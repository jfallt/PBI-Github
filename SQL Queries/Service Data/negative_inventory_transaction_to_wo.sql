-- Negative Inventory Transactions
select top 5 rc.Name as reason_code,
    fin.id financial_trans_id,
    fin.SCMC__GL_Account__c as [Type],
    SCMC__Old_Location_Balance__c as old_balance,
    SCMC__New_Location_Balance__c as new_balance
from Temporal.SCMCInventoryTransactionPerpetualRecord pr
    inner join Temporal.SCMCInventoryTransactionFinancialRecords fin ON pr.Id = fin.SCMC__Inventory_Transaction__c
    left join temporal.scmcReasonCode rc on pr.SCMC__Reason_Code__c = rc.id
    --left join Temporal.SCMCItem i on i.id = pr.SCMC__Item_Master__c 
where rc.name = 'negative inventory'
    and fin.CreatedDate > '1/5/2020'


-- Sales Order to Work Order Line
SELECT top 5 sli.id
    ,so.id
    ,sli.lp_quench__Related_Record_Id__c as wo_line_id
    ,sli.*
    ,so.*
    --,pr.*
    ,SCMC__Inventory_Transactions__c
    ,SCMC__Old_Location_Balance__c
    ,SCMC__New_Location_Balance__c
FROM Temporal.SCMCSalesOrderLineItem sli
    inner join Temporal.SCMCSalesOrder so on so.id = sli.SCMC__Sales_Order__c
    inner join Temporal.SCMCInventoryTransactionPerpetualRecord pr on pr.SCMC__Sales_Order_Line_Item__c = sli.id
WHERE sli.lp_quench__Related_Record_Type__c = 'Work Order Detail'
    and SCMC__Old_Location_Balance__c = 0


select itpr.createddate,
       itpr.scmc__inventory_transactions__c,
       rc.name as rc,
       itpr.SCMC__New_Location_Balance__c,
       itpr.SCMC__Old_Location_Balance__c,
       itpr.SCMC__Quantity__c,
       scil.Name
from temporal.scmcinventorytransactionperpetualrecord itpr
  left join temporal.scmcreasoncode rc on rc.id = itpr.SCMC__Reason_Code__c
  inner join temporal.scmcinventorylocation scil on scil.id = SCMC__Inventory_Location__c
where SCMC__Inventory_Location__c= 'aFo1R0000004FVGSA2'
  and SCMC__Item_Master__c = 'aFw1R000000PBFaSAO'
  and itpr.createddate > '01/01/2020'
order by itpr.createddate