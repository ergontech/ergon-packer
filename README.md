# Packer

## Table of Contents
  - [Dependencies](#dependencies)
  - [Installation](#installation)
  - [Usage](#usage)
  - Vendor workflow
    - [Adding Packer to your project](docs/vendor.md#adding-packer-to-your-project)
    - [Pulling changes downstream](docs/vendor.md#pulling-changes-downstream)
    - [Pushing changes upstream](docs/vendor.md#passing-changes-upstream)
  - Debugging Issues

## TODO
* Create scripts for amazon and virtualbox
* Create script to upload to VagrantCloud or EC2
* Document scripts

## Dependencies
This README is written for Mac OSX and `homebrew`, using the `brew` command.

Install `homebrew` with:
```
ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
```

## Installation
```
$ brew cask install \
    vagrant \
    virtualbox

$ brew install \
    awscli \
    direnv \
    packer
```

## Usage
TODO

## Debugging Issues
Packer will automatically destroy instances when provisioning fails. To prevent
your instance from being destroyed use `-on-error=ask` in the packer command at
the end of either `build_amazon.sh` or `build_virtualbox.sh`.

```
$ tail -n10 build_amazon.sh
packer build -force \
    -on-error=ask \
    -var "ansible_environment=${env}" \
    -var "ansible_groups=${groups}" \
    -var "ansible_playbook=../ansible/${playbook}.yml" \
    -var "revision=${revision}" \
    -var "ssh_bastion_host=${bastion}" \
    -var "subnet_id=${subnet}" \
    -var "vpc_id=${vpc}" \
    amazon.json
```
