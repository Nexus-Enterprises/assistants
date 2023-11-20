#!/bin/bash

PURPLE='\033[0;35m'
NC='\033[0m'
VERSAO=17

# Nome da empresa
EMPRESA="Nexus"

# Função para verificar se o Docker está pronto
docker_ready() {
    docker run hello-world &> /dev/null
}

# Função para verificar se o MySQL está pronto
mysql_ready() {
    while ! docker exec NexusBank mysqladmin --user=root --password=nexus123 --host=localhost ping --silent &> /dev/null; do
        echo -e "${PURPLE}[${EMPRESA}]:${NC} Aguardando que o MySQL inicie completamente..."
        sleep 5
    done
}

# Atualizar os pacotes do sistema
echo -e "${PURPLE}[${EMPRESA}]:${NC} Atualizando os pacotes..."
sudo apt update && sudo apt upgrade -y
sleep 30

# Mensagem informativa sobre a instalação do Docker
echo -e "${PURPLE}[${EMPRESA}]:${NC} Instalando o Docker..."
sudo apt install docker.io
while ! docker_ready; do
    sleep 10
done
echo -e "${PURPLE}[${EMPRESA}]:${NC} Docker instalado com sucesso!"

# Iniciar o serviço do Docker
echo -e "${PURPLE}[${EMPRESA}]:${NC} Iniciando o serviço do Docker..."
sudo systemctl start docker
sudo systemctl enable docker
while ! docker_ready; do
    sleep 10
done
echo -e "${PURPLE}[${EMPRESA}]:${NC} Docker está pronto!"

# Baixar a imagem do MySQL 5.7
echo -e "${PURPLE}[${EMPRESA}]:${NC} Baixando a imagem do MySQL:latest..."
sudo docker pull mysql:latest
while ! mysql_ready; do
    sleep 10
done
echo -e "${PURPLE}[${EMPRESA}]:${NC} Imagem do MySQL baixada com sucesso!"

# Criar e executar o container MySQL com o script SQL
echo -e "${PURPLE}[${EMPRESA}]:${NC} Criando e executando o container MySQL..."
sudo docker run -d -p 3306:3306 --name NexusBank -e "MYSQL_DATABASE=NEXUS" -e "MYSQL_ROOT_PASSWORD=nexus123" -v /home/ubuntu/assistants:/docker-entrypoint-initdb.d mysql:latest
sleep 60  
echo -e "${PURPLE}[${EMPRESA}]:${NC} Container MySQL criado e em execução!"

# Executar o script SQL dentro do container MySQL
echo -e "${PURPLE}[${EMPRESA}]:${NC} Executando o script SQL dentro do container MySQL..."
sudo docker exec -i NexusBank mysql -u root -pnexus123 NEXUS < /home/ubuntu/assistants/script.sql
echo -e "${PURPLE}[${EMPRESA}]:${NC} Script SQL executado com sucesso!"

# Executar o arquivo java-install.sh
echo -e "${PURPLE}[${EMPRESA}]:${NC} Dando permissão e executando o arquivo java-install.sh..."
sudo chmod +x java-install.sh

# Executar o arquivo java-install.sh
echo -e "${PURPLE}[${EMPRESA}]:${NC} Executando o arquivo java-install.sh"
sudo ./java-install.sh