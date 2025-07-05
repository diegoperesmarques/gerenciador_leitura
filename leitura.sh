#!/usr/bin/env bash

source ./funcoes_uteis.sh


function principal() {

    declare -a OPCOES_MENU_PRINCIPAL=(
        "1" "Livros"
        "2" "Histórico de leitura"
    )

    opcao_selecionada=$(menu_opcoes "Menu Principal" "${OPCOES_MENU_PRINCIPAL[@]}")


    case $opcao_selecionada in
    1)
        imprimir_titulo "Você está na opção livros"
        echo "Você escolheu a opção 1: Livros."
        ;;
    2)
        imprimir_titulo "Você está na opção histórico de leitura"
        echo "Você escolheu a opção 2: Histórico de leitura."
        ;;
    *)
        echo "Opção inválida."
        ;;
    esac


}


principal