--need to include roll calculation, not sure how that works

SELECT --zi.[Name] as Invoice
	SUM(zp.Zuora__AppliedInvoiceAmount__c) as Applied_Invoice_Amount
	,CAST(zp.Zuora__CreatedDate__c as DATE) as Payment_Date
	,sf.[Name] as Collector
	--,CAST(Zuora__DueDate__c as DATE) as Payment_Due_Date
	--,DATEDIFF(d, Zuora__DueDate__c, zp.CreatedDate) as Days_Overdue
FROM Temporal.ZuoraPayment zp
LEFT JOIN Temporal.ZuoraZInvoice zi on zi.Id = zp.Zuora__Invoice__c
LEFT JOIN Temporal.Account a on a.Id = zi.Zuora__Account__c
LEFT JOIN Reporting.SalesforceUser sf on sf.id = a.CollectionsOwner__c
WHERE CAST(Zuora__CreatedDate__c as DATE) > '2019-10-01'
AND zp.Zuora__Invoice__c IS NOT NULL -- some payments do not match/have an invoice, not sure if we need to include these -JTF
AND DATEDIFF(d, Zuora__DueDate__c, zp.CreatedDate) > 0 -- only looking at overdue invoices aka invoices that would have gone to collections
GROUP BY CAST(zp.Zuora__CreatedDate__c as DATE)
	,sf.[Name]