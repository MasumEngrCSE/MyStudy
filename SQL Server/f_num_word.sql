
select 'kas'+'Null'

--
select dbo.f_num_word(131100)

alter function f_num_word
(
@pval float
)
returns varchar(100)
as
begin

declare @vchk	int
declare @vspnum1 int
declare @vspnum2 int
declare @vspnum3 int

declare @n1 varchar(100)
declare @n2 varchar(100)
declare @n3 varchar(100)
declare @n4 varchar(100)
declare @n5 varchar(100)
declare @n6 varchar(100)
declare @n7 varchar(100)



declare @lenv int=len(@pval)
declare @rval varchar(100)

declare @hun varchar(20)='Hundred'
declare @Thu varchar(20)='Thousand'
declare @lac varchar(20)='Lac'
declare @Cor varchar(20)='Couror'

declare @tbl table( num int,ntitle varchar(20))

insert into @tbl
select 0,'Zero'	union		select 1,'One' union		select 2,'Two' union		select 3,'Three' union		select 4,'Four' union
select 5,'Five' union		select 6,'Six' union		select 7,'Seven' union		select 8,'Eight' union		select 9,'Nine' union 
select 10,'Ten' union		select 11,'Eleven' union	select 12,'Twelve' union	select 13,'Thirteen' union	select 14,'Fourtheen' union
select 15,'Fiftheen' union	select 16,'Sixteen' union	select 17,'Seventeen' union select 18,'Eighteen' union	select 19,'Nineteen' union
select 20,'Twenty' union	select 30,'Thirty' union	select 40,'Fourty' union	select 50,'Fifty' union		select 60,'Sixty' union
select 70,'Seventy' union	select 80,'Eightyty' union	select 90,'Ninty' 


if(@lenv=1)
	begin
		select @rval=ntitle from @tbl where num=@pval
	end
else if(@lenv=2)
	begin

		select @vchk=COUNT(num) from @tbl where num=@pval
		
		if(@vchk>0)
			begin
				select @rval=ntitle from @tbl where num=@pval
			end
		else
			begin
				select @n1=ntitle from @tbl where num=Convert(int,Convert(varchar,left(@pval,1))+'0')
				select @n2=ntitle from @tbl where num=right(@pval,1)
				set @rval=@n1+' '+@n2
			end
	end

else if(@lenv=3)
	begin
		
		select @n3=ntitle+' '+ @hun from @tbl where num=left(@pval,1)
		
		set @pval=right(@pval,2)
		select @vchk=COUNT(num) from @tbl where num=@pval
		
		if(@pval=0)
		begin
			set @rval=@n3
		end
		else
		begin
			if(@vchk>0)
				begin
					select @n2=ntitle from @tbl where num=@pval
					set @rval=@n3+' '+@n2
				end
			else
				begin
					select @n2=ntitle from @tbl where num=Convert(int,Convert(varchar,left(@pval,1))+'0')
					select @n1=ntitle from @tbl where num=right(@pval,1)
					set @rval=@n3+' '+ @n2+' '+@n1
				end
		end
	end

else if(@lenv=4)
	begin
		--First Digit
		select @n4=ntitle+' '+@Thu from @tbl where num=left(@pval,1)
		
		--2nd Digit
		set @pval=right(@pval,3)
		
		if(left(@pval,1)=0)
		begin
			set @n3=@n4
		end
		else
		begin
			
			select @n3=ntitle+' '+@hun from @tbl where num=left(@pval,1)
			set @n3=@n4+' '+@n3
		end
		--Rest 2 Digit
		set @pval=right(@pval,2)
		select @vchk=COUNT(num) from @tbl where num=@pval
		
		if(@pval=0)
		begin
			
			set @rval=@n3
		end
		else
		begin
			if(@vchk>0)
				begin
					select @n2=ntitle from @tbl where num=@pval
					--set @rval=@n3+' '+@n2
				end
			else
				begin
					select @n2=ntitle from @tbl where num=Convert(int,Convert(varchar,left(@pval,1))+'0')
					select @n1=ntitle from @tbl where num=right(@pval,1)
					--set @rval=@n3+' '+ @n2+' '+@n1
				end
		end
		
		
		set @rval=@n3+' '+ isnull(@n2,'')+' '+isnull(@n1,'')
	end
	
