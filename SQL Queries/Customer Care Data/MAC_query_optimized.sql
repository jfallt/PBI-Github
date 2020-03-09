/* Purpose: Find missed appointments by comparing data from yesterday to today
Step 1: Identify if labor occured on a work order
Step 2: Use various where statements (and step 1) to identify which work orders require reschedule action
	Join with tasks to see if work order had reschedule action
Step 3: Check work orders with resolution codes against previous day
Step 4: Determine if we need to contact customer*/

declare @lastworkingday DATETIME 
	
set @lastworkingday = CAST(DATEADD(DAY, CASE DATENAME(WEEKDAY, GETDATE())
                        WHEN 'Sunday' THEN -2 			
                        WHEN 'Monday' THEN -3 			
                        ELSE -1			
                        END, DATEDIFF(DAY, 0, GETDATE())) as DATE)

/**********************************************************************************
Step 1: Check if there are labor transactions on potential reschedule work orders
**********************************************************************************/
;WITH labor AS
(
select sy.wo_id
	,SUM(sol.SVMXC__Actual_Quantity2__c) as labor_qty
FROM reporting.scheduledWorkOrders sy 
	INNER JOIN Temporal.SVMXCServiceOrder so on so.id = sy.wo_id
	LEFT JOIN Temporal.SVMXCServiceOrderLine sol on sol.SVMXC__Service_Order__c = so.id
	LEFT JOIN product2 p2 on p2.id = sol.SVMXC__Product__c
WHERE so.svmxc__Order_status__c IN ('Scheduled', 'Ready to Schedule', 'Open')
	AND so.Field_Status__c IS NULL
	AND sy.asofdate = @lastworkingday
	AND p2.Name = 'Labor Fee'
	AND so.Market__c <> 'ROW'
	AND so.svmxc__Order_type__c NOT IN ('Delivery'
										,'PM TNM'
										,'Retrofit'
										,'Technical Survey'
										,'PM'
										,'Site Audit'
										,'Repossession')
GROUP BY sy.wo_id
),

/**********************************************************************************
Step 2: Using tasks table, see if we called the customer
**********************************************************************************/

assign_codes AS
(
select sy.wo_id
	,so.Name as work_order
	,so.svmxc__Order_status__c as current_status
	,so.account_number__c as account_number
	,so.Account_Name__c as account_name
	,so.svmxc__Order_type__c as order_type
	,so.Market__c as market
	,CAST(so.SVMXC__Scheduled_Date_Time__c AT TIME ZONE 'UTC' AT TIME ZONE 'Eastern Standard Time' as DATE) as current_sched_date
	,MAX(CASE WHEN Cast(t.createddate AT TIME ZONE 'UTC' AT TIME ZONE 'Eastern Standard Time' as date) >= @lastworkingday
		AND t.Whatid LIKE 'a7K%'
		THEN 1 ELSE 0 END ) as called_cust
	,CASE WHEN @lastworkingday = CAST(so.SVMXC__Scheduled_Date_Time__c AT TIME ZONE 'UTC' AT TIME ZONE 'Eastern Standard Time' as DATE)
		THEN 1 ELSE 0 END as sched_date_unchanged
	,so.Scheduling_Notes__c as sched_notes
	,so.SVMXC__Work_Performed__c as wo_notes
	,so.Resolution_Code__c as res_code
	,CAST(so.createddate as DATE) as wo_createddate
FROM reporting.scheduledWorkOrders sy 
	LEFT JOIN Temporal.Task t on sy.wo_id = t.Whatid
	INNER JOIN Temporal.SVMXCServiceOrder so on so.id = sy.wo_id
	LEFT JOIN labor l on l.wo_id = so.Id
WHERE so.svmxc__Order_status__c IN ('Open'
								   ,'Scheduled'
								   ,'Ready to Schedule')
	--AND so.Resolution_Code__c IS NULL
	AND sy.asofdate = @lastworkingday
	AND ISNULL(l.labor_qty, 0) = 0 -- if tech transacted labor, then we are assuming he was on site
	AND so.Field_Status__c IS NULL -- same as above, field status change indicates tech was on site
	AND so.Market__c <> 'ROW'
	AND so.svmxc__Order_type__c NOT IN ('Delivery'
										,'PM TNM'
										,'Retrofit'
										,'Technical Survey'
										,'PM'
										,'Site Audit'
										,'Repossession')
GROUP BY sy.wo_id
	,so.svmxc__Order_status__c
	,so.account_number__c
	,so.Account_Name__c
	,CAST(so.SVMXC__Scheduled_Date_Time__c AT TIME ZONE 'UTC' AT TIME ZONE 'Eastern Standard Time' as DATE)
	,so.svmxc__Order_type__c
	,l.labor_qty
	,so.Market__c
	,so.Name
	,so.Scheduling_Notes__c
	,so.Resolution_Code__c
	,so.SVMXC__Work_Performed__c
	,CAST(so.createddate as DATE)
)
,
/**********************************************************************************
Step 3: get res codes for work orders with a current rescode
**********************************************************************************/
old_res_code AS
(
SELECT so.id
	,so.Resolution_Code__c as res_code
FROM Temporal.SVMXCServiceOrder FOR SYSTEM_TIME AS OF @lastworkingday so
WHERE so.id IN (SELECT wo_id FROM assign_codes WHERE res_code IS NOT NULL)
AND CAST(so.CreatedDate as DATE) <= @lastworkingday
)

/**********************************************************************************
Step 4: Using queries from steps 3 and 4, assign need to contact
**********************************************************************************/

SELECT ac.*
	,CASE
		WHEN called_cust = 1 THEN 0 -- if we contacted the customer
		WHEN ac.res_code IS NOT NULL AND ac.res_code <> c.res_code --if the new rescode isn't equal to the old 
		THEN 0
		WHEN ac.res_code IS NOT NULL AND c.res_code IS NULL --if new res code exists and old res code was null
		THEN 0
		WHEN sched_date_unchanged = 1 THEN 1 
		WHEN called_cust = 0 THEN 1
		ELSE 0
	END as need_to_contact --assign need to contact based if there's a task (i.e. cust was contacted)
FROM assign_codes ac
    LEFT JOIN old_res_code c on c.id = ac.wo_id
WHERE ac.wo_createddate <> @lastworkingday
