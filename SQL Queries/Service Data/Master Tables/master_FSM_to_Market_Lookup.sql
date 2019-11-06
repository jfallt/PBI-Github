WITH Markets AS

(
	SELECT DISTINCT
	[MSA_CSA__c] as 'Market'
	FROM [Source].[Zip_Code__c]
),

FSMtoMarket AS

(
	SELECT
		CASE
			WHEN Market = 'Manhattan, NY'
			THEN 'Waldy Negron'

			WHEN Market IN ('Outer Boroughs, NY', 'White Plains, NY', 'Trenton, NJ')
			THEN 'Jose Ventura'

			WHEN Market IN ('Boston-Cambridge-NH-VT')
			THEN 'Rich Delucia'

			WHEN Market IN ('Boston Suburbs-West-RI', 'Hartford, CT')
			THEN 'Curt Braverman'

			WHEN Market = 'Los Angeles – Orange County'
			THEN 'Eris Esparza'

			WHEN Market = 'San Diego- Bakersfield – Inland Empire'
			THEN 'Andrea De La Cruz'

			WHEN Market IN ('Phoenix, AZ', 'Denver, CO', 'Tucson, AZ')
			THEN 'James Harber'

			WHEN Market IN ('Las Vegas, NV', 'Portland, OR', 'Seattle, WA', 'Las Vegas,NV')
			THEN 'Rudy Gonzales'

			WHEN Market = 'San Francisco, CA'
			THEN 'Atilio Duenas'

			WHEN Market IN ('Washington, DC', 'Baltimore, MD', 'Alexandria, VA')
			THEN 'Alicia Jones'

			WHEN Market = 'Atlanta, GA'
			THEN 'Keith Lloyd'

			WHEN Market = 'Raleigh, NC'
			THEN 'Alan Parker'

			WHEN Market IN ('Tampa, FL', 'Jacksonville, FL', 'Orlando, FL','Fort Myers, FL', 'Ft Myers')
			THEN 'Dale Hanks'
			
			WHEN Market = 'Miami, FL'
			THEN 'Thomas Kern'

			WHEN Market IN ('Philadelphia, PA', 'Wilmington, DE')
			THEN 'Steve Hliwski'

			WHEN Market IN ('Detroit, MI', 'Syracuse, NY', 'Pittsburgh, PA', 'Cincinnati, OH', 'Cleveland, OH', 'Columbus, OH', 'Dayton, OH')
			THEN 'Steve Weisenberger'

			WHEN Market IN ('Chicago, IL', 'Milwaukee, WI')
			THEN 'Mario Mendez'

			WHEN Market IN ('Birmingham, AL', 'Nashville, TN', 'Memphis, TN', 'New Orleans, LA')
			THEN 'Ricky Smith'

			WHEN Market IN ('Indianapolis, IN', 'Louisville, KY', 'Kansas City, MO', 'Minneapolis, MN', 'St. Louis, MO')
			THEN 'Daryl Linville'

			WHEN Market IN ('Houston, TX')
			THEN 'Arthur Perez'

			WHEN Market IN ('Austin, TX', 'San Antonio, TX', 'El Paso, TX', 'St. Louis, MO')
			THEN 'Jason Healy'

			WHEN Market IN ('Dallas, TX', 'Oklahoma City, OK')
			THEN 'Julio Curiel'

			WHEN Market = 'Salt Lake City, UT'
			THEN 'Fabian Lopez'

			WHEN Market IN ('Charlotte, NC', 'Richmond, VA', 'Virginia Beach, VA', 'Hilton Head, SC')
			THEN 'Toby Hopkins'

			WHEN Market IN ('Augusta, GA', 'Savannah, GA', 'Macon, GA')
			THEN 'Daren Killingsworth '

			WHEN Market IN ('ROW', 'Outsourced')
			THEN 'N/A'

			ELSE 'Needs Assignment'
			END as 'FSM',
		Market
	FROM Markets
),

FSMtoRegion AS
(
SELECT
*,
CASE
	WHEN FSM IN('Daryl Linville', 'Jason Healy', 'Julio Curiel', 'Mario Mendez', 'Ricky Smith', 'Steve Weisenberger', 'Arthur Perez')
	THEN 'Central'

	WHEN FSM IN('Curt Braverman', 'Rich Delucia', 'Jose Ventura', 'Waldy Negron')
	THEN 'Northeast'

	WHEN FSM IN('Alan Parker', 'Alicia Jones', 'Thomas Kern', 'Daren Killingsworth', 'Keith Lloyd', 'Steve Hliwski', 'Toby Hopkins', 'Dale Hanks')
	THEN 'Southeast'

	WHEN FSM IN('Andrea De La Cruz', 'Eris Esparza', 'Atilio Duenas', 'Fabian Lopez', 'James Harber', 'Rudy Gonzales', 'Toby Hopkins')
	THEN 'West'

	ELSE 'ROW'
	END as 'Region'
FROM FSMtoMarket
)

SELECT * FROM FSMtoRegion
ORDER BY Market
