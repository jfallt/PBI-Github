SELECT Id
	, ISNULL([Item Master (Proposed New Product Name) (Value)], p2.Name) as Name
	, Description
	, p2.Family
	, Integration_SCM_Item_External_Id__c as SCM_Item_ID
FROM dbo.Product2 p2
LEFT JOIN dbo.[Products2ToItemMaster] p2m on p2.id = p2m.[Product Id]