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

CREATE TABLE Empresa (
  idEmpresa INT AUTO_INCREMENT PRIMARY KEY,
  nomeEmpresa VARCHAR(45) NOT NULL,
  CNPJ VARCHAR(14) NOT NULL UNIQUE,
  digito CHAR(3) NOT NULL,
  descricao VARCHAR(45) NULL,
  ispb CHAR(8) NOT NULL,
  situacao TINYINT NULL
);

CREATE TABLE Agencia (
  idAgencia INT AUTO_INCREMENT PRIMARY KEY,
  numero CHAR(5) NULL,
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

CREATE TABLE Funcionario (
  idFuncionario INT AUTO_INCREMENT PRIMARY KEY,
  nome VARCHAR(45) NULL,
  sobrenome VARCHAR(45) NULL,
  emailCorporativo VARCHAR(45) NULL UNIQUE,
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

CREATE TABLE Usuario (
  idUsuario INT AUTO_INCREMENT PRIMARY KEY,
  email VARCHAR(45) NOT NULL UNIQUE,
  token VARCHAR(50) NOT NULL,
  fkFuncionario INT NOT NULL UNIQUE,
  FOREIGN KEY (fkFuncionario)
    REFERENCES Funcionario (idFuncionario)
  );


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

CREATE TABLE Componente (
  idComponente INT AUTO_INCREMENT PRIMARY KEY,
  nome VARCHAR(45) NULL,
  modelo VARCHAR(45) NULL,
  capacidadeMax DOUBLE NULL,
  montagem VARCHAR(45) NULL,
  fkMaquina INT NOT NULL,
  CONSTRAINT fkMaquinaComponente
    FOREIGN KEY (fkMaquina)
    REFERENCES Maquina (idMaquina)
);

CREATE TABLE Alerta (
  idAlerta INT AUTO_INCREMENT PRIMARY KEY,
  causa VARCHAR(60) NOT NULL,
  gravidade VARCHAR(45) NOT NULL
);

CREATE TABLE Registro (
  idRegistro INT AUTO_INCREMENT PRIMARY KEY,
  enderecoIPV4 VARCHAR(500) NOT NULL,
  usoAtual DOUBLE NOT NULL,
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

-- Inserindo dados na tabela Endereco
INSERT INTO Endereco (cep, logradouro, bairro, localidade, uf, complemento)
VALUES
  ('12345678', 'Rua Padrao', 'Padrao', 'Padrao', 'SP', 'Padrao');

-- Inserindo dados na tabela Empresa
INSERT INTO Empresa (nomeEmpresa, CNPJ, digito, descricao, ispb, situacao)
VALUES
  ('Bradesco', '60746948000112', '237', 'Bradesco S.A.', '60746948', 1),
  ('Banco do Brasil', '00000000000191', '001', 'Banco do Brasil', '00000000', 1),
  ('Itau', '60701190000104', '341', 'Itau', '60701190', 1);
  
-- Inserindo dados na tabela Agencia
INSERT INTO Agencia (numero, digitoAgencia, ddd, telefone, email, fkEmpresa, fkEndereco)
VALUES
  ('11111', '1', '11', '111111111', 'padrao@padrao.com', 1, 1);


SELECT 
    F.nome,
    F.situacao,
    M.modelo,
    M.marca,
    M.sistemaOperacional,
    M.situacao,
    C.nome,
    A.causa,
    R.enderecoIPV4,
    R.usoAtual,
    R.dataHora
FROM Funcionario AS F
JOIN Maquina AS M ON F.idFuncionario = M.fkFuncionario
JOIN Componente AS C ON M.idMaquina = C.fkMaquina
JOIN Alerta AS A ON 1 = 1  -- Faz um "CROSS JOIN" para todos os alertas
JOIN Registro AS R ON C.idComponente = R.fkComponente;

select * from Usuario;