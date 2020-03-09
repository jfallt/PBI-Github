SELECT r.qforceEffectiveStatus as [Status]
	,r.qforceEffectiveSubscriptionType as [Type]
	,r.entitlementtemplatename as Entitlement
	,r.siteid as qSiteID
	,r.MIF as Quantity
	,CAST(GETDATE() as DATE) as asofdate
	,r.RMR as RecurringMonthlyRevenue
	,r.acquisitionsource as Acquisition
	,r.productid as ProductId
	,r.accountid
FROM Reporting.latest_working_smz r
WHERE r.qforceEffectiveStatus  <> 'Cancelled' --only interested in active MIF

/* Saving Old Version for Reference
SELECT r.QforceEffectiveSubscriptionStatus as [Status]
	,r.SubscriptionEnhancedType as [Type]
	,r.SubscriptionEntitlementTemplateName as Entitlement
	,r.SiteID as qSiteID
	,r.entry_quantity__c as Quantity
	,r.asofdate
	,r.[RecurringMonthlyRevenue] as RecurringMonthlyRevenue
	,r.[SubscriptionAcquisitionSource] as Acquisition
	,r.ProductId
FROM [Reporting].[QforceSubscriptionFinancialAndContractual] r
WHERE r.entry_quantity__c > 0
	AND r.asofdate = ((SELECT MAX(asofdate) as MaxAsOfDate FROM [Reporting].[QforceSubscriptionFinancialAndContractual]) )
*/
