select r.asofdate
	,r.QforceEffectiveSubscriptionStatus as subscription_status
	,SUM(r.entry_quantity__c) as Quantity
	,p2.Name as Product
	,w.Name as Shed
FROM [Reporting].[QforceSubscriptionFinancialAndContractual] r
	LEFT JOIN temporal.zipcode z on z.Id = r.PostalCodeID
	LEFT JOIN Temporal.QforceSite s on s.[Id] = r.[SiteID]
	LEFT JOIN Temporal.SVMXCSite ss on ss.qSite__c = s.id
	LEFT JOIN Temporal.SVMXCSite w on w.id = ss.Shed__c
	LEFT JOIN Product2 p2 on p2.id = r.ProductId
WHERE r.entry_quantity__c > 0
	AND r.asofdate = ((SELECT MAX(asofdate) as MaxAsOfDate FROM [Reporting].[QforceSubscriptionFinancialAndContractual]))
GROUP BY r.asofdate
	,r.QforceEffectiveSubscriptionStatus
	,p2.Name
	,w.Name