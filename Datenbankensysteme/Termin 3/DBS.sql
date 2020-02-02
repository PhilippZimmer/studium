/*
*SQL = structured query language
*DDL = Data Definition Language
*/

/*erstmal tabellen löschen*/

DROP TABLE kunden CASCADE CONSTRAINTS;
DROP TABLE fuehrerscheinklassen CASCADE CONSTRAINTS;
DROP TABLE hersteller CASCADE CONSTRAINTS;
DROP TABLE fahrzeugarten CASCADE CONSTRAINTS;
DROP TABLE person_fuehrerscheinklassen CASCADE CONSTRAINTS;
DROP TABLE fahrzeugtypen CASCADE CONSTRAINTS;
DROP TABLE fahrzeuge CASCADE CONSTRAINTS;
DROP TABLE vorbestellungen CASCADE CONSTRAINTS;
DROP TABLE ausleihen CASCADE CONSTRAINTS;
DROP TABLE ftypen_fklassen_benoetigt CASCADE CONSTRAINTS;
DROP TABLE ftypen_fklassen_gilt_gefahren CASCADE CONSTRAINTS;


/*erstelle Tabellen*/
CREATE TABLE kunden (
    pid INTEGER PRIMARY KEY,
    name VARCHAR2(255) NOT NULL,
    strasse VARCHAR2(255) NOT NULL,
    ort VARCHAR2(255) NOT NULL,
    plz VARCHAR2(5) NULL,
    iban VARCHAR2(34) NOT NULL
);

CREATE TABLE fuehrerscheinklassen (
    klassenkennung      INTEGER PRIMARY KEY,
    Klassenbezeichnung  VARCHAR2(4) NOT NULL,
    Beschreibung        VARCHAR2(255) NULL
);

CREATE TABLE hersteller (
    hid INTEGER PRIMARY KEY,
    hersteller_name VARCHAR2(255) NOT NULL,
    adresse VARCHAR2(255) NULL
);

CREATE TABLE fahrzeugarten (
    art_id INTEGER PRIMARY KEY,
    art_bezeichnung VARCHAR2(255) NOT NULL
);

CREATE TABLE person_fuehrerscheinklassen (
    seit TIMESTAMP NOT NULL,
    klassenkennung_id INTEGER NOT NULL,
    pid_id INTEGER NOT NULL,
    bemerkung VARCHAR2(255) NULL,
    CONSTRAINT pk_per_fueherschkl PRIMARY KEY (seit, klassenkennung_id, pid_id)
);

CREATE TABLE fahrzeugtypen (
    typ_id INTEGER PRIMARY KEY,
    art_id INTEGER NOT NULL,
    hid INTEGER NOT NULL,
    typ_bezeichner VARCHAR2(255) NOT NULL,
    anzahl_sitze INTEGER NOT NULL,
    anzahl_türen INTEGER NULL,
    zul_gesamtgewicht INTEGER NOT NULL,
    zul_hoechstgeschw INTEGER NOT NULL
);

CREATE TABLE fahrzeuge (
    kfz_nr INTEGER PRIMARY KEY,
    typ_id INTEGER NOT NULL,
    preis_pro_tag DECIMAL(5,2) NOT NULL,
    nummernschild VARCHAR2(9) NOT NULL,
    gelaufene_km INTEGER NOT NULL,
    naechste_hu DATE NOT NULL,
    naechste_asu DATE NOT NULL,
    farbe VARCHAR2(45) NOT NULL,
    klimaanlage VARCHAR2(255) NULL,
    angemeldet_am TIMESTAMP NOT NULL,
    abgemeldet_am TIMESTAMP NULL
);

CREATE TABLE vorbestellungen (
    vid INTEGER PRIMARY KEY,
    pid INTEGER NOT NULL,
    kfz_nr INTEGER NOT NULL,
    von TIMESTAMP NOT NULL,
    bis TIMESTAMP NOT NULL
);

CREATE TABLE ausleihen (
    von TIMESTAMP NOT NULL,
    bis TIMESTAMP NOT NULL,
    kfz_nr INTEGER NOT NULL,
    pid INTEGER NOT NULL,
    vid INTEGER NOT NULL,
    CONSTRAINT pk_ausleihen PRIMARY KEY (von, bis, kfz_nr, pid)
);


