CREATE DATABASE campeonato;
USE campeonato;

-- CRIANDO AS TABELAS
CREATE TABLE times(
	codigoTime INT PRIMARY KEY IDENTITY(1, 1),
	nome VARCHAR(100) NOT NULL,
	cidade VARCHAR(100) NOT NULL,
	estadio VARCHAR(100) NOT NULL	
)

CREATE TABLE grupo(
	sigla CHAR PRIMARY KEY
)

CREATE TABLE grupos(
	codigoGrupo CHAR NOT NULL,
	codigoTime INT NOT NULL,
	
	FOREIGN KEY (codigoGrupo) REFERENCES grupo(sigla),
	FOREIGN KEY (codigoTime) REFERENCES times(codigoTime)
)

-- INSERINDO OS GRUPOS
INSERT INTO grupo (sigla) VALUES ('A'), ('B'), ('C'), ('D');

--INSERINDO OS TIMES
INSERT INTO times (nome, cidade, estadio) VALUES
('São Paulo', 'São Paulo', 'Estádio Cícero Pompeu de Toledo'),
('Corinthians', 'São Paulo', 'Neo Química Arena'),
('Palmeiras', 'São Paulo', 'Allianz Parque'),
('Santos', 'São Paulo', 'Estádio Urbano Caldeira'),

('Flamengo', 'Rio de Janeiro', 'Estádio José Bastos Padilha'),
('Vasco', 'Rio de Janeiro', 'Estádio São Januário'),
('Fluminense', 'Rio de Janeiro', 'Maracanã'),
('Botafogo', 'Rio de Janeiro', 'Estádio Nilton Santos'),

('Internacional', 'Rio Grande do Sul', 'Estádio Beira-Rio'),
('Grêmio', 'Rio Grande do Sul', 'Arena do Grêmio'),
('Chapecoense', 'Santa Catarina', 'Arena Condá'),
('Cruzeiro', 'Minas Gerais', 'Mineirão'),

('Atlético Mineiro', 'Minas Gerais', ' Estádio Raimundo Sampaio'),
('Fortaleza', 'Fortaleza', 'Estádio Alcides Santos'),
('Bahia', 'Salvador', 'Itaipava Arena Fonte Nova'),
('Ponte Preta', 'Campinas', 'Estádio Moisés Lucarelli');

