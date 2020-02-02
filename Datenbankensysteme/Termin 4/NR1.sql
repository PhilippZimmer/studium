---------------------------- L?sung: Fahrzeugausleihe  ---------------------------------------------------------------------------------
----------------------------      Brumm & Br?der       ---------------------------------------------------------------------------------
---------------------------- im Wintersemester 2019/20 ---------------------------------------------------------------------------------
---------------------------------------------------------------------------------------------------------------------------------------- 10/2019 - aktualisiert von Maurice Bartoszewicz
----------------------------------------------------------------------------------------------------------------------------------------



--Pre - a) f?r das Wiederholte ausf?hren
DROP TABLE FTyp_Fuehrerscheinklasse CASCADE CONSTRAINTS;
DROP TABLE Fuehrerscheinklassen CASCADE CONSTRAINTS;
DROP TABLE Ausleihen CASCADE CONSTRAINTS;
DROP TABLE Vorbestellungen CASCADE CONSTRAINTS;
DROP TABLE Fahrzeuge CASCADE CONSTRAINTS;
DROP TABLE FahrzeugTypen CASCADE CONSTRAINTS;
DROP TABLE FahrzeugArten CASCADE CONSTRAINTS;
DROP TABLE Kunden CASCADE CONSTRAINTS;
DROP TABLE Person_Fuehrerscheinklasse CASCADE CONSTRAINTS;
DROP TABLE Hersteller CASCADE CONSTRAINTS;


--a) 
CREATE TABLE FTyp_Fuehrerscheinklasse (
       Typ_ID               	    NUMBER(9)   NOT NULL,
       KlassenKennung       	    VARCHAR2(3) NOT NULL,
       CONSTRAINT XPKFTyp_Fuehrerscheinklasse PRIMARY KEY (KlassenKennung, Typ_ID)
);

CREATE TABLE Person_Fuehrerscheinklasse (
       KlassenKennung               VARCHAR2(3) NOT NULL,
       PID                          NUMBER(9) NOT NULL,
       seit                         DATE NOT NULL,
       Bemerkungen                  VARCHAR2(2000) NULL
);

ALTER TABLE Person_Fuehrerscheinklasse
       ADD  ( CONSTRAINT XPKPerson_Fuehrerscheinklasse PRIMARY KEY (KlassenKennung, seit, PID) ) ;



CREATE TABLE Fuehrerscheinklassen (
       KlassenKennung           VARCHAR2(3)     PRIMARY KEY,
       Klassenbezeichnung       VARCHAR2(50)    NOT NULL,
       Beschreibung             VARCHAR2(2000)  NULL
);

CREATE TABLE Ausleihen (
       von                   DATE      NOT NULL,
       bis                   DATE      NOT NULL,
       KFZ_NR                NUMBER(9) NOT NULL,
       PID                   NUMBER(9) NOT NULL,
       VID                   NUMBER(9) NULL,
       CONSTRAINT XPKAusleihen PRIMARY KEY (von, bis, KFZ_NR, PID)
);

CREATE TABLE Vorbestellungen (
       VID                  NUMBER(9) PRIMARY KEY,
       PID                  NUMBER(9) NOT NULL,
       KFZ_NR               NUMBER(9) NOT NULL,
       von                  DATE      NOT NULL,
       bis                  DATE      NOT NULL
);

CREATE TABLE Fahrzeuge (
       KFZ_NR               	NUMBER(9)    PRIMARY KEY,
       Typ_ID               	NUMBER(9)    NOT NULL,
       Preis_pro_Tag        	NUMBER(6,2)  NOT NULL,
       gelaufene_KM         	NUMBER(7)    NULL,
       Nummernschild        	VARCHAR2(20) NOT NULL,
       naechste_HU          	DATE         NOT NULL,
       naechste_ASU         	DATE         NOT NULL,
       Farbe                	VARCHAR2(20) NULL,
       Klimaanlage          	VARCHAR2(20) NULL,
       angemeldet_am        	DATE         NOT NULL,
       abgemeldet_am        	DATE         NULL
);


