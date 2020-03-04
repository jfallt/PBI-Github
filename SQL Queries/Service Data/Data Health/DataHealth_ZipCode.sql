/* Identify zip codes in ROW markets with non-ROW submarkets */
SELECT zc.Name as ZipCode
	,MSA_CSA__c as Market
	,Submarket__c as Submarket
	,zc.Region__c as Region
	,sg.Name as Technician
	,zc.City__c as City
	,zc.State__c as State
FROM Temporal.ZipCode zc
	LEFT JOIN Temporal.SVMXCServiceGroupMembers sg on sg.Id = zc.Technician__c
WHERE MSA_CSA__c = 'ROW'
	AND Submarket__c NOT IN ('Canada', 'NULL', 'San Juan, PR', 'OutSourced', 'ROW')

/* Identify zip codes in markets without assigned submarkets, excluding ROW & Outsourced*/
SELECT zc.Name as ZipCode
	,MSA_CSA__c as Market
	,sg.Name as Technician
	,zc.Region__c as Region
	,zc.City__c as City
	,zc.State__c as State
FROM Temporal.ZipCode zc
	LEFT JOIN Temporal.SVMXCServiceGroupMembers sg on sg.Id = zc.Technician__c
WHERE Submarket__c IS NULL
	AND MSA_CSA__c NOT IN ('ROW', 'Outsourced')


/* Identify zip codes in markets with incorrectly assigned regions using FSM to Market query*/
DROP TABLE IF EXISTS #FSMs
DROP TABLE IF EXISTS #FSM2
DROP TABLE IF EXISTS #Region

CREATE TABLE #FSMs
	(
		Service_Member_Name VARCHAR(100),
		Region VARCHAR(100)
	)

INSERT INTO #FSMs (Service_Member_Name, Region) VALUES ('Negron, Waldy ', 'NE'), ('Marte, Jose ', 'NE')
														, ('Delucia, Rich', 'NE'), ('Braverman, Curt', 'NE')
														, ('Hanks, Dale', 'SE'), ('Killingsworth, Daren', 'SE')
														, ('Jones, Alicia', 'SE'),('Parker, Alan', 'SE')
														, ('Kern, Thomas', 'SE'), ('Hliwski, Steve', 'NE')
														, ('Hopkins, Toby', 'SE'), ('Lloyd, Keith', 'SE')
														, ('Curiel, Julio', 'C'), ('Weisenberger, Steve', 'C')
														, ('Mendez, Mario', 'C'), ('Linville, Daryl', 'C')
														, ('Perez, Arthur', 'C'), ('Healy, Jason', 'C')
														, ('Smith, Ricky', 'C'), ('Esparza, Eris', 'W')
														, ('Open_FSM', 'W'), ('Harber, James', 'W')
														, ('Duenas, Atilio', 'W'), ('Gonzales, Rudy', 'W')
														, ('Lewis, Rick', 'W')
CREATE TABLE #Region
	(
		Region_Key VARCHAR(100),
		Region VARCHAR(100)
	)

INSERT INTO #Region (Region_Key, Region) VALUES ('NE', 'Northeast'), ('SE', 'Southeast'), ('C', 'Central'), ('W', 'West')
														

SELECT *, IDENTITY (int, 1,1) AS id
INTO #FSM2
FROM #FSMs

;WITH Markets AS

(
	SELECT DISTINCT
	[MSA_CSA__c] as 'Market'
	FROM [Temporal].[ZipCode]
),

FSMtoMarket AS

