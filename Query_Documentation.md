# Query Documentation :open_book:

<!-- START doctoc generated TOC please keep comment here to allow auto update -->
<!-- DON'T EDIT THIS SECTION, INSTEAD RE-RUN doctoc TO UPDATE -->
**Table of Contents**  *generated with [DocToc](https://github.com/thlorenz/doctoc)*

- [Definitions](#definitions)
  - [Install Types](#install-types)
    - [Order Availability :heavy_check_mark:](#order-availability-heavy_check_mark)
    - [Availability By Order Status](#availability-by-order-status)
  - [Abbreviations](#abbreviations)
    - [Basic Terms](#basic-terms)
    - [KPIs](#kpis)
    - [Time](#time)
- [Service_Data.pbix Queries :memo:](#service_datapbix-queries-memo)
  - [Master Tables](#master-tables)
    - [Report Bases](#report-bases)
    - [Master Filter Tables](#master-filter-tables)
  - [MIF](#mif)
  - [PMs](#pms)
  - [Non PM Backlog](#non-pm-backlog)
  - [WO Atttributes](#wo-atttributes)
  - [WO Lookup](#wo-lookup)

<!-- END doctoc generated TOC please keep comment here to allow auto update -->

## Service Definitions

The following definitions are used when defining queries for various purposes.

### Install Types
| Term  | Definition |
| ------| :---|
| Project |  Work orders with a project name in the column *SMAX_PS_Project_Name__c*. Used for large installs for companies such as Wal-Mart or Amazon
| Single |  All others are denoted as "Single" Installs |

#### Order Availability :heavy_check_mark:

<details>
  <summary> Definition Below  </summary>
  
***

Determines whether or not the work can be completed at this time. All scheduled work orders go in a separate bucket titled "Scheduled"
  
#### Availability By Order Status

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

### Abbreviations

<details>
  <summary> The table below details abbreviations, their full names and definitions used in Service Reporting  </summary>

#### Basic Terms

| Abbreviation  | Full Name | Definition  |
| ------------- | ------------- | ------------- |
| WO | Work Order |  |
| RMR | Recurring Monthly Revenue | Money received from machine rentals |
| MIF | Machines in Field | These are the products in the field. This definition varies by department. Finance defines as machines with RMR while service defines as machines with subscription type of maintenance or rental. |
| PM | Preventative Maintenace | Cleaning the machine and changing filters |
| NRU | Non-responding Unit | GPS tracking unit failures, tracked by fleet admin |

#### KPIs

| Abbreviation  | Full Name | Definition  |
| ------------- | ------------- | ------------- |
| FTF |  First Time Fix | Indicates the percentage of time a technician is able to fix the issue the first time, without need for additional expertise, information, or parts |
| FTI |  First Time Install | Same as above but for installations |
| OTR | On Time Rating | An order is considered completed on time if it resolved before or on the resolution customer by date. On Time Rating is the percentage of break fix calls completed on time |
| SLA | Service Level Agreement | These vary based on order type |

#### Time

| Abbreviation  | Full Name |
| ------------- | ------------- |
| TTM | Trailing 12 Months |
| EoP | End of Period |

</details>

## Service_Data.pbix Queries :memo:

Each section below details each query used in the Service_Data.pbix file, with links to each query.

### Master Tables

<details>
  <summary> Master Tables  </summary>
 
***
Used as the basis for a report or a way to link different tables together for filtering purposes to ensure the correct data is shown.

#### Report Bases
| Query | Definition  |
| ------------- | ------------- | 
| [master_MIF](https://github.com/jfallt/PBI-Github/blob/master/SQL%20Queries/Service%20Data/Master%20Tables/master_MIF.sql) | MIF or *Machines in Field* |
| [master_SVMXC_Service_Order](https://github.com/jfallt/PBI-Github/blob/master/SQL%20Queries/Service%20Data/Master%20Tables/master_SVMXC_Service_Order.sql) | All ServiceMax service orders |
  
 #### Master Filter Tables
| Query | Definition  |
| ------------- | ------------- | 
| [master_account](https://github.com/jfallt/PBI-Github/blob/master/SQL%20Queries/Service%20Data/Master%20Tables/master_account.sql)| Only includes accounts with SVMXC service orders
| [master_filtration](https://github.com/jfallt/PBI-Github/blob/master/SQL%20Queries/Service%20Data/Master%20Tables/master_filtration.sql) | Distinct filters, categorized by RO (*Reverse Osmosis*) or Standard |
| [master_FSM_to_Market_Lookup](https://github.com/jfallt/PBI-Github/blob/master/SQL%20Queries/Service%20Data/Master%20Tables/master_FSM_to_Market_Lookup.sql) | Current Market assignments by FSM <Field Service Manager>, Used to tie different tables together by Market (i.e. master_SVMXC_Service_Order and master_MIF) |
| [master_item](https://github.com/jfallt/PBI-Github/blob/master/SQL%20Queries/Service%20Data/Master%20Tables/master_item.sql) | Master Product List, joined with Product2Master to consolidate similar products with different productIDs |
| [master_location](https://github.com/jfallt/PBI-Github/blob/master/SQL%20Queries/Service%20Data/Master%20Tables/master_location.sql) | Zip codes with current MIF count, latitude and longitude for GIS reporting |
| [master_order_types](https://github.com/jfallt/PBI-Github/blob/master/SQL%20Queries/Service%20Data/Master%20Tables/master_order_types.sql)| All order types from SVMXC |
| [master_productFamily](https://github.com/jfallt/PBI-Github/blob/master/SQL%20Queries/Service%20Data/Master%20Tables/master_productFamily.sql)| Use to filter reports using multiple tables with product family data |
| [master_sales_reps](https://github.com/jfallt/PBI-Github/blob/master/SQL%20Queries/Service%20Data/Master%20Tables/master_sales_reps.sql)| Sales reps on SVMXC orders |

</details>

### MIF

<details>
  <summary> MIF  </summary>
  
| Query | Definition  |
| ------------- | ------------- | 
| [MIF_Current_Installed_Products](https://github.com/jfallt/PBI-Github/blob/master/SQL%20Queries/Service%20Data/MIF/MIF_Current_Installed_Products.sql) | Serial labels for installed products, mot currently used for any reports | 
| [MIF_Historic](https://github.com/jfallt/PBI-Github/blob/master/SQL%20Queries/Service%20Data/MIF/MIF_Historic.sql) | Counts by Market, Product Family | 
|  [MIF_Historic_PreConversion](https://github.com/jfallt/PBI-Github/blob/master/SQL%20Queries/Service%20Data/MIF/MIF_Historic_PreConversion.sql) | Counts by Market, Product Family, combined with the query above in PBI for complete MIF history | 
</details>

### PMs
<details>
  <summary> PMs  </summary>
  
| Query | Definition  |
| ------------- | ------------- | 
| [wo_PM_backlog_dbo](https://github.com/jfallt/PBI-Github/blob/master/SQL%20Queries/Service%20Data/PMs/wo_PM_backlog_dbo.sql) | PM backlog from 2/28/2018 to 3/31/19, combined with query below in PBI for complete backlog history |
| [wo_PM_SVMXC_pm_backlog_count](https://github.com/jfallt/PBI-Github/blob/master/SQL%20Queries/Service%20Data/PMs/wo_SVMXC_pm_backlog_count.sql) | Backlog from 4/30/19 to Date |
| [wo_PM_SVMXC_pm_on_breakfix](https://github.com/jfallt/PBI-Github/blob/master/SQL%20Queries/Service%20Data/PMs/wo_SVMXC_pm_on_breakfix.sql) | WO Ids for breakfix pm counter resets (i.e. filter changes on breakfix) |
| [wo_PM_SVMXC_pm_creation_prediction](https://github.com/jfallt/PBI-Github/blob/master/SQL%20Queries/Service%20Data/PMs/wo_SVMXC_pm_creation_prediction.sql) | Shows current backlog, future PMs opening and projected PMs based on the date and frequency on each installed product |
 

</details>

### Non PM Backlog

<details>
  <summary> Non PM Backlog  </summary>

***
  
Refers to backlog of installs, purchase installs, removals and repossessions.

* [Non PM Backlog](https://github.com/jfallt/Quench_PowerBI_Reporting/blob/master/SQL%20Queries/Service%20Data/Non%20PM%20Backlog/wo_nonpm_backlog.sql)

</details>

### WO Atttributes

<details>
  <summary> WO Attributes  </summary>

***

1. These are complex and cannot be determined by calculated columns within PBI
1. Each attribute has its own query
1. Each query has its own set of parameters defined below
1. All abbreviations are defined above

* [wo_ftf_by_tech](https://github.com/jfallt/PBI-Github/blob/master/SQL%20Queries/Service%20Data/WO%20Attributes/wo_ftf_by_tech.sql)
  * When a technician selected "Additional Work Required", this query pulls the first row containing the following:
      * Resolution Code
      * Technician
      * Time
* [wo_labor_days](https://github.com/jfallt/PBI-Github/blob/master/SQL%20Queries/Service%20Data/WO%20Attributes/wo_labor_days.sql)
  * Uses labor transactions as another way to determine if a work order was an FTF (i.e. 2 visits is not an FTF)
* [wo_reschedules](https://github.com/jfallt/PBI-Github/blob/master/SQL%20Queries/Service%20Data/WO%20Attributes/wo_reschedules.sql)
  * Identify distinct scheduled dates (anything with 2 or more has n - 1 reschedules)
  * First scheduled date
  * Final scheduled date
* [wo_svmxc_order_history](https://github.com/jfallt/PBI-Github/blob/master/SQL%20Queries/Service%20Data/WO%20Attributes/wo_svmxc_order_history.sql)
  * Time in status
  * Used for Install SLA times
  * This is a part of the Temporal.SVMXCServiceOrder table but is pulled in separately to filter cancelled work orders to reduce data load
* [wo_work_order_line](https://github.com/jfallt/PBI-Github/blob/master/SQL%20Queries/Service%20Data/WO%20Attributes/wo_work_order_line.sql)
  * Aggregates cost by category
    * Parts
    * Tubing
    * Machines
    * Labor
    * Filters

</details>

### WO Lookup

<details>
  <summary> WO Lookup </summary>

* [wo_lookup_availability_and_group](https://github.com/jfallt/PBI-Github/blob/master/SQL%20Queries/Service%20Data/WO%20Lookup/wo_lookup_availability_and_group.sql)
  * Availability was [defined above](https://github.com/jfallt/PBI-Github/blob/master/Query_Documentation.md#install-types)
* [wo_lookup_pm_slas](https://github.com/jfallt/PBI-Github/blob/master/SQL%20Queries/Service%20Data/WO%20Lookup/wo_lookup_pm_slas.sql)
* [wo_lookup_problemcode_groups](https://github.com/jfallt/PBI-Github/blob/master/SQL%20Queries/Service%20Data/WO%20Lookup/wo_lookup_problemcode_groups.sql)
* [wo_lookup_rescode_groups](https://github.com/jfallt/PBI-Github/blob/master/SQL%20Queries/Service%20Data/WO%20Lookup/wo_lookup_rescode_groups.sql)
 
 </details>
 
 ## Collections Definitions

## zuora_data.pbix memo:

Each section below details each query used in the Service_Data.pbix file, with links to each query.


| Query | Definition  |
| ------------- | ------------- | 
| [zuora_collections](https://github.com/jfallt/Quench_PowerBI_Reporting/blob/master/SQL%20Queries/Zuora%20Data/zuora_collections.sql) | pulls current state of invoices, assigns an aging bucket based on due date and determines if an invoice will roll during the quarter |

