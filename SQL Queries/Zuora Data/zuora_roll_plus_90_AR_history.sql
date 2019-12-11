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
	,DATEADD(d, 91, CAST(Zuora__DueDate__c as DATE)) as Roll_Date -- add 91 days to due date for roll
    ,Zuora__Balance2__c as Balance
	,DATEDIFF(d
			,CAST(Zuora__DueDate__c as DATE)
			,CAST(@asofdate as DATE)
			) as Days_Overdue
FROM Temporal.ZuoraZInvoice FOR SYSTEM_TIME AS OF @asofdate zi
WHERE Zuora__Balance2__c <> 0
),

Categories AS
(
	SELECT AsOfDate
		,Balance
		,CASE
			WHEN DATEPART(QUARTER, Roll_Date) = DATEPART(QUARTER, GETDATE())
			AND DATEPART(YEAR, Roll_Date)= DATEPART(YEAR, GETDATE())
			THEN 1
			WHEN Days_Overdue >=90  THEN 1
			ELSE 0
		 END as ninety_plus_or_roll
	 FROM Past_Due_Invoices
)

	INSERT INTO #balance_history (balance, asofdate)

	SELECT SUM(Balance) as balance, @asofdate as asofdate
	FROM Categories
	WHERE ninety_plus_or_roll = 1;

	SET @asofdate = DATEADD(d, 1, @asofdate) -- add one day to asofdate
END
GO

-- get results from temp table
SELECT asofdate
	,balance
	,LAG (balance) OVER (ORDER BY asofdate) - balance as daily_reduction
FROM #balance_history