-- Creacio de la BBDD
DROP DATABASE IF EXISTS F1_OLAP;
CREATE DATABASE F1_OLAP;
USE F1_OLAP;

-- Eliminacio de taules
DROP TABLE IF EXISTS Circuits CASCADE;
DROP TABLE IF EXISTS Results CASCADE;
DROP TABLE IF EXISTS pitStops CASCADE;
DROP TABLE IF EXISTS Laps CASCADE;
DROP TABLE IF EXISTS Status CASCADE;


-- Crecio de taules
CREATE TABLE Circuits (
  circuitId INT(11) NOT NULL PRIMARY KEY,
  circuitRef VARCHAR(255) NOT NULL,
  circuitName VARCHAR(255) NOT NULL,
  location VARCHAR(255) DEFAULT NULL,
  country VARCHAR(255) DEFAULT NULL,
  lat FLOAT DEFAULT NULL,
  lng FLOAT DEFAULT NULL,
  alt INT(11) DEFAULT NULL,
  circuitUrl VARCHAR(255) NOT NULL UNIQUE
);

CREATE TABLE Results (
  resultId INT(11) NOT NULL PRIMARY KEY,
  number INT(11) DEFAULT NULL,
  grid INT(11) DEFAULT 0,
  position INT(11) DEFAULT NULL,
  points FLOAT DEFAULT 0,
  wins INT(11) DEFAULT 0,
  numLaps INT(11) DEFAULT 0,
  time VARCHAR(255) DEFAULT NULL,
  milliseconds INT(11) DEFAULT NULL,
  fastestLap INT(11) DEFAULT NULL,
  `rank` INT(11) DEFAULT 0,
  fastestLapTime VARCHAR(255) DEFAULT NULL,
  fastestLapSpeed VARCHAR(255) DEFAULT NULL,
  driverId INT(11) DEFAULT 0,
  driverRef VARCHAR(255) ,
  driverNumber INT(11) DEFAULT NULL,
  code VARCHAR(3) DEFAULT NULL,
  forename VARCHAR(255),
  surename VARCHAR(255),
  dob DATE DEFAULT NULL,
  nationality VARCHAR(255) DEFAULT NULL,
  driverUrl VARCHAR(255),
  statusId INT(11) DEFAULT NULL,
  constructorId INT(11),
  constructorRef VARCHAR(255),
  constructorName VARCHAR(255),
  constructorNationality VARCHAR(255) DEFAULT NULL,
  constructorUrl VARCHAR(255),
  constructorPoints FLOAT DEFAULT NULL,
  constructorPosition INT(11) DEFAULT NULL,
  constructorWins INT(11) DEFAULT 0,
  constructorStatus VARCHAR(255) DEFAULT NULL,
  qNumber INT(11) DEFAULT 0,
  qPosition INT(11) DEFAULT NULL,
  q1 VARCHAR (255) DEFAULT NULL,
  q2 VARCHAR (255) DEFAULT NULL,
  q3 VARCHAR (255) DEFAULT NULL,
  raceId INT(11),
  round INT(11) DEFAULT 0,
  raceName VARCHAR(255),
  date DATE DEFAULT '0000-00-00',
  raceUrl VARCHAR(255) DEFAULT NULL,
  year INT(11) DEFAULT 0,
  yearUrl VARCHAR(255),
  circuitId INT(11),
  FOREIGN KEY (circuitId) REFERENCES Circuits(circuitId)
);

CREATE TABLE Laps (
  raceId INT(11) NOT NULL,
  driverId INT(11) NOT NULL,
  lap INT(11) NOT NULL,
  position INT(11) DEFAULT NULL,
  time VARCHAR(255) DEFAULT NULL,
  milliseconds INT(11) DEFAULT NULL,
  PRIMARY KEY (raceId, driverId, lap)
);

CREATE TABLE PitStops (
  raceId INT(11) NOT NULL,
  driverId INT(11) NOT NULL,
  stop INT(11) NOT NULL,
  lap INT(11) NOT NULL,
  time TIME NOT NULL,
  duration VARCHAR(255) DEFAULT NULL,
  milliseconds INT(11) DEFAULT NULL,
  PRIMARY KEY (raceId, driverId, stop)
);

CREATE TABLE Status (
  statusId INT(11) NOT NULL PRIMARY KEY,
  status VARCHAR(255)
);

-- Selects de les taules
SELECT * FROM Circuits;
SELECT * FROM Results;
SELECT * FROM Laps;
SELECT * FROM PitStops;
SELECT * FROM Status;


-- Comprovacio

-- Mostra els circuits que el seu nom comenci per Circuit
SELECT * FROM Circuits WHERE circuitName LIKE 'Circuit%';

-- Mostra els 3 pilots que van fer millor qualificacio en el circuit de montmelo lany 2019
SELECT surename, forename, c.circuitName AS circuit_name, year, q3 as qualifying_time
FROM results as r
    JOIN circuits as c ON c.circuitId = r.circuitId
WHERE year = 2019 AND location = 'Montmeló' AND q3 is not null
ORDER BY q3
LIMIT 3;
