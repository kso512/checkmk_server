# [checkmk_server](https://galaxy.ansible.com/ui/standalone/roles/kso512/checkmk_server/)

[![Release](https://github.com/kso512/checkmk_server/actions/workflows/release.yml/badge.svg)](https://github.com/kso512/checkmk_server/actions/workflows/release.yml) [![GitHub issues](https://img.shields.io/github/issues-raw/kso512/checkmk_server)](https://github.com/kso512/checkmk_server) [![GitHub repo size](https://img.shields.io/github/repo-size/kso512/checkmk_server)](https://github.com/kso512/checkmk_server)

[![made-with-Markdown](https://img.shields.io/badge/Made%20with-Markdown-1f425f.svg)](http://commonmark.org) [![GitHub](https://img.shields.io/github/license/kso512/checkmk_server)](https://www.gnu.org/licenses/gpl-2.0.txt)

An [Ansible](https://www.ansible.com/) [Role](https://docs.ansible.com/ansible/latest/user_guide/playbooks_reuse_roles.html) to install [CheckMK RAW edition](https://checkmk.com/product/raw-edition) and set up an initial site.

This is a complete rebuild of the [install-check_mk-server](https://github.com/kso512/install-check_mk-server) role I created and maintained for years, undertaken due to changes in CI/CD and naming conventions in Ansible Galaxy & CheckMK.

All tasks are tagged with `checkmk-server`.

**I do NOT recommend the default configuration for unprotected connection directly to the Internet, as the server configuration includes un-encrypted HTTP access.**

The following distributions have been tested automatically:

- [Debian 10 "Buster"](https://www.debian.org/releases/buster/)
- [Debian 11 "Bullseye"](https://www.debian.org/releases/bullseye/)
- [Debian 12 "Bookworm"](https://www.debian.org/releases/bookworm/)
- [Ubuntu 20.04 LTS "Focal Fossa"](http://releases.ubuntu.com/focal/)
- [Ubuntu 22.04 LTS "Jammy Jellyfish"](http://releases.ubuntu.com/jammy/)
- [Ubuntu 24.04 LTS "Noble Numbat"](http://releases.ubuntu.com/noble/)

For reference, "OMD" below stands for the [Open Monitoring Distribution](https://checkmk.com/guides/open-monitoring-distribution) which is a predecessor of CheckMK RAW edition.  Those "omd" commands were left in for backwards compatibility.

## Recent Version Matrix

| CheckMK Raw Edition Version | Role Version/Tag |
| --------------------------- | ---------------- |
| 2.3.0p18                    | 1.0.93           |
| 2.3.0p17                    | 1.0.92           |
| 2.3.0p16                    | 1.0.91           |
| 2.3.0p15                    | 1.0.90           |
| 2.3.0p14                    | 1.0.89           |

## Requirements

If the server has a firewall enabled, it may need to be altered to allow incoming packets on TCP port 80 for the web portal access, and/or TCP port 514, plus UDP ports 162 & 514 for event console (syslog) input.

As with any modern Linux deployment, SELinux may come into play.

To fulfill these requirements, I recommend using another Ansible Role.

## Upkeep (updates and out-dated versions)

While this role does install the latest stable version of CheckMK, it does not apply any update commands to existing deployments.  This is to avoid clobbering production sites and allow for oversight during upgrades.

These steps may be followed to enact an upgrade on a site named "test" after running a newer update of this role; change "test" to the name of the site you want to upgrade:

1. Become the "test" user: `sudo omd su test`
1. Stop the "test" site: `omd stop`
1. Update the "test" site; to complete this step you need to interact with the text interface as well: `omd update`
1. Start the "test" site: `omd start`

If you have many sites to upgrade, the following one-liner may help.  Just change the `site` variable declaration as needed:

    site=test ; sudo omd stop $site ; sudo omd update $site ; sudo omd start $site

For the brave, the `omd` command does allow for fully-automated upgrades, which can then be executed via ansible like so (for a given group `hq-cmk` in the `testing.ini` inventory, a site named `test`, and upgrading to version `2.2.0p12` in this example):

    ansible hq-cmk -b -i testing.ini -m shell -a "site=test ; omd stop $site ; omd -f -V 2.2.0p12.cre update --conflict=install $site ; omd start $site" -vvvv

In the same manner, older versions are left on the systems by this role and it is up to the administrator to remove unneeded versions.  Use this command to remove all unneeded CheckMK versions: `sudo omd cleanup`

## Role Variables

Some of these may be seem redundant but are specified so future users can override them with local variables as needed.

### Table of Variables Common to All Distributions (with Defaults)

| Variable | Description | Default |
| -------- | ----------- | ------- |
| checkmk_server_adminpw | Password for the `cmkadmin` user created for the test site; if left blank, the password for this user can be found in the `checkmk_server_log_dest` file created on the remote instance | undefined |
| checkmk_server_base_url | Base URL that other URLs are based on | `https://download.checkmk.com/checkmk` |
| checkmk_server_cache_valid_time | Update the apt cache if it is older than this time, in seconds. | `3600` |
| checkmk_server_download | Filename of the source installation package | `check-mk-raw-{{ checkmk_server_version }}_0.{{ ansible_distribution_release }}_amd64.deb` |
| checkmk_server_download_dest | Final full path of the source installation package | `"{{ checkmk_server_download_dest_folder }}/{{ checkmk_server_download }}"` |
| checkmk_server_download_dest_folder | Destination folder of the source installation package | `/opt` |
| checkmk_server_download_mode | File mode settings of the source installation package | `0755` |
| checkmk_server_download_url | URL of the source installation package to download | `"{{ checkmk_server_base_url }}/{{ checkmk_server_version }}/{{ checkmk_server_source }}"` |
| checkmk_server_htpasswd_group | Name of the group that should own the htpasswd file, as would be fed to chown | `"{{ checkmk_server_site }}"` |
| checkmk_server_htpasswd_mode | File mode settings of the htpasswd file | `0660` |
| checkmk_server_htpasswd_name | Name of the user that will have their password set, if `checkmk_server_adminpw` is set | `cmkadmin` |
| checkmk_server_htpasswd_owner | Name of the user that should own the htpasswd file, as would be fed to chown | `"{{ checkmk_server_site }}"` |
| checkmk_server_htpasswd_path | Final full path of the htpasswd file | `/opt/omd/sites/{{ checkmk_server_site }}/etc/htpasswd` |
| checkmk_server_install_package | Final full path of the installation package | `"{{ checkmk_server_download_dest }}"` |
| checkmk_server_key_url | URL of the public key for CheckMK | `"{{ checkmk_server_base_url }}/Check_MK-pubkey.gpg"` |
| checkmk_server_log_dest | Final full path of the OMD create log, which captures the cmkadmin password if `checkmk_server_adminpw` is not set | `/opt/omd/sites/{{ checkmk_server_site }}/omd-create.log` |
| checkmk_server_log_group | Name of the group that should own the OMD create log, as would be fed to chown | `"{{ checkmk_server_site }}"` |
| checkmk_server_log_mode | File mode settings of the OMD create log | `0600` |
| checkmk_server_log_owner | Name of the user that should own the OMD create log, as would be fed to chown | `"{{ checkmk_server_site }}"` |
| checkmk_server_man_mode | File mode settings of the required man folder | `0755` |
| checkmk_server_man_path | Final full path of the required man folder | `/usr/share/man/man8` |
| checkmk_server_omd_create_command | Command used to create a new OMD site | `omd create {{ checkmk_server_site }}` |
| checkmk_server_omd_create_creates | File created by creating a new OMD site | `/opt/omd/sites/{{ checkmk_server_site }}` |
| checkmk_server_omd_setup_command | Command used to set up OMD | `omd setup` |
| checkmk_server_omd_setup_creates | Folder created by setting up OMD | `/opt/omd` |
| checkmk_server_omd_start_command | Command used to start OMD | `omd start {{ checkmk_server_site }}` |
| checkmk_server_omd_start_creates | File created by starting OMD | `/opt/omd/sites/{{ checkmk_server_site }}/tmp/apache/run/apache.pid` |
| checkmk_server_prerequisites | Packages needed before installing CheckMK RAW edition | `python3-apt` `python3-passlib` |
| checkmk_server_site | Name of OMD "site" to create; this is often shown as `my-site` in the CheckMK documentation examples | `test` |
| checkmk_server_version | Version of CheckMK RAW edition to install | `2.3.0p18` |
| checkmk_server_web_service | Name of the web service to start and enable | `apache2` |

### Tables of Variables Unique to at Least One Distribution (with Defaults)

To enable multi-distro support, the role defines distro-specific variables with the [`include_vars` and `with_first_found`](https://docs.ansible.com/ansible/latest/collections/ansible/builtin/include_vars_module.html) mechanisms.

#### checkmk_server_download_checksum

Description: SHA256 checksum of the source installation package

| Distribution | Default |
| ------------ | ------- |
| Debian 10    | `sha256:1e85463d663ef27370b016cfaf70960192daf46f73d3c62b4832d8cba01af506` |
| Debian 11    | `sha256:a0db4b3d08eb4f8d5c007c99a2e7d088c24fc6942157814a2ce3fc5a73dc64f2` |
| Debian 12    | `sha256:224ea6ecaa2e4fa0a49ac4ce95bd29dcbe23f665fff65058fd1da22ff602406b` |
| Ubuntu 20.04 | `sha256:4f3af2965a7220741ccd962ee2a190a092705049af9fcf7a6c8eb55aaefe56b6` |
| Ubuntu 22.04 | `sha256:81e03d96b01bda98a8ffc6630ecdb19a4f3a1853809f55c3b65403becccc1a07` |
| Ubuntu 24.04 | `sha256:1941fd3a4897cd6f23a53022f16e9848505be8c68748979154e1c4e60006091f` |

## Dependencies

None yet defined.

## Example Playbook

Example that enforces a specific password for the `cmkadmin` user:

    - hosts: monitoring-servers
      roles:
         - { role: kso512.checkmk_server, checkmk_server_adminpw: "wintermute" }

## License

[GNU General Public License version 2](https://www.gnu.org/licenses/gpl-2.0.txt)

## Contributing

If you have any suggestions or ideas, please feel free to open an issue, or fork the repository and submit an merge request.

## Author Information

[@kso512](https://github.com/kso512) with contributions to the original "install-check_mk-server" code from these helpful Github users:

- [@sylekta](https://github.com/sylekta)
- [@timorunge](https://github.com/timorunge)
- [@judouk](https://github.com/judouk)
- [@JWhy](https://github.com/JWhy)
