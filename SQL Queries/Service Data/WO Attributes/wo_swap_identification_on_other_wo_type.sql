---------------------------------------------------------------------
-------------------Pull swap reasons from notes----------------------
---------------------------------------------------------------------
DROP TABLE IF EXISTS #pre_processing_swap_on_other_wo

CREATE TABLE #pre_processing_swap_on_other_wo (wo_id nvarchar (MAX)
							 ,reason_code nvarchar (MAX)
							 ,notes nvarchar (MAX)
							 ,order_type nvarchar (MAX)
							 ,wo_notes nvarchar (MAX)
							 ,res_code nvarchar (MAX)
							 ,problem_code nvarchar (MAX)
							 ,field_add nvarchar (MAX))

INSERT INTO #pre_processing_swap_on_other_wo

SELECT so.Id as wo_id
	,qwo.Reason_Code__c
	/*,CASE WHEN qwo.Notes__c LIKE '%Reason For Swap:%' 
			THEN TRIM(SUBSTRING(qwo.Notes__c, CHARINDEX('Reason For Swap:', qwo.Notes__c) + LEN('Reason For Swap:'), LEN(qwo.Notes__c)))
			ELSE qwo.Notes__c
		END AS Notes*/
	,qwo.Notes__c as Notes
	,so.SVMXC__Order_Type__c
	,SVMXC__Work_Performed__c as wo_notes
	,Resolution_Code__c
	,Problem_Code__c
	,SMAX_PS_Field_Add_Required__c
FROM Temporal.SVMXCServiceOrder so
	LEFT JOIN Temporal.QforceWorkOrder qwo on qwo.Id = so.qWork_Order__c
WHERE SVMXC__Order_Type__c IN ('Emergency', 'PM', 'PM TNM', 'Standard')
	AND SVMXC__Order_Status__c = 'Complete'
	AND SVMX_PS_Override_Order_Type__c = 'Swap'

---------------------------------------------------------------------
----------------Find if associated with other WO---------------------
---------------------------------------------------------------------
DROP TABLE IF EXISTS #add_origin_wo_swap_on_other_wo

CREATE TABLE #add_origin_wo_swap_on_other_wo   (wo_id nvarchar (MAX)
							  ,notes nvarchar (MAX)
							  ,origin_wo nvarchar (MAX)
							  ,wo_start nvarchar (MAX)
							  ,reason_code nvarchar (MAX)
							  ,wo_notes nvarchar (MAX)
							  ,res_code nvarchar (MAX)
							  ,problem_code nvarchar (MAX)
							  ,field_add nvarchar (MAX))

INSERT INTO #add_origin_wo_swap_on_other_wo

SELECT wo_id 
	,notes		
	,CASE WHEN Notes LIKE '% WO-%[0-9]%[0-9]%' --regex to find SVMXC work orders
		THEN TRIM(SUBSTRING(Notes, CHARINDEX('WO-', Notes), LEN('WO-[0-9]'))) --format correctly and remove white space
		WHEN Notes LIKE '% QWO-%[0-9]%[0-9]%' --regex to find qwork orders
		THEN TRIM(SUBSTRING(Notes, CHARINDEX('QWO-', Notes), LEN('QWO-[0-9]'))) --format correctly and remove white space
		ELSE NULL
		END AS origin_wO
	,CASE WHEN Notes LIKE '% WO-%[0-9]%[0-9]%'
		THEN 'WO-'
		WHEN Notes LIKE '% QWO-%[0-9]%[0-9]%'
		THEN 'QWO-'
		ELSE NULL
		END AS wo_start
	,reason_code
	,wo_notes
	,res_code
	,problem_code
	,field_add
FROM #pre_processing_swap_on_other_wo

---------------------------------------------------------------------
----------------Assign reasons based on notes------------------------
---------------------------------------------------------------------
DROP TABLE IF EXISTS #assign_reasons_swap_on_other_wo 

CREATE TABLE #assign_reasons_swap_on_other_wo  (wo_id nvarchar (MAX)
							  ,notes nvarchar (MAX)
							  ,swap_reason nvarchar (MAX)
							  ,origin_wo nvarchar (MAX)
							  ,reason_code nvarchar (MAX)
							  ,wo_notes nvarchar (MAX)
							  ,res_code nvarchar (MAX)
							  ,problem_code nvarchar (MAX)
							  ,field_add nvarchar (MAX))

INSERT INTO #assign_reasons_swap_on_other_wo

