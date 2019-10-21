/*Declare @Date's in EST*/  
	DECLARE @asOf DATETIME = GETDATE() AT TIME ZONE 'Eastern Standard Time' 
	DECLARE @asOf1 DATETIME = GETDATE() AT TIME ZONE 'Eastern Standard Time'
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
	SET @asOf1 = EOMONTH(@asof, -1)
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

;WITH dboBacklog AS -- Query data from the dbo history table (for data before May 2019)

(	(SELECT	h1.*
		, CAST(@asof1 as DATE) as 'AsOf'
		, ROW_NUMBER() OVER(PARTITION BY ParentId ORDER BY CreatedDate DESC) rn
			FROM
			(
				SELECT h.* FROM [dbo].[SVMXC__Service_Order__History] h
				INNER JOIN Temporal.SVMXCServiceOrder so on so.id = h.ParentId
				WHERE h.[CreatedDate]<= @asof1
				AND Field IN ('Created', 'SVMXC__Order_Status__c')  
				AND so.SVMXC__Order_Type__c IN ('Install', 'Purchase Install', 'Removal', 'Repossession')
			) h1
	)

	UNION ALL

	(SELECT	h1.*
		, CAST(@asof2 as DATE) as 'AsOf'
		, ROW_NUMBER() OVER(PARTITION BY ParentId ORDER BY CreatedDate DESC) rn
			FROM
			(
				SELECT h.* FROM [dbo].[SVMXC__Service_Order__History] h
				INNER JOIN Temporal.SVMXCServiceOrder so on so.id = h.ParentId
				WHERE h.[CreatedDate]<= @asof2
				AND Field IN ('Created', 'SVMXC__Order_Status__c')  
				AND so.SVMXC__Order_Type__c IN ('Install', 'Purchase Install', 'Removal', 'Repossession')
			) h1
	)

	UNION ALL

	(SELECT	h1.*
		, CAST(@asof3 as DATE) as 'AsOf'
		, ROW_NUMBER() OVER(PARTITION BY ParentId ORDER BY CreatedDate DESC) rn
			FROM
			(
				SELECT h.* FROM [dbo].[SVMXC__Service_Order__History] h
				INNER JOIN Temporal.SVMXCServiceOrder so on so.id = h.ParentId
				WHERE h.[CreatedDate]<= @asof3
				AND Field IN ('Created', 'SVMXC__Order_Status__c')  
				AND so.SVMXC__Order_Type__c IN ('Install', 'Purchase Install', 'Removal', 'Repossession')
			) h1
	)

	UNION ALL

	(SELECT	h1.*
		, CAST(@asof4 as DATE) as 'AsOf'
		, ROW_NUMBER() OVER(PARTITION BY ParentId ORDER BY CreatedDate DESC) rn
			FROM
			(
				SELECT h.* FROM [dbo].[SVMXC__Service_Order__History] h
				INNER JOIN Temporal.SVMXCServiceOrder so on so.id = h.ParentId
				WHERE h.[CreatedDate]<= @asof4
				AND Field IN ('Created', 'SVMXC__Order_Status__c')  
				AND so.SVMXC__Order_Type__c IN ('Install', 'Purchase Install', 'Removal', 'Repossession')
			) h1
	)

	UNION ALL

	(SELECT	h1.*
		, CAST(@asof5 as DATE) as 'AsOf'
		, ROW_NUMBER() OVER(PARTITION BY ParentId ORDER BY CreatedDate DESC) rn
			FROM
			(
				SELECT h.* FROM [dbo].[SVMXC__Service_Order__History] h
				INNER JOIN Temporal.SVMXCServiceOrder so on so.id = h.ParentId
				WHERE h.[CreatedDate]<= @asof5
				AND Field IN ('Created', 'SVMXC__Order_Status__c')  
				AND so.SVMXC__Order_Type__c IN ('Install', 'Purchase Install', 'Removal', 'Repossession')
			) h1
	)

	UNION ALL

	(SELECT	h1.*
		, CAST(@asof6 as DATE) as 'AsOf'
		, ROW_NUMBER() OVER(PARTITION BY ParentId ORDER BY CreatedDate DESC) rn
			FROM
			(
				SELECT h.* FROM [dbo].[SVMXC__Service_Order__History] h
				INNER JOIN Temporal.SVMXCServiceOrder so on so.id = h.ParentId
				WHERE h.[CreatedDate]<= @asof6
				AND Field IN ('Created', 'SVMXC__Order_Status__c')  
				AND so.SVMXC__Order_Type__c IN ('Install', 'Purchase Install', 'Removal', 'Repossession')
			) h1
	)

	UNION ALL

	(SELECT	h1.*
		, CAST(@asof7 as DATE) as 'AsOf'
		, ROW_NUMBER() OVER(PARTITION BY ParentId ORDER BY CreatedDate DESC) rn
			FROM
			(
				SELECT h.* FROM [dbo].[SVMXC__Service_Order__History] h
				INNER JOIN Temporal.SVMXCServiceOrder so on so.id = h.ParentId
				WHERE h.[CreatedDate]<= @asof7
				AND Field IN ('Created', 'SVMXC__Order_Status__c')  
				AND so.SVMXC__Order_Type__c IN ('Install', 'Purchase Install', 'Removal', 'Repossession')
			) h1
	)

	UNION ALL

	(SELECT	h1.*
		, CAST(@asof8 as DATE) as 'AsOf'
		, ROW_NUMBER() OVER(PARTITION BY ParentId ORDER BY CreatedDate DESC) rn
			FROM
			(
				SELECT h.* FROM [dbo].[SVMXC__Service_Order__History] h
				INNER JOIN Temporal.SVMXCServiceOrder so on so.id = h.ParentId
				WHERE h.[CreatedDate]<= @asof8
				AND Field IN ('Created', 'SVMXC__Order_Status__c')  
				AND so.SVMXC__Order_Type__c IN ('Install', 'Purchase Install', 'Removal', 'Repossession')
			) h1
	)

	UNION ALL

	(SELECT	h1.*
		, CAST(@asof9 as DATE) as 'AsOf'
		, ROW_NUMBER() OVER(PARTITION BY ParentId ORDER BY CreatedDate DESC) rn
			FROM
			(
				SELECT h.* FROM [dbo].[SVMXC__Service_Order__History] h
				INNER JOIN Temporal.SVMXCServiceOrder so on so.id = h.ParentId
				WHERE h.[CreatedDate]<= @asof9
				AND Field IN ('Created', 'SVMXC__Order_Status__c')  
				AND so.SVMXC__Order_Type__c IN ('Install', 'Purchase Install', 'Removal', 'Repossession')
			) h1
	)

	UNION ALL

	(SELECT	h1.*
		, CAST(@asof10 as DATE) as 'AsOf'
		, ROW_NUMBER() OVER(PARTITION BY ParentId ORDER BY CreatedDate DESC) rn
			FROM
			(
				SELECT h.* FROM [dbo].[SVMXC__Service_Order__History] h
				INNER JOIN Temporal.SVMXCServiceOrder so on so.id = h.ParentId
				WHERE h.[CreatedDate]<= @asof10
				AND Field IN ('Created', 'SVMXC__Order_Status__c')  
				AND so.SVMXC__Order_Type__c IN ('Install', 'Purchase Install', 'Removal', 'Repossession')
			) h1
	)


	UNION ALL

	(SELECT	h1.*
		, CAST(@asof11 as DATE) as 'AsOf'
		, ROW_NUMBER() OVER(PARTITION BY ParentId ORDER BY CreatedDate DESC) rn
			FROM
			(
				SELECT h.* FROM [dbo].[SVMXC__Service_Order__History] h
				INNER JOIN Temporal.SVMXCServiceOrder so on so.id = h.ParentId
				WHERE h.[CreatedDate]<= @asof11
				AND Field IN ('Created', 'SVMXC__Order_Status__c')  
				AND so.SVMXC__Order_Type__c IN ('Install', 'Purchase Install', 'Removal', 'Repossession')
			) h1
	)

	UNION ALL

	(SELECT	h1.*
		, CAST(@asof12 as DATE) as 'AsOf'
		, ROW_NUMBER() OVER(PARTITION BY ParentId ORDER BY CreatedDate DESC) rn
			FROM
			(
				SELECT h.* FROM [dbo].[SVMXC__Service_Order__History] h
				INNER JOIN Temporal.SVMXCServiceOrder so on so.id = h.ParentId
				WHERE h.[CreatedDate]<= @asof12
				AND Field IN ('Created', 'SVMXC__Order_Status__c')  
				AND so.SVMXC__Order_Type__c IN ('Install', 'Purchase Install', 'Removal', 'Repossession')
			) h1
	)

	UNION ALL

	(SELECT	h1.*
		, CAST(@asof13 as DATE) as 'AsOf'
		, ROW_NUMBER() OVER(PARTITION BY ParentId ORDER BY CreatedDate DESC) rn
			FROM
			(
				SELECT h.* FROM [dbo].[SVMXC__Service_Order__History] h
				INNER JOIN Temporal.SVMXCServiceOrder so on so.id = h.ParentId
				WHERE h.[CreatedDate]<= @asof13
				AND Field IN ('Created', 'SVMXC__Order_Status__c')  
				AND so.SVMXC__Order_Type__c IN ('Install', 'Purchase Install', 'Removal', 'Repossession')
			) h1
	)

	UNION ALL

	(SELECT	h1.*
		, CAST(@asof14 as DATE) as 'AsOf'
		, ROW_NUMBER() OVER(PARTITION BY ParentId ORDER BY CreatedDate DESC) rn
			FROM
			(
				SELECT h.* FROM [dbo].[SVMXC__Service_Order__History] h
				INNER JOIN Temporal.SVMXCServiceOrder so on so.id = h.ParentId
				WHERE h.[CreatedDate]<= @asof14
				AND Field IN ('Created', 'SVMXC__Order_Status__c')  
				AND so.SVMXC__Order_Type__c IN ('Install', 'Purchase Install', 'Removal', 'Repossession')
			) h1
	)

	UNION ALL

	(SELECT	h1.*
		, CAST(@asof15 as DATE) as 'AsOf'
		, ROW_NUMBER() OVER(PARTITION BY ParentId ORDER BY CreatedDate DESC) rn
			FROM
			(
				SELECT h.* FROM [dbo].[SVMXC__Service_Order__History] h
				INNER JOIN Temporal.SVMXCServiceOrder so on so.id = h.ParentId
				WHERE h.[CreatedDate]<= @asof15
				AND Field IN ('Created', 'SVMXC__Order_Status__c')  
				AND so.SVMXC__Order_Type__c IN ('Install', 'Purchase Install', 'Removal', 'Repossession')
			) h1
	)
),

