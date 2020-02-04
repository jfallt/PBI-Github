/* Purpose: Assign reasons for swaps / remove sales swaps
Step 1: Find opportunities tied to amendment or new sales
Step 2: Connect the work order to the case to the opportunity and then the query from Step 1
Step 3: Identify accounts with more than 2 swaps created on the same day
Step 4: Join step 3 with step 2
Step 5: Parse work orders in work order notes with RegEx - if there's a work order preceding
	the swap we are assuming it's service related (there are some rare cases where the unit is
	old)
Step 6: Assign reasons based on a number of different criteria
*/

---------------------------------------------------------------------
--Step 1: Amendment Sales and New Sales------------------------------
---------------------------------------------------------------------
DROP TABLE IF EXISTS #amendment_sales

CREATE TABLE #amendment_sales (charge_change int
							  ,OpportunityId__c nvarchar (MAX))

INSERT INTO #amendment_sales

SELECT MAX(charge_change) as charge_change -- multiple changes can occur on the same opportunity
	,OpportunityId__c
FROM 
	(
		SELECT ISNULL(MAX(ISNULL(increase_Recurring_Charge__c,0)), MAX(ISNULL(new_RecurringCharge__c,0))) as charge_change
			,OpportunityId__c
		FROM qforce_mv_amendsales
		GROUP BY OpportunityId__c, increase_Recurring_Charge__c
	) a
GROUP BY OpportunityId__c

DROP TABLE IF EXISTS #new_sales

CREATE TABLE #new_sales (charge_change int
						,OpportunityId__c nvarchar (MAX))

INSERT INTO #new_sales

SELECT MAX(ISNULL(RecurringCharge__c,0)) as charge_change -- rolling up all records into one using the max
	,OpportunityId__c
FROM qforce_mv_newsales
GROUP BY OpportunityId__c

---------------------------------------------------------------------
--Step 2: WO -> Case -> Opp -> Charge Change-------------------------
---------------------------------------------------------------------

DROP TABLE IF EXISTS #wo_case_and_opp

CREATE TABLE #wo_case_and_opp  (wo_id nvarchar (MAX)
							 ,SalesNotes nvarchar (MAX)
							 ,Reason_Code__c nvarchar (MAX)
							 ,Notes nvarchar (MAX)
							 ,SVMXC__Order_Type__c nvarchar (MAX)
							 ,Acquisition_Name__c nvarchar (MAX)
							 ,ProjectName nvarchar (MAX)
							 ,wo_notes nvarchar (MAX)
							 ,sales_rep_id nvarchar (MAX)
							 ,case_reason nvarchar (MAX)
							 ,case_subject nvarchar (MAX)
							 ,case_type nvarchar (MAX)
							 ,opportunity_key nvarchar (MAX)
							 ,opportunity_type nvarchar (MAX)
							 ,created_by_role nvarchar (MAX)
							 ,additional_notes nvarchar (MAX)
							 ,charge_change nvarchar (MAX)
							 ,account_id nvarchar (MAX)
							 ,created_date date)

INSERT INTO #wo_case_and_opp

SELECT so.Id as wo_id
	,qwo.Sales_Notes__c as SalesNotes
	,qwo.Reason_Code__c
	/*,CASE WHEN qwo.Notes__c LIKE '%Reason For Swap:%' 
			THEN TRIM(SUBSTRING(qwo.Notes__c, CHARINDEX('Reason For Swap:', qwo.Notes__c) + LEN('Reason For Swap:'), LEN(qwo.Notes__c)))
			ELSE qwo.Notes__c
		END AS Notes*/
	,qwo.Notes__c as Notes
	,so.SVMXC__Order_Type__c
	,so.Acquisition_Name__c
	,SMAX_PS_Project_Name__c as ProjectName
	,SVMXC__Work_Performed__c as wo_notes
	,so.SMAX_PS_Sales_Rep__c as SalesRepID 
	,c.Reason
	,CASE WHEN c.Subject LIKE '%a2R%'
	THEN 'msl_change'
	ELSE c.Subject
	END as [Subject]
	,c.[Type] as case_type
	,o.OpportunityKey__c as opportunity_key
	,o.Type as opportunity_type
	,o.Created_by_Role_Name__c as created_by_role
	,o.Additional_Notes__c as additional_notes
	,CASE
		WHEN ISNULL(ams.charge_change, ans.charge_change) > 25	THEN 'sales_upgrade'
		WHEN ISNULL(ams.charge_change, ans.charge_change) > 0	THEN 'positive'
		WHEN ISNULL(ams.charge_change, ans.charge_change) < 0	THEN 'negative'
		ELSE NULL
	END as charge_change
	,qwo.AccountId__c as account_id
	,CAST(qwo.CreatedDate as DATE) as created_date
