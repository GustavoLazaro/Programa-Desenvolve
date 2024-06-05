CREATE FUNCTION PRIMEIRA_FUNCAO() RETURNS INTEGER AS
	'SELECT (5 - 3) * 2'
LANGUAGE SQL;

SELECT PRIMEIRA_FUNCAO() AS NUMERO;

DROP FUNCTION soma_dois_numeros;

CREATE FUNCTION SOMA_DOIS_NUMEROS(INTEGER, INTEGER)
RETURNS INTEGER AS
	'SELECT $1 + $2'
LANGUAGE SQL;

SELECT soma_dois_numeros(34, 26) AS "RESULTADO";
DROP TABLE A
CREATE TABLE a (nome VARCHAR(255) NOT NULL);
DROP FUNCTION CRIA_A;
CREATE OR REPLACE FUNCTION cria_a(nome VARCHAR) RETURNS VOID AS $$
	BEGIN
		INSERT INTO a (nome) VALUES('Patrícia');
	END;
$$ LANGUAGE PLPGSQL;


SELECT CRIA_A('Viviane Ferreira');

SELECT * FROM A;

DELETE FROM A
WHERE NOME = UPPER(TRIM('gustavo hermano'))