-- Add fields

dboBacklog1 AS
(
	SELECT 
		s.Name as 'WorkOrder',
		s.SVMXC__Order_Type__c as 'OrderType',
		ISNULL(a.NewValue, 'Open') as 'OrderStatus',
		ISNULL(ISNULL(q.Market__c, ss.Market__c), z.[MSA_CSA__c])  as 'Market',
		SMAX_PS_Credit_Hold__c as 'CreditHold',
		CAST(s.[CreatedDate] as DATE) as CreatedDate,
		CASE WHEN SMAX_PS_Project_Name__c IS NOT NULL AND SVMXC__Order_Type__c IN ('Purchase Install', 'Install') THEN 'Project'
		WHEN SVMXC__Order_Type__c IN ('Purchase Install', 'Install') THEN 'Single'
		ELSE NULL
		END as InstallType,
		AsOf

	FROM dboBacklog a
	LEFT JOIN [Temporal].[SVMXCServiceOrder] s on s.Id = a.ParentId
	LEFT JOIN [Source].[SVMXC__Site__c] ss on ss.Id = s.SVMXC__Site__c
	LEFT JOIN [Source].[qforce_Site__c] q on q.Id = ss.qSite__c
	LEFT JOIN [Source].[Zip_Code__c] z on z.[Id] = q.zip_code__c
	WHERE rn = 1
),

