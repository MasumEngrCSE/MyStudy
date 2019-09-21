
----------------------Read Instraction Care Fully:
/*
	1	Set Company ID For New Database in Variable(@CompanyID)
	2	Set Database Name To *** Import Data From Others Database ***
	3	Update All  Script (Update Script) to That Database.
	4.	Set Source Database Name in  Table (ERPUpdateScriptlog)
	
*/
declare @CompanyID int=1
------------
----------------------------------make the db Blank ---------------------------------------------------------------
-------------- First disable referential integrity
EXEC sp_MSForEachTable 'ALTER TABLE ? NOCHECK CONSTRAINT ALL'

exec sp_MSforeachtable 'ALTER TABLE ? DISABLE TRIGGER ALL'  


EXEC sp_MSForEachTable '
 IF OBJECTPROPERTY(object_id(''?''), ''TableHasForeignRef'') = 1
  DELETE FROM ?
 else 
  TRUNCATE TABLE ?
'

-- Now enable referential integrity again
EXEC sp_MSForEachTable 'ALTER TABLE ? CHECK CONSTRAINT ALL'

exec sp_MSforeachtable 'ALTER TABLE ? ENABLE TRIGGER ALL' 

------- not need this script---------------------------------------------

--Select * from CmnPermissionGroupUser a
--Join CmnPermissionGroup b on a.PermissionGroupID=b.PermissionGroupID
--Join CmnPermissionGroupDoc c on c.PermissionGroupID=b.PermissionGroupID
--Join CmnUserInfo d on d.UserID=a.UserID
--Join CmnDocList e on e.DocListID=c.DocListID
--Join CmnModuleFormCompany f on f.ModuleID=e.ModuleID

--select distinct v.ModuleName from CmnPermissionGroupUser p
--inner join CmnPermissionGroup q on p.PermissionGroupID = q.PermissionGroupID
--inner join CmnPermissionGroupDoc r on p.PermissionGroupID = r.PermissionGroupID
--join CmnUserInfo s on p.UserID = s.UserID
--join CmnDocList t on r.DocListID = t.DocListID
--join CmnModuleFormCompany u  on t.ModuleID = u.ModuleID and u.CompanyID=3
--join CmnModuleList v on u.ModuleID = v.ModuleID

--------Blank DB Script------------------
-------------------------------------------------------------------Import Data From Others Database:
----------Insert Erp Script Log information from Temp Table
--insert into ERPUpdateScriptlog(PIDUpdateScript,ScriptName,UpdateDate)
--select PIDUpdateScript,ScriptName,UpdateDate from Outpace241114.dbo.ERPUpdateScriptlog
--------------------------------------------------------------
Insert into CmnItemCategory
Select * from XERP_FAAR.dbo.CmnItemCategory
Update CmnItemCategory Set CompanyID=@CompanyID
-----------------------------------------------
Insert Into CmnUOMGroup
Select * from XERP_FAAR.dbo.CmnUOMGroup
Update CmnUOMGroup Set CompanyID=@CompanyID
-----------------------------------------------
Insert Into CmnUOM
Select * from XERP_FAAR.dbo.CmnUOM
Update CmnUOM Set CompanyID=@CompanyID
--------------------------------------------------------------
Insert into CmnItemGroup
Select * from XERP_FAAR.dbo.CmnItemGroup
Update CmnItemGroup Set CompanyID=@CompanyID
--------------------------------------------------------------
Insert Into CmnItemBrand
Select * from XERP_FAAR.dbo.CmnItemBrand 
Update CmnItemBrand Set CompanyID=@CompanyID
--------------------------------------------------------------
Insert Into CmnItemColor
Select * from XERP_FAAR.dbo.CmnItemColor 
Update CmnItemColor Set CompanyID=@CompanyID
--------------------------------------------------------------
Insert Into CmnItemCondition
Select * from XERP_FAAR.dbo.CmnItemCondition 
Update CmnItemCondition Set CompanyID=@CompanyID
--------------------------------------------------------------
Insert Into CmnItemGrade
Select * from XERP_FAAR.dbo.CmnItemGrade 
Update CmnItemGrade Set CompanyID=@CompanyID
--------------------------------------------------------------
Insert Into CmnItemModel
Select * from XERP_FAAR.dbo.CmnItemModel 
Update CmnItemModel Set CompanyID=@CompanyID
--------------------------------------------------------------
Insert Into CmnItemSpecificationType
Select * from XERP_FAAR.dbo.CmnItemSpecificationType 
Update CmnItemSpecificationType Set CompanyID=@CompanyID
--------------------------------------------------------------
Insert Into CmnItemSpecificationParameter
Select * from XERP_FAAR.dbo.CmnItemSpecificationParameter 
Update CmnItemSpecificationParameter Set CompanyID=@CompanyID
---------------------------------------------------
Insert into CmnAddressCountry
Select * from XERP_FAAR.dbo.CmnAddressCountry
Update CmnAddressCountry Set CompanyID=@CompanyID
--------------------------------------------------------------
Insert Into CmnItemMaster(ItemID,CustomCode,ItemName,ItemCategoryID,ItemGroupID,ItemColorID,ItemStyleID
					,ItemSpecificationID,ItemBrandID,ItemModelID,ItemGradeID,OriginCountryID
					,UOMID,IsQCRequired,IsOverQuntityAccepted,Barcode,ParentID,StatusID,CompanyID
					,DBID,CreateBy,CreateOn,CreatePc,UpdateBy,UpdateOn,UpdatePc,IsDeleted,DeleteBy,DeleteOn,DeletePc,Transfer)
Select ItemID,CustomCode,ItemName,ItemCategoryID,ItemGroupID,ItemColorID,ItemStyleID
					,ItemSpecificationID,ItemBrandID,ItemModelID,ItemGradeID,OriginCountryID
					,UOMID,IsQCRequired,IsOverQuntityAccepted,Barcode,ParentID,StatusID,CompanyID
					,DBID,CreateBy,CreateOn,CreatePc,UpdateBy,UpdateOn,UpdatePc,IsDeleted,DeleteBy,DeleteOn,DeletePc,Transfer
from XERP_FAAR.dbo.CmnItemMaster  A
Update CmnItemMaster Set CompanyID=@CompanyID
------------------------------
Insert Into CmnItemSizeMaster
Select * from XERP_FAAR.dbo.CmnItemSizeMaster
Update CmnItemSizeMaster Set CompanyID=@CompanyID
------------------------------
--update CmnItemMaster
--set ItemSizeID=s.ItemSizeID
--from CmnItemMaster as i,CmnItemSizeMaster as s
--where i.ItemID=s.ItemID
	
--------------------------------------------------------------

Insert Into CmnItemSpecificationMaster
Select * from XERP_FAAR.dbo.CmnItemSpecificationMaster 
Update CmnItemSpecificationMaster Set CompanyID=@CompanyID
--------------------------------------------------------------
Insert Into CmnItemSpecificationDetail
Select * from XERP_FAAR.dbo.CmnItemSpecificationDetail 
		Where ItemSpecificationID  in( Select distinct ItemSpecificationID from XERP_FAAR.dbo.CmnItemSpecificationMaster )
Update CmnItemSpecificationDetail Set CompanyID=@CompanyID

--------------------------------------------------------------
-------------------------------------------------------------------End Import Data From Others Database:
-----------------
-------------------------------------------------
Insert into CmnPartnerType
Select * from XERP_FAAR.dbo.CmnPartnerType
Update CmnPartnerType Set CompanyID=@CompanyID

-------------------------------------------------
Insert into CmnPartnerDetail
Select * from XERP_FAAR.dbo.CmnPartnerDetail
Update CmnPartnerDetail Set CompanyID=@CompanyID
-------------------------------------------------
Insert into CmnCompanyCategory
Select * from XERP_FAAR.dbo.CmnCompanyCategory
Update CmnCompanyCategory Set CompanyID=@CompanyID
-------------------------------------------------
Insert into CmnCompanyType
Select * from XERP_FAAR.dbo.CmnCompanyType
Update CmnCompanyType Set CompanyID=@CompanyID
-------------------------------------------------
Insert into CmnCompany(CompanyID,CustomCode,CompanyName,CompanyCategoryID,PartnerID,InceptionDate, RefID, StatusID, DBID, CreateBy, CreateOn, CreatePc, IsDeleted)
Select CompanyID,CustomCode,CompanyName,CompanyCategoryID,PartnerID,InceptionDate, RefID, StatusID, DBID, CreateBy, CreateOn, CreatePc, IsDeleted
from XERP_FAAR.dbo.CmnCompany
--Update CmnCompany Set CompanyID=@CompanyID
------------------------------------------------
Insert into CmnModuleList
Select * from XERP_FAAR.dbo.CmnModuleList
Update CmnModuleList Set CompanyID=1
-------------------------------------------------
Insert Into CmnDataBaseLocation
Select * from XERP_FAAR.dbo.CmnDataBaseLocation
Update CmnDataBaseLocation Set CompanyID=@CompanyID
--------------------------------------------------
Insert into CmnDocType
Select * from XERP_FAAR.dbo.CmnDocType
Update CmnDocType Set CompanyID=@CompanyID
-------------------------------------------------
Insert into CmnDocList
Select * from XERP_FAAR.dbo.CmnDocList
Update CmnDocList Set CompanyID=@CompanyID
-------------------------------------------------
Insert into CmnDocListTableMapping(DocListTableMappingID,CustomCode,DocListID,TableType,TableName,TableDescription,ColumnType,ColumnName,ColumnDescription,IsInActive
		,StatusID,CompanyID,DBID,CreateBy,CreateOn,CreatePc,IsDeleted,Transfer,PageControlType,PageControlID,ParentControlType,ParentControlID )
Select DocListTableMappingID,CustomCode,DocListID,TableType,TableName,TableDescription,ColumnType,ColumnName,ColumnDescription,IsInActive
	,StatusID,CompanyID,DBID,CreateBy,CreateOn,CreatePc,IsDeleted,Transfer,PageControlType,PageControlID,ParentControlType,ParentControlID 
from XERP_FAAR.dbo.CmnDocListTableMapping
Update CmnDocListTableMapping Set CompanyID=@CompanyID
-------------------------------------------------
Insert into CmnPermissionGroup
Select * from XERP_FAAR.dbo.CmnPermissionGroup
Update CmnPermissionGroup Set CompanyID=@CompanyID
-------------------------------------------------
Insert into CmnPermissionGroupDoc
Select * from XERP_FAAR.dbo.CmnPermissionGroupDoc
Update CmnPermissionGroupDoc Set CompanyID=@CompanyID
---------------------------------------------
Insert into CmnModuleFormCompany
Select * from XERP_FAAR.dbo.CmnModuleFormCompany
Update CmnModuleFormCompany Set CompanyID=@CompanyID
--------------------------------------------------
Insert into CmnUserType
Select * from XERP_FAAR.dbo.CmnUserType
Update CmnUserType Set CompanyID=@CompanyID

