SELECT COUNT(*) as RecordCount
	,Market__c as Market
	,asOfDate
FROM
(
	SELECT ss.Market__c
		,bh.asOfDate
		,so.SVMXC__Order_Type__c
	FROM work_order_backlog_history bh
		INNER JOIN Temporal.SVMXCServiceOrder so on so.id = bh.wo_id
		LEFT JOIN Temporal.SVMXCSite ss on ss.Id = so.SVMXC__Site__c
	WHERE so.SVMXC__Order_Type__c IN ('PM', 'Routine')
		AND so.SVMXC__Preferred_Start_Time__c < bh.asOfDate
		AND bh.SVMXC__Order_Status__c IN ('Open'
										,'OS Warranty'
										,'Ready to Schedule'
										,'Reschedule'
										,'Scheduling Hold'
										,'Service Hold')
) a
GROUP BY asOfDate
	,Market__c