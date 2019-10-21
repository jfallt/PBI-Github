SELECT DISTINCT Problem_Code__c as ProblemCode
	, CASE
		WHEN Problem_Code__c IN ('Delivery'
								,'PestInf'
								,'SwapFS'
								,'TS'
								,'SubMgmt'
								,'RMVLSERV'
								,'SiteSur'
								,'Retrofit'
								,'ReloReq'
								,'INSLEASE'
								,'CustPM'
								,'AutoPm')
		THEN 'Other'
		WHEN Problem_Code__c IN ('UnitBeep', 'UnitErr')
		THEN 'Unit Error/Beep' 
		WHEN Problem_Code__c IN ('ClrdWtr', 'PoorIceQ', 'PoorTst', 'PrtInWtr')
		THEN 'Water/Ice Quality'
		WHEN Problem_Code__c IN ('CustPM', 'AutoPm')
		THEN 'PM' 
		ELSE Problem_Code__c
		END as ProblemCodeGroup
FROM temporal.SVMXCServiceORder
WHERE SVMXC__Order_Type__c IN ('Emergency', 'Standard')
AND Problem_Code__c IS NOT NULL

UNION ALL

SELECT
'None', 'Other'