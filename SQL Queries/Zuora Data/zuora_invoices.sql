WITH Past_Due_Invoices AS
(
SELECT CAST(GETDATE() as DATE) as AsOfDate
	,zi.Account_Number__c as Account_Number
    --,a.Name as Account_Name
    ,zi.[Name] as Invoice_Number
    ,LegacyInvoiceNumber__c as Legacy_Invoice_Number
    ,CAST(Zuora__InvoiceDate__c as DATE) as Invoice_Date
	,DATEADD(d, 91, CAST(Zuora__DueDate__c as DATE)) as Roll_Date -- add 91 days to due date for roll
    ,Zuora__Balance2__c as Balance
	,CAST(Zuora__DueDate__c as DATE) as Invoice_Due_Date
	,Zuora__Age_Bucket__c
	,zi.Number_of_Days_Passed__c
	,DATEDIFF(d
			,CAST(Zuora__DueDate__c as DATE)
			,CAST(GETDATE() as DATE)
			) as Days_Overdue
	,[Zuora__PaymentTerm__c] as Payment
	--,a.EscalationsRegion__c as Region
	--,sf.[Name] as Collector
	--,a.Lead_Source__c as Lead_Source
	,zi.Zuora__Account__c
	,zi.Zuora__TotalAmount__c as Total_Amount
	--,CASE WHEN sf.[Name] = 'Frank Grillo' THEN 1 ELSE 0 End as Radius
	--,CASE WHEN a.Name LIKE '%Wal-Mart%' THEN 1
	--WHEN a.Name LIKE '%Walmart%' THEN 1
	--ELSE 0 END as Walmart
FROM Temporal.ZuoraZInvoice zi
--LEFT JOIN Temporal.Account a on a.Id = zi.Zuora__Account__c
--LEFT JOIN Reporting.SalesforceUser sf on sf.id = a.CollectionsOwner__c
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
		WHEN DATEPART(QUARTER, Roll_Date) = DATEPART(QUARTER, GETDATE())
		AND DATEPART(YEAR, Roll_Date)= DATEPART(YEAR, GETDATE())
		THEN 1
		ELSE 0
		END as Roll
	,Total_Amount
 FROM Past_Due_Invoices