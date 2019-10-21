/*Declare @Date's in EST*/  
	DECLARE @asOf DATETIME = GETDATE() AT TIME ZONE 'Eastern Standard Time' 
	DECLARE @asOf2 DATETIME = GETDATE() AT TIME ZONE 'Eastern Standard Time'
	DECLARE @asOf3 DATETIME = GETDATE() AT TIME ZONE 'Eastern Standard Time' 
	DECLARE @asOf4 DATETIME = GETDATE() AT TIME ZONE 'Eastern Standard Time'
	DECLARE @asOf5 DATETIME = GETDATE() AT TIME ZONE 'Eastern Standard Time'
	DECLARE @asOf6 DATETIME = GETDATE() AT TIME ZONE 'Eastern Standard Time' 
	DECLARE @asOf7 DATETIME = GETDATE() AT TIME ZONE 'Eastern Standard Time' 
	DECLARE @asOf8 DATETIME = GETDATE() AT TIME ZONE 'Eastern Standard Time' 
	DECLARE @asOf9 DATETIME = GETDATE() AT TIME ZONE 'Eastern Standard Time' 
	DECLARE @asOf10 DATETIME = GETDATE() AT TIME ZONE 'Eastern Standard Time' 
	DECLARE @asOf11 DATETIME = GETDATE() AT TIME ZONE 'Eastern Standard Time' 
	DECLARE @asOf12 DATETIME = GETDATE() AT TIME ZONE 'Eastern Standard Time' 
	DECLARE @asOf13 DATETIME = GETDATE() AT TIME ZONE 'Eastern Standard Time'
	DECLARE @asOf14 DATETIME = GETDATE() AT TIME ZONE 'Eastern Standard Time' 
	DECLARE @asOf15 DATETIME = GETDATE() AT TIME ZONE 'Eastern Standard Time'

/*Set @Date Dates to Last Day of the Month going back 24 months*/  
	SET @asOf = '2019-05-15'
	SET @asOf2 = EOMONTH(@asof, -2)
	SET @asOf3 = EOMONTH(@asof, -3)
	SET @asOf4 = EOMONTH(@asof, -4)
	SET @asOf5 = EOMONTH(@asof, -5)
	SET @asOf6 = EOMONTH(@asof, -6)
	SET @asOf7 = EOMONTH(@asof, -7)
	SET @asOf8 = EOMONTH(@asof, -8)
	SET @asOf9 = EOMONTH(@asof, -9)
	SET @asOf10 = EOMONTH(@asof, -10)
	SET @asOf11 = EOMONTH(@asof, -11)
	SET @asOf12 = EOMONTH(@asof, -12)
	SET @asOf13 = EOMONTH(@asof, -13)
	SET @asOf14 = EOMONTH(@asof, -14)
	SET @asOf15 = EOMONTH(@asof, -15)


--PM Backlog from Temporal data--
;WITH dboBacklog AS

