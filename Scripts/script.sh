#!/bin/bash

criar_script(){
    echo -e ""
    read -p "Nome do Script: " nScript
    touch $nScript
    chmod +x $nScript
    echo "#!/bin/bash" >> $nScript
    echo "#Owner: " >> $nScript
    echo "#Date: " >> $nScript
    echo "#SortDescription: " >> $nScript
    echo "#Description: " >> $nScript
    echo "#How to Use: " >> $nScript
    nano $nScript
}

opcoes_scripts() {

    argsscripts=()

    listar_menu

    read -p "Insira opcao: " op

	N=1
	for k in `ls -1 ${args[$op-1]}`
	do
		Name=`cat ${args[$op-1]}/$k | grep SortDescription | awk -F ":" '{print $2}'`
		echo $N - $Name \($k\)
		argsscripts+=("${args[$op-1]}/$k")
		let N=$N+1
    done

    read -p "Qual script deseja adicionar a bateria: " opS
    for y in `ls -1 ${argsscripts[$opS-1]/$y}`
    do
        chmod +x $y
        #short=${y##*/}
        echo "./"$y >> bateria.sh
    done

    show_menu
}

listar_menu(){
    N=1
    args=()

    echo
    for i in `ls -1 | grep -v script`
    do
        echo $N - $i
        args+=("$i")
        let N=$N+1
    done
}

correr_bateria(){
    echo -e ""
    touch bateria.sh
    chmod +x bateria.sh
    ./bateria.sh
}

remover_bateria(){
    rm bateria.sh
}

show_menu() {
    echo -e "\n    Select an option from menu: "
    echo -e "\n Key  Menu Option:               Description:"
    echo -e " ---  ------------                 ------------"
    echo -e "  1 - Criar                        (Cria um script para o utilizador)"
    echo -e "  2 - Adicionar                    (Adiciona Scripts a nossa bateria)"
    echo -e "  3 - Correr                       (Corre a nossa bateria)"
    echo -e "  4 - Remover                      (Remove tudo dentro da bateria)"
    read -n1 -p "  Press key for menu item selection or press X to exit: " menuinput

  case $menuinput in
        1) criar_script;;
        2) opcoes_scripts;;
        3) correr_bateria;;
        4) remover_bateria;;
        x|X) echo -e "\n\n Exiting";;
        *) show_menu;;
    esac
}

exit_screen () {
    echo -e "\n All Done! \n"
    exit
}

#Run menus
show_menu
exit_screen