---------------------------------------------------
Insert Into CmnCurrencyMaster
Select * from XERP_FAAR.dbo.CmnCurrencyMaster 
Update CmnCurrencyMaster Set CompanyID=@CompanyID
--------------------------------------------------
Insert into CmnUserGender
Select * from XERP_FAAR.dbo.CmnUserGender
Update CmnUserGender Set CompanyID=@CompanyID
-------------------------------------------------
Insert into CmnUserReligion
Select * from XERP_FAAR.dbo.CmnUserReligion
Update CmnUserReligion Set CompanyID=@CompanyID
---------------------------------------------------
Insert into CmnUserGroup
Select * from XERP_FAAR.dbo.CmnUserGroup
Update CmnUserGroup Set CompanyID=@CompanyID
---------------------------------------------------
Insert into CmnUserPriorityType
Select * from XERP_FAAR.dbo.CmnUserPriorityType
Update CmnUserPriorityType Set CompanyID=@CompanyID
-----------------------------------------------
Insert into CmnOrganogramType
Select * from XERP_FAAR.dbo.CmnOrganogramType
Update CmnOrganogramType Set CompanyID=@CompanyID
-------------------------------------------
Insert into CmnChartOfAccountsBase
Select * from XERP_FAAR.dbo.CmnChartOfAccountsBase
Update CmnChartOfAccountsBase Set CompanyID=@CompanyID
------------------------------------------------------
Insert into CmnChartOfAccountType
Select * from XERP_FAAR.dbo.CmnChartOfAccountType
Update CmnChartOfAccountType Set CompanyID=@CompanyID

-------------------------------------------------------------------------
Insert into CmnUserInfo(UserID,CustomCode,UserPriorityTypeID,UserTypeID,UserGroupID,UserTitleID,UserFirstName,UserMiddleName,UserLastName,UserFullName,ReligionID,GenderID,DateOfBirth
	,ParentID,IsActive,COAID,StatusID,CompanyID,DBID,CreateBy,CreateOn,IsDeleted,Transfer)
Select UserID,CustomCode,UserPriorityTypeID,UserTypeID,UserGroupID,UserTitleID,UserFirstName,UserMiddleName,UserLastName,UserFullName,ReligionID,GenderID,DateOfBirth
	,ParentID,IsActive,COAID,StatusID,CompanyID,DBID,CreateBy,CreateOn,IsDeleted,Transfer
from XERP_FAAR.dbo.CmnUserInfo Where UserID=1
Update CmnUserInfo Set CompanyID=@CompanyID
-----------------------------------------------------------------------
Insert into CmnUserAuthentication
Select * from XERP_FAAR.dbo.CmnUserAuthentication Where UserID=1
--Update CmnUserAuthentication
--Set CompanyID=3
--------------------------------------------------------------------
Insert into CmnPermissionGroupUser
Select * from XERP_FAAR.dbo.CmnPermissionGroupUser Where UserID=1
--Update CmnPermissionGroupUser
--Set CompanyID=3
--------------------------------------------------------------------
Insert into CmnTransactionType
Select * from XERP_FAAR.dbo.CmnTransactionType
Update CmnTransactionType Set CompanyID=@CompanyID
---------------------------------------------------------------------
Insert into CmnTransactionReferenceType
Select * from XERP_FAAR.dbo.CmnTransactionReferenceType
Update CmnTransactionReferenceType Set CompanyID=@CompanyID
------------------------------------------------------------------
Insert into CmnTransactionReferenceTypeDetail
Select * from XERP_FAAR.dbo.CmnTransactionReferenceTypeDetail
Update CmnTransactionReferenceTypeDetail Set CompanyID=@CompanyID
--------------------------------------------------------------------

Insert into CmnItemPriceMethod
Select * from XERP_FAAR.dbo.CmnItemPriceMethod
Update CmnItemPriceMethod Set CompanyID=@CompanyID
------------------------------------------------------------------
Insert into InvItemPriceMethod
Select * from XERP_FAAR.dbo.InvItemPriceMethod
Update InvItemPriceMethod Set CompanyID=@CompanyID

---------------------------------------------------------------

Insert into BilBillStatus
Select * from XERP_FAAR.dbo.BilBillStatus
Update BilBillStatus Set CompanyID=@CompanyID

-----------------------------------------------------------------

Insert into AccJournalType
Select * from XERP_FAAR.dbo.AccJournalType
Update AccJournalType Set CompanyID=@CompanyID
-------------------------------------------------------------------
Insert into AccChequeTransectionType
Select * from XERP_FAAR.dbo.AccChequeTransectionType
Update AccChequeTransectionType Set CompanyID=@CompanyID
---------------------------------------------------------------
Insert into AccChequeStatusList
Select * from XERP_FAAR.dbo.AccChequeStatusList
Update AccChequeStatusList Set CompanyID=@CompanyID
-----------------------------------------------------------------
Insert into CmnDeliveryType
Select * from XERP_FAAR.dbo.CmnDeliveryType
Update CmnDeliveryType Set CompanyID=@CompanyID
-----------------------------------------------------------------

Insert into CmnTaxType
Select * from XERP_FAAR.dbo.CmnTaxType
Update CmnTaxType Set CompanyID=@CompanyID
------------------------------------------------------------
Insert into CmnTaxCategory
Select * from XERP_FAAR.dbo.CmnTaxCategory
--Update CmnTaxCategory
--Set CompanyID=3
--------------------------------------------------------------

Insert into CmnTaxMaster
Select * from XERP_FAAR.dbo.CmnTaxMaster  --366,380
Update CmnTaxMaster Set CompanyID=@CompanyID
---------------------------------------------------------------
Insert into BilBillType
Select * from XERP_FAAR.dbo.BilBillType
Update BilBillType Set CompanyID=@CompanyID
------------------------------------------------------------
Insert into BilBillingType
Select * from XERP_FAAR.dbo.BilBillingType
Update BilBillingType Set CompanyID=@CompanyID
-------------------------------------------------------
Insert into BilBillingDuration
Select * from XERP_FAAR.dbo.BilBillingDuration
Update BilBillingDuration Set CompanyID=@CompanyID
------------------------------------------------------

Insert into SalSalesCategory
Select * from XERP_FAAR.dbo.SalSalesCategory
Update SalSalesCategory Set CompanyID=@CompanyID
---------------------------------------------------------
Insert into InvDOType
Select * from XERP_FAAR.dbo.InvDOType
Update InvDOType Set CompanyID=@CompanyID
-----------------------------------------------------------
Insert into CmnStatusList
Select * from XERP_FAAR.dbo.CmnStatusList
Update CmnStatusList Set CompanyID=@CompanyID
---------------------------------------------------------------
Insert into CmnItemAccountType
Select * from XERP_FAAR.dbo.CmnItemAccountType
Update CmnItemAccountType Set CompanyID=@CompanyID
---------------------------------------------------------

Insert into CmnUserAccountType
Select * from XERP_FAAR.dbo.CmnUserAccountType
Update CmnUserAccountType Set CompanyID=@CompanyID
------------------------------------------------------------

Insert into CmnCarrierTYpe
Select * from XERP_FAAR.dbo.CmnCarrierTYpe
Update CmnCarrierTYpe Set CompanyID=@CompanyID
-------------------------------------------------------------
Insert into CmnAddressType
Select * from XERP_FAAR.dbo.CmnAddressType
Update CmnAddressType Set CompanyID=@CompanyID
------------------------------------------------------------
Insert into PurQuotationType
Select * from XERP_FAAR.dbo.PurQuotationType
Update PurQuotationType Set ComapanyID=@CompanyID
-----------------------------------------------------------
Insert into CmnBatchType
Select * from XERP_FAAR.dbo.CmnBatchType
Update CmnBatchType Set CompanyID=@CompanyID
--------------------------------------------------------------
Insert into CmnDashBoardType
Select * from XERP_FAAR.dbo.CmnDashBoardType
Update CmnDashBoardType Set CompanyID=@CompanyID
--------------------------------------------------------------
Insert into CmnDashBoardPanel
Select * from XERP_FAAR.dbo.CmnDashBoardPanel
Update CmnDashBoardPanel Set CompanyID=@CompanyID
--------------------------------------------------------------
Insert into CmnDashBoard
Select * from XERP_FAAR.dbo.CmnDashBoard
Update CmnDashBoard Set CompanyID=@CompanyID
--------------------------------------------------------------
Insert into CmnPeriodType
Select * from XERP_FAAR.dbo.CmnPeriodType
Update CmnPeriodType Set CompanyID=@CompanyID
--------------------------------------------------------------
Insert into CmnPaymentMethod
Select * from XERP_FAAR.dbo.CmnPaymentMethod
Update CmnPaymentMethod Set CompanyID=@CompanyID
-------------------------------------------------------------
Insert into CmnPaymentTerm
Select * from XERP_FAAR.dbo.CmnPaymentTerm
Update CmnPaymentTerm Set CompanyID=@CompanyID
--------------------------------------------------------------
Insert into CmnYear
Select * from XERP_FAAR.dbo.CmnYear
Update CmnYear Set CompanyID=@CompanyID
--------------------------------------------------------------
Insert into CmnFiscalYear
Select * from XERP_FAAR.dbo.CmnFiscalYear
Update CmnFiscalYear Set CompanyID=@CompanyID
--------------------------------------------------------------
Insert into SalSalesType
Select * from XERP_FAAR.dbo.SalSalesType
Update SalSalesType Set CompanyID=@CompanyID
--------------------------------------------------------------
Insert into CmnShippingMode
Select * from XERP_FAAR.dbo.CmnShippingMode
Update CmnShippingMode Set CompanyID=@CompanyID
--------------------------------------------------------------
--Insert into CmnOrganogramList
--Select * from XERP_FAAR.dbo.CmnOrganogramList
--Update CmnOrganogramList Set CompanyID=@CompanyID
--------------------------------------------------------------
--Insert into CmnOrganogram
--Select * from XERP_FAAR.dbo.CmnOrganogram
--Update CmnOrganogram Set CompanyID=@CompanyID
--------------------------------------------------------------
--Insert into CmnProject
--Select * from XERP_FAAR.dbo.CmnProject
--Update CmnProject Set CompanyID=@CompanyID
--------------------------------------------------------------
--Insert into CmnWorkFlowMaster
--Select * from XERP_FAAR.dbo.CmnWorkFlowMaster
--Update CmnWorkFlowMaster Set CompanyID=@CompanyID
--------------------------------------------------------------
--Insert into CmnWorkFlowDetail
--Select * from XERP_FAAR.dbo.CmnWorkFlowDetail
--Update CmnWorkFlowDetail Set CompanyID=@CompanyID
--------------------------------------------------------------
--Insert into CmnWorkFlowTransaction(CustomCode,DocListID,TransactionID,TransactionDate,StatusID,UserID,IsApprove,BackwardComment
--			,ForwardComment,ProjectID,CostCenterID,CompanyID,DBID,CreateBy,CreateOn,CreatePc,UpdateBy,UpdateOn,UpdatePc,IsDeleted
--			,DeleteBy,DeleteOn,DeletePc,Transfer)
--Select CustomCode,DocListID,TransactionID,TransactionDate,StatusID,UserID,IsApprove,BackwardComment
--			,ForwardComment,ProjectID,CostCenterID,CompanyID,DBID,CreateBy,CreateOn,CreatePc,UpdateBy,UpdateOn,UpdatePc,IsDeleted
--			,DeleteBy,DeleteOn,DeletePc,Transfer
--	from XERP_FAAR.dbo.CmnWorkFlowTransaction
--Update CmnWorkFlowTransaction Set CompanyID=@CompanyID
--------------------------------------------------------------
Insert Into CmnDocListFormat
Select * from XERP_FAAR.dbo.CmnDocListFormat
Update CmnDocListFormat Set CompanyID=@CompanyID
--------------------------------------------------------------
Insert Into CmnDocListFormatAutoNo
Select * from XERP_FAAR.dbo.CmnDocListFormatAutoNo
--Update CmnDocListFormatAutoNo Set CompanyID=@CompanyID
--------------------------------------------------------------


