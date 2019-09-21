

-- drop FUNCTION InWord
-- go

alter FUNCTION InWord
(@num numeric)
RETURNS varchar(500)
AS

    BEGIN
    DECLARE @cNum numeric
    SET @cNum = @num

    DECLARE @tblNum TABLE
    (Num int, NumStr varchar(20))
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

Declare @Crore	integer
Declare @Lac	int
Declare @Thou	int
Declare @Hund	int
Declare @Unit	int
Declare @Deci	int
Declare @Word	varchar(500)
Declare @Text	varchar(50)

set @Crore =floor(@cNum/1000000000)
set @Lac = right(floor(@cNum/10000000),2)
set @Thou = right(floor(@cNum/100000),2)
set @Hund = right(floor(@cNum/10000),1)
set @Unit = right(floor(@cNum/100),2)
set @Deci = right(Floor(@cNum),2)

set @Word =''
if @Crore <> 0 
  begin
	--set @Word = Master.dbo.InWord(@Crore*100)
	set @Word = substring(@Word,1,len(@Word)-5) + ' Crore'
  end
if @Lac <> 0 
  begin
	set @Text = ''
	select @Text =NumStr from @tblNum where Num = @Lac
	set @Word = @Word + @Text + ' Lac'
  end
if @Thou <> 0
  begin
	set @Text = ''
	select @Text =NumStr from @tblNum where Num = @Thou
	set @Word = @Word + @Text + ' Thousand'
  end
if @Hund <> 0
  begin
	set @Text = ''
	select @Text =NumStr from @tblNum where Num = @Hund
	set @Word = @Word + @Text + ' Hundred'
  end
if @Unit <> 0
  begin
	set @Text = ''
	select @Text =NumStr from @tblNum where Num = @Unit
	set @Word = @Word + @Text
  end
if ltrim(@Word) <> ''
  begin
	set @Word = @Word + ' taka'
  end
if @Deci <> 0
  begin
	set @Text = ''
	select @Text =NumStr from @tblNum where Num = @Deci
	set @Word = @Word + @Text + ' taka'
  end

RETURN @Word
END