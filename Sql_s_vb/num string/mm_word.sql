

select dbo.f_mm_numstr(123)

alter function f_mm_numstr(@strNumber varchar(25))
returns varchar(500) as
begin
declare @ConvertNumber varchar(500)
--declare @strNumber varchar(25)
declare @numstr varchar(25)
declare @tk varchar(20)
declare @paisa varchar(20)
declare @ten varchar(20)
declare @hund varchar(20)
declare @thou varchar(20)
declare @lac varchar(20)
declare @crore varchar(20)
--declare @list(100) varchar(20)
declare @length As Integer
declare @lencr As Integer
declare @pointl As Integer
declare @croreten varchar(20)
declare @crorehund varchar(20)
declare @crorethou varchar(20)
declare @crorelac varchar(20)
declare @crorecr varchar(20)
declare @tkword varchar(500)

--set @strNumber=1234

 declare @tblNum table
 (
	id int,ntitle varchar(20)
 )

    INSERT INTO @tblNum
    SELECT 1, ' one' UNION SELECT 2, ' two' UNION    SELECT 3, ' three' UNION SELECT 4, ' four' UNION
    SELECT 5, ' five' UNION SELECT 6, ' six' UNION    SELECT 7, ' seven' UNION SELECT 8, ' eight' UNION
    SELECT 9, ' nine' UNION SELECT 10, ' ten' UNION    SELECT 11, ' eleven' UNION SELECT 12, ' twelve' UNION
    SELECT 13, ' thirteen' UNION SELECT 14, ' fourteen' UNION    SELECT 15, ' fifteen' UNION SELECT 16, ' sixteen' UNION
    SELECT 17, ' seventeen' UNION SELECT 18, ' eighteen' UNION    SELECT 19, ' nineteen' UNION SELECT 20, ' twenty' UNION
    SELECT 21, ' twenty one' UNION SELECT 22, ' twenty two' UNION    SELECT 23, ' twenty three' UNION SELECT 24, ' twenty four' UNION
    SELECT 25, ' twenty five' UNION SELECT 26, ' twenty six' UNION    SELECT 27, ' twenty seven' UNION SELECT 28, ' twenty eight' UNION
    SELECT 29, ' twenty nine' UNION SELECT 30, ' thirty' UNION    SELECT 31, ' thirty one' UNION SELECT 32, ' thirty two' UNION
    SELECT 33, ' thirty three' UNION SELECT 34, ' thirty four' UNION    SELECT 35, ' thirty five' UNION SELECT 36, ' thirty six' UNION
    SELECT 37, ' thirty seven' UNION SELECT 38, ' thirty eight' UNION    SELECT 39, ' thirty nine' UNION SELECT 40, ' forty' UNION
    SELECT 41, ' forty one' UNION SELECT 42, ' forty two' UNION    SELECT 43, ' forty three' UNION SELECT 44, ' forty four' UNION
    SELECT 45, ' forty five' UNION SELECT 46, ' forty six' UNION    SELECT 47, ' forty seven' UNION SELECT 48, ' forty eight' UNION
    SELECT 49, ' forty nine' UNION SELECT 50, ' fifty' UNION    SELECT 51, ' fifty one' UNION SELECT 52, ' fifty two' UNION
    SELECT 53, ' fifty three' UNION SELECT 54, ' fifty four' UNION    SELECT 55, ' fifty five' UNION SELECT 56, ' fifty six' UNION
    SELECT 57, ' fifty seven' UNION SELECT 58, ' fifty eight' UNION    SELECT 59, ' fifty nine' UNION SELECT 60, ' sixty' UNION
    SELECT 61, ' sixty one' UNION SELECT 62, ' sixty two' UNION    SELECT 63, ' sixty three' UNION SELECT 64, ' sixty four' UNION
    SELECT 65, ' sixty five' UNION SELECT 66, ' sixty six' UNION    SELECT 67, ' sixty seven' UNION SELECT 68, ' sixty eight' UNION
    SELECT 69, ' sixty nine' UNION SELECT 70, ' seventy' UNION    SELECT 71, ' seventy one' UNION SELECT 72, ' seventy two' UNION
    SELECT 73, ' seventy three' UNION SELECT 74, ' seventy four' UNION    SELECT 75, ' seventy five' UNION SELECT 76, ' seventy six' UNION
    SELECT 77, ' seventy seven' UNION SELECT 78, ' seventy eight' UNION    SELECT 79, ' seventy nine' UNION SELECT 80, ' eighty' UNION
    SELECT 81, ' eighty one' UNION SELECT 82, ' eighty two' UNION    SELECT 83, ' eighty three' UNION SELECT 84, ' eighty four' UNION
    SELECT 85, ' eighty five' UNION SELECT 86, ' eighty six' UNION    SELECT 87, ' eighty seven' UNION SELECT 88, ' eighty eight' UNION
    SELECT 89, ' eighty nine' UNION SELECT 90, ' ninety' UNION    SELECT 91, ' ninety one' UNION SELECT 92, ' ninety two' UNION
    SELECT 93, ' ninety three' UNION SELECT 94, ' ninety four' UNION    SELECT 95, ' ninety five' UNION SELECT 96, ' ninety six' UNION
    SELECT 97, ' ninety seven' UNION SELECT 98, ' ninety eight' UNION    SELECT 99, ' ninety nine'

