#!/bin/bash

source ./graph.sh

bfs ()
{
	local begin=$1
	local end=$2

	if [[ ! -v nodes[$begin] ]] && [[ "$begin" != "$end" ]]; then
		echo "Node '$begin' not found"
		return 1
	fi

	if [[ ! -v nodes[$end] ]] && [[ "$begin" != "$end" ]]; then
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
