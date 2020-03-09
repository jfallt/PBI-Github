/*
  we collect candidate work orders with call back (via IP, scan Q, or Q Num in) within 30 days
  then limit to unique orig and callback wo
  then save for delivery to SFDC after skipping any that were already identified

  the delivery to sfdc is via Skyvia synchronization of table:

create table wo_call_back (
  id int identity not null primary key,
  Original_Work_Order__c nvarchar(18) not null,
  Callback_Work_Order__c nvarchar(18) not null,
  Callback_Confirmed__c bit,
  Callback_Excluded__c bit,
  name nvarchar(80),
  Comments__c nvarchar(max)
);

--select * from wo_call_back
--exec callback_work_order_sp

*/ 
DROP TABLE IF EXISTS #wos
DROP TABLE IF EXISTS #candidate_callbacks
DROP TABLE IF EXISTS #candidate_callbacks_both_unique
  -- first get projection of interesting columns from all candidate wo

  select wo.id as wo_id,
       wo.createddate as createdDate,
       wo.SVMXC__Actual_Resolution__c as resolution_date,
       wo.SVMXC__Order_Type__c as order_type,
       wo.SVMXC__Component__c as ip_id,
       wo.Scanned_Q_Number__c as scan,
       wo.Q_Number_In_c__c as qNum_in,
       ip.Q_Number__c as ip_qNum
  into #wos
  -- select count(*)
  from temporal.svmxcServiceOrder wo
    left join temporal.svmxcInstalledproduct ip on wo.SVMXC__Component__c = ip.id
  where svmxc__order_status__c = 'complete'
   -- and SVMXC__Order_Type__c not in ('Technical Survey','Site Audit','Customer Purchase')
    and YEAR(wo.SVMXC__Actual_Resolution__c) >= '2019';

  create clustered columnstore index wo_cx on #wos;

  -- select candidate callback wos

  select o.wo_id as orig_wo_id,
       n.wo_id as callback_wo_id,
       datediff(dd,o.resolution_date,n.createddate) as date_diff,
       o.createddate as orig_createdDate,
       o.resolution_date as orig_resolution_date,
       o.order_type as orig_order_type,
       o.ip_id as orig_ip_id,
       o.scan as orig_scan,
       o.qNum_in as orig_qNum_in,
       n.createddate as new_createdDate,
       n.resolution_date as new_resolution_date,
       n.order_type as new_order_type,
       n.ip_id as new_ip_id,
       n.scan as new_scan,
       n.qNum_in as new_qNum_in 
  into #candidate_callbacks
  -- select count(*)
  from #wos n
    inner join #wos o on n.ip_id = o.ip_id
  where n.wo_id <> o.wo_id
   /* and n.order_type not in ('Repossession','Removal','Technical Survey','Site Audit','Relocation In',
                        'Relocation Out','Relocation Same','Customer Purchase','Retrofit',
              'Upgrade','PM','PM TNM','Routine','Install','Delivery') */
    and o.createddate < n.createddate
    and datediff(dd,o.resolution_date,n.createddate) between 1 and 30
  union
  select o.wo_id as orig_wo_id,
       n.wo_id as callback_wo_id,
       datediff(dd,o.resolution_date,n.createddate) as date_diff,
       o.createddate as orig_createdDate,
       o.resolution_date as orig_resolution_date,
       o.order_type as orig_order_type,
       o.ip_id as orig_ip_id,
       o.scan as orig_scan,
       o.qNum_in as orig_qNum_in,
       n.createddate as new_createdDate,
       n.resolution_date as new_resolution_date,
       n.order_type as new_order_type,
       n.ip_id as new_ip_id,
       n.scan as new_scan,
       n.qNum_in as new_qNum_in 
  -- select count(*)
  from #wos n
    inner join #wos o on n.ip_qNum = o.scan
  where n.wo_id <> o.wo_id
    /*and n.order_type not in ('Repossession','Removal','Technical Survey','Site Audit','Relocation In',
                        'Relocation Out','Relocation Same','Customer Purchase','Retrofit',
              'Upgrade','PM','PM TNM','Routine','Install','Delivery') */
    and o.createddate < n.createddate
    and datediff(dd,o.resolution_date,n.createddate) between 1 and 30
  union
  select o.wo_id as orig_wo_id,
       n.wo_id as callback_wo_id,
       datediff(dd,o.resolution_date,n.createddate) as date_diff,
       o.createddate as orig_createdDate,
       o.resolution_date as orig_resolution_date,
       o.order_type as orig_order_type,
       o.ip_id as orig_ip_id,
       o.scan as orig_scan,
       o.qNum_in as orig_qNum_in,
       n.createddate as new_createdDate,
       n.resolution_date as new_resolution_date,
       n.order_type as new_order_type,
       n.ip_id as new_ip_id,
       n.scan as new_scan,
       n.qNum_in as new_qNum_in 
  -- select count(*)
  from #wos n
    inner join #wos o on n.ip_qNum = o.qNum_in
  where n.wo_id <> o.wo_id
    and n.order_type not in ('Repossession','Removal','Technical Survey','Site Audit','Relocation In',
                        'Relocation Out','Relocation Same','Customer Purchase','Retrofit',
              'Upgrade','PM','PM TNM','Routine','Install','Delivery')
    and o.createddate < n.createddate
    and datediff(dd,o.resolution_date,n.createddate) between 1 and 30;

  -- more than 2 callback report
  /*
  select orig_wo_id,
       count(*) as num_callbacks,
       string_agg(callback_wo_id + '(' + new_order_type + ', ' + convert(nvarchar(10), new_createdDate, 23) + ')',' | ') within group (order by new_createdDate) as callback_wos--,
     --  string_agg(convert(nvarchar(10), new_createdDate, 23),',') within group (order by new_createdDate) as callback_wos_createdates,
     --  string_agg(new_order_type,',') within group (order by new_createdDate) as callback_wos_types
  from #candidate_callbacks
  where orig_createddate >'1/1/2019'
  group by orig_wo_id
  having count(*) > 2
  order by 2 desc
  */
  -- pick one callback -> orig based on latest resolution date, now the set is 1 to 1
  select orig_wo_id,
       callback_wo_id,
       date_diff,
       orig_createdDate,
       orig_resolution_date,
       orig_order_type,
       orig_ip_id,
       orig_scan,
       orig_qNum_in,
       new_createdDate,
       new_resolution_date,
       new_order_type,
       new_ip_id,
       new_scan,
       new_qNum_in
  into #candidate_callbacks_both_unique
  from (
      select *,
         row_number() over(partition by orig_wo_id order by new_createdDate) as orig_rn,
         row_number() over(partition by callback_wo_id order by orig_resolution_date desc) as callback_rn
      from #candidate_callbacks
  ) a
  where orig_rn = 1
    and callback_rn = 1;

  select orig_wo_id,callback_wo_id
  from #candidate_callbacks_both_unique u