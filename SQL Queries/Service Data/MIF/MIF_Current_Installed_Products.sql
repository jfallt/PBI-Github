SELECT sip.id as sip_id
	,ISNULL(sSite.Market__c, sIP.Market__c) as Market
	,ISNULL(sSite.SVMXC__State__c, sIP.SVMXC__State__c) as [State]
	,sPMSched.SVMXC__Scheduled_On__c AT TIME ZONE 'UTC' AT TIME ZONE 'Eastern Standard Time' as Next_PM
	,sPMDef.SVMXC__Frequency__c as PM_frequency
	,sip.SVMXC__Product__c as ProductID
	,sip.SVMX_PS_Q_Number_Short__c as QNumber
	,CAST(sip.SVMXC__Date_Installed__c  AT TIME ZONE 'UTC' AT TIME ZONE 'Eastern Standard Time' as DATE) as InstallDate
FROM temporal.SVMXCInstalledProduct sIP
	LEFT JOIN Temporal.SVMXCPMPlan sPMP on sPMP.smax_ps_single_installed_product__c = sIP.id and sPMP.svmxc__status__c = 'active'
	LEFT JOIN Temporal.SVMXCPMScheduleDefinition sPMDef on sPMDef.svmxc__pm_plan__c = sPMP.id
	LEFT JOIN Temporal.SVMXCPMSchedule sPMSched on sPMSched.svmxc__pm_plan__c = sPMP.id
	LEFT JOIN Temporal.SVMXCSite sSite on sSite.id =  sip.SVMXC__Site__c
WHERE sip.SVMXC__Status__c = 'Installed'
	AND sip.name LIKE 'IP%'