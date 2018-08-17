#!/bin/bash

set -eo pipefail

function usage() {
    cat <<- EOF
usage: $0 [-n build name] [-g groups] [-p playbook]

    -g (groups)          the ansible groups a virtual machine should belong to
    -h (help)            show this help
    -n (build name)      the name of the virtual machine that will be created
    -p (playbook)        the ansible playbook to run during build process

    $0 -n client-dev-web-vm -g application,webserver -p provision.yml
EOF
}

while getopts "p:g:n:h" arg; do
    case "$arg" in
        g) groups=${OPTARG} ;;
        p) playbook=${OPTARG%".yml"} ;; # remove .yml if present
        n) name=${OPTARG} ;;
        h) usage && exit ;;
        *) echo "unknown option, check usage with -h" && exit 1;;
    esac
done

if [ -z "${name}" ] || [ -z "${groups}" ] || [ -z "${playbook}" ]
then
    echo "missing args, check usage with -h" && exit 1
fi

packer build -force \
    -var "build_name=${name}" \
    -var "ansible_environment=development" \
    -var "ansible_groups=${groups}" \
    -var "revision=master" \
    -var "ansible_playbook=../ansible/${playbook}.yml" \
    virtualbox.json
