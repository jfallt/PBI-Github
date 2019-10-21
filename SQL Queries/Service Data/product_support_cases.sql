WITH ProductSupportCases AS

(
SELECT
	CaseNumber,	
	[Origin],
	c.Subject,
	AdditionalTrainingNeeded__c as AdditionalTrainingNeeded,
	c.Resolution_Code__c as ResCode,
	LEFT(c.Description, 80) as Description,
	Type,
	SecondaryType__c as SecondaryType,
	ISNULL(sfr1.Name, ISNULL(ISNULL(Technician_Name__c,[Technician_LU__c]), [SuppliedName])) as Employee,
	CAST([ClosedDate] as DATE) as ClosedDate,
CAST(c.CreatedDate as DATE) as CreatedDate,
	[IsClosed],
	[IsClosedOnCreate],
	[Linked_Work_Orders__c],
	CASE
		WHEN so.Name IS NULL AND SUBSTRING(c.Description, CHARINDEX('QWO-',c.Description), 12) LIKE 'QWO-%'
		THEN SUBSTRING(c.Description, CHARINDEX('QWO-',c.Description), 12)
		WHEN so.Name IS NULL AND SUBSTRING(c.Description, CHARINDEX('WO-',c.Description), 11) LIKE 'WO-%'
		THEN SUBSTRING(c.Description, CHARINDEX('WO-',c.Description), 11)
		WHEN so.Name IS NULL AND SUBSTRING(c.Subject, CHARINDEX('QWO-',c.Description), 12) LIKE 'QWO-%'
		THEN SUBSTRING(c.Subject, CHARINDEX('QWO-',c.Description), 12)
		WHEN so.Name IS NULL AND SUBSTRING(c.Subject, CHARINDEX('WO-',c.Description), 11) LIKE 'WO-%'
		THEN SUBSTRING(c.Subject, CHARINDEX('WO-',c.Description), 11)
		ELSE so.Name
	END as WorkOrder,
	[PartsUnavailableontruck__c] as PartsUnavailableonTruck,
	ISNULL(ISNULL([ProductId], so.SVMXC__Product__c), c.SVMXC__Product__c) as ProductId,
  --sfr.Name as RecordType,
	sf.Name as CaseOwner

FROM [Temporal].[Case] c
LEFT JOIN [Temporal].[SVMXCServiceOrder] so on so.Id = c.WorkOrder__c
LEFT JOIN [Reporting].[SalesforceUser] sf on sf.Id = c.OwnerId
LEFT JOIN [Reporting].[SalesforceRecordType] sfr on sfr.Id = c.RecordTypeId
LEFT JOIN [Reporting].[SalesforceUser] sfr1 on sfr1.Id = c.Employee__c
WHERE
	(sfr.Name = 'Service - Product Support'
--OR	 sfr.Name = 'Service'
--OR	 sfr.Name = 'Service - Outsource'
--OR   sfr.Name = 'Service - Reschedule'
--OR   sfr.Name = 'Service - Scheduling'
)
AND (SuppliedEmail LIKE '%@quenchonline.com%' OR SuppliedEmail IS NULL)
)

SELECT * FROM ProductSupportCases