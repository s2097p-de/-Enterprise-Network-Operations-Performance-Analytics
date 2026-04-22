--  Core Network Performance 

-- 1. Average Latency (ms)
-- Measures network speed.
SELECT AVG(LatencyMS) AS AvgLatency FROM NetworkLog;
-- Target: < 100 ms

-- Network Availability (%)
-- Measures uptime reliability.
SELECT 
100 - (SUM(TIMESTAMPDIFF(MINUTE, StartTime, EndTime)) / (24*60)) * 100 AS Availability
FROM Incident
WHERE IncidentType = 'Downtime';
-- Target: 99.9%+

-- Packet Success Rate (%)
SELECT 
(COUNT(CASE WHEN Status='Success' THEN 1 END) * 100.0) / COUNT(*) AS SuccessRate
FROM NetworkLog;
-- Target: > 98%

-- Average Bandwidth Usage (GB)
SELECT AVG(TotalUsageGB) FROM BandwidthUsage;
-- Helps in capacity planning

-- Peak Usage (GB)
SELECT MAX(PeakUsageGB) FROM BandwidthUsage;
-- Identifies overload risk

-- 2. Incident & Reliability KPIs

-- Total Incidents
SELECT COUNT(*) FROM Incident;

-- Mean Time to Repair (MTTR)
SELECT AVG(TIMESTAMPDIFF(MINUTE, StartTime, EndTime)) AS MTTR
FROM Incident;
-- Lower is better

-- Mean Time Between Failures (MTBF)
SELECT AVG(TIMESTAMPDIFF(HOUR, LAG(EndTime) OVER (ORDER BY StartTime), StartTime))
FROM Incident;
-- Higher is better

-- High Severity Incident Rate
SELECT 
(COUNT(*) * 100.0) / (SELECT COUNT(*) FROM Incident)
FROM Incident
WHERE Severity = 'High';

-- User Behavior KPIs

-- Top Data Consumers
SELECT EmployeeID, SUM(DataUsageMB) AS Usagee
FROM NetworkLog
GROUP BY EmployeeID
ORDER BY Usagee DESC
LIMIT 5;

-- Failed Login Rate
SELECT 
(COUNT(CASE WHEN Status='Failed' THEN 1 END) * 100.0) / COUNT(*) 
FROM NetworkLog;

-- VPN Usage Ratio
SELECT 
(COUNT(CASE WHEN AccessType='VPN' THEN 1 END) * 100.0) / COUNT(*) AS Usage_Ratio
FROM NetworkLog;

-- Off-Hours Access (%)
SELECT 
(COUNT(*) * 100.0) / (SELECT COUNT(*) FROM NetworkLog)
FROM NetworkLog
WHERE HOUR(Timestamp) BETWEEN 0 AND 6;

-- Zone-Level KPIs (Important for  Project)

-- Zone-wise Latency
SELECT z.ZoneName, AVG(n.LatencyMS)
FROM NetworkLog n
JOIN Device d ON n.DeviceID = d.DeviceID
JOIN Zone z ON d.ZoneID = z.ZoneID
GROUP BY z.ZoneName;

-- Zone-wise Data Usage
SELECT z.ZoneName, SUM(n.DataUsageMB) as Data_Usage
FROM NetworkLog n
JOIN Device d ON n.DeviceID = d.DeviceID
JOIN Zone z ON d.ZoneID = z.ZoneID
GROUP BY z.ZoneName;

-- Zone Incident Count
SELECT z.ZoneName, COUNT(i.IncidentID)
FROM Incident i
JOIN Device d ON i.DeviceID = d.DeviceID
JOIN Zone z ON d.ZoneID = z.ZoneID
GROUP BY z.ZoneName;

-- Device Performance KPIs

-- Device Failure Rate
SELECT DeviceID, 
(COUNT(CASE WHEN Status='Failed' THEN 1 END) * 100.0) / COUNT(*) 
FROM NetworkLog
GROUP BY DeviceID;

-- Device Utilization
SELECT DeviceID, SUM(DataUsageMB)
FROM NetworkLog
GROUP BY DeviceID;

-- Devices with High Latency
SELECT DeviceID, AVG(LatencyMS)
FROM NetworkLog
GROUP BY DeviceID
HAVING AVG(LatencyMS) > 200;

-- Security & Fraud KPIs

-- Suspicious Activity Rate
SELECT 
(COUNT(*) * 100.0) / (SELECT COUNT(*) FROM NetworkLog)
FROM NetworkLog
WHERE Status='Failed' AND AccessType='External';

-- Data Spike Events
SELECT COUNT(*)
FROM NetworkLog
WHERE DataUsageMB > 1000;

-- Multi-device Access Risk
SELECT EmployeeID, COUNT(DISTINCT DeviceID)
FROM NetworkLog
GROUP BY EmployeeID
HAVING COUNT(DISTINCT DeviceID) > 3;