#!/bin/bash

options=""
usage() { echo "Usage $0 [-b <int>]k bandwidth limit [-p <string>] download path" ; exit 1;}
while getopts ":b:p:" o; do
    case "${o}" in
        p)
            p=${OPTARG}
            ;;
        b)
            b=${OPTARG}
            options="${options} --limit-rate=${b}"
            ;;
    esac
done
shift $((OPTIND-1))

declare -A courses
courses=( ["CS106A"]=28 ["CS106B"]=27 ["CS107"]=24 )
for c in ${!courses[@]}
    do
        if  [ ! -d "${p}/${c}" ]; then
            echo "creating directory ${c}"
            mkdir "${p}/${c}"
        fi
        echo "downloading ${c}"
        for i in $(seq -f "%02g" 1 ${courses[${c}]})
            do
                echo "downloading lecture ${i} of ${c}"
                wget -O "${p}/${c}/${i}.mp4" -c ${options} "http://html5.stanford.edu/videos/courses/see/${c}/${c}-lecture${i}.mp4"
            done
        echo "finished downloading ${c}"
    done
