;WITH TruckRollTasks AS

(
select CAST(t.CreatedDate as Date) as Created_Date
	,t.Subject as [Subject]
	,t.ownerid
	,CASE
		WHEN LEFT(t.Subject, 4) = 'Trac'
		THEN 'NA'
		WHEN LEFT(t.Subject, 4) = 'Tran'
		THEN 'NA'
		WHEN LEFT(t.Subject, 4) = 'Tran'
		THEN 'NA'
		WHEN LEFT(t.Subject, 4) = 'Trap'
		THEN 'NA'
		WHEN RIGHT(t.Subject,3) = 'Tra'
		THEN 'TRA'
		WHEN RIGHT(t.Subject,3) = 'Trp'
		THEN 'TRP'
		WHEN LEFT(t.Subject, 3) = 'Tra'
		THEN 'TRA'
		WHEN LEFT(t.Subject, 3) = 'Trp'
		THEN 'TRP'
	ELSE 'NA'
	END as Truck_Roll_Prevention
FROM Temporal.Task t
WHERE t.status like 'completed'
AND t.TaskSubtype = 'Call'
)

SELECT * FROM TruckRollTasks
WHERE Truck_Roll_Prevention <> 'NA'