
--select dbo.F_numstr(129.78)

ALTER  FUNCTION [dbo].[F_numstr2]
(
@P_num	varchar(20)
--@P_num	decimal(18,4)
)
RETURNS VARCHAR(500)
AS
BEGIN
declare @str_len int
declare @tmp int
declare @tmp2 int
declare @isval int
declare @rval varchar(500)
declare @v_str varchar(500)
declare @v_strp varchar(500)
declare @v_str5 varchar(90)

declare @v_numstr varchar(20)
declare @num_taka	varchar(20)
declare @num_poisa varchar(20)
declare @len int
declare @i int
declare @istaka int
declare @tmps varchar
declare @v_numstr1 varchar(20)
declare @v_negativecheck decimal
-----------------------
declare @num_tbl table
(
nid	int,
ntitle	varchar(15)
)
---------------------------------------------
set @v_numstr=CONVERT(varchar,@P_num)
set @v_negativecheck=@P_num
--set @v_numstr=@P_num
set @v_str=''
insert into @num_tbl(nid,ntitle)
select 0,'zero'		union	select 1,'One'			union	select 2,'Two'			union	select 3,'Three'	union
select 4,'Four'		union	select 5,'Five'			union	select 6,'Six'			union	select 7,'Seven'	union
select 8,'Eight'	union	select 9,'Nine'			union	select 10,'Ten'			union	select 11,'Eleven'	union
select 12,'Twelve'	union	select 13,'Thirteen'	union	select 14,'Tourteen'	union	select 15,'Fifteen'	union
select 16,'Sixteen' union	select 17,'Seventeen'	union	select 18,'Eighteen'	union	select 19,'Nineteen'union
select 20,'Twenty'	union	select 30,'Thirty'		union	select 40,'Forty'		union	select 50,'Fifty'	union
select 60,'Sixty'	union	select 70,'Seventy'		union	select 80,'Eighty'		union	select 90,'Ninety' 
----divided taka and poisa -----------------------
begin
--declare @numb decimal(18,4)
declare @num varchar(20)
-----------
set @i=1
--set @numb=911896535887.1234
set @num=@v_numstr
set @len=LEN(@num)
set @istaka=1
set @num_taka=''
set @num_poisa=''
while(@len>=@i)
begin
	set @tmps=substring(@num,@i,1)
	if(@tmps='.')
	begin
		set @istaka=0
	end
	-------------------------
	if(@tmps!='.')
	begin
		if @istaka=1	
		begin
			set @num_taka=@num_taka+@tmps
		end
		else
		begin
			set @num_poisa=@num_poisa+@tmps
		end
	end
	-----------------------------
	set @i=@i+1
end
	set @v_numstr=@num_taka
end
-------taka--------------------
---step1---------------------------------------------
SET @str_len = LEN(@v_numstr)
if @str_len=12
begin
		set @tmp=substring(@v_numstr,1,2)
		if @tmp>0
		begin
			select @v_str=@v_str+' '+ntitle from @num_tbl where nid=@tmp;
			select @isval=COUNT(*) from @num_tbl where nid=@tmp;
			if @isval=0
			begin
				select @tmp2=max(nid) from @num_tbl where nid<@tmp
				select @tmp=@tmp-@tmp2
				
				select @v_str=@v_str+' '+ntitle from @num_tbl where nid=@tmp2
				select @v_str=@v_str+' '+ntitle from @num_tbl where nid=@tmp
			end
		end
		set @v_str=@v_str+' '+'Thousand'
		set @v_numstr=substring(@v_numstr,3,10)
end
----------------
SET @str_len = LEN(@v_numstr)
if @str_len=11
begin
		set @tmp=substring(@v_numstr,1,1)
		select @v_str=@v_str+' '+ntitle+' Thousand' from @num_tbl where nid=@tmp
		set @v_numstr=substring(@v_numstr,2,10)
