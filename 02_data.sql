-- 1. USERS DATA (utilizatori)

INSERT INTO utilizatori (id_utilizator, nume, prenume, buget_lunar_maxim)
VALUES (seq_utilizatori.NEXTVAL, 'Plamuti', 'Elena-Cristina',2400);
INSERT INTO utilizatori (id_utilizator, nume, prenume, buget_lunar_maxim)
VALUES (seq_utilizatori.NEXTVAL, 'Popescu', 'Maria',2000);
INSERT INTO utilizatori (id_utilizator, nume, prenume, buget_lunar_maxim)
VALUES (seq_utilizatori.NEXTVAL, 'Ionescu', 'Mihaela',1800);
INSERT INTO utilizatori (id_utilizator, nume, prenume, buget_lunar_maxim)
VALUES (seq_utilizatori.NEXTVAL, 'Radu', 'Andrei',2200);
INSERT INTO utilizatori (id_utilizator, nume, prenume, buget_lunar_maxim)
VALUES (seq_utilizatori.NEXTVAL, 'Dumitrescu', 'Ana',1500);
INSERT INTO utilizatori (id_utilizator, nume, prenume, buget_lunar_maxim)
VALUES (seq_utilizatori.NEXTVAL, 'Stan', 'Florin',2500);


-- 2. CATEGORIES DATA (categorii)

INSERT INTO categorii (id_categorie, denumire) VALUES (seq_categorii.NEXTVAL, 'Salariu');
INSERT INTO categorii (id_categorie, denumire) VALUES (seq_categorii.NEXTVAL, 'Chirie');
INSERT INTO categorii (id_categorie, denumire) VALUES (seq_categorii.NEXTVAL, 'Transport');
INSERT INTO categorii (id_categorie, denumire) VALUES (seq_categorii.NEXTVAL, 'Mancare');
INSERT INTO categorii (id_categorie, denumire) VALUES (seq_categorii.NEXTVAL, 'Facturi');


-- 3. INCOME DATA (venituri)

INSERT INTO venituri (id_venit, id_utilizator, id_categorie, data_venit, suma)
VALUES (seq_venituri.NEXTVAL, 1, 1, TO_DATE('2025-12-01','YYYY-MM-DD'), 2500);
INSERT INTO venituri (id_venit, id_utilizator, id_categorie, data_venit, suma)
VALUES (seq_venituri.NEXTVAL, 2, 1, TO_DATE('2025-12-05','YYYY-MM-DD'), 2000);
INSERT INTO venituri (id_venit, id_utilizator, id_categorie, data_venit, suma)
VALUES (seq_venituri.NEXTVAL, 3, 1, TO_DATE('2025-12-07','YYYY-MM-DD'), 2200);
INSERT INTO venituri (id_venit, id_utilizator, id_categorie, data_venit, suma)
VALUES (seq_venituri.NEXTVAL, 4, 1, TO_DATE('2025-12-05','YYYY-MM-DD'), 3000);
INSERT INTO venituri (id_venit, id_utilizator, id_categorie, data_venit, suma)
VALUES (seq_venituri.NEXTVAL, 5, 1, TO_DATE('2025-12-06','YYYY-MM-DD'), 2800);
INSERT INTO venituri (id_venit, id_utilizator, id_categorie, data_venit, suma)
VALUES (seq_venituri.NEXTVAL, 6, 1, TO_DATE('2025-12-07','YYYY-MM-DD'), 2600);


-- 4. EXPENSES DATA (cheltuieli)