--m:n
CREATE TABLE ftypen_fklassen_benoetigt (
    typ_id NUMBER NOT NULL,
    klassenkennung NUMBER NOT NULL,
    CONSTRAINT typ_klass_ben_pk PRIMARY KEY (typ_id, klassenkennung)
);

CREATE TABLE ftypen_fklassen_gilt_gefahren (
    typ_id NUMBER NOT NULL,
    klassenkennung NUMBER NOT NULL,
    CONSTRAINT typ_klass_gilt_pk PRIMARY KEY (typ_id, klassenkennung)
);



--erzeugen von Fremdschlüsseln mit Kunde löschen = löschen

ALTER TABLE ausleihen
    ADD CONSTRAINT fk_kunde_ausleihen FOREIGN KEY (pid)
        REFERENCES kunden(pid) ON DELETE CASCADE INITIALLY DEFERRED;
ALTER TABLE vorbestellungen
    ADD CONSTRAINT fk_kunde_vorbestellungen FOREIGN KEY (pid)
        REFERENCES kunden(pid) ON DELETE CASCADE INITIALLY DEFERRED;
ALTER TABLE person_fuehrerscheinklassen
    ADD CONSTRAINT fk_kunde_pers_fueherschein FOREIGN KEY (pid_id)
        REFERENCES kunden(pid) ON DELETE CASCADE INITIALLY DEFERRED;



-- erzeugen von Fremdschlüsseln mit Vorbestellung löschen = NULL

ALTER TABLE ausleihen
    ADD CONSTRAINT fk_vorbestellung FOREIGN KEY (vid)
        REFERENCES vorbestellungen(vid) ON DELETE SET NULL INITIALLY DEFERRED;



-- erzeugen von Fremdschlüsseln mit Default verhalten

ALTER TABLE person_fuehrerscheinklassen
    ADD CONSTRAINT fk_fuehrerscheinklassen FOREIGN KEY (klassenkennung_id)
        REFERENCES fuehrerscheinklassen(klassenkennung);

ALTER TABLE fahrzeugtypen
    ADD CONSTRAINT fk_fahrzeugart FOREIGN KEY (art_id)
        REFERENCES fahrzeugarten(art_id);
ALTER TABLE fahrzeugtypen
    ADD CONSTRAINT fk_hersteller FOREIGN KEY (hid)
        REFERENCES hersteller(hid);

ALTER TABLE fahrzeuge
    ADD CONSTRAINT fk_fahrzeugtypen FOREIGN KEY (typ_id)
        REFERENCES fahrzeugtypen(typ_id);

ALTER TABLE vorbestellungen
    ADD CONSTRAINT fk_fahrzeug_vorbestellungen FOREIGN KEY (kfz_nr)
        REFERENCES fahrzeuge(kfz_nr);

ALTER TABLE ausleihen
    ADD CONSTRAINT fk_fahrzeug FOREIGN KEY (kfz_nr)
        REFERENCES fahrzeuge(kfz_nr);

ALTER TABLE ftypen_fklassen_benoetigt
    ADD CONSTRAINT fahrzeugtypen_ft_fk_b_fk FOREIGN KEY (typ_id)
        REFERENCES fahrzeugtypen (typ_id);

ALTER TABLE ftypen_fklassen_benoetigt
    ADD CONSTRAINT fklassen_ft_fk_b_fk FOREIGN KEY (klassenkennung)
        REFERENCES fuehrerscheinklassen (klassenkennung);

ALTER TABLE ftypen_fklassen_gilt_gefahren
    ADD CONSTRAINT fahrzeugtypen_ft_fk_fk FOREIGN KEY (typ_id)
        REFERENCES fahrzeugtypen (typ_id);

ALTER TABLE ftypen_fklassen_gilt_gefahren
    ADD CONSTRAINT fuehrerscheinklassen_ft_fk_fk FOREIGN KEY (klassenkennung)
    REFERENCES fuehrerscheinklassen (klassenkennung);


--löschen von Sequenzen
DROP SEQUENCE kunden_seq;
DROP SEQUENCE hersteller_seq;
DROP SEQUENCE fahrzeugarten_seq;
DROP SEQUENCE fahrzeugtypen_seq;
DROP SEQUENCE vorbestellungen_seq;
DROP SEQUENCE fahrzeuge_seq;



--erzeugen von Sequenzen
CREATE SEQUENCE kunden_seq;
CREATE SEQUENCE hersteller_seq;
CREATE SEQUENCE fahrzeugarten_seq;
CREATE SEQUENCE fahrzeugtypen_seq;
CREATE SEQUENCE vorbestellungen_seq;
CREATE SEQUENCE fahrzeuge_seq;




