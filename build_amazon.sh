#!/bin/bash

set -eo pipefail

function usage() {
    cat <<- EOF
usage: $0 [-e environment] [-g groups] [-v vpc_id] [-s subnet_id] [-p playbook] [-r revision] [-b bastion]

    -b (bastion)        the ssh bastion host needed to tunnel into a VPC
    -e (environment)    the ansible environment to apply as a role
    -g (groups)         the ansible groups an AMI will belong to
    -h (help)           show this help
    -p (playbook)       the ansible playbook to run during build process
    -r (revision)       the revision that will be baked into an AMI
    -s (subnet id)      the id of the private subnet that the AMI will be created on
    -v (vpc id)         the id of the private vpc that the AMI will be created in

    $0 -b ssh.client.ergon.io -e review -g application,webserver -p packer.yml -r master -s subnet-e9a5ceb2 -v vpc-248eae5d
EOF
}

while getopts "e:r:b:s:p:g:v:h" arg; do
    case "$arg" in
        b) bastion=${OPTARG} ;;
        e) env=${OPTARG} ;;
        g) groups=${OPTARG} ;;
        h) usage && exit ;;
        p) playbook=${OPTARG%".yml"} ;; # remove .yml if present
        r) revision=${OPTARG} ;;
        s) subnet=${OPTARG} ;;
        v) vpc=${OPTARG} ;;
        *) echo "unknown option, check usage with -h" && exit 1;;
    esac
done

if [ -z "${bastion}" ] || [ -z "${groups}" ] || [ -z "${playbook}" ] || \
   [ -z "${revision}" ] || [ -z "${subnet}" ] || [ -z "${vpc}" ] || [ -z "${env}" ]
then
    echo "missing args, check usage with -h" && exit 1
fi

packer build -force \
    -var "ansible_environment=${env}" \
    -var "ansible_groups=${groups}" \
    -var "ansible_playbook=../ansible/${playbook}.yml" \
    -var "revision=${revision}" \
    -var "ssh_bastion_host=${bastion}" \
    -var "subnet_id=${subnet}" \
    -var "vpc_id=${vpc}" \
    amazon.json