end
----------------
SET @str_len = LEN(@v_numstr)
if @str_len=10
begin
	set @tmp=substring(@v_numstr,1,3)
	set @v_numstr1=@tmp
	----------
	set @str_len=len(@v_numstr1)
	if @str_len=3
	begin
		set @tmp=substring(@v_numstr,1,1)
		if @tmp>0
		begin
			select @v_str=@v_str+' '+ntitle+' Hundred' from @num_tbl where nid>0 and nid=@tmp;
		end
		set @v_numstr1=substring(@v_numstr1,2,2)
	end
	-----------------------------------------
	set @str_len=len(@v_numstr1)
	if @str_len=2
	begin
		set @tmp=@v_numstr1
		if @tmp>0
		begin
			-------
			select @v_str=@v_str+' '+ntitle from @num_tbl where nid=@tmp;
			select @isval=COUNT(*) from @num_tbl where nid=@tmp;
			if @isval=0
			begin
				select @tmp2=max(nid) from @num_tbl where nid<@tmp
				select @tmp=@tmp-@tmp2
				
				select @v_str=@v_str+' '+ntitle from @num_tbl where nid=@tmp2
				select @v_str=@v_str+' '+ntitle from @num_tbl where nid=@tmp
			end
			-------
		end
	end
	----------
	set @v_str=@v_str+' Crore'
	set @v_numstr=substring(@v_numstr,4,7)
end

--step2----------------------------------------------
SET @str_len = LEN(@v_numstr)
if @str_len=9
begin
	set @tmp=substring(@v_numstr,1,2)
	if @tmp>0
	begin
		-------
		select @v_str=@v_str+' '+ntitle from @num_tbl where nid=@tmp;
		select @isval=COUNT(*) from @num_tbl where nid=@tmp;
		if @isval=0
		begin
			select @tmp2=max(nid) from @num_tbl where nid<@tmp
			select @tmp=@tmp-@tmp2
			
			select @v_str=@v_str+' '+ntitle from @num_tbl where nid=@tmp2
			select @v_str=@v_str+' '+ntitle from @num_tbl where nid=@tmp
		end
		-------
		--select @v_str=@v_str+' '+@v_str5+' Crore'
		select @v_str=@v_str+' Crore'
	end
	set @v_numstr=substring(@v_numstr,3,7)
end
------------------------------------------------
SET @str_len = LEN(@v_numstr)
if @str_len=8
begin
	set @tmp=substring(@v_numstr,1,1)
	if @tmp>0
	begin
		select @v_str=ntitle+' Crore' from @num_tbl where nid>0 and nid=@tmp;
	end
	set @v_numstr=substring(@v_numstr,2,7)
end
----------------------------------------------
SET @str_len = LEN(@v_numstr)
if @str_len=7
begin
	set @tmp=substring(@v_numstr,1,2)
	if @tmp>0
	begin
		-------
		select @v_str=@v_str+' '+ntitle from @num_tbl where nid=@tmp;
		select @isval=COUNT(*) from @num_tbl where nid=@tmp;
		if @isval=0
		begin
			select @tmp2=max(nid) from @num_tbl where nid<@tmp
			select @tmp=@tmp-@tmp2
	
			select @v_str=@v_str+' '+ntitle from @num_tbl where nid=@tmp2
			select @v_str=@v_str+' '+ntitle from @num_tbl where nid=@tmp
		end
		-------
		select @v_str=@v_str+' Lac'
	end
	set @v_numstr=substring(@v_numstr,3,5)
end
----------------------------------------------
SET @str_len = LEN(@v_numstr)
if @str_len=6
begin
	set @tmp=substring(@v_numstr,1,1)
	if @tmp>0
	begin
		select @v_str=ntitle+' Lac' from @num_tbl where nid>0 and nid=@tmp;
	end
	set @v_numstr=substring(@v_numstr,2,5)
end
----------------------------------------------
SET @str_len = LEN(@v_numstr)
if @str_len=5
begin
	set @tmp=substring(@v_numstr,1,2)
	if @tmp>0
	begin
	-------
	select @v_str=@v_str+' '+ntitle from @num_tbl where nid=@tmp;
	select @isval=COUNT(*) from @num_tbl where nid=@tmp;
	if @isval=0
	begin
		select @tmp2=max(nid) from @num_tbl where nid<@tmp
		select @tmp=@tmp-@tmp2
		
		select @v_str=@v_str+' '+ntitle from @num_tbl where nid=@tmp2
		select @v_str=@v_str+' '+ntitle from @num_tbl where nid=@tmp
	end
	-------
	select @v_str=@v_str+' Thousand'
	end
	set @v_numstr=substring(@v_numstr,3,3)
