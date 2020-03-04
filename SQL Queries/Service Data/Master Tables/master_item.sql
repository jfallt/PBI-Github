SELECT *
	,CASE
	WHEN Name IN ('940', '970-15', '970', '970-15-S', '975', '975-15', '975-S', '975-15-S', '990', 'Quench 990-RO', '992', 'Quench 992-RO', '994', 'Quench 994-RO',
	'980-25-50 Base', '980-50 S', '980-90',  '980-90 S', 'Quench 980 - FS R/O', 'Quench 980-12',  'Quench 980-12 R/O',  'Quench 980-25 R/O',  'Quench 980-50 R/O', 'Quench 980-90 R/O',
	'985-12', '985-25','985-50','985-50 S','985-90','Quench 985-12 R/O','Quench 985-25 R/O','Quench 985-50 R/O','Quench 985-90 R/O')
	THEN 'Pre-Built'
	WHEN Name IN ('Quench 980-12 - Plus - RO', 'Quench 980-25 - Plus - RO', 'Quench 980-50 - Plus - RO', 'Quench 980-90 - Plus - RO', '980-25 Plus', '980-12 Plus S',
	'980-12 Plus', '980-25 Plus S', '980-50 Plus', '980-90 Plus', '985-12 Plus','985-12 Plus S','985-25 Plus','985-25 Plus S','985-50 Plus','985-50 Plus S','985-90 Plus','Quench 985-12 - Plus - RO'
	,'Quench 985-25 - Plus - RO','Quench 985-50 - Plus - RO','Quench 985-90 - Plus - RO', '978', 'Quench 978 R/O','979','Quench 979 R/O')
	THEN 'Rapidly-Built'
	WHEN Name IN ('523', '528', '555-T', '565-T', '92', '94', '96')
	THEN 'Stocked'
	WHEN Primary_Vendor_Name LIKE '%Vivreau%' 
	THEN 'Direct Ship'
	WHEN Name IN ('Bevi-CT', 'Bevi-CT-RM')
	THEN 'Bevi-CT'
	WHEN Name IN ('Bevi-FS', 'Bevi-FS-RM')
	THEN 'Bevi-FS'
	End as SLA_Category
FROM
(SELECT p2.Id
	,ISNULL(sc.Name, p2.Name) as Name
	,p2.Description
	,p2.Family
	,sc.Sub_Category__c as Sub_Category
	,i.Primary_Vendor_Name
	,CASE WHEN p2.id = '01t36000003PhJfAAK'
	THEN 'Special order'
	WHEN Legacy_Unit_Flag = 1
	THEN 'Legacy Item'
	WHEN Stocking_Strategy IS NULL
	THEN 'Unknown'
	ELSE i.Stocking_Strategy END as Stocking_Type
	,CASE WHEN p2.id = '01t36000003PhJfAAK'
	THEN '30'
	ELSE sc.lead_time__c END as Lead_Time
	FROM dbo.Product2 p2
		LEFT JOIN DRP_FF_Test.Items_v i on i.SFId = p2.Integration_SCM_Item_External_Id__c
		LEFT JOIN [Temporal].[SCMCItem] sc on sc.Id = Integration_SCM_Item_External_Id__c) a
