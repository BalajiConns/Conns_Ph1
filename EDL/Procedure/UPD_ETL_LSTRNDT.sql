CREATE OR REPLACE PROCEDURE EDL_PRD.AS400.UPD_ETL_LSTRNDT("ENVR" VARCHAR(16777216), "MPPNG_NM" VARCHAR(16777216))
RETURNS VARCHAR(1000)
LANGUAGE SQL
EXECUTE AS OWNER
AS '
declare 
	edl_dbnm varchar;	
	c1 cursor for SELECT ''EDL_''||SUBSTRING(current_database(),5,4) DB;
	select_stmnt varchar;
	res resultset;
	e varchar;
	m varchar;
begin	
		OPEN c1; 		
		FETCH c1 INTO edl_dbnm;	    
		CLOSE c1;		    		
		select_stmnt := ''MERGE INTO '' || edl_dbnm || ''.AS400.ETLMPPNG_LSTRUNDT TGT  USING 
		(SELECT COUNT(1) CNT FROM ''|| edl_dbnm ||''.AS400.ETLMPPNG_LSTRUNDT WHERE UPPER(ENVIRONMENT)= UPPER(''''''||:ENVR||'''''') AND UPPER(MAPPING_NAME) = UPPER(''''''||:MPPNG_NM||'''''')) SRC
		ON SRC.CNT > 0 
		WHEN MATCHED AND UPPER(ENVIRONMENT)= UPPER(''''''||:ENVR||'''''') AND UPPER(MAPPING_NAME) = UPPER(''''''||:MPPNG_NM||'''''') THEN 
			UPDATE SET TGT.LAST_RUN_TIMESTAMP = CURRENT_TIMESTAMP()
		WHEN NOT MATCHED THEN
			INSERT (TGT.ENVIRONMENT,TGT.MAPPING_NAME,TGT.LAST_RUN_TIMESTAMP)
			VALUES (''''''||:ENVR||'''''',''''''||:MPPNG_NM||'''''',CURRENT_TIMESTAMP())'';
		res := (EXECUTE IMMEDIATE :select_stmnt);
	return ''SUCCESS'';
		--return select_stmnt;
end;
';