SELECT SUM(Quantity) as Quantity
	, ProductFamily
	, Market
	, asofdate
	, SubscriptionType
FROM 
(	select CASE
		WHEN ProductFamily IN ('Boston Board System', 'Boston Filter', 'Boston Small RO', 'Parts', 'Filter', 'Tank')
		THEN 'Water'
		WHEN ProductFamily IN ('Water', 'Sparkling', 'Ice', 'Coffee')
		THEN ProductFamily
		ELSE 'Other'
		End as 'ProductFamily'
		, r.entry_quantity__c as Quantity
		, ISNULL(z.MSA_CSA__c, s.[Market__c]) as Market
		, r.asofdate
		,SubscriptionEnhancedType as SubscriptionType
	from [Reporting].[QForceSubscriptionFinancialAndContractual_MonthlyAndCurrent] r
	LEFT JOIN temporal.zipcode z on z.Id = r.PostalCodeID
	LEFT JOIN [Temporal].[QforceSite] s on s.[Id] = r.[SiteID]
	AND r.SubscriptionEnhancedType IN ('Maintenance', 'Rental')
	AND r.entry_quantity__c > 0
	) a
GROUP BY
	ProductFamily,
	SubscriptionType,
	Market,
	asofdate