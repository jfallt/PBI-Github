-- Subquery using the previous order status and end time to assign TRUE or FALSE values
;WITH WoRanked AS

(SELECT id
	,LAG(SVMXC__Scheduled_Date_Time__c) OVER (ORDER BY id, VersionStartTime) as PreviousOrderStatus
	,SVMXC__Scheduled_Date_Time__c
	,VersionStartTime
	,CASE WHEN --Assign a 1 for each new order status change
		(CASE WHEN SVMXC__Scheduled_Date_Time__c = (LAG(SVMXC__Scheduled_Date_Time__c) OVER (ORDER BY id, VersionStartTime))
			THEN 1 ELSE 0 END)
		=
		(CASE WHEN [VersionStartTime] = (LAG([VersionEndTime]) OVER (ORDER BY id, [VersionStartTime]))
			THEN  1 ELSE 0 END)
		THEN 0 ELSE 1 END AS StatusGroup
	,ROW_NUMBER() OVER(ORDER BY id, VersionStartTime) rownum
	FROM TemporalHistory.SVMXCServiceOrder
	WHERE VersionStartTime > '2019-05-15 16:44:54.000'
	AND SVMXC__Scheduled_Date_Time__c IS NOT NULL
),

--assign group based on query above
WoGrouped AS

(
	SELECT id
		,SVMXC__Scheduled_Date_Time__c
		,VersionStartTime
		,SUM(StatusGroup) OVER(ORDER BY rownum ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW) as 'StatusGroup'
	FROM WoRanked
),

WoTemporal AS
(
	SELECT ParentId as id,
		CreatedDate as 'CreatedDate',
		NewValue
	FROM SVMXC__Service_Order__History
		WHERE Field = 'SVMXC__Scheduled_Date_Time__c'
		AND NewValue IS NOT NULL
),

--Format Results Like Old History Table
WoHistory AS

(
	SELECT TOP 100000000 id
		,SVMXC__Scheduled_Date_Time__c as NewValue
		,MIN([VersionStartTime]) as CreatedDate
	FROM WoGrouped
	WHERE SVMXC__Scheduled_Date_Time__c IS NOT NULL
	GROUP BY id, SVMXC__Scheduled_Date_Time__c, StatusGroup
	ORDER BY id, StatusGroup
),

--Combine Temporal & dbo. into one history table
Consolidated1 AS

(
	SELECT id
		,CAST(DATEADD(HOUR,-4,CreatedDate) as DATE) as CreatedDate
		,CAST(DATEADD(HOUR,-4,NewValue) as DATE) as Dates
	FROM WoTemporal

	UNION ALL

	SELECT id
		,CAST(CreatedDate as DATE) as CreatedDate
		,CAST(NewValue as DATE) as Dates
	FROM WoHistory
),

Consolidated AS

(SELECT DISTINCT * FROM Consolidated1),

DistinctDatesCheckSameDate AS
(	
	SELECT
		id,
		CreatedDate,
		Dates,
		CASE WHEN
			LAG(Dates) OVER (ORDER BY id, CreatedDate) = Dates
			THEN 1
			ELSE 0
			END as 'CheckSameDate'
	FROM Consolidated
),

DistinctDatesFiltered AS
(	SELECT
		id,
		CreatedDate,
		Dates
	FROM DistinctDatesCheckSameDate
	WHERE CheckSameDate = 0
),


DistinctDatesCount AS

(
	SELECT
		id,
		COUNT(DISTINCT(CreatedDate)) as 'DistinctDates'
	FROM DistinctDatesFiltered
	GROUP BY id, Dates
)


SELECT d.id
	, MAX(DistinctDates) - 1 as 'Reschedules'
	, MAX(DistinctDates) as '# of Distinct Dates'
	, CAST(so.SVMXC__FirstScheduledDateTime__c as DATE) as FirstScheduledDate
	, CAST(so.SVMXC__Scheduled_Date_Time__c as DATE) as LastScheduledDate
FROM DistinctDatesCount d
LEFT JOIN Temporal.SVMXCServiceOrder so on so.id = d.id
WHERE DistinctDates >= 2
GROUP BY d.id,  CAST(so.SVMXC__FirstScheduledDateTime__c as DATE), CAST(so.SVMXC__Scheduled_Date_Time__c as DATE)
HAVING DATEDIFF(DAY, CAST(CAST(so.SVMXC__FirstScheduledDateTime__c as DATE) as Date), CAST(CAST(so.SVMXC__Scheduled_Date_Time__c as DATE) as Date)) > 0

