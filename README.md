# Packer

## Table of Contents
  - [Dependencies](#dependencies)
  - [Installation](#installation)
  - [Usage](#usage)
  - Vendor workflow
    - [Adding Packer to your project](docs/vendor.md#adding-packer-to-your-project)
    - [Pulling changes downstream](docs/vendor.md#pulling-changes-downstream)
    - [Pushing changes upstream](docs/vendor.md#passing-changes-upstream)

## TODO
* Create scripts for amazon and virtualbox
* Create script to upload to VagrantCloud or EC2
* Document scripts
* Document workflow for vendor process

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
