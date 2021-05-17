USE f1_OLAP;

-- 1
SELECT status
FROM status AS s LEFT JOIN results AS r ON s.statusId = r.statusId
WHERE r.statusId IS NULL;


-- 2
SELECT r.surename, r.forename, r.nationality, AVG(p.milliseconds)
FROM pitStops as p LEFT JOIN results as r ON (p.driverId = r.driverId AND p.raceId = r.raceId)
WHERE r.constructorId IN (
    SELECT r1.constructorId
    FROM pitStops as p1 LEFT JOIN results as r1 ON (p1.driverId = r1.driverId AND p1.raceId = r1.raceId)
    GROUP BY r1.constructorId
    HAVING AVG(p1.milliseconds) <= ALL
        (SELECT AVG(p2.milliseconds) FROM pitStops as p2 LEFT JOIN results as r2 ON (p2.driverId = r2.driverId AND p2.raceId = r2.raceId)
        GROUP BY r2.constructorId
        ORDER BY AVG(p2.milliseconds)))
GROUP BY r.driverId;


-- 3
SELECT r.forename, r.surename, r.fastestLapTime
FROM results as r
WHERE r.q1 > r.q2 AND r.q2 > r.q3 AND r.position > 0 AND r.position < 4 and  r.fastestLapTime < ALL (
    SELECT r1.q1
    FROM results as r1
    WHERE r.raceId = r1.raceId AND r.driverId <> r1.driverId AND r1.q1 IS NOT NULL)
AND r.fastestLapTime < ALL (
    SELECT r2.q2
    FROM results as r2
    WHERE r.raceId = r2.raceId AND r.driverId <> r2.driverId AND r2.q2 IS NOT NULL)
AND r.fastestLapTime < ALL (
    SELECT r3.q3
    FROM results as r3
    WHERE r.raceId = r3.raceId AND r.driverId <> r3.driverId AND r3.q3 IS NOT NULL);


-- 4
(SELECT DISTINCT r.forename,r.surename,r.fastestLapSpeed,r.fastestLapTime,c.circuitName
FROM results as r JOIN circuits as c ON (r.circuitId = c.circuitId) JOIN laps as l ON (l.driverId = r.driverId AND l.raceId = r.raceId)
WHERE r.fastestLapSpeed IS NOT NULL AND r.fastestLapTime IS NOT NULL
AND l.milliseconds <= ALL (
    SELECT l1.milliseconds
    FROM laps as l1
    WHERE r.raceId = l1.raceId AND l1.milliseconds IS NOT NULL)
AND r.fastestLapSpeed < ANY (
    SELECT r2.fastestLapSpeed
    FROM results as r2
    WHERE r.raceId = r2.raceId AND r2.fastestLapSpeed IS NOT NULL))
UNION
(SELECT DISTINCT r.forename,r.surename,r.fastestLapSpeed,r.fastestLapTime,c.circuitName
FROM results as r JOIN circuits as c ON (r.circuitId = c.circuitId) JOIN laps as l ON (l.driverId = r.driverId AND l.raceId = r.raceId)
WHERE r.fastestLapSpeed IS NOT NULL AND r.fastestLapTime IS NOT NULL
AND l.milliseconds > ANY (
    SELECT l1.milliseconds
    FROM laps as l1
    WHERE r.raceId = l1.raceId AND l1.milliseconds IS NOT NULL)
AND r.fastestLapSpeed >= ALL (
    SELECT r2.fastestLapSpeed
    FROM results as r2
    WHERE r.raceId = r2.raceId AND r2.fastestLapSpeed IS NOT NULL));


-- 5
(SELECT r.forename, r.surename, c.circuitName, r.year, l.position - r.position AS Overtaking
FROM Results AS r, Circuits AS c, Laps AS l
WHERE r.raceId = l.raceId AND r.driverId = l.driverId AND c.circuitId = r.circuitId
  AND l.lap = 2 AND r.position IS NOT NULL AND l.position IS NOT NULL
ORDER BY Overtaking DESC
LIMIT 1)
UNION
(SELECT r.forename, r.surename, c.circuitName, r.year, l1.position - l2.position AS Overtaking
FROM Results AS r, Circuits AS c, Laps AS l1, Laps l2
WHERE r.raceId = l1.raceId AND r.driverId = l1.driverId AND r.raceId = l2.raceId AND r.driverId = l2.driverId AND c.circuitId = r.circuitId
  AND l2.lap = l1.lap + 1 AND r.position IS NOT NULL AND l1.position IS NOT NULL
ORDER BY Overtaking DESC
LIMIT 1);