(
	SELECT
		CASE
			WHEN Market = 'Manhattan, NY'
			THEN (SELECT Service_Member_Name FROM #FSM2 WHERE id = 1)
			WHEN Market IN ('Outer Boroughs, NY', 'White Plains, NY', 'Trenton, NJ')
			THEN (SELECT Service_Member_Name FROM #FSM2 WHERE id = 2)
			WHEN Market IN ('Boston-Cambridge -NH-VT-ME')
			THEN (SELECT Service_Member_Name FROM #FSM2 WHERE id = 3)
			WHEN Market IN ('Boston Suburbs-West-RI', 'Hartford, CT', 'Syracuse, NY')
			THEN (SELECT Service_Member_Name FROM #FSM2 WHERE id = 4)
			WHEN Market IN ('Los Angeles - Orange County', 'San Diego - Bakersfield - Inland Empire')
			THEN (SELECT Service_Member_Name FROM #FSM2 WHERE id = 20)
			WHEN Market IN ('Phoenix, AZ', 'Denver, CO', 'Tucson, AZ')
			THEN (SELECT Service_Member_Name FROM #FSM2 WHERE id = 22)
			WHEN Market IN ('Las Vegas, NV', 'Portland, OR', 'Seattle, WA', 'Las Vegas,NV')
			THEN (SELECT Service_Member_Name FROM #FSM2 WHERE id = 24)
			WHEN Market = 'San Francisco, CA'
			THEN (SELECT Service_Member_Name FROM #FSM2 WHERE id = 23)
			WHEN Market IN ('Washington, DC', 'Baltimore, MD', 'Alexandria, VA')
			THEN (SELECT Service_Member_Name FROM #FSM2 WHERE id = 7)
			WHEN Market = 'Atlanta, GA'
			THEN (SELECT Service_Member_Name FROM #FSM2 WHERE id = 12)
			WHEN Market = 'Raleigh, NC'
			THEN (SELECT Service_Member_Name FROM #FSM2 WHERE id = 8)
			WHEN Market IN ('Tampa, FL', 'Jacksonville, FL', 'Orlando, FL','Fort Myers, FL', 'Ft Myers')
			THEN (SELECT Service_Member_Name FROM #FSM2 WHERE id = 5)
			WHEN Market = 'Miami, FL'
			THEN (SELECT Service_Member_Name FROM #FSM2 WHERE id = 9)
			WHEN Market IN ('Philadelphia, PA', 'Wilmington, DE')
			THEN (SELECT Service_Member_Name FROM #FSM2 WHERE id = 10)
			WHEN Market IN ('Detroit, MI', 'Pittsburgh, PA', 'Cincinnati, OH', 'Cleveland, OH', 'Columbus, OH', 'Dayton, OH')
			THEN (SELECT Service_Member_Name FROM #FSM2 WHERE id = 14)
			WHEN Market IN ('Chicago, IL', 'Milwaukee, WI')
			THEN (SELECT Service_Member_Name FROM #FSM2 WHERE id = 15)
			WHEN Market IN ('Birmingham, AL', 'Nashville, TN', 'Memphis, TN', 'New Orleans, LA')
			THEN (SELECT Service_Member_Name FROM #FSM2 WHERE id = 19)
			WHEN Market IN ('Indianapolis, IN', 'Louisville, KY', 'Kansas City, MO', 'Minneapolis, MN', 'St. Louis, MO')
			THEN (SELECT Service_Member_Name FROM #FSM2 WHERE id = 16)
			WHEN Market IN ('Houston, TX')
			THEN (SELECT Service_Member_Name FROM #FSM2 WHERE id = 17)
			WHEN Market IN ('Austin, TX', 'San Antonio, TX', 'El Paso, TX', 'St. Louis, MO')
			THEN (SELECT Service_Member_Name FROM #FSM2 WHERE id = 18)
			WHEN Market IN ('Dallas, TX', 'Oklahoma City, OK')
			THEN (SELECT Service_Member_Name FROM #FSM2 WHERE id = 13)
			WHEN Market = 'Salt Lake City, UT'
			THEN (SELECT Service_Member_Name FROM #FSM2 WHERE id = 25)
			WHEN Market IN ('Charlotte, NC', 'Richmond, VA', 'Virginia Beach, VA', 'Hilton Head, SC')
			THEN (SELECT Service_Member_Name FROM #FSM2 WHERE id = 11)
			WHEN Market IN ('Augusta, GA', 'Savannah, GA', 'Macon, GA')
			THEN (SELECT Service_Member_Name FROM #FSM2 WHERE id = 6)
			WHEN Market IN ('ROW', 'Outsourced')
			THEN 'N/A'
			ELSE 'Needs Assignment'
			END as 'FSM',
		Market
	FROM Markets
),

FSM_Final AS
(
SELECT FSM
	,CONCAT(Market, ISNULL(r.Region, 'ROW')) as MarketRegion
	,Market
	,r.Region
FROM FSMtoMarket f2m
LEFT JOIN #FSM2 f on f.Service_Member_Name = f2m.FSM
LEFT JOIN #Region r on r.Region_Key = f.Region
)

SELECT z.Name as ZipCode
	,z.State__c as State
	,z.MSA_CSA__c as Market
	,z.Region__c as Assigned_Region
	,f2.Region as Correct_Region
FROM Temporal.ZipCode z
LEFT JOIN FSM_Final f on f.MarketRegion = CONCAT(z.MSA_CSA__c, z.Region__c)
LEFT JOIN FSM_Final f2 on f2.Market = z.MSA_CSA__c
WHERE MSA_CSA__c NOT IN ('ROW', 'Outsourced')
AND f.MarketRegion IS NULL