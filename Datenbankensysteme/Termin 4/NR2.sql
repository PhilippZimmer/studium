--a

SELECT DISTINCT KFZ_NR, Nummernschild
FROM Fahrzeuge
WHERE KFZ_NR IN (SELECT Fahrzeuge.KFZ_NR FROM vorbestellungen, Ausleihen);

--b
--SELECT DISTINCT KFZ_NR, Nummernschild
--FROM fahrzeuge LEFT OUTER JOIN ausleihen USING (KFZ_NR)
--   JOIN fahrzeuge USING (KFZ_NR);

SELECT DISTINCT KFZ_NR, Nummernschild FROM fahrzeuge
Where KFZ_NR NOT IN(SELECT KFZ_NR FROM ausleihen);

SELECT KFZ_NR, Nummernschild
FROM Fahrzeuge
WHERE NOT EXISTS (SELECT KFZ_NR FROM Ausleihen WHERE Ausleihen.KFZ_NR = Fahrzeuge.KFZ_NR);

SELECT DISTINCT fahrzeuge.KFZ_NR, Nummernschild
FROM fahrzeuge 
LEFT OUTER JOIN ausleihen ON ausleihen.KFZ_NR = fahrzeuge.KFZ_NR WHERE ausleihen.KFZ_NR IS NULL;

--c
SELECT DISTINCT KFZ_NR, Nummernschild, TYP_Bezeichner, Anzahl_Tueren
FROM fahrzeuge NATURAL JOIN vorbestellungen
    NATURAL JOIN fahrzeugtypen Where Anzahl_Tueren > 2;

--d
SELECT DISTINCT Pid, Name, STRASSE, PLZ, Ort
FROM person_fuehrerscheinklasse 
LEFT OUTER JOIN Fuehrerscheinklassen ON  Fuehrerscheinklassen.klassenkennung = person_fuehrerscheinklasse.klassenkennung WHERE person_fuehrerscheinklasse.klassenkennung IS NULL
    AND NATURAL JOIN Kunden;

--Nr3 a)
--Limousine, >150000 kilmometer, Nummernschild(ort) = GM, bis 1.5.2020 HU, Ausgeliehen
--KFZ_NR, Nummernschild, TYP_Bezeichner
SELECT DISTINCT fahrzeuge.KFZ_NR, fahrzeuge.Nummernschild, fahrzeugtypen.typ_bezeichner
FROM fahrzeuge, fahrzeugarten, fahrzeugtypen
WHERE fahrzeugarten.Art_Bezeichner = 'Limousine'
AND fahrzeuge.gelaufene_KM < 150000
AND fahrzeuge.Nummernschild LIKE 'GM%'
AND fahrzeuge.naechste_HU < '01-05-2020'
AND fahrzeuge.KFZ_NR  = ausleihen.KFZ_NR
AND fahrzeuge.typ_id = fahrzeugtypen.typ_id;


--b)
--Kunde = meiste Fahrzeuge
--PID, NAmen absteigend, max Anzahl
SELECT DISTINCT kunden.PID, kunden.Name, COUNT(ausleihen.KFZ_NR) as Anzahl
FROM kunden, ausleihen, Fahrzeuge
WHERE ausleihen.PID = kunden.PID
AND ausleihen.KFZ_NR = Fahrzeuge.KFZ_NR
GROUP BY kunden.PID, kunden.Name
ORDER BY  Anzahl DESC, kunden.Name ASC;



--c)
--2a modifizieren, dritte Spalte = V(vorbestellt)/A(ausgeliehen)
SELECT DISTINCT ausleihen.KFZ_NR, fahrzeuge.nummernschild, 'A' Status
FROM vorbestellungen, ausleihen, fahrzeuge
WHERE vorbestellungen.KFZ_NR = ausleihen.KFZ_NR
AND fahrzeuge.KFZ_NR = vorbestellungen.KFZ_NR;

--d)
--Fahrzeuge = gleiche TYP_Bezeichner oder mehrfach?
--Typ_Bezeichner(absteigend), KFZ_Nr(aufsteigend)
SELECT fahrzeugtypen.typ_bezeichner, fahrzeuge.KFZ_NR, COUNT(fahrzeuge.typ_id) as Anzahl
FROM fahrzeuge, fahrzeugtypen
WHERE fahrzeuge.typ_id = fahrzeugtypen.typ_id
GROUP BY  fahrzeugtypen.typ_bezeichner, fahrzeuge.KFZ_NR
HAVING COUNT (*) > 2
ORDER BY fahrzeugtypen.typ_bezeichner DESC, fahrzeuge.KFZ_NR ASC;