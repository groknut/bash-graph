
#!/bin/bash

source ./graph.sh

dfs()
{
	local node="$1"
	declare -A visited

	_dfs()
	{
		local n="$1"
		if [[ -n "${visited[$n]}" ]]; then
			return
		fi

		visited["$n"]=1

		echo "Visited $n"

		for neigh in ${nodes[$n]}; do
			[[ -z "${visited[$neigh]}" ]] && _dfs "$neigh"
		done
	}
	_dfs "$node"

	if [[ ${#visited[@]} -eq ${#nodes[@]} ]]; then echo "All nodes visited"; fi	
}