FROM Temporal.SVMXCServiceOrder so 
	LEFT JOIN Temporal.QforceWorkOrder qwo on qwo.Id = so.qWork_Order__c
	LEFT JOIN Temporal.[Case] c on c.id = so.SVMXC__Case__c
	LEFT JOIN Temporal.Opportunity o on c.Opportunity_Link__c = o.Id
	LEFT JOIN #amendment_sales ams on o.Id = ams.OpportunityId__c
	LEFT JOIN #new_sales ans on o.Id = ans.OpportunityId__c
WHERE so.SVMXC__Order_Type__c = 'Swap'
	AND SVMXC__Order_Status__c = 'Complete'
---------------------------------------------------------------------
--Step 3: Identify accounts with more than 2 swaps created in a day--
---------------------------------------------------------------------
DROP TABLE IF EXISTS #multiple_swaps

CREATE TABLE #multiple_swaps (WO_Count int,swap_id nvarchar (MAX))

INSERT INTO #multiple_swaps

SELECT COUNT(id) as WO_Count
	,CONCAT(Account__c, CAST(CreatedDate as DATE)) as swap_id
FROM Temporal.QforceWorkOrder qwo
WHERE Work_Order_Type__c = '_SWAP'
GROUP BY CONCAT(Account__c, CAST(CreatedDate as DATE))
HAVING COUNT(id) >= 2

---------------------------------------------------------------------
--Step 4: Join wos with multiple swaps and the associated cases -----
---------------------------------------------------------------------
DROP TABLE IF EXISTS #pre_processing

CREATE TABLE #pre_processing (wo_id nvarchar (MAX)
							 ,SalesNotes nvarchar (MAX)
							 ,Reason_Code__c nvarchar (MAX)
							 ,Notes nvarchar (MAX)
							 ,SVMXC__Order_Type__c nvarchar (MAX)
							 ,Acquisition_Name__c nvarchar (MAX)
							 ,ProjectName nvarchar (MAX)
							 ,wo_notes nvarchar (MAX)
							 ,sales_rep_id nvarchar (MAX)
							 ,case_reason nvarchar (MAX)
							 ,case_subject nvarchar (MAX)
							 ,case_type nvarchar (MAX)
							 ,opportunity_key nvarchar (MAX)
							 ,opportunity_type nvarchar (MAX)
							 ,created_by_role nvarchar (MAX)
							 ,additional_notes nvarchar (MAX)
							 ,charge_change nvarchar (MAX)
							 ,WO_Count int)

INSERT INTO #pre_processing

SELECT wco.wo_id
	,wco.SalesNotes
	,wco.Reason_Code__c
	,wco.Notes
	,wco.SVMXC__Order_Type__c
	,wco.Acquisition_Name__c
	,wco.ProjectName
	,wco.wo_notes
	,wco.sales_rep_id
	,wco.case_reason
	,wco.case_subject
	,wco.case_type
	,wco.opportunity_key
	,wco.opportunity_type
	,wco.created_by_role
	,wco.additional_notes
	,wco.charge_change
	,msp.WO_Count
FROM #wo_case_and_opp wco
	LEFT JOIN #multiple_swaps msp on msp.swap_id = CONCAT(wco.account_id, CAST(wco.created_date as DATE))
---------------------------------------------------------------------
--Step 5: Find associated WOs with RegEx ----------------------------
---------------------------------------------------------------------
DROP TABLE IF EXISTS #add_origin_wo 

