# checkmk_server

[![made-with-bash](https://img.shields.io/badge/Made%20with-Bash-1f425f.svg)](https://www.gnu.org/software/bash/) [![made-with-Markdown](https://img.shields.io/badge/Made%20with-Markdown-1f425f.svg)](http://commonmark.org) ![GitHub](https://img.shields.io/github/license/kso512/checkmk_server)

![GitHub repo size](https://img.shields.io/github/repo-size/kso512/checkmk_server) ![GitHub issues](https://img.shields.io/github/issues-raw/kso512/checkmk_server)

An [Ansible](https://www.ansible.com/) [Role](https://docs.ansible.com/ansible/latest/user_guide/playbooks_reuse_roles.html) to install [CheckMK RAW](https://checkmk.com/product/raw-edition) and set up an initial site.

This is a complete rebuild of the [install-check_mk-server](https://github.com/kso512/install-check_mk-server) role I created and maintained for years, undertaken due to changes in CI/CD and naming conventions in Ansible Galaxy & CheckMK.

All tasks are tagged with `checkmk-server`.

**I do NOT recommend the default configuration for unprotected connection directly to the Internet, as the server configuration includes un-encrypted HTTP access.**

Tested automatically and continuously integrated with [_Molecule playbook testing_ as instructed by Jeff Geerling](https://github.com/geerlingguy/molecule-playbook-testing) on the following distributions:

- [Ubuntu 18.04 LTS "Bionic Beaver"](http://releases.ubuntu.com/bionic/)

## Requirements

If the server has a firewall enabled, it may need to be altered to allow incoming packets on TCP port 80 for the web portal access, and/or TCP port 514, plus UDP ports 162 & 514 for event console input.

As with any modern Linux deployment, SELinux may come into play.

To fulfill these requirements, I recommend using another Ansible Role.  For example, [this role from Jeff Geerling may be used to handle EPEL](https://galaxy.ansible.com/geerlingguy/repo-epel) if needed.

## Role Variables

### Table of variables with defaults

| Variable | Description | Value |
| -------- | ----------- | ----- |
| checkmk_server_cache_valid_time | Number of seconds to consider the last apt cache update as valid | `3600` |
| checkmk_server_dest | Destination folder of the source installation package | `/opt` |
| checkmk_server_prerequisites | Package needed before installing CheckMK RAW | `dpkg-sig` |
| checkmk_server_source | Filename of the source installation package | `check-mk-raw-{{ checkmk_server_version }}_0.{{ ansible_distribution_release }}_amd64.deb` |
| checkmk_server_source_checksum | SHA256 checksum of the source installation package | `sha256:aedd9b72aea27b8ceb27a2d25c2606c0a2642146689108af51f514c42ba293cd` |
| checkmk_server_source_mode | File mode settings of the source installation package | `0755` |
| checkmk_server_source_url | URL of the source installation package to download | `https://download.checkmk.com/checkmk/{{ checkmk_server_version }}/{{ checkmk_server_source }}` |
| checkmk_server_version | Version of CheckMK RAW to install | `2.0.0p9` |

## Dependencies

None yet defined.

## Example Playbook

Example that enforces a specific version of CheckMK RAW:

    - hosts: monitoring-servers
      roles:
         - { role: kso512.checkmk_server, checkmk_server_version: "2.0.0p8" }

## License

[GNU General Public License version 2](https://www.gnu.org/licenses/gpl-2.0.txt)

## Author Information

[@kso512](https://github.com/kso512) with contributions to the original "install-check_mk-server" code from these helpful Github users:

- [@sylekta](https://github.com/sylekta)
- [@timorunge](https://github.com/timorunge)
- [@judouk](https://github.com/judouk)
- [@JWhy](https://github.com/JWhy)
