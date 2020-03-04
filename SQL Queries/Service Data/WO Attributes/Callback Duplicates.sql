SELECT * FROM Reporting.wo_call_back_v cb
WHERE cb.original_work_order__c IN (SELECT cb.original_work_order__c
                                    FROM Reporting.wo_call_back_v cb
                                    GROUP BY cb.original_work_order__c
                                    HAVING COUNT(*) > 1)
ORDER BY cb.original_work_order__c

SELECT * FROM Reporting.wo_call_back_v cb
WHERE cb.Callback_Work_Order__c IN (SELECT Callback_Work_Order__c
                                    FROM Reporting.wo_call_back_v cb
                                    GROUP BY cb.Callback_Work_Order__c
                                    HAVING COUNT(*) > 1)
ORDER BY cb.Callback_Work_Order__c