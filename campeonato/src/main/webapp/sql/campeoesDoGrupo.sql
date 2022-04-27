USE campeonato;

Fazer  uma  tela  de  consulta  com  os  4  grupos  e  4 Tabelas,  
que  mostrem  a  saída  (para  cadaTabela) de uma UDF (User Defined FUNCTION), 
que receba o nome do grupo, valide-o e dê aseguinte saída: 
GRUPO  (nome_time,  num_jogos_disputados*,  vitorias,  empates,  derrotas,  gols_marcados, gols_sofridos, saldo_gols**,pontos***) 
O campeão de cada grupo se dará por aquele que tiver maior número de pontos. Em caso de empate, a ordem de desempate é por número de vitórias, 
depois por gols marcados e por fim, por saldo de gols.
(Vitória = 3 pontos, Empate = 1 ponto , Derrota = 0 pontos)

CREATE FUNCTION classificar_grupo(
	@grupo VARCHAR(1)
)
RETURNS @tabela TABLE (
	nome_time				VARCHAR(100),
	jogos_disputados		INT,
	vitorias				INT,
	empates					INT, 
	derrotas				INT,
	gols_marcados			INT,
	gols_sofridos			INT,
	saldo_gols				INT,
	pontos					INT
)
AS
BEGIN
	DECLARE @nome_time				VARCHAR(100),
			@jogos_disputados		INT,
			@vitorias				INT,
			@empates				INT, 
			@derrotas				INT,
			@gols_marcados			INT,
			@gols_sofridos			INT,
			@saldo_gols				INT,
			@pontos					INT;
			
	
	--jogos disputados será sempre 12???

	
	--TODO cursor para percorrer todos os ids do times do grupo X
	--SELECT codigoTime FROM grupos WHERE codigoGrupo = 'B'
	
	DECLARE @idTime INT;

	DECLARE c_percorre_grupo CURSOR 
		FOR SELECT codigoTime FROM grupos WHERE codigoGrupo = @grupo
	OPEN c_percorre_grupo
		BEGIN 
			
			FETCH NEXT FROM c_percorre_grupo into @idTime
			
			WHILE @@FETCH_STATUS = 0
				BEGIN
					
					--TODO cursor para percorrer todos os jogos de um ID especifico
					--SELECT * FROM jogos WHERE timeCasa = 14
					--union
					--SELECT * FROM jogos WHERE timeFora = 14
					--logica que pega incrementa as vitorias, derrotas e empates
					--calcula os pontos, gols marcados, gols sofridos e saldo de gols (gols marcados - gols sofridos)
				
									
					FETCH NEXT FROM c_percorre_grupo into @idTime
				END
		END
	CLOSE c_percorre_grupo
	DEALLOCATE c_percorre_grupo
	
	
	RETURN

END

SELECT * from  classificar_grupo('D')
 

		