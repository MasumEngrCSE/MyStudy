-------------------------------------------------
-------Create Database Objects for KCC-----------
--------- for Accounts Department ---------------
-------------------------------------------------
---------- Catagory Type Table ------------------
---Create data25 table---------------------------
Create Table [dbo].[data25](
	d25f1 [char] (1) NOT NULL,
	d25f2 [varchar] (30) NOT NULL,
	d25f3 [varchar] (30) NOT NULL,
	d25f4 [varchar] (30) NOT NULL,
	d25f5 [char] (4) NOT NULL
) On [Primary]
Go
---------- Catagory Table -----------------------
---Create data26 table---------------------------
Create Table [dbo].[data26](
	d26f1 [char] (2) NOT NULL,
	d26f2 [varchar] (50) NOT NULL,
	d26f3 [char] (1) NOT NULL,
	d26f4 [varchar] (30) NOT NULL,
	d26f5 [varchar] (30) NOT NULL,
	d26f6 [char] (4) NOT NULL
) On [Primary]
Go
----------- Head Table --------------------------
---Create data27 table---------------------------
Create Table [dbo].[data27](
	d27f1 [char] (2) NOT NULL,
	d27f2 [char] (2) NOT NULL,
	d27f3 [varchar] (50) NOT NULL,
	d27f4 [varchar] (30) NOT NULL,
	d27f5 [varchar] (30) NOT NULL,
	d27f6 [char] (4) NOT NULL
) On [Primary]
Go
------------Sub Head Table-----------------------
---Create data28 table---------------------------
Create Table [dbo].[data28](
	d28f1 [char] (7) NOT NULL,
	d28f2 [varchar] (50) NOT NULL,
	d28f3 [char] (1) NULL,
	d28f4 [varchar] (30) NOT NULL,
	d28f5 [varchar] (30) NOT NULL,
	d28f6 [char] (4) NOT NULL
) On [Primary]
Go
------Create data29 table Project----------------
Create Table [dbo].[data29](
	d29f1 [char] (3) NOT NULL,
	d29f2 [varchar] (50) NOT NULL,
	d29f3 [varchar] (30) NOT NULL,
	d29f4 [varchar] (30) NOT NULL,
	d29f5 [char] (4) NOT NULL
) On [Primary]
Go

------ Create table data30 table Vr Mst----------------
Create Table [dbo].[data30](
	d30f1 [varchar] (12) NOT NULL,		-- Vr_No,
	d30f2 [datetime] NOT NULL,		-- Vr_Date,
	d30f3 [Char] (1) NOT NULL,		-- Account_Type,
	d30f4 [varchar] (7) NOT NULL,		-- Rev_Account_Code,
	d30f5 [varchar] (20) NOT NULL,		-- Cheque_No,
	d30f6 [float] NOT NULL,			-- Vr_Amount,
	d30f7 [Integer] NOT NULL,		-- No_of_Tr
	d30f8 [varchar] (200) NOT NULL,		-- Vr_Note                 --New
	d30f9 [varchar] (30) NOT NULL,
	d30f10 [varchar] (30) NOT NULL,
	d30f11 [integer] NOT NULL
) On [Primary]
Go

------ Create table data31 table Vr Dtl ---------------
Create Table [dbo].[data31](
	d31f1 [varchar] (12) NOT NULL,		-- Vr_No
	d31f2 [varchar] (7) NOT NULL,		-- Account_Code,
	d31f3 [varchar] (100) NOT NULL,		-- Narration,
	d31f4 [varchar] (8) NOT NULL,		-- Sub_Vr,
	d31f5 [float] NOT NULL,			-- Vr_Amount,
	d31f6 [integer] NOT NULL,		-- Sl_No
	d31f7 [varchar] (8) NOT NULL		-- Staff_ID
) On [Primary]
Go

------Create data32 table YearNo----------------
Create Table [dbo].[data32](
	d32f1 [char] (2) NOT NULL,
	d32f2 [varchar] (10) NOT NULL,
	d32f3 [varchar] (10) NOT NULL,
	d32f4 [varchar] (30) NOT NULL,
	d32f5 [varchar] (30) NOT NULL,
	d32f6 [char] (4) NOT NULL
) On [Primary]
Go

------Create data33 table AccControl----------------
Create Table [dbo].[data33](
	d33f1 [char] (2) NOT NULL,
	d33f2 [varchar] (12) NOT NULL,
	d33f3 [varchar] (10) NOT NULL,
	d33f4 [varchar] (30) NOT NULL,
	d33f5 [varchar] (30) NOT NULL,
	d33f6 [char] (4) NOT NULL
) On [Primary]
Go

------Create data34 table budget----------------
Create Table [dbo].[data34](
	d34f1 [char] (2) NOT NULL,
	d34f2 [varchar] (7) NOT NULL,
	d34f3 [varchar] (10) NOT NULL,
	d34f4 [char] (1) NOT NULL,
	d34f5 [varchar] (30) NOT NULL,
	d34f6 [varchar] (30) NOT NULL,
	d34f7 [char] (4) NOT NULL
) On [Primary]

------Create data35 table Budget Acc Type----------------
Create Table [dbo].[data35](
	d35f1 [char] (1) NOT NULL,
	d35f2 [varchar] (4) NOT NULL,
	d35f3 [varchar] (30) NOT NULL,
	d35f4 [varchar] (30) NOT NULL,
	d35f5 [char] (4) NOT NULL
) On [Primary]
Go

--------------------------------------------------
------Create data36 table Opening Balance---------
Create Table [dbo].[data36](
	d36f1 [char] (2) NOT NULL,
	d36f2 [varchar] (7) NOT NULL,
	d36f3 [char] (10) NOT NULL,
	d36f4 [char] (1) NOT NULL,
	d36f5 [varchar] (30) NOT NULL,
	d36f6 [varchar] (30) NOT NULL,
	d36f7 [char] (4) NOT NULL
) On [Primary]
Go
------Create data37 table Acc Type----------------
Create Table [dbo].[data37](
	d37f1 [char] (1) NOT NULL,
	d37f2 [varchar] (10) NOT NULL,
	d37f3 [varchar] (30) NOT NULL,
	d37f4 [varchar] (30) NOT NULL,
	d37f5 [char] (4) NOT NULL
) On [Primary]
Go
------Create data38 table Sub_Sub_Head----------------
Create Table [dbo].[data38](
	d38f1 [char] (10) NOT NULL,		--- PK  sub(7)+ Sub_Sub(3)
	d38f2 [varchar] (100) NOT NULL,
	d38f3 [varchar] (30) NOT NULL,
	d38f4 [varchar] (30) NOT NULL,
	d38f5 [char] (4) NOT NULL
) On [Primary]
Go