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
    SELECT 13, ' ÜZi' UNION SELECT 14, ' ÜPäœ' UNION    SELECT 15, ' cábi' UNION SELECT 16, ' Ülvj' UNION
    SELECT 17, ' máZi' UNION SELECT 18, ' AvVvi' UNION    SELECT 19, ' Ewbk' UNION SELECT 20, ' wek' UNION
    SELECT 21, ' GKzk' UNION SELECT 22, ' evBk' UNION    SELECT 23, ' ÜZBk' UNION SELECT 24, ' Pweük' UNION
    SELECT 25, ' cuwPk' UNION SELECT 26, ' Qvweük' UNION    SELECT 27, ' mvZvk' UNION SELECT 28, ' AvVvk' UNION
    SELECT 29, ' EbwŒk' UNION SELECT 30, ' wŒk' UNION    SELECT 31, ' GKwŒk' UNION SELECT 32, ' ewŒk' UNION
    SELECT 33, ' ÜZwŒk' UNION SELECT 34, ' ÜPäwŒk' UNION    SELECT 35, ' cqwŒk' UNION SELECT 36, ' QwŒk' UNION
    SELECT 37, ' mvBwŒk' UNION SELECT 38, ' AvUwŒk' UNION    SELECT 39, ' DbPwj≠k' UNION SELECT 40, ' Pwj≠k' UNION
    SELECT 41, ' GKPwj≠k' UNION SELECT 42, ' weqvwj≠k' UNION    SELECT 43, ' ÜZZvwj≠k' UNION SELECT 44, ' Pzqvwj≠k' UNION
    SELECT 45, ' cqZvwj≠k' UNION SELECT 46, ' ÜQPwj≠k' UNION    SELECT 47, ' mvZPwj≠k' UNION SELECT 48, ' AvUPwj≠k' UNION
    SELECT 49, ' Ebc¬vk' UNION SELECT 50, ' c¬vk' UNION    SELECT 51, ' GKvbú' UNION SELECT 52, ' evqvbú' UNION
    SELECT 53, ' wZ‡vbú' UNION SELECT 54, ' Pzqvbú' UNION    SELECT 55, ' c¬vbú' UNION SELECT 56, ' Qv‡vbú' UNION
    SELECT 57, ' mvZvbú' UNION SELECT 58, ' AvUvbú' UNION    SELECT 59, ' DblvU' UNION SELECT 60, ' lvU' UNION
    SELECT 61, ' GKlw∆' UNION SELECT 62, ' evlw∆' UNION    SELECT 63, ' ÜZlw∆' UNION SELECT 64, ' ÜPälw∆' UNION
    SELECT 65, ' cqlw∆' UNION SELECT 66, ' ÜQlw∆' UNION    SELECT 67, ' mvZlw∆' UNION SELECT 68, ' AvUlw∆' UNION
    SELECT 69, ' DbmÀi' UNION SELECT 70, ' mÀi' UNION    SELECT 71, ' GKvÀi' UNION SELECT 72, ' evnvÀi' UNION
    SELECT 73, ' ÜZnvÀi' UNION SELECT 74, ' PzqvÀi' UNION    SELECT 75, ' cPvÀi' UNION SELECT 76, ' wQqvÀi' UNION
    SELECT 77, ' mvZvÀi' UNION SELECT 78, ' AvUvÀi' UNION    SELECT 79, ' DbAvwk' UNION SELECT 80, ' Avwk' UNION
    SELECT 81, ' GKvwk' UNION SELECT 82, ' weivwk' UNION    SELECT 83, ' wZivwk' UNION SELECT 84, ' Pzivwk' UNION
    SELECT 85, ' cuPvwk' UNION SELECT 86, ' wQqvwk' UNION    SELECT 87, ' mvZvwk' UNION SELECT 88, ' AvUvwk' UNION
    SELECT 89, ' DbbeüB' UNION SELECT 90, ' beüB' UNION    SELECT 91, ' GKvbeüB' UNION SELECT 92, ' weivbeüB' UNION
    SELECT 93, ' wZivbeüB' UNION SELECT 94, ' PzivbeüB' UNION    SELECT 95, ' cuPvbeüB' UNION SELECT 96, ' wQqvbeüB' UNION
    SELECT 97, ' mvZvbeüB' UNION SELECT 98, ' AvUvbeüB' UNION    SELECT 99, ' wbivbeüB'

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
	set @Word = substring(@Word,1,len(@Word)-5) + ' ÜKvwU'
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