------------------------------------------------------------------------------------------------------
---------------------Create temp table to store results of while loop---------------------------------												
------------------------------------------------------------------------------------------------------
DROP TABLE IF EXISTS #roll_zero_balance_history

CREATE TABLE #roll_zero_balance_history (AsOfDate datetime
										,collector_id nvarchar (MAX)
										,total_balance_60 float
										,total_balance_90 float
										,total_balance_120 float
										,total_balance_150 float
										,total_balance_180 float);
------------------------------------------------------------------------------------------------------
----------------Declare variables, only looking at beginning date of quarter--------------------------
------------------------------------------------------------------------------------------------------
DECLARE @quarter_offset as int
SET @quarter_offset = 0

DECLARE @asofdate datetime
SET @asofdate = DATEADD(qq, DATEDIFF(qq, 0, GETDATE()) - @quarter_offset, 0)

------------------------------------------------------------------------------------------------------
--------------------------------------Begin while loop------------------------------------------------												
------------------------------------------------------------------------------------------------------
WHILE DATEADD(qq, DATEDIFF(qq, 0, GETDATE()) - @quarter_offset, 0) > '04-01-2019'  

BEGIN

	INSERT INTO #roll_zero_balance_history (AsOfDate
											,collector_id
											,total_balance_60
											,total_balance_90
											,total_balance_120
											,total_balance_150
											,total_balance_180)

SELECT @asofdate as AsOfDate 
	,CollectionsOwner__c
	,SUM(CASE WHEN DATEDIFF(m, GETDATE(), DATEADD(day,61,zi.Zuora__DueDate__c))  = 0 THEN Zuora__TotalAmount__c ELSE 0 End) as total_balance_60
	,SUM(CASE WHEN DATEDIFF(m, GETDATE(), DATEADD(day,91,zi.Zuora__DueDate__c))  = 0 THEN Zuora__TotalAmount__c ELSE 0 End) as total_balance_90
	,SUM(CASE WHEN DATEDIFF(m, GETDATE(), DATEADD(day,121,zi.Zuora__DueDate__c)) = 0 THEN Zuora__TotalAmount__c ELSE 0 End) as total_balance_120
	,SUM(CASE WHEN DATEDIFF(m, GETDATE(), DATEADD(day,151,zi.Zuora__DueDate__c)) = 0 THEN Zuora__TotalAmount__c ELSE 0 End) as total_balance_150
	,SUM(CASE WHEN DATEDIFF(m, GETDATE(), DATEADD(day,181,zi.Zuora__DueDate__c)) = 0 THEN Zuora__TotalAmount__c ELSE 0 End) as total_balance_180
FROM Temporal.ZuoraZInvoice FOR SYSTEM_TIME AS OF @asofdate zi
	LEFT JOIN Temporal.Account a on zi.Zuora__Account__c = a.Id
WHERE Zuora__Balance2__c = 0
GROUP BY CollectionsOwner__c

	SET @quarter_offset = @quarter_offset + 1; -- add one day to asofdate
	SET @asofdate = DATEADD(qq, DATEDIFF(qq, 0, GETDATE()) - @quarter_offset, 0)

END

SELECT * FROM #roll_zero_balance_history