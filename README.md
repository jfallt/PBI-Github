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

![](https://exceleratorbi.com.au/wp-content/uploads/2018/06/image_thumb.png)

#### Key Differences
* "Golden Datasets" are housed in GitHub using LFS instead of onedrive
* Only one appspace is used with different reports stemming from the data model

</details>
