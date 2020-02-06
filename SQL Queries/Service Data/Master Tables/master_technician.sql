DROP TABLE IF EXISTS #TechManualAdd

CREATE TABLE #TechManualAdd (id varchar (MAX)
							,Name varchar (MAX)
							,Role varchar (MAX)
							,Region varchar (MAX)
							,Market varchar (MAX)
							,Inventory_City varchar (MAX)
							,Inventory_State varchar (MAX)
							,Active varchar (MAX)
							,Hire_Date varchar (MAX)
							,Email varchar (MAX)
							,Manager varchar (MAX))

INSERT INTO #TechManualAdd
VALUES ('a', 'Abbott, Francis', 'Technician', 'Southeast', 'Philadelphia, PA', 'King of Prussia', 'PA', 0, CAST('2012-12-17' AS DATE), 'fabbott@quenchonline.com', NULL)
	  ,('b', 'Beecher, Cody', 'Technician', 'Central', 'Oklahoma City, OK', NULL, NULL, 0, CAST('2015-09-02' AS DATE), 'cbeecher@quenchonline.com', NULL)
	  ,('c', 'Brown, Anthony', 'Technician', 'Central', 'Dallas, TX', NULL, NULL, 0, CAST('2017-05-06' AS DATE), 'abrown@quenchonline.com', NULL)
	  ,('d', 'Buchanan, Mark', 'Technician', 'Northeast', 'Boston, MA', NULL, NULL, 0, CAST('2015-08-06' AS DATE), 'mbuchanan@quenchonline.com', NULL)
	  ,('e', 'Cassidy, Steven', 'FIELD SERVICE MANAGER',	'Southeast', 'Baltimore, MD', NULL, NULL, 0, CAST('2016-11-16' AS DATE), 'scassidy@quenchonline.com', NULL)
	  ,('f', 'Cosma, Peter',	'TECHNICIAN', 'Central', 'Detroit, MI', NULL, NULL, 0,	CAST('2009-10-19' AS DATE),	'pcosma@quenchonline.com', NULL)
	  ,('g', 'COUEPEL, John',	'TECHNICIAN','Northeast', 'Boston, MA', NULL, NULL, 0,	CAST('2002-12-27' AS DATE),	'jcouepel@quenchonline.com', NULL)
	  ,('h', 'Danielson, Jonathan',	'TECHNICIAN',	'West',	'Los Angeles � Orange County', NULL, NULL, 0, CAST('2016-11-10' AS DATE), 'jdanielson@quenchonline.com', NULL)
	  ,('i', 'Demers, Richard',	'TECHNICIAN',	'Northeast', 'Boston, MA', NULL, NULL, 0, CAST('2015-06-29' AS DATE), 'rdemers@quenchonline.com', NULL)
	  ,('j', 'Duley, Paula',	'TECHNICIAN', 'Southeast', 'Baltimore, MD', NULL, NULL, 0, CAST('2000-06-16' AS DATE), 'pduley@quenchonline.com', NULL)
	  ,('k', 'Eggleston, Christopher', 'FIELD SERVICE MANAGER', 'Southeast', 'Baltimore, MD', NULL, NULL, 0, CAST('2013-04-29' AS DATE), 'ceggleston@quenchonline.com', NULL)
	  ,('l', 'Farrow, Duane', 'TECHNICIAN', 'Southeast', 'Washington, DC', NULL, NULL, 0, CAST('2014-06-02' AS DATE), 'dfarrow@quenchonline.com', NULL)
	  ,('m', 'Foxworth, Jake', 'TECHNICIAN', 'West',	'Seattle, WA', NULL, NULL, 0, CAST('2016-10-10' AS DATE), 'jfoxworth@quenchonline.com', NULL)
	  ,('n', 'Franco, Peter',	'TECHNICIAN', 'Northeast', 'Manhattan, NY', NULL, NULL, 0, CAST('2015-08-10' AS DATE), 'pfranco@quenchonline.com', NULL)
	  ,('o', 'Herr, Casey',	'TECHNICIAN', 'Central', 'Indianapolis, IN', NULL, NULL, 0,	CAST('2008-05-27' AS DATE),	'cherr@quenchonline.com', NULL)
	  ,('p', 'Hooks, Keith',	'TECHNICIAN', 'Southeast', 'Philadelphia, PA', NULL, NULL, 0, CAST('2015-04-28' AS DATE),	'khooks@quenchonline.com', NULL)
	  ,('q', 'Hughes Jr, James', 'TECHNICIAN', 'Southeast', 'Savannah, GA', NULL, NULL, 0,	CAST('2013-03-04' AS DATE),	'jhughes@quenchonline.com', NULL)
	  ,('r', 'John, ERIC',	'TECHNICIAN',	'Southeast',	'Atlanta, GA', NULL, NULL, 0, CAST('2010-10-11' AS DATE),	'ejohn@quenchonline.com', NULL)
	  ,('s', 'JONES, Benjamin',	'TECHNICIAN',	'Southeast',	'Washington, DC', NULL, NULL, 0, CAST('2017-02-20' AS DATE),	'bajones@quenchonline.com', NULL)
	  ,('t', 'MAHER, Kevin',	'TECHNICIAN',	'Southeast',	'Jacksonville, FL', NULL, NULL, 0, CAST('2013-08-26' AS DATE),	'kmaher@quenchonline.com', NULL)
	  ,('u', 'Martell, Sean',	'TECHNICIAN',	'Northeast',	'Boston, MA', NULL, NULL, 0, CAST('2015-03-16' AS DATE), 'smartell@quenchonline.com', NULL)
	  ,('v', 'McDermott, Michael',	'TECHNICIAN',	'Southeast',	'Virginia Beach, VA', NULL, NULL, 0, CAST('2015-10-05' AS DATE), 'mmcdermott@quenchonline.com', NULL)
	  ,('w', 'Mensah, Martin', 'TECHNICIAN',	'West',	'San Francisco, CA', NULL, NULL, 0, CAST('2017-05-03' AS DATE),	'mmensah@quenchonline.com', NULL)
	  ,('x', 'Morris, Chancey', 'TECHNICIAN',	'West',	'Phoenix, AZ', NULL, NULL, 0, CAST('2017-04-12' AS DATE), 'cmorris@quenchonline.com', NULL)
	  ,('y', 'Mosley, Norman', 'FIELD SERVICE MANAGER',	'Southeast', 'Charlotte, NC', NULL, NULL, 0, CAST('2012-11-01' AS DATE),	'nmosley@quenchonline.com', NULL)
	  ,('z', 'Paulemon, Mike', 'TECHNICIAN',	'Northeast',	'Manhattan, NY', NULL, NULL, 0, CAST('2013-07-01' AS DATE), 'mpaulemon@quenchonline.com', NULL)
	  ,('aa', 'Pentico, Anthony', 'TECHNICIAN',	'West',	'San Francisco, CA', NULL, NULL, 0, CAST('2013-12-09' AS DATE), 'apentico@quenchonline.com', NULL)
	  ,('ab', 'Pierce, Thomas', 'TECHNICIAN',	'Northeast',	'Trenton, NJ', NULL, NULL, 0, CAST('2017-05-15' AS DATE),	'tpierce@quenchonline.com', NULL)
	  ,('ac', 'Powell, Chardae', 'TECHNICIAN',	'Southeast',	'Philadelphia, PA', NULL, NULL, 0, CAST('2016-06-20' AS DATE), 'cpowell@quenchonline.com', NULL)
	  ,('ad', 'Powell, DeSean', 'TECHNICIAN', 'Central', 'Detroit, MI', NULL, NULL, 0,	CAST('2017-01-23' AS DATE),	'dxpowell@quenchonline.com', NULL)
	  ,('ae', 'Rivard, Christopher', 'TECHNICIAN',	'Southeast',	'Washington, DC', NULL, NULL, 0,	CAST('2015-11-02' AS DATE),	'crivard@quenchonline.com', NULL)
	  ,('af', 'Rivera, Marcos', 'TECHNICIAN', 'West',	'San Diego- Bakersfield � Inland Empire', NULL, NULL, 0,	CAST('2016-03-07' AS DATE),	'mrivera@quenchonline.com', NULL)
	  ,('ag', 'Robertson, Michael', 'TECHNICIAN',	'West',	'Phoenix, AZ', NULL, NULL, 0, CAST('2016-09-27' AS DATE),	'mrobertson@quenchonline.com', NULL)
	  ,('ah', 'Rodriguez, Airon',	'TECHNICIAN',	'Northeast',	'Manhattan, NY', NULL, NULL, 0, CAST('2016-10-03' AS DATE),	'arodriguez@quenchonline.com', NULL)
	  ,('ai', 'Rodriguez, Manuel',	'TECHNICIAN',	'Southeast',	'Orlando, FL', NULL, NULL, 0, CAST('2016-04-18' AS DATE),	'mrodriguez@quenchonline.com', NULL)
	  ,('aj', 'Ruiz, Michael',	'TECHNICIAN',	'Central',	'Houston, TX', NULL, NULL, 0, CAST('2014-12-01' AS DATE),	'mruiz@quenchonline.com', NULL)
	  ,('ak', 'Rzeczkowski, Jaroslaw',	'TECHNICIAN',	'Northeast', 'Trenton, NJ', NULL, NULL, 0, CAST('2017-06-21' AS DATE),	'jrzeczkowski@quenchonline.com', NULL)
	  ,('al', 'Sagram, Vasant', 'TECHNICIAN',	'Northeast',	'Outer Boroughs, NY', NULL, NULL, 0, CAST('2015-06-08' AS DATE),	'vsagram@quenchonline.com', NULL)
	  ,('am', 'Sanchez, Lenin', 'TECHNICIAN', 'Northeast', 'Boston, MA', NULL, NULL, 0, CAST('2015-07-13' AS DATE),	'rsanchez@quenchonline.com', NULL)
	  ,('an', 'Scott, Justin', 'TECHNICIAN',	'Central',	'Cincinnati, OH', NULL, NULL, 0, CAST('2016-09-01' AS DATE),	'jscott@quenchonline.com', NULL)
	  ,('ao', 'Spears, Julian',	'TECHNICIAN',	'West',	'San Francisco, CA', NULL, NULL, 0,	CAST('2017-02-01' AS DATE),	'jspears@quenchonline.com', NULL)
	  ,('ap', 'Taylor, Benjamin', 'TECHNICIAN',	'Central',	'Louisville, KY', NULL, NULL, 0, CAST('2011-09-21' AS DATE),	'btaylor@QUENCHONLINE.COM', NULL)
	  ,('aq', 'Totah, Khalil',	'TECHNICIAN',	'West',	'San Francisco, CA', NULL, NULL, 0,	CAST('2017-02-07' AS DATE),	'ktotah@quenchonline.com', NULL)
	  ,('ar', 'Westmoreland, Jason',	'TECHNICIAN',	'Central',	'Birmingham, AL', NULL, NULL, 0, CAST('2016-08-08' AS DATE),	'jwestmoreland@quenchonline.com', NULL)
	  ,('as', 'Yoders, Todd',	'TECHNICIAN',	'Central',	'Nashville, TN', NULL, NULL, 0, CAST('2015-04-27' AS DATE),	'tyoders@quenchonline.com', NULL)
	  ,('at', 'Zanin, Jean',	'TECHNICIAN',	'Central',	'Chicago, IL', NULL, NULL, 0, CAST('2015-09-14' AS DATE), 'jzanin@quenchonline.com', NULL)

