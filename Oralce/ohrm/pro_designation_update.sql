CREATE OR REPLACE procedure OHRM.p_desig_up
as
cursor cur_desig_up is
    select emp_id,desig_no
    from emp_tbl
    where emp_type is null 
        and desig_no is not null
       ;

 var_emp_type varchar2(1);
 var_work_grp varchar2(1);
begin

For CU in cur_desig_up loop
     var_emp_type := 0;
     var_work_grp := 0;
     
    SELECT DESIG_TBL.EMP_TYPE,DESIG_TBL.WORK_GRP
    into var_emp_type,var_work_grp
    FROM DESIG_TBL
    where DESIG_TBL.DESIG_NO=CU.desig_no;

    BEGIN

    update emp_tbl
    set EMP_TYPE=var_emp_type,
        WORK_GRP=var_work_grp
    where emp_id=CU.emp_id;
        

    END;
  end loop;

commit;
 exception
  when others then
    raise_application_error(-20001, 'Error Occured on procedure p_desig_up');
rollback;
end;
/
