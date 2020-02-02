
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
    klassenkennung INTEGER PRIMARY KEY,
    Klassenbezeichnung VARCHAR2(4) NOT NULL,
    Beschreibung VARCHAR2(255) NULL
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
    zul_gesamtgewicht DECIMAL(2,3) NOT NULL,
    zul_hoechstgeschw INTEGER NOT NULL
);

CREATE TABLE fahrzeuge (
    kfz_nr INTEGER PRIMARY KEY,
    typ_id INTEGER NOT NULL,
    preis_pro_tag DECIMAL(5,2) NOT NULL,
    nummernschild VARCHAR2(7) NOT NULL,
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
    von INTEGER NOT NULL,
    bis INTEGER NOT NULL,
    kfz_nr INTEGER NOT NULL,
    pid INTEGER NOT NULL,
    vid INTEGER NOT NULL,
    CONSTRAINT pk_ausleihen PRIMARY KEY (von, bis, kfz_nr, pid)
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



--löschen von Sequenzen
DROP SEQUENCE kunden_seq;
DROP SEQUENCE hersteller_seq;
DROP SEQUENCE fahrzeugarten_seq;
DROP SEQUENCE fahrzeugtypen_seq;
DROP SEQUENCE vorbestellungen_seq;



--erzeugen von Sequenzen
CREATE SEQUENCE kunden_seq;
CREATE SEQUENCE hersteller_seq;
CREATE SEQUENCE fahrzeugarten_seq;
CREATE SEQUENCE fahrzeugtypen_seq;
CREATE SEQUENCE vorbestellungen_seq;




--löschen von Index
DROP INDEX bis_ind;


--erzeugen von Index absteigendsortiert
CREATE INDEX bis_ind
    ON ausleihen(bis);
SELECT * FROM ausleihen ORDER BY bis ASC;

COMMIT;