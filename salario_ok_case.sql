DROP FUNCTION SALARIO_OK;
CREATE OR REPLACE FUNCTION SALARIO_OK(ID_INSTRUTOR INTEGER) RETURNS VARCHAR AS $$ 
	DECLARE
		INSTRUTOR INSTRUTOR;
	BEGIN
		SELECT * FROM INSTRUTOR WHERE ID = ID_INSTRUTOR INTO INSTRUTOR;
		/* Se o salário do instrutor for maior do que 300, está ok. Senão, pode aumentar.
		Se for 300 reais, então pode aumentar
		Caso contrário salário ótimo*/
		/*IF INSTRUTOR.SALARIO > 300 THEN
			RETURN 'Salário OK';
		ELSEIF INSTRUTOR.SALARIO = 300 THEN
			RETURN 'Salário pode aumentar';
		ELSE
			RETURN 'Salario está defasado';
		END IF;*/
		CASE instrutor.salario
			WHEN  100 THEN
				RETURN 'Salário muito baixo';
			WHEN  200 THEN
			    RETURN 'Salário baixo';
			WHEN 300 THEN
				RETURN 'Salário ok';
			ELSE
				RETURN 'Salário ótimo';
		END CASE;
	END;
$$ LANGUAGE PLPGSQL;

SELECT NOME, SALARIO_OK(INSTRUTOR.ID) FROM INSTRUTOR;