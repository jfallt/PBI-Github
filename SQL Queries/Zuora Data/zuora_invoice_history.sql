DECLARE @asofdate as Date
SET @asofdate = '2019-10-01'

;WITH Past_Due_Invoices AS
(
SELECT @asofdate as AsOfDate
	,zi.Account_Number__c as Account_Number
    ,zi.[Name] as Invoice_Number
    ,LegacyInvoiceNumber__c as Legacy_Invoice_Number
    ,CAST(Zuora__GeneratedDate__c as DATE) as Invoice_Date
	,DATEADD(d, 91, CAST(Zuora__DueDate__c as DATE)) as Roll_Date -- add 91 days to due date for roll
    ,Zuora__Balance2__c as Balance
	,CAST(Zuora__DueDate__c as DATE) as Invoice_Due_Date
	,Zuora__Age_Bucket__c
	,zi.Number_of_Days_Passed__c
	,DATEDIFF(d
			,CAST(Zuora__DueDate__c as DATE)
			,CAST(@asofdate as DATE)
			) as Days_Overdue
	,[Zuora__PaymentTerm__c] as Payment
	,zi.Zuora__Account__c
FROM Temporal.ZuoraZInvoice FOR SYSTEM_TIME AS OF @asofdate zi
WHERE Zuora__Balance2__c <> 0
)

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
		WHEN DATEPART(QUARTER, Roll_Date) = DATEPART(QUARTER, @asofdate)
		AND DATEPART(YEAR, Roll_Date)= DATEPART(YEAR, @asofdate)
		THEN 1
		ELSE 0
		END as Roll
 FROM Past_Due_Invoices