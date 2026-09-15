-- =================================================================
-- SECTION 1: ADVANCED REPORTING & ANALYTICAL QUERIES
-- =================================================================

-- 1. Filter income records by specific categories ('Salariu', 'Chirie') using JOINs
SELECT 
    v.id_venit, 
    u.nume, 
    u.prenume, 
    c.denumire AS categorie, 
    v.suma
FROM venituri v
JOIN utilizatori u ON v.id_utilizator = u.id_utilizator
JOIN categorii c ON v.id_categorie = c.id_categorie
WHERE c.denumire IN ('Salariu', 'Chirie');


-- 2. Aggregate expenses per user and filter total spending over 1000 RON
SELECT 
    u.nume, 
    u.prenume, 
    SUM(ch.suma) AS total_cheltuieli
FROM cheltuieli ch
JOIN utilizatori u ON ch.id_utilizator = u.id_utilizator
GROUP BY u.nume, u.prenume
HAVING SUM(ch.suma) > 1000;


-- 3. Retrieve income recorded within the last 25 days
SELECT *
FROM venituri
WHERE data_venit BETWEEN SYSDATE - 25 AND SYSDATE;


-- 4. Calculate total expenses by category, including categories with 0 recorded expenses (OUTER JOIN)
SELECT 
    c.denumire AS categorie, 
    NVL(SUM(ch.suma), 0) AS total_cheltuit
FROM categorii c
LEFT JOIN cheltuieli ch ON c.id_categorie = ch.id_categorie
GROUP BY c.denumire;


-- 5. Classify users based on total income using conditional CASE statements
SELECT 
    u.nume, 
    u.prenume, 
    SUM(v.suma) AS total_venit,
    CASE 
        WHEN SUM(v.suma) > 2200 THEN 'High Income'
        ELSE 'Standard'
    END AS clasificare_venit
FROM venituri v
JOIN utilizatori u ON v.id_utilizator = u.id_utilizator
GROUP BY u.nume, u.prenume;


-- 6. Expense aggregation using DECODE for category renaming
SELECT 
    DECODE(c.denumire, 'Mancare', 'Alimente', c.denumire) AS categorie,
    SUM(ch.suma) AS total_cheltuieli
FROM cheltuieli ch
JOIN categorii c ON ch.id_categorie = c.id_categorie
GROUP BY DECODE(c.denumire, 'Mancare', 'Alimente', c.denumire);


-- =================================================================
-- SECTION 2: SUBQUERIES & SET OPERATORS
-- =================================================================

-- 7. Subquery: Retrieve income for users whose total expenses exceed 1000 RON
SELECT v.*
FROM venituri v
WHERE v.id_utilizator IN (
    SELECT id_utilizator
    FROM cheltuieli
    GROUP BY id_utilizator
    HAVING SUM(suma) > 1000
);


-- 8. Set Operator (MINUS): Identify categories with recorded income but no expenses
SELECT DISTINCT id_categorie FROM venituri
MINUS
SELECT DISTINCT id_categorie FROM cheltuieli;


-- 9. Subquery: Find income entries higher than the overall dataset average
SELECT 
    u.nume, 
    u.prenume, 
    v.suma
FROM venituri v
JOIN utilizatori u ON v.id_utilizator = u.id_utilizator
WHERE v.suma > (SELECT AVG(suma) FROM venituri);


-- 10. Correlated Subquery: Find the earliest expense entry for each user
SELECT 
    u.nume,
    u.prenume,
    c.denumire AS categorie,
    ch.data_cheltuiala,
    ch.suma
FROM cheltuieli ch
JOIN utilizatori u ON u.id_utilizator = ch.id_utilizator
JOIN categorii c ON c.id_categorie = ch.id_categorie
WHERE ch.data_cheltuiala = (
    SELECT MIN(ch2.data_cheltuiala)
    FROM cheltuieli ch2
    WHERE ch2.id_utilizator = ch.id_utilizator
);


-- =================================================================
-- SECTION 3: DATE FUNCTIONS & DML OPERATIONS
-- =================================================================

