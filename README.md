# checkmk_server

[![made-with-bash](https://img.shields.io/badge/Made%20with-Bash-1f425f.svg)](https://www.gnu.org/software/bash/) [![made-with-Markdown](https://img.shields.io/badge/Made%20with-Markdown-1f425f.svg)](http://commonmark.org) ![GitHub](https://img.shields.io/github/license/kso512/checkmk_server)

![GitHub repo size](https://img.shields.io/github/repo-size/kso512/checkmk_server) ![GitHub issues](https://img.shields.io/github/issues-raw/kso512/checkmk_server)

An [Ansible](https://www.ansible.com/) [Role](https://docs.ansible.com/ansible/latest/user_guide/playbooks_reuse_roles.html) to install [CheckMK RAW](https://checkmk.com/product/raw-edition) and set up an initial site.

This is a complete rebuild of the [install-check_mk-server](https://github.com/kso512/install-check_mk-server) role I created and maintained for years, undertaken due to changes in CI/CD and naming conventions in Ansible Galaxy & CheckMK.

## Requirements

If the server has a firewall enabled, it may need to be altered to allow incoming packets on TCP port 80 for the web portal access, and/or TCP port 514, plus UDP ports 162 & 514 for event console input.

As with any modern Linux deployment, SELinux may come into play.

To fulfill these requirements, I recommend using another Ansible Role.  For example, [this role from Jeff Geerling may be used to handle EPEL](https://galaxy.ansible.com/geerlingguy/repo-epel) if needed.

## Role Variables

None yet defined.

## Dependencies

None yet defined.

## Example Playbook

Simple example:

    - hosts: monitoring-servers
      roles:
         - { role: kso512.checkmk_server }

## License

[GNU General Public License version 2](https://www.gnu.org/licenses/gpl-2.0.txt)

## Author Information

Chris Lindbergh [@kso512](https://github.com/kso512) with contributions to the original "install-check_mk-server" code from these helpful Github users:

- [@sylekta](https://github.com/sylekta)
- [@timorunge](https://github.com/timorunge)
- [@judouk](https://github.com/judouk)
- [@JWhy](https://github.com/JWhy)
