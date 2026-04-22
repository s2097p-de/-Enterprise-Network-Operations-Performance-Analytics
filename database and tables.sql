-- Enterprise Network Operations & Performance Analytics System
-- CREATE DATABASE NETWORKINGDB
CREATE DATABASE NetworkDb;
USE NetworkDb;

-- Core Tables
-- 1. Zones
CREATE TABLE Zone (
    ZoneID INT PRIMARY KEY,
    ZoneName VARCHAR(50),  -- Zone A, B, C
    Location VARCHAR(100)
);

-- 2. Devices
CREATE TABLE Device (
    DeviceID INT PRIMARY KEY,
    ZoneID INT,
    DeviceType VARCHAR(50), -- Router, Switch, Server
    IPAddress VARCHAR(20),
    Status VARCHAR(20),
    CPU_Usage INT,
    Memory_Usage INT,
	UptimeDays INT,

    FOREIGN KEY (ZoneID) REFERENCES Zone(ZoneID)
);

-- 3. Employees
CREATE TABLE Employee (
    EmployeeID INT PRIMARY KEY,
    Name VARCHAR(100),
    Department VARCHAR(50),
    Role VARCHAR(50),
    AccessLevel VARCHAR(10)
);

-- 4. Network Logs
CREATE TABLE NetworkLog (
    LogID BIGINT PRIMARY KEY,
    DeviceID INT,
    EmployeeID INT,
    Timestamp DATETIME,
    DataUsageMB FLOAT,
    LatencyMS INT,
    AccessType VARCHAR(50), -- VPN, Internal, External
    Status VARCHAR(20),     -- Success, Failed
    FOREIGN KEY (DeviceID) REFERENCES Device(DeviceID),
    FOREIGN KEY (EmployeeID) REFERENCES Employee(EmployeeID)
);

-- 5. Incidents (Downtime / Security)
CREATE TABLE Incident (
    IncidentID INT PRIMARY KEY,
    DeviceID INT,
    IncidentType VARCHAR(50), -- Downtime, Security Breach
    StartTime DATETIME,
    EndTime DATETIME,
    Severity VARCHAR(20),
    FOREIGN KEY (DeviceID) REFERENCES Device(DeviceID)
);

-- 6. Bandwidth Usage
CREATE TABLE BandwidthUsage (
    UsageID INT PRIMARY KEY,
    ZoneID INT,
    Date DATE,
    TotalUsageGB FLOAT,
    PeakUsageGB FLOAT,
    FOREIGN KEY (ZoneID) REFERENCES Zone(ZoneID)
);