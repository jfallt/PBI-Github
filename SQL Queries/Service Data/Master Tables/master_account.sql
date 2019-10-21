SELECT Id
	, Name as AccountName
	, Account_Number__c as AccountNumber
	, Sales_Team__c as SalesTeam
	, Sales_Region__c as SalesRegion
FROM [Temporal].[Account] a
WHERE EXISTS (SELECT Account_Number__c FROM Temporal.SVMXCServiceOrder so WHERE so.Account_Number__c = a.Account_Number__c)