set @tkword = ''
set @crore = ''
set @lac = ''
set @thou = ''
set @hund = ''
set @ten = ''
set @crorecr = ''
set @crorelac = ''
set @crorethou = ''
set @crorehund = ''
set @croreten = ''
set @ConvertNumber = ''
set @lencr = 0

set @pointl = charindex('.',@strNumber)
--InStr(1, @strNumber, '.', vbTextCompare)


If @pointl > 0 
	begin
	  set @tk = substring(@strNumber, 1, @pointl - 1)
	  set @paisa = substring(@strNumber, @pointl + 1, Len(@strNumber))
	end
Else
	begin
		--set @tk = CStr(Val(@strNumber))
		set @tk = @strNumber
	end

set @length = Len(@tk)

 While @length > 0
	begin
		
	if @length > 7
		begin		set @crore = substring(@tk, 1, @length - 7)
					set @tk = substring(@tk, @length - 6, @length)
		end
                  
     else if  @length > 5
		begin
					set @lac = substring(@tk, 1, @length - 5)
					set @tk = substring(@tk, @length - 4, @length)
		end
                  
      else if   @length > 3
		begin
					set @thou = substring(@tk, 1, @length - 3)
					set @tk = substring(@tk, @length - 2, @length)
		end
                  
      else if   @length> 2
		begin
					set @hund = substring(@tk, 1, @length - 2)
					set @tk = substring(@tk, @length - 1, @length)
		end
                  
      else if @length> 0
		begin
					set @ten = @tk
					set @tk = ''
		end
                  
      
		set @length = Len(@tk)
	end
 
 If @crore != 0 And @crore < 1000000000
 begin
    
     set @lencr = Len(@crore)
     set @length = Len(@crore)
     While @length > 0
		begin
		   if @length > 7
				begin
					set @crorecr = substring(@crore, 1, @length - 7)
					set @crore = substring(@crore, @length - 6, @length)
				end
                  
         else if @length > 5
				begin
					set @crorelac = substring(@crore, 1, @length - 5)
					set @crore = substring(@crore, @length - 4, @length)
				end
         else if @length > 3
				begin
					set @crorethou = substring(@crore, 1, @length - 3)
                  set @crore = substring(@crore, @length - 2, @length)
				end
         else if @length > 2
				begin
					set @crorehund = substring(@crore, 1, @length - 2)
					set @crore = substring(@crore, @length - 1, @length)
				end
         else if @length > 0
				begin
					set @croreten = @crore
					set @crore = ''
				end
		set @length = Len(@crore)
	end
    
   end
   
   
 If @crorecr !=0 
	begin
		select @numstr=ntitle from @tblNum where id=@crorecr
		set @tkword = @tkword + @numstr + ' @crore '
    end

 If @crorelac!= 0 
	begin
		select @numstr=ntitle from @tblNum where id=@crorelac
        set @tkword = @tkword + @numstr + ' Lac '
    end
    
 If @crorethou!=0
	begin
		select @numstr=ntitle from @tblNum where id=@crorethou
        set @tkword = @tkword + @numstr + ' Thousand '
    end
  
 If @crorehund!= 0
	begin
		select @numstr=ntitle from @tblNum where id=@crorehund
		set @tkword = @tkword + @numstr + ' Hundred '
    end
    
 If @croreten != 0 
	begin
		select @numstr=ntitle from @tblNum where id=@croreten
		set @tkword = @tkword + @numstr + ' @crore '
    end

 If @croreten = 0 And @lencr > 0 
	begin
		set @tkword = @tkword + @crore
	end
 
  
 If @lac!= 0
	begin
		select @numstr=ntitle from @tblNum where id=@lac
		set @tkword = @tkword + @numstr + ' Lac '
    end
 If @thou != 0 
	begin
		select @numstr=ntitle from @tblNum where id=@thou
		set @tkword = @tkword + @numstr + ' Thousand '
	end
	
 If @hund != 0 
	begin
		select @numstr=ntitle from @tblNum where id=@hund
		set @tkword = @tkword + @numstr + ' Hundred '
	end

 If @ten != 0 
	begin
		select @numstr=ntitle from @tblNum where id=@ten
		set @tkword = @tkword + @numstr
	end
	set @ConvertNumber = @tkword + ' Taka '

If @paisa != 0 
	begin
		select @numstr=ntitle from @tblNum where id=@paisa
		set @ConvertNumber = @ConvertNumber + '   And   ' + @numstr + ' paisa '
	end


--print @ConvertNumber

return @ConvertNumber
end