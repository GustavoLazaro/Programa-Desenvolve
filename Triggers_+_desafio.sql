/*
Caso o instrutor inserido receba acima da média, cancele a instrução, ou seja, não permita que a inserção ocorra.

Desfaça o desafio anterior. Caso o instrutor inserido receba mais do que 100% dos instrutores existentes, modifique 
a inserção para que ele passe a receber o mesmo que o instrutor mais bem pago

Lembrando que modificar ou cancelar a inserção só é possível na definição do trigger no momento BEFORE. ;-)*/


CREATE TABLE LOG_INSTRUTORES (
	ID SERIAL PRIMARY KEY,
	INFORMACAO VARCHAR(255),
	MOMENTO_CRIACAO TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

DROP FUNCTION CRIA_INSTRUTOR;
CREATE OR REPLACE FUNCTION CRIA_INSTRUTOR() RETURNS TRIGGER AS $$ 
	DECLARE
		MEDIA_SALARIAL DECIMAL;
		INSTRUTORES_RECEBEM_MENOS INTEGER DEFAULT 0;
		TOTAL_INSTRUTORES INTEGER DEFAULT 0;
		SALARIO DECIMAL;
		MAX_SALARIO DECIMAL;
		PERCENTUAL DECIMAL(10, 2);
	BEGIN
		SELECT AVG(INSTRUTOR.SALARIO) INTO MEDIA_SALARIAL FROM INSTRUTOR WHERE ID <> NEW.ID;

		IF NEW.SALARIO > MEDIA_SALARIAL THEN
			INSERT INTO LOG_INSTRUTORES (INFORMACAO) VALUES (NEW.NOME || ' Recebe acima da média');
		END IF;

		FOR SALARIO IN SELECT INSTRUTOR.SALARIO FROM INSTRUTOR WHERE ID <> NEW.ID LOOP
			TOTAL_INSTRUTORES := TOTAL_INSTRUTORES + 1;

			IF NEW.SALARIO > SALARIO THEN
				INSTRUTORES_RECEBEM_MENOS := INSTRUTORES_RECEBEM_MENOS + 1;
			END IF;
		END LOOP;

		PERCENTUAL = INSTRUTORES_RECEBEM_MENOS::DECIMAL / TOTAL_INSTRUTORES::DECIMAL * 100;
		
		SELECT MAX(INSTRUTOR.SALARIO) INTO MAX_SALARIO FROM INSTRUTOR WHERE ID <> NEW.ID;
		IF NEW.SALARIO > MAX_SALARIO THEN
			NEW.SALARIO := MAX_SALARIO;
		END IF;

		INSERT INTO LOG_INSTRUTORES (INFORMACAO)
			VALUES (NEW.NOME || ' Recebe mais do que ' || PERCENTUAL || '% da grade de instrutores');
		
		RETURN NEW;
	END;
$$ LANGUAGE PLPGSQL;

DROP TRIGGER CRIA_LOG_INSTRUTORES ON INSTRUTOR;
CREATE TRIGGER CRIA_LOG_INSTRUTORES
    BEFORE INSERT ON INSTRUTOR
    FOR EACH ROW
    EXECUTE FUNCTION CRIA_INSTRUTOR();


SELECT * FROM INSTRUTOR;
SELECT * FROM LOG_INSTRUTORES;

INSERT INTO INSTRUTOR (NOME, SALARIO) VALUES ('Fulano de tal 3', 1500);