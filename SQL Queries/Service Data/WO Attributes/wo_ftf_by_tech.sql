/*******************************************************
Purpose: Identify when work orders are not FTFs
    (First Time Fixes)
How: Find all instances a tech changes the field
status to "Additional Work Required"
********************************************************/

select id,
	   StatusChange,
       ResCode,
       --field_status__c,
       GroupMemberID
from (-- self explanatory
      select row_number() over(partition by id, field_status__c order by StatusChange) as rn,
             *
      from (-- take care of any null technician values by using our previously calculated leads and lags
            select StatusChange,
                   id,
                   ResCode,
                   field_status__c,
                --    last_GroupMemberID,
                --    last_GroupMemberID2,
                --    next_GroupMemberID,
                   coalesce(GroupMemberID, last_GroupMemberID, last_GroupMemberID2, next_GroupMemberID) as GroupMemberID
            from (-- start by grabbing the last 2, and the next tech to fill in the blanks where necessary
                  -- since we're looking for additional work required state-changes, we can ignore all "complete" and "cancel" versions
                  -- we can likewise ignore all records with a "completed" field status, but we need to keep the nulls for our leads and lags to work
                  select versionstarttime as StatusChange,
                         id,
                         isNull(Resolution_Code__c, 'No ResCode')  as ResCode,
                         isNull(field_status__c, 'F') as field_status__c,
                         SVMXC__Group_Member__c  as GroupMemberID,
                         lag(SVMXC__Group_Member__c) over (partition by id order by VersionStartTime) as last_GroupMemberID,
                         lag(SVMXC__Group_Member__c, 2) over (partition by id order by VersionStartTime) as last_GroupMemberID2,
                         lead(SVMXC__Group_Member__c) over (partition by id order by VersionStartTime) as next_GroupMemberID
                  from Reporting.svmxcServiceOrder_HistoryAbridged
                  where SVMXC__Order_Status__c not in ('cancel', 'complete')
                    and isNull(field_status__C, 'F') <> 'Completed'
            ) open_wo
      ) a 
-- where field_status__c = 'Additional Work Required'
) a
where rn = 1
  and field_status__c = 'Additional Work Required''