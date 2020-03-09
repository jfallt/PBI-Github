--Declare in EST
DECLARE @asOf DATETIME = GETDATE() AT TIME ZONE 'Eastern Standard Time' 
SET @asOf = '2019-04-30'

SELECT TOP 10 * FROM SVMXC__Service_Order__History

--PM Backlog from Temporal data--
;WITH dboBacklog AS

(	
	(SELECT
		h1.*,
		CAST(@asof as DATE) as 'AsOf',
		ROW_NUMBER() OVER (PARTITION BY ParentId ORDER BY CreatedDate DESC) rn
			FROM
			(
				SELECT * FROM SVMXC__Service_Order__History h
					WHERE CreatedDate <= @asof
					AND Field IN ('Created', 'SVMXC__Order_Status__c')  
					AND EXISTS
					(SELECT id FROM Temporal.SVMXCServiceOrder so
					WHERE so.id = h.ParentId
				AND so.SVMXC__Order_Type__c IN ('Routine', 'PM'))
			) h1
	)
),

dboBacklog1 AS -- Add fields
(
	SELECT s.Name as WorkOrder
		,ISNULL(a.NewValue, 'Open') as OrderStatus
		,ISNULL(ISNULL(q.Market__c, ss.Market__c), z.[MSA_CSA__c])  as Market
		,CAST(SVMXC__Preferred_Start_Time__c as DATE) as SVMXC__Preferred_Start_Time__c
		,qSLA_Package__c
		,AsOf
	FROM dboBacklog a
		LEFT JOIN Temporal.SVMXCServiceOrder s on s.Id = a.ParentId
		LEFT JOIN Temporal.SVMXC__Site__c ss on ss.Id = s.SVMXC__Site__c
		LEFT JOIN Temporal.qforce_Site__c q on q.Id = ss.qSite__c
		LEFT JOIN Temporal.Zip_Code__c z on z.[Id] = q.zip_code__c
	WHERE rn = 1
)

SELECT Market
	--,OrderStatus
	,COUNT(WorkOrder) as RecordCount
	--,SLA
	--,WithinSLA
	,AsOf
FROM dbobacklog1
WHERE OrderStatus In ('Open'
					,'OS Warranty'
					,'Ready to Schedule'
					,'Reschedule'
					,'Scheduling Hold'
					,'Service Hold')
GROUP BY --OrderStatus
	Market
	--,SLA
	--,WithinSLA
	,AsOf