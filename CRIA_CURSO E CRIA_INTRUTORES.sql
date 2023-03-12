CREATE OR REPLACE FUNCTION CRIA_CURSO (NOME_CURSO VARCHAR, NOME_CATEGORIA VARCHAR) RETURNS VOID AS $$ 
	DECLARE
		ID_CATEGORIA INTEGER;
	BEGIN
		SELECT ID INTO ID_CATEGORIA FROM CURSO_ALURA.CATEGORIA WHERE NOME = NOME_CATEGORIA;
		
		IF NOT FOUND THEN
			INSERT INTO CURSO_ALURA.CATEGORIA (NOME) VALUES (NOME_CATEGORIA) RETURNING ID INTO ID_CATEGORIA;
		END IF;
		IF NOT FOUND THEN
			INSERT INTO CURSO_ALURA.CURSO (NOME, CATEGORIA_ID) VALUES (NOME_CURSO, ID_CATEGORIA);
		END IF;
	END;
$$ LANGUAGE PLPGSQL;

SELECT CRIA_CURSO('Java', 'Programação');
SELECT * FROM CURSO_ALURA.CURSO;
SELECT * FROM CURSO_ALURA.CATEGORIA;


-- Inserir instrutores (com salários).
-- Se o salário for maior do que a média, salvar um log.
-- Salvar outro log dizendo que fulano recebe mais do que X% da grade de instrutores


CREATE TABLE LOG_INSTRUTORES (
	ID SERIAL PRIMARY KEY,
	INFORMACAO VARCHAR(255),
	MOMENTO_CRIACAO TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);


CREATE OR REPLACE FUNCTION CRIA_INSTRUTOR (NOME_INSTRUTOR VARCHAR, SALARIO_INSTRUTOR DECIMAL) RETURNS VOID AS $$ 
	DECLARE
		ID_INSTRUTOR_INSERIDO INTEGER;
		MEDIA_SALARIAL DECIMAL;
		INSTRUTORES_RECEBEM_MENOS INTEGER DEFAULT 0;
		TOTAL_INSTRUTORES INTEGER DEFAULT 0;
		SALARIO DECIMAL;
		PERCENTUAL DECIMAL(10, 2);
	BEGIN
		IF NOT FOUND THEN
			INSERT INTO INSTRUTOR (NOME, SALARIO) VALUES (NOME_INSTRUTOR, SALARIO_INSTRUTOR) RETURNING ID INTO ID_INSTRUTOR_INSERIDO;
		END IF;

		SELECT AVG(INSTRUTOR.SALARIO) INTO MEDIA_SALARIAL FROM INSTRUTOR WHERE ID <> ID_INSTRUTOR_INSERIDO;

		IF SALARIO_INSTRUTOR > MEDIA_SALARIAL THEN
			INSERT INTO LOG_INSTRUTORES (INFORMACAO) VALUES (NOME_INSTRUTOR || 'Recebe acima da média');
		END IF;

		FOR SALARIO IN SELECT INSTRUTOR.SALARIO FROM INSTRUTOR WHERE ID <> ID_INSTRUTOR_INSERIDO LOOP
			TOTAL_INSTRUTORES := TOTAL_INSTRUTORES + 1;

			IF SALARIO_INSTRUTOR > SALARIO THEN
				INSTRUTORES_RECEBEM_MENOS := INSTRUTORES_RECEBEM_MENOS + 1;
			END IF;
		END LOOP;

		PERCENTUAL = INSTRUTORES_RECEBEM_MENOS::DECIMAL / TOTAL_INSTRUTORES::DECIMAL * 100;

		INSERT INTO LOG_INSTRUTORES (INFORMACAO)
			VALUES (NOME_INSTRUTOR || ' Recebe mais do que' || PERCENTUAL || '% da grade de instrutores');
	END;
$$ LANGUAGE PLPGSQL;

SELECT * FROM INSTRUTOR;
SELECT CRIA_INSTRUTOR('fulana de tal', 1000);
SELECT * FROM LOG_INSTRUTORES;