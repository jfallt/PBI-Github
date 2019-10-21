SELECT DISTINCT SVMXC__Order_Type__c as 'Order Type'
FROM Temporal.SVMXCServiceOrder
WHERE SVMXC__Order_Type__c IS NOT NULL