CREATE TABLE FahrzeugTypen (
       Typ_ID               	NUMBER(9)    PRIMARY KEY,
       Art_ID               	NUMBER(9)    NOT NULL,
       HID                  	NUMBER(9)    NOT NULL,
       Typ_Bezeichner       	VARCHAR2(20) NOT NULL,
       Anzahl_Sitze         	NUMBER(3)    NULL,
       Anzahl_Tueren         	NUMBER(2)    NULL,
       zul_Gesamtgewicht    	NUMBER(8,2)  NOT NULL,
       zul_hoechstgeschw    	NUMBER(3)    NOT NULL
);

CREATE TABLE Hersteller (
       HID                  	NUMBER(9)    PRIMARY KEY,
       Hersteller_Name      	VARCHAR2(20) NOT NULL,
       Adresse              	VARCHAR2(20) NOT NULL
);


CREATE TABLE FahrzeugArten (
       Art_ID               	NUMBER(9)    PRIMARY KEY,
       Art_Bezeichner       	VARCHAR2(20) NOT NULL 
);

CREATE TABLE Kunden (
       PID                  NUMBER(9)    PRIMARY KEY,
       Name                 VARCHAR2(50) NOT NULL,
       Strasse              VARCHAR2(50) NOT NULL,
       Ort                  VARCHAR2(50) NOT NULL,
       PLZ                  NUMBER(8)    NOT NULL,
       Kontonummer          NUMBER(12)   NULL,
       BLZ                  NUMBER(8)    NULL
);



--b) Fremdschl?ssel

ALTER TABLE FTyp_Fuehrerscheinklasse
       ADD  ( CONSTRAINT hat_Fscheinklasse_fk
              FOREIGN KEY (KlassenKennung)
                            REFERENCES Fuehrerscheinklassen ) ;

ALTER TABLE FTyp_Fuehrerscheinklasse
       ADD  ( CONSTRAINT ist_FTypen_fk
              FOREIGN KEY (Typ_ID)
                             REFERENCES FahrzeugTypen ) ;

ALTER TABLE Person_Fuehrerscheinklasse
       ADD  ( CONSTRAINT hat_gemacht_fk
              FOREIGN KEY (PID)
                             REFERENCES Kunden  ON DELETE CASCADE 
					 	INITIALLY DEFERRED) ;

ALTER TABLE Person_Fuehrerscheinklasse
       ADD  ( CONSTRAINT wurde_gemacht_fk
              FOREIGN KEY (KlassenKennung)
                             REFERENCES Fuehrerscheinklassen) ;

ALTER TABLE Ausleihen
       ADD  ( CONSTRAINT leiht_aus_fk
              FOREIGN KEY (PID)
                             REFERENCES Kunden  ON DELETE CASCADE
						INITIALLY DEFERRED) ;

ALTER TABLE Ausleihen
       ADD  ( CONSTRAINT wird_ausgeliehen_fk
              FOREIGN KEY (KFZ_NR)
                             REFERENCES Fahrzeuge) ;
							 
ALTER TABLE Ausleihen
       ADD  ( CONSTRAINT mit_vorbestellung_fk
              FOREIGN KEY (VID)
                             REFERENCES Vorbestellungen	ON DELETE SET NULL
							INITIALLY DEFERRED) ;

ALTER TABLE Vorbestellungen
       ADD  ( CONSTRAINT bestellt_vor_fk
              FOREIGN KEY (PID)
                             REFERENCES Kunden  ON DELETE CASCADE
						INITIALLY DEFERRED) ;

ALTER TABLE Vorbestellungen
       ADD  ( CONSTRAINT wird_vorbestellt_fk
              FOREIGN KEY (KFZ_NR)
                             REFERENCES Fahrzeuge ) ;

ALTER TABLE Fahrzeuge
       ADD  ( CONSTRAINT typ_gilt_fuer_fk
              FOREIGN KEY (Typ_ID)
                             REFERENCES FahrzeugTypen ) ;

ALTER TABLE FahrzeugTypen
       ADD  ( CONSTRAINT art_gilt_fuer_fk
              FOREIGN KEY (Art_ID)
                             REFERENCES FahrzeugArten ) ;

ALTER TABLE FahrzeugTypen
       ADD  ( CONSTRAINT bietet_an_fk
              FOREIGN KEY (HID)
                             REFERENCES Hersteller ) ;




-- c) Sequenz
DROP SEQUENCE kund_seq;
DROP SEQUENCE vorb_seq;
DROP SEQUENCE fhart_seq;
DROP SEQUENCE ftyp_seq;
DROP SEQUENCE hers_seq;

