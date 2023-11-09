CREATE DATABASE NEXUS;
USE NEXUS;

CREATE TABLE Endereco (
  idEndereco INT AUTO_INCREMENT PRIMARY KEY,
  cep CHAR(8) NULL,
  logradouro VARCHAR(45) NOT NULL,
  bairro VARCHAR(45) NOT NULL,
  localidade VARCHAR(45) NOT NULL,
  uf CHAR(2) NOT NULL,
  complemento VARCHAR(45) NULL
);
-- Inserindo dados na tabela Endereco
INSERT INTO Endereco (cep, logradouro, bairro, localidade, uf, complemento)
VALUES
  ('12345678', 'Rua Padrao', 'Padrao', 'Padrao', 'SP', 'Padrao');


CREATE TABLE Empresa (
  idEmpresa INT AUTO_INCREMENT PRIMARY KEY,
  nomeEmpresa VARCHAR(45) NOT NULL,
  CNPJ VARCHAR(14) NOT NULL UNIQUE,
  digito CHAR(3) NOT NULL,
  descricao VARCHAR(45) NULL,
  ispb CHAR(8) NOT NULL,
  situacao TINYINT NULL
);
-- Inserindo dados na tabela Empresa
INSERT INTO Empresa (nomeEmpresa, CNPJ, digito, descricao, ispb, situacao)
VALUES
  ('Bradesco', '60746948000112', '237', 'Bradesco S.A.', '60746948', 1),
  ('Banco do Brasil', '00000000000191', '001', 'Banco do Brasil', '00000000', 1),
  ('Itau', '60701190000104', '341', 'Itau', '60701190', 1);

CREATE TABLE Agencia (
  idAgencia INT AUTO_INCREMENT PRIMARY KEY,
  numero CHAR(4) NULL,
  digitoAgencia CHAR(1) NULL,
  ddd CHAR(2) NULL,
  telefone VARCHAR(9) NULL,
  email VARCHAR(45) NULL UNIQUE,
  fkEmpresa INT NOT NULL,
  fkEndereco INT NOT NULL,
  CONSTRAINT fkEndereco
    FOREIGN KEY (fkEndereco)
    REFERENCES Endereco (idEndereco),
  CONSTRAINT fkEmpresaAgencia
    FOREIGN KEY (fkEmpresa)
    REFERENCES Empresa (idEmpresa)
);

-- Inserindo dados na tabela Agencia
INSERT INTO Agencia (numero, digitoAgencia, ddd, telefone, email, fkEmpresa, fkEndereco)
VALUES
  ('1111', '1', '11', '111111111', 'padrao@padrao.com', 1, 1),
  ('0897', '2', '22', '222222222', 'agencia2@bradesco.com', 1, 1),
  ('0327', '3', '33', '333333333', 'agencia3@bradesco.com', 1, 1),
  ('0438', '4', '44', '444444444', 'agencia4@bradesco.com', 1, 1),
  ('0283', '5', '55', '555555555', 'agencia5@bradesco.com', 1, 1);


CREATE TABLE Funcionario (
  idFuncionario INT AUTO_INCREMENT PRIMARY KEY,
  nome VARCHAR(45) NULL,
  sobrenome VARCHAR(45) NULL,
  emailCorporativo VARCHAR(45) NULL UNIQUE,
  token VARCHAR(50) NULL,
  ddd CHAR(2) NULL,
  telefone VARCHAR(9) NULL UNIQUE,
  cargo VARCHAR(45) NULL,
  situacao VARCHAR(10) NULL,
  fkAgencia INT NOT NULL,
  fkEmpresa INT NOT NULL,
  fkFuncionario INT NULL,
  CONSTRAINT fkAgencia
    FOREIGN KEY (fkAgencia)
    REFERENCES Agencia (idAgencia),
  CONSTRAINT fkEmpresa
    FOREIGN KEY (fkEmpresa)
    REFERENCES Empresa (idEmpresa),
  CONSTRAINT fkFuncionario
    FOREIGN KEY (fkFuncionario)
    REFERENCES Funcionario (idFuncionario)
);
INSERT INTO Funcionario (nome, sobrenome, emailCorporativo, ddd, telefone, cargo, situacao, token, fkAgencia, fkEmpresa)
VALUES
('João', 'Silva', 'joao.silva@empresa.com', '11', '999999999', 'Analista de TI', 'Ativo', 'token1', 1, 1),
('Maria', 'Pereira', 'maria.pereira@empresa.com', '21', '888888888', 'Desenvolvedor', 'Ativo', 'token2', 2, 1),
('Pedro', 'Santos', 'pedro.santos@outraempresa.com', '31', '777777777', 'Analista de Redes', 'Inativo', 'token3', 3, 1);

