------------------------------------------------------------------------------------------------------
---------------------Create temp table to store results of while loop---------------------------------														
------------------------------------------------------------------------------------------------------
DROP TABLE IF EXISTS #overdue_history

CREATE TABLE #overdue_history (
					 AsOfDate datetime
					,Account_Number nvarchar (1300)
					,Invoice_Number nvarchar (80)
					,Legacy_Invoice_Number nvarchar	(255)
					,Invoice_Date datetime
					,Roll_Date datetime
					,Balance float
					,Invoice_Due_Date datetime
					,Zuora__Age_Bucket__c nvarchar	(1300)
					,Number_of_Days_Passed__c float
					,Days_Overdue float
					,Payment nvarchar (32)
					,Zuora__Account__c nvarchar	(18)
					,Total_Amount float
					);
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

	INSERT INTO #overdue_history (
					 AsOfDate
					,Account_Number
					,Invoice_Number
					,Legacy_Invoice_Number
					,Invoice_Date
					,Roll_Date
					,Balance
					,Invoice_Due_Date
					,Zuora__Age_Bucket__c
					,Number_of_Days_Passed__c
					,Days_Overdue
					,Payment
					,Zuora__Account__c
					,Total_Amount
					)

	SELECT CAST(@asofdate AS DATE)
		,zi.Account_Number__c
		,zi.[Name]
		,LegacyInvoiceNumber__c
		,CAST(Zuora__InvoiceDate__c as DATE)
		,DATEADD(d, 91, CAST(Zuora__DueDate__c as DATE)) -- add 91 days to due date for roll
		,Zuora__Balance2__c as Balance
		,CAST(Zuora__DueDate__c as DATE)
		,Zuora__Age_Bucket__c
		,zi.Number_of_Days_Passed__c
		,DATEDIFF(d
				,CAST(Zuora__DueDate__c as DATE)
				,CAST(@asofdate as DATE)
				)
		,[Zuora__PaymentTerm__c]
		,zi.Zuora__Account__c
		,Zuora__TotalAmount__c as Total_Amount
	FROM Temporal.ZuoraZInvoice FOR SYSTEM_TIME AS OF @asofdate zi
	WHERE Zuora__Balance2__c <> 0

	SET @quarter_offset = @quarter_offset + 1; -- add one day to asofdate
	SET @asofdate = DATEADD(qq, DATEDIFF(qq, 0, GETDATE()) - @quarter_offset, 0)

END
------------------------------------------------------------------------------------------------------
----------------------------Apply Aging Transformation------------------------------------------------
------------------------------------------------------------------------------------------------------
SELECT AsOfDate
	,Zuora__Account__c as Account_Id
	,Invoice_Number
	,Legacy_Invoice_Number
	,Invoice_Date
	,Invoice_Due_Date
	,Days_Overdue
	,Balance
	,CASE
		 WHEN Days_Overdue <=0   THEN 'Current'
		 WHEN Days_Overdue <=30  THEN '1-30'
		 WHEN Days_Overdue <=60  THEN '31-60'
		 WHEN Days_Overdue <=90  THEN '61-90'
		 WHEN Days_Overdue <=120 THEN '91-120'
		 WHEN Days_Overdue <=150 THEN '121-150'
		 WHEN Days_Overdue <=180 THEN '151-180'
		 WHEN Days_Overdue > 180 THEN '180+'
		 ELSE 'No Aging'
	 END as Revised_Aging
	 ,Roll_Date
	,CASE
		WHEN Days_Overdue > 90 THEN 0
		WHEN DATEPART(QUARTER, Roll_Date) = DATEPART(QUARTER, AsOfDate)
		AND DATEPART(YEAR, Roll_Date)= DATEPART(YEAR, AsOfDate)
		THEN 1
		ELSE 0
		END as Roll
	,Total_Amount
 FROM #overdue_history
 WHERE asofdate <> CAST(GETDATE() as DATE)