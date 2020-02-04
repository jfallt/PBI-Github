-- Declare and set as of date
DECLARE @asofdate as date
SET @asofdate = DATEADD(qq, DATEDIFF(qq, 0, GETDATE()), 0)

-- create temp table to store results
DROP TABLE IF EXISTS #balance_history
CREATE TABLE #balance_history (balance int
					   ,asofdate date)

;WHILE @asofdate < GETDATE()

BEGIN

WITH Past_Due_Invoices AS
(
SELECT CAST(@asofdate as DATE) as AsOfDate
    ,Zuora__Balance2__c as Balance
	,DATEDIFF(d
			,CAST(Zuora__DueDate__c as DATE)
			,CAST(@asofdate as DATE)
			) as Days_Overdue
FROM Temporal.ZuoraZInvoice FOR SYSTEM_TIME AS OF @asofdate zi
WHERE Zuora__Balance2__c <> 0
)


	INSERT INTO #balance_history (balance, asofdate)

	SELECT SUM(Balance) as balance, @asofdate as asofdate
	FROM Past_Due_Invoices
	WHERE Days_Overdue >= 180;

	SET @asofdate = DATEADD(d, 1, @asofdate) -- add one day to asofdate
END
GO

 -- get results from temp table
SELECT asofdate
	,balance
FROM #balance_history