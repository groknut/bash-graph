#!/bin/bash

if [[ $# -ne 1 ]]; then
	echo "Использование: $0 <file>"
	exit 1
fi

if [[ ! -f $1 ]]; then
	echo "Файл $1 не существует"
	exit 1
fi
declare -a order
declare -A graph

while read source target weight; do
	graph["$source, $target"]=$weight
	order+=("$source, $target")
done < $1

graph_print ()
{
	for edge in "${order[@]}"; do
		source="${edge%,*}"
		target="${edge#*,}"
		echo "$source -> $target : ${graph[$edge]}"
	done
}

graph_print graph
