CREATE OR REPLACE FUNCTION your_function_name(json_params JSONB)
RETURNS TABLE (ORDER_ID int, ORG_ID int, ACCESSION_NO varchar(30)) AS $$
DECLARE
  ORDER_ID INTEGER;
  EXAM_ID INTEGER;
 ACCESSION_NO varchar(30);
BEGIN
  -- Extract org_id
  ORDER_ID := (json_params ->> 'ORDER_ID')::INTEGER;
  
  -- Extract user_id
  EXAM_ID := (json_params ->> 'EXAM_ID')::INTEGER;
 
 ACCESSION_NO := (json_params ->> 'ACCESSION_NO')::varchar(30);

  -- Perform the SELECT query using the extracted parameters
  RETURN QUERY
    SELECT "ORDER_ID" ,"ORG_ID" ,"ACCESSION_NO" 
    FROM "RIS_ORDERDTL"
    WHERE "ORDER_ID"  = ORDER_ID AND "EXAM_ID"  = EXAM_ID AND "ACCESSION_NO" =ACCESSION_NO;

END;
$$ LANGUAGE plpgsql;


SELECT * FROM your_function_name('{"EXAM_ID": 571,"ORDER_ID": 272514,"ACCESSION_NO":"20022002"}');
--DROP FUNCTION your_function_name


SELECT "ORDER_ID","ACCESSION_NO","EXAM_ID"  FROM "RIS_ORDERDTL" WHERE "ORDER_ID" = ? AND  "EXAM_ID" =?