; WITH cte_transactions as
 (
    select top 10 swo.id as wo_id,
           isNull(swo.SVMX_PS_Override_Order_Type__c, swo.svmxc__order_type__C) as wo_effective_type,
           swol.SVMXC__Actual_Price2__c,
           swol.SVMXC__Actual_Quantity2__c,
           i2.Name as wo_product,
           p.Family as wo_family,
           p2.Family as wo_line_family,
           i.name as item,
           i.scmc__item_description__c
    from temporal.svmxcserviceorderline swol
      inner join temporal.svmxcserviceorder swo on swo.id = swol.SVMXC__Service_Order__c
      inner join product2 p on p.id = swo.SVMXC__Product__c
      inner join product2 p2 on p2.id = swol.SVMXC__Product__c
      inner join temporal.scmcitem i on i.id = p2.Integration_SCM_Item_External_Id__c
      inner join temporal.scmcitem i2 on i.id = p.Integration_SCM_Item_External_Id__c
    where swol.SVMXC__Line_Type__c <> 'Labor'
      and swol.SVMXC__Actual_Quantity2__c is not null
      and swo.svmxc__order_status__c = 'complete'
      and p.Family = 'Water'
      and p2.Family not in ('Ice', 'Water', 'Sparkling', 'Coffee')
 )

SELECT *
FROM   (SELECT wo_id,
               ,
               AnnualPay
        FROM   cte_transactions
        WHERE  RowNumber = 1
            AND wo_effective_type = 'PM') as SourceTable
PIVOT
(
   Sum(swol.SVMXC__Actual_Quantity2__c)
   FOR wo_line IN ([item])
) AS TotalTransactions