-- Creacio de la BBDD
DROP DATABASE IF EXISTS F1_OLTP;
CREATE DATABASE F1_OLTP;
USE F1_OLTP;
SET GLOBAL time_zone = '+2:00';

-- Eliminacio de taules
DROP TABLE IF EXISTS circuits CASCADE;
DROP TABLE IF EXISTS constructorResults CASCADE;
DROP TABLE IF EXISTS constructorStandings CASCADE;
DROP TABLE IF EXISTS constructors CASCADE;
DROP TABLE IF EXISTS driverStandings CASCADE;
DROP TABLE IF EXISTS drivers CASCADE;
DROP TABLE IF EXISTS qualifying CASCADE;
DROP TABLE IF EXISTS races CASCADE;
DROP TABLE IF EXISTS results CASCADE;
DROP TABLE IF EXISTS seasons CASCADE;
DROP TABLE IF EXISTS status CASCADE;
DROP TABLE IF EXISTS lapTimes CASCADE;
DROP TABLE IF EXISTS pitStops CASCADE;

-- Crecio de taules
CREATE TABLE circuits (
  circuitId INT(11) NOT NULL AUTO_INCREMENT PRIMARY KEY,
  circuitRef VARCHAR(255) NOT NULL,
  name VARCHAR(255) NOT NULL,
  location VARCHAR(255) DEFAULT NULL,
  country VARCHAR(255) DEFAULT NULL,
  lat FLOAT DEFAULT NULL,
  lng FLOAT DEFAULT NULL,
  alt INT(11) DEFAULT NULL,
  url VARCHAR(255) NOT NULL UNIQUE
);

CREATE TABLE races (
  raceId INT(11) NOT NULL AUTO_INCREMENT PRIMARY KEY,
  year INT(11) NOT NULL DEFAULT 0,
  round INT(11) NOT NULL DEFAULT 0,
  circuitId INT(11) NOT NULL DEFAULT 0,
  name VARCHAR(255) NOT NULL,
  date DATE NOT NULL DEFAULT '0000-00-00',
  time TIME DEFAULT NULL,
  url VARCHAR(255) UNIQUE DEFAULT NULL
);

CREATE TABLE constructorResults (
  constructorResultsId INT(11) NOT NULL AUTO_INCREMENT PRIMARY KEY,
  raceId INT(11) NOT NULL DEFAULT 0,
  constructorId INT(11) NOT NULL DEFAULT 0,
  points FLOAT DEFAULT NULL,
  status VARCHAR(255) DEFAULT NULL
);

CREATE TABLE constructorStandings (
  constructorStandingsId INT(11) NOT NULL AUTO_INCREMENT PRIMARY KEY,
  raceId INT(11) NOT NULL DEFAULT 0,
  constructorId INT(11) NOT NULL DEFAULT 0,
  points FLOAT DEFAULT NULL,
  position INT(11) DEFAULT NULL,
  positionText VARCHAR(255) DEFAULT NULL,
  wins INT(11) DEFAULT 0
);

CREATE TABLE constructors (
  constructorId INT(11) NOT NULL AUTO_INCREMENT PRIMARY KEY,
  constructorRef VARCHAR(255) NOT NULL,
  name VARCHAR(255) NOT NULL UNIQUE,
  nationality VARCHAR(255) DEFAULT NULL,
  url VARCHAR(255) NOT NULL
);

CREATE TABLE driverStandings (
  driverStandingsId INT(11) NOT NULL AUTO_INCREMENT PRIMARY KEY,
  raceId INT(11) NOT NULL DEFAULT 0,
  driverId INT(11) NOT NULL DEFAULT 0,
  points FLOAT NOT NULL DEFAULT 0,
  position INT(11) DEFAULT NULL,
  positionText VARCHAR(255) DEFAULT NULL,
  wins INT(11) DEFAULT 0
);

CREATE TABLE drivers (
  driverId INT(11) NOT NULL AUTO_INCREMENT PRIMARY KEY,
  driverRef VARCHAR(255) NOT NULL,
  number INT(11) DEFAULT NULL,
  code VARCHAR(3) DEFAULT NULL,
  forename VARCHAR(255) NOT NULL,
  surname VARCHAR(255) NOT NULL,
  dob DATE DEFAULT NULL,
  nationality VARCHAR(255) DEFAULT NULL,
  url VARCHAR(255) NOT NULL UNIQUE
);


