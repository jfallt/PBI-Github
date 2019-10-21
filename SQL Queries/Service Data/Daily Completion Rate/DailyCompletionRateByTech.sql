With WorkOrderOnSchedule AS
(
SELECT COUNT(DISTINCT(Name)) as TotalAssigned
	, COUNT(DISTINCT(CASE WHEN SVMXC__Order_Status__c = 'Complete' then [Name] end)) as Complete
	, CAST(SVMXC__Scheduled_Date_Time__c as DATE) as ScheduledDate
	, SVMXC__Group_Member__c as ServiceMember
FROM [Temporal].[SVMXCServiceOrder]
FOR SYSTEM_TIME ALL
WHERE CAST(SVMXC__Scheduled_Date_Time__c as DATE) = CAST(VersionStartTime as DATE)
AND SVMXC__Group_Member__c IS NOT NULL
GROUP BY CAST(SVMXC__Scheduled_Date_Time__c as DATE)
	, SVMXC__Group_Member__c
),

CompletedWorkOrders AS
(
SELECT COUNT(DISTINCT(Name)) as TotalCompleted
	, CAST(SVMXC__Scheduled_Date_Time__c as DATE) as ActualRes
	, SVMXC__Group_Member__c as ServiceMember
FROM [Temporal].[SVMXCServiceOrder]
FOR SYSTEM_TIME ALL
WHERE CAST(SVMXC__Actual_Resolution__c as DATE) = CAST(VersionStartTime as DATE)
AND SVMXC__Group_Member__c IS NOT NULL
AND SVMXC__Order_Status__c = 'Complete'
GROUP BY CAST(SVMXC__Scheduled_Date_Time__c as DATE)
	, SVMXC__Group_Member__c
),

CombinedTable AS
(
SELECT ISNULL(ws.ServiceMember, cw.ServiceMember) as ServiceMember
	, ISNULL(TotalAssigned, 0) as TotalAssigned
	, ISNULL(TotalCompleted, Complete) as TotalComplete
	, ISNULL(ScheduledDate, ActualRes) as [Date]
	, CASE WHEN ISNULL(TotalCompleted, 0) - ISNULL(Complete, 0) < 0
	THEN 0
	ELSE ISNULL(TotalCompleted, 0) - ISNULL(Complete, 0)
	END as WOCompletedNotOnScheduledDate
	, (ISNULL(TotalAssigned,0) - ISNULL(Complete,0)) as WOAssignedButNotComplete
FROM
WorkOrderOnSchedule ws
FULL OUTER JOIN CompletedWorkOrders cw ON ws.ServiceMember = cw.ServiceMember AND ws.ScheduledDate = cw.ActualRes
)

SELECT sm.Name as Technician
	, ServiceMember
	, [Date]
	, TotalAssigned
	, TotalComplete
	, WOCompletedNotOnScheduledDate
	, WOAssignedButNotComplete
FROM CombinedTable ct
LEFT JOIN Temporal.SVMXCServiceGroupMembers sm on ct.ServiceMember = sm.Id
WHERE [Date] IS NOT NULL
AND sm.Name NOT LIKE '%Outsourced%'