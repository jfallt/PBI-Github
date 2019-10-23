SELECT * FROM
(SELECT id
	,CAST((ISNULL(BD_Time_In_Customer_Hold__c,0) + ISNULL(BD_Time_in_Customer_Success_Hold__c, 0))/60 as decimal(10,2)) as Time_Cust
	,CAST((ISNULL(BD_Time_in_On_Site__c, 0) + ISNULL(BD_Time_in_Service_Hold__c, 0) + ISNULL(BD_Time_in_Missed_Appointment__c, 0))/60 as decimal(10,2)) as Time_Service
	,CAST((ISNULL(BD_Time_in_Parts_Hold__c, 0) + ISNULL(BD_Time_in_Parts_Hold__c, 0) + ISNULL(BD_Time_in_Pending_Equipment_Parts__c, 0) + ISNULL(BD_Time_in_Open__c, 0) + ISNULL(BD_Time_in_Supply_Chain_Hold__c, 0))/60 as decimal(10,2)) as Time_SupplyChain
	,CAST(ISNULL(BD_Time_in_Pending_Contractor__c, 0)/60 as decimal(10,2)) as Time_OS
	,CAST((ISNULL(BD_Time_in_Ready_to_Schedule__c, 0) + ISNULL(BD_Time_in_Reschedule__c, 0))/60 as decimal(10,2)) as Time_CustomerCare
	,CAST(ISNULL(BD_Time_in_Sales_Hold__c, 0)/60 as decimal(10,2)) as Time_Sales
	,CAST(ISNULL(BD_Time_in_Scheduled__c, 0)/60 as decimal(10,2)) as Time_Scheduled
	,CAST(DATEDIFF(minute, CreatedDate, SVMXC__Actual_Resolution__c)/CAST(3600 as decimal(10,2))as decimal(10,2)) as Time_Total
FROM Temporal.SVMXCServiceOrder) a
WHERE Time_Total > 0
