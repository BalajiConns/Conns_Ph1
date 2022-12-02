CREATE OR REPLACE PROCEDURE ESL_PRD.AS400.ESL_DLTA_TMPTBL("VW_NAME" VARCHAR(16777216))
RETURNS VARCHAR(200)
LANGUAGE SQL
EXECUTE AS OWNER
AS '
declare 
	esl_dbnm varchar;	
	c1 cursor for SELECT ''ESL_''||SUBSTRING(current_database(),5,4) DB;
	select_stmnt varchar;
	res resultset;
	tbl_nm varchar;
begin	
		OPEN c1; 		
		FETCH c1 INTO esl_dbnm;	    
		CLOSE c1;
	    tbl_nm := ''VW_''||SUBSTRING(VW_NAME,6,LENGTH(VW_NAME));
		select_stmnt := ''CREATE OR REPLACE TABLE '' || esl_dbnm || ''.AS400.''||tbl_nm||''  AS SELECT * FROM ''||esl_dbnm||''.AS400.''||VW_NAME||'';''; 		
	    --select_stmnt := ''INSERT OVERWRITE INTO  '' || esl_dbnm || ''.AS400.''||tbl_nm||''  SELECT * FROM ''||esl_dbnm||''.AS400.''||VW_NAME||'';'';
		res := (EXECUTE IMMEDIATE :select_stmnt);
	   --return select_stmnt;
	  return ''SUCCESS'';
end;
';