(	
	(SELECT
		h1.*,
		CAST(@asof2 as DATE) as 'AsOf',
		ROW_NUMBER() OVER(PARTITION BY ParentId ORDER BY CreatedDate DESC) rn
			FROM
			(
				SELECT * FROM SVMXC__Service_Order__History h
				WHERE CreatedDate <= @asof2
				AND Field IN ('Created', 'SVMXC__Order_Status__c')  
				AND EXISTS
				(SELECT id FROM Temporal.SVMXCServiceOrder so
				WHERE so.id = h.ParentId
				AND so.SVMXC__Order_Type__c IN ('Routine', 'PM'))
			) h1
	)

	UNION ALL

	(SELECT
		h1.*,
		CAST(@asof3 as DATE) as 'AsOf',
		ROW_NUMBER() OVER(PARTITION BY ParentId ORDER BY CreatedDate DESC) rn
			FROM
			(
				SELECT * FROM SVMXC__Service_Order__History h
				WHERE CreatedDate <= @asof3
				AND Field IN ('Created', 'SVMXC__Order_Status__c')
				AND EXISTS
				(SELECT id FROM Temporal.SVMXCServiceOrder so
				WHERE so.id = h.ParentId
				AND so.SVMXC__Order_Type__c IN ('Routine', 'PM'))
			) h1
	)

	UNION ALL

	(SELECT
		h1.*,
		CAST(@asof4 as DATE) as 'AsOf',
		ROW_NUMBER() OVER(PARTITION BY ParentId ORDER BY CreatedDate DESC) rn
			FROM
			(
				SELECT * FROM SVMXC__Service_Order__History h
				WHERE CreatedDate <= @asof4
				AND Field IN ('Created', 'SVMXC__Order_Status__c')
				AND EXISTS
				(SELECT id FROM Temporal.SVMXCServiceOrder so
				WHERE so.id = h.ParentId
				AND so.SVMXC__Order_Type__c IN ('Routine', 'PM'))
			) h1
	)

	UNION ALL

	(SELECT
		h1.*,
		CAST(@asof5 as DATE) as 'AsOf',
		ROW_NUMBER() OVER(PARTITION BY ParentId ORDER BY CreatedDate DESC) rn
			FROM
			(
				SELECT * FROM SVMXC__Service_Order__History h
				WHERE CreatedDate <= @asof5
				AND Field IN ('Created', 'SVMXC__Order_Status__c') 
				AND EXISTS
				(SELECT id FROM Temporal.SVMXCServiceOrder so
				WHERE so.id = h.ParentId
				AND so.SVMXC__Order_Type__c IN ('Routine', 'PM'))
			) h1
	)

	UNION ALL

	(SELECT
		h1.*,
		CAST(@asof6 as DATE) as 'AsOf',
		ROW_NUMBER() OVER(PARTITION BY ParentId ORDER BY CreatedDate DESC) rn
			FROM
			(
				SELECT * FROM SVMXC__Service_Order__History h
				WHERE CreatedDate <= @asof6
				AND Field IN ('Created', 'SVMXC__Order_Status__c')
				AND EXISTS
				(SELECT id FROM Temporal.SVMXCServiceOrder so
				WHERE so.id = h.ParentId
				AND so.SVMXC__Order_Type__c IN ('Routine', 'PM'))
			) h1
	)

	UNION ALL

	(SELECT
		h1.*,
		CAST(@asof7 as DATE) as 'AsOf',
		ROW_NUMBER() OVER(PARTITION BY ParentId ORDER BY CreatedDate DESC) rn
			FROM
			(
				SELECT * FROM SVMXC__Service_Order__History h
				WHERE CreatedDate <= @asof7
				AND Field IN ('Created', 'SVMXC__Order_Status__c')  
				AND EXISTS
				(SELECT id FROM Temporal.SVMXCServiceOrder so
				WHERE so.id = h.ParentId
				AND so.SVMXC__Order_Type__c IN ('Routine', 'PM'))
			) h1
	)

	UNION ALL

	(SELECT
		h1.*,
		CAST(@asof8 as DATE) as 'AsOf',
		ROW_NUMBER() OVER(PARTITION BY ParentId ORDER BY CreatedDate DESC) rn
			FROM
			(
				SELECT * FROM SVMXC__Service_Order__History h
				WHERE CreatedDate <= @asof8
				AND Field IN ('Created', 'SVMXC__Order_Status__c')
				AND EXISTS
				(SELECT id FROM Temporal.SVMXCServiceOrder so
				WHERE so.id = h.ParentId
				AND so.SVMXC__Order_Type__c IN ('Routine', 'PM'))
			) h1
	)

	UNION ALL

	(SELECT
		h1.*,
		CAST(@asof9 as DATE) as 'AsOf',
		ROW_NUMBER() OVER(PARTITION BY ParentId ORDER BY CreatedDate DESC) rn
			FROM
			(
				SELECT * FROM SVMXC__Service_Order__History h
				WHERE CreatedDate <= @asof9
				AND Field IN ('Created', 'SVMXC__Order_Status__c')
				AND EXISTS
				(SELECT id FROM Temporal.SVMXCServiceOrder so
				WHERE so.id = h.ParentId
				AND so.SVMXC__Order_Type__c IN ('Routine', 'PM'))
			) h1
	)

	UNION ALL

	(SELECT
		h1.*,
		CAST(@asof10 as DATE) as 'AsOf',
		ROW_NUMBER() OVER(PARTITION BY ParentId ORDER BY CreatedDate DESC) rn
			FROM
			(
				SELECT * FROM SVMXC__Service_Order__History h
				WHERE CreatedDate <= @asof10
				AND Field IN ('Created', 'SVMXC__Order_Status__c')
				AND EXISTS
				(SELECT id FROM Temporal.SVMXCServiceOrder so
				WHERE so.id = h.ParentId
				AND so.SVMXC__Order_Type__c IN ('Routine', 'PM')) 
			) h1
	)

	UNION ALL

	(SELECT
		h1.*,
		CAST(@asof11 as DATE) as 'AsOf',
		ROW_NUMBER() OVER(PARTITION BY ParentId ORDER BY CreatedDate DESC) rn
			FROM
			(
				SELECT * FROM SVMXC__Service_Order__History h
				WHERE [CreatedDate]<= @asof11
				AND Field IN ('Created', 'SVMXC__Order_Status__c')
				AND EXISTS
				(SELECT id FROM Temporal.SVMXCServiceOrder so
				WHERE so.id = h.ParentId
				AND so.SVMXC__Order_Type__c IN ('Routine', 'PM'))
			) h1
	)

	UNION ALL

	(SELECT
		h1.*,
		CAST(@asof12 as DATE) as 'AsOf',
		ROW_NUMBER() OVER(PARTITION BY ParentId ORDER BY CreatedDate DESC) rn
			FROM
			(
				SELECT * FROM SVMXC__Service_Order__History h
				WHERE [CreatedDate]<= @asof12
				AND Field IN ('Created', 'SVMXC__Order_Status__c')  
				AND EXISTS
				(SELECT id FROM Temporal.SVMXCServiceOrder so
				WHERE so.id = h.ParentId
				AND so.SVMXC__Order_Type__c IN ('Routine', 'PM'))
			) h1
	)

	UNION ALL

	(SELECT
		h1.*,
		CAST(@asof13 as DATE) as 'AsOf',
		ROW_NUMBER() OVER(PARTITION BY ParentId ORDER BY CreatedDate DESC) rn
			FROM
			(
				SELECT * FROM SVMXC__Service_Order__History h
				WHERE CreatedDate<= @asof13
				AND Field IN ('Created', 'SVMXC__Order_Status__c') 
				AND EXISTS
				(SELECT id FROM Temporal.SVMXCServiceOrder so
				WHERE so.id = h.ParentId
				AND so.SVMXC__Order_Type__c IN ('Routine', 'PM'))
			) h1
	)

	UNION ALL

	(SELECT
		h1.*,
		CAST(@asof14 as DATE) as 'AsOf',
		ROW_NUMBER() OVER(PARTITION BY ParentId ORDER BY CreatedDate DESC) rn
			FROM
			(
				SELECT * FROM SVMXC__Service_Order__History h
				WHERE CreatedDate <= @asof14
				AND Field IN ('Created', 'SVMXC__Order_Status__c')
				AND EXISTS
				(SELECT id FROM Temporal.SVMXCServiceOrder so
				WHERE so.id = h.ParentId
				AND so.SVMXC__Order_Type__c IN ('Routine', 'PM'))
			) h1
	)

	UNION ALL

	(SELECT
		h1.*,
		CAST(@asof14 as DATE) as 'AsOf',
		ROW_NUMBER() OVER(PARTITION BY ParentId ORDER BY CreatedDate DESC) rn
			FROM
			(
				SELECT * FROM SVMXC__Service_Order__History h
				WHERE CreatedDate <= @asof14
				AND Field IN ('Created', 'SVMXC__Order_Status__c')
				AND EXISTS
				(SELECT id FROM Temporal.SVMXCServiceOrder so
				WHERE so.id = h.ParentId
				AND so.SVMXC__Order_Type__c IN ('Routine', 'PM'))
			) h1
	)

	UNION ALL

	(SELECT
		h1.*,
		CAST(@asof15 as DATE) as 'AsOf',
		ROW_NUMBER() OVER(PARTITION BY ParentId ORDER BY CreatedDate DESC) rn
			FROM
			(
				SELECT * FROM SVMXC__Service_Order__History h
				WHERE CreatedDate <= @asof15
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
	LEFT JOIN [Temporal].[SVMXCServiceOrder] s on s.Id = a.ParentId
	LEFT JOIN [Source].[SVMXC__Site__c] ss on ss.Id = s.SVMXC__Site__c
	LEFT JOIN [Source].[qforce_Site__c] q on q.Id = ss.qSite__c
	LEFT JOIN [Source].[Zip_Code__c] z on z.[Id] = q.zip_code__c
	WHERE rn = 1
)--,

--BacklogCombined1 AS -- change the acceptable due date by SLA and filter any orders deleted by the system admin
--(
--	SELECT *,
--	CASE
--		WHEN [qSLA_Package__c] LIKE '%Gold%'
--			THEN 'Gold'
--		WHEN [qSLA_Package__c] LIKE '%Platinum%'
--			THEN 'Platinum'
--		WHEN [qSLA_Package__c] LIKE '%Silver%'
--			THEN 'Silver'
--		WHEN [qSLA_Package__c] LIKE '%Bronze%'
--			THEN 'Bronze'
--		WHEN [qSLA_Package__c] LIKE '%Food%'
--			THEN 'Food Service'
--		ELSE 'Unknown'
--			END as 'SLA',
--	--Change Due Date--
--	CASE
--		WHEN [qSLA_Package__c] LIKE '%Gold%'
--			THEN DATEADD(DAY, 60, [SVMXC__Preferred_Start_Time__c])
--		WHEN [qSLA_Package__c] LIKE '%Platinum%'
--			THEN DATEADD(DAY, 30, [SVMXC__Preferred_Start_Time__c])
--		WHEN [qSLA_Package__c] LIKE '%Silver%'
--			THEN DATEADD(DAY, 90, [SVMXC__Preferred_Start_Time__c])
--		WHEN [qSLA_Package__c] LIKE '%Bronze%'
--			THEN DATEADD(DAY, 90, [SVMXC__Preferred_Start_Time__c])
--		WHEN [qSLA_Package__c] LIKE '%Food%'
--			THEN DATEADD(DAY, 30, [SVMXC__Preferred_Start_Time__c])
--		ELSE DATEADD(DAY, 90, [SVMXC__Preferred_Start_Time__c])
--			END as 'SLADueDate'
--	FROM dboBacklog1
--),

-- Identify if work orders were in SLA

--BacklogCombined2 AS

--(
--	SELECT *
--		,CASE WHEN SLADueDate > AsOf  THEN 1
--			  WHEN SLADueDate <= AsOf THEN 0
--			  ELSE NULL
--			  END as 'WithinSLA'
--	FROM BacklogCombined1
--	WHERE SVMXC__Preferred_Start_Time__c < AsOf
--	AND SVMXC__Preferred_Start_Time__c <= AsOf
--)

-- create a count by market and region

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