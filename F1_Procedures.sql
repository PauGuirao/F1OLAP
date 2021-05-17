USE F1_OLTP;

-- TRIGGER I CRIDA DE INSERT_CIRCUITS
DELIMITER //
CREATE PROCEDURE insert_circuits(IN cirID INT(11),IN cirRef VARCHAR(255),IN cirName VARCHAR(255),IN loc VARCHAR(255),IN Coun VARCHAR(255), IN lati FLOAT, IN lon FLOAT,IN alti INT(11),IN cUrl VARCHAR(255))
BEGIN
	INSERT INTO f1_olap.Circuits (circuitId, circuitRef, circuitName, location, country, lat, lng, alt, circuitUrl)
    VALUES(cirId,cirRef,cirName,loc,Coun,lati,lon,alti,cUrl);
END //
DELIMITER ;


-- TRIGGER I CRIDA DE INSERT_PITSTOPS
DELIMITER //
CREATE PROCEDURE insert_pitstops(IN rID INT(11),IN dID INT(11),IN stopIn INT(11),IN lapIn INT(11),IN timeIn TIME, IN durationIn VARCHAR(255), IN milis INT(11))
BEGIN
	INSERT INTO f1_olap.pitstops (raceId, driverId, stop, lap, time, duration, milliseconds)
    VALUES(rId,dId,stopIn,lapIn,timeIn,durationIn,milis);
END //
DELIMITER ;


-- TRIGGER I CRIDA DE INSERT_LAPS
DELIMITER //
CREATE PROCEDURE insert_laps(IN rID INT(11),IN dID INT(11),IN lapIn INT(11),IN posIn INT(11),IN timeIn VARCHAR(255),IN milis INT(11))
BEGIN
	INSERT INTO f1_olap.Laps (raceId, driverId, lap, position, time, milliseconds)
    VALUES(rId,dId,lapIn,posIn,timeIn,milis);
END //
DELIMITER ;


-- TRIGGER I CRIDA DE INSERT_STATUS
DELIMITER //
CREATE PROCEDURE insert_status(IN sID INT(11),IN statusIn VARCHAR(255))
BEGIN
	INSERT INTO f1_olap.status (statusId, status)
    VALUES(sID,statusIn);
END //
DELIMITER ;


-- TRIGGER I CRIDA DE INSERT_RESULTS_1
DELIMITER //
DROP PROCEDURE IF EXISTS insert_results_1 //
CREATE PROCEDURE insert_results_1(IN resId INT(11),IN numberIn INT(11),IN gridIn INT(11),IN positionIn INT(11),IN pointsIn FLOAT,IN numLapsIn INT(11),IN timeIn VARCHAR(255),IN millisecondsIn INT(11),IN fastestLapIn INT(11),IN rankIn INT(11),IN fastestLapTimeIn VARCHAR(255),IN fastestLapSpeedIn VARCHAR(255),IN dID INT(11),IN sID INT(11),IN cID INT(11),IN rID INT(11))
BEGIN
	INSERT INTO f1_olap.results(resultId, number, grid, position, points, numLaps, time, milliseconds, fastestLap, `rank`, fastestLapTime, fastestLapSpeed,driverId,statusId,constructorId,raceId)
    VALUES(resId,numberIn,gridIn,positionIn,pointsIn,numLapsIn,timeIn,millisecondsIn,
           fastestLapIn,rankIn,fastestLapTimeIn,fastestLapSpeedIn,dID,sID,cId,rId);
END //
DELIMITER ;


-- TRIGGER I CRIDA DE INSERT_RESULTS_2
DELIMITER //
CREATE PROCEDURE insert_results_2(IN yearIn INT(11),IN roundIn INT(11),IN cID INT(11),IN nameIn VARCHAR(255),IN dateIn DATE,IN timeIn VARCHAR(255),IN urlIn VARCHAR(255),IN rID INT(11))
BEGIN
	UPDATE f1_olap.results SET year = yearIn,round = roundIn,circuitId = cID,raceName = nameIn,date = dateIn,time = timeIn,raceUrl = urlIn
    WHERE rId = f1_olap.results.raceId;
END //
DELIMITER ;


-- TRIGGER I CRIDA DE INSERT_RESULTS_3
DELIMITER //
CREATE PROCEDURE insert_results_3(IN dRef VARCHAR(255),IN numberIn INT(11),IN codeIn VARCHAR(3),IN forenameIn VARCHAR(255),IN surnameIn VARCHAR(255),IN dobIn DATE,IN nationalityIn VARCHAR(255),IN urlIn VARCHAR(255),IN dID INT(11))
BEGIN
	UPDATE f1_olap.results
    SET driverRef = dRef,driverNumber = numberIn,code = codeIn,
    forename = forenameIn,surename = surnameIn,dob = dobIn,nationality = nationalityIn,driverUrl = urlIn
    WHERE dID = f1_olap.results.driverId;
END //
DELIMITER ;


