SELECT DISTINCT sf1.Id
,sf1.Name
	, sf2.Name as Manager
 FROM Reporting.SalesforceUser sf1
 LEFT JOIN Reporting.SalesforceUser sf2 on sf1.ManagerId = sf2.Id
RIGHT JOIN Temporal.SVMXCServiceOrder so on so.SMAX_PS_Sales_Rep__c = sf1.Id
WHERE sf1.Id is NOT NULL