-----------------Accounting:
----------------------------CmnChartOfAccount:
--Insert into CmnChartOfAccount
--Select * from XERP_FAAR.dbo.CmnChartOfAccount Where COAID between 1 and 8
INSERT CmnChartOfAccount (COAID, CustomCode, ChartOfAccountsBaseID, COATypeID, COAName,
 ParentID, COALevel, CostCenterID, ProjectID, IsTransactionAC, IsInActive, IsCash, IsDefaultCash, StatusID, CompanyID, DBID, CreateBy, CreateOn, CreatePc, UpdateBy, UpdateOn, UpdatePc, IsDeleted, DeleteBy, DeleteOn, DeletePc, Transfer) 
VALUES (1, N'1', 1, 1, N'ASSET', 0, 1, NULL, NULL, 0, 0, NULL, 0, 1, 3, 1, 1, CAST(0x0000A30100000000 AS DateTime), NULL, 1, CAST(0x0000A30100000000 AS DateTime), NULL, 0, 1, CAST(0x0000A30100000000 AS DateTime), NULL, 0)
INSERT CmnChartOfAccount (COAID, CustomCode, ChartOfAccountsBaseID, COATypeID, COAName, ParentID, COALevel, CostCenterID, ProjectID, IsTransactionAC, IsInActive, IsCash, IsDefaultCash, StatusID, CompanyID, DBID, CreateBy, CreateOn, CreatePc, UpdateBy, UpdateOn, UpdatePc, IsDeleted, DeleteBy, DeleteOn, DeletePc, Transfer) 
					VALUES (2, N'2', 1, 2, N'Libilities', 0, 1, NULL, NULL, 0, 0, NULL, 0, 1, 3, 1, 1, CAST(0x0000A30100000000 AS DateTime), NULL, 1, CAST(0x0000A30100000000 AS DateTime), NULL, 0, 1, CAST(0x0000A30100000000 AS DateTime), NULL, 0)
