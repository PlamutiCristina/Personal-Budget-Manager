CREATE TABLE utilizatori (
    id_utilizator NUMBER(6) PRIMARY KEY,
    nume VARCHAR2(50) NOT NULL,
    prenume VARCHAR2(50) NOT NULL
);

CREATE TABLE categorii (
    id_categorie NUMBER(6) PRIMARY KEY,
    denumire VARCHAR2(50) NOT NULL
);


CREATE TABLE venituri (
    id_venit NUMBER(6) PRIMARY KEY,
    id_utilizator NUMBER(6) NOT NULL,
    id_categorie NUMBER(6) NOT NULL,
    data_venit DATE NOT NULL,
    suma NUMBER(10,2) CHECK (suma > 0),
    CONSTRAINT fk_venit_utilizator FOREIGN KEY (id_utilizator)
        REFERENCES utilizatori(id_utilizator),
    CONSTRAINT fk_venit_categorie FOREIGN KEY (id_categorie)
        REFERENCES categorii(id_categorie)
);

CREATE TABLE cheltuieli (
    id_cheltuiala NUMBER(6) PRIMARY KEY,
    id_utilizator NUMBER(6) NOT NULL,
    id_categorie NUMBER(6) NOT NULL,
    data_cheltuiala DATE NOT NULL,
    suma NUMBER(10,2) CHECK (suma > 0),
    CONSTRAINT fk_chelt_utilizator FOREIGN KEY (id_utilizator)
        REFERENCES utilizatori(id_utilizator),
    CONSTRAINT fk_chelt_categorie FOREIGN KEY (id_categorie)
        REFERENCES categorii(id_categorie)
);

CREATE TABLE audit_buget (
id_audit NUMBER(6) PRIMARY KEY,
id_utilizator NUMBER(6) NOT NULL,
buget_vechi NUMBER(10,2) NOT NULL,
buget_nou NUMBER(12,2),
data_modificare DATE NOT NULL,
utilizator_db VARCHAR2(50),
CONSTRAINT fk_audit_utilizator FOREIGN KEY (id_utilizator) REFERENCES utilizatori(id_utilizator)
);

CREATE SEQUENCE seq_utilizatori START WITH 1 INCREMENT BY 1;
CREATE SEQUENCE seq_categorii START WITH 1 INCREMENT BY 1;
CREATE SEQUENCE seq_venituri START WITH 1 INCREMENT BY 1;
CREATE SEQUENCE seq_cheltuieli START WITH 1 INCREMENT BY 1;
CREATE SEQUENCE seq_audit_buget START WITH 1 INCREMENT BY 1;

-----------------------------------------------------------------------

ALTER TABLE cheltuieli ADD CONSTRAINT chk_suma_chelt CHECK (suma > 0);
ALTER TABLE venituri ADD CONSTRAINT chk_suma_venit CHECK (suma > 0);
ALTER TABLE cheltuieli ADD descriere VARCHAR2(100);
ALTER TABLE utilizatori ADD buget_lunar_maxim NUMBER(10,2) DEFAULT 3000;
