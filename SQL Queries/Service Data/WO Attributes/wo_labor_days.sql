SELECT COUNT(*) as DistinctLaborDays, WorkOrderID
FROM
(
SELECT DISTINCT WorkOrderID, [Date]
FROM
(
SELECT SVMXC__Service_Order__c as WorkOrderID
	,CAST(DATEADD(Hour, -4, s.[CreatedDate]) as DATE) as [Date]
	FROM [Temporal].[SVMXCServiceOrderLine] as s
	LEFT JOIN [dbo].[Product2] p on p.Id = s.SVMXC__Product__c
	WHERE p.[Name] = 'Labor Fee'
) a
) b

GROUP BY WorkOrderID
HAVING COUNT(*) > 1