-- 11. Extract month and format transaction dates
SELECT 
    id_venit, 
    id_utilizator, 
    id_categorie,
    TO_CHAR(data_venit, 'DD-MON-YYYY') AS data_formatata,
    EXTRACT(MONTH FROM data_venit) AS luna_tranzactie
FROM venituri;


-- 12. User spending history & time elapsed since oldest transaction
SELECT 
    u.nume, 
    u.prenume,
    SUM(ch.suma) AS total_cheltuieli,
    COUNT(ch.data_cheltuiala) AS numar_tranzactii,
    TRUNC(SYSDATE - MIN(ch.data_cheltuiala)) AS zile_de_la_prima_cheltuiala
FROM cheltuieli ch
JOIN utilizatori u ON ch.id_utilizator = u.id_utilizator
GROUP BY u.nume, u.prenume;


-- 13. Upsert Operation (MERGE): Insert or Update income records
MERGE INTO venituri v
USING (
    SELECT 
        1 AS id_utilizator,
        1 AS id_categorie,
        TO_DATE('2025-12-01','YYYY-MM-DD') AS data_venit,
        2700 AS suma
    FROM dual
) src
ON (v.id_utilizator = src.id_utilizator AND v.data_venit = src.data_venit)
WHEN MATCHED THEN
    UPDATE SET v.suma = src.suma
WHEN NOT MATCHED THEN
    INSERT (id_venit, id_utilizator, id_categorie, data_venit, suma)
    VALUES (seq_venituri.NEXTVAL, src.id_utilizator, src.id_categorie, src.data_venit, src.suma);

COMMIT;


-- =================================================================
-- SECTION 4: PL/SQL EXCEPTION HANDLING
-- =================================================================

-- 14. Custom User-Defined Exception: Validate transaction against monthly budget limit
DECLARE
    v_buget_max    utilizatori.buget_lunar_maxim%TYPE;
    v_suma_noua     NUMBER := 5000;
    ex_buget_depasit EXCEPTION;
BEGIN
    SELECT buget_lunar_maxim INTO v_buget_max
    FROM utilizatori
    WHERE id_utilizator = 1;
    
    IF v_suma_noua > v_buget_max THEN
        RAISE ex_buget_depasit;
    END IF;
    
    DBMS_OUTPUT.PUT_LINE('Transaction approved.');
EXCEPTION
    WHEN ex_buget_depasit THEN
        DBMS_OUTPUT.PUT_LINE('Alert: Amount exceeds your set budget limit of ' || v_buget_max || ' RON!');
END;
/

-- 15. Internal Oracle Exception Mapping: Catch CHECK constraint violation (-2290)
DECLARE
    ex_suma_invalida EXCEPTION;
    PRAGMA EXCEPTION_INIT(ex_suma_invalida, -2290);
BEGIN
    INSERT INTO cheltuieli (id_cheltuiala, id_utilizator, id_categorie, data_cheltuiala, suma)
    VALUES (seq_cheltuieli.NEXTVAL, 1, 1, SYSDATE, -100);
EXCEPTION
    WHEN ex_suma_invalida THEN
        DBMS_OUTPUT.PUT_LINE('Error: Negative expense amounts are strictly prohibited!');
END;
/

-- 16. Predefined Exception: Handle missing category records (NO_DATA_FOUND)
DECLARE
    v_denumire   categorii.denumire%TYPE;
    v_id_cautat  categorii.id_categorie%TYPE := 999;
BEGIN
    SELECT denumire INTO v_denumire
    FROM categorii
    WHERE id_categorie = v_id_cautat;
    
    DBMS_OUTPUT.PUT_LINE('Category found: ' || v_denumire);
EXCEPTION
    WHEN NO_DATA_FOUND THEN
        DBMS_OUTPUT.PUT_LINE('Error: Category ID ' || v_id_cautat || ' was not found.');
END;
/

