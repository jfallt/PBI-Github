SELECT DISTINCT
	Name AS 'Zip Code',
	--City__c as 'City',
	--[State__c] as 'State',
	--Country__c as 'Country',
	Region__c as 'Region',
	Submarket__c as 'Submarket',
	MSA_CSA__c as 'Market',
        [SLA_Terms__c] 'SLA',
        [Service_Coverage__c] as 'Service Coverage',
        [Filtration__c] as 'Filtration'
FROM [Temporal].[ZipCode]