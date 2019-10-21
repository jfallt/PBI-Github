; WITH TrackingHistoryRanked AS	-- Use the previous order status and end time to assign TRUE or FALSE values
(SELECT
	Name,
	LAG([FedEx_Tracking__c]) OVER (ORDER BY Name, [VersionStartTime])  as 'PreviousOrderStatus',
	[FedEx_Tracking__c],
	[VersionStartTime] as 'VersionStartTime',
	[VersionEndTime] as 'VersionEndTime',
	LAG([VersionEndTime]) OVER (ORDER BY Name, [VersionStartTime])  as 'PreviousVersionEndTime',

	
	CASE WHEN		--Assign a 1 for each new order status change
		(CASE WHEN FedEx_Tracking__c = (LAG(FedEx_Tracking__c) OVER (ORDER BY Name, [VersionStartTime]))
			THEN 1 ELSE 0 END)
		=
		(CASE WHEN [VersionStartTime] = (LAG([VersionEndTime]) OVER (ORDER BY Name, [VersionStartTime]))
			THEN  1 ELSE 0 END)
		THEN 0 ELSE 1 END AS 'StatusGroup',
	ROW_NUMBER() OVER(ORDER BY Name, [VersionStartTime]) rownum
	FROM [TemporalHistory].[SVMXCServiceOrder]
	WHERE [VersionStartTime] > '2019-05-15 16:44:54.000'),


TrackingHistoryGrouped AS		--assign group based on query above
	(SELECT
		Name,
		[FedEx_Tracking__c],
		[VersionStartTime],
		SUM(StatusGroup) OVER(ORDER BY rownum ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW) as 'StatusGroup'
	FROM TrackingHistoryRanked),

TrackingHistory AS		--Format Results Like dbo table
(SELECT
	Name as 'WorkOrder',
	[FedEx_Tracking__c] as 'TrackingNo',
	MIN([VersionStartTime]) as 'StatusChange'
FROM TrackingHistoryGrouped
WHERE [FedEx_Tracking__c] IS NOT NULL
GROUP BY Name, [FedEx_Tracking__c], StatusGroup

UNION ALL

SELECT
	Name as 'WorkOrder',
	[NewValue] as 'TrackingNo',
	h.[CreatedDate] as 'StatusChange'
FROM [dbo].[SVMXC__Service_Order__History] h
LEFT JOIN [Temporal].[SVMXCServiceOrder]s on s.Id = h.ParentID
WHERE[Field] = '[FedEx_Tracking__c]'
AND [NewValue] IS NOT NULL
),

TrackingHistoryClean AS
(
SELECT
	WorkOrder,
	LEFT(TrackingNo, 4) as TrackingNo,
	RIGHT(TrackingNo, 4) as TrackingNo2,
	StatusChange
FROM TrackingHistory
)

SELECT * FROM TrackingHistoryClean

ORDER BY WorkOrder