-- 17. Predefined Exception: Handle multi-row return on single-row fetch (TOO_MANY_ROWS)
DECLARE
    v_data DATE;
BEGIN
    SELECT data_cheltuiala INTO v_data
    FROM cheltuieli
    WHERE id_utilizator = 1;
    
    DBMS_OUTPUT.PUT_LINE('Expense date: ' || v_data);
EXCEPTION
    WHEN TOO_MANY_ROWS THEN
        DBMS_OUTPUT.PUT_LINE('Error: User has multiple transactions. Query returned too many rows!');
END;
/


-- =================================================================
-- SECTION 5: CURSORS & ITERATIVE PROCESSING
-- =================================================================

-- 18. Implicit Cursor Attributes: Track updated rows during global budget adjustment
BEGIN
    SAVEPOINT sp_before_update;
    
    UPDATE utilizatori
    SET buget_lunar_maxim = buget_lunar_maxim * 1.1;
    
    IF SQL%FOUND THEN
        DBMS_OUTPUT.PUT_LINE('Success! Updated budget limits for ' || SQL%ROWCOUNT || ' users.');
    ELSE
        DBMS_OUTPUT.PUT_LINE('No user records updated.');
    END IF;
    
    ROLLBACK TO sp_before_update; -- Rollback to preserve original test data
END;
/

-- 19. Parameterless Explicit Cursor: Generate high-expense report (>1000 RON)
DECLARE
    CURSOR c_cheltuieli_mari IS
        SELECT u.nume, c.denumire, ch.suma
        FROM cheltuieli ch
        JOIN utilizatori u ON ch.id_utilizator = u.id_utilizator
        JOIN categorii c ON ch.id_categorie = c.id_categorie
        WHERE ch.suma > 1000
        ORDER BY ch.suma DESC;
BEGIN
    DBMS_OUTPUT.PUT_LINE('--- TOP EXPENSES REPORT (>1000 RON) ---');
    FOR v_rec IN c_cheltuieli_mari LOOP
        DBMS_OUTPUT.PUT_LINE(v_rec.nume || ' spent on ' || v_rec.denumire || ': ' || v_rec.suma || ' RON');
    END LOOP;
END;
/

-- 20. Parameterized Explicit Cursor & SYS_REFCURSOR: Dynamic user income inspection
DECLARE
    CURSOR c_sumar (p_id_utilizator NUMBER) IS
        SELECT COUNT(*) FROM venituri WHERE id_utilizator = p_id_utilizator;
        
    v_nr_venituri      NUMBER;
    v_cursor_detalii   SYS_REFCURSOR;
    v_denumire         categorii.denumire%TYPE;
    v_suma             venituri.suma%TYPE;
BEGIN
    OPEN c_sumar(1);
    FETCH c_sumar INTO v_nr_venituri;
    CLOSE c_sumar;
    
    DBMS_OUTPUT.PUT_LINE('User ID 1 has ' || v_nr_venituri || ' recorded income sources.');
    DBMS_OUTPUT.PUT_LINE('--- Income Details ---');
    
    OPEN v_cursor_detalii FOR
        SELECT c.denumire, v.suma
        FROM venituri v
        JOIN categorii c ON v.id_categorie = c.id_categorie
        WHERE v.id_utilizator = 1;
        
    LOOP
        FETCH v_cursor_detalii INTO v_denumire, v_suma;
        EXIT WHEN v_cursor_detalii%NOTFOUND;
        DBMS_OUTPUT.PUT_LINE('Income from ' || v_denumire || ': ' || v_suma || ' RON');
    END LOOP;
    
    CLOSE v_cursor_detalii;
END;
/


-- =================================================================
-- SECTION 6: DATABASE TRIGGERS
-- =================================================================

-- 21. BEFORE INSERT/UPDATE Trigger: Prevent recording future-dated transactions
CREATE OR REPLACE TRIGGER trg_valideaza_data_cheltuiala
BEFORE INSERT OR UPDATE ON cheltuieli
FOR EACH ROW
BEGIN
    IF :NEW.data_cheltuiala > SYSDATE THEN
        RAISE_APPLICATION_ERROR(-20001, 'Error: Expense date cannot be in the future!');
    END IF;
