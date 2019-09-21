

select * from billbook where house_no like'49-097-2008-%'


BEGIN
Declare @HouseNo_up varchar(74)
Declare @hsl varchar(15)
declare @v_road varchar(4)
declare @v_area varchar(3)

DECLARE Cal_cursor CURSOR FOR

select house_no,holding_sl,
	area,
	road_no,
	ltrim(rtrim(ward_no))+'-'+ltrim(rtrim(area))+'-'+ltrim(rtrim(road_no))+'-'+ holding_new+'-'+appt_fl Holding_up
from hv_holding01 
where road_no='2008'and area='097';
Open Cal_Cursor

--select * from hv_assessment01

--sp_help hv_assessment01
FETCH NEXT FROM Cal_Cursor
into @hsl,@v_area,@v_road,@HouseNo_up

WHILE @@FETCH_STATUS = 0
Begin


--select master.dbo.kccdecrypt(d260f28,11) from data260


	update data260 
		set D260F1=master.dbo.kccencrypt(@HouseNo_up,11),
			d260f28=master.dbo.kccencrypt('097',11),
			d260f3=master.dbo.kccencrypt('2008',11)
		where D260F26=@hsl;

	update data265 
		set D265F1=master.dbo.kccencrypt(@HouseNo_up,11)
		where D265F13=@hsl;
	update data267
		set D267F2=master.dbo.kccencrypt(@HouseNo_up,11)
		where D267F12=@hsl;

	update data273 
		set D273F1=master.dbo.kccencrypt(@HouseNo_up,11)
		where D273F8=@hsl;

	FETCH NEXT FROM Cal_Cursor
	into @hsl,@v_area,@v_road,@HouseNo_up
End
CLOSE Cal_Cursor
DEALLOCATE Cal_Cursor
END
