#!/bin/bash
# Define colors for formatting
PURPLE='\033[0;35m'
NC='\033[0m'
VERSAO=17

# Nome da empresa
EMPRESA="Nexus"

# Função para registrar mensagens de erro
log_error() {
    echo "Erro: $1" >> log.txt
}

# Função para instalar Docker e MySQL container
installContainerMySQL() {
    echo -e "${PURPLE}[${EMPRESA}]:${NC} Olá Cliente, vamos instalar o Docker e criar um Container com o MySQL 5.7"
    echo -e "${PURPLE}[${EMPRESA}]:${NC} Verificando se você possui o Docker instalado..."
    sleep 2
    docker -v
    if [ $? -eq 0 ]; then
        echo "Você já tem o Docker instalado!"
    else
        echo "Não identificamos nenhuma versão do Docker instalado, mas não se preocupe, irei resolver isso agora mesmo!"
        echo "Confirme para nosso sistema se realmente deseja instalar o Docker (S/N)?"
        read inst
        if [ "$inst" == "S" ]; then
            echo "Ok! Você escolheu instalar o Docker ;D"
            echo "Adicionando o repositório!"
            sleep 2
            sudo apt update -y
            clear
            echo "Atualizando! Quase lá."
            sleep 2
            sudo apt install docker.io -y
            sudo systemctl start docker
            sudo systemctl enable docker
            sleep 2
            sudo docker pull mysql:latest
            sudo docker run -d -p 3306:3306 --name NexusBank -e "MYSQL_DATABASE=NEXUS" -e "MYSQL_ROOT_PASSWORD=nexus123" mysql:latest
            sleep 10

            sudo docker exec -i NexusBank mysql -u root -pnexus123 NEXUS < script.sql
            echo "Docker instalado com sucesso e container criado com sucesso!"
            echo "Agora iremos criar as tabelas no banco de dados"
            sleep 2

            sudo apt install mysql-client -y
            mysql -u root -pnexus123 -h 127.0.0.1 -P 3306 NEXUS < script.sql

            echo "Tabelas criadas com sucesso!"
            echo "Tudo configurado com sucesso!"
        else
            log_error "Você optou por não instalar o Docker por enquanto."
        fi
    fi
}


# Função para instalar o Java e executar o arquivo JAR
installJavaNexus() {
    echo -e "${PURPLE}[${EMPRESA}]:${NC} Olá usuário, serei seu assistente para instalação do Java e execução do arquivo JAR!"
    echo -e "${PURPLE}[${EMPRESA}]:${NC} Verificando se você possui o Java instalado na sua máquina..."
    sleep 2

    # Verifica se o Java está instalado
    java -version
    if [ $? -eq 0 ]; then
        echo -e "${PURPLE}[${EMPRESA}]:${NC} Você já possui o Java instalado na sua máquina!"
        echo -e "${PURPLE}[${EMPRESA}]:${NC} Vamos atualizar os pacotes..."
        sudo apt update && sudo apt upgrade -y
        clear
        echo -e "${PURPLE}[${EMPRESA}]:${NC} Pacotes atualizados!"
        
        # Baixa o arquivo JAR diretamente do GitHub
        echo -e "${PURPLE}[${EMPRESA}]:${NC} Baixando o arquivo JAR..."
        wget https://github.com/Nexus-Enterprises/login-Java/raw/main/Nexus/target/Nexus-1.0-jar-with-dependencies.jar
        if [ $? -eq 0 ]; then
            echo -e "${PURPLE}[${EMPRESA}]:${NC} Arquivo JAR baixado com sucesso!"
            echo -e "${PURPLE}[${EMPRESA}]:${NC} Agora vamos executar o arquivo JAR..."
            java -jar Nexus-1.0-jar-with-dependencies.jar
        else
            log_error "Erro ao baixar o arquivo JAR do GitHub"
        fi
    else
        echo -e "${PURPLE}[${EMPRESA}]:${NC} Não foi encontrada nenhuma versão do Java na sua máquina, mas iremos resolver isso!"
        echo -e "${PURPLE}[${EMPRESA}]:${NC} Você deseja instalar o Java na sua máquina (S/N)?"
        read inst
        if [ "$inst" == "S" ]; then
            echo -e "${PURPLE}[${EMPRESA}]:${NC} Ok! Você decidiu instalar o Java na máquina, uhul!"
            echo -e "${PURPLE}[${EMPRESA}]:${NC} Adicionando o repositório!"
            sleep 2
            sudo add-apt-repository ppa:linuxuprising/java
            clear
            echo -e "${PURPLE}[${EMPRESA}]:${NC} Atualizando os pacotes... Quase acabando."
            sleep 2
            sudo apt update -y
            clear
            if [ $VERSAO -eq 17 ]; then
                echo -e "${PURPLE}[${EMPRESA}]:${NC} Preparando para instalar a versão 17 do Java. Lembre-se de confirmar a instalação quando necessário!"
                sudo apt-get install openjdk-17-jdk
                clear
                echo -e "${PURPLE}[${EMPRESA}]:${NC} Java instalado com sucesso!"
                echo -e "${PURPLE}[${EMPRESA}]:${NC} Vamos atualizar os pacotes..."
                sudo apt update && sudo apt upgrade -y
                clear

                # Baixa o arquivo JAR diretamente do GitHub
                echo -e "${PURPLE}[${EMPRESA}]:${NC} Baixando o arquivo JAR..."
                wget https://github.com/Nexus-Enterprises/login-Java/raw/main/Nexus/target/Nexus-1.0-jar-with-dependencies.jar
                if [ $? -eq 0 ]; then
                    echo -e "${PURPLE}[${EMPRESA}]:${NC} Arquivo JAR baixado com sucesso!"
                    echo -e "${PURPLE}[${EMPRESA}]:${NC} Agora vamos executar o arquivo JAR..."
                    java -jar Nexus-1.0-jar-with-dependencies.jar
                else
                    log_error "Erro ao baixar o arquivo JAR do GitHub"
                fi
            fi
        else
            log_error "Você optou por não instalar o Java por enquanto."
        fi
    fi
}


# Main script - functions
installContainerMySQL
installJavaNexus