CREATE TABLE Maquina (
  idMaquina INT AUTO_INCREMENT PRIMARY KEY,
  marca VARCHAR(45) NULL,
  modelo VARCHAR(45) NULL,
  situacao VARCHAR(10) NULL,
  sistemaOperacional VARCHAR(15) NULL,
  fkFuncionario INT NOT NULL,
  fkAgencia INT NOT NULL,
  fkEmpresa INT NOT NULL,
  CONSTRAINT fkFuncionarioMaq
    FOREIGN KEY (fkFuncionario)
    REFERENCES Funcionario (idFuncionario),
  CONSTRAINT fkAgenciaMaq
    FOREIGN KEY (fkAgencia)
    REFERENCES Agencia (idAgencia),
  CONSTRAINT fkEmpresaMaq
    FOREIGN KEY (fkEmpresa)
    REFERENCES Empresa (idEmpresa)
);

INSERT INTO Maquina (marca, modelo, situacao, sistemaOperacional, fkFuncionario, fkAgencia, fkEmpresa)
VALUES 
('Dell', 'Latitude 7400', 'Ativa', 'Windows 10', 1, 1, 1),
('HP', 'ProBook 450 G6', 'Ativa', 'Windows 10', 1, 2, 1),
('Lenovo', 'ThinkPad T480', 'Inativa', 'Windows 7', 2, 3, 2),
('Apple', 'MacBook Air', 'Ativa', 'macOS', 2, 4, 2),
('HP', 'EliteBook 840 G5', 'Ativa', 'Windows 10', 3, 5, 2);

CREATE TABLE Componente (
  idComponente INT AUTO_INCREMENT PRIMARY KEY,
  nome VARCHAR(45) NULL UNIQUE
);

INSERT INTO Componente (nome) VALUES
  ('Processador'),
  ('Memória RAM'),
  ('Disco rígido'),
  ('Placa de vídeo'),
  ('Unidade de estado sólido (SSD)'),
  ('Placa de rede (Ethernet)'),
  ('Placa de rede sem fio (Wi-Fi)'),
  ('Disco rígido externo');

CREATE TABLE Alerta (
  idAlerta INT AUTO_INCREMENT PRIMARY KEY,
  causa VARCHAR(60) NOT NULL,
  gravidade VARCHAR(45) NOT NULL
);

INSERT INTO Alerta (causa, gravidade)
VALUES
  ('Sobrecarga de CPU', 'Baixa'),
  ('Sobrecarga de CPU', 'Media'),
  ('Sobrecarga de CPU', 'Alta'),
  ('Memória insuficiente', 'Baixa'),
  ('Memória insuficiente', 'Média'),
  ('Memória insuficiente', 'Alta'),
  ('Erro de disco rígido', 'Baixa'),
  ('Erro de disco rígido', 'Media'),
  ('Erro de disco rígido', 'Alta'),
  ('Erro na Placa de Video', 'Baixa'),
  ('Erro na Placa de Video', 'Media'),
  ('Erro na Placa de Video', 'Alta'),
  ('SSD com Erro', 'Baixa'),
  ('SSD com Erro', 'Media'),
  ('SSD com Erro', 'Alta'),
  ('Sem Conexao com a Internet', 'Baixa'),
  ('Sem Conexao com a Internet', 'Media'),
  ('Sem Conexao com a Internet', 'Alta');