else if(@lenv=5)
	begin
		--First 2 Digit
		
		set @vspnum1=left(@pval,2)
		select @vchk=COUNT(num) from @tbl where num=@vspnum1
		if(@vchk>0)
			begin
				select @n4=ntitle+' '+@Thu from @tbl where num=@vspnum1
			end
		else
			begin
				select @n2=ntitle from @tbl where num=Convert(int,Convert(varchar,left(@vspnum1,1))+'0')
				select @n1=ntitle from @tbl where num=right(@vspnum1,1)
				set @n4=@n2+' '+@n1+' '+@Thu
			end
		
		--2nd Digit
		set @pval=right(@pval,3)
		
		if(left(@pval,1)>0)
		begin
			
			select @n3=ntitle+' '+@hun from @tbl where num=left(@pval,1)
			--set @n3=@n4+' '+@n3
		end
		set @n3=@n4+' '+isnull(@n3,'')
		
		--Rest 2 Digit
		set @pval=right(@pval,2)
		select @vchk=COUNT(num) from @tbl where num=@pval
		
		if(@pval>0)
		begin
			if(@vchk>0)
				begin
					select @n2=ntitle from @tbl where num=@pval
					--set @rval=@n3+' '+@n2
				end
			else
				begin
					select @n2=ntitle from @tbl where num=Convert(int,Convert(varchar,left(@pval,1))+'0')
					select @n1=ntitle from @tbl where num=right(@pval,1)
					--set @rval=@n3+' '+ @n2+' '+@n1
				end
		end
		else
		begin
			set @n2=''
			set @n1=''
		end
		
		
		set @rval=@n3+' '+ isnull(@n2,'')+' '+isnull(@n1,'')
	end


else if(@lenv=6)
	begin
	
		--Fist 1 digit convert to lac
		select @n5=ntitle+' '+@lac from @tbl where num=left(@pval,1)
		
		set @pval=RIGHT(@pval,5)
		--First 2 Digit
--2990
		if( len(@pval)>3)
		begin
			if(len(@pval)=5)  set @vspnum1=left(@pval,2)
			else	set @vspnum1=left(@pval,1)
			
			select @vchk=COUNT(num) from @tbl where num=@vspnum1
			if(@vchk>0)
				begin
					select @n4=ntitle+' '+@Thu from @tbl where num=@vspnum1
					
				end
			else
				begin
					select @n2=ntitle from @tbl where num=Convert(int,Convert(varchar,left(@vspnum1,1))+'0')
					select @n1=ntitle from @tbl where num=right(@vspnum1,1)
					set @n4=@n2+' '+@n1+' '+@Thu
				end
		end
		set @n4=@n5+' '+isnull(@n4,'')

		--2nd Digit
		set @pval=right(@pval,3)
		
		if(left(@pval,1)=0)
		begin
			set @n3=@n4
		end
		else
		begin
			
			select @n3=ntitle+' '+@hun from @tbl where num=left(@pval,1)
			set @n3=@n4+' '+@n3
		end
		--Rest 2 Digit
		set @pval=right(@pval,2)
		select @vchk=COUNT(num) from @tbl where num=@pval
		
		if(@pval=0)
		begin
			set @n2=''
			set @n1=''
			--set @rval=@n3
		end
		else
		begin
			if(@vchk>0)
				begin
					select @n2=ntitle from @tbl where num=@pval
					--set @rval=@n3+' '+@n2
				end
			else
				begin
					select @n2=ntitle from @tbl where num=Convert(int,Convert(varchar,left(@pval,1))+'0')
					select @n1=ntitle from @tbl where num=right(@pval,1)
					--set @rval=@n3+' '+ @n2+' '+@n1
				end
		end
		
		
		set @rval=@n3+' '+ isnull(@n2,'')+' '+isnull(@n1,'')
	end
	
else
begin
	set @rval='Error Print'
end


--select @rval=ntitle from @tbl where num=LEFT(@pval,1)


set @rval=@rval+' '+'Taka Only.'

return @rval
end