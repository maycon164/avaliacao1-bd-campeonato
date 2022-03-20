CREATE DATABASE campeonato;
USE campeonato;

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

insert into grupo (sigla) values ('A'), ('B'), ('C'), ('D');

insert into times (nome, cidade, estadio) VALUES
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


SELECT codigoTime FROM times ORDER BY NEWID();

----codigo jederson

CREATE TABLE registroGrupoTime

SELECT DISTINCT codigoTime, sigla FROM (SELECT codigoTime, 1 as col2 FROM times WHERE codigoTime NOT IN (1, 2, 3, 4)) AS tblA
INNER JOIN
(SELECT sigla, 1 as col2 from grupo UNION ALL SELECT sigla, 1 as col2 from grupo UNION ALL SELECT  sigla, 1 as col2 from grupo) AS tblB
ON tblA.col2 = tblB.col2
ORDER BY codigoTime, sigla, NEWID();


----- ESSA PRIMEIRA PARTE SORTEIA 3 TIMES PARA CADA GRUPO
SELECT  nome, codigoTime, sigla FROM
	(
		SELECT ROW_NUMBER() OVER (ORDER BY NEWID()) AS cont, codigoTime, nome FROM times
		WHERE codigoTime NOT IN (1, 2, 3, 4)
	) tbl1 
	INNER JOIN	
	(
		SELECT ROW_NUMBER() OVER (ORDER BY sigla) AS cont, sigla 
		FROM (SELECT sigla FROM grupo union all SELECT sigla FROM grupo union all SELECT sigla FROM grupo) AS aux
	) AS tbl2
ON tbl1.cont = tbl2.cont

---- A SEGUNDA PARTE SORTEIA OS TIMES DE ID 1, 2, 3, 4 EM CADA GRUPO  
SELECT  nome, codigoTime, sigla FROM
	(
		SELECT ROW_NUMBER() OVER (ORDER BY NEWID()) AS cont, codigoTime, nome FROM times
		WHERE codigoTime IN (1, 2, 3, 4)
	) tbl1 
	INNER JOIN	
	(
		SELECT ROW_NUMBER() OVER (ORDER BY sigla) AS cont, sigla FROM grupo
	) AS tbl2
ON tbl1.cont = tbl2.cont

			
			
------ procedure para sortear os times nos grupos
CREATE PROCEDURE sortearGrupos
AS
BEGIN
	DELETE grupos;

	----INSERINDO OS PRIMEIROS TIMES
	INSERT INTO grupos (codigoGrupo, codigoTime)
	SELECT sigla, codigoTime  FROM
		(
			SELECT ROW_NUMBER() OVER (ORDER BY NEWID()) AS cont, codigoTime, nome FROM times
			WHERE codigoTime NOT IN (1, 2, 3, 4)
		) tbl1 
		INNER JOIN	
		(
			SELECT ROW_NUMBER() OVER (ORDER BY sigla) AS cont, sigla 
			FROM (SELECT sigla FROM grupo union all SELECT sigla FROM grupo union all SELECT sigla FROM grupo) AS aux
		) AS tbl2
	ON tbl1.cont = tbl2.cont;
	
	----INSERINDO OS TIMES COM ID 1, 2, 3, 4
	INSERT INTO grupos (codigoGrupo, codigoTime)
	SELECT sigla, codigoTime FROM
		(
			SELECT ROW_NUMBER() OVER (ORDER BY NEWID()) AS cont, codigoTime, nome FROM times
			WHERE codigoTime IN (1, 2, 3, 4)
		) tbl1 
		INNER JOIN	
		(
			SELECT ROW_NUMBER() OVER (ORDER BY sigla) AS cont, sigla FROM grupo
		) AS tbl2
	ON tbl1.cont = tbl2.cont;

	SELECT t.nome, g.sigla FROM times t, grupo g, grupos gp
	WHERE t.codigoTime = gp.codigoTime 
	AND g.sigla = gp.codigoGrupo 
	ORDER BY g.sigla;
END

EXEC sortearGrupos;





