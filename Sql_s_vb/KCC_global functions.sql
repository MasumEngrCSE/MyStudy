--=========================================================================================--
--=========================================================================================--
-------------------------------------Database For KCC----------------------------------------
--=========================================================================================--
--*****************************************************************************************--
--Created By: Asadul Islam			        Last Modification Date: 05-Jul-2003--
--Created Date: 31-May-2003					    Print Date: 05-Jul-2003--	
--*****************************************************************************************--
--								       Modification No: (8)--
---------------------------------------------------------------------------------------------
--------Create the Global Functions----------------------------------------------------------
---------------------------------------------------------------------------------------------
	--------------------------------------------
	---Encryption Function----------------------
	--------------------------------------------
	Use Master
	Go
	Create Function KCCEncrypt 
	(  @InChar varchar(300), @Key tinyint )
	  Returns varchar(300)
	With Encryption
	AS
	BEGIN
	  Declare @TotChar int
	  Declare @Cnt int
	  Declare @OutChar varchar(300)
	  Set @OutChar = @InChar
	  Set @TotChar = len(@InChar)
	  Set @Cnt = 1
	
	  While @Cnt <= @TotChar
	  BEGIN
	if @Cnt > @Key
	    set @OutChar = 
		Stuff(@OutChar, @Cnt, 1, Char(Ascii(Substring(@OutChar,@Cnt,1))-@Key))
	else
	    set @OutChar = 
		Stuff(@OutChar, @Cnt, 1, Char(Ascii(Substring(@OutChar,@Cnt,1))+@Cnt-@Key))
	    Set @Cnt = @Cnt + 1
	  END
	
	  Return @OutChar
	END
	GO
	
	--------------------------------------------
	---Decryption Function----------------------
	--------------------------------------------
	Create Function KCCDecrypt 
	(  @InChar varchar(300), @Key tinyint)
	  Returns varchar(300)
	With Encryption
	AS
	BEGIN
	  Declare @TotChar int
	  Declare @Cnt int
	  Declare @OutChar varchar(300)
	  Set @OutChar = @InChar
	  Set @TotChar = len(@InChar)
	  Set @Cnt = 1
	
	  While @Cnt <= @TotChar
	  BEGIN
	if @Cnt > @Key
	    set @OutChar = 
		Stuff(@OutChar, @Cnt, 1, Char(Ascii(Substring(@OutChar,@Cnt,1))+@Key))
	else
	    set @OutChar = 
		Stuff(@OutChar, @Cnt, 1, Char(Ascii(Substring(@OutChar,@Cnt,1))- @Cnt+@Key))

	    Set @Cnt = @Cnt + 1
	  END
	
	  Return @OutChar
	END
	GO
	--------------------------------------------
	---Create ZeroFill Function-----------------
	--------------------------------------------
	Create Function ZeroFill 
	(  @InChar varchar(30), @Length tinyint )
	  Returns varchar(30)
	With Encryption
	AS
	BEGIN
	  Declare @TotChar int
	  Declare @Cnt int
	  Declare @OutChar varchar(30)
	  Set @OutChar = ''
	  Set @TotChar = len(@InChar)
	  Set @Cnt = 1
	
	  While @Cnt <= (@Length -@TotChar)
	  BEGIN
	    set @OutChar = @OutChar + '0'
	    Set @Cnt = @Cnt + 1
	  END
	
	  Return (@OutChar + @InChar)
	END
	GO
	--------------------------------------------
	---Create GetCheckDigit Function------------(Complete)
	--------(Modulus 11 Formula)---------------- ** 'X' <-> '0' Corrected

	Create Function GetCheckDigit
	(@Target Char(9))
	Returns Char(1)
	With Encryption
	AS
	BEGIN
	  Declare @m smallint
	  Declare @mTotal int
	  Declare @mRemain smallint
	  Declare @RetValue Char(1)

	  Set @m = 2
	  Set @mTotal = 0
	  While @m <= 10
	  BEGIN
	    Set @mTotal = @mTotal + convert(int,Substring(@Target, 11 - @m,1)) * @m 
	    Set @m = @m + 1
	  END

	  Set @mRemain = @mTotal % 11

	  IF @mRemain = 0
	    BEGIN
	      Set @retValue = '0'
	    END
	  ELSE
	    BEGIN
	      IF @mRemain = 1
	        BEGIN
		  Set @retValue = 'X'      
	        END
	      ELSE
	        BEGIN
		  Set @retValue = Convert(Char(1),11 - @mRemain)
	        END
	    END
	  Return @RetValue
	END
	GO
	-------------------------------------------------------------
	--------------------------------------------------------
	---Create GetCheckDigit10 Function ---------------------
	------(Modulus 10 Check Digit)--------------------------
	Create Function GetCheckDigit10
	(@Target Char(9))
	Returns Char(1)
	With Encryption
	AS
	BEGIN
	  Declare @m smallint
	  Declare @mTotal int
	  Declare @mRemain smallint
	  Declare @RetValue Char(1)

	  Declare @mA tinyint
	  Declare @mB tinyint
	  Declare @mC tinyint
	  Declare @mD tinyint
	  Declare @mE tinyint
	  Declare @mF tinyint
	  Declare @mG tinyint
	  Declare @mH tinyint
	  Declare @mI tinyint
	  
	  Set @mA = Convert(tinyint,Substring(@Target,1,1)) * 2
	  Set @mB = Convert(tinyint,Substring(@Target,2,1))

	  Set @mC = Convert(tinyint,Substring(@Target,3,1)) * 2
	  Set @mD = Convert(tinyint,Substring(@Target,4,1))

	  Set @mE = Convert(tinyint,Substring(@Target,5,1)) * 2
	  Set @mF = Convert(tinyint,Substring(@Target,6,1))

	  Set @mG = Convert(tinyint,Substring(@Target,7,1)) * 2
	  Set @mH = Convert(tinyint,Substring(@Target,8,1))

	  Set @mI = Convert(tinyint,Substring(@Target,9,1)) * 2

	  IF Len(rtrim(Convert(Char(2),@mA))) = 1 
	  BEGIN
	      Set @mTotal = @mA
	  END
	  ELSE
	  BEGIN
	      Set @mTotal = Convert(tinyint,left(rtrim(Convert(Char(2),@mA)),1)) + 
			Convert(tinyint,right(rtrim(Convert(Char(2),@mA)),1))
	  END

	  IF Len(rtrim(Convert(Char(2),@mC))) = 1 
	  BEGIN
	      Set @mTotal = @mTotal + @mC
	  END
	  ELSE
	  BEGIN
	      Set @mTotal = @mTotal + Convert(tinyint,left(rtrim(Convert(Char(2),@mC)),1))+ 
			Convert(tinyint,right(rtrim(Convert(Char(2),@mC)),1))
	  END
	
	  IF Len(rtrim(Convert(Char(2),@mE))) = 1 
	  BEGIN
	      Set @mTotal = @mTotal + @mE
	  END
	  ELSE
	  BEGIN
	      Set @mTotal = @mTotal + Convert(tinyint,left(rtrim(Convert(Char(2),@mE)),1))+ 
			Convert(tinyint,right(rtrim(Convert(Char(2),@mE)),1))
	  END

	  IF Len(rtrim(Convert(Char(2),@mG))) = 1 
	  BEGIN
	      Set @mTotal = @mTotal + @mG
	  END
	  ELSE
	  BEGIN
	      Set @mTotal = @mTotal + Convert(tinyint,left(rtrim(Convert(Char(2),@mG)),1))+ 
			Convert(tinyint,right(rtrim(Convert(Char(2),@mG)),1))
	  END

	  IF Len(rtrim(Convert(Char(2),@mI))) = 1 
	  BEGIN
	      Set @mTotal = @mTotal + @mI
	  END
	  ELSE
	  BEGIN
	      Set @mTotal = @mTotal + Convert(tinyint,left(rtrim(Convert(Char(2),@mI)),1))+ 
			Convert(tinyint,right(rtrim(Convert(Char(2),@mI)),1))
	  END

	  Set @mTotal = @mTotal + @mB + @mD + @mF + @mH

	  Set @mRemain = @mTotal % 10

	  IF @mRemain = 0
	    BEGIN
	      Set @retValue = '0'
	    END
	  ELSE
	    BEGIN
	      Set @retValue = Convert(Char(1),10 - @mRemain)
	    END
	  Return @RetValue
	END
	GO

	-------------------------------------------------------------
	-------------------------------------------------------------
	---Create SplitName Function---------------------------------
	---(Split name in First, Middle & Last Format)---------------
	Drop Procedure SplitName
	Go
	Create Procedure SplitName
	  @Name VarChar(60),
	  @First VarChar(25) OUTPUT,
	  @Middle VarChar(25) OUTPUT,
	  @Last VarChar(25) OUTPUT
	As
	  Declare @Target VarChar(60)
	  Declare @a Integer
	  Declare @b Integer
	  Set @b = 1
	  Set @Target = rtrim(@Name)
	  Set @a = len(@Name)
	
	  While @b <= @a
	  BEGIN
		if SubString(@Target,@b,1)=' ' 
		BEGIN
			Set @First = Left(@Target,@b-1)
			break
		END
		Set @b = @b + 1
	  END
	
	  Set @Target = Right(@Target,@a-@b)
		  Set @a = len(@Target)
	  Set @b = @a
	
	  While @b >= 1
	  BEGIN
		if SubString(@Target,@b,1)= ' ' 
		BEGIN
			Set @Last = Right(@Target,@a-@b)
			break
		END
		Set @b = @b - 1
	  END
	
	  Set @Middle = left(@Target,@b)
