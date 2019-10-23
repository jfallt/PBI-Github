# PowerBI Version Control :tada:

## Overview

### Goals of this repository

* Allow testing of new features and changes to data model without disrupting current reports
* Documentation on all changes
* Scalability
* Cross department communication

### File and Query Detail
* Service_Data.pbix
  * Main data model, feeds most of the reports in the Service Analytics app
* Labor_Compliance.pbix
  * Estimates hours worked per day based on gps trip data
* [Query Details](https://github.com/jfallt/PBI-Github/blob/master/Query_Documentation.md)


### Golden Dataset Methodology

* The Service Analytics PBI environment uses a modified version of the [golden dataset](https://exceleratorbi.com.au/new-power-bi-reports-golden-dataset/)
* Version history, commentary, and documentation are captured in this github repository
* Additions, Updates (optimizations etc.), and changes require a new branch and approval
* .pbix files are re-published to web after branch is merged

<details>
  <summary> Golden Dataset Diagram  </summary>

![](https://github.com/jfallt/PBI-Github/blob/master/Golden_Dataset_Git_Workflow.png)

</details>
