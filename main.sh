
#!/bin/bash

source ./graph.sh
source ./bfs.sh
source ./dfs.sh

if [[ $# -lt 1  ]]; then
	echo "Using: $0 <file> [oriented]"
	exit 1
fi

file="$1"
oriented=${2:-0}

load_graph $file $oriented

graph_info $file

graph_print

bfs A X
dfs A

