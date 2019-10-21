WITH CheckScheduledDate AS
(
SELECT so.Name as WorkOrder
	, sw.versionStartTime
	, sw.versionEndTime
	, sw.SVMXC__Scheduled_Date_Time__c as ScheduledDate
	, sw.prev_SVMXC__Scheduled_Date_Time__c as PrevScheduleDate
	, sg.Name as Tech
	, sw.SVMXC__Order_Status__c
	, sw.Resolution_Code__c
	, CASE WHEN sw.SVMXC__Scheduled_Date_Time__c BETWEEN CAST(sw.versionStartTime as DATE) AND CAST(sw.versionEndTime as DATE)
		THEN 1 ELSE 0 END as IsSchedDateToday
	, CASE WHEN sw.SVMXC__Order_Status__c = 'Complete'
		AND (CASE WHEN sw.SVMXC__Scheduled_Date_Time__c
				BETWEEN CAST(sw.versionStartTime as DATE)
				AND CAST(sw.versionEndTime as DATE)
				THEN 1 ELSE 0 END) = 1
		THEN 1 
		WHEN sw.SVMXC__Order_Status__c = 'Complete'
		AND (CASE WHEN sw.SVMXC__Scheduled_Date_Time__c
			BETWEEN CAST(sw.versionStartTime as DATE)
			AND CAST(sw.versionEndTime as DATE)
			THEN 1 ELSE 0 END) = 0
		THEN -2
	ELSE 0 END as CompletedOnSchedDate
 FROM swo_state_changes sw
LEFT JOIN Temporal.SVMXCServiceGroupMembers sg on sg.id = sw.SVMXC__Group_Member__c
LEFT JOIN Temporal.SVMXCServiceOrder so on sw.id = so.Id
),

CheckForCompletedOnSchedDate AS
(
SELECT Tech, WorkOrder, ScheduledDate, IsSchedDateToday + CompletedOnSchedDate as AddSchedAndComplete
FROM CheckScheduledDate
)


SELECT Tech
	, ScheduledDate
	, SUM(CASE WHEN MaxCheck = 2 then 1 ELSE 0 END) as Completed_OnSchedDate
	, SUM(CASE WHEN MaxCheck = 1 then 1 ELSE 0 END) as NotCompletedOnSched
	, SUM(CASE WHEN MaxCheck = -2 then 1 ELSE 0 END) as Completed_NotOnScheduled
FROM
(
SELECT Tech, ScheduledDate, WorkOrder, MAX(AddSchedAndComplete) as MaxCheck
FROM CheckForCompletedOnSchedDate
GROUP BY Tech, ScheduledDate, WorkOrder
) a
WHERE ScheduledDate < CAST(GETDATE() as DATE)
AND Tech IS NOT NULL
AND ScheduledDate IS NOT NULL
GROUP BY Tech,ScheduledDate
ORDER BY Tech,ScheduledDate