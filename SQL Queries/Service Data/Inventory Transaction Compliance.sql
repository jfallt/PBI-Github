-- CTE#1
with parts_transacted_per_WO as (
    -- parts transacted in a work order
    -- all non-labor lines with non-null SVMXC__Actual_Quantity2__c value
    -- for completed work orders
    select top 10 swol.id as swo_detail_id,
           swol.name as swo_detail,
           swo.id as wo_id,
           swo.svmxc__order_type__C,
           swo.SVMX_PS_Override_Order_Type__c,
           isNull(swo.SVMX_PS_Override_Order_Type__c, swo.svmxc__order_type__C) as wo_effective_type,
           swol.SVMXC__Actual_Price2__c,
           swol.SVMXC__Actual_Quantity2__c,
           p.id as product_id,
           i.id as item_id,
           i.name as item,
           i.scmc__item_description__c
    from temporal.svmxcserviceorderline swol
      inner join temporal.svmxcserviceorder swo on swo.id = swol.SVMXC__Service_Order__c
      inner join product2 p on p.id = swol.SVMXC__Product__c
      inner join temporal.scmcitem i on i .id = p.Integration_SCM_Item_External_Id__c
    where swol.SVMXC__Line_Type__c <> 'Labor'
      and swol.SVMXC__Actual_Quantity2__c is not null
      and swo.svmxc__order_status__c = 'complete'
),

/*

-- CTE#2
parts_transacted_per_WO_type as (
    -- aggregate of CTE#1 by item and work order type
    select item,
           scmc__item_description__c,
           wo_effective_type,
           sum(SVMXC__Actual_Quantity2__c) num_transacted,
           count(distinct wo_id) as num_work_orders
    from parts_transacted_per_WO
    group by item,
             scmc__item_description__c,
             wo_effective_type
),
-- CTE#3
tot_completed_wo_by_type as (
    -- total number of completed work orders by "effective type"
    select isNull(SVMX_PS_Override_Order_Type__c, svmxc__order_type__C) as wo_effective_type,
           count(*) as tot_wo
    from temporal.svmxcserviceorder
    where svmxc__order_status__C = 'complete'
    group by isNull(SVMX_PS_Override_Order_Type__c, svmxc__order_type__C)
),
-- CTE#4
transaction_percentage as (
    -- join of CTE#3 and CTE#4 to calculate a percentage, then pick out the top 10 most transacted parts per WO
    select item,
           scmc__item_description__c,
           wo_effective_type,
           num_transacted,
           num_work_orders,
           tot_wo,
           pct_wo_where_part_transacted
    from (
          select trans.*,
                 wo.tot_wo,
                 cast(trans.num_work_orders as decimal(18,2))/ wo.tot_wo as pct_wo_where_part_transacted,
                 row_number() over(partition by trans.wo_effective_type order by cast(trans.num_work_orders as decimal)/ wo.tot_wo desc) as rn
          from parts_transacted_per_WO_type  trans
            inner join tot_completed_wo_by_type wo on wo.wo_effective_type = trans.wo_effective_type
    ) trans
    where rn <= 10
)
select item,
       scmc__item_description__c,
       wo_effective_type,
       num_transacted,
       cast(num_transacted as decimal)/num_work_orders as num_transacted_per_WO,
       num_work_orders,
       tot_wo,
       pct_wo_where_part_transacted
from transaction_percentage
order by 3, 7 desc
*/