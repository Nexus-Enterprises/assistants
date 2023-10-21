#!/bin/bash

# Função para exibir mensagens de erro
print_error() {
    echo "Erro: $1"
    exit 1
}


# Atualiza o sistema
sudo apt update || print_error "Falha ao atualizar o sistema."
sudo apt upgrade -y || print_error "Falha ao atualizar o sistema."

# Troca a senha dos usuários
sudo passwd ubuntu
sudo passwd root

# Instala o RDP no Ubuntu
sudo apt install -y xrdp || print_error "Falha ao instalar o RDP."

# Verifica se o Java 17 está instalado
if ! command -v java &>/dev/null || [[ $(java -version 2>&1 | grep -c "17\..*") -eq 0 ]]; then
    echo "Java 17 não está instalado. Deseja instalar o Java? [s/n]"
    read -r get
    if [ "$get" == "s" ]; then
        # Instala o OpenJDK 17 JRE
        sudo apt-get install -y openjdk-17-jre
    else
        echo "Você optou por não instalar o Java. Saindo..."
        exit 1
    fi
fi

# Verifica a instalação do Java JRE
java -version && javac -version

# Baixa o arquivo .jar diretamente do link
wget https://github.com/Nexus-Enterprises/login-Java/blob/main/Nexus/target/Nexus-1.0-jar-with-dependencies.jar -O nexus.jar || print_error "Falha ao baixar o arquivo JAR."

# Permissão para o arquivo .jar
chmod +x nexus.jar

# Executa o arquivo .jar
java -jar nexus.jar