END;
/

-- 22. AFTER UPDATE Trigger: Audit historical user budget adjustments
CREATE OR REPLACE TRIGGER trg_audit_buget_utilizator
AFTER UPDATE OF buget_lunar_maxim ON utilizatori
FOR EACH ROW
BEGIN
    INSERT INTO audit_buget (id_audit, id_utilizator, buget_vechi, buget_nou, data_modificare, utilizator_db)
    VALUES (seq_audit_buget.NEXTVAL, :OLD.id_utilizator, :OLD.buget_lunar_maxim, :NEW.buget_lunar_maxim, SYSDATE, USER);
END;
/


-- =================================================================
-- SECTION 7: MODULAR PL/SQL PACKAGE
-- =================================================================

-- Package Specification
CREATE OR REPLACE PACKAGE pkg_gestiune_buget IS
    ex_buget_depasit EXCEPTION;
    
    FUNCTION get_procent_consumat(p_id_utilizator utilizatori.id_utilizator%TYPE) RETURN NUMBER;
    FUNCTION get_top_categorie(p_id_utilizator utilizatori.id_utilizator%TYPE) RETURN VARCHAR2;
    FUNCTION get_nr_tranzactii(p_id_utilizator utilizatori.id_utilizator%TYPE) RETURN NUMBER;
    
    PROCEDURE inregistreaza_tranzactie(
        p_id_u utilizatori.id_utilizator%TYPE,
        p_id_c categorii.id_categorie%TYPE,
        p_suma cheltuieli.suma%TYPE
    );
    PROCEDURE genereaza_raport_analitic(p_id_utilizator utilizatori.id_utilizator%TYPE);
END pkg_gestiune_buget;
/

