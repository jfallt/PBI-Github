select r.Customer_Name as [Name]
	,r.Customer_Number as Number
	,r.Site_Sequence as [Sequence]
	,r.QforceEffectiveSubscriptionStatus as [Status]
	,r.SubscriptionEnhancedType as [Type]
	,r.SubscriptionEntitlementTemplateName as Entitlement
	,r.Site_City__c as City
	,r.Site_State__c as [State]
	,r.Site_Postal_Code__c as 'Postal Code'
	,z.[Filtration__c] as Filtration
	,r.entry_quantity__c as Quantity
	,z.MSA_CSA__c as Market
	,z.submarket__c as Submarket
	,s.[SLA_Package__c] as SLA
	,r.asofdate
	,r.[RecurringMonthlyRevenue] as RecurringMonthlyRevenue
	,r.[SubscriptionAcquisitionSource] as Acquisition
	,r.ProductId
	,ISNULL(z.Technician__c, s.Preferred_Tech__c)  as Technician_ID
from [Reporting].[QforceSubscriptionFinancialAndContractual] r
	LEFT JOIN temporal.zipcode z on z.Id = r.PostalCodeID
	LEFT JOIN [Temporal].[QforceSite] s on s.[Id] = r.[SiteID]
WHERE r.entry_quantity__c > 0
	AND r.asofdate = ((SELECT MAX(asofdate) as MaxAsOfDate FROM [Reporting].[QforceSubscriptionFinancialAndContractual]) )