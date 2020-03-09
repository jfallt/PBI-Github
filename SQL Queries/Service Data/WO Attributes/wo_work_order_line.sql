/***********************************************************
Purpose: Aggregate work order transactions by family
    calculate total line price and quantity
***********************************************************/

WITH transactions AS
(
SELECT SVMXC__Service_Order__c as WorkOrder_id
	,SVMXC__Product__c as Product_id
	,SVMXC__Total_Line_Price__c
    ,CASE WHEN SVMXC__Total_Line_Price__c > 250
	    AND SVMXC__Product__c = '01t36000003PhNKAA0'
	THEN 1
    WHEN SVMXC__Total_Line_Price__c < 0
	    AND SVMXC__Product__c = '01t36000003PhNKAA0'
	THEN 1
	ELSE 0
	END as TransactionError
	,sf.Email
	,p2.Family
    ,sl.SVMXC__Actual_Quantity2__c
 FROm Temporal.svmxcserviceorderline sl
    LEFT JOIN reporting.SalesforceUser sf on sf.id = sl.CreatedById
    LEFT JOIN Product2 p2 on p2.id = sl.SVMXC__Product__c
WHERE SVMXC__Actual_Quantity2__c <> 0
)

SELECT SUM(SVMXC__Total_Line_Price__c) as TotalLinePrice
    ,SUM(SVMXC__Actual_Quantity2__c) as TotalQuantity
    ,WorkOrder_id
    ,TransactionError
    ,Family
    ,Email
FROM transactions
GROUP BY WorkOrder_id
    ,TransactionError
    ,Family
    ,Email