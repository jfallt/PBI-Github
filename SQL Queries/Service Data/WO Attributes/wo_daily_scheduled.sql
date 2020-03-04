SELECT swo.asofdate
	,swo.wo_id
	,swo.SVMXC__Group_Member__c
	,swo.lastmodifieddate
    ,CASE
        WHEN CAST(SVMXC__Actual_Resolution__c as DATE) = swo.asofdate
        THEN 0
        ELSE 1
    END as Reschedule
FROM reporting.scheduledWorkOrders swo
INNER JOIN Temporal.SVMXCServiceOrder so on so.id = swo.wo_id