CREATE TABLE #add_origin_wo   (wo_id nvarchar (MAX)
							  ,Notes nvarchar (MAX)
							  ,Origin_WO nvarchar (MAX)
							  ,wo_start nvarchar (MAX)
							  ,SalesNotes nvarchar (MAX)
							  ,ReasonCode nvarchar (MAX)
							  ,WO_Count int
							  ,ProjectName nvarchar (MAX)
							  ,wo_notes nvarchar (MAX)
							  ,sales_rep_id nvarchar (MAX)
							  ,case_reason nvarchar (MAX)
							  ,case_subject nvarchar (MAX)
							  ,case_type nvarchar (MAX)
							  ,opportunity_key nvarchar (MAX)
							  ,opportunity_type nvarchar (MAX)
							  ,created_by_role nvarchar (MAX)
							  ,additional_notes nvarchar (MAX)
							  ,charge_change nvarchar (MAX))

INSERT INTO #add_origin_wo

SELECT wo_id 
	,Notes		
	,CASE
		WHEN Notes LIKE '%QWO-%[0-9]%[0-9]%'
		THEN TRIM(SUBSTRING(Notes, CHARINDEX('QWO-', Notes) + 4, LEN('QWO-[0-9]')))
		WHEN Notes LIKE '%WO-%[0-9]%[0-9]%' --regex to find work orders, repeated for qwork order, check Notes, SalesNotes and case_subject
		THEN TRIM(SUBSTRING(Notes, CHARINDEX('WO-', Notes) + 3, LEN('WO-[0-9]'))) --format correctly and remove white space
		WHEN SalesNotes LIKE '%QWO-%[0-9]%[0-9]%'
		THEN TRIM(SUBSTRING(SalesNotes, CHARINDEX('QWO-', SalesNotes) + 4, LEN('QWO-[0-9]')))
		WHEN SalesNotes LIKE '%WO-%[0-9]%[0-9]%'
		THEN TRIM(SUBSTRING(SalesNotes, CHARINDEX('WO-', SalesNotes) + 3, LEN('WO-[0-9]')))
		WHEN case_subject LIKE '%QWO-%[0-9]%[0-9]%'
		THEN TRIM(SUBSTRING(case_subject, CHARINDEX('QWO-', case_subject) + 4, LEN('QWO-[0-9]')))
		WHEN case_subject LIKE '%WO-%[0-9]%[0-9]%'
		THEN TRIM(SUBSTRING(case_subject, CHARINDEX('WO-', case_subject) + 3, LEN('WO-[0-9]')))
		ELSE NULL
		END AS Origin_WO
	,CASE WHEN Notes LIKE '% WO-%[0-9]%[0-9]%' -- add the correct prefix (either SVMXC work order or qWorkorder)
		THEN 'WO-'
		WHEN Notes LIKE '% QWO-%[0-9]%[0-9]%'
		THEN 'QWO-'
		WHEN SalesNotes LIKE '% WO-%[0-9]%[0-9]%'
		THEN 'WO-'
		WHEN SalesNotes LIKE '% QWO-%[0-9]%[0-9]%'
		THEN 'QWO-'
		WHEN case_subject LIKE '% WO-%[0-9]%[0-9]%'
		THEN 'WO-'
		WHEN case_subject LIKE '% QWO-%[0-9]%[0-9]%'
		THEN 'QWO-'
		ELSE NULL
		END AS wo_start
	,SalesNotes
	,Reason_Code__c
	,WO_Count
	,ProjectName
	,wo_notes
	,sales_rep_id
	,case_reason
	,case_subject
	,case_type
	,opportunity_key
	,opportunity_type
	,created_by_role
	,additional_notes
	,charge_change
FROM #pre_processing 
---------------------------------------------------------------------
--Step 6: Assign reasons based on notes------------------------------
---------------------------------------------------------------------
DROP TABLE IF EXISTS #assign_reasons 

CREATE TABLE #assign_reasons  (wo_id nvarchar (MAX)
							  ,Notes nvarchar (MAX)
							  ,Swap_Reason nvarchar (MAX)
							  ,Origin_WO nvarchar (MAX)
							  ,WO_Count int
							  ,ReasonCode nvarchar (MAX)
							  ,wo_notes nvarchar (MAX)
							  ,sales_rep_id nvarchar (MAX)
							  ,sales_notes nvarchar (MAX)
							  ,case_reason nvarchar (MAX)
							  ,case_subject nvarchar (MAX)
							  ,case_type nvarchar (MAX)
							  ,opportunity_key nvarchar (MAX)
							  ,opportunity_type nvarchar (MAX)
							  ,created_by_role nvarchar (MAX)
							  ,additional_notes nvarchar (MAX)
							  ,charge_change nvarchar (MAX))

