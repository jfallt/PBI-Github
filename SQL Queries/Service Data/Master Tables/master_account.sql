SELECT a.Id
	,a.Name as AccountName
	,a.Account_Number__c as AccountNumber
	,a.Sales_Team__c as SalesTeam
	,a.Sales_Region__c as SalesRegion
    ,a.Credit_Hold_Quench__c as Credit_Hold
	,a.Lead_Source__c as Acquisition
    ,CASE WHEN Parent_Account_Customer_Number__c IN ('D187246'
                                           ,'D241936'
                                           ,'D187246'
                                           ,'D135359')
    THEN 'MTA - Master'
    WHEN account_number__c IN ('D103927'
                            ,'D187246'
                            ,'D241936'
                            ,'D241959'
                            ,'D135359'
                            ,'D303989'
                            ,'D106611')
    THEN 'MTA - Master'
    WHEN a.Name LIKE '%Walmart%'
    THEN 'Wal-Mart - Master'
    WHEN a.Name LIKE '%Wal-mart%'
    THEN 'Wal-Mart - Master'
    WHEN a.Name LIKE '%Sams%' AND a.Name LIKE '%Club%'
    THEN 'Wal-Mart - Master'
    ELSE p.parent_account_name END as ParentAccountName
    ,CASE WHEN Parent_Account_Customer_Number__c IN ('D187246'
                                           ,'D241936'
                                           ,'D187246'
                                           ,'D135359')
    THEN 'D187246'
    WHEN account_number__c IN ('D103927'
                            ,'D187246'
                            ,'D241936'
                            ,'D241959'
                            ,'D135359'
                            ,'D303989'
                            ,'D106611')
    THEN 'D187246'
    WHEN a.Name LIKE '%Walmart%'
    THEN 'D102006'
    WHEN a.Name LIKE '%Wal-mart%'
    THEN 'D102006'
    WHEN a.Name LIKE '%Sams%' AND a.Name LIKE '%Club%'
    THEN 'D102006'
    ELSE p.parent_cust_num END as ParentAccountNumber
FROM Temporal.Account a
    LEFT JOIN reporting.latest_working_smz p on p.accountid = a.id
WHERE EXISTS (SELECT Account_Number__c FROM Temporal.SVMXCServiceOrder so WHERE so.Account_Number__c = a.Account_Number__c)