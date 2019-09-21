
create Procedure hsp_update_last_zero
AS
BEGIN

Declare @HouseNo varchar(74)
Declare @hsl varchar(15)
Declare @p_ouseNo varchar(74)

DECLARE Cal_cursor CURSOR FOR
select  master.dbo.kccdecrypt(D260f26,11) hsl,
	rtrim(master.dbo.kccdecrypt(D260F1,11)) house_no
from data260
where right(rtrim(master.dbo.kccdecrypt(D260F1,11)),1)='-'
order by D260f26;

Open Cal_Cursor

FETCH NEXT FROM Cal_Cursor
into @hsl,@HouseNo

WHILE @@FETCH_STATUS = 0
Begin
set @p_ouseNo=@HouseNo+'0';
set @p_ouseNo=master.dbo.kccencrypt(@p_ouseNo,11)

	update data260
		set D260F1=@p_ouseNo
		where D260F13=@hsl;
	update data265
		set D265F1=@p_ouseNo
		where D265f13=@hsl;
	update data267
		set D267F2=@p_ouseNo
		where D267F1=@hsl;

	FETCH NEXT FROM Cal_Cursor
	into @hsl,@HouseNo

End
CLOSE Cal_Cursor
DEALLOCATE Cal_Cursor
END
Go