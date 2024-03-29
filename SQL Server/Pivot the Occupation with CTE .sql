Pivot the Occupation column in OCCUPATIONS so that each Name is sorted alphabetically and displayed underneath its corresponding Occupation. The output column headers should be Doctor, Professor, Singer, and Actor, respectively.

Note: Print NULL when there are no more names corresponding to an occupation.

solution:

CREATE TABLE [dbo].[OCCUPATIONS](
	[Name] [varchar](50),
	[OCCUPATION] [varchar](50)
) ON [PRIMARY]
GO
INSERT [dbo].[OCCUPATIONS] ([Name], [OCCUPATION]) VALUES (N'Ashley', N'Professor')
INSERT [dbo].[OCCUPATIONS] ([Name], [OCCUPATION]) VALUES (N'Samantha', N'Actor')
INSERT [dbo].[OCCUPATIONS] ([Name], [OCCUPATION]) VALUES (N'Julia', N'Doctor')
INSERT [dbo].[OCCUPATIONS] ([Name], [OCCUPATION]) VALUES (N'Britney', N'Professor')
INSERT [dbo].[OCCUPATIONS] ([Name], [OCCUPATION]) VALUES (N'Maria', N'Professor')
INSERT [dbo].[OCCUPATIONS] ([Name], [OCCUPATION]) VALUES (N'Meera', N'Professor')
INSERT [dbo].[OCCUPATIONS] ([Name], [OCCUPATION]) VALUES (N'Priya', N'Doctor')
INSERT [dbo].[OCCUPATIONS] ([Name], [OCCUPATION]) VALUES (N'Priyanka', N'Professor')
INSERT [dbo].[OCCUPATIONS] ([Name], [OCCUPATION]) VALUES (N'Jennifer', N'Actor')
INSERT [dbo].[OCCUPATIONS] ([Name], [OCCUPATION]) VALUES (N'Ketty', N'Actor')
INSERT [dbo].[OCCUPATIONS] ([Name], [OCCUPATION]) VALUES (N'Belvet', N'Professor')
INSERT [dbo].[OCCUPATIONS] ([Name], [OCCUPATION]) VALUES (N'Naomi', N'Professor')
INSERT [dbo].[OCCUPATIONS] ([Name], [OCCUPATION]) VALUES (N'Jane', N'Singer')
INSERT [dbo].[OCCUPATIONS] ([Name], [OCCUPATION]) VALUES (N'Jenny', N'Singer')
INSERT [dbo].[OCCUPATIONS] ([Name], [OCCUPATION]) VALUES (N'Kristeen', N'Singer')
INSERT [dbo].[OCCUPATIONS] ([Name], [OCCUPATION]) VALUES (N'Christeen', N'Singer')
INSERT [dbo].[OCCUPATIONS] ([Name], [OCCUPATION]) VALUES (N'Eve', N'Actor')
INSERT [dbo].[OCCUPATIONS] ([Name], [OCCUPATION]) VALUES (N'Aamina', N'Doctor')
GO

--------------------------Query---------

with d as
(
select name ,row_number() over(order by name) as RowNum
from OCCUPATIONS
WHERE OCCUPATION = 'Doctor'
)
,p as
(
select name ,row_number() over(order by name) as RowNum
from OCCUPATIONS
WHERE OCCUPATION = 'Professor'
)
,s as
(
select name ,row_number() over(order by name) as RowNum
from OCCUPATIONS
WHERE OCCUPATION = 'Singer'
)
,a as
(
select name ,row_number() over(order by name) as RowNum
from OCCUPATIONS
WHERE OCCUPATION = 'Actor'
)

select d.name as Doctor,p.name as Professor ,s.name as Singer,a.name as Actor
from d
	full join p on p.RowNum=d.RowNum
	full join s on s.RowNum=p.RowNum
	full join a on a.RowNum=s.RowNum;

---------------------------------------------