CREATE SEQUENCE kund_seq;
CREATE SEQUENCE vorb_seq;
CREATE SEQUENCE fhart_seq;
CREATE SEQUENCE ftyp_seq;
CREATE SEQUENCE hers_seq;


-- d) Index

CREATE INDEX Ausl_bis_idx ON Ausleihen ( bis   DESC );

--Unterschied zu einem Eindeutigen (UNIQUE) Index:
--In "bis" d?rften dann keine gleichen Eintr?ge sein. 

--f) Nur einfuegen von vorher definierten Kuerzel -  DEFERRED
ALTER TABLE FUEHRERSCHEINKLASSEN 
    ADD CONSTRAINT kk_check CHECK(LOWER(KLASSENKENNUNG) IN ('a1', 'a', 'm', 't', 'c1', 'c', 'b', 'be')) INITIALLY DEFERRED;


--g) von-Datum soll zeitlich vor dem bis-Datum liegen - IMMEDIATE
ALTER TABLE VORBESTELLUNGEN
    ADD CONSTRAINT date_check CHECK(von<=bis) INITIALLY IMMEDIATE;



--  Datenbestand

INSERT INTO fahrzeugarten VALUES (1,'Limousine');
INSERT INTO fahrzeugarten VALUES (2,'Cabrio');
INSERT INTO fahrzeugarten VALUES (3,'Combi');
INSERT INTO fahrzeugarten VALUES (4,'KRAD');
INSERT INTO fahrzeugarten VALUES (5,'Leichtkrad');
INSERT INTO fahrzeugarten VALUES (6,'LKW');
COMMIT; 

INSERT INTO hersteller VALUES (1,'Audi','Ingelheim');
INSERT INTO hersteller VALUES (2,'Merceds Benz','Stuttgart');
INSERT INTO hersteller VALUES (3,'VW','Wolfsburg');
INSERT INTO hersteller VALUES (4,'Ford','K?ln');
INSERT INTO hersteller VALUES (5,'Opel','R?sselsheim');
COMMIT; 

INSERT INTO fahrzeugtypen VALUES (1,3,1,'A4 Avant',5,5,1500,205);
INSERT INTO fahrzeugtypen VALUES (2,2,2,'SLK 200',4,2,1200,225);
INSERT INTO fahrzeugtypen VALUES (3,1,1,'A3',5,3,1100,198);
INSERT INTO fahrzeugtypen VALUES (4,1,3,'Golf',5,3,1150,202);
INSERT INTO fahrzeugtypen VALUES (5,1,4,'Focus',5,3,1080,185);
INSERT INTO fahrzeugtypen VALUES (6,3,4,'Vektra',5,3,1996,200);
COMMIT; 

INSERT INTO fuehrerscheinklassen VALUES ('A1','Leichtkraftr?der',NULL);
INSERT INTO fuehrerscheinklassen VALUES ('A','Motorr?der',NULL);
INSERT INTO fuehrerscheinklassen VALUES ('M','Mofa','bla');
INSERT INTO fuehrerscheinklassen VALUES ('C1','Klein-LKW',NULL);
INSERT INTO fuehrerscheinklassen VALUES ('C','Gross-LKW',NULL);
INSERT INTO fuehrerscheinklassen VALUES ('B','PKW','blupp');
INSERT INTO fuehrerscheinklassen VALUES ('BE','PKW mit Anh?nger',NULL);
COMMIT; 

INSERT INTO ftyp_fuehrerscheinklasse VALUES (1,'B');
INSERT INTO ftyp_fuehrerscheinklasse VALUES (2,'B');
INSERT INTO ftyp_fuehrerscheinklasse VALUES (3,'B');
INSERT INTO ftyp_fuehrerscheinklasse VALUES (4,'B');
INSERT INTO ftyp_fuehrerscheinklasse VALUES (5,'B');
INSERT INTO ftyp_fuehrerscheinklasse VALUES (1,'BE');
INSERT INTO ftyp_fuehrerscheinklasse VALUES (2,'BE');
INSERT INTO ftyp_fuehrerscheinklasse VALUES (3,'BE');
INSERT INTO ftyp_fuehrerscheinklasse VALUES (4,'BE');
INSERT INTO ftyp_fuehrerscheinklasse VALUES (5,'BE');
INSERT INTO ftyp_fuehrerscheinklasse VALUES (6,'C');
INSERT INTO ftyp_fuehrerscheinklasse VALUES (6,'C1');
COMMIT; 

