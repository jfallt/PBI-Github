/* AR SRO - Activities on Contacts
Locates activities logged with contact information??*/

DROP TABLE #contactactivity

SELECT t.id 
    ,a.Account_Number__c as 'Account Number'
    ,u.Name as 'Created By'
    ,t.subject
    ,c.name as 'Contact Name'
    ,CAST(t.CreatedDate AS DATE) as CreatedDate
    ,t.WhoId
    ,t.WhatId
    ,CASE
        /*WHEN t.Subject LIKE'%[A][R]%'
        THEN 1
        WHEN t.subject LIKE '%A[ /]R%'
        THEN 1 */
        WHEN t.subject LIKE '%Account Receivable%'
        THEN 1
        WHEN t.subject LIKE '%overdue%'
        THEN 1
        WHEN t.subject LIKE '%Invoice%'
        THEN 1
        WHEN t.subject LIKE '%Balance%'
        THEN 1
        WHEN t.subject LIKE '%Collections%'
        THEN 1
        WHEN t.subject LIKE '%INV[0-9]%'
        THEN 1
        WHEN t.subject LIKE '%Past Due%'
        THEN 1
        ELSE 0
    END as criteria_check
INTO #contactactivity
FROM Temporal.task t
    LEFT JOIN Temporal.Contact c ON c.id = t.WhoId
    LEFT JOIN Temporal.Account a ON t.accountid = a.id
    LEFT JOIN dbo.[User] u ON t.createdbyid = u.id
WHERE t.WhoID LIKe '003%'
    AND CAST(t.CreatedDate as DATE) = '2020-02-27'
    --AND CAST(t.CreatedDate as DATE) < '2020-03-02'
    AND t.createdbyid NOT IN (
        '00536000003i1IlAAI' --Marketo U.ID
        ,'00536000003iGkQAAU' --Migration U.ID
        )

SELECT * FROM #contactactivity
WHERE criteria_check = 1