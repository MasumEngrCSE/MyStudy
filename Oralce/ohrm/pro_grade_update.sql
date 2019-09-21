CREATE OR REPLACE procedure pro_grade_update
as
cursor cur_grade is
    select emp_id,salary
    from emp_tbl;

 var_grade varchar(2);
 var_grade_sl number;
begin

For CU in cur_grade loop
     var_grade := 0;
    var_grade_sl := 0;
     
	select sl_no,Grade
	into var_grade_sl,var_grade
	from grade_tbl
	where cu.salary between start_range and nvl(end_range,1000000);

    BEGIN
    update emp_tbl
    set Grade=var_grade,
        GRADE_SLNO=var_grade_sl
    where emp_id=CU.emp_id;
        
    END;
  end loop;

commit;
 exception
  when others then
    raise_application_error(-20001, 'Error Occured on procedure grade_update');
rollback;
end;
/
