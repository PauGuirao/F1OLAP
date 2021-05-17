USE F1_OLTP;

-- Triggers de Circuits

#&&TRIGGER 0 CIRCUITS->CIRCUITS
DELIMITER $
DROP TRIGGER IF EXISTS trigger_circuits $
CREATE TRIGGER trigger_circuits AFTER INSERT ON f1_oltp.circuits
FOR EACH ROW
BEGIN
    CALL insert_circuits(NEW.circuitId,NEW.circuitRef,NEW.name,NEW.location,NEW.country,NEW.lat,NEW.lng,NEW.alt,NEW.url);
END $
DELIMITER ;

-- Triggers de pitStops
#&&TRIGGERS PITSTOPS -> PITSTOPS
DELIMITER $$
DROP TRIGGER IF EXISTS trigger_pitStops $$
CREATE TRIGGER trigger_pitStops AFTER INSERT ON f1_oltp.pitstops
FOR EACH ROW
BEGIN
    CALL insert_pitstops(NEW.raceId,NEW.driverId,NEW.stop,NEW.lap, NEW.time, NEW.duration, NEW.milliseconds);
END $$
DELIMITER ;


-- Triggers de Laps

#&&TRIGGER 1 LAPTIMES -> LAPS
DELIMITER $$
DROP TRIGGER IF EXISTS trigger_laps $$
CREATE TRIGGER trigger_laps AFTER INSERT ON f1_oltp.laptimes
FOR EACH ROW
BEGIN
    CALL insert_laps(NEW.raceId,NEW.driverId,NEW.lap,NEW.position,NEW.time,NEW.milliseconds);
END $$
DELIMITER ;

-- Triggers de Status

DELIMITER $$
DROP TRIGGER IF EXISTS trigger_status $$
CREATE TRIGGER trigger_status AFTER INSERT ON f1_oltp.status
FOR EACH ROW
BEGIN
    CALL insert_status(NEW.statusId,NEW.status);
END $$
DELIMITER ;


-- Triggers de Results

#&&TRIGGER 1 RESULTS->RESULTS
DELIMITER $$
DROP TRIGGER IF EXISTS trigger_results_1 $$
CREATE TRIGGER trigger_results_1 AFTER INSERT ON f1_oltp.results
FOR EACH ROW
BEGIN
    CALL insert_results_1(NEW.resultId,NEW.number,NEW.grid,NEW.position,NEW.points,NEW.laps,NEW.time,NEW.milliseconds,NEW.fastestLap,NEW.`rank`,NEW.fastestLapTime,NEW.fastestLapSpeed,NEW.driverId,NEW.statusId,NEW.constructorId,NEW.raceId);
END $$
DELIMITER ;

#&&TRIGGER 2 RACES->RESULTS
DELIMITER $$
DROP TRIGGER IF EXISTS trigger_results_2 $$
CREATE TRIGGER trigger_results_2 AFTER INSERT ON f1_oltp.races
FOR EACH ROW
BEGIN
    CALL insert_results_2(NEW.year,NEW.round,NEW.circuitId,NEW.name,NEW.date, NEW.time,NEW.url,NEW.raceId);
END $$
DELIMITER ;

#&&TRIGGER 3 DRIVERS->RESULTS
DELIMITER $$
DROP TRIGGER IF EXISTS trigger_results_3 $$
CREATE TRIGGER trigger_results_3 AFTER INSERT ON f1_oltp.drivers
FOR EACH ROW
BEGIN
    CALL insert_results_3(NEW.driverRef,NEW.number,NEW.code,NEW.forename,NEW.surname,NEW.dob,NEW.nationality,NEW.url,NEW.driverId);
END $$
DELIMITER ;

#&&TRIGGER 4 CONSTRUCTORS->RESULTS
DELIMITER $$
DROP TRIGGER IF EXISTS trigger_results_4 $$
CREATE TRIGGER trigger_results_4 AFTER INSERT ON f1_oltp.constructors
FOR EACH ROW
BEGIN
    CALL insert_results_4(NEW.constructorRef,NEW.name,NEW.nationality,NEW.url,NEW.constructorId);
END $$
DELIMITER ;

#&&TRIGGER 5 CONSTRUCTORSTANDINGS->RESULTS
DELIMITER $$
DROP TRIGGER IF EXISTS trigger_results_5 $$
CREATE TRIGGER trigger_results_5 AFTER INSERT ON f1_oltp.constructorstandings
FOR EACH ROW
BEGIN
    CALL insert_results_5(NEW.points,NEW.position,NEW.wins,NEW.raceId,NEW.constructorId);
END $$
DELIMITER ;

#&&TRIGGER 6 CONSTRUCTORSRESULTS->RESULTS
DELIMITER $$
DROP TRIGGER IF EXISTS trigger_results_6 $$
CREATE TRIGGER trigger_results_6 AFTER INSERT ON f1_oltp.constructorresults
FOR EACH ROW
BEGIN
    CALL insert_results_6( NEW.status,NEW.raceId,NEW.constructorId);
END $$
DELIMITER ;

#&&TRIGGER 7 QUALIFYING->RESULTS
DELIMITER $$
DROP TRIGGER IF EXISTS trigger_results_7 $$
CREATE TRIGGER trigger_results_7 AFTER INSERT ON f1_oltp.qualifying
FOR EACH ROW
BEGIN
    CALL insert_results_7(NEW.number, NEW.position,NEW.q1,NEW.q2,NEW.q3,NEW.raceId,NEW.driverId,NEW.constructorId);
END $$
DELIMITER ;

#&&TRIGGER 8 SEASONS->RESULTS
DELIMITER $$
DROP TRIGGER IF EXISTS trigger_results_8 $$
CREATE TRIGGER trigger_results_8 AFTER INSERT ON f1_oltp.seasons
FOR EACH ROW
BEGIN
    CALL insert_results_8(NEW.url,NEW.year);
END $$
DELIMITER ;

SHOW TRIGGERS ;

-- Creacio Event
DELIMITER $$
DROP EVENT IF EXISTS compara_files $$
CREATE EVENT IF NOT EXISTS compara_files
ON SCHEDULE EVERY 5 MINUTE STARTS NOW()
DO BEGIN

-- Declaracio Variables
DECLARE numOLTP INT;
DECLARE numOLAP INT;

-- Creacio taula auxiliar
DROP TABLE IF EXISTS Comprovacio CASCADE;
CREATE TABLE Comprovacio (
    nom VARCHAR(255) PRIMARY KEY,
    oltp_num_files INT,
    olap_num_files INT
);

-- Crida comprovacions
CALL comprovacio_circuits(numOLTP,numOLAP);
CALL comprovacio_status(numOLTP,numOLAP);
CALL comprovacio_laps(numOLTP,numOLAP);
CALL comprovacio_pitStops(numOLTP,numOLAP);
CALL comprovacio_results(numOLTP,numOLAP);

SELECT * FROM Comprovacio;

END $$
DELIMITER ;

SHOW EVENTS;
