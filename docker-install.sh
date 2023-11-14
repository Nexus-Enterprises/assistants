#!/bin/bash

PURPLE='\033[0;35m'
NC='\033[0m'
VERSAO=17

# Nome da empresa
EMPRESA="Nexus"

# Função para registrar mensagens de erro
log_error() {
    echo "Erro: $1" >> log.txt
}

# Mensagem informativa sobre a instalação do Docker
echo -e "${PURPLE}[${EMPRESA}]:${NC} Instalando o Docker..."
sudo apt install docker.io
sleep 10
echo -e "${PURPLE}[${EMPRESA}]:${NC} Docker instalado com sucesso!"

# Iniciar o serviço do Docker
echo -e "${PURPLE}[${EMPRESA}]:${NC} Iniciando o serviço do Docker..."
sudo systemctl start docker
sudo systemctl enable docker
sleep 10

# Baixar a imagem do MySQL 5.7
echo -e "${PURPLE}[${EMPRESA}]:${NC} Baixando a imagem do MySQL 5.7..."
sudo docker pull mysql:5.7
sleep 15
echo -e "${PURPLE}[${EMPRESA}]:${NC} Imagem do MySQL 5.7 baixada com sucesso!"

# Criar e executar o container MySQL
echo -e "${PURPLE}[${EMPRESA}]:${NC} Criando e executando o container MySQL..."
sudo docker run -d -p 3306:3306 --name NexusBank -e "MYSQL_DATABASE=NEXUS" -e "MYSQL_ROOT_PASSWORD=nexus123" mysql:latest
sleep 15
echo -e "${PURPLE}[${EMPRESA}]:${NC} Container MySQL criado e em execução!"

# Executar o script SQL dentro do container MySQL
echo -e "${PURPLE}[${EMPRESA}]:${NC} Executando o script SQL dentro do container MySQL..."
sudo docker exec -i NexusBank mysql -u root -pnexus123 NEXUS < /home/ubuntu/assistant/script.sql
echo -e "${PURPLE}[${EMPRESA}]:${NC} Script SQL executado com sucesso!"

# Executar o arquivo java-install.sh
echo -e "${PURPLE}[${EMPRESA}]:${NC} Dando permissão e executando o arquivo java-install.sh..."
sudo chmod +x java-install.sh

# Executar o arquivo java-install.sh
echo -e "${PURPLE}[${EMPRESA}]:${NC} Executando o arquivo java-install.sh"
sudo ./java-install.sh