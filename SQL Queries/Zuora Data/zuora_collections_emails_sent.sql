/* Purpose: Identify invoices where payments (or credits) were not made before their due date + 90 days
*/

DECLARE @today AS DATE
SET @today = CAST(GETDATE() as DATE)

;WITH payments_on_invoice AS
(
	SELECT zi.id
		,DATEADD(d,90, CAST(Zuora__DueDate__c as DATE)) as email_date
		,CAST(
			MIN(ISNULL(ISNULL(zp.CreatedDate, zip.CreatedDate), @today) -- find payment or credit applied, if there isn't one sub today's date
				) as DATE)
		as first_payment_date
	FROM Temporal.ZuoraZInvoice zi
		LEFT JOIN Temporal.ZuoraPayment zp on zp.Zuora__Invoice__c = zi.Id
		LEFT JOIN Temporal.ZuoraPaymentInvoice zip on zip.Zuora__Invoice__c = zi.id
	WHERE DATEADD(d,90, CAST(Zuora__DueDate__c as DATE)) < @today
		AND DATEADD(d,90, CAST(Zuora__DueDate__c as DATE)) > '2019-01-01'
	GROUP BY DATEADD(d,90, CAST(Zuora__DueDate__c as DATE))
		,zi.id
)

SELECT email_date
	,COUNT(*) as email_count
FROM payments_on_invoice
WHERE email_date <= first_payment_date
GROUP BY email_date