;WITH Markets AS
( SELECT DISTINCT MSA_CSA__c FROM temporal.ZipCode)


SELECT m.id
	,m.[Name]
	,m.[SVMXC__Role__c] as 'Role'
	,m.[Region__c] as 'Region'
	,CASE 
		WHEN m.Service_Market__c = mt.MSA_CSA__c								THEN mt.MSA_CSA__c
		WHEN m.[Service_Market__c] LIKE '%San D%'								THEN 'San Diego - Bakersfield - Inland Empire'
		WHEN m.[Service_Market__c] LIKE '%Los An%'								THEN 'Los Angeles - Orange County'
		WHEN m.[Service_Market__c] LIKE '%Boston-C%'							THEN 'Boston-Cambridge -NH-VT-ME'
		WHEN q.Name = 'DeLucia, Rich'											THEN 'Boston-Cambridge -NH-VT-ME'
		WHEN q.Name = 'Braverman, Curt' AND m.Service_Market__c = 'Boston, MA'	THEN 'Boston Suburbs-West-RI'
		WHEN q.Name = 'Howe, Will'												THEN 'Boston-Cambridge -NH-VT-ME'
		WHEN q.Name = 'Campbell, Ed'											THEN 'Boston-Cambridge -NH-VT-ME'
		WHEN q.Name = 'Negron, Waldy'											THEN 'Manhattan, NY'
		WHEN m.[SVMXC__Role__c] LIKE '%Region%'									THEN 'Quench Corporate'
	END as Market
	,s.[SVMXC__City__c] as 'Inventory City'
	,s.[SVMXC__State__c] as 'Inventory State'
	,m.[SVMXC__Active__c] as 'Active'
	,m.[Hire_Date__c] as 'Hire Date'
	,ISNULL(ISNULL(m.[SVMXC__Email__c], f.Email)
		,REPLACE(
			LOWER(
				CONCAT(
					TRIM(SUBSTRING(s.Name
								,LEN(LEFT(s.Name, CHARINDEX(',', s.Name))) + 1, 2) -- first letter of first name
						)
						,LEFT(s.Name, (CHARINDEX(',', s.Name))) -- last name
						,'quenchonline.com' -- email address
						)
				)
				, ',', '@'))   as 'Email'
	,CASE WHEN m.Name = 'Bailey, Dameond' THEN 'Hliwski, Steve'
	ELSE q.[Name] END as Manager
FROM [Temporal].[SVMXCServiceGroupMembers] m
	LEFT JOIN [Temporal].[SVMXCSite] s on s.[Id] = m.[SVMXC__Inventory_Location__c]
	LEFT JOIN [Reporting].[SalesforceUser] f on s.id = m.SVMXC__Salesforce_User__c
	LEFT JOIN [Temporal].[SVMXCServiceGroupMembers] q on q.Id = m.Manager__c
	LEFT JOIN Markets mt on mt.MSA_CSA__c = m.[Service_Market__c]

UNION ALL

SELECT * FROM #TechManualAdd