end
----------------------------------------
SET @str_len = LEN(@v_numstr)
if @str_len=4
begin
	set @tmp=substring(@v_numstr,1,1)
	if @tmp>0
	begin
	select @v_str=ntitle+' Thousand' from @num_tbl where nid>0 and nid=@tmp;
	end
	set @v_numstr=substring(@v_numstr,2,3)
end
-----------------------------------------
set @str_len=len(@v_numstr)
if @str_len=3
begin
	set @tmp=substring(@v_numstr,1,1)
	if @tmp>0
	begin
		select @v_str=@v_str+' '+ntitle+' Hundred' from @num_tbl where nid>0 and nid=@tmp;
	end
	set @v_numstr=substring(@v_numstr,2,2)
end
-----------------------------------------
set @str_len=len(@v_numstr)
if @str_len=2
begin
	set @tmp=@v_numstr
	if @tmp>0
	begin
		select @v_str=@v_str+' '+ntitle from @num_tbl where nid=@tmp;
		select @isval=COUNT(*) from @num_tbl where nid=@tmp;
		if @isval=0
		begin
			select @tmp2=max(nid) from @num_tbl where nid<@tmp
			select @tmp=@tmp-@tmp2
			
			select @v_str=@v_str+' '+ntitle from @num_tbl where nid=@tmp2
			select @v_str=@v_str+' '+ntitle from @num_tbl where nid=@tmp
		end
	end
end
-------------------------------------
set @str_len=len(@v_numstr)
if @str_len=1
begin
	select @v_str=ntitle from @num_tbl where nid=@v_numstr
end
-----------------------------------
set @v_str=@v_str+' Taka'
-------end taka------------------------------------------------------------------------------
set @v_strp=''
-------poisa---------------------------------------------------------------------------------
SET @str_len = LEN(@num_poisa)
if @str_len>4
begin
	set @num_poisa=substring(@num_poisa,1,4)
end
--------------------
SET @str_len = LEN(@num_poisa)
if @str_len=4
begin
	set @tmp=substring(@num_poisa,1,1)
	if @tmp>0
	begin
		select @v_strp=ntitle+' Thousand' from @num_tbl where nid>0 and nid=@tmp;
	end
	set @num_poisa=substring(@num_poisa,2,3)
end
-----------------------------------------
set @str_len=len(@num_poisa)
if @str_len=3
begin
	set @tmp=substring(@num_poisa,1,1)
	if @tmp>0
	begin
		select @v_strp=@v_strp+' '+ntitle+' Hundred' from @num_tbl where nid>0 and nid=@tmp;
	end
	set @num_poisa=substring(@num_poisa,2,2)
end
-----------------------------------------
set @str_len=len(@num_poisa)
if @str_len=2
begin
	set @tmp=@num_poisa
	if @tmp>0
	begin
		select @v_strp=@v_strp+' '+ntitle from @num_tbl where nid=@tmp;
		select @isval=COUNT(*) from @num_tbl where nid=@tmp;
		if @isval=0
		begin
			select @tmp2=max(nid) from @num_tbl where nid<@tmp
			select @tmp=@tmp-@tmp2
			
			select @v_strp=@v_strp+' '+ntitle from @num_tbl where nid=@tmp2
			select @v_strp=@v_strp+' '+ntitle from @num_tbl where nid=@tmp
		end
	end
end
-------------------------------------
set @str_len=len(@num_poisa)
if @str_len=1
begin
	select @v_strp=ntitle from @num_tbl where nid=@num_poisa
end
----------
if @v_strp!=''
begin
	set @v_strp='And '+@v_strp+' Poisa'
end
-------end poisa--------------------
set @rval=@v_str+' '+@v_strp
if @v_negativecheck<0 
begin
	set @rval='Negative'+' '+@rval
end
------------------------------------------------------------------------
RETURN ltrim(@rval)
END