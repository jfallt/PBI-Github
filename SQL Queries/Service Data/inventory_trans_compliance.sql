/* item master */

With Items As (
select item,Supply_Family,[description],category,Sub_Category,Stocking_Strategy,Legacy_Unit_Flag
from drp_ff_test.items),

/* current inventory */

Current_Inventory as (
select i.item,
iv.warehouse_id as 'whse',
sum(iv.item_qty) as 'current_inventory_qty'
from [DRP_FF_Test].[view_historic_inventory] iv
join drp_ff_test.items i on i.item = iv.item_id
where the_date = cast(getdate() as date)
group by i.item,
iv.warehouse_id ),

/* starting inventory for period */

Start_Inventory as (
select i.item,
iv.warehouse_id as 'whse',
sum(iv.item_qty) as '2019_start_qty'
from [DRP_FF_Test].[view_historic_inventory] iv
join drp_ff_test.items i on i.item = iv.item_id
where the_date = '2020-01-05'
group by i.item,
iv.warehouse_id ),

/* ending inventory for period */

End_Inventory as (
select i.item,
iv.warehouse_id as 'whse',
sum(iv.item_qty) as '2019_end_qty'
from [DRP_FF_Test].[view_historic_inventory] iv
join drp_ff_test.items i on i.item = iv.item_id
where the_date = cast(getdate() as date)
group by i.item,
iv.warehouse_id ),

/* shipments sent to shed */

Shipments as (
select s.Item, 
s.To_Whse as 'Whse', sum(s.Received_Qty) as 'qty'
from drp_ff_test.Shipments_v s
where s.Ship_Date >= '1/1/2020'
and Shipment_Type like ('DC to Shed - Standard')
group by s.Item, s.To_Whse),

/* variance from 2019 PI, provided by IT */

Variance as (

select isNull(s.whse_name,e.whse_name) as whse_name,
       isNull(s.item_name,e.item_name) as item_name,
          --- parts

          --isnull(s.PartRMQTY_s,0) as 'prt_starting qty',
          --isnull(e.PartRMQTY_e,0) as 'prt_ending qty',
          
          ----- serial qty

          --isnull(s.SerialQTY_s,0) as 'ser_starting qty',
          --isnull(e.SerialQTY_e,0) as 'ser_ending qty',

          ---- lost qty
          
          --isnull(s.PartRMQTY_s,0) as 'prt_starting qty',
          --isnull(e.PartRMQTY_e,0) as 'prt_ending qty',
       s.PartRMValue as starting_PartRMValue,
       e.PartRMValue as ending_PartRMValue,
       isNull(e.PartRMValue,0) - isNull(s.PartRMValue,0) as PartRMVariance,
          isnull(s.PartRMQTY_s,0) -  isnull(e.PartRMQTY_e,0) as qty_var,
       s.SerialValue as starting_SerialValue,
       e.SerialValue as ending_SerialValue,
       isNull(e.SerialValue,0) - isNull(s.SerialValue,0) as SerialVariance,
       s.LostSerialValue as starting_LostSerialValue,
       e.LostSerialValue as ending_LostSerialValue,
       isNull(e.LostSerialValue,0) - isNull(s.LostSerialValue,0) as LostSerialVariance
from (
  select w.name as whse_name,
         i.name as item_name,
         
              sum(case when SCMC__Serial_Number_Lookup__c is null then SCMC__Quantity__c else 0 end) as PartRMQTY_s,
         sum(case when SCMC__Serial_Number_Lookup__c is not null and isNull(lp_Quench__Event__c,'') <> 'lost' then SCMC__Quantity__c else 0 end) as SerialQTY_s,
         sum(case when SCMC__Serial_Number_Lookup__c is not null and isNull(lp_Quench__Event__c,'') = 'lost' then SCMC__Quantity__c else 0 end) as LostSerialQTY_s,
             
              sum(case when SCMC__Serial_Number_Lookup__c is null then SCMC__Current_Value__c * SCMC__Quantity__c else 0 end) as PartRMValue,
         sum(case when SCMC__Serial_Number_Lookup__c is not null and isNull(lp_Quench__Event__c,'') <> 'lost' then SCMC__Current_Value__c * SCMC__Quantity__c else 0 end) as SerialValue,
         sum(case when SCMC__Serial_Number_Lookup__c is not null and isNull(lp_Quench__Event__c,'') = 'lost' then SCMC__Current_Value__c * SCMC__Quantity__c else 0 end) as LostSerialValue
  from QPI_2019._QUENCH_QPI_Starting_Inventory_Position sip
    inner join temporal.scmcInventoryLocation il on il.id = sip.scmc__bin__c
    inner join temporal.scmcWarehouse w on w.id = il.scmc__warehouse__c
    inner join temporal.scmcitem i on i.id = sip.scmc__item_master__c
    left join QPI_2019._QUENCH_QPI_Starting_Serial_Number sn on sip.SCMC__Serial_Number_Lookup__c = sn.id
  group by w.name,i.name
  ) s

  full outer join (

  select w.name as whse_name,
         i.name as item_name,
         
              sum(case when SCMC__Serial_Number_Lookup__c is null then SCMC__Quantity__c else 0 end) as PartRMQTY_e,

         sum(case when SCMC__Serial_Number_Lookup__c is not null and isNull(lp_Quench__Event__c,'') <> 'lost' then SCMC__Quantity__c else 0 end) as SerialQTY_e,
         sum(case when SCMC__Serial_Number_Lookup__c is not null and isNull(lp_Quench__Event__c,'') = 'lost' then SCMC__Quantity__c else 0 end) as LostSerialQTY_e,
             
              sum(case when SCMC__Serial_Number_Lookup__c is null then SCMC__Current_Value__c * SCMC__Quantity__c else 0 end) as PartRMValue,
         sum(case when SCMC__Serial_Number_Lookup__c is not null and isNull(lp_Quench__Event__c,'') <> 'lost' then SCMC__Current_Value__c * SCMC__Quantity__c else 0 end) as SerialValue,
         sum(case when SCMC__Serial_Number_Lookup__c is not null and isNull(lp_Quench__Event__c,'') = 'lost' then SCMC__Current_Value__c * SCMC__Quantity__c else 0 end) as LostSerialValue
  from QPI_2019._QUENCH_QPI_Ending_Inventory_Position sip
    inner join temporal.scmcInventoryLocation il on il.id = sip.scmc__bin__c
    inner join temporal.scmcWarehouse w on w.id = il.scmc__warehouse__c
    inner join temporal.scmcitem i on i.id = sip.scmc__item_master__c
    left join QPI_2019._QUENCH_QPI_Ending_Serial_Number sn on sip.SCMC__Serial_Number_Lookup__c = sn.id
  group by w.name,i.name
  ) e on s.whse_name = e.whse_name and s.item_name = e.item_name
where isNull(s.PartRMValue,0) > 0
   or isNull(s.SerialValue,0) > 0
   or isNull(s.LostSerialValue,0) > 0
   or isNull(e.PartRMValue,0) > 0
   or isNull(e.SerialValue,0) > 0
   or isNull(e.LostSerialValue,0) > 0

),


