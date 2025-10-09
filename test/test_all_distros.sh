#!/usr/bin/env bash

# List of supported distros
distros=( debian11 debian12 )
distros+=( ubuntu2204 ubuntu2404 )

# Fail upon any error
set -e

# Loop through the list of distros
for distro in ${distros[@]}; do

  # Run the docker container, which outputs the unique id of the container
  echo ""
  echo "=00= Running container for distro: ${distro}"
  container=$(docker run --detach --privileged \
    --volume=/sys/fs/cgroup:/sys/fs/cgroup:rw --cgroupns=host \
    --volume=$(pwd):/etc/ansible/roles/role_under_test:ro \
    "geerlingguy/docker-${distro}-ansible:latest")

  # Run the ansible playbook and look for no failures
  echo "-01- Testing playbook for no failures in distro: ${distro}"
  ansible_output=$(docker exec --tty "${container}" env TERM=xterm \
    ansible-playbook /etc/ansible/roles/role_under_test/test/playbook.yml)
  echo "${ansible_output}" | \
    grep -o "failed=0"

  # Run the ansible playbook again and look for idempotence
  echo "-02- Testing playbook for no changes (idempotence) in distro: ${distro}"
  ansible_output=$(docker exec --tty "${container}" env TERM=xterm \
    ansible-playbook /etc/ansible/roles/role_under_test/test/playbook.yml)
  echo "${ansible_output}" | \
    grep -o "changed=0"

  # Make sure a site exists
  echo "-03- Testing for CheckMK Raw Edition default site in distro: ${distro}"
  omd_sites=$(docker exec --tty "${container}" env TERM=xterm \
    omd sites)
  echo "${omd_sites}" | \
    grep "\w*\s*\w*\.\w*\.\w*\.cre\s*default version"

  # Make sure a site is running
  echo "-04- Testing for running status of CheckMK site in distro: ${distro}"
  # Use --bare flag to use the script-friendly mode with no colors
  omd_status=$(docker exec --tty "${container}" env TERM=xterm \
    omd status --bare)
  echo "${omd_status}" | \
    grep "OVERALL 0"

  # Remove the container once the test passes
  echo "-05- Removing container for distro after successful tests: ${distro}"
  docker rm -f "${container}"

  # End 'for distro' loop
  done

# Finish clean
exit 0
