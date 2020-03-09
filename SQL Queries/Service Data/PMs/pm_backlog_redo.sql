/***********************************************************
Purpose: Calculate historic PM backlog

Step 1: Get list of accounts on credit hold at each month's end
Step 2: Add versionendtime to abridged history table
Step 3: Get current market info joining from site, to zip code
Step 4: Calculate backlog using union of abridged history table
    and existing backlog table, checking for credit holds on
    accounts
***********************************************************/


/***********************************************************
Credit Hold History by Account
***********************************************************/
DECLARE @asofdate as date
SET @asofdate = GETDATE()

DROP TABLE IF EXISTS #credit_hold_history
CREATE TABLE #credit_hold_history (account_id nvarchar (MAX)
					   ,asofdate date)

;WHILE @asofdate > '2018-02-27'

BEGIN

INSERT INTO #credit_hold_history (account_id, asofdate)

	SELECT id
        ,@asofdate
	FROM Temporal.Account FOR SYSTEM_TIME AS OF @asofdate a
	WHERE Credit_Hold_Quench__c = 1;

	SET @asofdate = EOMONTH(DATEADD(m, -1, @asofdate)) -- get previous month
END
GO

/***********************************************************
Add version end date to service order history
and only include PMs
***********************************************************/

DROP TABLE IF EXISTS #service_order_history

SELECT soh.id
    ,so.SVMXC__Site__c
    ,soh.VersionStartTime
    ,ISNULL(
        LEAD(soh.versionstarttime) OVER (PARTITION BY soh.id ORDER BY soh.versionstarttime)
        ,GETDATE()) as versionendtime
    ,soh.SVMXC__Company__c
    ,soh.SVMXC__Order_Status__c
    ,so.SVMXC__Preferred_Start_Time__c
    ,so.Market__c
INTO #service_order_history
FROM Reporting.svmxcServiceOrder_HistoryAbridged soh
    INNER JOIN Temporal.SVMXCServiceOrder so on so.id = soh.id
WHERE soh.SVMXC__Order_Type__c IN ('PM', 'Routine')  

/***********************************************************
Calculate the backlog by site
***********************************************************/
DROP TABLE IF EXISTS #pm_backlog
CREATE TABLE #pm_backlog (site_id nvarchar (MAX)
                        ,asofdate date
                        ,Market__c nvarchar (MAX)
                        ,backlog_count int)


DECLARE @asofdate2 as datetime
SET @asofdate2 = GETDATE()


;WHILE @asofdate2 > '2019-11-01 00:00:00.000'

BEGIN

INSERT INTO #pm_backlog (site_id, asofdate, Market__c, backlog_count)

	SELECT SVMXC__Site__c
        ,@asofdate2 as asofdate
        ,Market__c
        ,CASE
        WHEN EXISTS (SELECT chh.account_id
                    FROM #credit_hold_history chh
                    WHERE chh.account_id = soh.SVMXC__Company__c
                        AND chh.asofdate = CAST(@asofdate2 as DATE))
        THEN 0 ELSE 1 END as backlog_count
	FROM #service_order_history soh
	WHERE soh.VersionStartTime <= @asofdate2
        AND soh.VersionEndTime >= @asofdate2
        AND SVMXC__Preferred_Start_Time__c <= @asofdate2
        AND soh.SVMXC__Order_Status__c IN ('Open'
                                        ,'OS Warranty'
                                        ,'Ready to Schedule'
                                        ,'Reschedule'
                                        ,'Scheduling Hold'
                                        ,'Service Hold');

	SET @asofdate2 = EOMONTH(DATEADD(m, -1, @asofdate2)) -- get previous month
END
GO

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
SELECT SUM(backlog_count) as pm_backlog
    ,asofdate
    ,ISNULL(Market, Market__c) as Market
FROM #pm_backlog pmb
    LEFT JOIN #site_to_market s2m on s2m.Id = pmb.site_id
GROUP BY asofdate
    ,ISNULL(Market, Market__c)

UNION

SELECT SUM(backlog_count) as RecordCount
	,asOfDate
    ,Market__c as Market
FROM
(
	SELECT ss.Market__c
		,bh.asOfDate
		,so.SVMXC__Order_Type__c
        ,CASE
        WHEN EXISTS (SELECT chh.account_id
                    FROM #credit_hold_history chh
                    WHERE chh.account_id = so.SVMXC__Company__c
                        AND chh.asofdate = CAST(asofdate as DATE))
        THEN 0 ELSE 1 END as backlog_count
	FROM work_order_backlog_history bh
		INNER JOIN Temporal.SVMXCServiceOrder so on so.id = bh.wo_id
		LEFT JOIN Temporal.SVMXCSite ss on ss.Id = so.SVMXC__Site__c
	WHERE so.SVMXC__Order_Type__c IN ('PM', 'Routine')
        AND bh.asofdate < '2019-11-01'
		AND so.SVMXC__Preferred_Start_Time__c < bh.asOfDate
		AND bh.SVMXC__Order_Status__c IN ('Open'
										,'OS Warranty'
										,'Ready to Schedule'
										,'Reschedule'
										,'Scheduling Hold'
										,'Service Hold')
) a
GROUP BY asOfDate
	,Market__c