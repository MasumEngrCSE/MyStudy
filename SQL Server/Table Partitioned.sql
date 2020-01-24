------1. Switch from a non-partitioned table to another non-partitioned table
------2. Load data by switching in: Switch from a non-partitioned table to a partition in a partitioned table
------3. Archive data by switching out: Switch from a partition in a partitioned table to a non-partitioned table
------4. Switch from a partition in a partitioned table to a partition in another partitioned table


------------------1. Switch from Non-Partitioned to Non-Partitioned


CREATE TABLE SalesSource (
  SalesDate DATE,
  Quantity INT
) ON [PRIMARY];



INSERT INTO SalesSource(SalesDate, Quantity)
SELECT DATEADD(DAY,dates.n-1,'2012-01-01') AS SalesDate, qty.n AS Quantity
FROM GetNums(DATEDIFF(DD,'2012-01-01','2016-01-01')) dates
CROSS JOIN GetNums(1000) AS qty;


CREATE TABLE SalesTarget (
  SalesDate DATE,
  Quantity INT
) ON [PRIMARY];


SELECT COUNT(*) FROM SalesSource; -- 1461000 rows
SELECT COUNT(*) FROM SalesTarget; -- 0 rows


-- Turn on statistics
SET STATISTICS TIME ON;

-- Is it really that fast...?
ALTER TABLE SalesSource SWITCH TO SalesTarget; 
-- YEP! SUPER FAST!

-- Turn off statistics
SET STATISTICS TIME OFF;


-- Verify row count after switch
SELECT COUNT(*) FROM SalesSource; -- 0 rows
SELECT COUNT(*) FROM SalesTarget; -- 1461000 rows


ALTER TABLE SalesSource SWITCH TO SalesTarget; 

ALTER TABLE SalesTarget SWITCH TO SalesSource; 


--ALTER TABLE Source SWITCH TO Target PARTITION 1
--------------2. Load data by switching in: Switch from Non-Partitioned to Partition

-- Drop objects if they already exist
IF EXISTS (SELECT * FROM sys.tables WHERE name = N'SalesSource')
  DROP TABLE SalesSource;
IF EXISTS (SELECT * FROM sys.tables WHERE name = N'SalesTarget')
  DROP TABLE SalesTarget;

CREATE PARTITION FUNCTION pfSales (DATE)
AS RANGE RIGHT FOR VALUES 
('2013-01-01', '2014-01-01', '2015-01-01');


CREATE PARTITION SCHEME psSales
AS PARTITION pfSales 
ALL TO ([Primary]);


CREATE TABLE SalesSource (
  SalesDate DATE,
  Quantity INT
) ON [PRIMARY];


INSERT INTO SalesSource(SalesDate, Quantity)
SELECT DATEADD(DAY,dates.n-1,'2012-01-01') AS SalesDate, qty.n AS Quantity
FROM GetNums(DATEDIFF(DD,'2012-01-01','2013-01-01')) dates
CROSS JOIN GetNums(1000) AS qty;



-- Create the Partitioned Target Table (Heap) on the Partition Scheme
CREATE TABLE SalesTarget (
  SalesDate DATE,
  Quantity INT
) ON psSales(SalesDate);

-- Insert test data
INSERT INTO SalesTarget(SalesDate, Quantity)
SELECT DATEADD(DAY,dates.n-1,'2013-01-01') AS SalesDate, qty.n AS Quantity
FROM GetNums(DATEDIFF(DD,'2013-01-01','2016-01-01')) dates
CROSS JOIN GetNums(1000) AS qty;


-- Verify row count before switch
SELECT COUNT(*) FROM SalesSource; -- 366000 rows
SELECT 
	pstats.partition_number AS PartitionNumber
	,pstats.row_count AS PartitionRowCount
FROM sys.dm_db_partition_stats AS pstats
WHERE pstats.object_id = OBJECT_ID('SalesTarget')
ORDER BY PartitionNumber; -- 0 rows in Partition 1, 365000 rows in Partitions 2-4


-- Turn on statistics
SET STATISTICS TIME ON;

-- Is it really that fast...?
ALTER TABLE SalesSource SWITCH TO SalesTarget PARTITION 1; 