-- TRIGGER I CRIDA DE INSERT_RESULTS_4
DELIMITER //
CREATE PROCEDURE insert_results_4(IN cRef VARCHAR(255),IN nameIn VARCHAR(255),IN nationalityIn VARCHAR(255),IN urlIn VARCHAR(255),IN cID INT(11))
BEGIN
	UPDATE f1_olap.results SET constructorRef = cRef,constructorName = nameIn,constructorNationality = nationalityIn,constructorUrl = urlIn
    WHERE cID = f1_olap.results.constructorID;
END //
DELIMITER ;


-- TRIGGER I CRIDA DE INSERT_RESULTS_5
DELIMITER //
CREATE PROCEDURE insert_results_5(IN pointsIn FLOAT,IN positionIn INT(11),IN winsIn INT(11),IN rID INT(11),IN cID INT(11))
BEGIN
	UPDATE f1_olap.results SET constructorPoints = pointsIn,constructorPosition = positionIn,constructorWins = winsIn
    WHERE rID = f1_olap.results.raceId AND cID = f1_olap.results.constructorID;
END //
DELIMITER ;


-- TRIGGER I CRIDA DE INSERT_RESULTS_6
DELIMITER //
CREATE PROCEDURE insert_results_6(IN statusIn VARCHAR(255),IN rID INT(11),IN cID INT(11))
BEGIN
	UPDATE f1_olap.results SET constructorStatus = statusIn
    WHERE rID = f1_olap.results.raceId AND cID = f1_olap.results.constructorID;
END //
DELIMITER ;


-- TRIGGER I CRIDA DE INSERT_RESULTS_7
DELIMITER //
CREATE PROCEDURE insert_results_7(IN numberIn INT(11),IN positionIn INT(11),IN q1In VARCHAR(255),IN q2In VARCHAR(255),IN q3In VARCHAR(255),IN rID INT(11),IN dID INT(11),IN cID INT(11))
BEGIN
	UPDATE f1_olap.results SET qNumber = numberIn,qPosition = positionIn,q1 = q1In,q2 = q2In,q3 = q3In
    WHERE rID = f1_olap.results.raceId AND
          dID = f1_olap.results.driverId AND
          cID = f1_olap.results.constructorID;
END //
DELIMITER ;


-- TRIGGER I CRIDA DE INSERT_RESULTS_8
DELIMITER //
CREATE PROCEDURE insert_results_8(IN url VARCHAR(255),IN yearIn INT(11))
BEGIN
	UPDATE f1_olap.results SET yearUrl = url
    WHERE yearIn = f1_olap.results.year;
END //
DELIMITER ;


-- EVENT PROCEDURES
DELIMITER //
CREATE PROCEDURE comprovacio_circuits(IN numOLTP INT,IN numOLAP INT)
BEGIN
    SET numOLTP = (SELECT COUNT(circuitId) FROM f1_oltp.circuits);
    SET numOLAP = (SELECT COUNT(circuitId) FROM f1_olap.circuits);

	INSERT INTO Comprovacio(nom, oltp_num_files, olap_num_files)
    VALUES ('Circuits', numOLTP, numOLAP);
END //
DELIMITER ;


DELIMITER //
CREATE PROCEDURE comprovacio_status(IN numOLTP INT,IN numOLAP INT)
BEGIN
    SET numOLTP = (SELECT COUNT(statusId) FROM f1_oltp.status);
    SET numOLAP = (SELECT COUNT(statusId) FROM f1_olap.status);

	INSERT INTO Comprovacio(nom, oltp_num_files, olap_num_files)
    VALUES ('Status', numOLTP, numOLAP);
END //
DELIMITER ;


DELIMITER //
CREATE PROCEDURE comprovacio_laps(IN numOLTP INT,IN numOLAP INT)
BEGIN
    SET numOLTP = (SELECT COUNT(raceId) FROM f1_oltp.lapTimes);
    SET numOLAP = (SELECT COUNT(raceId) FROM f1_olap.laps);

	INSERT INTO Comprovacio(nom, oltp_num_files, olap_num_files)
    VALUES ('Laps', numOLTP, numOLAP);
END //
DELIMITER ;


DELIMITER //
CREATE PROCEDURE comprovacio_pitStops(IN numOLTP INT,IN numOLAP INT)
BEGIN
    SET numOLTP = (SELECT COUNT(raceId) FROM f1_oltp.pitStops);
    SET numOLAP = (SELECT COUNT(raceId) FROM f1_olap.pitStops);

	INSERT INTO Comprovacio(nom, oltp_num_files, olap_num_files)
    VALUES ('PitStops', numOLTP, numOLAP);
END //
DELIMITER ;


DELIMITER //
CREATE PROCEDURE comprovacio_results(IN numOLTP INT,IN numOLAP INT)
BEGIN
    SET numOLTP = (SELECT COUNT(resultId) FROM f1_oltp.results);
    SET numOLAP = (SELECT COUNT(resultId) FROM f1_olap.results);

	INSERT INTO Comprovacio(nom, oltp_num_files, olap_num_files)
    VALUES ('Results', numOLTP, numOLAP);
END //
DELIMITER ;
