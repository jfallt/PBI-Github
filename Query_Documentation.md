# Query Table of Contents

<details>
  <summary> Master Tables  </summary>

* [master_account](https://github.com/jfallt/PBI-Github/blob/master/SQL%20Queries/Service%20Data/Master%20Tables/master_account.sql)
  * Only includes accounts with SVMXC service orders
* [master_filtration](https://github.com/jfallt/PBI-Github/blob/master/SQL%20Queries/Service%20Data/Master%20Tables/master_filtration.sql)
  * Distinct filters
  * Categorized by RO (*Reverse Osmosis*) or Standard
* [master_FSM_to_Market_Lookup](https://github.com/jfallt/PBI-Github/blob/master/SQL%20Queries/Service%20Data/Master%20Tables/master_FSM_to_Market_Lookup.sql)
  * Current Market assignments by FSM <Field Service Manager>
* [master_item](https://github.com/jfallt/PBI-Github/blob/master/SQL%20Queries/Service%20Data/Master%20Tables/master_item.sql)
  * Master Product List
  * Joined with Product2Master to consolidate similar products
* [master_location](https://github.com/jfallt/PBI-Github/blob/master/SQL%20Queries/Service%20Data/Master%20Tables/master_location.sql)
* [master_MIF](https://github.com/jfallt/PBI-Github/blob/master/SQL%20Queries/Service%20Data/Master%20Tables/master_MIF.sql)
  * MIF or *Machines in Field*
* [master_order_types](https://github.com/jfallt/PBI-Github/blob/master/SQL%20Queries/Service%20Data/Master%20Tables/master_order_types.sql)
  * All order types from SVMXC
* [master_productFamily](https://github.com/jfallt/PBI-Github/blob/master/SQL%20Queries/Service%20Data/Master%20Tables/master_productFamily.sql)
* [master_sales_reps](https://github.com/jfallt/PBI-Github/blob/master/SQL%20Queries/Service%20Data/Master%20Tables/master_sales_reps.sql)
  * Sales reps on SVMXC orders
* [master_SVMXC_Service_Order](https://github.com/jfallt/PBI-Github/blob/master/SQL%20Queries/Service%20Data/Master%20Tables/master_SVMXC_Service_Order.sql)
</details>


<details>
  <summary> MIF  </summary>

* [MIF_Current_Installed_Products](https://github.com/jfallt/PBI-Github/blob/master/SQL%20Queries/Service%20Data/MIF/MIF_Current_Installed_Products.sql)
* [MIF_Historic](https://github.com/jfallt/PBI-Github/blob/master/SQL%20Queries/Service%20Data/MIF/MIF_Historic.sql)
* [MIF_Historic_PreConversion](https://github.com/jfallt/PBI-Github/blob/master/SQL%20Queries/Service%20Data/MIF/MIF_Historic_PreConversion.sql)
</details>

<details>
  <summary> Non PM Backlog  </summary>

* [wo_backlog_count_nonpm_dboHistory](https://github.com/jfallt/PBI-Github/blob/master/SQL%20Queries/Service%20Data/Non%20PM%20Backlog/wo_backlog_count_nonpm_dboHistory.sql)
* Install Backlog
  * **Project**: work orders with a project name in the field *SMAX_PS_Project_Name__c.*
  * These are used for large installs for companies such as Wal-Mart or Amazon
    * [wo_install_backlog_project_and_available](https://github.com/jfallt/PBI-Github/blob/master/SQL%20Queries/Service%20Data/Non%20PM%20Backlog/wo_install_backlog_project_and_available.sql)
    * [wo_install_backlog_project_and_scheduled](https://github.com/jfallt/PBI-Github/blob/master/SQL%20Queries/Service%20Data/Non%20PM%20Backlog/wo_install_backlog_project_and_scheduled.sql)
    * [wo_install_backlog_project_and_unavailable](https://github.com/jfallt/PBI-Github/blob/master/SQL%20Queries/Service%20Data/Non%20PM%20Backlog/wo_install_backlog_project_and_unavailable.sql)
    * [wo_install_backlog_single_and_available](https://github.com/jfallt/PBI-Github/blob/master/SQL%20Queries/Service%20Data/Non%20PM%20Backlog/wo_install_backlog_single_and_available.sql)
    * [wo_install_backlog_single_and_scheduled](https://github.com/jfallt/PBI-Github/blob/master/SQL%20Queries/Service%20Data/Non%20PM%20Backlog/wo_install_backlog_single_and_scheduled.sql)
    * [wo_install_backlog_single_and_unavailable](https://github.com/jfallt/PBI-Github/blob/master/SQL%20Queries/Service%20Data/Non%20PM%20Backlog/wo_install_backlog_single_and_unavailable.sql)
---
* Removal Backlog
  * [wo_install_backlog_project_and_available](https://github.com/jfallt/PBI-Github/blob/master/SQL%20Queries/Service%20Data/Non%20PM%20Backlog/wo_removal_backlog_available.sql)
  * [wo_install_backlog_project_and_scheduled](https://github.com/jfallt/PBI-Github/blob/master/SQL%20Queries/Service%20Data/Non%20PM%20Backlog/wo_removal_backlog_scheduled.sql)
  * [wo_install_backlog_project_and_unavailable](https://github.com/jfallt/PBI-Github/blob/master/SQL%20Queries/Service%20Data/Non%20PM%20Backlog/wo_removal_backlog_unavailable.sql)
 

</details>

<details>
  <summary> PMs  </summary>

* [wo_PM_backlog_dbo](https://github.com/jfallt/PBI-Github/blob/master/SQL%20Queries/Service%20Data/PMs/wo_PM_backlog_dbo.sql)
* [wo_PM_SVMXC_pm_backlog_count](https://github.com/jfallt/PBI-Github/blob/master/SQL%20Queries/Service%20Data/PMs/wo_SVMXC_pm_backlog_count.sql)
* [wo_PM_SVMXC_pm_on_breakfix](https://github.com/jfallt/PBI-Github/blob/master/SQL%20Queries/Service%20Data/PMs/wo_SVMXC_pm_on_breakfix.sql)
* [wo_PM_SVMXC_pm_creation_prediction](https://github.com/jfallt/PBI-Github/blob/master/SQL%20Queries/Service%20Data/PMs/wo_SVMXC_pm_creation_prediction.sql)
 

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
* [wo_lookup_pm_slas](https://github.com/jfallt/PBI-Github/blob/master/SQL%20Queries/Service%20Data/WO%20Lookup/wo_lookup_pm_slas.sql)
* [wo_lookup_problemcode_groups](https://github.com/jfallt/PBI-Github/blob/master/SQL%20Queries/Service%20Data/WO%20Lookup/wo_lookup_problemcode_groups.sql)
* [wo_lookup_rescode_groups](https://github.com/jfallt/PBI-Github/blob/master/SQL%20Queries/Service%20Data/WO%20Lookup/wo_lookup_rescode_groups.sql)
 

</details>