CREATE TABLE lapTimes (
  raceId INT(11) NOT NULL,
  driverId INT(11) NOT NULL,
  lap INT(11) NOT NULL,
  position INT(11) DEFAULT NULL,
  time VARCHAR(255) DEFAULT NULL,
  milliseconds INT(11) DEFAULT NULL,
  PRIMARY KEY (raceId, driverId, lap)
);


CREATE TABLE qualifying (
  qualifyId INT(11) NOT NULL AUTO_INCREMENT PRIMARY KEY,
  raceId INT(11) NOT NULL DEFAULT 0,
  driverId INT(11) NOT NULL DEFAULT 0,
  constructorId INT(11) NOT NULL DEFAULT 0,
  number INT(11) NOT NULL DEFAULT 0,
  position INT(11) DEFAULT NULL,
  q1 VARCHAR (255) DEFAULT NULL,
  q2 VARCHAR (255) DEFAULT NULL,
  q3 VARCHAR (255) DEFAULT NULL
);

CREATE TABLE pitStops (
  raceId INT(11) NOT NULL,
  driverId INT(11) NOT NULL,
  stop INT(11) NOT NULL,
  lap INT(11) NOT NULL,
  time TIME NOT NULL,
  duration VARCHAR(255) DEFAULT NULL,
  milliseconds INT(11) DEFAULT NULL,
  PRIMARY KEY (raceId, driverId, stop)
);

CREATE TABLE results (
  resultId INT(11) NOT NULL AUTO_INCREMENT PRIMARY KEY,
  raceId INT(11) NOT NULL DEFAULT 0,
  driverId INT(11) NOT NULL DEFAULT 0,
  constructorID INT(11) NOT NULL DEFAULT 0,
  number INT(11) DEFAULT NULL,
  grid INT(11) NOT NULL DEFAULT 0,
  position INT(11) DEFAULT NULL,
  positionText VARCHAR(255) NOT NULL,
  positionOrder INT(11) NOT NULL DEFAULT 0,
  points FLOAT NOT NULL DEFAULT 0,
  laps INT(11) NOT NULL DEFAULT 0,
  time VARCHAR(255) DEFAULT NULL,
  milliseconds INT(11) DEFAULT NULL,
  fastestLap INT(11) DEFAULT NULL,
  `rank` INT(11) DEFAULT 0,
  fastestLapTime VARCHAR(255) DEFAULT NULL,
  fastestLapSpeed VARCHAR(255) DEFAULT NULL,
  statusId INT(11) NOT NULL DEFAULT 0
);

CREATE TABLE seasons (
  year INT(11) NOT NULL PRIMARY KEY DEFAULT 0,
  url VARCHAR(255) NOT NULL UNIQUE
);

CREATE TABLE status (
  statusId INT(11) NOT NULL PRIMARY KEY AUTO_INCREMENT,
  status VARCHAR(255) NOT NULL
);

-- Selects de les taules
SELECT * FROM circuits;
SELECT * FROM pitStops;
SELECT * FROM lapTimes;
SELECT * FROM results;
SELECT * FROM constructors;
SELECT * FROM constructorResults;
SELECT * FROM constructorStandings;
SELECT * FROM driverStandings;
SELECT * FROM drivers;
SELECT * FROM qualifying;
SELECT * FROM races;
SELECT * FROM seasons;
SELECT * FROM status;


-- Comprovacio

-- Mostra els circuits que el seu nom comenci per Circuit
SELECT * FROM Circuits WHERE name LIKE 'Circuit%';

-- Mostra els 3 pilots que van fer millor qualificacio en el circuit de montmelo lany 2019
SELECT surname, forename, c.name AS circuit_name, year, q3 as qualifying_time
FROM results as r
    JOIN qualifying as q on (r.raceId = q.raceId AND r.driverId = q.driverId)
    JOIN drivers as d on r.driverId = d.driverId
    JOIN races as ra on ra.raceId = r.raceId
    JOIN circuits as c on c.circuitId = ra.circuitId
WHERE year = 2019 AND location = 'Montmeló' AND q3 is not null
ORDER BY q3
LIMIT 3;

