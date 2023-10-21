#!/bin/bash

# Função para exibir mensagens de erro
print_error() {
    echo "Erro: $1"
    exit 1
}

# Função para instalar pacotes com tratamento de erro
install_package() {
    package_name="$1"
    if dpkg -l | grep -q "$package_name"; then
        echo "$package_name já está instalado."
    else
        sudo apt-get -y install "$package_name" || print_error "Falha ao instalar $package_name."
    fi
}

# Deseja instalar o MySQL
echo "Deseja instalar o MySQL e criar a estrutura do banco de dados? [s/n]"
read -r getMysql

if [ "$getMysql" == "s" ]; then
    # Define a senha para o usuário 'root' do MySQL
    sudo mysqladmin -u root password '01032002' || print_error "Falha ao definir a senha do MySQL."

    # Instala o MySQL Server
    install_package "mysql-server"

    # Inicia o serviço do MySQL
    sudo service mysql start || print_error "Falha ao iniciar o serviço MySQL."

    # Configura o MySQL para iniciar automaticamente na inicialização
    sudo systemctl enable mysql

    # Função para criar banco de dados e usuário
    create_database_and_user() {
        db_name="$1"
        db_user="$2"
        db_password="$3"
        mysql -u root -p -e "CREATE DATABASE IF NOT EXISTS $db_name;" || print_error "Falha ao criar o banco de dados."
        mysql -u root -p -e "CREATE USER IF NOT EXISTS '$db_user'@'localhost' IDENTIFIED BY '$db_password';" || print_error "Falha ao criar o usuário."
        mysql -u root -p -e "GRANT ALL PRIVILEGES ON $db_name.* TO '$db_user'@'localhost';" || print_error "Falha ao conceder privilégios."
        mysql -u root -p -e "FLUSH PRIVILEGES;" || print_error "Falha ao atualizar privilégios."
    }

    # Cria um banco de dados e um usuário
    create_database_and_user "NEXUS" "seu_usuario" "sua_senha"

    # URL do arquivo SQL local
    sql_file_url="/caminho/para/script-sql.sql"

    # Função para baixar e executar arquivo SQL
    download_and_execute_sql() {
        sql_file="$1"
        mysql -u root -p < "$sql_file" || print_error "Falha ao executar o arquivo SQL."
    }

    # Baixa e executa o arquivo SQL local
    download_and_execute_sql "$sql_file_url"

else
    echo "Você optou por não instalar o MySQL. Segue a execução..."
fi
