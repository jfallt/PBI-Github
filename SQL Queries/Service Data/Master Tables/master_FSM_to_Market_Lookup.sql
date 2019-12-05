DROP TABLE IF EXISTS #FSMs
DROP TABLE IF EXISTS #FSM2
DROP TABLE IF EXISTS #Region

CREATE TABLE #FSMs
	(
		Service_Member_Name VARCHAR(100),
		Region VARCHAR(100)
	)

INSERT INTO #FSMs (Service_Member_Name, Region) VALUES ('Waldy Negron', 'NE'), ('Jose Marte', 'NE')
														, ('Rich Delucia', 'NE'), ('Curt Braverman', 'NE')
														, ('Dale Hanks', 'SE'), ('Daren Killingsworth', 'SE')
														, ('Alicia Jones', 'SE'),('Alan Parker', 'SE')
														, ('Thomas Kern', 'SE'), ('Steve Hliwski', 'SE')
														, ('Toby Hopkins', 'SE'), ('Keith Lloyd', 'SE')
														, ('Julio Curiel', 'C'), ('Steve Weisenberger', 'C')
														, ('Mario Mendez', 'C'), ('Daryl Linville', 'C')
														, ('Arthur Perez', 'C'), ('Jason Healy', 'C')
														, ('Ricky Smith', 'C'), ('Eris Esparza', 'W')
														, ('Andrea De La Cruz', 'W'), ('James Harber', 'W')
														, ('Atilio Duenas', 'W'), ('Rudy Gonzales', 'W')
														, ('Fabian Lopez', 'W')
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
			WHEN Market IN ('Boston Suburbs-West-RI', 'Hartford, CT')
			THEN (SELECT Service_Member_Name FROM #FSM2 WHERE id = 4)
			WHEN Market = 'Los Angeles - Orange County'
			THEN (SELECT Service_Member_Name FROM #FSM2 WHERE id = 20)
			WHEN Market = 'San Diego - Bakersfield - Inland Empire'
			THEN (SELECT Service_Member_Name FROM #FSM2 WHERE id = 21)
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
			WHEN Market IN ('Detroit, MI', 'Syracuse, NY', 'Pittsburgh, PA', 'Cincinnati, OH', 'Cleveland, OH', 'Columbus, OH', 'Dayton, OH')
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
)

SELECT FSM
	,Market
	,ISNULL(r.Region, 'ROW') as Region
FROM FSMtoMarket f2m
LEFT JOIN #FSM2 f on f.Service_Member_Name = f2m.FSM
LEFT JOIN #Region r on r.Region_Key = f.Region