SELECT wo_id
	,Notes
	,CASE
	----Not a Swap------------------------------------------------------------------
		WHEN res_code IN ('Equip - Turned Power On'
						 ,'Leak Detect - Dried/Reset'
						 ,'Spigots - Repair/Replace'
						 ,'Replace Fitting'
						 ,'Equip - Serviced RO Tank'
						 ,'Tstat/solenoid - Replace'
						 ,'Equip - Flushed Filters'
						 ,'No Problem Found'
						 ,'Reset Power/Plugged In Unit'
						 ,'Equip - Replaced Filters')
		THEN 'Not a Swap'
	----New Install------------------------------------------------------------------
		WHEN notes LIKE '%just install%'				THEN 'Other'
		WHEN notes LIKE '%new install%'					THEN 'Other'
		WHEN notes LIKE '%newly install%'				THEN 'Other'
	----Unserviceable (damaged, parts failure, fumigation, pest infest, algae, fire)
		WHEN problem_code IN ('DmgUnit', 'FireSmk', 'NoPower')
														THEN 'Unserviceable'							
		WHEN wo_notes LIKE '%internal leak%'			THEN 'Unserviceable'
		WHEN wo_notes LIKE '%product%'
			AND wo_notes LIKE '%support%'				THEN 'Unserviceable'
		WHEN wo_notes LIKE '%tech%'
			AND wo_notes LIKE '%support%'				THEN 'Unserviceable'
		WHEN wo_notes LIKE '%Dan%'
			AND wo_notes LIKE '%per%'					THEN 'Unserviceable'
		WHEN wo_notes LIKE '%Morris%'					THEN 'Unserviceable'
		WHEN  wo_notes LIKE '%smell%'					THEN 'Unserviceable'
		WHEN wo_notes LIKE '%Ken%'						THEN 'Unserviceable'
		WHEN wo_notes LIKE '%corro%'					THEN 'Unserviceable'
		WHEN wo_notes LIKE '%mold%'						THEN 'Unserviceable'
		WHEN wo_notes LIKE '%coolant%'					THEN 'Unserviceable'
		WHEN wo_notes LIKE '%elect% %short%'			THEN 'Unserviceable'
		WHEN wo_notes LIKE '%unrepair%'					THEN 'Unserviceable'		
		WHEN wo_notes LIKE '% refrig%'					THEN 'Unserviceable'
		WHEN wo_notes LIKE '%freon%'					THEN 'Unserviceable'
		WHEN wo_notes LIKE '% rust%'					THEN 'Unserviceable'
		WHEN wo_notes LIKE '% crack%'					THEN 'Unserviceable'
		WHEN wo_notes LIKE '% pump%'					THEN 'Unserviceable'
		WHEN wo_notes LIKE '%press[eo]r%'				THEN 'Unserviceable'
		WHEN wo_notes LIKE '%hot tank%'					THEN 'Unserviceable'
		WHEN wo_notes LIKE '%cold tank%'				THEN 'Unserviceable'
		WHEN wo_notes LIKE '%damage%'					THEN 'Unserviceable'
		WHEN wo_notes LIKE '%destroyed%'				THEN 'Unserviceable'
		WHEN wo_notes LIKE '%crack%'					THEN 'Unserviceable'
		WHEN wo_notes LIKE '%infest%'					THEN 'Unserviceable'
		WHEN wo_notes LIKE '%algae%'					THEN 'Unserviceable'
		WHEN wo_notes LIKE '%fumigat%'					THEN 'Unserviceable'
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
		WHEN wo_notes LIKE '%bad%'						THEN 'Unserviceable'
		WHEN Notes LIKE '%leak%'						THEN 'Unserviceable'
		WHEN Notes LIKE '%press[eo]r%'					THEN 'Unserviceable'
		WHEN Notes LIKE '%hot tank%'					THEN 'Unserviceable'
		WHEN Notes LIKE '%cold tank%'					THEN 'Unserviceable'
		WHEN Notes LIKE '%damage%'						THEN 'Unserviceable'
		WHEN Notes LIKE '%destroyed%'					THEN 'Unserviceable'
		WHEN Notes LIKE '%crack%'						THEN 'Unserviceable'
		WHEN Notes LIKE '%infest%'						THEN 'Unserviceable'
		WHEN Notes LIKE '%algae%'						THEN 'Unserviceable'
		WHEN Notes LIKE '%fumigat%'						THEN 'Unserviceable'
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
		WHEN wo_notes LIKE '%leak%'						THEN 'Unserviceable'
		WHEN wo_notes LIKE '%thermo%'					THEN 'Unserviceable'
		WHEN wo_notes LIKE '%board%'					THEN 'Unserviceable'
		WHEN wo_notes LIKE '%electric%'					THEN 'Unserviceable'
		WHEN wo_notes LIKE '%[r]us[t]%'
			AND wo_notes NOT LIKE '%trust%'
			AND wo_notes NOT LIKE '%frust%'				THEN 'Unserviceable'
		WHEN wo_notes LIKE '%fork%'
			AND wo_notes LIKE '%lift%'					THEN 'Unserviceable'
		WHEN wo_notes LIKE '%overtime%'					THEN 'Unserviceable'
		WHEN wo_notes LIKE '%refri%'					THEN 'Unserviceable'

	----No Parts--------------------------------------------------------------------	
		WHEN wo_notes LIKE '%no parts%'					THEN 'Parts'
		WHEN wo_notes LIKE '% parts%'					THEN 'Parts'
		WHEN wo_notes LIKE '%part%'
			AND wo_notes LIKE '%order%'					THEN 'Parts'
	----Repeat issue----------------------------------------------------------------
		WHEN Notes LIKE '%no water%'					THEN 'Repeat Issue'
		WHEN Notes LIKE '%repeat%'						THEN 'Repeat Issue'
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
		WHEN wo_notes LIKE '%repeat%'					THEN 'Repeat Issue'
		WHEN wo_notes LIKE '%multiple%'					THEN 'Repeat Issue'
		WHEN wo_notes LIKE '%keeps%'					THEN 'Repeat Issue'
		WHEN wo_notes LIKE '%still%'					THEN 'Repeat Issue'
		WHEN wo_notes LIKE '%has had issues%'			THEN 'Repeat Issue'
		WHEN wo_notes LIKE '%all the time%'				THEN 'Repeat Issue'
		WHEN wo_notes LIKE '%same issue%'				THEN 'Repeat Issue'
		WHEN wo_notes LIKE '%again%'					THEN 'Repeat Issue'
		WHEN wo_notes LIKE '%several%'					THEN 'Repeat Issue'
		WHEN wo_notes LIKE '%recurr%'					THEN 'Repeat Issue'
		WHEN wo_notes LIKE '%ongoing%'					THEN 'Repeat Issue'
		WHEN wo_notes LIKE '%many issue%'				THEN 'Repeat Issue'
		WHEN wo_notes LIKE '%many service%'				THEN 'Repeat Issue'
		WHEN wo_notes LIKE '%constant issue%'			THEN 'Repeat Issue'
		WHEN wo_notes LIKE '%[0-9] service%'			THEN 'Repeat Issue'
		WHEN wo_notes LIKE '%reoccur%'					THEN 'Repeat Issue'
		WHEN wo_notes LIKE '%beep%'						THEN 'Repeat Issue'
		WHEN wo_notes LIKE '%[0-9]rd issue%'			THEN 'Repeat Issue'
	----Old Unit--------------------------------------------------------------------
		WHEN Notes LIKE '% old%'						THEN 'Old Unit'
		WHEN Notes LIKE '%years%'						THEN 'Old Unit'
		WHEN Notes LIKE '% age%'						THEN 'Old Unit'
		WHEN Notes LIKE '%obsolete%'					THEN 'Old Unit'
		WHEN wo_notes LIKE '% old%'						THEN 'Old Unit'
		WHEN wo_notes LIKE '%years%'					THEN 'Old Unit'
		WHEN wo_notes LIKE '% age%'						THEN 'Old Unit'
		WHEN wo_notes LIKE '%obsolete%'					THEN 'Old Unit'
		WHEN wo_notes LIKE 'old%'						THEN 'Old Unit'
	----Customer--------------------------------------------------------------------
		WHEN notes LIKE '%will cancel%'					THEN 'Cancel/Save'
		WHEN Notes LIKE '%customer want%'				THEN 'Customer'
		WHEN Notes LIKE '%client reached out%'			THEN 'Customer'
		WHEN Notes LIKE '%client upset%'				THEN 'Cancel/Save'
		WHEN Notes LIKE '%demanded%'					THEN 'Cancel/Save'
		WHEN Notes LIKE '%customer is requesting%'		THEN 'Customer'
		WHEN Notes LIKE '%Customer Demand%'				THEN 'Customer'
		WHEN Notes LIKE '%Customer request%'			THEN 'Customer'
		WHEN Notes LIKE '%customer is%'					THEN 'Customer'
		WHEN Notes LIKE '%customer approv%'				THEN 'Customer'
		WHEN Notes LIKE '%client approv%'				THEN 'Customer'
		WHEN Notes LIKE '%threat%'						THEN 'Customer'
		WHEN Notes LIKE '%save%'						THEN 'Customer'
		WHEN wo_notes LIKE '%customer request%'			THEN 'Customer'
		WHEN wo_notes LIKE '%cancel%'
			AND wo_notes LIKE '%save%'					THEN 'Cancel/Save'
	----Recommendation-------------------------------------------------------------
		WHEN Origin_WO IS NOT NULL						THEN 'Tech Recommendation'
		WHEN Notes LIKE '%per tech%'					THEN 'Tech Recommendation'
		WHEN Notes LIKE '%per Ken%'						THEN 'Unserviceable'
		WHEN Notes LIKE '%ken neelon%'					THEN 'Unserviceable'
		WHEN Notes LIKE '%dan d%'						THEN 'Unserviceable'
		WHEN Notes LIKE '%tech recommend%'				THEN 'Tech Recommendation'
		WHEN Notes LIKE '%tech/scheduling request%'		THEN 'Tech Recommendation'
		WHEN Notes LIKE '%tech suggest%'				THEN 'Tech Recommendation'
		WHEN Notes LIKE '%product support%'				THEN 'Unserviceable'
		WHEN Notes LIKE  '%tech request%'				THEN 'Tech Recommendation'
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
		WHEN wo_notes LIKE '%follett%'					THEN 'Other'
	----If none of the above apply then---------------------------------------------
		WHEN Notes LIKE '%is no longer%'				THEN 'Unserviceable'
		WHEN Notes LIKE '%is not work%'					THEN 'Unserviceable'
		WHEN Notes LIKE '%is not brew%'					THEN 'Unserviceable'
		WHEN Notes LIKE '%not dispens%'					THEN 'Unserviceable'
		WHEN Notes LIKE '%repairable%'					THEN 'Unserviceable'
		WHEN wo_notes LIKE '%short%'					THEN 'Unserviceable'
	----Missing All Notes-----------------------------------------------------------
		WHEN Notes = 'swap'								THEN 'None Provided'
		WHEN Notes = 'swap for same'					THEN 'None Provided'
		WHEN Notes = 'swap unit'						THEN 'None Provided'
		WHEN Notes IS NULL AND wo_notes IN ('Swapped', 'Swapped Unit'
											,'Swapped Unit Out','Swap Machine'
											,'Unit Swap', 'Swap', 'Standard Swap')
														THEN 'None Provided'
	----Tech couldn't fix on visit--------------------------------------------------
	WHEN wo_notes LIKE '%not cool%'						THEN 'Could Not Fix'
	WHEN wo_notes LIKE  '%not heat%'					THEN 'Could Not Fix'
	WHEN wo_notes LIKE  '%not brew%'					THEN 'Could Not Fix'
	
	--------------------------------------------------------------------------------
		ELSE NULL --'Notes_Require_Analysis'
		END as Swap_Reason
