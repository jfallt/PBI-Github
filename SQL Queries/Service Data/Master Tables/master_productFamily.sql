WITH ProductFamily AS
(
SELECT DISTINCT
	[ProductFamily] as ProductFamily
FROM [Reporting].[QforceSubscriptionFinancialAndContractual]

UNION ALL

SELECT DISTINCT
	[Family] as ProductFamily
FROM [dbo].[Product2]
),

DistinctFamily AS
(
SELECT DISTINCT * FROM ProductFamily
)

SELECT
	*,
	CASE
		WHEN ProductFamily IN ('Boston Board System'
								,'Boston Filter'
								,'Boston Small RO'
								,'Parts'
								,'Filter')
		THEN 'Water'
		WHEN ProductFamily IN ('Water'
							,'Sparkling'
							,'Ice'
							,'Coffee')
		THEN ProductFamily
	ELSE 'Other'
	End as 'Group'
FROM DistinctFamily
WHERE ProductFamily IS NOT NULL
