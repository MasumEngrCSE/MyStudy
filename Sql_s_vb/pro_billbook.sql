create procedure hsp_billbook_rpt
@ward	varchar(5),
@area	varchar(5),
@road	varchar(5),
@fy	varchar(2),
@YearTitle varchar(10),
@UserName	varchar(30),
@ModificationDate varchar(30),
@ModificationNo char(4),
@Gaps varchar(50),
@Gaps_No int
as
begin

declare @House_No varchar(74)


DECLARE cur_billbook CURSOR FOR
Select a.House_No,b.FY_Qtr 
From hv_Holding01 As a 
	Left Outer Join hv_Gap_Payment As b 
         On a.House_Number=b.House_Number
Where a.ward_no=@ward and a.area=@area and a.road_no=@road;

OPEN cur_billbook
FETCH NEXT FROM cur_billbook
into @House_No,@Ward,@FY_No,@YearTitle,@UserName,@ModificationDate,@ModificationNo,@Gaps,@Gaps_No
WHILE @@FETCH_STATUS = 0
BEGIN


------------------
select @v_count= count(*) from billbook where substring(House_No,1,11)=@ward+'-'+@area+'-'+@road;
------------------

if @v_count=0
  begin
    INSERT into billbook
    Values
    (	@House_No,
	@Ward,
	@FY_No,
	@YearTitle,
	@UserName,
	@ModificationDate,
	@ModificationNo,
	@Gaps,
	@Gaps_No
    );

  end
else
 begin
  UPDATE billbook
    Set House_No=@House_No,
	Ward=@Ward,
	FY_No=@FY_No,
	YearTitle=@YearTitle,
	UserName=@UserName,
	ModificationDate=@ModificationDate,
	ModificationNo=@ModificationNo,
	Gaps=@Gaps,
	Gaps_No=@Gaps_No
    Where substring(House_No,1,11)=@ward+'-'+@area+'-'+@road;
  end
	
   FETCH NEXT FROM cur_billbook
	into @House_No,@Ward,@FY_No,@YearTitle,@UserName,@ModificationDate,@ModificationNo,@Gaps,@Gaps_No
END
CLOSE cur_billbook
DEALLOCATE cur_billbook

end


sp_help billbook

