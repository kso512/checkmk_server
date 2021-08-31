# [checkmk_server](https://galaxy.ansible.com/kso512/checkmk_server)

[![Ansible role quality](https://img.shields.io/ansible/quality/56129)](https://galaxy.ansible.com/kso512/checkmk_server) [![Ansible role downloads](https://img.shields.io/ansible/role/d/56129)](https://galaxy.ansible.com/kso512/checkmk_server)

[![made-with-bash](https://img.shields.io/badge/Made%20with-Bash-1f425f.svg)](https://www.gnu.org/software/bash/) [![made-with-Markdown](https://img.shields.io/badge/Made%20with-Markdown-1f425f.svg)](http://commonmark.org) [![GitHub](https://img.shields.io/github/license/kso512/checkmk_server)](https://www.gnu.org/licenses/gpl-2.0.txt)

[![GitHub repo size](https://img.shields.io/github/repo-size/kso512/checkmk_server)](https://github.com/kso512/checkmk_server) [![GitHub issues](https://img.shields.io/github/issues-raw/kso512/checkmk_server)](https://github.com/kso512/checkmk_server)

An [Ansible](https://www.ansible.com/) [Role](https://docs.ansible.com/ansible/latest/user_guide/playbooks_reuse_roles.html) to install [CheckMK RAW edition](https://checkmk.com/product/raw-edition) and set up an initial site.

This is a complete rebuild of the [install-check_mk-server](https://github.com/kso512/install-check_mk-server) role I created and maintained for years, undertaken due to changes in CI/CD and naming conventions in Ansible Galaxy & CheckMK.

All tasks are tagged with `checkmk-server`.

**I do NOT recommend the default configuration for unprotected connection directly to the Internet, as the server configuration includes un-encrypted HTTP access.**

The following distributions have been tested automatically and continuously integrated:

- [Debian 10 "Buster"](https://www.debian.org/releases/buster/)
- [Ubuntu 18.04 LTS "Bionic Beaver"](http://releases.ubuntu.com/bionic/)

...using the following technologies:

- [Molecule playbook testing](https://github.com/geerlingguy/molecule-playbook-testing) by [@geerlingguy](https://github.com/geerlingguy)
- [GitHub Actions](https://github.com/features/actions)
- [docker-systemctl-replacement](https://github.com/gdraheim/docker-systemctl-replacement) by [@gdraheim](https://github.com/gdraheim)

## Requirements

The below requirements are needed on the host that executes this module.

- [python3-apt](https://docs.ansible.com/ansible/latest/collections/ansible/builtin/apt_module.html#requirements)

If the server has a firewall enabled, it may need to be altered to allow incoming packets on TCP port 80 for the web portal access, and/or TCP port 514, plus UDP ports 162 & 514 for event console input.

As with any modern Linux deployment, SELinux may come into play.

To fulfill these requirements, I recommend using another Ansible Role.

## Role Variables

To enable multi-distro support, the role defines distro-specific variables with the [`include_vars` and `with_first_found`](https://docs.ansible.com/ansible/latest/collections/ansible/builtin/include_vars_module.html) mechanisms.

Some of these may be seem redundant but are specified so future users can override them with local variables as needed.

For reference, "OMD" below stands for the [Open Monitoring Distribution](https://checkmk.com/guides/open-monitoring-distribution) which is a predecessor of CheckMK RAW edition.  Those "omd" commands were left in for backwards compatibility.

### Table of variables with defaults

| Variable | Description | Default |
| -------- | ----------- | ------- |
| checkmk_server_adminpw | Password for the `cmkadmin` user created for the test site; if left blank, the password for this user can be found in the `checkmk_server_log_dest` file created on the remote instance | undefined |
| checkmk_server_base_url | Base URL that other URLs are based on | `https://download.checkmk.com/checkmk` |
| checkmk_server_cache_valid_time | Update the apt cache if it is older than this time, in seconds. | `3600` |
| checkmk_server_download | Filename of the source installation package | `check-mk-raw-{{ checkmk_server_version }}_0.{{ ansible_distribution_release }}_amd64.deb` |
| checkmk_server_download_checksum | SHA256 checksum of the source installation package | `sha256:aedd9b72aea27b8ceb27a2d25c2606c0a2642146689108af51f514c42ba293cd` |
| checkmk_server_download_dest | Final full path of the source installation package | `{{ checkmk_server_download_dest_folder }}/{{ checkmk_server_download }}` |
| checkmk_server_download_dest_folder | Destination folder of the source installation package | `/opt` |
| checkmk_server_download_mode | File mode settings of the source installation package | `0755` |
| checkmk_server_download_url | URL of the source installation package to download | `{{ checkmk_server_base_url }}/{{ checkmk_server_version }}/{{ checkmk_server_source }}` |
| checkmk_server_htpasswd_group | Name of the group that should own the htpasswd file, as would be fed to chown | `{{ checkmk_server_site }}` |
| checkmk_server_htpasswd_mode | File mode settings of the htpasswd file | `0660` |
| checkmk_server_htpasswd_name | Name of the user that will have their password set, if `checkmk_server_adminpw` is set | `cmkadmin` |
| checkmk_server_htpasswd_owner | Name of the user that should own the htpasswd file, as would be fed to chown | `{{ checkmk_server_site }}` |
| checkmk_server_htpasswd_path | Final full path of the htpasswd file | `/opt/omd/sites/{{ checkmk_server_site }}/etc/htpasswd` |
| checkmk_server_install_deb | Final full path of the installation package | `{{ checkmk_server_download_dest }}` |
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
| checkmk_server_prerequisites | Package needed before installing CheckMK RAW edition | `python3-passlib` |
| checkmk_server_site | Name of OMD "site" to create; this is often shown as `my-site` in the CheckMK documentation examples | `test` |
| checkmk_server_systemctl_dest | File name to replace with the docker-systemctl-replacement script | `/usr/bin/systemctl` |
| checkmk_server_systemctl_mode | File mode settings of the docker-systemctl-replacement script | `0755` |
| checkmk_server_systemctl_url | URL of the docker-systemctl-replacement script | `https://github.com/gdraheim/docker-systemctl-replacement/raw/master/files/docker/systemctl.py` |
| checkmk_server_version | Version of CheckMK RAW edition to install | `2.0.0p9` |
| checkmk_server_web_service | Name of the web service to start and enable | `apache2` |

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
