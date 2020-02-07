DROP TABLE IF EXISTS #pm_slas

CREATE TABLE #pm_slas (sla_package nvarchar (MAX)
                      ,Days int)
INSERT INTO #pm_slas
VALUES ('Food Service', 30)
      ,('Platinum', 30)
      ,('Gold', 60)
      ,('Silver', 90)
      ,('Bronze', 90)
      ,('Unknown', 60)

SELECT * FROM #pm_slas