--löschen von Index
DROP INDEX bis_ind;


--erzeugen von Index absteigendsortiert
CREATE INDEX bis_ind
    ON ausleihen(bis asc);

--Bedingungen
ALTER TABLE fuehrerscheinklassen
    ADD CONSTRAINT Klassenbezeichnung
        CHECK (UPPER(Klassenbezeichnung)
            IN ('A1', 'A', 'M', 'T', 'C1', 'C', 'B', 'BE'))
            INITIALLY DEFERRED;

ALTER TABLE vorbestellungen
    ADD CONSTRAINT CHECK_2
        CHECK (von >= bis)
        INITIALLY IMMEDIATE;

ALTER TABLE ausleihen
    ADD CONSTRAINT ausleihen_von_vorbst_bis
        --REFERENCES vorbestellungen(bis)
            CHECK ( von >= bis)
            INITIALLY DEFERRED;



--daten einfügen und neue PK werte
INSERT INTO kunden (pid, name, strasse, ort, plz, iban)
    VALUES ( kunden_seq.NEXTVAL, 'Tatiana Test', 'Teststraße 26', 'Teststatd', 11111, 1234567891012345 );
INSERT INTO kunden (pid, name, strasse, ort, plz, iban)
    VALUES ( kunden_seq.NEXTVAL, 'Irngried Iris', 'Staren Weg 7', 'Teststatd', 11111, 0198765432112345 );
INSERT INTO kunden (pid, name, strasse, ort, plz, iban)
    VALUES ( kunden_seq.NEXTVAL, 'Lars Laus', 'Insekten Weg 232', 'Teststatd', 11111, 1234545691012345 );

INSERT INTO hersteller (hid, hersteller_name ,adresse)
    VALUES ( hersteller_seq.NEXTVAL, 'Mitsubishi', 'Japan');
INSERT INTO hersteller (hid, hersteller_name ,adresse)
    VALUES ( hersteller_seq.NEXTVAL, 'BMW', 'Bayan');
INSERT INTO hersteller (hid, hersteller_name ,adresse)
    VALUES ( hersteller_seq.NEXTVAL, 'Ferrari', 'Italien');

INSERT INTO fahrzeugarten (art_id ,art_bezeichnung)
    VALUES  (fahrzeugarten_seq.NEXTVAL,'Sportwagen');
INSERT INTO fahrzeugarten (art_id ,art_bezeichnung)
    VALUES  (fahrzeugarten_seq.NEXTVAL, 'SUV');
INSERT INTO fahrzeugarten (art_id ,art_bezeichnung)
    VALUES  (fahrzeugarten_seq.NEXTVAL, 'Moped');

INSERT INTO fahrzeugtypen (typ_id, art_id, hid, typ_bezeichner, anzahl_sitze, anzahl_türen, zul_gesamtgewicht, zul_hoechstgeschw)
    VALUES  (fahrzeugtypen_seq.NEXTVAL, 1, 1, 'GRF7', 2, 4, 1100, 320);
INSERT INTO fahrzeugtypen (typ_id, art_id, hid, typ_bezeichner, anzahl_sitze, anzahl_türen, zul_gesamtgewicht, zul_hoechstgeschw)
    VALUES  (fahrzeugtypen_seq.NEXTVAL, 2, 2, 'BR5', 5, 4, 2300, 230);
INSERT INTO fahrzeugtypen (typ_id, art_id, hid, typ_bezeichner, anzahl_sitze, anzahl_türen, zul_gesamtgewicht, zul_hoechstgeschw)
    VALUES  (fahrzeugtypen_seq.NEXTVAL, 3, 3, 'MU1', 1, 0, 400, 80);

INSERT INTO fahrzeuge (kfz_nr, typ_id, preis_pro_tag, nummernschild, gelaufene_km, naechste_hu, naechste_asu, farbe, klimaanlage, angemeldet_am, abgemeldet_am)
    VALUES (fahrzeuge_seq.NEXTVAL, 3, 0.5, 'B SM 7000', 35000, '01-01-2020', '01-01-2020', 'schwarz', 'ne', '01-01-2018', '');
