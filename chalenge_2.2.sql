CREATE TABLE ouro_netflix_relatorio_ano_lancamento(
	ano_lancamento INTEGER NOT NULL,
	qtd_titulos INTEGER
);

INSERT INTO ouro_netflix_relatorio_ano_lancamento
	SELECT release_year AS ano_lancamento, 
		COUNT (release_year)::INTEGER AS qtd_titulos
		FROM prata_netflix
		GROUP BY release_year
		ORDER BY release_year DESC;
	
SELECT * FROM ouro_netflix_relatorio_ano_lancamento;

CREATE TABLE ouro_netflix_seriados(
  show_id      SERIAL PRIMARY KEY,
  type         VARCHAR(12) NOT NULL,
  title        VARCHAR(104) NOT NULL,
  director     VARCHAR(208),
  desc_cast    VARCHAR(771),
  country      VARCHAR(123),
  date_added   VARCHAR(19),
  release_year INTEGER NOT NULL,
  rating       VARCHAR(12),
  duration     VARCHAR(12),
  listed_in    VARCHAR(79) NOT NULL,
  description  VARCHAR(120) NOT NULL);
  
INSERT INTO ouro_netflix_seriados(
	SELECT * FROM prata_netflix
	WHERE type = 'TV Show'
	ORDER BY release_year, title
);

SELECT * FROM ouro_netflix_seriados;

CREATE TABLE ouro_netflix_filmes(
  show_id      SERIAL PRIMARY KEY,
  type         VARCHAR(12) NOT NULL,
  title        VARCHAR(104) NOT NULL,
  director     VARCHAR(208),
  desc_cast    VARCHAR(771),
  country      VARCHAR(123),
  date_added   VARCHAR(19),
  release_year INTEGER NOT NULL,
  rating       VARCHAR(12),
  duration     VARCHAR(12),
  listed_in    VARCHAR(79) NOT NULL,
  description  VARCHAR(120) NOT NULL);
  
INSERT INTO ouro_netflix_filmes(
	SELECT * FROM prata_netflix
	WHERE type = 'Movie'
	ORDER BY release_year, title
);

SELECT * FROM ouro_netflix_filmes;

CREATE TABLE ouro_netflix_relatorio_titulos(
	ano_lancamento INTEGER NOT NULL,
	descricao_tipo VARCHAR(12) NOT NULL,
	nome_pais_origem VARCHAR(123),
	categoria_classificacao_indicativa VARCHAR(12),
	qtd_titulos INTEGER
);

INSERT INTO ouro_netflix_relatorio_titulos(
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
				 qtd_titulos DESC
);

SELECT * FROM ouro_netflix_relatorio_titulos;