-- Package Body
CREATE OR REPLACE PACKAGE BODY pkg_gestiune_buget IS

    FUNCTION get_procent_consumat(p_id_utilizator utilizatori.id_utilizator%TYPE) RETURN NUMBER IS
        v_buget_max       NUMBER;
        v_total_cheltuit  NUMBER;
    BEGIN
        SELECT buget_lunar_maxim INTO v_buget_max FROM utilizatori WHERE id_utilizator = p_id_utilizator;
        SELECT NVL(SUM(suma), 0) INTO v_total_cheltuit FROM cheltuieli WHERE id_utilizator = p_id_utilizator;
        RETURN ROUND((v_total_cheltuit / v_buget_max) * 100, 2);
    EXCEPTION
        WHEN OTHERS THEN RETURN 0;
    END get_procent_consumat;

    FUNCTION get_top_categorie(p_id_utilizator utilizatori.id_utilizator%TYPE) RETURN VARCHAR2 IS
        v_nume_cat VARCHAR2(100);
    BEGIN
        SELECT c.denumire INTO v_nume_cat
        FROM cheltuieli ch 
        JOIN categorii c ON ch.id_categorie = c.id_categorie
        WHERE ch.id_utilizator = p_id_utilizator
        GROUP BY c.denumire
        ORDER BY SUM(ch.suma) DESC
        FETCH FIRST 1 ROW ONLY;
        
        RETURN v_nume_cat;
    EXCEPTION
        WHEN NO_DATA_FOUND THEN RETURN 'No Data';
    END get_top_categorie;

    FUNCTION get_nr_tranzactii(p_id_utilizator utilizatori.id_utilizator%TYPE) RETURN NUMBER IS
        v_count NUMBER;
    BEGIN
        SELECT COUNT(*) INTO v_count FROM cheltuieli WHERE id_utilizator = p_id_utilizator;
        RETURN NVL(v_count, 0);
    EXCEPTION
        WHEN OTHERS THEN RETURN 0;
    END get_nr_tranzactii;

    PROCEDURE inregistreaza_tranzactie(
        p_id_u utilizatori.id_utilizator%TYPE, 
        p_id_c categorii.id_categorie%TYPE, 
        p_suma cheltuieli.suma%TYPE
    ) IS
        v_buget_max        NUMBER;
        v_total_existent   NUMBER;
    BEGIN
        SELECT buget_lunar_maxim INTO v_buget_max FROM utilizatori WHERE id_utilizator = p_id_u;
        SELECT NVL(SUM(suma), 0) INTO v_total_existent FROM cheltuieli WHERE id_utilizator = p_id_u;
        
        IF (v_total_existent + p_suma) > v_buget_max THEN
            RAISE ex_buget_depasit;
        END IF;
        
        INSERT INTO cheltuieli (id_cheltuiala, id_utilizator, id_categorie, data_cheltuiala, suma)
        VALUES (seq_cheltuieli.NEXTVAL, p_id_u, p_id_c, SYSDATE, p_suma);
        
        DBMS_OUTPUT.PUT_LINE('Transaction recorded successfully.');
    EXCEPTION
        WHEN ex_buget_depasit THEN
            DBMS_OUTPUT.PUT_LINE('Alert: Transaction of ' || p_suma || ' RON would exceed maximum allowed budget!');
    END inregistreaza_tranzactie;

    PROCEDURE genereaza_raport_analitic(p_id_utilizator utilizatori.id_utilizator%TYPE) IS
        v_nume      utilizatori.nume%TYPE;
        v_procent   NUMBER;
    BEGIN
        SELECT nume INTO v_nume FROM utilizatori WHERE id_utilizator = p_id_utilizator;
        v_procent := get_procent_consumat(p_id_utilizator);
        
        DBMS_OUTPUT.PUT_LINE('=== FINANCIAL ANALYSIS REPORT: ' || UPPER(v_nume) || ' ===');
        DBMS_OUTPUT.PUT_LINE('Total Transactions: ' || get_nr_tranzactii(p_id_utilizator));
        DBMS_OUTPUT.PUT_LINE('Budget Utilization: ' || v_procent || '%');
        DBMS_OUTPUT.PUT_LINE('Highest Expense Category: ' || get_top_categorie(p_id_utilizator));
        
        IF v_procent > 90 THEN
            DBMS_OUTPUT.PUT_LINE('DIAGNOSTIC: High Financial Risk!');
        ELSIF v_procent > 50 THEN
            DBMS_OUTPUT.PUT_LINE('DIAGNOSTIC: Moderate Spending.');
        ELSE
            DBMS_OUTPUT.PUT_LINE('DIAGNOSTIC: Budget Under Control.');
        END IF;
    END genereaza_raport_analitic;

END pkg_gestiune_buget;
/


-- =================================================================
-- SECTION 8: PACKAGE & TRIGGER VERIFICATION TESTS
-- =================================================================

-- Test Package Functions
DECLARE
    v_procent   NUMBER;
    v_cat       VARCHAR2(100);
    v_nr_tranz  NUMBER;
BEGIN
    v_procent  := pkg_gestiune_buget.get_procent_consumat(2);
    v_cat      := pkg_gestiune_buget.get_top_categorie(2);
    v_nr_tranz := pkg_gestiune_buget.get_nr_tranzactii(2);
    
    DBMS_OUTPUT.PUT_LINE('Calculated consumption: ' || v_procent || '%');
    DBMS_OUTPUT.PUT_LINE('Top spending category: ' || v_cat);
    DBMS_OUTPUT.PUT_LINE('Total transaction count: ' || v_nr_tranz);
END;
/

-- Test Package Procedures
BEGIN
    pkg_gestiune_buget.inregistreaza_tranzactie(1, 1, 10);
    pkg_gestiune_buget.inregistreaza_tranzactie(1, 1, 999999); -- Expected to trigger exception
    pkg_gestiune_buget.genereaza_raport_analitic(1);
END;
/

-- Test Audit Trigger Execution
UPDATE utilizatori SET buget_lunar_maxim = 7000 WHERE id_utilizator = 1;
SELECT * FROM audit_buget;