INSERT INTO fahrzeuge (kfz_nr, typ_id, preis_pro_tag, nummernschild, gelaufene_km, naechste_hu, naechste_asu, farbe, klimaanlage, angemeldet_am, abgemeldet_am)
    VALUES (fahrzeuge_seq.NEXTVAL, 2, 8, 'B MS 0007', 25000, '01-01-2020', '01-01-2020', 'blau', 'ja', '01-01-2018', '');
INSERT INTO fahrzeuge (kfz_nr, typ_id, preis_pro_tag, nummernschild, gelaufene_km, naechste_hu, naechste_asu, farbe, klimaanlage, angemeldet_am, abgemeldet_am)
    VALUES (fahrzeuge_seq.NEXTVAL, 1, 15, 'B MM 9999', 15000, '01-01-2020', '01-01-2020', 'gelb', 'ja', '01-01-2018', '');

INSERT INTO vorbestellungen (vid, pid, kfz_nr, von, bis)
    VALUES  (vorbestellungen_seq.NEXTVAL, 1, 1, '01-12-2019 11:11:11', '15-01-2019 12:35:09');
INSERT INTO vorbestellungen (vid, pid, kfz_nr, von, bis)
    VALUES  (vorbestellungen_seq.NEXTVAL, 3, 3, '01-12-2019 11:11:11', '15-01-2019 12:35:09');
INSERT INTO vorbestellungen (vid, pid, kfz_nr, von, bis)
    VALUES  (vorbestellungen_seq.NEXTVAL, 2, 2, '08-12-2019 16:11:10', '15-01-2019 8:35:09');

INSERT INTO ausleihen (vid, pid, kfz_nr, von, bis)
    VALUES (1, 1, 1,'01-12-2019 11:11:11', '15-01-2019 12:35:09');
INSERT INTO ausleihen (vid, pid, kfz_nr, von, bis)
    VALUES (2, 2, 2,'01-12-2019 11:11:11', '15-01-2019 12:35:09');
INSERT INTO ausleihen (vid, pid, kfz_nr, von, bis)
    VALUES (3, 3, 3,'08-12-2019 16:11:10', '15-01-2019 8:35:09');
COMMIT;

--------------Test-------------
--update
SELECT * FROM kunden;
UPDATE kunden
    SET ort = 'Teststadt'
    WHERE ort = 'Teststatd';
COMMIT;

--PK Test und Pflichteingaben
DELETE FROM kunden
    Where name = 'Irngried Iris';

SELECT * FROM kunden;


INSERT INTO kunden (pid, name, strasse, ort, plz, iban)
    VALUES ( kunden_seq.NEXTVAL, 'Irngried Iris', '', 'Teststadt', 11111, 0198765432112345 );
INSERT INTO kunden (pid, name, strasse, ort, plz, iban)
    VALUES ( kunden_seq.NEXTVAL, 'Tim Kölner', 'Fuchsweg 5', 'Teststadt', 11111, 0186965432112345 );
COMMIT;

--ON DELETE CASCADE Kunde und Ausleihen
SELECT * FROM ausleihen;

DELETE FROM kunden
    where pid = 1;
COMMIT;
SELECT * FROM ausleihen;

--ON DELETE SET NULL Vorbestellung und Ausleihen
SELECT * FROM vorbestellungen;

DELETE FROM ausleihen
    where vid = 3;
COMMIT;

SELECT * FROM vorbestellungen;

--Default-Fehlverhalten
SELECT * FROM fahrzeuge;
DELETE FROM fahrzeuge
    where kfz_nr = 1;
    COMMIT;
SELECT * FROM fahrzeuge;

--test groß und kleinschreibung egal, verzögert, nur kürzel
INSERT INTO fuehrerscheinklassen (klassenkennung, Klassenbezeichnung, Beschreibung)
    VALUES (1, 'A1', 'ne');
INSERT INTO fuehrerscheinklassen (klassenkennung, Klassenbezeichnung, Beschreibung)
    VALUES (2, 'c1', 'ne');
INSERT INTO fuehrerscheinklassen (klassenkennung, Klassenbezeichnung, Beschreibung)
    VALUES (3, 'z', 'ne');
COMMIT;

--test Datum
INSERT INTO vorbestellungen (vid, pid, kfz_nr, von, bis)
    VALUES  (vorbestellungen_seq.NEXTVAL, 3, 2,'15-01-2019 8:35:09' , '08-12-2019 16:11:10');


--Primary Key(zusammengesetzte) seperat per ALTER erzeugen


