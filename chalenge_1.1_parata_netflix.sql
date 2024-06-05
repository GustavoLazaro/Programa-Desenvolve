-- PASSO 2: HIGIENIZAÇÃO DE DADO
-- Nome da tabela: prata_netflix
-- Inserir os dados na tabela acima com as seguintes regras:
-- - Campos que possuem valores vazios devem ter esses valores substituídos pela string: “Desconhecido”
-- - O campo description pode ter somente 120 caracteres, portanto, caso haja mais, considerar somente os primeiros 120
-- - O campo show_id precisa ser do tipo integer na nova tabela, para isso antes da inserção na tabela a string: “s” deve ser removida;
-- - O campo release_year deve ser inteiro, caso o campo esteja vazio, considerar o valor 9999
DROP TABLE prata_netflix;
CREATE TABLE prata_netflix(
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

INSERT INTO prata_netflix
SELECT
	REPLACE(show_id, 's', '')::INTEGER,
	COALESCE(NULLIF(type, ''), 'Desconhecido'),
	COALESCE(NULLIF(title, ''), 'Desconhecido'),
	COALESCE(NULLIF(director, ''), 'Desconhecido'),
	COALESCE(NULLIF(desc_cast, ''), 'Desconhecido'),
	COALESCE(NULLIF(country, ''), 'Desconhecido'),
	COALESCE(NULLIF(date_added, ''), 'Desconhecido'),
	COALESCE(NULLIF(release_year, '')::INTEGER, 9999),
	COALESCE(NULLIF(rating, ''), 'Desconhecido'),
	COALESCE(NULLIF(duration, ''), 'Desconhecido'),
	COALESCE(NULLIF(listed_in, ''), 'Desconhecido'),
	COALESCE(NULLIF(SUBSTRING(description FROM 1 FOR 120), ''), 'Desconhecido')
FROM bronze_netflix;

SELECT * FROM prata_netflix;
	