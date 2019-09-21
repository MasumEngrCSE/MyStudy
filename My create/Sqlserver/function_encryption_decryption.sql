alter function fcc(

 @exp	varchar(20)
,@key	int
) returns varchar(100)
as
begin
--set @exp='0123456789'
--set @key=11
declare @rval	varchar(100)
declare @l int
declare @i	int
declare @gval varchar(1)
declare @rsval varchar(40)
--------------------
set @l=LEN(@exp)
set @i=0
set @rsval=''
while(@l!=0)
begin
	set @i=@i+1
	set @gval=substring(@exp, @i, 1)

	select @rsval=@rsval+Char(convert(varchar,(Ascii(@gval)+@key)))
	set @l=@l-1
end

set @rval=@rsval

return @rval
end



create function fcd(

 @exp	varchar(20)
,@key	int
) returns varchar(100)
as
begin
--set @exp='0123456789'
--set @key=11
declare @rval	varchar(100)
declare @l int
declare @i	int
declare @gval varchar(1)
declare @rsval varchar(40)
--------------------
set @l=LEN(@exp)
set @i=0
set @rsval=''
while(@l!=0)
begin
	set @i=@i+1
	set @gval=substring(@exp, @i, 1)

	select @rsval=@rsval+Char(convert(varchar,(Ascii(@gval)-@key)))
	set @l=@l-1
end

set @rval=@rsval

return @rval
end