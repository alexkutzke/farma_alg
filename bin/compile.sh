#!/bin/bash

lang=$1
source_file=$2
bin_file=$3
output_file=$4

if [[ ${lang} == "c" ]]
then
	gcc "${source_file}" -o "${bin_file}" &> "${output_file}"
elif [[ ${lang} == "pas" ]]
then
	fpc "${source_file}" -o"${bin_file}" -Fe"${output_file}"
elif [[ ${lang} == "rb" ]]
then
	ruby -c "${source_file}" &> "${output_file}"
fi

echo $?