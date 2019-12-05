SELECT 
  driver_day.driver_email_address, 
  SUM(driver_day.total_idle) as Idle_time, 
  SUM(driver_day.trip_distance) as Distance, 
  SUM(driver_day.speeding_over_75_mph) as Speeding_Over_75mph, 
  SUM(driver_day.speeding_over_posted) as Speeding_Over_Posted, 
  SUM(driver_day.hard_accel) as Hard_Accel, 
  SUM(driver_day.hard_brake) as Hard_Brake, 
  driver_day.start_day_year, 
  driver_day.start_day_month,
  COUNT(driver_day.start_day_date) as NumberOfDaysDriven,
  SUM(driver_day.drive_time_duration) as Drive_Duration
FROM 
  zonesf03a.driver_day
  WHERE driver_day.trip_distance > 1
  AND driver_day.drive_time_duration > 0
  GROUP BY driver_day.driver_email_address,
	driver_day.start_day_year, 
	driver_day.start_day_month;