INSERT CmnChartOfAccount (COAID, CustomCode, ChartOfAccountsBaseID, COATypeID, COAName, ParentID, COALevel, CostCenterID, ProjectID, IsTransactionAC, IsInActive, IsCash, IsDefaultCash, StatusID, CompanyID, DBID, CreateBy, CreateOn, CreatePc, UpdateBy, UpdateOn, UpdatePc, IsDeleted, DeleteBy, DeleteOn, DeletePc, Transfer) VALUES (3, N'3', 1, 1, N'Incom', 0, 3, NULL, NULL, 0, 0, 0, 0, 1, 3, 1, 1, CAST(0x0000A30100000000 AS DateTime), NULL, 1, CAST(0x0000A30100000000 AS DateTime), NULL, 0, 1, CAST(0x0000A30100000000 AS DateTime), NULL, 0)
INSERT CmnChartOfAccount (COAID, CustomCode, ChartOfAccountsBaseID, COATypeID, COAName, ParentID, COALevel, CostCenterID, ProjectID, IsTransactionAC, IsInActive, IsCash, IsDefaultCash, StatusID, CompanyID, DBID, CreateBy, CreateOn, CreatePc, UpdateBy, UpdateOn, UpdatePc, IsDeleted, DeleteBy, DeleteOn, DeletePc, Transfer) VALUES (4, N'4', 1, 4, N'Expense', 0, 1, NULL, NULL, 0, 0, NULL, 0, 1, 3, 1, 1, CAST(0x0000A30100000000 AS DateTime), NULL, 1, CAST(0x0000A30100000000 AS DateTime), NULL, 0, 1, CAST(0x0000A30100000000 AS DateTime), NULL, 0)
INSERT CmnChartOfAccount (COAID, CustomCode, ChartOfAccountsBaseID, COATypeID, COAName, ParentID, COALevel, CostCenterID, ProjectID, IsTransactionAC, IsInActive, IsCash, IsDefaultCash, StatusID, CompanyID, DBID, CreateBy, CreateOn, CreatePc, UpdateBy, UpdateOn, UpdatePc, IsDeleted, DeleteBy, DeleteOn, DeletePc, Transfer) VALUES (5, N'5', 1, 1, N'Current Asset', 1, 2, NULL, NULL, 0, 0, 0, 0, 0, 3, 1, 1, CAST(0x0000A30900000000 AS DateTime), NULL, 1, CAST(0x0000A30900000000 AS DateTime), NULL, 0, 1, CAST(0x0000A30900000000 AS DateTime), NULL, 0)
INSERT CmnChartOfAccount (COAID, CustomCode, ChartOfAccountsBaseID, COATypeID, COAName, ParentID, COALevel, CostCenterID, ProjectID, IsTransactionAC, IsInActive, IsCash, IsDefaultCash, StatusID, CompanyID, DBID, CreateBy, CreateOn, CreatePc, UpdateBy, UpdateOn, UpdatePc, IsDeleted, DeleteBy, DeleteOn, DeletePc, Transfer) VALUES (6, N'6', 1, 1, N'Fixt Asset', 1, 2, NULL, NULL, 0, 0, NULL, 0, 1, 3, 1, 1, CAST(0x0000A30100000000 AS DateTime), NULL, 1, CAST(0x0000A30100000000 AS DateTime), NULL, 0, 1, CAST(0x0000A30100000000 AS DateTime), NULL, 0)
INSERT CmnChartOfAccount (COAID, CustomCode, ChartOfAccountsBaseID, COATypeID, COAName, ParentID, COALevel, CostCenterID, ProjectID, IsTransactionAC, IsInActive, IsCash, IsDefaultCash, StatusID, CompanyID, DBID, CreateBy, CreateOn, CreatePc, UpdateBy, UpdateOn, UpdatePc, IsDeleted, DeleteBy, DeleteOn, DeletePc, Transfer) VALUES (7, N'7', 1, 2, N'Current Libilitie', 2, 2, NULL, NULL, 0, 0, NULL, 0, 1, 3, 1, 1, CAST(0x0000A30100000000 AS DateTime), NULL, 1, CAST(0x0000A30100000000 AS DateTime), NULL, 0, 1, CAST(0x0000A30100000000 AS DateTime), NULL, 0)
INSERT CmnChartOfAccount (COAID, CustomCode, ChartOfAccountsBaseID, COATypeID, COAName, ParentID, COALevel, CostCenterID, ProjectID, IsTransactionAC, IsInActive, IsCash, IsDefaultCash, StatusID, CompanyID, DBID, CreateBy, CreateOn, CreatePc, UpdateBy, UpdateOn, UpdatePc, IsDeleted, DeleteBy, DeleteOn, DeletePc, Transfer) VALUES (8, N'8', 1, 2, N'Long Term Libilities', 2, 2, NULL, NULL, 0, 0, NULL, 0, 1, 3, 1, 1, CAST(0x0000A30100000000 AS DateTime), NULL, 1, CAST(0x0000A30100000000 AS DateTime), NULL, 0, 1, CAST(0x0000A30100000000 AS DateTime), NULL, 0)
INSERT CmnChartOfAccount (COAID, CustomCode, ChartOfAccountsBaseID, COATypeID, COAName, ParentID, COALevel, CostCenterID, ProjectID, IsTransactionAC, IsInActive, IsCash, IsDefaultCash, StatusID, CompanyID, DBID, CreateBy, CreateOn, CreatePc, UpdateBy, UpdateOn, UpdatePc, IsDeleted, DeleteBy, DeleteOn, DeletePc, Transfer) VALUES (11, N'11', 1, 1, N'Party Payable', 1, 1, NULL, NULL, 1, 0, NULL, 0, 1, 3, 1, 1, CAST(0x0000A30100000000 AS DateTime), NULL, 1, CAST(0x0000A30100000000 AS DateTime), NULL, 0, 1, CAST(0x0000A30100000000 AS DateTime), NULL, 0)
INSERT CmnChartOfAccount (COAID, CustomCode, ChartOfAccountsBaseID, COATypeID, COAName, ParentID, COALevel, CostCenterID, ProjectID, IsTransactionAC, IsInActive, IsCash, IsDefaultCash, StatusID, CompanyID, DBID, CreateBy, CreateOn, CreatePc, UpdateBy, UpdateOn, UpdatePc, IsDeleted, DeleteBy, DeleteOn, DeletePc, Transfer) VALUES (12, N'12', 1, 1, N'Party Receivable', 1, 1, NULL, NULL, 1, 0, NULL, 0, 1, 3, 1, 1, CAST(0x0000A30100000000 AS DateTime), NULL, 1, CAST(0x0000A30100000000 AS DateTime), NULL, 0, 1, CAST(0x0000A30100000000 AS DateTime), NULL, 0)
INSERT CmnChartOfAccount (COAID, CustomCode, ChartOfAccountsBaseID, COATypeID, COAName, ParentID, COALevel, CostCenterID, ProjectID, IsTransactionAC, IsInActive, IsCash, IsDefaultCash, StatusID, CompanyID, DBID, CreateBy, CreateOn, CreatePc, UpdateBy, UpdateOn, UpdatePc, IsDeleted, DeleteBy, DeleteOn, DeletePc, Transfer) VALUES (13, N'13', 1, 1, N'Employee Payable ACcount', 1, 1, NULL, NULL, 1, 0, NULL, 0, 1, 3, 1, 1, CAST(0x0000A30100000000 AS DateTime), NULL, 1, CAST(0x0000A30100000000 AS DateTime), NULL, 0, 1, CAST(0x0000A30100000000 AS DateTime), NULL, 0)
INSERT CmnChartOfAccount (COAID, CustomCode, ChartOfAccountsBaseID, COATypeID, COAName, ParentID, COALevel, CostCenterID, ProjectID, IsTransactionAC, IsInActive, IsCash, IsDefaultCash, StatusID, CompanyID, DBID, CreateBy, CreateOn, CreatePc, UpdateBy, UpdateOn, UpdatePc, IsDeleted, DeleteBy, DeleteOn, DeletePc, Transfer) VALUES (14, N'14', 1, 2, N'Sundry Liability- Over A/C ', 2, 1, NULL, NULL, 1, 0, NULL, 0, 1, 3, 1, 1, CAST(0x0000A30100000000 AS DateTime), NULL, 1, CAST(0x0000A30100000000 AS DateTime), NULL, 0, 1, CAST(0x0000A30100000000 AS DateTime), NULL, 0)
INSERT CmnChartOfAccount (COAID, CustomCode, ChartOfAccountsBaseID, COATypeID, COAName, ParentID, COALevel, CostCenterID, ProjectID, IsTransactionAC, IsInActive, IsCash, IsDefaultCash, StatusID, CompanyID, DBID, CreateBy, CreateOn, CreatePc, UpdateBy, UpdateOn, UpdatePc, IsDeleted, DeleteBy, DeleteOn, DeletePc, Transfer) VALUES (15, N'15', 1, 2, N'Sundry Liability- Damage Goods ', 2, 1, NULL, NULL, 1, 0, NULL, 0, 1, 3, 1, 1, CAST(0x0000A30100000000 AS DateTime), NULL, 1, CAST(0x0000A30100000000 AS DateTime), NULL, 0, 1, CAST(0x0000A30100000000 AS DateTime), NULL, 0)
INSERT CmnChartOfAccount (COAID, CustomCode, ChartOfAccountsBaseID, COATypeID, COAName, ParentID, COALevel, CostCenterID, ProjectID, IsTransactionAC, IsInActive, IsCash, IsDefaultCash, StatusID, CompanyID, DBID, CreateBy, CreateOn, CreatePc, UpdateBy, UpdateOn, UpdatePc, IsDeleted, DeleteBy, DeleteOn, DeletePc, Transfer) VALUES (16, N'16', 1, 1, N'Purchase Account', 1, 1, NULL, NULL, 1, 0, NULL, 0, 1, 3, 1, 1, CAST(0x0000A30100000000 AS DateTime), NULL, 1, CAST(0x0000A30100000000 AS DateTime), NULL, 0, 1, CAST(0x0000A30100000000 AS DateTime), NULL, 0)
INSERT CmnChartOfAccount (COAID, CustomCode, ChartOfAccountsBaseID, COATypeID, COAName, ParentID, COALevel, CostCenterID, ProjectID, IsTransactionAC, IsInActive, IsCash, IsDefaultCash, StatusID, CompanyID, DBID, CreateBy, CreateOn, CreatePc, UpdateBy, UpdateOn, UpdatePc, IsDeleted, DeleteBy, DeleteOn, DeletePc, Transfer) VALUES (17, N'17', 1, 1, N'Sales Account', 1, 1, NULL, NULL, 1, 0, NULL, 0, 1, 3, 1, 1, CAST(0x0000A30100000000 AS DateTime), NULL, 1, CAST(0x0000A30100000000 AS DateTime), NULL, 0, 1, CAST(0x0000A30100000000 AS DateTime), NULL, 0)
INSERT CmnChartOfAccount (COAID, CustomCode, ChartOfAccountsBaseID, COATypeID, COAName, ParentID, COALevel, CostCenterID, ProjectID, IsTransactionAC, IsInActive, IsCash, IsDefaultCash, StatusID, CompanyID, DBID, CreateBy, CreateOn, CreatePc, UpdateBy, UpdateOn, UpdatePc, IsDeleted, DeleteBy, DeleteOn, DeletePc, Transfer) VALUES (18, N'18', 1, 1, N'Bank Charge or Commission', 1, 1, NULL, NULL, 1, 0, NULL, 0, 1, 3, 1, 1, CAST(0x0000A30100000000 AS DateTime), NULL, 1, CAST(0x0000A30100000000 AS DateTime), NULL, 0, 1, CAST(0x0000A30100000000 AS DateTime), NULL, 0)
INSERT CmnChartOfAccount (COAID, CustomCode, ChartOfAccountsBaseID, COATypeID, COAName, ParentID, COALevel, CostCenterID, ProjectID, IsTransactionAC, IsInActive, IsCash, IsDefaultCash, StatusID, CompanyID, DBID, CreateBy, CreateOn, CreatePc, UpdateBy, UpdateOn, UpdatePc, IsDeleted, DeleteBy, DeleteOn, DeletePc, Transfer) VALUES (19, N'18', 1, 1, N'Conveyance ', 1, 1, NULL, NULL, 1, 0, NULL, 0, 1, 3, 1, 1, CAST(0x0000A30100000000 AS DateTime), NULL, 1, CAST(0x0000A30100000000 AS DateTime), NULL, 0, 1, CAST(0x0000A30100000000 AS DateTime), NULL, 0)
Update CmnChartOfAccount Set CompanyID=@CompanyID
----------------------------CmnAccountIntegrationSetting:
INSERT CmnAccountIntegrationSetting (AISID, CustomCode, DocListID, TransactionTypeID, IsItemDebit, DebitItemAccountTypeID, DebitUserAccountTypeID, DebitCOAID, CreditItemAccountTypeID, CreditUserAccountTypeID, CreditCOAID, IsInActive, StatusID, CompanyID, DBID, CreateBy, CreateOn, CreatePc, UpdateBy, UpdateOn, UpdatePc, IsDeleted, DeleteBy, DeleteOn, DeletePc, Transfer) VALUES (13, N'13', 1321, 127, 0, NULL, 1, NULL, 2, NULL, NULL, NULL, 0, 3, 1, 1, CAST(0x0000A31700000000 AS DateTime), NULL, 1, CAST(0x0000A31700000000 AS DateTime), NULL, 0, 1, CAST(0x0000A31700000000 AS DateTime), NULL, 0)
INSERT CmnAccountIntegrationSetting (AISID, CustomCode, DocListID, TransactionTypeID, IsItemDebit, DebitItemAccountTypeID, DebitUserAccountTypeID, DebitCOAID, CreditItemAccountTypeID, CreditUserAccountTypeID, CreditCOAID, IsInActive, StatusID, CompanyID, DBID, CreateBy, CreateOn, CreatePc, UpdateBy, UpdateOn, UpdatePc, IsDeleted, DeleteBy, DeleteOn, DeletePc, Transfer) VALUES (17, N'17', 1171, 144, 1, 1, NULL, NULL, NULL, 2, NULL, NULL, 0, 3, 1, 1, CAST(0x0000A31700000000 AS DateTime), NULL, 1, CAST(0x0000A31700000000 AS DateTime), NULL, 0, 1, CAST(0x0000A31700000000 AS DateTime), NULL, 0)
INSERT CmnAccountIntegrationSetting (AISID, CustomCode, DocListID, TransactionTypeID, IsItemDebit, DebitItemAccountTypeID, DebitUserAccountTypeID, DebitCOAID, CreditItemAccountTypeID, CreditUserAccountTypeID, CreditCOAID, IsInActive, StatusID, CompanyID, DBID, CreateBy, CreateOn, CreatePc, UpdateBy, UpdateOn, UpdatePc, IsDeleted, DeleteBy, DeleteOn, DeletePc, Transfer) VALUES (18, N'18', 1314, 143, 0, NULL, 2, NULL, 1, NULL, NULL, NULL, 0, 3, 1, 1, CAST(0x0000A2DC00000000 AS DateTime), NULL, 1, CAST(0x0000A2DC00000000 AS DateTime), NULL, 0, 1, CAST(0x0000A2DC00000000 AS DateTime), NULL, 0)
INSERT CmnAccountIntegrationSetting (AISID, CustomCode, DocListID, TransactionTypeID, IsItemDebit, DebitItemAccountTypeID, DebitUserAccountTypeID, DebitCOAID, CreditItemAccountTypeID, CreditUserAccountTypeID, CreditCOAID, IsInActive, StatusID, CompanyID, DBID, CreateBy, CreateOn, CreatePc, UpdateBy, UpdateOn, UpdatePc, IsDeleted, DeleteBy, DeleteOn, DeletePc, Transfer) VALUES (19, N'19', 1315, 145, 1, 1, NULL, NULL, NULL, 2, NULL, NULL, 0, 3, 1, 1, CAST(0x0000A2DC00000000 AS DateTime), NULL, 1, CAST(0x0000A2DC00000000 AS DateTime), NULL, 0, 1, CAST(0x0000A2DC00000000 AS DateTime), NULL, 0)
INSERT CmnAccountIntegrationSetting (AISID, CustomCode, DocListID, TransactionTypeID, IsItemDebit, DebitItemAccountTypeID, DebitUserAccountTypeID, DebitCOAID, CreditItemAccountTypeID, CreditUserAccountTypeID, CreditCOAID, IsInActive, StatusID, CompanyID, DBID, CreateBy, CreateOn, CreatePc, UpdateBy, UpdateOn, UpdatePc, IsDeleted, DeleteBy, DeleteOn, DeletePc, Transfer) VALUES (110, N'110', 142, 169, 0, NULL, 1, NULL, 2, NULL, NULL, NULL, 0, 3, 1, 1, CAST(0x0000A30500000000 AS DateTime), NULL, 1, CAST(0x0000A30500000000 AS DateTime), NULL, 0, 1, CAST(0x0000A30500000000 AS DateTime), NULL, 0)
INSERT CmnAccountIntegrationSetting (AISID, CustomCode, DocListID, TransactionTypeID, IsItemDebit, DebitItemAccountTypeID, DebitUserAccountTypeID, DebitCOAID, CreditItemAccountTypeID, CreditUserAccountTypeID, CreditCOAID, IsInActive, StatusID, CompanyID, DBID, CreateBy, CreateOn, CreatePc, UpdateBy, UpdateOn, UpdatePc, IsDeleted, DeleteBy, DeleteOn, DeletePc, Transfer) VALUES (111, N'111', 1402, 163, 0, NULL, 1, NULL, NULL, 1, NULL, NULL, 0, 3, 1, 1, CAST(0x0000A2BF00000000 AS DateTime), NULL, 1, CAST(0x0000A2BF00000000 AS DateTime), NULL, 0, 1, CAST(0x0000A2BF00000000 AS DateTime), NULL, 0)
INSERT CmnAccountIntegrationSetting (AISID, CustomCode, DocListID, TransactionTypeID, IsItemDebit, DebitItemAccountTypeID, DebitUserAccountTypeID, DebitCOAID, CreditItemAccountTypeID, CreditUserAccountTypeID, CreditCOAID, IsInActive, StatusID, CompanyID, DBID, CreateBy, CreateOn, CreatePc, UpdateBy, UpdateOn, UpdatePc, IsDeleted, DeleteBy, DeleteOn, DeletePc, Transfer) VALUES (112, N'112', 1403, 162, 1, NULL, 1, NULL, NULL, 1, NULL, NULL, 0, 3, 1, 1, CAST(0x0000A2BF00000000 AS DateTime), NULL, 1, CAST(0x0000A2BF00000000 AS DateTime), NULL, 0, 1, CAST(0x0000A2BF00000000 AS DateTime), NULL, 0)
INSERT CmnAccountIntegrationSetting (AISID, CustomCode, DocListID, TransactionTypeID, IsItemDebit, DebitItemAccountTypeID, DebitUserAccountTypeID, DebitCOAID, CreditItemAccountTypeID, CreditUserAccountTypeID, CreditCOAID, IsInActive, StatusID, CompanyID, DBID, CreateBy, CreateOn, CreatePc, UpdateBy, UpdateOn, UpdatePc, IsDeleted, DeleteBy, DeleteOn, DeletePc, Transfer) VALUES (113, N'113', 1151, 113, 0, 6, NULL, NULL, 3, NULL, NULL, NULL, 0, 3, 1, 1, CAST(0x0000A2BF00000000 AS DateTime), NULL, 1, CAST(0x0000A2BF00000000 AS DateTime), NULL, 0, 1, CAST(0x0000A2BF00000000 AS DateTime), NULL, 0)
INSERT CmnAccountIntegrationSetting (AISID, CustomCode, DocListID, TransactionTypeID, IsItemDebit, DebitItemAccountTypeID, DebitUserAccountTypeID, DebitCOAID, CreditItemAccountTypeID, CreditUserAccountTypeID, CreditCOAID, IsInActive, StatusID, CompanyID, DBID, CreateBy, CreateOn, CreatePc, UpdateBy, UpdateOn, UpdatePc, IsDeleted, DeleteBy, DeleteOn, DeletePc, Transfer) VALUES (114, N'114', 1313, 121, 1, 3, NULL, NULL, NULL, NULL, 14, NULL, 0, 3, 1, 1, CAST(0x0000A2C000000000 AS DateTime), NULL, 1, CAST(0x0000A2C000000000 AS DateTime), NULL, 0, 1, CAST(0x0000A2C000000000 AS DateTime), NULL, 0)
INSERT CmnAccountIntegrationSetting (AISID, CustomCode, DocListID, TransactionTypeID, IsItemDebit, DebitItemAccountTypeID, DebitUserAccountTypeID, DebitCOAID, CreditItemAccountTypeID, CreditUserAccountTypeID, CreditCOAID, IsInActive, StatusID, CompanyID, DBID, CreateBy, CreateOn, CreatePc, UpdateBy, UpdateOn, UpdatePc, IsDeleted, DeleteBy, DeleteOn, DeletePc, Transfer) VALUES (115, N'115', 1341, 146, 1, 8, NULL, NULL, NULL, NULL, 15, NULL, 0, 3, 1, 1, CAST(0x0000A2C000000000 AS DateTime), NULL, 1, CAST(0x0000A2C000000000 AS DateTime), NULL, 0, 1, CAST(0x0000A2C000000000 AS DateTime), NULL, 0)
INSERT CmnAccountIntegrationSetting (AISID, CustomCode, DocListID, TransactionTypeID, IsItemDebit, DebitItemAccountTypeID, DebitUserAccountTypeID, DebitCOAID, CreditItemAccountTypeID, CreditUserAccountTypeID, CreditCOAID, IsInActive, StatusID, CompanyID, DBID, CreateBy, CreateOn, CreatePc, UpdateBy, UpdateOn, UpdatePc, IsDeleted, DeleteBy, DeleteOn, DeletePc, Transfer) VALUES (116, N'116', 1261, 177, 1, 5, NULL, NULL, 3, NULL, NULL, NULL, 0, 3, 1, 1, CAST(0x0000A2C000000000 AS DateTime), NULL, 1, CAST(0x0000A2C000000000 AS DateTime), NULL, 0, 1, CAST(0x0000A2C000000000 AS DateTime), NULL, 0)
INSERT CmnAccountIntegrationSetting (AISID, CustomCode, DocListID, TransactionTypeID, IsItemDebit, DebitItemAccountTypeID, DebitUserAccountTypeID, DebitCOAID, CreditItemAccountTypeID, CreditUserAccountTypeID, CreditCOAID, IsInActive, StatusID, CompanyID, DBID, CreateBy, CreateOn, CreatePc, UpdateBy, UpdateOn, UpdatePc, IsDeleted, DeleteBy, DeleteOn, DeletePc, Transfer) VALUES (117, N'117', 1256, 178, 1, 9, NULL, NULL, 3, NULL, NULL, NULL, 0, 3, 1, 1, CAST(0x0000A2C000000000 AS DateTime), NULL, 1, CAST(0x0000A2C000000000 AS DateTime), NULL, 0, 1, CAST(0x0000A2C000000000 AS DateTime), NULL, 0)
INSERT CmnAccountIntegrationSetting (AISID, CustomCode, DocListID, TransactionTypeID, IsItemDebit, DebitItemAccountTypeID, DebitUserAccountTypeID, DebitCOAID, CreditItemAccountTypeID, CreditUserAccountTypeID, CreditCOAID, IsInActive, StatusID, CompanyID, DBID, CreateBy, CreateOn, CreatePc, UpdateBy, UpdateOn, UpdatePc, IsDeleted, DeleteBy, DeleteOn, DeletePc, Transfer) VALUES (118, N'118', 1421, 180, 1, 7, NULL, NULL, 3, NULL, NULL, NULL, 0, 3, 1, 1, CAST(0x0000A2C300000000 AS DateTime), NULL, 1, CAST(0x0000A2C300000000 AS DateTime), NULL, 0, 1, CAST(0x0000A2C300000000 AS DateTime), NULL, 0)
INSERT CmnAccountIntegrationSetting (AISID, CustomCode, DocListID, TransactionTypeID, IsItemDebit, DebitItemAccountTypeID, DebitUserAccountTypeID, DebitCOAID, CreditItemAccountTypeID, CreditUserAccountTypeID, CreditCOAID, IsInActive, StatusID, CompanyID, DBID, CreateBy, CreateOn, CreatePc, UpdateBy, UpdateOn, UpdatePc, IsDeleted, DeleteBy, DeleteOn, DeletePc, Transfer) VALUES (119, N'119', 1422, 181, 1, 4, NULL, NULL, 3, NULL, NULL, NULL, 0, 3, 1, 1, CAST(0x0000A2C600000000 AS DateTime), NULL, 1, CAST(0x0000A2C600000000 AS DateTime), NULL, 0, 1, CAST(0x0000A2C600000000 AS DateTime), NULL, 0)
INSERT CmnAccountIntegrationSetting (AISID, CustomCode, DocListID, TransactionTypeID, IsItemDebit, DebitItemAccountTypeID, DebitUserAccountTypeID, DebitCOAID, CreditItemAccountTypeID, CreditUserAccountTypeID, CreditCOAID, IsInActive, StatusID, CompanyID, DBID, CreateBy, CreateOn, CreatePc, UpdateBy, UpdateOn, UpdatePc, IsDeleted, DeleteBy, DeleteOn, DeletePc, Transfer) VALUES (120, N'120', 1424, 182, 1, NULL, NULL, 13, NULL, 3, NULL, NULL, 0, 3, 1, 1, CAST(0x0000A2C700000000 AS DateTime), NULL, 1, CAST(0x0000A2C700000000 AS DateTime), NULL, 0, 1, CAST(0x0000A2C700000000 AS DateTime), NULL, 0)
INSERT CmnAccountIntegrationSetting (AISID, CustomCode, DocListID, TransactionTypeID, IsItemDebit, DebitItemAccountTypeID, DebitUserAccountTypeID, DebitCOAID, CreditItemAccountTypeID, CreditUserAccountTypeID, CreditCOAID, IsInActive, StatusID, CompanyID, DBID, CreateBy, CreateOn, CreatePc, UpdateBy, UpdateOn, UpdatePc, IsDeleted, DeleteBy, DeleteOn, DeletePc, Transfer) VALUES (121, N'121', 134, 166, 1, 1, NULL, NULL, NULL, 2, NULL, NULL, 0, 3, 1, 1, CAST(0x0000A2CE00000000 AS DateTime), NULL, 1, CAST(0x0000A2CE00000000 AS DateTime), NULL, 0, 1, CAST(0x0000A2CE00000000 AS DateTime), NULL, 0)
INSERT CmnAccountIntegrationSetting (AISID, CustomCode, DocListID, TransactionTypeID, IsItemDebit, DebitItemAccountTypeID, DebitUserAccountTypeID, DebitCOAID, CreditItemAccountTypeID, CreditUserAccountTypeID, CreditCOAID, IsInActive, StatusID, CompanyID, DBID, CreateBy, CreateOn, CreatePc, UpdateBy, UpdateOn, UpdatePc, IsDeleted, DeleteBy, DeleteOn, DeletePc, Transfer) VALUES (122, N'122', 136, 168, 0, NULL, 1, NULL, 2, NULL, NULL, NULL, 0, 3, 1, 1, CAST(0x0000A2CE00000000 AS DateTime), NULL, 1, CAST(0x0000A2CE00000000 AS DateTime), NULL, 0, 1, CAST(0x0000A2CE00000000 AS DateTime), NULL, 0)
INSERT CmnAccountIntegrationSetting (AISID, CustomCode, DocListID, TransactionTypeID, IsItemDebit, DebitItemAccountTypeID, DebitUserAccountTypeID, DebitCOAID, CreditItemAccountTypeID, CreditUserAccountTypeID, CreditCOAID, IsInActive, StatusID, CompanyID, DBID, CreateBy, CreateOn, CreatePc, UpdateBy, UpdateOn, UpdatePc, IsDeleted, DeleteBy, DeleteOn, DeletePc, Transfer) VALUES (123, N'123', 1321, 127, 0, NULL, 1, NULL, 2, NULL, NULL, NULL, 0, 3, 1, 1, CAST(0x0000A2DC00000000 AS DateTime), NULL, 1, CAST(0x0000A2DC00000000 AS DateTime), NULL, 0, 1, CAST(0x0000A2DC00000000 AS DateTime), NULL, 0)
INSERT CmnAccountIntegrationSetting (AISID, CustomCode, DocListID, TransactionTypeID, IsItemDebit, DebitItemAccountTypeID, DebitUserAccountTypeID, DebitCOAID, CreditItemAccountTypeID, CreditUserAccountTypeID, CreditCOAID, IsInActive, StatusID, CompanyID, DBID, CreateBy, CreateOn, CreatePc, UpdateBy, UpdateOn, UpdatePc, IsDeleted, DeleteBy, DeleteOn, DeletePc, Transfer) VALUES (124, N'124', 142, 169, 0, 2, NULL, NULL, 2, NULL, NULL, NULL, 0, 3, 1, 1, CAST(0x0000A2D700000000 AS DateTime), NULL, 1, CAST(0x0000A2D700000000 AS DateTime), NULL, 0, 1, CAST(0x0000A2D700000000 AS DateTime), NULL, 0)
INSERT CmnAccountIntegrationSetting (AISID, CustomCode, DocListID, TransactionTypeID, IsItemDebit, DebitItemAccountTypeID, DebitUserAccountTypeID, DebitCOAID, CreditItemAccountTypeID, CreditUserAccountTypeID, CreditCOAID, IsInActive, StatusID, CompanyID, DBID, CreateBy, CreateOn, CreatePc, UpdateBy, UpdateOn, UpdatePc, IsDeleted, DeleteBy, DeleteOn, DeletePc, Transfer) VALUES (125, N'125', 1343, 185, 0, NULL, 1, NULL, 2, NULL, NULL, NULL, 0, 3, 1, 1, CAST(0x0000A2DC00000000 AS DateTime), NULL, 1, CAST(0x0000A2DC00000000 AS DateTime), NULL, 0, 1, CAST(0x0000A2DC00000000 AS DateTime), NULL, 0)
INSERT CmnAccountIntegrationSetting (AISID, CustomCode, DocListID, TransactionTypeID, IsItemDebit, DebitItemAccountTypeID, DebitUserAccountTypeID, DebitCOAID, CreditItemAccountTypeID, CreditUserAccountTypeID, CreditCOAID, IsInActive, StatusID, CompanyID, DBID, CreateBy, CreateOn, CreatePc, UpdateBy, UpdateOn, UpdatePc, IsDeleted, DeleteBy, DeleteOn, DeletePc, Transfer) VALUES (126, N'126', 1446, 11, 1, NULL, NULL, 11, NULL, NULL, 11, NULL, 0, 3, 1, 1, CAST(0x0000A2F800000000 AS DateTime), NULL, 1, CAST(0x0000A2F800000000 AS DateTime), NULL, 0, 1, CAST(0x0000A2F800000000 AS DateTime), NULL, 0)
INSERT CmnAccountIntegrationSetting (AISID, CustomCode, DocListID, TransactionTypeID, IsItemDebit, DebitItemAccountTypeID, DebitUserAccountTypeID, DebitCOAID, CreditItemAccountTypeID, CreditUserAccountTypeID, CreditCOAID, IsInActive, StatusID, CompanyID, DBID, CreateBy, CreateOn, CreatePc, UpdateBy, UpdateOn, UpdatePc, IsDeleted, DeleteBy, DeleteOn, DeletePc, Transfer) VALUES (127, N'127', 1417, 12, 1, NULL, NULL, 18, NULL, 1, NULL, NULL, 0, 3, 1, 1, CAST(0x0000A2DC00000000 AS DateTime), NULL, 1, CAST(0x0000A2DC00000000 AS DateTime), NULL, 0, 1, CAST(0x0000A2DC00000000 AS DateTime), NULL, 0)
INSERT CmnAccountIntegrationSetting (AISID, CustomCode, DocListID, TransactionTypeID, IsItemDebit, DebitItemAccountTypeID, DebitUserAccountTypeID, DebitCOAID, CreditItemAccountTypeID, CreditUserAccountTypeID, CreditCOAID, IsInActive, StatusID, CompanyID, DBID, CreateBy, CreateOn, CreatePc, UpdateBy, UpdateOn, UpdatePc, IsDeleted, DeleteBy, DeleteOn, DeletePc, Transfer) VALUES (128, N'128', 1466, 13, 1, NULL, NULL, 19, NULL, NULL, 13, NULL, 0, 3, 1, 1, CAST(0x0000A2FB00000000 AS DateTime), NULL, 1, CAST(0x0000A2FB00000000 AS DateTime), NULL, 0, 1, CAST(0x0000A2FB00000000 AS DateTime), NULL, 0)
INSERT CmnAccountIntegrationSetting (AISID, CustomCode, DocListID, TransactionTypeID, IsItemDebit, DebitItemAccountTypeID, DebitUserAccountTypeID, DebitCOAID, CreditItemAccountTypeID, CreditUserAccountTypeID, CreditCOAID, IsInActive, StatusID, CompanyID, DBID, CreateBy, CreateOn, CreatePc, UpdateBy, UpdateOn, UpdatePc, IsDeleted, DeleteBy, DeleteOn, DeletePc, Transfer) VALUES (129, N'129', 1339, 132, 0, NULL, NULL, 12, NULL, NULL, 17, NULL, 0, 3, 1, 1, CAST(0x0000A2F800000000 AS DateTime), NULL, 1, CAST(0x0000A2F800000000 AS DateTime), NULL, 0, 1, CAST(0x0000A2F800000000 AS DateTime), NULL, 0)
Update CmnAccountIntegrationSetting Set CompanyID=@CompanyID

