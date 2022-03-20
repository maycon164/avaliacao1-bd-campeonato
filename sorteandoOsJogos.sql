USE campeonato;

CREATE TABLE jogos(
	codigoTimeA INT NOT NULL,
	codigoTimeB INT NOT NULL,
	data DATE 
)
SELECT * FROM times
SELECT * FROM grupos;

------ SELECT QUE GERA TODAS AS POSSIBILIDADES DE JOGO 1-VERSÃO
------ 128 LINHAS RETORNADAS 
CREATE DROP VIEW todosOsJogosPossiveisFail
AS

SELECT ROW_NUMBER() OVER (ORDER BY tbl1.nome) as id, tbl1.nome as timeCasa, tbl1.codigoGrupo as grupoCasa, tbl2.nome as timeFora, tbl2.codigoGrupo as grupoFora
FROM 
(
	SELECT  t2.nome, t2.codigoTime, g2.codigoGrupo FROM times t2 
	INNER JOIN grupos g2
	ON t2.codigoTime = g2.codigoTime	
)  tbl1
INNER JOIN
(
	SELECT t2.nome, t2.codigoTime, g2.codigoGrupo FROM times t2 
	INNER JOIN grupos g2
	ON t2.codigoTime = g2.codigoTime	
)  tbl2
ON tbl1.nome != tbl2.nome
AND tbl1.codigoGrupo != tbl2.codigoGrupo;

SELECT * FROM todosOsJogosPossiveis;


--- SELECT QUE GERA TODAS AS POSSIBILIDADES DE JOGOS 2-VERSÃO
--- TEM QUE SER 96 LINHAS RETORNADAS

CREATE VIEW todosOsJogosPossiveis
AS

SELECT ROW_NUMBER() OVER (ORDER BY principal.timeCasa) AS id, principal.* FROM (
	SELECT tbl1.nome as timeCasa, tbl1.codigoGrupo as grupoCasa, tbl2.nome as timeFora, tbl2.codigoGrupo as grupoFora
	FROM 
	(
		SELECT  t2.nome, t2.codigoTime, g2.codigoGrupo FROM times t2 
		INNER JOIN grupos g2
		ON t2.codigoTime = g2.codigoTime	
	)  tbl1
	INNER JOIN
	(
		SELECT t2.nome, t2.codigoTime, g2.codigoGrupo FROM times t2 
		INNER JOIN grupos g2
		ON t2.codigoTime = g2.codigoTime	
	)  tbl2
	
	ON tbl1.nome != tbl2.nome
	AND tbl1.codigoGrupo != tbl2.codigoGrupo
	AND tbl1.codigoGrupo = 'A'
	
	UNION
	
	SELECT tbl1.nome as timeCasa, tbl1.codigoGrupo as grupoCasa, tbl2.nome as timeFora, tbl2.codigoGrupo as grupoFora
	FROM 
	(
		SELECT  t2.nome, t2.codigoTime, g2.codigoGrupo FROM times t2 
		INNER JOIN grupos g2
		ON t2.codigoTime = g2.codigoTime
		WHERE g2.codigoGrupo NOT IN ('A')
	)  tbl1
	INNER JOIN
	(
		SELECT t2.nome, t2.codigoTime, g2.codigoGrupo FROM times t2 
		INNER JOIN grupos g2
		ON t2.codigoTime = g2.codigoTime
		WHERE g2.codigoGrupo NOT IN ('A')
	)  tbl2
	
	ON tbl1.nome != tbl2.nome
	AND tbl1.codigoGrupo != tbl2.codigoGrupo
	AND tbl1.codigoGrupo = 'B'
	
	UNION
	
	SELECT tbl1.nome as timeCasa, tbl1.codigoGrupo as grupoCasa, tbl2.nome as timeFora, tbl2.codigoGrupo as grupoFora
	FROM 
	(
		SELECT  t2.nome, t2.codigoTime, g2.codigoGrupo FROM times t2 
		INNER JOIN grupos g2
		ON t2.codigoTime = g2.codigoTime
		WHERE g2.codigoGrupo NOT IN ('A', 'B')
	)  tbl1
	INNER JOIN
	(
		SELECT t2.nome, t2.codigoTime, g2.codigoGrupo FROM times t2 
		INNER JOIN grupos g2
		ON t2.codigoTime = g2.codigoTime
		WHERE g2.codigoGrupo NOT IN ('A', 'B')
	)  tbl2
	
	ON tbl1.nome != tbl2.nome
	AND tbl1.codigoGrupo != tbl2.codigoGrupo
	AND tbl1.codigoGrupo = 'C'
) AS principal

---------- SÓ VERIFICANDO SE TODOS OS TIMES TEM A MESMA QUANTIDADE DE JOGOS
SELECT SUM(qtd) as nDePartidas, time, grupo FROM  (
SELECT * FROM (SELECT COUNT(timeCasa) as qtd, timeCasa as time , grupoCasa as grupo FROM todosOsJogosPossiveis 
GROUP BY timeCasa, grupoCasa ) as tbl1

UNION

SELECT * FROM  (SELECT COUNT(grupoFora) as qtd, timeFora as time, grupoFora as grupo FROM todosOsJogosPossiveis 
GROUP BY grupoFora, timeFora) as tbl2
) AS exemplo
GROUP BY time, grupo
ORDER BY grupo 

----------- GERANDO TODAS AS RODADAS ACEITAVEIS

--- 12 RODADAS
WHILE(1 = 1){
	DECLARE @query = VARCHAR(MAX),
			@idsJogoJaPegos VARCHAR()
	
	SET @query = 
	
	SELECT * FROM todosOsJogosPossiveis ORDER BY grupoCasa;
 	
	
	SELECT TOP 8 * FROM todosOsJogosPossiveis 

}










------------ procedure para organizar os jogos com as datas
SELECT * FROM jogos;

CREATE PROCEDURE organizarJogos
AS
	DECLARE @contadorRodada INT,
			@contadorPartida INT,
			@idJogoPossivel INT,
			@data DATE,
			@query VARCHAR(MAX);
	
	SET @contadorRodada = 1;
	SET @contadorPartida = 1;
	
	DECLARE @dataPossivel DATE;
	EXEC gerarDataValida '2022-03-20', @dataPossivel OUTPUT;
	
	
	WHILE @contadorRodada < 12 
		BEGIN
			
			WHILE @contadorPartida < 8
				BEGIN 
					
				END
		END

SELECT * FROM todosOsJogosPossiveis;

----------- procedure para gerar a data da proxima quarta feira ou do proximo domingo
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

---------

DECLARE @saida DATE;
DECLARE @info VARCHAR(MAX);
EXEC gerarDataValida '2022-03-25', @saida OUTPUT, @info OUTPUT;
PRINT @saida;
PRINT @info;






