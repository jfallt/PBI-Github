/* Find Last PM Date For All Installed Products */
/*DROP TABLE IF EXISTS #wos

SELECT MAX(SVMXC__Actual_Resolution__c) as last_pm
    ,SVMXC__Component__c
into #wos
FROM Temporal.SVMXCServiceOrder
WHERE SVMXC__Order_Type__c in ('PM','PM TNM', 'Routine')
    OR (Resolution_Code__c = 'Equip - Changed Filters')
GROUP BY SVMXC__Component__c*/

/* Find all Installed Products without a maintenance agreement */
SELECT /*sip.id as sip_id
	--,CAST(sPMSched.SVMXC__Scheduled_On__c AT TIME ZONE 'UTC' AT TIME ZONE 'Eastern Standard Time' as DATE) as Next_PM
	--,sPMDef.SVMXC__Frequency__c as PM_frequency
	,sip.Name as sIP
	,p2.Name as Product
    ,p2.Family as Family
	,sip.SVMX_PS_Q_Number_Short__c as QNumber
	,CAST(sip.SVMXC__Date_Installed__c  AT TIME ZONE 'UTC' AT TIME ZONE 'Eastern Standard Time' as DATE) as InstallDate
	/*,ISNULL(sSite.SVMXC__City__c, sIP.SVMXC__City__c) as City
	,ISNULL(sSite.Market__c, sIP.Market__c) as Market
	,ISNULL(sSite.SVMXC__State__c, sIP.SVMXC__State__c) as [State] Removed 2/7/20 in favor of zip id*/
	--,qSite.zip_code__c as zip_id 
	,CONCAT('https://quench.my.salesforce.com/', sip.id) as link
	--,ssite.SVMXC__Account__c as account_id
    ,ssite.Name as Site
    ,ssite.SVMXC__Street__c as Street
	,qfe.Entitlement_Template__c as Entitlement
   -- ,last_pm
	--,qs.* */
	COUNT(*)
	,Is_Active__c
FROM temporal.SVMXCInstalledProduct sIP
	LEFT JOIN Temporal.SVMXCPMPlan sPMP on sPMP.smax_ps_single_installed_product__c = sIP.id and sPMP.svmxc__status__c = 'active'
	LEFT JOIN Temporal.SVMXCPMScheduleDefinition sPMDef on sPMDef.svmxc__pm_plan__c = sPMP.id
	LEFT JOIN Temporal.SVMXCPMSchedule sPMSched on sPMSched.svmxc__pm_plan__c = sPMP.id
	LEFT JOIN Temporal.SVMXCSite sSite on sSite.id =  sip.SVMXC__Site__c
	LEFT JOIN Temporal.qforceSite qSite on qSite.id = sSite.qSite__c
	LEFT JOIN Temporal.qForceFUSSInstalledProduct qip on qip.id = sip.qforce_installedproduct_c_id_extId__c
	LEFT JOIN Temporal.QforceMasterSubscription qs on qs.id = qip.Subscription__c
	LEFT JOIN Temporal.QforceEntitlement qfe on qfe.id = qs.Entitlement__c
   -- LEFT JOIN #wos w on w.SVMXC__Component__c = sIP.id
    INNER JOIN Product2 p2 on p2.id = sip.SVMXC__Product__c
    INNER JOIN Temporal.Account a on a.id = ssite.SVMXC__Account__c 
WHERE sip.SVMXC__Status__c = 'Installed'
	AND sip.name LIKE 'IP%'
    AND sPMP.Name IS NULL
GROUP BY Is_Active__c
	--AND Is_Active__c = 1
    --AND last_pm IS NOT NULL
	--AND qs.Subscription_Type__c NOT IN ('Rental', 'Maintenance')
	--AND qfe.Entitlement_Template__c NOT IN ('')
	--AND CAST(sPMSched.SVMXC__Scheduled_On__c AT TIME ZONE 'UTC' AT TIME ZONE 'Eastern Standard Time' as DATE) IS NOT NULL