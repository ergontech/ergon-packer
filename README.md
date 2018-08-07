# Packer

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

## Adding Packer to your project
```
$ ls packer/
ls: packer/: No such file or directory

$ git checkout -b feature/add-packer

$ git subtree add --prefix=packer --squash git://github.com/ergontech/ergon-packer.git master
git fetch git://github.com/ergontech/ergon-packer.git master
From git://github.com/ergontech/ergon-packer
 * branch            master     -> FETCH_HEAD
Added dir 'packer'

$ ls packer/
README.md        amazon.json      http/            scripts/       virtualbox.json
```

## Usage
