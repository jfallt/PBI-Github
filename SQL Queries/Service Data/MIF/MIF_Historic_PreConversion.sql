SELECT SUM(Quantity) as Quantity
	,ProductFamily
	,Market
	,asofdate
	,SubscriptionEnhancedType as SubscriptionType
FROM
	(select CASE
		WHEN ProductFamily IN ('Boston Board System', 'Boston Filter', 'Boston Small RO', 'Parts', 'Filter', 'Tank')
		THEN 'Water'
		WHEN ProductFamily IN ('Water', 'Sparkling', 'Ice', 'Coffee')
		THEN ProductFamily
		ELSE 'Other'
		End as 'ProductFamily'
		, r.entry_quantity__c as Quantity
		, ISNULL(z.MSA_CSA__c, s.[Market__c]) as Market
		, r.AsOfDate 
		,SubscriptionEnhancedType
	from [Reporting].[PreConversionSubscriptionFinancialAndContractual_Monthly] r
	LEFT JOIN temporal.zipcode z on z.Id = r.PostalCodeID
	LEFT JOIN [Temporal].[QForceSite] s on s.[Id] = r.[SiteID]
	WHERE r.SubscriptionEnhancedType IN ('Maintenance', 'Rental')
	AND r.entry_quantity__c > 0) b
GROUP BY
	ProductFamily,
	SubscriptionEnhancedType,
	Market,
	asofdate

	UNION ALL 

SELECT SUM(Quantity) as Quantity
	,ProductFamily
	,Market
	,asofdate
	,SubscriptionEnhancedType as SubscriptionType
	FROM
	(select CASE
		WHEN ProductFamily IN ('Boston Board System', 'Boston Filter', 'Boston Small RO', 'Parts', 'Filter', 'Tank')
		THEN 'Water'
		WHEN ProductFamily IN ('Water', 'Sparkling', 'Ice', 'Coffee')
		THEN ProductFamily
		ELSE 'Other'
		End as 'ProductFamily'
		, r.entry_quantity__c as Quantity
		, ISNULL(z.MSA_CSA__c, s.[Market__c]) as Market
		, DATEADD(day, 1, r.AsOfDate) as AsOfDate
		,SubscriptionEnhancedType
	from [Reporting].[PreConversionSubscriptionFinancialAndContractual] r
	LEFT JOIN temporal.zipcode z on z.Id = r.PostalCodeID
	LEFT JOIN [Temporal].[QForceSite] s on s.[Id] = r.[SiteID]
	WHERE r.SubscriptionEnhancedType IN ('Maintenance', 'Rental')
	AND r.entry_quantity__c > 0
	AND r.AsOfDate = '2017-07-30') c
	GROUP BY
	ProductFamily,
	SubscriptionEnhancedType,
	Market,
	asofdate