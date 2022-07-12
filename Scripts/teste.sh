#!/bin/bash

opcoes_scripts() {
	argsscripts=()
	N=1
	for k in `ls -1 ${args[$op-1]}`
	do
		Name=`cat ${args[$op-1]}/$k | grep SortDescription | awk -F ":" '{print $2}'`
		echo $N - $Name \($k\)
        echo "./"$k >> fich_user1.sh
		argsscripts+=("${args[$op-1]}/$k")
		let N=$N+1
	done
}


N=1
args=()
bat=()
for i in `ls -1 | grep -v menu`
do
	echo $N - $i
	args+=("$i")
	let N=$N+1
	
done

echo -e "Insira opcao : "
read op

opcoes_scripts
