/***********************************************************
Purpose: Identify number of work orders left over at the end
of each month for Installs, Purchase Installs, Removals and
Repossessions

Step 1: Assign availability, install type and limit query
    selection
Step 2: Calculate backlog by site
Step 3: Create temp table storing current market assignments
    based on zip code
Step 4. Join step 2 with step 3 and count the number of
    records
***********************************************************/



/***********************************************************
Add version end date, install type and availability to service
    order history only including relevant order types
***********************************************************/

DROP TABLE IF EXISTS #service_order_history

SELECT soh.id
    ,so.SVMXC__Site__c
    ,soh.VersionStartTime
    ,soh.SVMXC__Order_Type__c
    ,ISNULL(
        LEAD(soh.versionstarttime) OVER (PARTITION BY soh.id ORDER BY soh.versionstarttime)
        ,GETDATE()) as versionendtime
    ,soh.SVMXC__Company__c
    ,CASE
			WHEN soh.SVMXC__Order_Status__c IN ('On Site'
												,'Open'
												,'Ready to Schedule'
												,'Reschedule'
												,'Scheduling Hold'
												,'Service Hold')
			THEN 'Available'
			WHEN soh.SVMXC__Order_Status__c = 'Scheduled'
			THEN 'Scheduled'
            WHEN soh.SVMXC__Order_Status__c IN ('Cancel', 'Complete')
			THEN 'Resolved'
			ELSE 'Unavailable'
			END as [Availability]
    ,CASE WHEN so.SMAX_PS_Project_Name__c IS NOT NULL
    THEN 'Project'
    ELSE 'Single' END as InstallType
INTO #service_order_history
FROM Reporting.svmxcServiceOrder_HistoryAbridged soh
    INNER JOIN Temporal.SVMXCServiceOrder so on so.id = soh.id
WHERE soh.SVMXC__Order_Type__c IN ('Install', 'Purchase Install', 'Removal', 'Repossession')  

/***********************************************************
Calculate the backlog by site
***********************************************************/
DROP TABLE IF EXISTS #backlog
CREATE TABLE #backlog (site_id nvarchar (MAX)
                        ,asofdate date
                        ,[Availability] nvarchar (MAX)
                        ,SVMXC__Order_Type__c nvarchar (MAX)
                        ,InstallType nvarchar (MAX)
                    )


DECLARE @asofdate2 as datetime
SET @asofdate2 = GETDATE()


;WHILE @asofdate2 > '2018-02-27 00:00:00.000'

BEGIN

INSERT INTO #backlog (site_id, asofdate, [Availability], SVMXC__Order_Type__c, InstallType)

	SELECT SVMXC__Site__c
        ,@asofdate2 as asofdate
        ,[Availability]
        ,SVMXC__Order_Type__c
        ,InstallType
	FROM #service_order_history soh
	WHERE soh.VersionStartTime <= @asofdate2
        AND soh.VersionEndTime >= @asofdate2
        AND soh.Availability <> 'Resolved';

	SET @asofdate2 = EOMONTH(DATEADD(m, -1, @asofdate2)) -- get previous month
END


/***********************************************************
Get current market info from site tables to zip
***********************************************************/
DROP TABLE IF EXISTS #site_to_market

SELECT ss.id
    ,COALESCE(zc.MSA_CSA__c, qs.Market__c, ss.Market__c) as Market
INTO #site_to_market
FROM Temporal.SVMXCSite ss
    LEFT JOIN Temporal.QforceSite qs on qs.id = ss.qSite__c
    LEFT JOIN Temporal.ZipCode zc on zc.id = qs.zip_code__c

/***********************************************************
Calculate Backlog by Market
***********************************************************/
SELECT COUNT(*) as RecordCount
    ,asofdate as AsOf
    ,Market
    ,[Availability]
    ,SVMXC__Order_Type__c as OrderType
    ,InstallType
FROM #backlog bl
    LEFT JOIN #site_to_market s2m on s2m.Id = bl.site_id
GROUP BY asofdate
    ,Market
    ,[Availability]
    ,SVMXC__Order_Type__c
    ,InstallType