INSERT INTO kunden VALUES (1,'Meier, Hugo','Bremsweg 13','Braushausen',36909,01245780,37010050);
INSERT INTO kunden VALUES (2,'M?ller, Erna','Kriechspur 67','Kruvlingen',43677,0167894,27726699);
INSERT INTO kunden VALUES (3,'Schmidchen, Anton','Tempoweg 122','Fahrten',19556,09744223,7654321);
INSERT INTO kunden VALUES (4,'B?cker, Emma','Fahrgasse 43','Stoppheim',45889,0987655,1234567);
INSERT INTO kunden VALUES (5,'B?cker, Hugo','Fahrgasse 43','Stoppheim',45889,NULL, NULL);
COMMIT; 

INSERT INTO person_fuehrerscheinklasse VALUES ('B', 1,SYSDATE-100,NULL);
INSERT INTO person_fuehrerscheinklasse VALUES ('B', 2,SYSDATE-200,NULL);
INSERT INTO person_fuehrerscheinklasse VALUES ('B', 4,SYSDATE-400,NULL);
INSERT INTO person_fuehrerscheinklasse VALUES ('A', 1,SYSDATE-100,NULL);
INSERT INTO person_fuehrerscheinklasse VALUES ('A', 2,SYSDATE-150,NULL);
INSERT INTO person_fuehrerscheinklasse VALUES ('BE',2,SYSDATE-300,NULL);
INSERT INTO person_fuehrerscheinklasse VALUES ('B', 3,SYSDATE-300,NULL);
INSERT INTO person_fuehrerscheinklasse VALUES ('BE',3,SYSDATE-200,NULL);
INSERT INTO person_fuehrerscheinklasse VALUES ('A1',3,SYSDATE-250,NULL);
INSERT INTO person_fuehrerscheinklasse VALUES ('A', 3,SYSDATE-250,NULL);
INSERT INTO person_fuehrerscheinklasse VALUES ('C1',3,SYSDATE-250,NULL);
INSERT INTO person_fuehrerscheinklasse VALUES ('C', 3,SYSDATE-250,NULL);
INSERT INTO person_fuehrerscheinklasse VALUES ('M', 3,SYSDATE-500,NULL);
COMMIT; 




INSERT INTO fahrzeuge VALUES (1296833,1,98,123450,'GM-AL 455',SYSDATE+100,SYSDATE+100,'silber','JA. Automatisch',SYSDATE-10,NULL);
INSERT INTO fahrzeuge VALUES (2334556,2,139,160000,'GM-HG 34',SYSDATE+120,SYSDATE+120,'silber','JA. Automatisch',SYSDATE-90,NULL);
INSERT INTO fahrzeuge VALUES (9998767,3,56,152000,'GM-JK 980',SYSDATE-30,SYSDATE-30,'gelb','JA. Manuell',SYSDATE-160,SYSDATE);
INSERT INTO fahrzeuge VALUES (4567673,4,37,135000,'K-LM 2344',SYSDATE+55,SYSDATE+55,'blau','NEIN',SYSDATE-200,NULL);
INSERT INTO fahrzeuge VALUES (8968585,5,39,189000,'GM-LO 780',SYSDATE+10,SYSDATE+10,'rot','NEIN',SYSDATE-300,NULL);
INSERT INTO fahrzeuge VALUES (5696833,1,108,123450,'GM-LB 155',SYSDATE+100,SYSDATE+100,'silber','JA. Automatisch',SYSDATE-10,NULL);
INSERT INTO fahrzeuge VALUES (7834556,2,119,160000,'GL-HF 324',SYSDATE+120,SYSDATE+120,'silber','JA. Automatisch',SYSDATE-90,NULL);
INSERT INTO fahrzeuge VALUES (4498767,3,66,120000,'RS-ID 850',SYSDATE-30,SYSDATE-30,'gelb','JA. Manuell',SYSDATE-160,SYSDATE);
INSERT INTO fahrzeuge VALUES (2367673,4,57,135000,'K-DT 1244',SYSDATE+55,SYSDATE+55,'blau','NEIN',SYSDATE-200,NULL);
INSERT INTO fahrzeuge VALUES (4568585,5,59,089000,'GL-LR 180',SYSDATE+10,SYSDATE+10,'rot','NEIN',SYSDATE-300,NULL);
COMMIT; 

