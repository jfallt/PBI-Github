# Query Documentation :open_book:

## Service_Data.pbix Queries :memo:

Each section below details each query used in the Service_Data.pbix file, with links to each query.

<details>
  <summary> Master Tables  </summary>
 
***
Used as the basis for a report or a way to link different tables together for filtering purposes to ensure the correct data is shown.

### Report Bases
* [master_MIF](https://github.com/jfallt/PBI-Github/blob/master/SQL%20Queries/Service%20Data/Master%20Tables/master_MIF.sql)
  * MIF or *Machines in Field*
* [master_SVMXC_Service_Order](https://github.com/jfallt/PBI-Github/blob/master/SQL%20Queries/Service%20Data/Master%20Tables/master_SVMXC_Service_Order.sql)
  * All ServiceMax service orders
  
 ### Master Filter Tables

* [master_account](https://github.com/jfallt/PBI-Github/blob/master/SQL%20Queries/Service%20Data/Master%20Tables/master_account.sql)
  * Only includes accounts with SVMXC service orders
* [master_filtration](https://github.com/jfallt/PBI-Github/blob/master/SQL%20Queries/Service%20Data/Master%20Tables/master_filtration.sql)
  * Distinct filters
  * Categorized by RO (*Reverse Osmosis*) or Standard
* [master_FSM_to_Market_Lookup](https://github.com/jfallt/PBI-Github/blob/master/SQL%20Queries/Service%20Data/Master%20Tables/master_FSM_to_Market_Lookup.sql)
  * Current Market assignments by FSM <Field Service Manager>
  * Used to tie different tables together by Market (i.e. master_SVMXC_Service_Order and master_MIF)
* [master_item](https://github.com/jfallt/PBI-Github/blob/master/SQL%20Queries/Service%20Data/Master%20Tables/master_item.sql)
  * Master Product List
  * Joined with Product2Master to consolidate similar products with different productIDs
* [master_location](https://github.com/jfallt/PBI-Github/blob/master/SQL%20Queries/Service%20Data/Master%20Tables/master_location.sql)
* [master_order_types](https://github.com/jfallt/PBI-Github/blob/master/SQL%20Queries/Service%20Data/Master%20Tables/master_order_types.sql)
  * All order types from SVMXC
* [master_productFamily](https://github.com/jfallt/PBI-Github/blob/master/SQL%20Queries/Service%20Data/Master%20Tables/master_productFamily.sql)
* [master_sales_reps](https://github.com/jfallt/PBI-Github/blob/master/SQL%20Queries/Service%20Data/Master%20Tables/master_sales_reps.sql)
  * Sales reps on SVMXC orders

</details>


<details>
  <summary> MIF  </summary>

* [MIF_Current_Installed_Products](https://github.com/jfallt/PBI-Github/blob/master/SQL%20Queries/Service%20Data/MIF/MIF_Current_Installed_Products.sql)
  * Not currently used for any reports
* [MIF_Historic](https://github.com/jfallt/PBI-Github/blob/master/SQL%20Queries/Service%20Data/MIF/MIF_Historic.sql)
  * Counts by Market, Product Family
* [MIF_Historic_PreConversion](https://github.com/jfallt/PBI-Github/blob/master/SQL%20Queries/Service%20Data/MIF/MIF_Historic_PreConversion.sql)
  * Counts by Market, Product Family
  * Combined with the query above in PBI for complete MIF history
</details>

<details>
  <summary> PMs  </summary>

* [wo_PM_backlog_dbo](https://github.com/jfallt/PBI-Github/blob/master/SQL%20Queries/Service%20Data/PMs/wo_PM_backlog_dbo.sql)
* [wo_PM_SVMXC_pm_backlog_count](https://github.com/jfallt/PBI-Github/blob/master/SQL%20Queries/Service%20Data/PMs/wo_SVMXC_pm_backlog_count.sql)
* [wo_PM_SVMXC_pm_on_breakfix](https://github.com/jfallt/PBI-Github/blob/master/SQL%20Queries/Service%20Data/PMs/wo_SVMXC_pm_on_breakfix.sql)
* [wo_PM_SVMXC_pm_creation_prediction](https://github.com/jfallt/PBI-Github/blob/master/SQL%20Queries/Service%20Data/PMs/wo_SVMXC_pm_creation_prediction.sql)
 

</details>


<details>
  <summary> Non PM Backlog  </summary>

***
  
Refers to any type of backlog that is not preventative maintenance such as installs, purchase installs, removals and repossessions.
* The following queries are all combined into one table in PBI but are run separately to reduce the load on the database.

***

* [wo_backlog_count_nonpm_dboHistory](https://github.com/jfallt/PBI-Github/blob/master/SQL%20Queries/Service%20Data/Non%20PM%20Backlog/wo_backlog_count_nonpm_dboHistory.sql)
  * Uses the dbo history table (for data before 2019/05/01)
 
### Install and Removal Backlogs

#### Install Types
* **Project**: work orders with a project name in the field *SMAX_PS_Project_Name__c.*
  * These are used for large installs for companies such as Wal-Mart or Amazon
* **Single**: All other types are denoted as "Single" Installs

<details>
  <summary> Availability  </summary>
  
***
  
**Table 1.** By Order Status

| Unavailable  | Available  |
| ------------- | ------------- |
| Parts Hold | On Site|
| Pending Equipment/Parts | Open |
| Supply Chain Hold | Ready to Schedule |
| Sales Hold | Reschedule |
| Pending Contractor | Scheduling Hold |
| OS Pending contractor (ETA) | Service Hold |
| OS Pending contractor (Paperwork) | |
| OS Hold for shipping ETA | |
| OS Warranty | |
| Customer Success Hold | |
| Customer Hold | |
| Credit Hold | |

</details>

---
##### Project Installs (and Purchase Installs)
* [wo_install_backlog_project_and_available](https://github.com/jfallt/PBI-Github/blob/master/SQL%20Queries/Service%20Data/Non%20PM%20Backlog/wo_install_backlog_project_and_available.sql)
* [wo_install_backlog_project_and_scheduled](https://github.com/jfallt/PBI-Github/blob/master/SQL%20Queries/Service%20Data/Non%20PM%20Backlog/wo_install_backlog_project_and_scheduled.sql)
* [wo_install_backlog_project_and_unavailable](https://github.com/jfallt/PBI-Github/blob/master/SQL%20Queries/Service%20Data/Non%20PM%20Backlog/wo_install_backlog_project_and_unavailable.sql)

##### Single Installs (and Purchase Installs)
* [wo_install_backlog_single_and_available](https://github.com/jfallt/PBI-Github/blob/master/SQL%20Queries/Service%20Data/Non%20PM%20Backlog/wo_install_backlog_single_and_available.sql)
* [wo_install_backlog_single_and_scheduled](https://github.com/jfallt/PBI-Github/blob/master/SQL%20Queries/Service%20Data/Non%20PM%20Backlog/wo_install_backlog_single_and_scheduled.sql)
* [wo_install_backlog_single_and_unavailable](https://github.com/jfallt/PBI-Github/blob/master/SQL%20Queries/Service%20Data/Non%20PM%20Backlog/wo_install_backlog_single_and_unavailable.sql)
---

##### Removal (and Reposession) Backlog
  * [wo_install_backlog_project_and_available](https://github.com/jfallt/PBI-Github/blob/master/SQL%20Queries/Service%20Data/Non%20PM%20Backlog/wo_removal_backlog_available.sql)
  * [wo_install_backlog_project_and_scheduled](https://github.com/jfallt/PBI-Github/blob/master/SQL%20Queries/Service%20Data/Non%20PM%20Backlog/wo_removal_backlog_scheduled.sql)
  * [wo_install_backlog_project_and_unavailable](https://github.com/jfallt/PBI-Github/blob/master/SQL%20Queries/Service%20Data/Non%20PM%20Backlog/wo_removal_backlog_unavailable.sql)
 

</details>



<details>
  <summary> WO Attributes  </summary>

* [wo_ftf_by_tech](https://github.com/jfallt/PBI-Github/blob/master/SQL%20Queries/Service%20Data/WO%20Attributes/wo_ftf_by_tech.sql)
* [wo_labor_days](https://github.com/jfallt/PBI-Github/blob/master/SQL%20Queries/Service%20Data/WO%20Attributes/wo_labor_days.sql)
* [wo_reschedules](https://github.com/jfallt/PBI-Github/blob/master/SQL%20Queries/Service%20Data/WO%20Attributes/wo_reschedules.sql)
* [wo_svmxc_order_history](https://github.com/jfallt/PBI-Github/blob/master/SQL%20Queries/Service%20Data/WO%20Attributes/wo_svmxc_order_history.sql)
* [wo_work_order_line](https://github.com/jfallt/PBI-Github/blob/master/SQL%20Queries/Service%20Data/WO%20Attributes/wo_work_order_line.sql)
 

</details>

<details>
  <summary> WO Lookup </summary>

* [wo_lookup_availability_and_group](https://github.com/jfallt/PBI-Github/blob/master/SQL%20Queries/Service%20Data/WO%20Lookup/wo_lookup_availability_and_group.sql)
  * Availability was [defined above](https://github.com/jfallt/PBI-Github/blob/master/Query_Documentation.md#install-types)
* [wo_lookup_pm_slas](https://github.com/jfallt/PBI-Github/blob/master/SQL%20Queries/Service%20Data/WO%20Lookup/wo_lookup_pm_slas.sql)
* [wo_lookup_problemcode_groups](https://github.com/jfallt/PBI-Github/blob/master/SQL%20Queries/Service%20Data/WO%20Lookup/wo_lookup_problemcode_groups.sql)
* [wo_lookup_rescode_groups](https://github.com/jfallt/PBI-Github/blob/master/SQL%20Queries/Service%20Data/WO%20Lookup/wo_lookup_rescode_groups.sql)
 

</details>
