SELECT [Original_Work_Order__c] as BreakFixTriggerPM
FROM [Temporal].[PMTransaction]
WHERE [Status__c] = 'Completed'