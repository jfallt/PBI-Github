SELECT *
	,CASE
		WHEN
			FieldStatus = 'Additional Work Required' AND ResCode LIKE '%Tech%'
			THEN 'Tech'
			WHEN FieldStatus = 'Additional Work Required' AND ResCode LIKE '%Parts%'
			THEN 'Parts'
			WHEN FieldStatus = 'Additional Work Required' AND ResCode IN ('Equip - Swap Temp', 'Equip - Swap Needed')
			THEN 'Swap Required'
			WHEN FieldStatus = 'Additional Work Required' AND ResCode LIKE '%Cust%'
			THEN 'Cust'
			WHEN FieldStatus = 'Additional Work Required' AND ResCode LIKE '%Site%'
			THEN 'Site'
			WHEN ResCode = 'Equip - WO Incorrect'
			THEN 'WO Incorrect'
			WHEN FieldStatus = 'Additional Work Required'
			THEN 'Other'
			ELSE 'Resolution'
		END as ResCodeGroup
FROM
(SELECT Resolution_Code__c as ResCode
,CASE WHEN Resolution_Code__c IN ('Tech - Needs Reschedule'
								,'Tech - Need Tools'
								,'Tech - Manpower Needed'
								,'Tech - No ResCode'
								,'Site - Utilites Incomp.'
								,'Site - COI'
								,'Site - Lift Required'
								,'Site - No Dock Access'
								,'Parts - Not Avail'
								,'Parts - In Shed'
								,'Equip - WO Incorrect'
								,'Equip - Swap Temp'
								,'Equip - Swap Needed'
								,'Equip - Needed Clearance'
								,'Equip - Engage 3rd Party (PS OK)'
								,'Equip - Damaged In Ship'
								,'Cust - Unavailable'
								,'Cust - Turned Away'
								,'Cust - Site Not Ready'
								,'Cust - Incorrect Address'
								,'Cust - Had to Leave'
								,'Cust - No Water'
								,'Other - Add Notes'
								,'No ResCode')
THEN 'Additional Work Required'
ELSE 'Completed'
END as FieldStatus

FROM (SELECT DISTINCT ISNULL(Resolution_Code__c, 'No ResCode') as Resolution_Code__c FROM Temporal.SVMXCServiceOrder) a
) b