/* variance from 2019 PI, provided by IT -- grouped */

groupedvariance as (
  
  select item_name as 'item',whse_name as 'whse',sum(isnull(qty_var,0)) as 'var_qty'
   from variance
   group by item_name,whse_name),

/* negative inventory transaction in 2020 */

negative_inventory as (
select 
i.[Name] as 'item',
pr.scmc__warehouse__c as 'whse',
sum(pr.SCMC__Quantity__c) as 'qty'
FROM Temporal.SCMCInventoryTransactionPerpetualRecord pr
INNER JOIN Temporal.SCMCInventoryTransactionFinancialRecords fin ON pr.Id = fin.SCMC__Inventory_Transaction__c --AND SCMC__GL_Account__c = 'Cost of Goods Sold'
left join temporal.scmcReasonCode rc on pr.SCMC__Reason_Code__c = rc.id --and rc.name = 'scrap'
left join temporal.SCMCItem i on i.id = pr.SCMC__Item_Master__c 
where cast(fin.CreatedDate as date) > '1/5/2020'
and rc.name = 'negative inventory'
--pr.SCMC__Export_Status__c = 'Exported'
--and (fin.scmc__icp_unit_cost__c = 0
--or fin.SCMC__ICP_Value_Amount__c = 0)
group by i.[Name],
pr.scmc__warehouse__c
),

transacted as (
--- field and customer trans
select item_id as 'item',
td.trans_whse as 'whse',
sum(item_qty) as 'qty' 
from [DRP_FF_Test].[view_transacted_demand] td
where year(td.trans_date) = '2020' 
and item_qty > 0
group by item_id,
td.trans_whse
),

production_trans as (select item_id as 'item',
warehouse_id as 'whse',
sum(transaction_qty) as qty
from DRP_FF_Test.view_all_prod_trans
where transaction_sub_type_desc <> 'Finish Transaction'
                    and transact_date >='1/1/2020'
                    and category not in ('Serialized Equipment', 'Raw Material')
                    and transaction_qty <> 0
group by item_id,
warehouse_id ),


/* item and whse grouping */

itemgroup as (

select whse,item from Current_Inventory
UNION
select whse,item from Start_Inventory
UNION
select whse,item from End_Inventory
UNION
select whse,item from Shipments
UNION
select whse,item from groupedvariance
UNION
select whse,item from negative_inventory
UNION 
select whse,item from transacted
UNION
select whse,item from production_trans),

/*distinct item and whse grouping */

distinct_item_whse as (
select distinct * 
from itemgroup)

select i.*,
ai.SCMC__Item_Description__c,
ai.Category__c,
ai.Sub_Category__c,
isnull(ci.current_inventory_qty,0) as 'current_inventory_qty',
isnull(si.[2019_start_qty],0) as '2020_start_qty',
--isnull(ei.[2019_end_qty],0) as '2019_end_qty',
isnull(gv.var_qty,0) as 'var_qty',
isnull(pt.qty,0) + isnull(t.qty,0)  as 'transacted_qty',
isnull(ni.qty,0)  as 'negative_qty',
isnull(s.qty,0) as 'shipped_qty'

from distinct_item_whse i
left join Current_Inventory ci on ci.item = i.Item and ci.whse = i.whse
left join Start_Inventory si on si.Item = i.item and si.whse = i.whse
left join End_Inventory ei on ei.Item = i.item and ei.whse = i.whse
left join groupedvariance gv on gv.item = i.item and gv.whse = i.whse
left join transacted t on t.item = i.item and t.whse = i.whse
left join production_trans pt on pt.item = i.item and pt.whse = i.whse
left join negative_inventory ni on ni.item = i.item and ni.whse = i.whse
left join Shipments s on s.item = i.item and s.whse = i.whse
join temporal.SCMCItem ai on ai.[Name] = i.item and ai.Category__c in ('Part','Filter')
--left join purchases p on p.item_id = i.Item
--left join production_trans pt on pt.item_id = i.item
where isnull(ni.qty,0) <> 0
and (isnull(ci.current_inventory_qty,0) = 0
and isnull(si.[2019_start_qty],0) = 0)
order by 1,2
