#!/bin/bash

#Verificação de permissões
if [[ $EUID -ne 0 ]]; then
	echo -e "\033[1;31m Este script precisa ser executado como root. \033[0m"
	exit 1
fi

#Mensagem de inĩcio
echo -e "\033[1;35m Coletando arquivos do sistema...\033[0m"

#Criação de diretório para coleta
COLLECTED_DIR="collected_files"
mkdir -p "$COLLECTED_DIR"

#Coleta de informações do sistema
echo -e "\033[0;95m Listando informações sobre discos e partições... \033[0m"

#Listar os dispositivos de armazenamento e informações de partições
DISK_INFO="$COLLECTED_DIR/disk_info.txt"
lsblk > "$DISK_INFO"

#Coleta de conexões de rede
echo -e "\033[0;95m Coletando informações de rede... \033[0m"

#Capturar conexões ativas e portas abertas
netstat -tunapl > "$COLLECTED_DIR/open_ports.txt"
ss -tunapl > "$COLLECTED_DIR/active_connections.txt"

#Coleta de processos
echo -e "\033[0;95m Coleta de processos... \033[0m"

#Criação de arquivo que lista processos em execução
ps aux > "$COLLECTED_DIR/process_list.txt"

#Coleta de registros do sistema
echo -e "\033[0;95m Coletando logs do sistema... \033[0m"

#Copiar logs
cp /var/log/syslog "$COLLECTED_DIR/syslog.log"
cp /var/log/auth.log "$COLLECTED_DIR/auth.log"
cp /var/log/dmesg "$COLLECTED_DIR/dmesg.log"

#Coleta de arquivos de configuração
echo -e "\033[0;95m Coletando arquivos de configuração... \033[0m"

#Criação do backup do diretório
cp -r /etc "$COLLECTED_DIR/etc_backup"

#Coleta de lista de arquivos do diretório raiz
echo -e "\033[0;95m Listando o diretório raiz... \033[0m"

#Criando um arquivo contendo a listagem do diretório
ls -la / > "$COLLECTED_DIR/root_dir_list.txt"

#Compactação e nomeação do arquivo de saída
HOSTNAME=$(hostname)
DATE_COLLECT=$(date +"%Y%m%d-%H%M%S")
TAR_FILE="TraceHunter_${HOSTNAME}_${DATE_COLLECT}.tar.gz"
tar -czf "$TAR_FILE" "$COLLECTED_DIR"

#Mensagem final de criação do arquivo tar.gz
echo -e "\033[1;33m Arquivo ${TAR_FILE} criado com sucesso! \033[0m"
