/* Problem: For individual collections metrics, we need to know the original total balance.
Solution: We sum the total amount due for each roll bucket where the balance is = 0
We can use this aggregate in our PowerBI calculation so we can still have drill down ability*/

SELECT CAST(GETDATE() as DATE) as AsOfDate 
	,CollectionsOwner__c
	,SUM(CASE WHEN DATEDIFF(m, GETDATE(), DATEADD(day,61,zi.Zuora__DueDate__c))  = 0 THEN Zuora__TotalAmount__c ELSE 0 End) as total_balance_60
	,SUM(CASE WHEN DATEDIFF(m, GETDATE(), DATEADD(day,91,zi.Zuora__DueDate__c))  = 0 THEN Zuora__TotalAmount__c ELSE 0 End) as total_balance_90
	,SUM(CASE WHEN DATEDIFF(m, GETDATE(), DATEADD(day,121,zi.Zuora__DueDate__c)) = 0 THEN Zuora__TotalAmount__c ELSE 0 End) as total_balance_120
	,SUM(CASE WHEN DATEDIFF(m, GETDATE(), DATEADD(day,151,zi.Zuora__DueDate__c)) = 0 THEN Zuora__TotalAmount__c ELSE 0 End) as total_balance_150
	,SUM(CASE WHEN DATEDIFF(m, GETDATE(), DATEADD(day,181,zi.Zuora__DueDate__c)) = 0 THEN Zuora__TotalAmount__c ELSE 0 End) as total_balance_180
FROM Temporal.ZuoraZInvoice zi
	LEFT JOIN Temporal.Account a on zi.Zuora__Account__c = a.Id
WHERE Zuora__Balance2__c = 0
GROUP BY CollectionsOwner__c