----CashFlow:
insert into AccCashFlowMethod
select * from XERP_FAAR.dbo.AccCashFlowMethod
update AccCashFlowMethod Set CompanyID=@CompanyID
-------

insert into AccCashflowMethodMapCompany(CashflowMethodMapCompanyID,CustomCode,MethodID,Descriptions,CompanyID,EffectiveDate,IsActive
				,StatusID,DBID,CreateBy,CreateOn,CreatePc,UpdateBy,UpdateOn,UpdatePc,IsDeleted,DeleteBy,DeleteOn,DeletePc,Transfer)
select CashflowMethodMapCompanyID,CustomCode,MethodID,Descriptions,CompanyID,EffectiveDate,IsActive
				,StatusID,DBID,CreateBy,CreateOn,CreatePc,UpdateBy,UpdateOn,UpdatePc,IsDeleted,DeleteBy,DeleteOn,DeletePc,Transfer
from XERP_FAAR.dbo.AccCashflowMethodMapCompany 
update AccCashflowMethodMapCompany Set CompanyID=@CompanyID
--------------------------------------------------------------
insert into AccCashFlowClass
select * from XERP_FAAR.dbo.AccCashFlowClass 
update AccCashFlowClass  Set CompanyID=@CompanyID
--------------------------------------------------------------
insert into AccCashFlowSubClass
select * from XERP_FAAR.dbo.AccCashFlowSubClass
update  AccCashFlowSubClass Set CompanyID=@CompanyID
--------------------------------------------------------------
--insert into AccCashflowCOAMap
--select * from XERP_FAAR.dbo.AccCashflowCOAMap
--update  AccCashflowCOAMap  Set CompanyID=@CompanyID
INSERT AccCashflowCOAMap (CashFlowCOAMapID, CustomCode, CashFlowSubClassID, COAID, Descriptions, IsCarryforward, IsBegining, CostCenterID, ProjectID, EffectiveDate, IsActive, StatusID, CompanyID, DBID, CreateBy, CreateOn, CreatePc, UpdateBy, UpdateOn, UpdatePc, IsDeleted, DeleteBy, DeleteOn, DeletePc, Transfer) VALUES (18, N'18', 11, 11, N'test', 1, 0, NULL, NULL, CAST(0x0000A13900000000 AS DateTime), 1, NULL, 2, 1, 1, CAST(0x0000A2E200000000 AS DateTime), NULL, 1, CAST(0x0000A2E200000000 AS DateTime), NULL, 0, 1, CAST(0x0000A2E200000000 AS DateTime), NULL, 0)
INSERT AccCashflowCOAMap (CashFlowCOAMapID, CustomCode, CashFlowSubClassID, COAID, Descriptions, IsCarryforward, IsBegining, CostCenterID, ProjectID, EffectiveDate, IsActive, StatusID, CompanyID, DBID, CreateBy, CreateOn, CreatePc, UpdateBy, UpdateOn, UpdatePc, IsDeleted, DeleteBy, DeleteOn, DeletePc, Transfer) VALUES (19, N'19', 13, 11, N'desc test', 0, 0, NULL, NULL, CAST(0x0000A13900000000 AS DateTime), 1, NULL, 2, 1, 1, CAST(0x0000A2E400000000 AS DateTime), NULL, 1, CAST(0x0000A2E400000000 AS DateTime), NULL, 0, 1, CAST(0x0000A2E400000000 AS DateTime), NULL, 0)
INSERT AccCashflowCOAMap (CashFlowCOAMapID, CustomCode, CashFlowSubClassID, COAID, Descriptions, IsCarryforward, IsBegining, CostCenterID, ProjectID, EffectiveDate, IsActive, StatusID, CompanyID, DBID, CreateBy, CreateOn, CreatePc, UpdateBy, UpdateOn, UpdatePc, IsDeleted, DeleteBy, DeleteOn, DeletePc, Transfer) VALUES (110, N'110', 14, 12, N'', 0, 0, NULL, NULL, CAST(0x0000A13900000000 AS DateTime), 1, NULL, 2, 1, 1, CAST(0x0000A2E400000000 AS DateTime), NULL, 1, CAST(0x0000A2E400000000 AS DateTime), NULL, 0, 1, CAST(0x0000A2E400000000 AS DateTime), NULL, 0)
INSERT AccCashflowCOAMap (CashFlowCOAMapID, CustomCode, CashFlowSubClassID, COAID, Descriptions, IsCarryforward, IsBegining, CostCenterID, ProjectID, EffectiveDate, IsActive, StatusID, CompanyID, DBID, CreateBy, CreateOn, CreatePc, UpdateBy, UpdateOn, UpdatePc, IsDeleted, DeleteBy, DeleteOn, DeletePc, Transfer) VALUES (111, N'111', 16, 12, N'', 0, 0, NULL, NULL, CAST(0x0000A13900000000 AS DateTime), 1, NULL, 2, 1, 1, CAST(0x0000A2E400000000 AS DateTime), NULL, 1, CAST(0x0000A2E400000000 AS DateTime), NULL, 0, 1, CAST(0x0000A2E400000000 AS DateTime), NULL, 0)
INSERT AccCashflowCOAMap (CashFlowCOAMapID, CustomCode, CashFlowSubClassID, COAID, Descriptions, IsCarryforward, IsBegining, CostCenterID, ProjectID, EffectiveDate, IsActive, StatusID, CompanyID, DBID, CreateBy, CreateOn, CreatePc, UpdateBy, UpdateOn, UpdatePc, IsDeleted, DeleteBy, DeleteOn, DeletePc, Transfer) VALUES (112, N'112', 13, 13, N'', 0, 0, NULL, NULL, CAST(0x0000A13900000000 AS DateTime), 1, NULL, 2, 1, 1, CAST(0x0000A2E400000000 AS DateTime), NULL, 1, CAST(0x0000A2E400000000 AS DateTime), NULL, 0, 1, CAST(0x0000A2E400000000 AS DateTime), NULL, 0)
INSERT AccCashflowCOAMap (CashFlowCOAMapID, CustomCode, CashFlowSubClassID, COAID, Descriptions, IsCarryforward, IsBegining, CostCenterID, ProjectID, EffectiveDate, IsActive, StatusID, CompanyID, DBID, CreateBy, CreateOn, CreatePc, UpdateBy, UpdateOn, UpdatePc, IsDeleted, DeleteBy, DeleteOn, DeletePc, Transfer) VALUES (113, N'113', 14, 13, N'', 0, 0, NULL, NULL, CAST(0x0000A13900000000 AS DateTime), 1, NULL, 2, 1, 1, CAST(0x0000A2E400000000 AS DateTime), NULL, 1, CAST(0x0000A2E400000000 AS DateTime), NULL, 0, 1, CAST(0x0000A2E400000000 AS DateTime), NULL, 0)
INSERT AccCashflowCOAMap (CashFlowCOAMapID, CustomCode, CashFlowSubClassID, COAID, Descriptions, IsCarryforward, IsBegining, CostCenterID, ProjectID, EffectiveDate, IsActive, StatusID, CompanyID, DBID, CreateBy, CreateOn, CreatePc, UpdateBy, UpdateOn, UpdatePc, IsDeleted, DeleteBy, DeleteOn, DeletePc, Transfer) VALUES (114, N'114', 16, 14, N'', 0, 0, NULL, NULL, CAST(0x0000A13900000000 AS DateTime), 1, NULL, 2, 1, 1, CAST(0x0000A2E400000000 AS DateTime), NULL, 1, CAST(0x0000A2E400000000 AS DateTime), NULL, 0, 1, CAST(0x0000A2E400000000 AS DateTime), NULL, 0)
INSERT AccCashflowCOAMap (CashFlowCOAMapID, CustomCode, CashFlowSubClassID, COAID, Descriptions, IsCarryforward, IsBegining, CostCenterID, ProjectID, EffectiveDate, IsActive, StatusID, CompanyID, DBID, CreateBy, CreateOn, CreatePc, UpdateBy, UpdateOn, UpdatePc, IsDeleted, DeleteBy, DeleteOn, DeletePc, Transfer) VALUES (115, N'115', 14, 14, N'', 0, 0, NULL, NULL, CAST(0x0000A13900000000 AS DateTime), 1, NULL, 2, 1, 1, CAST(0x0000A2E400000000 AS DateTime), NULL, 1, CAST(0x0000A2E400000000 AS DateTime), NULL, 0, 1, CAST(0x0000A2E400000000 AS DateTime), NULL, 0)
INSERT AccCashflowCOAMap (CashFlowCOAMapID, CustomCode, CashFlowSubClassID, COAID, Descriptions, IsCarryforward, IsBegining, CostCenterID, ProjectID, EffectiveDate, IsActive, StatusID, CompanyID, DBID, CreateBy, CreateOn, CreatePc, UpdateBy, UpdateOn, UpdatePc, IsDeleted, DeleteBy, DeleteOn, DeletePc, Transfer) VALUES (116, N'116', 16, 15, N'', 0, 0, NULL, NULL, CAST(0x0000A13900000000 AS DateTime), 1, NULL, 2, 1, 1, CAST(0x0000A2E400000000 AS DateTime), NULL, 1, CAST(0x0000A2E400000000 AS DateTime), NULL, 0, 1, CAST(0x0000A2E400000000 AS DateTime), NULL, 0)
INSERT AccCashflowCOAMap (CashFlowCOAMapID, CustomCode, CashFlowSubClassID, COAID, Descriptions, IsCarryforward, IsBegining, CostCenterID, ProjectID, EffectiveDate, IsActive, StatusID, CompanyID, DBID, CreateBy, CreateOn, CreatePc, UpdateBy, UpdateOn, UpdatePc, IsDeleted, DeleteBy, DeleteOn, DeletePc, Transfer) VALUES (117, N'117', 14, 15, N'', 0, 0, NULL, NULL, CAST(0x0000A13900000000 AS DateTime), 1, NULL, 2, 1, 1, CAST(0x0000A2E400000000 AS DateTime), NULL, 1, CAST(0x0000A2E400000000 AS DateTime), NULL, 0, 1, CAST(0x0000A2E400000000 AS DateTime), NULL, 0)
INSERT AccCashflowCOAMap (CashFlowCOAMapID, CustomCode, CashFlowSubClassID, COAID, Descriptions, IsCarryforward, IsBegining, CostCenterID, ProjectID, EffectiveDate, IsActive, StatusID, CompanyID, DBID, CreateBy, CreateOn, CreatePc, UpdateBy, UpdateOn, UpdatePc, IsDeleted, DeleteBy, DeleteOn, DeletePc, Transfer) VALUES (118, N'118', 14, 16, N'', 0, 0, NULL, NULL, CAST(0x0000A13900000000 AS DateTime), 1, NULL, 2, 1, 1, CAST(0x0000A2E400000000 AS DateTime), NULL, 1, CAST(0x0000A2E400000000 AS DateTime), NULL, 0, 1, CAST(0x0000A2E400000000 AS DateTime), NULL, 0)
INSERT AccCashflowCOAMap (CashFlowCOAMapID, CustomCode, CashFlowSubClassID, COAID, Descriptions, IsCarryforward, IsBegining, CostCenterID, ProjectID, EffectiveDate, IsActive, StatusID, CompanyID, DBID, CreateBy, CreateOn, CreatePc, UpdateBy, UpdateOn, UpdatePc, IsDeleted, DeleteBy, DeleteOn, DeletePc, Transfer) VALUES (119, N'119', 14, 16, N'', 0, 0, NULL, NULL, CAST(0x0000A13900000000 AS DateTime), 1, NULL, 2, 1, 1, CAST(0x0000A2E400000000 AS DateTime), NULL, 1, CAST(0x0000A2E400000000 AS DateTime), NULL, 0, 1, CAST(0x0000A2E400000000 AS DateTime), NULL, 0)
INSERT AccCashflowCOAMap (CashFlowCOAMapID, CustomCode, CashFlowSubClassID, COAID, Descriptions, IsCarryforward, IsBegining, CostCenterID, ProjectID, EffectiveDate, IsActive, StatusID, CompanyID, DBID, CreateBy, CreateOn, CreatePc, UpdateBy, UpdateOn, UpdatePc, IsDeleted, DeleteBy, DeleteOn, DeletePc, Transfer) VALUES (120, N'120', 14, 17, N'', 0, 0, NULL, NULL, CAST(0x0000A13900000000 AS DateTime), 1, NULL, 2, 1, 1, CAST(0x0000A2E400000000 AS DateTime), NULL, 1, CAST(0x0000A2E400000000 AS DateTime), NULL, 0, 1, CAST(0x0000A2E400000000 AS DateTime), NULL, 0)
INSERT AccCashflowCOAMap (CashFlowCOAMapID, CustomCode, CashFlowSubClassID, COAID, Descriptions, IsCarryforward, IsBegining, CostCenterID, ProjectID, EffectiveDate, IsActive, StatusID, CompanyID, DBID, CreateBy, CreateOn, CreatePc, UpdateBy, UpdateOn, UpdatePc, IsDeleted, DeleteBy, DeleteOn, DeletePc, Transfer) VALUES (121, N'121', 14, 17, N'', 0, 0, NULL, NULL, CAST(0x0000A13900000000 AS DateTime), 1, NULL, 2, 1, 1, CAST(0x0000A2E400000000 AS DateTime), NULL, 1, CAST(0x0000A2E400000000 AS DateTime), NULL, 0, 1, CAST(0x0000A2E400000000 AS DateTime), NULL, 0)
INSERT AccCashflowCOAMap (CashFlowCOAMapID, CustomCode, CashFlowSubClassID, COAID, Descriptions, IsCarryforward, IsBegining, CostCenterID, ProjectID, EffectiveDate, IsActive, StatusID, CompanyID, DBID, CreateBy, CreateOn, CreatePc, UpdateBy, UpdateOn, UpdatePc, IsDeleted, DeleteBy, DeleteOn, DeletePc, Transfer) VALUES (122, N'122', 14, 18, N'', 0, 0, NULL, NULL, CAST(0x0000A13900000000 AS DateTime), 1, NULL, 2, 1, 1, CAST(0x0000A2E400000000 AS DateTime), NULL, 1, CAST(0x0000A2E400000000 AS DateTime), NULL, 0, 1, CAST(0x0000A2E400000000 AS DateTime), NULL, 0)
INSERT AccCashflowCOAMap (CashFlowCOAMapID, CustomCode, CashFlowSubClassID, COAID, Descriptions, IsCarryforward, IsBegining, CostCenterID, ProjectID, EffectiveDate, IsActive, StatusID, CompanyID, DBID, CreateBy, CreateOn, CreatePc, UpdateBy, UpdateOn, UpdatePc, IsDeleted, DeleteBy, DeleteOn, DeletePc, Transfer) VALUES (123, N'123', 14, 18, N'', 0, 0, NULL, NULL, CAST(0x0000A13900000000 AS DateTime), 1, NULL, 2, 1, 1, CAST(0x0000A2E400000000 AS DateTime), NULL, 1, CAST(0x0000A2E400000000 AS DateTime), NULL, 0, 1, CAST(0x0000A2E400000000 AS DateTime), NULL, 0)
INSERT AccCashflowCOAMap (CashFlowCOAMapID, CustomCode, CashFlowSubClassID, COAID, Descriptions, IsCarryforward, IsBegining, CostCenterID, ProjectID, EffectiveDate, IsActive, StatusID, CompanyID, DBID, CreateBy, CreateOn, CreatePc, UpdateBy, UpdateOn, UpdatePc, IsDeleted, DeleteBy, DeleteOn, DeletePc, Transfer) VALUES (124, N'124', 14, 19, N'', 0, 0, NULL, NULL, CAST(0x0000A13900000000 AS DateTime), 1, NULL, 2, 1, 1, CAST(0x0000A2E400000000 AS DateTime), NULL, 1, CAST(0x0000A2E400000000 AS DateTime), NULL, 0, 1, CAST(0x0000A2E400000000 AS DateTime), NULL, 0)
INSERT AccCashflowCOAMap (CashFlowCOAMapID, CustomCode, CashFlowSubClassID, COAID, Descriptions, IsCarryforward, IsBegining, CostCenterID, ProjectID, EffectiveDate, IsActive, StatusID, CompanyID, DBID, CreateBy, CreateOn, CreatePc, UpdateBy, UpdateOn, UpdatePc, IsDeleted, DeleteBy, DeleteOn, DeletePc, Transfer) VALUES (125, N'125', 14, 19, N'', 0, 0, NULL, NULL, CAST(0x0000A13900000000 AS DateTime), 1, NULL, 2, 1, 1, CAST(0x0000A2E400000000 AS DateTime), NULL, 1, CAST(0x0000A2E400000000 AS DateTime), NULL, 0, 1, CAST(0x0000A2E400000000 AS DateTime), NULL, 0)
--------------------------------------------------------------

