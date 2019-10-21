SELECT id, StatusChange, ResCode, GroupMemberID
FROM
(
SELECT id
	,DATEADD(hour, -4, VersionStartTime) as StatusChange
	,ISNULL(Resolution_Code__c, 'No ResCode')  as ResCode
	,SVMXC__Group_Member__c  as GroupMemberID
	,ROW_NUMBER() OVER(PARTITION BY id, Resolution_Code__c ORDER BY id, VersionStartTime) as rownum
FROM TemporalHistory.SVMXCServiceOrder
WHERE Field_Status__c = 'Additional Work Required'
AND Resolution_Code__c NOT IN ('No Problem Found', 'Equip - Replaced Filters', 'Equip - Swapped Unit', 'Tstat/solenoid - Replace')
) a
WHERE rownum = 1

UNION ALL

SELECT id, StatusChange, ResCode, GroupMemberID
FROM
(
SELECT id
	,VersionStartTime as StatusChange
	,ISNULL(Resolution_Code__c, 'No ResCode')  as ResCode
	,SVMXC__Group_Member__c  as GroupMemberID
	, ROW_NUMBER() OVER(PARTITION BY id, Resolution_Code__c ORDER BY id, VersionStartTime) as rownum
FROM swo_history
WHERE Field_Status__c = 'Additional Work Required'
AND VersionStartTime <= '2019-04-05 16:17:42'
AND Resolution_Code__c NOT IN ('No Problem Found', 'Equip - Replaced Filters', 'Equip - Swapped Unit', 'Tstat/solenoid - Replace')
) a
WHERE rownum = 1