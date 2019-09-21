-- drop FUNCTION InWord
-- go

CREATE FUNCTION InWord
(@num numeric)
RETURNS varchar(500)
AS

    BEGIN
    DECLARE @cNum numeric
    SET @cNum = @num

    DECLARE @tblNum TABLE
    (Num int, NumStr varchar(20))
    INSERT INTO @tblNum
    SELECT 1, ' GK' UNION SELECT 2, ' `yB' UNION    SELECT 3, ' wZb' UNION SELECT 4, ' Pvi' UNION
    SELECT 5, ' cuvP' UNION SELECT 6, ' Qq' UNION    SELECT 7, ' mvZ' UNION SELECT 8, ' AvU' UNION
    SELECT 9, ' bq' UNION SELECT 10, ' `k' UNION    SELECT 11, ' GMvi' UNION SELECT 12, ' evi' UNION
    SELECT 13, ' �Zi' UNION SELECT 14, ' �P��' UNION    SELECT 15, ' c�bi' UNION SELECT 16, ' �lvj' UNION
    SELECT 17, ' m�Zi' UNION SELECT 18, ' AvVvi' UNION    SELECT 19, ' Ewbk' UNION SELECT 20, ' wek' UNION
    SELECT 21, ' GKzk' UNION SELECT 22, ' evBk' UNION    SELECT 23, ' �ZBk' UNION SELECT 24, ' Pwe�k' UNION
    SELECT 25, ' cuwPk' UNION SELECT 26, ' Qvwe�k' UNION    SELECT 27, ' mvZvk' UNION SELECT 28, ' AvVvk' UNION
    SELECT 29, ' Ebw�k' UNION SELECT 30, ' w�k' UNION    SELECT 31, ' GKw�k' UNION SELECT 32, ' ew�k' UNION
    SELECT 33, ' �Zw�k' UNION SELECT 34, ' �P�w�k' UNION    SELECT 35, ' cqw�k' UNION SELECT 36, ' Qw�k' UNION
    SELECT 37, ' mvBw�k' UNION SELECT 38, ' AvUw�k' UNION    SELECT 39, ' DbPwj�k' UNION SELECT 40, ' Pwj�k' UNION
    SELECT 41, ' GKPwj�k' UNION SELECT 42, ' weqvwj�k' UNION    SELECT 43, ' �ZZvwj�k' UNION SELECT 44, ' Pzqvwj�k' UNION
    SELECT 45, ' cqZvwj�k' UNION SELECT 46, ' �QPwj�k' UNION    SELECT 47, ' mvZPwj�k' UNION SELECT 48, ' AvUPwj�k' UNION
    SELECT 49, ' Ebc�vk' UNION SELECT 50, ' c�vk' UNION    SELECT 51, ' GKvb�' UNION SELECT 52, ' evqvb�' UNION
    SELECT 53, ' wZ�vb�' UNION SELECT 54, ' Pzqvb�' UNION    SELECT 55, ' c�vb�' UNION SELECT 56, ' Qv�vb�' UNION
    SELECT 57, ' mvZvb�' UNION SELECT 58, ' AvUvb�' UNION    SELECT 59, ' DblvU' UNION SELECT 60, ' lvU' UNION
    SELECT 61, ' GKlw�' UNION SELECT 62, ' evlw�' UNION    SELECT 63, ' �Zlw�' UNION SELECT 64, ' �P�lw�' UNION
    SELECT 65, ' cqlw�' UNION SELECT 66, ' �Qlw�' UNION    SELECT 67, ' mvZlw�' UNION SELECT 68, ' AvUlw�' UNION
    SELECT 69, ' Dbm�i' UNION SELECT 70, ' m�i' UNION    SELECT 71, ' GKv�i' UNION SELECT 72, ' evnv�i' UNION
    SELECT 73, ' �Znv�i' UNION SELECT 74, ' Pzqv�i' UNION    SELECT 75, ' cPv�i' UNION SELECT 76, ' wQqv�i' UNION
    SELECT 77, ' mvZv�i' UNION SELECT 78, ' AvUv�i' UNION    SELECT 79, ' DbAvwk' UNION SELECT 80, ' Avwk' UNION
    SELECT 81, ' GKvwk' UNION SELECT 82, ' weivwk' UNION    SELECT 83, ' wZivwk' UNION SELECT 84, ' Pzivwk' UNION
    SELECT 85, ' cuPvwk' UNION SELECT 86, ' wQqvwk' UNION    SELECT 87, ' mvZvwk' UNION SELECT 88, ' AvUvwk' UNION
    SELECT 89, ' Dbbe�B' UNION SELECT 90, ' be�B' UNION    SELECT 91, ' GKvbe�B' UNION SELECT 92, ' weivbe�B' UNION
    SELECT 93, ' wZivbe�B' UNION SELECT 94, ' Pzivbe�B' UNION    SELECT 95, ' cuPvbe�B' UNION SELECT 96, ' wQqvbe�B' UNION
    SELECT 97, ' mvZvbe�B' UNION SELECT 98, ' AvUvbe�B' UNION    SELECT 99, ' wbivbe�B'

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
	set @Word = Master.dbo.InWord(@Crore*100)
	set @Word = substring(@Word,1,len(@Word)-5) + ' �KvwU'
  end
if @Lac <> 0 
  begin
	set @Text = ''
	select @Text =NumStr from @tblNum where Num = @Lac
	set @Word = @Word + @Text + ' jvL'
  end
if @Thou <> 0
  begin
	set @Text = ''
	select @Text =NumStr from @tblNum where Num = @Thou
	set @Word = @Word + @Text + ' nvRvi'
  end
if @Hund <> 0
  begin
	set @Text = ''
	select @Text =NumStr from @tblNum where Num = @Hund
	set @Word = @Word + @Text + ' kZ'
  end
if @Unit <> 0
  begin
	set @Text = ''
	select @Text =NumStr from @tblNum where Num = @Unit
	set @Word = @Word + @Text
  end
if ltrim(@Word) <> ''
  begin
	set @Word = @Word + ' UvKv'
  end
if @Deci <> 0
  begin
	set @Text = ''
	select @Text =NumStr from @tblNum where Num = @Deci
	set @Word = @Word + @Text + ' cqmv'
  end

RETURN @Word
END