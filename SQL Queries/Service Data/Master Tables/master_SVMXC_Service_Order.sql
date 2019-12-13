/*
Find missing work orders without products and put them in a temporary table
*/

DROP TABLE IF EXISTS #WO_WITHOUT_PRODUCTS

CREATE TABLE #WO_WITHOUT_PRODUCTS
	(
		id VARCHAR(100),
		SVMXC__Product__c VARCHAR(100)
	)

INSERT INTO #WO_WITHOUT_PRODUCTS
SELECT DISTINCT so.id
	,sip.SVMXC__Product__c
FROM Temporal.SVMXCServiceOrder so
LEFT JOIN Temporal.SVMXCInstalledProduct sip on sip.Q_Number__c = so.Scanned_Q_Number__c
WHERE so.SVMXC__Product__c IS NULL
AND SVMXC__Order_Status__c = 'Complete'
AND sip.SVMXC__Status__c = 'Installed'


/*
Work order query
*/

SELECT s.Id
	,s.[Name] as 'WorkOrder'
	,DATEPART(Hour, (DATEADD(HOUR,-4,s.[CreatedDate]))) as 'CreatedDate (Hour)'
	,CAST(DATEADD(HOUR,-4,s.[CreatedDate]) as DATE) as 'CreatedDate (Date Only)'
	,ISNULL(DATEADD(HOUR,-4,s.[SVMXC__Actual_Resolution__c]), CAST(DATEADD(HOUR,-4,s.[SVMXC__Closed_On__c]) as date))  as 'Actual Resolution' -- work order completion
	,DATEADD(HOUR,-4,s.[SVMXC__Scheduled_Date_Time__c]) as 'Scheduled Date'
	,CASE
		WHEN SVMXC__Order_Type__c IN ('PM', 'Routine') --consolidate due dates into one column based on order type
		THEN DATEADD(HOUR,-4,s.[SVMXC__Preferred_Start_Time__c])
		ELSE DATEADD(HOUR,-4,s.[SVMXC__Resolution_Customer_By__c])
		END as PrefStartTime
	,s.[SVMXC__Order_Type__c] as 'Order Type'
	,s.[SVMXC__Order_Status__c] as 'Order Status'
	,s.[SVMX_PS_Filtration__c] as 'Filtration'
	,s.[SVMX_PS_IP_Q_Number_Short__c] as 'SerialLabel'
	,CAST(s.[SVMX_PS_Location_Zip__c] as TEXT) as Zip
	,s.Shed__c as ShedId
	,s.[Account_Number__c] as 'Account Number'
	,s.[Billable__c] as IsBillable
	,CASE
		WHEN [qSLA_Package__c] LIKE '%Gold%'
		THEN 'Gold'
		WHEN [qSLA_Package__c] LIKE '%Platinum%'
		THEN 'Platinum'
		WHEN [qSLA_Package__c] LIKE '%Silver%'
		THEN 'Silver'
		WHEN [qSLA_Package__c] LIKE '%Bronze%'
		THEN 'Bronze'
		WHEN [qSLA_Package__c] LIKE '%Food%'
		THEN 'Food Service'
		ELSE 'Unknown'
	END as 'SLA'
	,s.[Resolution_Code__c] as 'Resolution Code'
	,s.[Acquisition_Name__c] as 'Acquisition Name'
	,s.[Problem_Code__c] as 'Problem Code'
	--, ISNULL(ISNULL(ISNULL(
	--	s.[SMAX_PS_Region__c]
	--	,q.[Service_Region__c])
	--	,qs.[Service_Region__c])
	--	,qs.Service_Team_Name__c) as 'Region1'
	,s.[Market__c]
	,[Submarket__c] as 'Submarket1'
	,SVMXC__Group_Member__c as TechID
	--,u.[Name] as 'Technician'
	--,t.[Name] as 'PrefTech'
	,s.[Q_Number_In_c__c] as 'Q Number In'
	,s.[Q_Number_Out__c] as 'Q Number Out'
	,s.[Scanned_Q_Number__c] as 'Scanned Q Number'
	,qs.[Service_Coverage__c] as 'ServiceCoverage1'
	,--ISNULL(
		ISNULL(ISNULL(s.[SVMXC__Product__c], SMAX_PS_Field_Add_Product__c), wop.SVMXC__Product__c)
		--,sip.[SVMXC__Product__c])
		as 'ProductKey'
	,s.[Credit_Hold__c] as CreditHold
	--,CASE
	--	WHEN q.[Work_Order_Type__c] = '_RELO_IN'	THEN 'Relocation In'
	--	WHEN q.[Work_Order_Type__c] = '_RELO_OUT'	THEN 'Relocation Out'
	--	WHEN q.[Work_Order_Type__c] = '_RELOSAME'	THEN 'Relocation Same'
	--	WHEN q.[Work_Order_Type__c] = '_RETRO'		THEN 'Retrofit'
	--	WHEN q.[Work_Order_Type__c] = '_CUSTPURCH'	THEN 'Customer Purchase'
	--	WHEN q.[Work_Order_Type__c] = '_SA'			THEN 'Site Audit'
	--	WHEN q.[Work_Order_Type__c] = '_PM'			THEN 'PM'
	--	WHEN q.[Work_Order_Type__c] = '_EM'			THEN 'Emergency'
	--	WHEN q.[Work_Order_Type__c] = '_STND'		THEN 'Standard'
	--	WHEN q.[Work_Order_Type__c] = '_AIRPM'		THEN 'PM'
	--	WHEN q.[Work_Order_Type__c] = '_PMTNM'		THEN 'PM TNM'
	--	WHEN q.[Work_Order_Type__c] = '_PURCH_INS'	THEN 'Purchase Install'
	--	WHEN q.[Work_Order_Type__c] = '_RMVL'		THEN 'Removal'
	--	WHEN q.[Work_Order_Type__c] = '_SWAP'		THEN 'Swap'
	--	WHEN q.[Work_Order_Type__c] = '_ROUTINE'	THEN 'Routine'
	--	WHEN q.[Work_Order_Type__c] = '_REPO'		THEN 'Repossession'
	--	WHEN q.[Work_Order_Type__c] = '_UPGD'		THEN 'Upgrade'
	--	WHEN q.[Work_Order_Type__c] = '_TS'			THEN 'Technical Survey'
	--	WHEN q.[Work_Order_Type__c] = '_INSTALL'	THEN 'Install'
	--	WHEN q.[Work_Order_Type__c] = '_COFFEE'		THEN 'Delivery'
	--	ELSE q.[Work_Order_Type__c]					END as 'QWO_Type'
	,CASE
		WHEN SVMXC__Order_Type__c IN ('Purchase Install', 'Install') AND [SMAX_PS_Project_Name__c] IS NOT NULL -- identify if a work order was part of a project (i.e. Amazon)
		THEN 'Project'
		ELSE 'Single'
	END as InstallationType
	,SVMXC__Work_Performed__c as 'Work Performed'
	,SMAX_PS_Sales_Rep__c as SalesRep
	,CASE WHEN SVMXC__Order_Type__c IN ('Emergency'
									,'Standard'
									,'Routine'
									,'PM'
									,'PM TNM')
		AND SVMXC__Order_Type__c <> SVMX_PS_Override_Order_Type__c -- identify override swap work orders
		THEN SVMX_PS_Override_Order_Type__c
		WHEN SVMXC__Order_Type__c IN ('Emergency'
									,'Standard'
									,'Routine'
									,'PM'
									,'PM TNM')
		AND Q_Number_In_c__c <> Q_Number_Out__c
		THEN 'Swap'
		ELSE NULL
	END as OrderTypeOverride
	,SVMXC__Total_Billable_Amount__c as BillableAmount 
FROM [Temporal].[SVMXCServiceOrder] s
	LEFT JOIN [Temporal].[QforceWorkOrder] q on q.Id = [qWork_Order__c]
	LEFT JOIN [Temporal].[QforceSite] qs on qs.Id = q.[Site__c]
	LEFT JOIN #WO_WITHOUT_PRODUCTS wop on wop.id = s.id
--LEFT JOIN [Temporal].[SVMXCServiceGroupMembers] u on u.[Id] = s.[SVMXC__Group_Member__c]
--LEFT JOIN [Temporal].[SVMXCServiceGroupMembers] t on t.[Id] = s.[SVMXC__Preferred_Technician__c] -- if you need preferred technician, havent' found anything useful for it
--LEFT JOIN [Temporal].[SVMXCInstalledProduct] sip on sip.[Q_Number__c] = Scanned_Q_Number__c AND sip.SVMXC__Status__c = 'Active'
WHERE SVMXC__Order_Type__c IS NOT NULL