----Income:
insert into AccIncomeStatementHeadCategory
select * from XERP_FAAR.dbo.AccIncomeStatementHeadCategory
update  AccIncomeStatementHeadCategory Set CompanyID=@CompanyID

----Income:
insert into AccIncomeStatementHead(HeadID,CustomCode,HeadName,HeadCategoryID,Sequence,OperationOperator,IsActive,CompanyID
								,DBID,CreateBy,CreateOn,CreatePc,UpdateBy,UpdateOn,UpdatePc,IsDeleted,DeleteBy,DeleteOn,DeletePc,Transfer)
select HeadID,CustomCode,HeadName,HeadCategoryID,Sequence,OperationOperator,IsActive,CompanyID
								,DBID,CreateBy,CreateOn,CreatePc,UpdateBy,UpdateOn,UpdatePc,IsDeleted,DeleteBy,DeleteOn,DeletePc,Transfer
from XERP_FAAR.dbo.AccIncomeStatementHead 
update  AccIncomeStatementHead Set CompanyID=@CompanyID
--------------------------------------------------------------
insert into AccIncomeStatementHeadCOAMap
select * from XERP_FAAR.dbo.AccIncomeStatementHeadCOAMap 
update  AccIncomeStatementHeadCOAMap Set CompanyID=@CompanyID

