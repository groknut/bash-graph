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
declare -A nodes

while read source target weight; do
	graph["$source, $target"]=$weight
	order+=("$source, $target")

	if [ -z "${nodes[$source]}" ]; then
		nodes["$source"]="$target"
	else
		nodes["$source"]="${nodes[$source]} $target"
	fi		 
	
done < $1

graph_print ()
{
	for edge in "${order[@]}"; do
		source="${edge%,*}"
		target="${edge#*,}"
		echo "$source -> $target : ${graph[$edge]}"
	done
}

graph_info ()
{
	echo
	echo "📊 ГРАФ ИЗ ФАЙЛА: $1"
	echo "─────────────────────────────────────────"
    echo "• Прочитано ребер: ${#graph[@]}"
    echo "• Формат данных: source target weight"
    echo "• Обработка: $(date)"
    if [[ ${#graph[@]} -eq 0 ]]; then
            echo "• ⚠️  ВНИМАНИЕ: Граф пуст!"
    fi
    echo
}

bfs ()
{
	local begin=$1
	local end=$2

	if [ -z "${nodes[$begin]}" ] && [ "$begin" != "$end" ]; then
		echo "Node ''$begin' not found"
		return 1
	fi

	if [ -z "${nodes[$end]}" ] && [ "$begin" != "$end" ]; then
		echo "Node '$end' not found"
		return 1
	fi

	if [ "$begin" == "$end"  ]; then
		echo "Begin == End"
		return 0
	fi
	
	local queue=()

	declare -A visited
	queue+=("$begin")
	visited["$begin"]=1

	while [ ${#queue[@]} -gt 0  ]; do
		local current="${queue[0]}"
		queue=("${queue[@]:1}")

		if [ "$current" == "$end" ]; then
			echo "True"
			return 0
		fi
		
		local neighs="${nodes[$current]}"

		if [ -n "$neighs" ]; then
			for neigh in $neighs; do
				if [ -z "${visited[$neigh]}" ]; then
					visited["$neigh"]=1
					queue+=("$neigh")
				fi
			done
		fi
	done
	echo "false"
	return 1
}

graph_info "$1"
graph_print
bfs A X
