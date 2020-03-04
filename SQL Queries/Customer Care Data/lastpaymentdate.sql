/*******************************************************
Purpose: Identify the last time an account has paid
********************************************************/
DROP TABLE IF EXISTS #credits
DROP TABLE IF EXISTS #payments
DROP TABLE IF EXISTS #lastpaymentdate

/*******************************************************
Step 1: Identify All Credits
********************************************************/
    select Zuora__Account__c
        ,MAX(zi.zuora__duedate__c) as [Date]
    into #credits
    from temporal.ZuoraZInvoice zi
    where zi.zuora__status__c like 'posted'
        and zi.zuora__creditbalanceadjustmentamount__C <> 0
    group by Zuora__Account__c

/*******************************************************
Step 2: Identify All Payments
********************************************************/
    select zp.Zuora__Account__c
        ,MAX(zpi.SystemModstamp) as [Date]
    into #payments
    from temporal.ZuoraPaymentInvoice zpi
        inner join Temporal.ZuoraPayment zp on zpi.zuora__payment__c=zp.id
    where zp.zuora__status__c like 'processed'
        and zp.zuora__appliedinvoiceamount__C <> 0
    group by zp.Zuora__Account__c

/*******************************************************
Step 3: Union Step 1 & 2 and take the max date
********************************************************/
;WITH lastpayment AS
(
    SELECT * FROM #payments

    union

    SELECT * FROM #credits
    )

SELECT Zuora__Account__c
    ,MAX([Date]) as lastpaymentdate
FROM lastpayment
group by Zuora__Account__c