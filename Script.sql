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


-- PROCEDURE PARA SORTEAR OS GRUPOS 
-- SAO PAULO, CORINTHIANS, PALMEIRAS E SANTOS NUNCA FICAM NO MESMO GRUPO;
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

EXEC sortearGrupos 

-- VIEW PARA SORTEAR TODOS OS JOGOS POSSIVEIS
-- 96 JOGOS ONDE
-- 1) TIMES DO MESMO GRUPO NÃO SE ENFRENTAM
-- 2) O MESMO JOGO NÃO ACONTECE DUAS VEZES

DROP VIEW todosOsJogosPossiveis;
CREATE VIEW todosOsJogosPossiveis 
AS

WITH timesGrupos AS
(
		SELECT  t2.nome, t2.codigoTime, g2.codigoGrupo FROM times t2 
		INNER JOIN grupos g2
		ON t2.codigoTime = g2.codigoTime	
)
SELECT tg1.codigoTime as codigoCasa, tg1.nome as timeCasa, tg1.codigoGrupo as grupoCasa, 
		tg2.codigoTime as codigoFora, tg2.nome as timeFora, tg2.codigoGrupo as grupoFora
	FROM timesGrupos tg1 
	INNER JOIN timesGrupos tg2
	ON tg1.codigoTime <> tg2.codigoTime 
	AND tg1.codigoGrupo <> tg2.codigoGrupo 
	AND tg1.codigoTime < tg2.codigoTime;

SELECT * FROM todosOsJogosPossiveis tojp;


-- PROCEDURE PARA GERAR A DATA DA PROXIMA QUARTA FEIRA OU DOMINGO

DROP PROCEDURE gerarDataValida 

CREATE PROCEDURE gerarDataValida
	@data AS DATE,
	@saida DATE OUTPUT,
	@info AS VARCHAR(MAX) = NULL OUTPUT
AS

	DECLARE @diaDaSemana INT,
			@novaData DATE,
			@nomeDoDia VARCHAR(100);
		
	SET @novaData = @data;
	SET @diaDaSemana = DATEPART(weekday, @novaData);

	WHILE 1=1
		BEGIN
			IF @diaDaSemana = 1
				BEGIN 
					SET @nomeDoDia = 'DOMINGO';
					BREAK;
				END
			ELSE IF @diaDaSemana = 4
				BEGIN 
					SET @nomeDoDia = 'QUARTA FEIRA';
					BREAK;
				END
			ELSE	
				BEGIN		
					SET @novaData = DATEADD(DAY, 1, @novaData);
					SET @diaDaSemana = DATEPART(weekday, @novaData);
				END
		END
	SET @saida = @novaData;
	SET @info = @nomeDoDia; 

