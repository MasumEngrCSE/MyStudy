alter function f_month_lastday
(
@p_date datetime
) returns datetime
as

begin
--declare @p_date datetime
declare @rday datetime
declare @m int
declare @tmp int
declare @sql varchar(20)
declare @v_year varchar(4)
--set @p_date='2013-02-01'
----------------------------------
set @m=month(@p_date)
--print @m
if (@m=1) or (@m=3) or (@m=5) or (@m=7) or (@m=8) or( @m=10) or (@m=12)
	begin
		set @sql=Convert(varchar,year(@p_date))+'-'+Convert(varchar,month(@p_date))+'-31'
		set @rday=Convert(datetime,@sql)
		
	end
else if @m=4 or @m=6 or @m=9 or @m=11
	begin
		set @sql=Convert(varchar,year(@p_date))+'-'+Convert(varchar,month(@p_date))+'-30'
		set @rday=Convert(datetime,@sql)
	end
else if @m=2
	begin
		set @tmp=year(@p_date)%4
		if @tmp=1
		begin
			set @sql=Convert(varchar,year(@p_date))+'-'+Convert(varchar,month(@p_date))+'-28'
			set @rday=Convert(datetime,@sql)
		end
		else
		begin
			set @sql=Convert(varchar,year(@p_date))+'-'+Convert(varchar,month(@p_date))+'-29'
			set @rday=Convert(datetime,@sql)
		end		
	end


--print  @rday
return @rday
end


--select convert(datetime,'2013-01-31')
--select 2013%4
