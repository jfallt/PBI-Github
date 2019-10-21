select r.Customer_Name,
       r.Customer_Number as cust_num,
       r.Site_Sequence as cust_seq,
       r.QforceEffectiveSubscriptionStatus as subscription_status,
       r.SubscriptionEnhancedType as Subscription_type,
       r.SubscriptionEntitlementTemplateName,
       r.ProductName,
       r.ProductFamily,
       r.Site_City__c as Site_city,
       r.Site_State__c as Site_State,
       r.Site_Postal_Code__c as Site_Postal_code,
       z.[Filtration__c] as 'Filtration',
       r.entry_quantity__c as Quantity,
       z.submarket__c as submarket,
       ISNULL(m.name, s.[Preferred_Technician_Name__c]) as Technician,
       ISNULL(z.Region__c, s.[Service_Region__c])  as Region, 
	   s.[SLA_Package__c],
	   r.asofdate,
	   r.[RecurringMonthlyRevenue] as RecurringMonthlyRevenue,
	   r.[SubscriptionAcquisitionSource] as Acquisition	   
	   
from [Reporting].[QforceSubscriptionFinancialAndContractual] r
LEFT JOIN temporal.zipcode z on z.Id = r.PostalCodeID
LEFT JOIN [Temporal].[QforceSite] s on s.[Id] = r.[SiteID]
LEFT JOIN Temporal.SVMXCServiceGroupMembers m on z.Technician__c = m.id  
WHERE r.entry_quantity__c > 0
AND r.asofdate = CAST(DATEADD(DAY, -1, GETDATE()) AS DATE)