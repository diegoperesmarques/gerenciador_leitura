#!/usr/bin/env bash

source ./funcoes_uteis.sh

menu_livros() {
    local -a OPCOES_MENU_PRINCIPAL=(
        "1" "Listar livros"
        "2" "Cadastrar livros"
        "3" "Editar livros"
        "4" "Excluir livros"
    )

    opcao_selecionada=$(menu_opcoes "Gerenciamento de livros" "${OPCOES_MENU_PRINCIPAL[@]}")

    case $opcao_selecionada in 
        1) 
            listar_livros
        ;;
        2) 
            cadastrar_livros
        ;;
        3) 
            editar_livros
        ;;
        *)
            excluir_livros
        ;;
    esac

}

listar_livros() 
{

    DB_FILE="leitura.db"

    SQL_SELECT="SELECT id, nome, autor, isbn_issn, num_paginas, data_criacao FROM livros"

    AWK_FORMATTER='
    BEGIN { 
        # Define o separador de campo dentro do script para melhor organização
        FS="|" 
    }
    {
        split($6, datetime, " ")
        
        split(datetime[1], date, "-")
        
        data_formatada = date[3] "/" date[2] "/" date[1] " " datetime[2]

        print "--------------------------------------------------"
        printf "ID: %s\n", $1
        printf "NOME: %s\n", $2
        printf "AUTOR: %s\n", $3
        printf "ISBN OU ISSN: %s\n", $4
        printf "PÁGINAS: %s\n", $5
        printf "CRIAÇÃO: %s\n", data_formatada
        print "" 
    }
    '

    sqlite3 "$DB_FILE" "$SQL_SELECT" | awk "$AWK_FORMATTER"

}

cadastrar_livros() 
{
    imprimir_titulo "Dados do livro"

    read -p "Nome do livro: " nome_livro
    read -p "Autor do livro: " autor_livro
    read -p "ISBN ou ISSN: " isbn_livro
    read -p "Número de páginas: " num_paginas

    DB_FILE="leitura.db"

    DATA_CRIACAO=$(date +"%Y-%m-%d %H:%M:%S")


    SQL_INSERT="INSERT INTO livros (nome, autor, isbn_issn, num_paginas, data_criacao) VALUES 
    ('$nome_livro', '$autor_livro', '$isbn_livro', $num_paginas, '$DATA_CRIACAO');"

    sqlite3 "$DB_FILE" "$SQL_INSERT"

    if [ $? -eq 0 ]; then
        echo ""
        echo "Livro '$nome_livro' inserido com sucesso!"
    else
        echo ""
        echo "Erro ao inserir o livro no banco de dados."
    fi

    read -p "Tecle enter para voltar ..." 

    menu_livros

}

editar_livros() 
{
    echo "Chegou na função editar livros"
}

excluir_livros() 
{
    echo "Chegou na função excluir livros"
}




principal() {

    inicializa_banco

    local -a OPCOES_MENU_PRINCIPAL=(
        "1" "Livros"
        "2" "Histórico de leitura"
    )

    opcao_selecionada=$(menu_opcoes "Menu Principal" "${OPCOES_MENU_PRINCIPAL[@]}")


    case $opcao_selecionada in
    1)
        menu_livros
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