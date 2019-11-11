WITH Past_Due_Invoices AS
(
SELECT zi.Account_Number__c as Account_Number
    ,a.Name as Account_Name
    ,zi.[Name] as Invoice_Number
    ,LegacyInvoiceNumber__c as Legacy_Invoice_Number
    ,CAST(Zuora__GeneratedDate__c as DATE) as Invoice_Date
	,DATEADD(d, 91, CAST(Zuora__DueDate__c as DATE)) as Roll_Report -- add 91 days to due date for roll
    ,Zuora__Balance2__c as Balance
	,CAST(Zuora__DueDate__c as DATE) as Invoice_Due_Date
	,Zuora__Age_Bucket__c
	,zi.Number_of_Days_Passed__c
	,DATEDIFF(d
			,CAST(Zuora__DueDate__c as DATE)
			,CAST(GETDATE() as DATE)
			) as Days_Overdue
	,[Zuora__PaymentTerm__c] as Payment
	,a.EscalationsRegion__c as Region
	,sf.[Name] as Collector
	,a.Lead_Source__c as Lead_Source
	,CASE WHEN sf.[Name] = 'Frank Grillo' THEN 1 ELSE 0 End as Radius
	,CASE WHEN a.Name LIKE '%Wal-Mart%' OR a.Name LIKE '%Walmart%'
	THEN 1 ELSE 0 END as Walmart
FROM Temporal.ZuoraZInvoice zi
LEFT JOIN Temporal.Account a on a.Id = zi.Zuora__Account__c
LEFT JOIN Reporting.SalesforceUser sf on sf.id = a.CollectionsOwner__c
WHERE Zuora__Balance2__c <> 0
--AND Zuora__Age_Bucket__c <> 'On Time'
)

SELECT Account_Number
	,Account_Name
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
	 ,Roll_Report
	 --,CASE        ---ROLL CALC --- needs work
		--WHEN Days_Overdue > 90 THEN 0
		--WHEN Roll_Report < '1/1/2020' ),[@[Roll Report]]>=(DATEVALUE("10/1/2019"))),1,0))
	,Walmart
	,Lead_Source
	,Region
 FROM Past_Due_Invoices