CREATE TABLE Registro (
  idRegistro INT AUTO_INCREMENT PRIMARY KEY,
  modelo VARCHAR(50) NULL,
  capacidadeMax DOUBLE NULL,
  usoAtual DOUBLE NULL,
  montagem VARCHAR(20) NULL,  
  enderecoIPV4 VARCHAR(500) NOT NULL,
  dataHora DATETIME NOT NULL,  
  fkAlerta INT NOT NULL,
  fkComponente INT NOT NULL,
  fkMaquina INT NOT NULL,
  CONSTRAINT fkAlertaRegistro
    FOREIGN KEY (fkAlerta)
    REFERENCES Alerta (idAlerta),
  CONSTRAINT fkComponenteRegistro
    FOREIGN KEY (fkComponente)
    REFERENCES Componente (idComponente),
  CONSTRAINT fkMaquinaRegistro
    FOREIGN KEY (fkMaquina)
    REFERENCES Maquina (idMaquina)
);

INSERT INTO Registro (modelo, capacidadeMax, usoAtual, montagem, enderecoIPV4, dataHora, fkAlerta, fkComponente, fkMaquina)
VALUES
  ('CPU Intel i7', 4.0, 3.9, 'Slot A', '192.168.1.101', '2023-11-04 12:34:56', 3, 1, 1),
  ('CPU Intel i7', 4.2, 4.0, 'Slot A', '192.168.1.101', '2023-11-04 12:34:56', 3, 1, 2),
  ('CPU Intel i7', 4.0, 4.0, 'Slot A', '192.168.1.101', '2023-11-04 12:34:56', 3, 1, 3),
  ('Memória RAM Kingston 8GB', 8.0, 3.0, 'Slot B', '192.168.1.102', '2023-11-04 13:45:30', 4, 2, 2),
  ('Disco Rígido Seagate 1TB', 1000.0, 90.0, NULL, '192.168.1.103', '2023-11-04 14:56:12', 7, 3, 3);

SELECT
  Registro.idRegistro,
  Registro.modelo,
  Registro.capacidadeMax,
  Registro.usoAtual,
  Registro.montagem,
  Registro.enderecoIPV4,
  Registro.dataHora,
  Alerta.causa AS causa_alerta,
  Alerta.gravidade AS gravidade_alerta,
  Componente.nome AS nome_componente,
  Maquina.marca AS marca_maquina,
  Maquina.modelo AS modelo_maquina,
  Maquina.situacao AS situacao_maquina,
  Maquina.sistemaOperacional AS sistemaOperacional_maquina,
  Funcionario.nome AS nome_funcionario,
  Funcionario.sobrenome AS sobrenome_funcionario,
  Funcionario.emailCorporativo AS email_corporativo_funcionario
FROM Registro
JOIN Alerta ON Registro.fkAlerta = Alerta.idAlerta
JOIN Componente ON Registro.fkComponente = Componente.idComponente
JOIN Maquina ON Registro.fkMaquina = Maquina.idMaquina
JOIN Funcionario ON Maquina.fkFuncionario = Funcionario.idFuncionario;

SELECT Agencia.numero AS "CodigoAgencia",
       Maquina.idMaquina AS "NumeroMaquina",
       Registro.capacidadeMax AS "TotalCapacidade",
       Registro.usoAtual AS "ConsumoAtual"
FROM Registro
JOIN Maquina ON Registro.fkMaquina = Maquina.idMaquina
JOIN Agencia ON Maquina.fkAgencia = Agencia.idAgencia
WHERE Registro.fkAlerta = (SELECT idAlerta FROM Alerta WHERE causa = 'Sobrecarga de CPU' AND gravidade = 'Alta')
  AND Agencia.fkEmpresa = (SELECT idEmpresa FROM Empresa WHERE nomeEmpresa = 'Bradesco')
ORDER BY (Registro.usoAtual - Registro.capacidadeMax) DESC
LIMIT 1;