;WITH AllStatuses AS

(SELECT DISTINCT
	[SVMXC__Order_Status__c] as 'OrderStatus'
	FROM [TemporalHistory].[SVMXCServiceOrder]
	WHERE 1=1)

SELECT *,
-------------------------------------------------
-- Define Availability by Order Status ----------
-------------------------------------------------
CASE
	WHEN OrderStatus = 'Cancel'
		THEN 'Cancel'
	WHEN OrderStatus = 'Complete'
		THEN 'Complete'
	WHEN OrderStatus IN ('On Site'
						,'Service Hold'
						,'Scheduled'
						,'Open'
						,'Scheduling Hold'
						,'Reschedule'
						,'Ready to Schedule'
						,'Missed Appointment')
		THEN 'Available'
	WHEN OrderStatus IN ('Parts Hold'
						,'Pending Equipment/Parts'
						,'Supply Chain Hold'
						,'Sales Hold'
						,'Pending Contractor'
						,'OS Pending contractor (ETA)'
						,'OS Pending contractor (Paperwork)'
						,'OS Hold for shipping ETA'
						,'OS Warranty'
						,'Customer Success Hold'
						,'Customer Hold')
		THEN 'Unavailable'
	ELSE 'Needs Group'
	END As 'Availability',

-------------------------------------------
------ Attribute Status to Department -----
-------------------------------------------
CASE
	WHEN OrderStatus = 'Cancel'
		THEN 'Cancel'
	WHEN OrderStatus = 'Complete'
		THEN 'Complete'
	WHEN OrderStatus IN ('On Site', 'Service Hold','Missed Appointment')
		THEN 'Service'
	WHEN OrderStatus = 'Scheduled'
		THEN 'Scheduled'
	WHEN OrderStatus IN ('Parts Hold', 'Pending Equipment/Parts','Supply Chain Hold','Open')
		THEN 'Supply Chain'
	WHEN OrderStatus = 'Sales Hold'
		THEN 'Sales'
	WHEN OrderStatus IN ('Pending Contractor','OS Pending contractor (ETA)','OS Pending contractor (Paperwork)','OS Hold for shipping ETA','OS Warranty')
		THEN 'Contractor/OS'
	WHEN OrderStatus IN ('Customer Success Hold', 'Customer Hold')
		THEN 'Customer'
	WHEN OrderStatus IN ('Scheduling Hold', 'Reschedule', 'Ready to Schedule')
		THEN 'Customer Care'
	ELSE 'Needs Group'
	END As 'Group'
FROM AllStatuses