-----------------HRM:
insert into HRMMonth 
select * from XERP_FAAR.dbo.HRMMonth
update  HRMMonth Set CompanyID=@CompanyID
--------------------------------------------------------------
insert into HRMDayStatus
select * from XERP_FAAR.dbo.HRMDayStatus
update  HRMDayStatus Set CompanyID=@CompanyID
--------------------------------------------------------------
insert into HRMOfficialSettingType 
select * from XERP_FAAR.dbo.HRMOfficialSettingType
update HRMOfficialSettingType Set CompanyID=@CompanyID
--------------------------------------------------------------
insert into HRMWeekendAndHolidayPolicyList 
select * from XERP_FAAR.dbo.HRMWeekendAndHolidayPolicyList
update HRMWeekendAndHolidayPolicyList Set CompanyID=@CompanyID
--------------------------------------------------------------
insert into HRMLeaveType 
select * from XERP_FAAR.dbo.HRMLeaveType
update HRMLeaveType Set CompanyID=@CompanyID
--------------------------------------------------------------
insert into HRMSalaryHeadType 
select * from XERP_FAAR.dbo.HRMSalaryHeadType
update HRMSalaryHeadType Set CompanyID=@CompanyID
--------------------------------------------------------------
insert into HRMSalaryHead(SalaryHeadID,CustomCode,SalaryHead,SalaryHeadTypeID,IsVATRequired,CompanyID,IsActive,StatusID,DBID,CreateBy,CreateOn,CreatePc,IsDeleted,Transfer,IsVisible) 
select SalaryHeadID,CustomCode,SalaryHead,SalaryHeadTypeID,IsVATRequired,CompanyID,IsActive,StatusID,DBID,CreateBy,CreateOn,CreatePc,IsDeleted,Transfer,IsVisible
from XERP_FAAR.dbo.HRMSalaryHead
update HRMSalaryHead Set CompanyID=@CompanyID
----------------------------
insert into HRMDeviceDataFileType
select * from XERP_FAAR.dbo.HRMDeviceDataFileType
update HRMDeviceDataFileType Set CompanyID=@CompanyID
----------------------------