,CASE WHEN Origin_WO IS NOT NULL
	THEN CONCAT(WO_start, RIGHT('000'+ISNULL(substring(Origin_WO,patindex('%[0-9]%', Origin_WO),len(Origin_WO)),''),8))
	ELSE NULL END as Origin_WO
	,reason_code
	,wo_notes
	,res_code
	,problem_code
	,field_add
FROM #add_origin_wo_swap_on_other_wo


SELECT notes
	,wo_notes
	,wo_id	
	,swap_reason
	,problem_code
	,field_add
FROM #assign_reasons_swap_on_other_wo ar
WHERE --problem_code = 'UnitBeep'
swap_reason IS NULL
--AND problem_code = 'AutoPm'
AND wo_notes LIKE '%part%'
AND wo_notes LIKE '%order%'

wo_notes LIKE '%[0-9][0-9][/-][0-9][0-9][/-][0-9][0-9]%'--'%fuse%'

SELECT notes
	,wo_notes
	,wo_id	
	,swap_reason
	,problem_code
	,field_add
FROM #assign_reasons_swap_on_other_wo ar
WHERE --problem_code = 'UnitBeep'
swap_reason IS NULL
--AND problem_code = 'AutoPm'
--AND wo_notes LIKE '%smell%'--'%fuse%'
AND wo_notes LIKE  '%follett%'

SELECT COUNT(*)
	,problem_code
FROM #assign_reasons_swap_on_other_wo ar
WHERE swap_reason IS NULL
GROUP BY problem_code

SELECT notes
	,wo_notes
	,wo_id	
	,swap_reason
	,problem_code
FROM #assign_reasons_swap_on_other_wo ar
WHERE swap_reason IS NULL
AND wo_notes LIKE '%overtime%'


AND wo_notes LIKE '%old%'
AND wo_notes NOT LIKE '%cold%'
--AND wo_notes LIKE '%part%'

SELECT Swap_Reason
	,COUNT(*) as WO_Count
FROM #assign_reasons_swap_on_other_wo
GROUP BY Swap_Reason


SELECT res_code
	,COUNT(*) as WO_Count
FROM #assign_reasons_swap_on_other_wo
GROUP BY res_code