-- change the acceptable due date by SLA and filter any orders deleted by the system admin

BacklogCombined1 AS
(
	SELECT *,
	CASE
	WHEN CreditHold <> 'No Hold'
		THEN 'Unavailable'
	WHEN OrderStatus IN('Scheduled')
		THEN 'Scheduled'
	WHEN OrderStatus IN('On Site'
						,'Service Hold'
						,'Scheduled'
						,'Open'
						,'Scheduling Hold'
						,'Reschedule'
						,'Ready to Schedule'
						,'Missed Appointment')
		THEN 'Available'
	WHEN OrderStatus IN ('Parts Hold'
						 ,'Pending Equipment/Parts'
						 ,'Supply Chain Hold'
						 ,'Sales Hold'
						 ,'Pending Contractor'
						 ,'OS Pending contractor (ETA)'
						 ,'OS Pending contractor (Paperwork)'
						 ,'OS Hold for shipping ETA'
						 ,'OS Warranty'
						 ,'Customer Success Hold'
						 ,'Customer Hold')
		THEN 'Unavailable'
	ELSE 'Needs Group'
	END As 'Availability',
	DATEADD(DAY, 1, EOMONTH(DATEADD(DAY, 1, AsOf), 0)) as 'EndDate'
	FROM dboBacklog1
)

-- create a count by market and region

SELECT OrderType
	,Market
	,[Availability]
	,InstallType
	,COUNT(WorkOrder) as RecordCount
	,AsOf
FROM BacklogCombined1


GROUP BY
	[Availability],
	Market,
	InstallType,
	OrderType,
	AsOf
ORDER BY AsOf DESC
