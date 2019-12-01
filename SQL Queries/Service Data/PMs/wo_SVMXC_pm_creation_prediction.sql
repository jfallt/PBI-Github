with Sched_PMs as
(
    select a.*,
        b.retSeq,
		b.RetVal as PM_Sched_date,
		case when b.retVal < getdate() then year(getdate()) else year(b.RetVal) end as PM_Year,
		case when b.retVal < getdate() then month(getdate()) else month(b.RetVal) end as PM_Month,
		case when b.retVal < getdate() then day(getdate()) else 1 end as PM_Day,
		case when b.retSeq = 1 then 'OnPMSchedule' else 'Projected' end as CurrentStatus
 from (

	SELECT
	    sip.id as sip_id,
		ISNULL(sSite.Market__c, sIP.Market__c)  as Market,
		sPMSched.[SVMXC__Scheduled_On__c] as Next_PM,
		sPMDef.SVMXC__Frequency__c 
	FROM temporal.SVMXCInstalledProduct sIP
	  LEFT JOIN Temporal.SVMXCPMPlan sPMP on sPMP.smax_ps_single_installed_product__c = sIP.id and sPMP.svmxc__status__c = 'active'
	  LEFT JOIN Temporal.SVMXCPMScheduleDefinition sPMDef on sPMDef.svmxc__pm_plan__c = sPMP.id
	  LEFT JOIN Temporal.SVMXCPMSchedule sPMSched on sPMSched.svmxc__pm_plan__c = sPMP.id
	  LEFT JOIN Temporal.SVMXCSite sSite on sSite.id =  sip.SVMXC__Site__c
    WHERE sip.SVMXC__Status__c = 'Installed'
	  AND sip.name LIKE 'IP%'
	  AND sPMSched.[SVMXC__Scheduled_On__c] IS NOT NULL
	  AND sPMDef.SVMXC__Frequency__c IS NOT NULL) a

	-- NOTE:  this is hard coded to set look ahead window to one year (365 days) 
	--        adjust as desired
	Cross Apply [dbo].[udf-Range-Date](A.Next_PM,getdate()+730,'MM',A.SVMXC__Frequency__c) B
),
Open_PMs AS	-- identify current open PMs, change date to month and year, roll up any PMs with a preferred start time before date into today
(
	SELECT CASE
			WHEN SVMXC__Preferred_Start_Time__c < GETDATE()
			THEN MONTH(GETDATE())
			ELSE MONTH(SVMXC__Preferred_Start_Time__c) 
		END as PM_Month
		,CASE
			WHEN SVMXC__Preferred_Start_Time__c < GETDATE()
			THEN YEAR(GETDATE())
			ELSE YEAR(SVMXC__Preferred_Start_Time__c) 
		END as PM_Year
		,CASE
			WHEN SVMXC__Preferred_Start_Time__c < GETDATE()
			THEN DAY(GETDATE())
			ELSE 1 
		END as PM_Day
		,z.MSA_CSA__c as Market
		,CASE
			WHEN SVMXC__Order_Status__c = 'Scheduled'
			THEN 'Scheduled'
			ELSE 'Open'
		END as CurrentStatus
	FROM Temporal.SVMXCServiceOrder so
	LEFT JOIN Temporal.SVMXCSite ss on ss.Id = so.SVMXC__Site__c
	LEFT JOIN Temporal.QforceSite qs on qs.Id = ss.qSite__c
	LEFT JOIN Temporal.ZipCode z on z.Id = qs.zip_code__c


	WHERE SVMXC__Order_Type__c = 'PM' -- NOTE:  simplifieid where clause with same effective logic
	  AND SVMXC__Order_Status__c in ('Open'
									,'OS Warranty'
									,'Ready to Schedule'
									,'Reschedule'
									,'Scheduling Hold'
									,'Service Hold'
									,'Scheduled')  
	  AND SMAX_PS_Credit_Hold__c = 'No Hold'
 )

SELECT COUNT(*) as PMs
	, Market
	, PM_Month
	, PM_Year
	, PM_Day
	, CurrentStatus
FROM Sched_PMs
GROUP BY Market
	, PM_Month
	, PM_Year
	, PM_Day
	, CurrentStatus

UNION ALL -- add current backlog of PMs

SELECT COUNT(*) as PMs
	, Market
	, PM_Month
	, PM_Year
	, PM_Day
	, CurrentStatus
FROM Open_PMs
GROUP BY Market
	, PM_Month
	, PM_Year
	, PM_Day
	, CurrentStatus
