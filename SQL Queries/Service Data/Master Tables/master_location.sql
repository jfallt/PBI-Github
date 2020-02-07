SELECT DISTINCT z.id 
	,z.Name AS 'Zip Code'
	,z.Region__c as Region
	,CASE WHEN z.Name = 'M6A2T9'
	THEN 'Toronto'
	ELSE City__c END as City
	,z.State__c as State
	,z.Country__c as Country
	,z.Submarket__c as Submarket
	,z.MSA_CSA__c as Market
	,z.SLA_Terms__c SLA
	,z.Service_Coverage__c as 'Service Coverage'
	,z.Filtration__c as Filtration
	,sg.Name as Technician
FROM Temporal.ZipCode z
    LEFT JOIN Temporal.SVMXCServiceGroupMembers sg on sg.id = z.Technician__c