-- NOPE! We get an error:
-- Msg 4982, ALTER TABLE SWITCH statement failed. Check constraints of source table 'SalesSource' 
-- allow values that are not allowed by range defined by partition 1 on target table 'Sales'.

-- Add constraints to the source table to ensure it only contains data with values 
-- that are allowed in partition 1 on the target table
ALTER TABLE SalesSource
WITH CHECK ADD CONSTRAINT ckMinSalesDate 
CHECK (SalesDate IS NOT NULL AND SalesDate >= '2012-01-01');

ALTER TABLE SalesSource
WITH CHECK ADD CONSTRAINT ckMaxSalesDate 
CHECK (SalesDate IS NOT NULL AND SalesDate < '2013-01-01');

-- Try again. Is it really that fast...?
ALTER TABLE SalesSource SWITCH TO SalesTarget PARTITION 1; 
-- YEP! SUPER FAST!

-- Turn off statistics
SET STATISTICS TIME OFF;


-- Verify row count after switch
SELECT COUNT(*) FROM SalesSource; -- 0 rows
SELECT 
	pstats.partition_number AS PartitionNumber
	,pstats.row_count AS PartitionRowCount
FROM sys.dm_db_partition_stats AS pstats
WHERE pstats.object_id = OBJECT_ID('SalesTarget')
ORDER BY PartitionNumber; -- 366000 rows in Partition 1, 365000 rows in Partitions 2-4

------------------3. Archive data by switching out: Switch from Partition to Non-Partitioned

--ALTER TABLE Source SWITCH PARTITION 1 TO Target
--This is usually referred to as switching out to archive data from partitioned tables:

-- Drop objects if they already exist
IF EXISTS (SELECT * FROM sys.tables WHERE name = N'SalesSource')
  DROP TABLE SalesSource;
IF EXISTS (SELECT * FROM sys.tables WHERE name = N'SalesTarget')
  DROP TABLE SalesTarget;
IF EXISTS (SELECT * FROM sys.partition_schemes WHERE name = N'psSales')
  DROP PARTITION SCHEME psSales;
IF EXISTS (SELECT * FROM sys.partition_functions WHERE name = N'pfSales')
  DROP PARTITION FUNCTION pfSales;


  -- Create the Partition Function 
CREATE PARTITION FUNCTION pfSales (DATE)
AS RANGE RIGHT FOR VALUES 
('2013-01-01', '2014-01-01', '2015-01-01');



-- Create the Partition Scheme
CREATE PARTITION SCHEME psSales
AS PARTITION pfSales 
ALL TO ([Primary]);


-- Create the Partitioned Source Table (Heap) on the Partition Scheme
CREATE TABLE SalesSource (
  SalesDate DATE,
  Quantity INT
) ON psSales(SalesDate);

-- Insert test data
INSERT INTO SalesSource(SalesDate, Quantity)
SELECT DATEADD(DAY,dates.n-1,'2012-01-01') AS SalesDate, qty.n AS Quantity
FROM GetNums(DATEDIFF(DD,'2012-01-01','2016-01-01')) dates
CROSS JOIN GetNums(1000) AS qty;


-- Create the Non-Partitioned Target Table (Heap) on the [PRIMARY] filegroup
CREATE TABLE SalesTarget (
  SalesDate DATE,
  Quantity INT
) ON [PRIMARY];


-- Verify row count before switch
SELECT 
	pstats.partition_number AS PartitionNumber
	,pstats.row_count AS PartitionRowCount
FROM sys.dm_db_partition_stats AS pstats
WHERE pstats.object_id = OBJECT_ID('Sales')
ORDER BY PartitionNumber; -- 366000 rows in Partition 1, 365000 rows in Partitions 2-4
SELECT COUNT(*) FROM SalesTarget; -- 0 rows


-- Turn on statistics
SET STATISTICS TIME ON;

-- Is it really that fast...?
ALTER TABLE SalesSource SWITCH PARTITION 1 TO SalesTarget; 
-- YEP! SUPER FAST!

-- Turn off statistics
SET STATISTICS TIME OFF;

-- Verify row count after switch
SELECT 
	pstats.partition_number AS PartitionNumber
	,pstats.row_count AS PartitionRowCount
