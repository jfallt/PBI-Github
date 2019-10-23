WITH RelativeAsOfTable AS
(SELECT * FROM
(
SELECT CAST(GETDATE() as DATE) as 'DateCheck0'
	,EOMONTH(GETDATE(), -1) as 'DateCheck1'
	,EOMONTH(GETDATE(), -2) as 'DateCheck2'
	,EOMONTH(GETDATE(), -3) as 'DateCheck3'
	,EOMONTH(GETDATE(), -4) as 'DateCheck4'
	,EOMONTH(GETDATE(), -5) as 'DateCheck5'
	,EOMONTH(GETDATE(), -6) as 'DateCheck6'
	,EOMONTH(GETDATE(), -7) as 'DateCheck7'
	,EOMONTH(GETDATE(), -8) as 'DateCheck8'
	,EOMONTH(GETDATE(), -9) as 'DateCheck9'
	,EOMONTH(GETDATE(), -10) as 'DateCheck10'
	,EOMONTH(GETDATE(), -11) as 'DateCheck11'
	,EOMONTH(GETDATE(), -12) as 'DateCheck12'
) a
UNPIVOT
		(
		AsOfDate FOR DateCheck IN (DateCheck0, DateCheck1, DateCheck2, DateCheck3, DateCheck4, DateCheck5, DateCheck6
								  ,DateCheck7, DateCheck8, DateCheck9, DateCheck10, DateCheck11, DateCheck12)
		) pvt1
),

PMChangeDueDate AS
(

SELECT DISTINCT s.SVMXC__Order_Type__c
		,SVMXC__Site__c
		,VersionStartTime
		,VersionEndTime
		, CASE
		WHEN [qSLA_Package__c] LIKE '%Platinum%'
		THEN DATEADD(DAY, 30, CAST(SVMXC__Preferred_Start_Time__c as DATE))
		WHEN [qSLA_Package__c] LIKE '%Silver%'
		THEN DATEADD(DAY, 90, CAST(SVMXC__Preferred_Start_Time__c as DATE))
		WHEN [qSLA_Package__c] LIKE '%Bronze%'
		THEN DATEADD(DAY, 90, CAST(SVMXC__Preferred_Start_Time__c as DATE))
		WHEN [qSLA_Package__c] LIKE '%Food%'
		THEN DATEADD(DAY, 30, CAST(SVMXC__Preferred_Start_Time__c as DATE))
		ELSE DATEADD(DAY, 60, CAST(SVMXC__Preferred_Start_Time__c as DATE))
		END as SLA
	FROM [Temporal].[SVMXCServiceOrder] FOR SYSTEM_TIME ALL s
	CROSS APPLY RelativeAsOfTable rt
	WHERE s.SVMXC__Order_Type__c IN ('PM', 'Routine')
	AND s.SVMXC__Order_Status__c IN ('Open'
									,'OS Warranty'
									,'Ready to Schedule'
									,'Reschedule'
									,'Scheduling Hold'
									,'Service Hold')
	AND s.VersionStartTime < rt.AsOfDate
	AND s.VersionEndTime > rt.AsOfDate
	AND SMAX_PS_Credit_Hold__c = 'No Hold'
),

