# [checkmk_server](https://galaxy.ansible.com/kso512/checkmk_server)

[![Ansible role quality](https://img.shields.io/ansible/quality/56139)](https://galaxy.ansible.com/kso512/checkmk_server) [![Ansible role downloads](https://img.shields.io/ansible/role/d/56139)](https://galaxy.ansible.com/kso512/checkmk_server) [![GitHub repo size](https://img.shields.io/github/repo-size/kso512/checkmk_server)](https://github.com/kso512/checkmk_server)

[![CI](https://github.com/kso512/checkmk_server/actions/workflows/ci.yml/badge.svg)](https://github.com/kso512/checkmk_server/actions/workflows/ci.yml) [![Release](https://github.com/kso512/checkmk_server/actions/workflows/release.yml/badge.svg)](https://github.com/kso512/checkmk_server/actions/workflows/release.yml) [![GitHub issues](https://img.shields.io/github/issues-raw/kso512/checkmk_server)](https://github.com/kso512/checkmk_server)

[![made-with-bash](https://img.shields.io/badge/Made%20with-Bash-1f425f.svg)](https://www.gnu.org/software/bash/) [![made-with-Markdown](https://img.shields.io/badge/Made%20with-Markdown-1f425f.svg)](http://commonmark.org) [![GitHub](https://img.shields.io/github/license/kso512/checkmk_server)](https://www.gnu.org/licenses/gpl-2.0.txt)

An [Ansible](https://www.ansible.com/) [Role](https://docs.ansible.com/ansible/latest/user_guide/playbooks_reuse_roles.html) to install [CheckMK RAW edition](https://checkmk.com/product/raw-edition) and set up an initial site.

This is a complete rebuild of the [install-check_mk-server](https://github.com/kso512/install-check_mk-server) role I created and maintained for years, undertaken due to changes in CI/CD and naming conventions in Ansible Galaxy & CheckMK.

All tasks are tagged with `checkmk-server`.

**I do NOT recommend the default configuration for unprotected connection directly to the Internet, as the server configuration includes un-encrypted HTTP access.**

The following distributions have been tested automatically and continuously integrated:

- [Debian 9 "Stretch"](https://www.debian.org/releases/stretch/)
- [Debian 10 "Buster"](https://www.debian.org/releases/buster/)
- [Debian 11 "Bullseye"](https://www.debian.org/releases/bullseye/)
- [Ubuntu 18.04 LTS "Bionic Beaver"](http://releases.ubuntu.com/bionic/)
- [Ubuntu 20.04 LTS "Focal Fossa"](http://releases.ubuntu.com/focal/)

...using the following technologies:

- [Molecule playbook testing](https://github.com/geerlingguy/molecule-playbook-testing) by [@geerlingguy](https://github.com/geerlingguy)
- [GitHub Actions](https://github.com/features/actions)
- [docker-systemctl-replacement](https://github.com/gdraheim/docker-systemctl-replacement) by [@gdraheim](https://github.com/gdraheim)

## Version Matrix

| CheckMK Raw Edition Version | Role Version |
| --------------------------- | ------------ |
| 2.0.0p20 | 1.0.13 |
| 2.0.0p19 | 1.0.12 |
| 2.0.0p18 | 1.0.11 |
| 2.0.0p17 | 1.0.10 |
| 2.0.0p16 | 1.0.9  |
| 2.0.0p15 | 1.0.8  |
| 2.0.0p14 | 1.0.7  |
| 2.0.0p13 | 1.0.6  |
| 2.0.0p12 | 1.0.5  |
| 2.0.0p11 | 1.0.4  |
| 2.0.0p10 | [skipped](https://forum.checkmk.com/t/release-checkmk-stable-release-2-0-0p10/27023) |
| 2.0.0p9  | 1.0.0 - 1.0.3 |

## Requirements

If the server has a firewall enabled, it may need to be altered to allow incoming packets on TCP port 80 for the web portal access, and/or TCP port 514, plus UDP ports 162 & 514 for event console input.

As with any modern Linux deployment, SELinux may come into play.

To fulfill these requirements, I recommend using another Ansible Role.

## Role Variables

Some of these may be seem redundant but are specified so future users can override them with local variables as needed.

For reference, "OMD" below stands for the [Open Monitoring Distribution](https://checkmk.com/guides/open-monitoring-distribution) which is a predecessor of CheckMK RAW edition.  Those "omd" commands were left in for backwards compatibility.

### Table of Variables Common to All Distributions (with Defaults)

| Variable | Description | Default |
| -------- | ----------- | ------- |
| checkmk_server_adminpw | Password for the `cmkadmin` user created for the test site; if left blank, the password for this user can be found in the `checkmk_server_log_dest` file created on the remote instance | undefined |
| checkmk_server_base_url | Base URL that other URLs are based on | `https://download.checkmk.com/checkmk` |
| checkmk_server_cache_valid_time | Update the apt cache if it is older than this time, in seconds. | `3600` |
| checkmk_server_download | Filename of the source installation package | `check-mk-raw-{{ checkmk_server_version }}_0.{{ ansible_distribution_release }}_amd64.deb` |
| checkmk_server_download_dest | Final full path of the source installation package | `{{ checkmk_server_download_dest_folder }}/{{ checkmk_server_download }}` |
| checkmk_server_download_dest_folder | Destination folder of the source installation package | `/opt` |
| checkmk_server_download_mode | File mode settings of the source installation package | `0755` |
| checkmk_server_download_url | URL of the source installation package to download | `{{ checkmk_server_base_url }}/{{ checkmk_server_version }}/{{ checkmk_server_source }}` |
| checkmk_server_htpasswd_group | Name of the group that should own the htpasswd file, as would be fed to chown | `{{ checkmk_server_site }}` |
| checkmk_server_htpasswd_mode | File mode settings of the htpasswd file | `0660` |
| checkmk_server_htpasswd_name | Name of the user that will have their password set, if `checkmk_server_adminpw` is set | `cmkadmin` |
| checkmk_server_htpasswd_owner | Name of the user that should own the htpasswd file, as would be fed to chown | `{{ checkmk_server_site }}` |
| checkmk_server_htpasswd_path | Final full path of the htpasswd file | `/opt/omd/sites/{{ checkmk_server_site }}/etc/htpasswd` |
| checkmk_server_install_package | Final full path of the installation package | `{{ checkmk_server_download_dest }}` |
| checkmk_server_key_url | URL of the public key for CheckMK | `{{ checkmk_server_base_url }}/Check_MK-pubkey.gpg` |
| checkmk_server_log_dest | Final full path of the OMD create log, which captures the cmkadmin password if `checkmk_server_adminpw` is not set | `/opt/omd/sites/{{ checkmk_server_site }}/omd-create.log` |
| checkmk_server_log_group | Name of the group that should own the OMD create log, as would be fed to chown | `{{ checkmk_server_site }}` |
| checkmk_server_log_mode | File mode settings of the OMD create log | `0600` |
| checkmk_server_log_owner | Name of the user that should own the OMD create log, as would be fed to chown | `{{ checkmk_server_site }}` |
| checkmk_server_man_mode | File mode settings of the required man folder | `0755` |
| checkmk_server_man_path | Final full path of the required man folder | `/usr/share/man/man8` |
| checkmk_server_omd_create_command | Command used to create a new OMD site | `omd create {{ checkmk_server_site }}` |
| checkmk_server_omd_create_creates | File created by creating a new OMD site | `/opt/omd/sites/{{ checkmk_server_site }}` |
| checkmk_server_omd_setup_command | Command used to set up OMD | `omd setup` |
| checkmk_server_omd_setup_creates | Folder created by setting up OMD | `/opt/omd` |
| checkmk_server_omd_start_command | Command used to start OMD | `omd start {{ checkmk_server_site }}` |
| checkmk_server_omd_start_creates | File created by starting OMD | `/opt/omd/sites/{{ checkmk_server_site }}/tmp/apache/run/apache.pid` |
| checkmk_server_site | Name of OMD "site" to create; this is often shown as `my-site` in the CheckMK documentation examples | `test` |
| checkmk_server_version | Version of CheckMK RAW edition to install | `2.0.0p20` |
| checkmk_server_web_service | Name of the web service to start and enable | `apache2` |

### Tables of Variables Unique to at Least One Distribution (with Defaults)

To enable multi-distro support, the role defines distro-specific variables with the [`include_vars` and `with_first_found`](https://docs.ansible.com/ansible/latest/collections/ansible/builtin/include_vars_module.html) mechanisms.

#### checkmk_server_download_checksum

Description: SHA256 checksum of the source installation package

| Distribution | Default |
| ------------ | ------- |
| Debian 9 | `sha256:c2532e015222b2888e1f6c54d1f5e2d6ee5fa7f1bb9104c2d3fec7d87fae77bc` |
| Debian 10 | `sha256:c4285c98eb63dea728b8ce86ac71dd11fa3ae4df129331692a52bff3f8250026` |
| Debian 11 | `sha256:cb4daf0a329dac46ba7233ba1aebf9fd332ba303aa26b4d732015030353cc299` |
| Ubuntu 18.04 | `sha256:ac0559f8a7d69cff050db3cbacf573293a486d5860ad771b3b26bc7a056dbc11` |
| Ubuntu 20.04 | `sha256:6a4b5176fbf21cfc62320744969e2c72b3a641dcf1627a9c3c0c1b65d748cd45` |

#### checkmk_server_prerequisites

Description: Packages needed before installing CheckMK RAW edition

| Distribution | Default |
| ------------ | ------- |
| Debian 9 | `python-apt` `python-passlib` |
| Debian 10 | `python3-apt` `python3-passlib` |
| Debian 11 | `python3-apt` `python3-passlib` |
| Ubuntu 18.04 | `python3-apt` `python3-passlib` |
| Ubuntu 20.04 | `python3-apt` `python3-passlib` |

## Dependencies

None yet defined.

## Example Playbook

Example that enforces a specific password for the `cmkadmin` user:

    - hosts: monitoring-servers
      roles:
         - { role: kso512.checkmk_server, checkmk_server_adminpw: "wintermute" }

## License

[GNU General Public License version 2](https://www.gnu.org/licenses/gpl-2.0.txt)

## Author Information

[@kso512](https://github.com/kso512) with contributions to the original "install-check_mk-server" code from these helpful Github users:

- [@sylekta](https://github.com/sylekta)
- [@timorunge](https://github.com/timorunge)
- [@judouk](https://github.com/judouk)
- [@JWhy](https://github.com/JWhy)