--Insert Into BilBillingPolicyMaster
--Select * from XERP_FAAR.dbo.BilBillingPolicyMaster 

--Update BilBillingPolicyMaster
--Set CompanyID=3


Insert Into CmnDocListFormatAutoNo
Select * from XERP_FAAR.dbo.CmnDocListFormatAutoNo Where Prefix in(
'CmnPartnerType',
'CmnPartnerDetail',
'CmnCompanyCategory',
'CmnCompanyCategory',
'CmnCompanyType',
'CmnCompany',
'CmnModuleList',
'CmnDataBaseLocation',
'CmnDocType',
'CmnDocList',
'CmnDocListTableMapping',
'CmnPermissionGroup',
'CmnPermissionGroupDoc',
'CmnModuleFormCompany',
'CmnUserType',
'CmnAddressCountry',
'CmnCurrencyMaster',
'CmnUserGender',
'CmnUserReligion',
'CmnUserGroup',
'CmnUserPriorityType',
'CmnOrganogramType',
'CmnChartOfAccountsBase',
'CmnChartOfAccountType',
'CmnChartOfAccount',
'CmnUserInfo',
'CmnUserAuthentication',
'CmnPermissionGroupUser',
'CmnTransactionType',
'CmnTransactionReferenceType',
'CmnTransactionReferenceTypeDetail',
'CmnItemPriceMethod',
'InvItemPriceMethod',
'CmnItemCategory',
'BilBillStatus',
'AccJournalType',
'AccChequeTransectionType',
'AccChequeStatusList',
'CmnDeliveryType',
'CmnTaxType',
'CmnTaxCategory',
'CmnTaxMaster',
'BilBillType',
'BilBillingType',
'BilBillingDuration',
'SalSalesCategory',
'InvDOType',
'CmnStatusList',
'CmnItemAccountType',
'CmnUserAccountType',
'CmnAccountIntegrationSetting',
'CmnCarrierTYpe',
'CmnAddressType',
'PurQuotationType',
'CmnBatchType',
'CmnDashBoardType',
'CmnDashBoardPanel',
'CmnDashBoard',
'CmnPeriodType',
'CmnPaymentMethod',
'CmnPaymentTerm',
'CmnYear',
'SalSalesType')
And Prefix Not in(Select Prefix from CmnDocListFormatAutoNo)

--Update CmnDocListFormatAutoNo Set CompanyID=1


Select * from CmnDocListFormatAutoNo

--Update B Set B.LastNo=A.LastNo from XERP_FAAR.dbo.CmnDocListFormatAutoNo A
--Join XERP_FAAR.dbo.CmnDocListFormatAutoNo B on A.Prefix=B.Prefix
--Where A.LastNo>B.LastNo

/*
'CmnPartnerType',
'CmnPartnerDetail',
'CmnCompanyCategory',
'CmnCompanyCategory',
'CmnCompanyType',
'CmnCompany',
'CmnModuleList',
'CmnDataBaseLocation',
'CmnDocType',
'CmnDocList',
'CmnDocListTableMapping',
'CmnPermissionGroup',
'CmnPermissionGroupDoc',
'CmnModuleFormCompany',
'CmnUserType',
'CmnAddressCountry',
'CmnCurrencyMaster',
'CmnUserGender',
'CmnUserReligion',
'CmnUserGroup',
'CmnUserPriorityType',
'CmnOrganogramType',
'CmnChartOfAccountsBase',
'CmnChartOfAccountType',
'CmnChartOfAccount',
'CmnUserInfo',
'CmnUserAuthentication',
'CmnPermissionGroupUser',
'CmnTransactionType',
'CmnTransactionReferenceType',
'CmnTransactionReferenceTypeDetail',
'CmnItemPriceMethod',
'InvItemPriceMethod',
'CmnItemCategory',
'BilBillStatus',
'AccJournalType',
'AccChequeTransectionType',
'AccChequeStatusList',
'CmnDeliveryType',
'CmnTaxType',
'CmnTaxCategory',
'CmnTaxMaster',
'BilBillType',
'BilBillingType',
'BilBillingDuration',
'SalSalesCategory',
'InvDOType',
'CmnStatusList',
'CmnItemAccountType',
'CmnUserAccountType',
'CmnAccountIntegrationSetting',
'CmnCarrierTYpe',
'CmnAddressType',
'PurQuotationType',
'CmnBatchType',
'CmnDashBoardType',
'CmnDashBoardPanel',
'CmnDashBoard',
'CmnPeriodType',
'CmnPaymentMethod',
'CmnPaymentTerm',
'CmnYear',
'SalSalesType',
'CmnShippingMode',



'CmnOrganogramList',
'CmnOrganogram',
'CmnWorkFlowMaster',
'CmnWorkFlowDetail',
'CmnWorkFlowTransaction',
'CmnDocListFormat',
'CmnDocListFormatAutoNo',
'CmnUOMGroup',
'CmnItemGroup',
'CmnItemBrand',
'CmnItemColor',
'CmnItemCondition',
'CmnItemGrade',
'CmnItemModel',
'CmnItemSpecificationType',
'CmnItemSpecificationParameter',
'CmnItemSpecificationMaster',
'CmnItemSpecificationDetail',
'CmnItemMaster',
'BilBillingPolicyMaster',

*/