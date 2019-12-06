# PowerBI Version Control :tada:

<!-- START doctoc generated TOC please keep comment here to allow auto update -->
<!-- DON'T EDIT THIS SECTION, INSTEAD RE-RUN doctoc TO UPDATE -->
**Table of Contents**  *generated with [DocToc](https://github.com/thlorenz/doctoc)*

- [Overview](#overview)
  - [Goals of this repository](#goals-of-this-repository)
  - [Datasets and Query Details](#datasets-and-query-details)
  - [Golden Dataset Methodology](#golden-dataset-methodology)
    - [Golden Dataset Diagram](#golden-dataset-diagram)

<!-- END doctoc generated TOC please keep comment here to allow auto update -->

## Overview

### Goals of this repository

* Allow testing of new features and changes to data model without disrupting current reports
* Documentation on all changes
* Scalability
* Cross department communication

### Datasets and Query Details
* Service_Data
  * Main data model, feeds most of the reports in the Service Analytics app
* Labor_Compliance
  * Estimates hours worked per day based on gps trip data
* Fleet Data
  * efleet data
  * telogis (gps telematics data)
* [Query Details](https://github.com/jfallt/PBI-Github/blob/master/Query_Documentation.md)


### Golden Dataset Methodology

* The Service Analytics PBI environment uses a modified version of the [golden dataset](https://exceleratorbi.com.au/new-power-bi-reports-golden-dataset/)
* Version history, commentary, and documentation are captured in this github repository
* Additions, updates (optimizations etc.), and changes require a new branch and approval
* .pbix files are re-published to web after branch is merged

#### Golden Dataset Diagram
<details>
  <summary> Golden Dataset Diagram  </summary>

![](https://github.com/jfallt/PBI-Github/blob/master/Golden_Dataset_Git_Workflow.png)

</details>
