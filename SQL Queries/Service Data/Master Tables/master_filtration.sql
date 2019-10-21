SELECT CASE
WHEN Filtration LIKE '%RO%'
THEN 'RO'
ELSE 'Standard'
END AS FiltrationGroup,
a.*
FROM
(SELECT DISTINCT [SVMX_PS_Filtration__c] as 'Filtration' FROM [Source].[SVMXC__Service_Order__c]) a