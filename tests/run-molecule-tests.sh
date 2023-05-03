#!/bin/bash

# Script to automate molecule tests

# List of distros to cover
DISTRO_LIST=(ubuntu1804 ubuntu2004 debian10 debian11)

# Help molecule link the path up correctly
export ANSIBLE_ROLES_PATH=../

# End script upon any failure
set -e

# Run molecule for each distro
for DISTRO in "${DISTRO_LIST[@]}"; do
  MOLECULE_DISTRO=$DISTRO molecule test
done

# Leave a big message when we're done
toilet -f big "ALL GOOD!"

# Exit cleanly
exit 0
