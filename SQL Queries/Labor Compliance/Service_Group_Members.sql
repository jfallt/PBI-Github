-- Create a temporary table to create records that do not exists in SVMXCServiceGroupMembers ----
-- This data is needed to combine with data from Verizon (Telogis) ------------------------------

DROP TABLE IF EXISTS #TechManualAdd

CREATE TABLE #TechManualAdd
	(
		Service_Member_Name VARCHAR(100)
	)

INSERT INTO #TechManualAdd (Service_Member_Name) VALUES ('Huling, Alexander'), ('Charette, David')
														, ('Duley, Paula'), ('Dreagon, Philip')
														, ('Sinclair, Rob'), ('Sanchez, Rudy')
														, ('Martell, Sean'),('Amaral, Steve')
														, ('Yoders, Todd'), ('Pierce, Tom')
														, ('Sagram, Vasant'), ('Fallt, Jared')
														, ('Turano, Chris')

SELECT s.Name as Service_Member_Name
	,ISNULL(s.SVMXC__Email__c,
    REPLACE(
		LOWER(
			CONCAT(
				TRIM(SUBSTRING(s.Name
							,LEN(LEFT(s.Name, CHARINDEX(',', s.Name))) + 1, 2) -- first letter of first name
					)
					,LEFT(s.Name, (CHARINDEX(',', s.Name))) -- last name
					,'quenchonline.com' -- email address
					)
			)
			, ',', '@')) as Service_Member_Email -- replace comma with @ for email format
	,s.SVMXC__Role__c as Role
	,s.Hire_Date__c as Hire_Date
	,s.Region__c as Region
	,s.Service_Market__c as Service_Market
	,s.Shed__c as Shed_ID
	,s.Vehicle__c as Vehicle_ID
	,ISNULL(m.Name, 'Turano, Chris') as 'Manager Name'
	,ISNULL(m.SVMXC__Email__c, 'cturano@quenchonline.com') as 'Manager E-Mail'
	,ISNULL(m.SVMXC__Role__c, 'Senior VP of Service') as 'Manager Role'
FROM Temporal.SVMXCServiceGroupMembers s
LEFT JOIN Temporal.SVMXCServiceGroupMembers m on m.Id = s.Manager__c
WHERE s.Name NOT IN ('Ashley Test Tech', 'Northeast Outsourced Technician', 'Southeast Outsourced Technician'
					,'Central Outsourced Technician', 'West Outsourced Technician')

UNION ALL

SELECT Service_Member_Name
	,CONCAT(
	LOWER(
	LEFT(
	SUBSTRING(Service_Member_Name, CASE CHARINDEX(',', Service_Member_Name)
            WHEN 0
                THEN LEN(Service_Member_Name) + 1
            ELSE CHARINDEX(',', Service_Member_Name) + 1
            END, 1000), 2)),
	LOWER(
	SUBSTRING(Service_Member_Name, 1, CASE CHARINDEX(',', Service_Member_Name)
            WHEN 0
                THEN LEN(Service_Member_Name)
            ELSE CHARINDEX(',', Service_Member_Name) - 1
            END)),
    '@quenchonline.com') as Service_Member_Email
	,null  as Role
	,null as Hire_Date
	,null as Region
	,null as Service_Market
	,null as Shed_ID
	,null as Vehicle_ID
	,null as 'Manager Name'
	,null as 'Manager E-Mail'
	,null as 'Manager Role'
FROM #TechManualAdd