FROM sys.dm_db_partition_stats AS pstats
WHERE pstats.object_id = OBJECT_ID('SalesSource')
ORDER BY PartitionNumber; -- 0 rows in Partition 1, 365000 rows in Partitions 2-4
SELECT COUNT(*) FROM SalesTarget; -- 366000 rows


----------------4. Switch from Partition to Partition

-- Drop objects if they already exist
IF EXISTS (SELECT * FROM sys.tables WHERE name = N'SalesSource')
  DROP TABLE SalesSource;
IF EXISTS (SELECT * FROM sys.tables WHERE name = N'SalesTarget')
  DROP TABLE SalesTarget;
IF EXISTS (SELECT * FROM sys.partition_schemes WHERE name = N'psSales')
  DROP PARTITION SCHEME psSales;
IF EXISTS (SELECT * FROM sys.partition_functions WHERE name = N'pfSales')
  DROP PARTITION FUNCTION pfSales;
 
-- Create the Partition Function 
CREATE PARTITION FUNCTION pfSales (DATE)
AS RANGE RIGHT FOR VALUES 
('2013-01-01', '2014-01-01', '2015-01-01');
 
-- Create the Partition Scheme
CREATE PARTITION SCHEME psSales
AS PARTITION pfSales 
ALL TO ([Primary]);
 
-- Create the Partitioned Source Table (Heap) on the Partition Scheme
CREATE TABLE SalesSource (
  SalesDate DATE,
  Quantity INT
) ON psSales(SalesDate);
 
-- Insert test data
INSERT INTO SalesSource(SalesDate, Quantity)
SELECT DATEADD(DAY,dates.n-1,'2012-01-01') AS SalesDate, qty.n AS Quantity
FROM GetNums(DATEDIFF(DD,'2012-01-01','2013-01-01')) dates
CROSS JOIN GetNums(1000) AS qty;

-- Create the Partitioned Target Table (Heap) on the Partition Scheme
CREATE TABLE SalesTarget (
  SalesDate DATE,
  Quantity INT
) ON psSales(SalesDate);
 
-- Insert test data
INSERT INTO SalesTarget(SalesDate, Quantity)
SELECT DATEADD(DAY,dates.n-1,'2013-01-01') AS SalesDate, qty.n AS Quantity
FROM GetNums(DATEDIFF(DD,'2013-01-01','2016-01-01')) dates
CROSS JOIN GetNums(1000) AS qty;

-- Verify row count before switch
SELECT 
	pstats.partition_number AS PartitionNumber
	,pstats.row_count AS PartitionRowCount
FROM sys.dm_db_partition_stats AS pstats
WHERE pstats.object_id = OBJECT_ID('SalesSource')
ORDER BY PartitionNumber; -- 366000 rows in Partition 1, 0 rows in Partitions 2-4
SELECT 
	pstats.partition_number AS PartitionNumber
	,pstats.row_count AS PartitionRowCount
FROM sys.dm_db_partition_stats AS pstats
WHERE pstats.object_id = OBJECT_ID('SalesTarget')
ORDER BY PartitionNumber; -- 0 rows in Partition 1, 365000 rows in Partitions 2-4

-- Turn on statistics
SET STATISTICS TIME ON;

-- Is it really that fast...?
ALTER TABLE SalesSource SWITCH PARTITION 1 TO SalesTarget PARTITION 1; 
-- YEP! SUPER FAST!

-- Turn off statistics
SET STATISTICS TIME OFF;

-- Verify row count after switch
SELECT 
	pstats.partition_number AS PartitionNumber
	,pstats.row_count AS PartitionRowCount
FROM sys.dm_db_partition_stats AS pstats
WHERE pstats.object_id = OBJECT_ID('SalesSource')
ORDER BY PartitionNumber; -- 0 rows in Partition 1-4
SELECT 
	pstats.partition_number AS PartitionNumber
	,pstats.row_count AS PartitionRowCount
FROM sys.dm_db_partition_stats AS pstats
WHERE pstats.object_id = OBJECT_ID('SalesTarget')
ORDER BY PartitionNumber; -- 366000 rows in Partition 1, 365000 rows in Partitions 2-4

SELECT message_id, text 
FROM sys.messages 
WHERE language_id = 1033
AND text LIKE '%ALTER TABLE SWITCH%';