INSERT INTO #assign_reasons

SELECT wo_id
	,Notes
	,CASE
	----Cancel Saves----------------------------------------------------------------
		WHEN additional_notes LIKE '%cancel%'
			AND additional_notes LIKE '%save%'			THEN 'Cancel/Save'
	----Sales Swaps-----------------------------------------------------------------
		WHEN ProjectName IS NOT NULL					THEN 'Sales'
		--WHEN WO_Count IS NOT NULL
		--AND ReasonCode = 'SubMgmt'					    THEN 'Sales'
		WHEN Notes LIKE '%account manager%'				THEN 'Sales'
		WHEN Notes LIKE '%sales swap%'					THEN 'Sales'
		WHEN Notes LIKE '%upgrad%'						THEN 'Sales'
		WHEN Notes LIKE '%per sales%'					THEN 'Sales'
		WHEN Notes LIKE '%750 w/RO%'					THEN 'Sales'
		WHEN Notes LIKE '%per Stretch%'					THEN 'Sales'
		WHEN Notes LIKE 'Ask for Kate Pollard%'			THEN 'Sales'
		WHEN case_subject LIKE '%Amazon%'				THEN 'Sales'
		WHEN case_subject LIKE '%Upgrade%'				THEN 'Sales'
		WHEN case_subject LIKE '%OP-[0-9]%'				THEN 'Sales'
		WHEN Notes LIKE '%OP-[0-9]%'					THEN 'Sales'
		WHEN case_subject LIKE '%generate%'				THEN 'Sales'
	----Unserviceable (damaged, parts failure, fumigation, pest infest, algae, fire)
		WHEN case_subject LIKE '%broken coffee brewer%'	THEN 'Unserviceable'
		WHEN case_subject LIKE '%damage%'				THEN 'Unserviceable'
		WHEN case_subject LIKE '%leak%'					THEN 'Unserviceable'
		WHEN Notes LIKE '%leak%'						THEN 'Unserviceable'
		WHEN Notes LIKE '%compressor%'					THEN 'Unserviceable'
		WHEN Notes LIKE '%hot tank%'					THEN 'Unserviceable'
		WHEN Notes LIKE '%cold tank%'					THEN 'Unserviceable'
		WHEN Notes LIKE '%damage%'						THEN 'Unserviceable'
		WHEN Notes LIKE '%destroyed%'					THEN 'Unserviceable'
		WHEN ReasonCode = 'DmgUnit'						THEN 'Unserviceable'
		WHEN Notes LIKE '%crack%'						THEN 'Unserviceable'
		WHEN case_subject LIKE '%crack%'				THEN 'Unserviceable'
		WHEN Notes LIKE '%infest%'						THEN 'Unserviceable'
		WHEN Notes LIKE '%algae%'						THEN 'Unserviceable'
		WHEN Notes LIKE '%fumigat%'						THEN 'Unserviceable'
		WHEN case_subject LIKE '%fumigat%'				THEN 'Unserviceable'
		WHEN case_subject LIKE '%infest%'				THEN 'Unserviceable'
		WHEN case_subject LIKE '%compressor%'			THEN 'Unserviceable'
		WHEN Notes LIKE '%smok%'						THEN 'Unserviceable'
		WHEN Notes LIKE '%mouse%'						THEN 'Unserviceable'
		WHEN Notes LIKE '%defect%'						THEN 'Unserviceable'
		WHEN Notes LIKE '%broke%'						THEN 'Unserviceable'
		WHEN Notes LIKE '%shatter%'						THEN 'Unserviceable'
		WHEN Notes LIKE '%quartz sleeve%'				THEN 'Unserviceable'
		WHEN Notes LIKE '%tank%'						THEN 'Unserviceable'
		WHEN Notes LIKE '%power%'						THEN 'Unserviceable'
		WHEN Notes LIKE '%freez%'						THEN 'Unserviceable'
		WHEN Notes LIKE '%froze%'						THEN 'Unserviceable'
		WHEN Notes LIKE '% bad%'						THEN 'Unserviceable'
		WHEN Notes LIKE '% burn%'						THEN 'Unserviceable'
		WHEN Notes LIKE '%burning%'						THEN 'Unserviceable'
		WHEN Notes LIKE '%bent%'						THEN 'Unserviceable'
		WHEN Notes LIKE '% dent %'						THEN 'Unserviceable'
		WHEN wo_notes LIKE '%compressor%'				THEN 'Unserviceable'
		WHEN wo_notes LIKE '%bad%'						THEN 'Unserviceable'
		WHEN wo_notes LIKE '%freez%'					THEN 'Unserviceable'
		WHEN wo_notes LIKE '%multiple%'					THEN 'Unserviceable'
		WHEN wo_notes LIKE '%smok%'						THEN 'Unserviceable'
		WHEN wo_notes LIKE '%mouse%'					THEN 'Unserviceable'
		WHEN wo_notes LIKE '%defect%'					THEN 'Unserviceable'
		WHEN wo_notes LIKE '%broke%'					THEN 'Unserviceable'
		WHEN wo_notes LIKE '%shatter%'					THEN 'Unserviceable'
		WHEN wo_notes LIKE '%quartz sleeve%'			THEN 'Unserviceable'
		WHEN wo_notes LIKE '%tank%'						THEN 'Unserviceable'
		WHEN wo_notes LIKE '%power%'					THEN 'Unserviceable'
		WHEN wo_notes LIKE '%freez%'					THEN 'Unserviceable'
		WHEN wo_notes LIKE '%froze%'					THEN 'Unserviceable'
		WHEN wo_notes LIKE '% bad%'						THEN 'Unserviceable'
		WHEN wo_notes LIKE '% burn%'					THEN 'Unserviceable'
		WHEN wo_notes LIKE '%burning%'					THEN 'Unserviceable'
		WHEN wo_notes LIKE '%bent%'						THEN 'Unserviceable'
		WHEN wo_notes LIKE '% dent %'					THEN 'Unserviceable'
	----Customer--------------------------------------------------------------------
		WHEN case_subject = 'customer order & swaps'	THEN 'Cancel/Save'
		WHEN case_subject LIKE '%cancel%'
			AND case_subject LIKE '%save%'				THEN 'Cancel/Save'
		WHEN case_subject LIKE '%cancel threat%'		THEN 'Cancel/Save'
		WHEN Notes LIKE '%will cancel%'					THEN 'Cancel/Save'
		WHEN Notes LIKE '%customer want%'				THEN 'Customer'
		WHEN Notes LIKE '%client reached out%'			THEN 'Customer'
		WHEN Notes LIKE '%client upset%'				THEN 'Customer'
		WHEN Notes LIKE '%demanded%'					THEN 'Customer'
		WHEN Notes LIKE '%customer is requesting%'		THEN 'Customer'
		WHEN Notes LIKE '%Customer Demand%'				THEN 'Cancel/Save'
		WHEN Notes LIKE '%Customer request%'			THEN 'Customer'
		WHEN Notes LIKE '%customer is%'					THEN 'Customer'
		WHEN Notes LIKE '%customer approv%'				THEN 'Customer'
		WHEN Notes LIKE '%client approv%'				THEN 'Customer'
		WHEN Notes LIKE '%threat%'						THEN 'Cancel/Save'
		WHEN Notes LIKE '%save%'						THEN 'Cancel/Save'
		WHEN wo_notes LIKE '%customer request%'			THEN 'Customer'
		WHEN case_subject = 'Web - Customer Service Request'
														THEN 'Customer'
		WHEN case_subject = 'Service Request'			THEN 'Customer'
		WHEN case_subject LIKE '%customer request%'		THEN 'Customer'
		WHEN case_subject LIKE '%compressor%'			THEN 'Unserviceable'
		WHEN case_subject LIKE '%cancel%'
			AND case_subject LIKE '%save%'				THEN 'Cancel/Save'
		WHEN case_subject LIKE '%cancel%'
			AND case_subject LIKE '%threat%'			THEN 'Cancel/Save'

	---Repeat issue----------------------------------------------------------------
		WHEN case_reason = 'Existing problem'			THEN 'Repeat Issue'
		WHEN ReasonCode NOT IN ('SwapFS','SubMgmt','AddWork','SwapJC','RMVLSERV'
									,'SwapCD','SwapSR')	THEN 'Repeat Issue'
		WHEN Notes LIKE '%no water%'					THEN 'Repeat Issue'
		WHEN Notes LIKE '%repeat%'						THEN 'Repeat Issue'
		WHEN Origin_WO IS NOT NULL						THEN 'Repeat Issue'
		WHEN Notes LIKE '%multiple%'					THEN 'Repeat Issue'
		WHEN Notes LIKE '%keeps%'						THEN 'Repeat Issue'
		WHEN Notes LIKE '%still%'						THEN 'Repeat Issue'
		WHEN Notes LIKE '%has had issues%'				THEN 'Repeat Issue'
		WHEN Notes LIKE '%all the time%'				THEN 'Repeat Issue'
		WHEN Notes LIKE '%same issue%'					THEN 'Repeat Issue'
		WHEN Notes LIKE '%again%'						THEN 'Repeat Issue'
		WHEN Notes LIKE '%several%'						THEN 'Repeat Issue'
		WHEN Notes LIKE '%recurr%'						THEN 'Repeat Issue'
		WHEN Notes LIKE '%ongoing%'						THEN 'Repeat Issue'
		WHEN Notes LIKE '%many issue%'					THEN 'Repeat Issue'
		WHEN Notes LIKE '%many service%'				THEN 'Repeat Issue'
		WHEN Notes LIKE '%constant issue%'				THEN 'Repeat Issue'
		WHEN Notes LIKE '%hot water%'					THEN 'Repeat Issue'
		WHEN Notes LIKE '%hot water%''%cold water%'		THEN 'Repeat Issue'
		WHEN Notes LIKE '%[0-9] service%'				THEN 'Repeat Issue'
		WHEN Notes LIKE '%reoccur%'						THEN 'Repeat Issue'
		WHEN Notes LIKE '%beep%'						THEN 'Repeat Issue'
		WHEN Notes LIKE '%[0-9]rd issue%'				THEN 'Repeat Issue'
		WHEN case_subject LIKE '%repeat issues%'		THEN 'Repeat Issue'
	----Old Unit--------------------------------------------------------------------
		WHEN Notes LIKE '% old%'						THEN 'Old Unit'
		WHEN Notes LIKE '%years%'						THEN 'Old Unit'
		WHEN Notes LIKE '% age%'						THEN 'Old Unit'
		WHEN Notes LIKE '%obsolete%'					THEN 'Old Unit'
		WHEN case_subject LIKE '%obsolete%'				THEN 'Old Unit'
	----Recommendation-------------------------------------------------------------
		--WHEN Origin_WO IS NOT NULL						THEN 'Tech Recommendation'
		WHEN Notes LIKE '%per tech%'					THEN 'Unserviceable'
		WHEN Notes LIKE '%per Ken%'						THEN 'Unserviceable'
		WHEN Notes LIKE '%ken neelon%'					THEN 'Unserviceable'
		WHEN Notes LIKE '%dan d%'						THEN 'Unserviceable'
		WHEN Notes LIKE '%tech recommend%'				THEN 'Unserviceable'
		WHEN Notes LIKE '%tech/scheduling request%'		THEN 'Unserviceable'
		WHEN Notes LIKE '%tech suggest%'				THEN 'Unserviceable'
		WHEN Notes LIKE '%product support%'				THEN 'Unserviceable'
		WHEN Notes LIKE  '%tech request%'				THEN 'Unserviceable'
	----Other----------------------------------------------------------------------
		WHEN Notes LIKE '%out of warranty%'				THEN 'Other'
		WHEN Notes LIKE '%warranty expired%'			THEN 'Other'
		WHEN Notes LIKE '%warranty%'					THEN 'Other'
		WHEN Notes LIKE '%trans%'						THEN 'Other'
		WHEN Notes LIKE '%No IP%'						THEN 'Other'
		WHEN Notes LIKE '% temp unit%'					THEN 'Other'
		WHEN Notes LIKE '% temp install%'				THEN 'Other'
		WHEN Notes LIKE '% temp swap%'					THEN 'Other'
		WHEN Notes LIKE '%placeholder unit%'			THEN 'Other'
		WHEN Notes LIKE '%temp %[A-Z0-9]% unit%'		THEN 'Other'
		WHEN Notes LIKE '%temp %[A-Z0-9]% swap%'		THEN 'Other'
		WHEN Notes LIKE '% temp%'						THEN 'Other'
		WHEN Notes LIKE '%not in system%'				THEN 'Other'
		WHEN Notes LIKE '%temporary%'					THEN 'Other'
		WHEN Notes LIKE '%Carolina Pure%'				THEN 'Other'
		WHEN Notes LIKE '%wrong%'						THEN 'Other'
	----If none of the above apply then---------------------------------------------
		WHEN Notes LIKE '%is no longer%'				THEN 'Unserviceable'
		WHEN Notes LIKE '%is not work%'					THEN 'Unserviceable'
		WHEN Notes LIKE '%is not brew%'					THEN 'Unserviceable'
		WHEN Notes LIKE '%not dispens%'					THEN 'Unserviceable'
		WHEN Notes LIKE '%repairable%'					THEN 'Unserviceable'
		WHEN case_subject LIKE '%repairable%'			THEN 'Unserviceable'
		WHEN Notes LIKE '%reason for swap%'				THEN 'Repeat Issue'
	----If none of the above apply then---------------------------------------------
		WHEN additional_notes LIKE '%upgrade%'			THEN 'Sales'
		WHEN case_type = 'Amendment Needed'
		AND WO_Count IS NOT NULL						THEN 'Sales'
		WHEN sales_rep_id IS NOT NULL					THEN 'Sales'
		WHEN SalesNotes IS NOT NULL						THEN 'Sales'
		WHEN opportunity_key IS NOT NULL
		AND case_subject = 'msl_change'
		AND opportunity_type IN ('Existing AddOn'
								,'New Business')		THEN 'Sales'
		WHEN case_subject IN ('Too Many Equipment Service Issues'
							 ,'Slow Equipment Service Responsiveness'
							 ,'Field Service or Equipment Issues')
														THEN 'Repeat Issue'
		--WHEN WO_Count IS NOT NULL						THEN 'Sales'
	----Missing All Notes-----------------------------------------------------------
		WHEN wo_notes LIKE '%client%'
			AND wo_notes LIKE '%request%'				THEN 'Customer'
		WHEN wo_notes LIKE '%customer%'
			AND wo_notes LIKE '%would like%'			THEN 'Customer'
		WHEN wo_notes LIKE '%numerous%'					THEN 'Customer'
		--WHEN SalesNotes IS NULL
		--AND Notes IS NULL AND WO_Count IS NULL			THEN 'None Provided'
		--WHEN Notes = 'swap'								THEN 'None Provided'
		--WHEN Notes = 'swap for same'					THEN 'None Provided'
		--WHEN Notes = 'swap unit'						THEN 'None Provided'
	--------------------------------------------------------------------------------
		ELSE 'Other' --'Notes_Require_Analysis'
		END as Swap_Reason