INSERT INTO vorbestellungen VALUES (vorb_seq.nextval,1,2334556,SYSDATE-52,SYSDATE-50);
INSERT INTO vorbestellungen VALUES (vorb_seq.nextval,2,9998767,SYSDATE-30,SYSDATE-29);
INSERT INTO vorbestellungen VALUES (vorb_seq.nextval,3,1296833,SYSDATE-12,SYSDATE-12);
INSERT INTO vorbestellungen VALUES (vorb_seq.nextval,4,8968585,SYSDATE-3,SYSDATE+5);
INSERT INTO vorbestellungen VALUES (vorb_seq.nextval,3,1296833,SYSDATE-1,SYSDATE+2);
INSERT INTO vorbestellungen VALUES (vorb_seq.nextval,1,7834556,SYSDATE+3,SYSDATE+7);
INSERT INTO vorbestellungen VALUES (vorb_seq.nextval,2,2334556,SYSDATE+10,SYSDATE+13);
INSERT INTO vorbestellungen VALUES (vorb_seq.nextval,3,5696833,SYSDATE+11,SYSDATE+12);
INSERT INTO vorbestellungen VALUES (vorb_seq.nextval,4,4567673,SYSDATE+20,SYSDATE+21);
INSERT INTO vorbestellungen VALUES (vorb_seq.nextval,2,7834556,SYSDATE+22,SYSDATE+22);
INSERT INTO vorbestellungen VALUES (vorb_seq.nextval,1,4498767,SYSDATE,SYSDATE+1);
INSERT INTO vorbestellungen VALUES (vorb_seq.nextval,2,2367673,SYSDATE,SYSDATE+2);
COMMIT;


INSERT INTO ausleihen VALUES (SYSDATE-52,SYSDATE-49,2334556,1,1);
INSERT INTO ausleihen VALUES (SYSDATE-30,SYSDATE-29,9998767,2,2);
INSERT INTO ausleihen VALUES (SYSDATE-14,SYSDATE-12,4498767,1,NULL);
INSERT INTO ausleihen VALUES (SYSDATE-19,SYSDATE-17,4498767,3,NULL);
INSERT INTO ausleihen VALUES (SYSDATE-16,SYSDATE-16,7834556,2,NULL);
INSERT INTO ausleihen VALUES (SYSDATE-12,SYSDATE-12,1296833,3,3);
INSERT INTO ausleihen VALUES (SYSDATE-1,SYSDATE+3,1296833,3,5);
INSERT INTO ausleihen VALUES (SYSDATE-13,SYSDATE-11,8968585,2,NULL);
INSERT INTO ausleihen VALUES (SYSDATE-3,SYSDATE+4,8968585,4,4);
INSERT INTO ausleihen VALUES (SYSDATE-8,SYSDATE-5,2367673,1,NULL);
INSERT INTO ausleihen VALUES (SYSDATE,SYSDATE+1,4498767,1,11);
INSERT INTO ausleihen VALUES (SYSDATE,SYSDATE+2,2367673,2,12);
INSERT INTO ausleihen VALUES (SYSDATE,SYSDATE+3,7834556,3,NULL);
INSERT INTO ausleihen VALUES (SYSDATE,SYSDATE+2,5696833,4,NULL);
INSERT INTO ausleihen VALUES (SYSDATE,SYSDATE+1,1296833,1,NULL);

COMMIT;


SELECT DISTINCT ausleihen.KFZ_NR, fahrzeuge.nummernschild, Status
FROM vorbestellungen, ausleihen, fahrzeuge
WHERE vorbestellungen.KFZ_NR = ausleihen.KFZ_NR
AND fahrzeuge.KFZ_NR = vorbestellungen.KFZ_NR;


SELECT fahrzeugtypen.typ_bezeichner, fahrzeuge.KFZ_NR, COUNT(fahrzeuge.typ_id) as Anzahl
FROM fahrzeuge, fahrzeugtypen
WHERE fahrzeuge.typ_id = fahrzeugtypen.typ_id
GROUP BY  fahrzeugtypen.typ_bezeichner, fahrzeuge.KFZ_NR
HAVING COUNT (*) > 1
ORDER BY fahrzeugtypen.typ_bezeichner DESC, fahrzeuge.KFZ_NR ASC;