PMBacklogCalc AS
(
SELECT *
		,CASE WHEN versionStartTime <= GETDATE()  AND VersionEndTime > GETDATE() AND SLA >= GETDATE()
			THEN 1 ELSE NULL END as 'DateCheck0'

		,CASE WHEN versionStartTime <= EOMONTH(GETDATE(), -1)  AND VersionEndTime > EOMONTH(GETDATE(), -1) AND SLA >= EOMONTH(GETDATE(), -1)
			THEN 1 ELSE NULL END as 'DateCheck1'
	
		,CASE WHEN versionStartTime <= EOMONTH(GETDATE(), -2)  AND VersionEndTime > EOMONTH(GETDATE(), -2) AND SLA >= EOMONTH(GETDATE(), -2)
			THEN 1 ELSE NULL END as 'DateCheck2'

		,CASE WHEN versionStartTime <= EOMONTH(GETDATE(), -3)  AND VersionEndTime > EOMONTH(GETDATE(), -3) AND SLA >= EOMONTH(GETDATE(), -3)
			THEN 1 ELSE NULL END as 'DateCheck3'

		,CASE WHEN versionStartTime <= EOMONTH(GETDATE(), -4)  AND VersionEndTime > EOMONTH(GETDATE(), -4) AND SLA >= EOMONTH(GETDATE(), -4)
			THEN 1 ELSE NULL END as 'DateCheck4'

		,CASE WHEN versionStartTime <= EOMONTH(GETDATE(), -5)  AND VersionEndTime > EOMONTH(GETDATE(), -5) AND SLA >= EOMONTH(GETDATE(), -5)
			THEN 1 ELSE NULL END as 'DateCheck5'
	
		,CASE WHEN versionStartTime <= EOMONTH(GETDATE(), -6)  AND VersionEndTime > EOMONTH(GETDATE(), -6) AND SLA >= EOMONTH(GETDATE(), -6)
			THEN 1 ELSE NULL END as 'DateCheck6'

		,CASE WHEN versionStartTime <= EOMONTH(GETDATE(), -7)  AND VersionEndTime > EOMONTH(GETDATE(), -7) AND SLA >= EOMONTH(GETDATE(), -7)
			THEN 1 ELSE NULL END as 'DateCheck7'

		,CASE WHEN versionStartTime <= EOMONTH(GETDATE(), -8)  AND VersionEndTime > EOMONTH(GETDATE(), -8) AND SLA >= EOMONTH(GETDATE(), -8)
			THEN 1 ELSE NULL END as 'DateCheck8'

		,CASE WHEN versionStartTime <= EOMONTH(GETDATE(), -9)  AND VersionEndTime > EOMONTH(GETDATE(), -9) AND SLA >= EOMONTH(GETDATE(), -9)
			THEN 1 ELSE NULL END as 'DateCheck9'
	
		,CASE WHEN versionStartTime <= EOMONTH(GETDATE(), -10)  AND VersionEndTime > EOMONTH(GETDATE(), -10) AND SLA >= EOMONTH(GETDATE(), -10)
			THEN 1 ELSE NULL END as 'DateCheck10'

		,CASE WHEN versionStartTime <= EOMONTH(GETDATE(), -11)  AND VersionEndTime > EOMONTH(GETDATE(), -11) AND SLA >= EOMONTH(GETDATE(), -11)
			THEN 1 ELSE NULL END as 'DateCheck11'

		,CASE WHEN versionStartTime <= EOMONTH(GETDATE(), -12)  AND VersionEndTime > EOMONTH(GETDATE(), -12) AND SLA >= EOMONTH(GETDATE(), -12)
			THEN 1 ELSE NULL END as 'DateCheck12'
FROM PMChangeDueDate
),

PM_Unpivot AS
(
	SELECT SVMXC__Site__c
		, RecordCount
		, DateCheck
	FROM PMBacklogCalc

	UNPIVOT
		(
		RecordCount FOR DateCheck IN (
										DateCheck0 ,DateCheck1 ,DateCheck2 ,DateCheck3 ,DateCheck4 ,DateCheck5 ,DateCheck6
									   ,DateCheck7 ,DateCheck8 ,DateCheck9 ,DateCheck10 ,DateCheck11 ,DateCheck12
									 )
		) pvt2
),

SiteTemp AS
(
	SELECT ss.id, z.MSA_CSA__c
	FROM [Temporal].[SVMXCSite] ss
	LEFT JOIN [Temporal].[QforceSite] q on q.Id = ss.qSite__c
	LEFT JOIN [Temporal].[ZipCode] z on z.[Id] = q.zip_code__c
)

SELECT st.MSA_CSA__c as Market
	,COUNT(RecordCount) as RecordCount
	,AsOfDate as AsOf
FROM PM_Unpivot i
LEFT JOIN RelativeAsOfTable rt on rt.DateCheck = i.DateCheck
LEFT JOIN SiteTemp st on st.id = i.SVMXC__Site__c
WHERE i.DateCheck IS NOT NULL
GROUP BY st.MSA_CSA__c
	,AsOfDate
