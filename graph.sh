#!/bin/bash

oriented=0

declare -a order
declare -A graph
declare -A nodes


load_graph()
{
	local file="$1"
	local oriented="$2"

	order=()
	graph=()
	nodes=()

	while read source target weight; do
		graph["$source, $target"]=$weight
		order+=("$source, $target")
	
		if [ -z "${nodes[$source]}" ]; then
			nodes["$source"]="$target"
		else
			nodes["$source"]="${nodes[$source]} $target"
		fi

		if [ -z "${nodes[$target]}"]; then
			nodes["$target"]=""
		fi
	
		if [[ $oriented -eq 0 ]]; then
			graph["$target, $source"]=$weight
			order+=("$target, $source")
	
			if [ -z "${nodes[$target]}" ]; then
					nodes["$target"]="$source"
			else
				nodes["$target"]="${nodes[$target]} $source"
			fi
		fi
	done < "$file"
}



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
