#!/usr/bin/env bash

imprimir_titulo() {
  local texto_titulo="${1}"

  local largura_total=${2:-45}

  local borda
  borda=$(printf '#%.0s' $(seq 1 "$largura_total"))

  clear

  echo "$borda"

  awk -v largura="$largura_total" -v texto="$texto_titulo" '
  BEGIN {
    padding_total = largura - length(texto) - 2; # -2 para os caracteres "#" de cada lado

    if (padding_total < 0) {
      padding_total = 0;
    }
    
    padding_esq = int(padding_total / 2);
    
    padding_dir = padding_total - padding_esq;
    
    espaco_esq = sprintf("%*s", padding_esq, "");
    espaco_dir = sprintf("%*s", padding_dir, "");

    printf("# %s%s%s #\n", espaco_esq, texto, espaco_dir);
  }
  '
  
  echo "$borda"
  
  echo ""

}


function menu_opcoes() {

      local titulo="$1"
    shift 
    local -a opcoes=("$@")
    local escolha
    local mensagem_erro=""

    while true; do
        clear >&2

        imprimir_titulo "$titulo" >&2

        if [[ -n "$mensagem_erro" ]]; then
            echo "$mensagem_erro" >&2
            echo "" >&2
        fi

        echo "Digite o número de uma das opções abaixo:" >&2
        echo "" >&2

        for ((i=0; i<${#opcoes[@]}; i+=2)); do
            printf "  %s) %s\n" "${opcoes[i]}" "${opcoes[i+1]}" >&2
        done
        
        echo "" >&2

        # O prompt do 'read -p' já é enviado para stderr em um terminal interativo.
        read -p "Opção: " escolha

        local opcao_valida=false
        for ((i=0; i<${#opcoes[@]}; i+=2)); do
            if [[ "${opcoes[i]}" == "$escolha" ]]; then
                opcao_valida=true
                break
            fi
        done

        if $opcao_valida; then
            # Apenas o valor final escolhido é enviado para stdout,
            # para que possa ser capturado pela substituição de comando.
            echo "$escolha"
            return 0
        else
            mensagem_erro="Opção inválida !!!"
        fi
    done

}