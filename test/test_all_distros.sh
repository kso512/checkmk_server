#!/usr/bin/env bash

# List of supported distros
distros=( debian11 debian12 ubuntu2204 ubuntu2404 )

# Fail upon any error
set -e

# Loop through the list of distros
for distro in ${distros[@]}; do

  # Run the docker container, which outputs the unique id of the container
  echo "--- Running container for distro: $distro"
  container=$(docker run --detach --privileged \
    --volume=/sys/fs/cgroup:/sys/fs/cgroup:rw --cgroupns=host \
    --volume=$(pwd):/etc/ansible/roles/role_under_test:ro \
    geerlingguy/docker-$distro-ansible:latest)

  # Execute the ansible playbook under test
  echo "--- Testing playability of role in distro: $distro"
  docker exec --tty $container env TERM=xterm \
    ansible-playbook /etc/ansible/roles/role_under_test/test/test.yml

  # Make sure a site exists
  echo "--- Testing for CheckMK Raw Edition default site in distro: $distro"
  omd_sites=$(docker exec --tty $container env TERM=xterm omd sites)
  echo "${omd_sites}" | grep "\w*\s*\w*\.\w*\.\w*\.cre\s*default version"

  # Make sure a site is running
  echo "--- Testing for running status of CheckMK site in distro: $distro"
  omd_status=$(docker exec --tty $container env TERM=xterm omd status)
  echo "${omd_status}" | grep "Overall state.*running"

  # Remove the container once the test passes
  echo "--- Removing container for distro: $distro"
  docker rm -f $container

  # End 'for distro' loop
  done

# Finish clean
exit 0
