SELECT
	SUM(TotalLinePrice) as TotalLinePrice,
	WorkOrder_id,
	Family,
	Email
FROM
(SELECT SVMXC__Service_Order__c as WorkOrder_id
	, SVMXC__Product__c as Product_id
	,CASE WHEN SVMXC__Total_Line_Price__c > 250
	 AND SVMXC__Product__c = '01t36000003PhNKAA0'
	 THEN 250
	 ELSE SVMXC__Total_Line_Price__c
	 END as TotalLinePrice
	,sf.Email
	,p2.Family
 FROm Temporal.svmxcserviceorderline sl
 LEFT JOIN reporting.SalesforceUser sf on sf.id = sl.CreatedById
 LEFT JOIN Product2 p2 on p2.id = sl.SVMXC__Product__c
 WHERE SVMXC__Total_Line_Price__c > 0) a
 GROUP BY 	WorkOrder_id,
	Family,
	Email