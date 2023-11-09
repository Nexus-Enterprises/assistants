 # Usando a imagem oficial do MySQL como imagem base
FROM mysql:latest

# defina variáveis de ambiente para a senha do rrot do MySQL
ENV MYSQL_USER=root
ENV MYSQL_ROOT_PASSWORD=nexus123
ENV MYSQL_DATABASE=NEXUS

# Copie o script de inicialização para o diretório de inicialização do MySQL
COPY script.sql /docker-entrypoint-initdb.d/

# Exponha a porta do MySQL (se necessário)
EXPOSE 3306