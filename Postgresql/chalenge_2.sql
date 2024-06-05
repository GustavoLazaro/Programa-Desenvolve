CREATE VIEW vw_ouro_netflix_relatorio_ano_lancamento AS
	SELECT release_year AS ano_lancamento, 
		COUNT (release_year)::INTEGER AS qtd_titulos
		FROM prata_netflix
		GROUP BY release_year
		ORDER BY release_year DESC;

SELECT * FROM vw_ouro_netflix_relatorio_ano_lancamento;


CREATE VIEW vw_ouro_netflix_seriados AS
	SELECT * FROM prata_netflix
	WHERE type = 'TV Show'
	ORDER BY release_year, title;
	
SELECT * FROM vw_ouro_netflix_seriados;


CREATE VIEW vw_ouro_netflix_filmes AS
	SELECT * FROM prata_netflix
	WHERE type = 'Movie'
	ORDER BY release_year, title;
	
SELECT * FROM vw_ouro_netflix_filmes;


CREATE VIEW vw_ouro_netflix_relatorio_titulos AS
	SELECT release_year AS ano_lancamento,
		type AS descricao_tipo,
		country AS nome_pais_origem,
		rating AS categoria_classificacao_indicativa,
		COUNT (release_year)::INTEGER AS qtd_titulos
		FROM prata_netflix
		GROUP BY release_year, type, country, rating
		ORDER BY release_year DESC,
				 type,
				 country,
				 qtd_titulos DESC;
				 
SELECT * FROM vw_ouro_netflix_relatorio_titulos;