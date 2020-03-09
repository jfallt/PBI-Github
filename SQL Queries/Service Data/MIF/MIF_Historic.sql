select SUM(Quantity) as Quantity
	,ProductID
	,Market
	,asofdate
	,SubscriptionType
	,[Status]
from
(   SELECT r.asofdate
        ,r.qforceEffectiveStatus as [Status]
        ,r.qforceEffectiveSubscriptionType as SubscriptionType
        ,z.MSA_CSA__c as Market
        ,r.MIF as Quantity
        ,r.productid as ProductId
    FROM Reporting.CoreMetricsMonthlyAndCurrent_v r
        INNER JOIN temporal.zipcode z on z.Id = r.PostalCodeID
    WHERE r.qforceEffectiveStatus  <> 'Cancelled'
        AND asofdate >= '2018-01-01'
        AND qforceEffectiveSubscriptionType IN ('Maintenance', 'Rental')
) a
group by ProductID
	,Market
	,asofdate
	,SubscriptionType
	,[Status]