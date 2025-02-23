# System Dotfiles

[![Travis](https://img.shields.io/travis/com/musq/dotfiles-system.svg)](https://travis-ci.com/musq/dotfiles-system.svg?branch=master)
[![Version](https://img.shields.io/github/release/musq/dotfiles-system.svg)](https://img.shields.io/github/release/musq/dotfiles-system)
[![semantic-release](https://img.shields.io/badge/%20%20%F0%9F%93%A6%F0%9F%9A%80-semantic--release-e10079.svg)](https://github.com/semantic-release/semantic-release)
[![standard-readme compliant](https://img.shields.io/badge/readme%20style-standard-brightgreen.svg)](https://github.com/RichardLitt/standard-readme)


Set up a base environment on a new system as an administrator. It must
be run as a user who has `sudo` access.

Please **do not** run it as `root`.

---

**BEWARE** — This tool will use `sudo` to modify system files.
**Proceed with caution.**

**DO NOT** run the `setup.sh` script if you don't fully understand
[what it does](https://github.com/musq/dotfiles-system/blob/master/src/os/setup.sh).
Seriously, **DON'T**!

---

## Table of Contents

- [Background](#background)
- [Requirements](#requirements)
- [Pre-Install](#pre-install)
- [Install](#install)
  - [One-line installer](#one-line-installer)
  - [Manual](#manual)
  - [Update](#update)
  - [Non-Interactive](#non-interactive)
- [Screenshots](#screenshots)
- [Acknowledgements](#acknowledgements)
- [Contributing](#contributing)
- [License](#license)


## Background

Manually setting up a usable environment on a brand new server is
always a tiring experience. I felt the need to create a tool which
would automate this process as smoothly as possible. It should ideally —

- Perform hardening operations
- Install necessary tools
- Manage system configurations

It should also **follow these standards** —

- Bootstrap itself using only `wget` or `curl`
- Be idempotent
- Be easy to audit


## Requirements

This tool is only meant for Linux variants. It has been verified to
work on —

- Debian 9
- Ubuntu 16.04


## Pre-Install

If you do not have a user with `sudo` access, create it as follows:

```bash
# Login to root
sudo -i

# Update the default text editor, select your desire
update-alternatives --config editor

# Edit sudoers file and add the following line
visudo
# Allow members of group sudo-users to execute any command, passwordless
%sudo-users ALL=(ALL) NOPASSWD: ALL
```

Run the following commands to:

- Create a new user `boss`
- Add **your SSH public key** to `boss` — **must replace** my SSH public key below
- Add `boss` to `sudo-users` for passwordless sudo
- Unlock this user by deleting its password

```bash
# Initialize USER variables
USER="boss"
USERNAME="Boss"
SSH_DIR="/home/$USER/.ssh"
SSH_PUBLIC_KEY="ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIJK827/gzPAZQaNsLdtBz/WK6HHJaFL85pF+gsP41SDl ashish"

# Add user
useradd \
    --key UMASK=022 \
    --user-group \
    --create-home \
    --shell /bin/bash \
    --comment "$USER_NAME" \
    "$USER"

# Create sudo-users group
groupadd --system sudo-users

# Add your user to sudo-users
usermod \
    --append \
    --groups sudo-users \
    "$USER"

# Setup SSH access
mkdir -p "$SSH_DIR"
echo "$SSH_PUBLIC_KEY" >> "$SSH_DIR/authorized_keys"
chown -R "$USER":"$USER" "$SSH_DIR"

# Sometimes SSH access is prohibited because user is locked
# Unlock the user by deleting its password
passwd -d "$USER"
```

## Install

The setup process will:

- Download the dotfiles on your computer (by default it will suggest
`~/projects/dotfiles-system`)
- Take versioned backup of files that might be changed and store them
in `~/.backups/dotfiles-system-backup/v*`
- Symlink the `etc/ssh/?`, `/etc/git/?`, `/usr/local/bin/?` files and
scripts
- Create groups: `ssh-users`, `nix-users` and add current user to them
- Install [`Nix`](https://nixos.org/nix) and some necessary packages

### One-line installer


| Tool | Snippet |
|:---|:---|
| `wget` | `bash -c "$(wget -qO - https://raw.githubusercontent.com/musq/dotfiles-system/master/src/os/setup.sh)"` |
| `cURL` | `bash -c "$(curl -LsS https://raw.githubusercontent.com/musq/dotfiles-system/master/src/os/setup.sh)"` |


### Manual

```bash
# Clone this repo
git clone https://github.com/musq/dotfiles-system.git

# Go inside
cd dotfiles-system

# Run installer
./src/os/setup.sh
```

### Update

```bash
# Go inside the project repo
cd path/to/dotfiles-system

# Update git repo
git pull origin master

# Run installer
./src/os/setup.sh
```

### Non-Interactive

Pass `-y` or `--yes` to automatically answer yes to all the questions.

| Tool | Snippet |
|:---|:---|
| `Manual` | `./src/os/setup.sh -y` |
| `wget` | `bash -c "$(wget -qO - https://raw.githubusercontent.com/musq/dotfiles-system/master/src/os/setup.sh) -y"` |
| `cURL` | `bash -c "$(curl -LsS https://raw.githubusercontent.com/musq/dotfiles-system/master/src/os/setup.sh) -y"` |


## Screenshots

<img
    src="https://raw.githubusercontent.com/musq/assets/master/dotfiles-system/install.gif"
    alt="Setup process in action"
    width="100%">


## Acknowledgements

Inspiration and code were taken from many sources, including:

- [Ashish's dotfiles](https://github.com/musq/dotfiles)
- [Cătălin's dotfiles](https://github.com/alrra/dotfiles)
- [Mathias Bynens' dotfiles](https://github.com/mathiasbynens/dotfiles)


## Contributing

Feel free to dive in!
[Open an issue](https://github.com/musq/dotfiles-system/issues/new)
or submit PRs.

See [contributing guidelines](CONTRIBUTING.md).


## License

- The code is available under [GNU GPL v3, or later](LICENSE) license
- Parts from the [original base](https://github.com/alrra/dotfiles) are
still available under MIT license
