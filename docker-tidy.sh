#!/bin/bash
#set -x

PATH="/bin:/usr/bin:/usr/local/bin:/sbin:/usr/sbin:/usr/local/sbin"
TERM="vt100"
export TERM PATH

my_docker=$(unalias docker > /dev/null 2>&1 ; which docker 2> /dev/null)

if [ "${my_docker}" != "" ]; then
    my_arg="${1}"

    container_arg="rm"
    image_arg="rmi"

    if [ "${my_arg}" = "force" ]; then
        container_arg="${container_arg} -f"
        image_arg="${image_arg} -f"
    fi

    # Flush exited containers
    let docker_container_count=$(${my_docker} ps -aq | wc -l | awk '{print $NF}')

    if [ ${docker_container_count} -gt 0 ]; then
        echo "$(date) - BEGIN - Deleting unused containers"
        ${my_docker} ${container_arg} $(${my_docker} ps -qa)
        echo "$(date) - END - Deleting unused containers"
    fi

    # Flush expired images
    let docker_image_count=$(${my_docker} images -q | wc -l | awk '{print $NF}')

    if [ ${docker_image_count} -gt 0 ]; then
        echo "$(date) - BEGIN - Deleting unused images"
        ${my_docker} ${image_arg} $(${my_docker} images -q)
        echo "$(date) - END - Deleting unused images"
    fi

fi
