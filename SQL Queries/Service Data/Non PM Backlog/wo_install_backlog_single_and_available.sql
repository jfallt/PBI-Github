WITH RelativeAsOfTable AS
(SELECT * FROM
(
SELECT EOMONTH(GETDATE(), -1) as 'DateCheck1'
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
		AsOfDate FOR DateCheck IN (DateCheck1, DateCheck2, DateCheck3, DateCheck4, DateCheck5, DateCheck6
								  ,DateCheck7, DateCheck8, DateCheck9, DateCheck10, DateCheck11, DateCheck12)
		) pvt1
),

AssignInstallTypeAndAvailability AS
(
SELECT id
		,s.SVMXC__Order_Type__c
		,SVMXC__Site__c
		,VersionStartTime
		,VersionEndTime
	FROM [Temporal].[SVMXCServiceOrder] FOR SYSTEM_TIME ALL s
	CROSS APPLY RelativeAsOfTable rt
	WHERE s.SVMXC__Order_Type__c IN ('Install', 'Purchase Install')
	AND s.SVMXC__Order_Status__c IN ('Parts Hold'
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
	AND s.VersionStartTime < rt.AsOfDate
	AND s.VersionEndTime > rt.AsOfDate
	AND SMAX_PS_Project_Name__c IS NULL
	AND SMAX_PS_Credit_Hold__c = 'No Hold'
),

SingleAndAvailable AS

(SELECT DISTINCT id
	,SVMXC__Site__c
	,SVMXC__Order_Type__c

,CASE WHEN a.versionStartTime <= EOMONTH(GETDATE(), -1)  AND a.VersionEndTime > EOMONTH(GETDATE(), -1)
	THEN 1 ELSE NULL END as 'DateCheck1'

,CASE WHEN a.versionStartTime <= EOMONTH(GETDATE(), -2)  AND a.VersionEndTime > EOMONTH(GETDATE(), -2)
	THEN 1 ELSE NULL END as 'DateCheck2'

,CASE WHEN a.versionStartTime <= EOMONTH(GETDATE(), -3)  AND a.VersionEndTime > EOMONTH(GETDATE(), -3)
	THEN 1 ELSE NULL END as 'DateCheck3'

,CASE WHEN a.versionStartTime <= EOMONTH(GETDATE(), -4)  AND a.VersionEndTime > EOMONTH(GETDATE(), -4)
	THEN 1 ELSE NULL END as 'DateCheck4'

,CASE WHEN a.versionStartTime <= EOMONTH(GETDATE(), -5)  AND a.VersionEndTime > EOMONTH(GETDATE(), -5)
	THEN 1 ELSE NULL END as 'DateCheck5'

,CASE WHEN a.versionStartTime <= EOMONTH(GETDATE(), -6)  AND a.VersionEndTime > EOMONTH(GETDATE(), -6)
	THEN 1 ELSE NULL END as 'DateCheck6'

,CASE WHEN a.versionStartTime <= EOMONTH(GETDATE(), -7)  AND a.VersionEndTime > EOMONTH(GETDATE(), -7)
	THEN 1 ELSE NULL END as 'DateCheck7'

,CASE WHEN a.versionStartTime <= EOMONTH(GETDATE(), -8)  AND a.VersionEndTime > EOMONTH(GETDATE(), -8)
	THEN 1 ELSE NULL END as 'DateCheck8'

,CASE WHEN a.versionStartTime <= EOMONTH(GETDATE(), -9)  AND a.VersionEndTime > EOMONTH(GETDATE(), -9)
	THEN 1 ELSE NULL END as 'DateCheck9'

,CASE WHEN a.versionStartTime <= EOMONTH(GETDATE(), -10)  AND a.VersionEndTime > EOMONTH(GETDATE(), -10)
	THEN 1 ELSE NULL END as 'DateCheck10'

,CASE WHEN a.versionStartTime <= EOMONTH(GETDATE(), -11)  AND a.VersionEndTime > EOMONTH(GETDATE(), -11)
	THEN 1 ELSE NULL END as 'DateCheck11'

,CASE WHEN a.versionStartTime <= EOMONTH(GETDATE(), -12)  AND a.VersionEndTime > EOMONTH(GETDATE(), -12)
	THEN 1 ELSE NULL END as 'DateCheck12'

FROM AssignInstallTypeAndAvailability a
)
,


Install_Unpivot AS
(
	SELECT SVMXC__Order_Type__c
		,SVMXC__Site__c
		, RecordCount
		, DateCheck
	FROM SingleAndAvailable

	UNPIVOT
		(
		RecordCount FOR DateCheck IN (
										DateCheck1 ,DateCheck2 ,DateCheck3 ,DateCheck4 ,DateCheck5 ,DateCheck6
									   ,DateCheck7 ,DateCheck8 ,DateCheck9 ,DateCheck10 ,DateCheck11 ,DateCheck12
									 )
		) pvt2
),

SiteTemp AS
(
	SELECT ss.Id, z.MSA_CSA__c
	FROM [Temporal].[SVMXCSite] ss
	LEFT JOIN [Temporal].[QforceSite] q on q.Id = ss.qSite__c
	LEFT JOIN [Temporal].[ZipCode] z on z.[Id] = q.zip_code__c
)

SELECT SVMXC__Order_Type__c as OrderType
	,st.MSA_CSA__c as Market
	,'Available' as [Availability]
	,'Single' as InstallType
	,COUNT(RecordCount) as RecordCount
	,AsOfDate as AsOf
FROM Install_Unpivot i
LEFT JOIN RelativeAsOfTable rt on rt.DateCheck = i.DateCheck
LEFT JOIN SiteTemp st on st.id = i.SVMXC__Site__c
WHERE i.DateCheck IS NOT NULL
GROUP BY SVMXC__Order_Type__c
	,st.MSA_CSA__c
	,AsOfDate