,CASE WHEN Origin_WO IS NOT NULL AND wo_start = 'QWO-'
	THEN CONCAT('QWO-',
				RIGHT('000000000'+ISNULL(LEFT(SUBSTRING(Origin_WO
												,PATINDEX('%[0-9]%', Origin_WO), 8000)
												,PATINDEX('%[^0-9]%'
												,SUBSTRING(Origin_WO
												,PATINDEX('%[0-9]%', Origin_WO), 8000) + 'X') -1
											  ),''),9))
	WHEN Origin_WO IS NOT NULL AND wo_start = 'WO-'
	THEN CONCAT('WO-',
				RIGHT('00000000'+ISNULL(LEFT(SUBSTRING(Origin_WO
												,PATINDEX('%[0-9]%', Origin_WO), 8000)
												,PATINDEX('%[^0-9]%'
												,SUBSTRING(Origin_WO
												,PATINDEX('%[0-9]%', Origin_WO), 8000) + 'X') -1
											  ),''),8))
	ELSE NULL END as Origin_WO
	,WO_Count 
	,ReasonCode
	,wo_notes
	,sales_rep_id
	,SalesNotes
	,case_reason
	,case_subject
	,case_type
	,opportunity_key
	,opportunity_type
	,created_by_role
	,additional_notes
	,charge_change
FROM #add_origin_wo

SELECT wo_id
	,Swap_Reason
	,wo_notes
	,additional_notes
	,SalesNotes
	,case_subject
	,opportunity_key
	,charge_change
FROM #assign_reasons