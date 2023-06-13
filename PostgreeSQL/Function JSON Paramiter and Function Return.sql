CREATE OR REPLACE FUNCTION functionReturn
(
json_params JSONB
)
RETURNS TABLE 
(
ORDER_ID int, 
ACCESSION_NO varchar(30),
CREATED_ON timestamp
) 
AS $$
declare
ORDERID INTEGER;
EXAM_ID INTEGER;
ACCESSION_NO varchar(30);
ORGID INTEGER;
FuntionName varchar(30);
BEGIN
 ORGID := (json_params ->> 'ORG_ID')::INTEGER;
 ORDERID := (json_params ->> 'ORDER_ID')::INTEGER;
 EXAM_ID := (json_params ->> 'EXAM_ID')::INTEGER;
 ACCESSION_NO := (json_params ->> 'AccNo')::varchar(30);
 FuntionName:= (json_params ->> 'FuntionName')::varchar(30);

---------------------------------------------------------------------------
  if FuntionName='F1' then
   RETURN QUERY 
  		SELECT *  FROM functionOrgAcc(ORGID,ACCESSION_NO);
  END IF;
 
  if FuntionName='F2' then
  RETURN QUERY	
 		SELECT *  FROM functionOrgAcc(ORGID,ACCESSION_NO);
  END if;
 

END;
$$ LANGUAGE plpgsql;

-------------------------------------------
--drop function functionReturn

SELECT * FROM functionReturn('{"FuntionName":"F2","ORG_ID": 36,"AccNo":"A000000003066595"}');
