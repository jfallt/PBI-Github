SELECT SVMXC__Product__c as ProductID
	, SVMX_PS_Q_Number_Short__c as QNumber
	, Market__c as Market
, SVMXC__Date_Installed__c as InstallDate
FROM [Temporal].[SVMXCInstalledProduct] sIP
WHERE Name LIKE 'IP%'
AND SVMXC__Status__c = 'Installed'