INSERT INTO cheltuieli (id_cheltuiala, id_utilizator, id_categorie, data_cheltuiala, suma)
VALUES (seq_cheltuieli.NEXTVAL, 1, 2, TO_DATE('2025-12-02','YYYY-MM-DD'), 1200);
INSERT INTO cheltuieli (id_cheltuiala, id_utilizator, id_categorie, data_cheltuiala, suma)
VALUES (seq_cheltuieli.NEXTVAL, 1, 3, TO_DATE('2025-12-03','YYYY-MM-DD'), 150);
INSERT INTO cheltuieli (id_cheltuiala, id_utilizator, id_categorie, data_cheltuiala, suma)
VALUES (seq_cheltuieli.NEXTVAL, 1, 4, TO_DATE('2025-12-04','YYYY-MM-DD'), 600);
INSERT INTO cheltuieli (id_cheltuiala, id_utilizator, id_categorie, data_cheltuiala, suma)
VALUES (seq_cheltuieli.NEXTVAL, 1, 5, TO_DATE('2025-12-05','YYYY-MM-DD'), 120);
INSERT INTO cheltuieli (id_cheltuiala, id_utilizator, id_categorie, data_cheltuiala, suma)
VALUES (seq_cheltuieli.NEXTVAL, 2, 2, TO_DATE('2025-12-02','YYYY-MM-DD'), 700);
INSERT INTO cheltuieli (id_cheltuiala, id_utilizator, id_categorie, data_cheltuiala, suma)
VALUES (seq_cheltuieli.NEXTVAL, 2, 3, TO_DATE('2025-12-03','YYYY-MM-DD'), 180);
INSERT INTO cheltuieli (id_cheltuiala, id_utilizator, id_categorie, data_cheltuiala, suma)
VALUES (seq_cheltuieli.NEXTVAL, 2, 4, TO_DATE('2025-12-04','YYYY-MM-DD'), 500);
INSERT INTO cheltuieli (id_cheltuiala, id_utilizator, id_categorie, data_cheltuiala, suma)
VALUES (seq_cheltuieli.NEXTVAL, 2, 5, TO_DATE('2025-12-05','YYYY-MM-DD'), 200);
INSERT INTO cheltuieli (id_cheltuiala, id_utilizator, id_categorie, data_cheltuiala, suma)
VALUES (seq_cheltuieli.NEXTVAL, 3, 2, TO_DATE('2025-12-02','YYYY-MM-DD'), 600);
INSERT INTO cheltuieli (id_cheltuiala, id_utilizator, id_categorie, data_cheltuiala, suma)
VALUES (seq_cheltuieli.NEXTVAL, 3, 3, TO_DATE('2025-12-03','YYYY-MM-DD'), 120);
INSERT INTO cheltuieli (id_cheltuiala, id_utilizator, id_categorie, data_cheltuiala, suma)
VALUES (seq_cheltuieli.NEXTVAL, 3, 4, TO_DATE('2025-12-04','YYYY-MM-DD'), 700);
INSERT INTO cheltuieli (id_cheltuiala, id_utilizator, id_categorie, data_cheltuiala, suma)
VALUES (seq_cheltuieli.NEXTVAL, 3, 5, TO_DATE('2025-12-05','YYYY-MM-DD'), 150);
INSERT INTO cheltuieli (id_cheltuiala, id_utilizator, id_categorie, data_cheltuiala, suma)
VALUES (seq_cheltuieli.NEXTVAL, 4, 2, TO_DATE('2025-12-08','YYYY-MM-DD'), 1000);
INSERT INTO cheltuieli (id_cheltuiala, id_utilizator, id_categorie, data_cheltuiala, suma)
VALUES (seq_cheltuieli.NEXTVAL, 4, 4, TO_DATE('2025-12-09','YYYY-MM-DD'), 400);
INSERT INTO cheltuieli (id_cheltuiala, id_utilizator, id_categorie, data_cheltuiala, suma)
VALUES (seq_cheltuieli.NEXTVAL, 5, 2, TO_DATE('2025-12-08','YYYY-MM-DD'), 850);
INSERT INTO cheltuieli (id_cheltuiala, id_utilizator, id_categorie, data_cheltuiala, suma)
VALUES (seq_cheltuieli.NEXTVAL, 5, 5, TO_DATE('2025-12-10','YYYY-MM-DD'), 300);
INSERT INTO cheltuieli (id_cheltuiala, id_utilizator, id_categorie, data_cheltuiala, suma)
VALUES (seq_cheltuieli.NEXTVAL, 6, 2, TO_DATE('2025-12-08','YYYY-MM-DD'), 900);
INSERT INTO cheltuieli (id_cheltuiala, id_utilizator, id_categorie, data_cheltuiala, suma)
VALUES (seq_cheltuieli.NEXTVAL, 6, 3, TO_DATE('2025-12-11','YYYY-MM-DD'), 250);
INSERT INTO cheltuieli (id_cheltuiala, id_utilizator, id_categorie, data_cheltuiala, suma)
VALUES (seq_cheltuieli.NEXTVAL, 4, 1, TO_DATE('2025-12-01','YYYY-MM-DD'), 1200);
INSERT INTO cheltuieli (id_cheltuiala, id_utilizator, id_categorie, data_cheltuiala, suma)
VALUES (seq_cheltuieli.NEXTVAL, 4, 3, TO_DATE('2025-12-27','YYYY-MM-DD'), 25);
INSERT INTO cheltuieli (id_cheltuiala, id_utilizator, id_categorie, data_cheltuiala, suma)
VALUES (seq_cheltuieli.NEXTVAL, 4, 5, TO_DATE('2025-12-30','YYYY-MM-DD'), 300);

COMMIT;
