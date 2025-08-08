#!/usr/bin/env bash

# List of supported distros
distros=( debian11 debian12 ubuntu2204 ubuntu2404 )

# Fail upon any error
set -e

# Figure out the last folder in our current path
current_folder=$(pwd | rev | cut -d"/" -f1 | rev)

# Move to the main role folder if we are in the test folder
if [ $current_folder == "test" ]; then
  cd ..
fi

# Loop through the list of distros
for distro in ${distros[@]}; do
  # Run the docker container, which outputs the unique id of the container
  echo "--- Running container for distro: $distro"
  container=$(docker run --detach --privileged \
    --volume=/sys/fs/cgroup:/sys/fs/cgroup:rw --cgroupns=host \
    --volume=$(pwd):/etc/ansible/roles/role_under_test:ro \
    geerlingguy/docker-$distro-ansible:latest)
  # Execute the ansible playbook under test
  echo "--- Testing role in distro: $distro"
  docker exec --tty $container env TERM=xterm ansible-playbook \
    /etc/ansible/roles/role_under_test/test/test.yml
  # Remove the container once the test passes
  echo "--- Removing container for distro: $distro"
  docker rm -f $container
  done

# Finish clean
exit 0
