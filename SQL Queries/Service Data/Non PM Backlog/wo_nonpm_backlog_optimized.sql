SELECT COUNT(*) as RecordCount
	,Market__c as Market
	,asOfDate as AsOf
	,Install_Type as InstallType
	,[Availability]
	,SVMXC__Order_Type__c as OrderType
FROM
(
	SELECT ss.Market__c
		,bh.asOfDate
		,so.SVMXC__Order_Type__c
		,CASE
			WHEN so.SVMXC__Order_Type__c IN ('Install', 'Purchase Install') AND SMAX_PS_Project_Name__c IS NOT NULL
			THEN 'Project'
			WHEN so.SVMXC__Order_Type__c IN ('Install', 'Purchase Install')
			THEN 'Single'
			ELSE null
		END as Install_Type
		,CASE
			WHEN bh.SVMXC__Order_Status__c IN ('On Site'
												,'Open'
												,'Ready to Schedule'
												,'Reschedule'
												,'Scheduling Hold'
												,'Service Hold')
			THEN 'Available'
			WHEN bh.SVMXC__Order_Status__c = 'Scheduled'
			THEN 'Scheduled'
			ELSE 'Unavailable'
			END as [Availability]
	FROM work_order_backlog_history bh
	INNER JOIN Temporal.SVMXCServiceOrder so on so.id = bh.wo_id
	LEFT JOIN Temporal.SVMXCSite ss on ss.Id = so.SVMXC__Site__c
	WHERE so.SVMXC__Order_Type__c IN ('Install', 'Purchase Install', 'Removal', 'Repossession')
) a
GROUP BY asOfDate
	,Market__c
	,Install_Type
	,[Availability]
	,SVMXC__Order_Type__c