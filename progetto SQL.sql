/* =========================================================
   TOYSGROUP - ESERCITAZIONE FINALE MODULO 3

   Il progetto modella le vendite di ToysGroup attraverso
   le tabelle Product, Region e Sales.
   ========================================================= */

DROP DATABASE IF EXISTS ToysGroup;
CREATE DATABASE ToysGroup;
USE ToysGroup;


/* =========================================================
   TASK 1a - PROGETTAZIONE CONCETTUALE

   Lo schema Entità/Relazione è stato realizzato tramite
   diagrams.net e allegato alla documentazione del progetto.
   ========================================================= */


/* =========================================================
   TASK 1b - PROGETTAZIONE LOGICA

   Lo schema logico con colonne, tipi di dato, PK e FK
   è stato realizzato tramite diagrams.net e allegato
   alla documentazione del progetto.
   ========================================================= */
   
/* =========================================================
   TASK 2 - DDL: CREAZIONE DELLE TABELLE

   Domanda:
   Creare le tabelle Product, Region e Sales definendo
   chiavi primarie, chiavi esterne e tipi di dato.
   ========================================================= */

CREATE TABLE Product (
    ProductID INT PRIMARY KEY,
    ProductCode VARCHAR(20) NOT NULL,
    ProductName VARCHAR(100) NOT NULL,
    Category VARCHAR(50) NOT NULL,
    PurchaseCost DECIMAL(10,2) NOT NULL
);

CREATE TABLE Region (
    RegionID INT PRIMARY KEY,
    State VARCHAR(50) NOT NULL,
    SalesRegion VARCHAR(50) NOT NULL
);

CREATE TABLE Sales (
    SalesID INT PRIMARY KEY,
    ProductID INT NOT NULL,
    RegionID INT NOT NULL,
    SalesDate DATE NOT NULL,
    Quantity INT NOT NULL,
    SalesAmount DECIMAL(10,2) NOT NULL,

    FOREIGN KEY (ProductID)
        REFERENCES Product(ProductID),

    FOREIGN KEY (RegionID)
        REFERENCES Region(RegionID)
);





/* =========================================================
   TASK 3 - POPOLAMENTO DATI

   Domanda:
   Popolare le tabelle Product, Region e Sales con dati
   coerenti, rispettando le chiavi esterne.
   ========================================================= */

-- Inserimento prodotti
INSERT INTO Product
    (ProductID, ProductCode, ProductName, Category, PurchaseCost)
VALUES
    (1, 'BIKE-100', 'Speed Bike', 'Bikes', 120.00),
    (2, 'BIKE-200', 'Mountain Bike', 'Bikes', 180.00),
    (3, 'TOY-100', 'Robot Explorer', 'Electronic Toys', 35.00),
    (4, 'TOY-200', 'Remote Control Car', 'Electronic Toys', 28.00),
    (5, 'GAME-100', 'Board Game Deluxe', 'Board Games', 20.00);
    
-- Inserimento regioni
INSERT INTO Region
    (RegionID, State, SalesRegion)
VALUES
    (1, 'France', 'WestEurope'),
    (2, 'Germany', 'WestEurope'),
    (3, 'Italy', 'SouthEurope'),
    (4, 'Spain', 'SouthEurope');
    
    
-- Inserimento vendite
INSERT INTO Sales
    (SalesID, ProductID, RegionID, SalesDate, Quantity, SalesAmount)
VALUES
    (1, 1, 1, '2024-02-15', 2, 320.00),
    (2, 2, 2, '2024-05-10', 1, 250.00),
    (3, 3, 3, '2024-09-20', 4, 220.00),
    (4, 4, 4, '2024-12-05', 3, 180.00),

    (5, 1, 2, '2025-03-12', 3, 480.00),
    (6, 2, 3, '2025-06-18', 2, 500.00),
    (7, 3, 4, '2025-08-25', 5, 275.00),
    (8, 4, 1, '2025-11-14', 4, 240.00),

    (9, 1, 3, '2026-01-20', 4, 640.00),
    (10, 2, 4, '2026-04-08', 3, 750.00),
    (11, 3, 1, '2026-06-16', 6, 330.00),
    (12, 4, 2, '2026-09-01', 5, 300.00);
    
    
    /* =========================================================
   TASK 4a - INTEGRITÀ E JOIN
   ========================================================= */
   
   /* 4a.1
   Domanda:
   Verificare l'unicità delle chiavi primarie
   delle tabelle Product, Region e Sales.
*/

-- Controllo PK Product
SELECT ProductID, COUNT(*) AS Conteggio
FROM Product
GROUP BY ProductID
HAVING COUNT(*) > 1;

-- Controllo PK Region
SELECT RegionID, COUNT(*) AS Conteggio
FROM Region
GROUP BY RegionID
HAVING COUNT(*) > 1;

-- Controllo PK Sales
SELECT SalesID, COUNT(*) AS Conteggio
FROM Sales
GROUP BY SalesID
HAVING COUNT(*) > 1;

/* 4a.2
   Domanda:
   Mostrare per ogni transazione il codice prodotto,
   la categoria, lo stato, la regione di vendita
   e la data della vendita.
*/

SELECT
    s.SalesID,
    p.ProductCode,
    p.Category,
    r.State,
    r.SalesRegion,
    s.SalesDate
FROM Sales s
INNER JOIN Product p
    ON s.ProductID = p.ProductID
INNER JOIN Region r
    ON s.RegionID = r.RegionID;
    
/* 4a.3
   Domanda:
   Indicare se sono trascorsi più di 180 giorni
   dalla data della vendita.
*/

SELECT
    s.SalesID,
    p.ProductCode,
    p.Category,
    r.State,
    r.SalesRegion,
    s.SalesDate,

    -- Controlla se sono trascorsi più di 180 giorni dalla data di vendita:
    -- MySQL restituisce 1 se la condizione è vera e 0 se è falsa.
    (DATEDIFF(CURDATE(), s.SalesDate) > 180) AS OlderThan180Days

FROM Sales s
INNER JOIN Product p
    ON s.ProductID = p.ProductID
INNER JOIN Region r
    ON s.RegionID = r.RegionID;
     
    
-- Controllo del numero di record
SELECT COUNT(*) AS NumeroProdotti FROM Product;
SELECT COUNT(*) AS NumeroRegioni FROM Region;
SELECT COUNT(*) AS NumeroVendite FROM Sales;

/* Controllo richiesto:
   il numero di righe della JOIN deve coincidere
   con il numero di righe presenti in Sales.
*/

SELECT COUNT(*) AS NumeroVendite
FROM Sales;

SELECT COUNT(*) AS NumeroRigheDopoJoin
FROM Sales s
INNER JOIN Product p
    ON s.ProductID = p.ProductID
INNER JOIN Region r
    ON s.RegionID = r.RegionID;


/* Controllo aggiuntivo:
   verificare che non esistano vendite senza un prodotto
   o una regione corrispondente.
*/

SELECT s.SalesID
FROM Sales s
LEFT JOIN Product p
    ON s.ProductID = p.ProductID
LEFT JOIN Region r
    ON s.RegionID = r.RegionID
WHERE p.ProductID IS NULL
   OR r.RegionID IS NULL;
   
   
   /* =========================================================
   TASK 4b - AGGREGAZIONI E RAGGRUPPAMENTI
   ========================================================= */

/* 4b.1
   Domanda:
   Calcolare il fatturato totale per prodotto e per anno.
*/

SELECT
    ProductID,
    YEAR(SalesDate) AS Anno,
    SUM(SalesAmount) AS FatturatoTotale
FROM Sales
GROUP BY
    ProductID,
    YEAR(SalesDate)
ORDER BY
    ProductID,
    Anno;


/* 4b.2
   Domanda:
   Calcolare il fatturato totale per stato e per anno,
   ordinando per anno e fatturato decrescente.
*/

SELECT
    r.State,
    YEAR(s.SalesDate) AS Anno,
    SUM(s.SalesAmount) AS FatturatoTotale
FROM Sales s
INNER JOIN Region r
    ON s.RegionID = r.RegionID
GROUP BY
    r.State,
    YEAR(s.SalesDate)
ORDER BY
    Anno,
    FatturatoTotale DESC;


/* 4b.3
   Domanda:
   Individuare la categoria di prodotto più richiesta,
   misurata come quantità totale venduta.
*/

SELECT
    p.Category,
    SUM(s.Quantity) AS QuantitaTotaleVenduta
FROM Sales s
INNER JOIN Product p
    ON s.ProductID = p.ProductID
GROUP BY
    p.Category
HAVING SUM(s.Quantity) = (
    SELECT MAX(TotaleCategoria)
    FROM (
        SELECT
            p2.Category,
            SUM(s2.Quantity) AS TotaleCategoria
        FROM Sales s2
        INNER JOIN Product p2
            ON s2.ProductID = p2.ProductID
        GROUP BY
            p2.Category
    ) AS TotaliCategorie
);

/* =========================================================
   TASK 4c - SUBQUERY E CTE
   ========================================================= */

/* 4c.1
   Domanda:
   Calcolare la quantità media venduta per prodotto
   nell'ultimo anno censito.
*/

SELECT
    AVG(TotalePerProdotto) AS MediaQuantitaUltimoAnno
FROM (
    SELECT
        ProductID,
        SUM(Quantity) AS TotalePerProdotto
    FROM Sales
    WHERE YEAR(SalesDate) = (
        SELECT MAX(YEAR(SalesDate))
        FROM Sales
    )
    GROUP BY ProductID
) AS VenditePerProdotto;


/* 4c.2
   Domanda:
   Individuare i prodotti con quantità totale venduta
   superiore alla media dell'ultimo anno censito,
   utilizzando una subquery.
*/

SELECT
    p.ProductCode,
    vp.TotaleVenduto
FROM Product p
INNER JOIN (
    SELECT
        ProductID,
        SUM(Quantity) AS TotaleVenduto
    FROM Sales
    WHERE YEAR(SalesDate) = (
        SELECT MAX(YEAR(SalesDate))
        FROM Sales
    )
    GROUP BY ProductID
) AS vp
    ON p.ProductID = vp.ProductID
WHERE vp.TotaleVenduto > (
    SELECT AVG(TotalePerProdotto)
    FROM (
        SELECT
            ProductID,
            SUM(Quantity) AS TotalePerProdotto
        FROM Sales
        WHERE YEAR(SalesDate) = (
            SELECT MAX(YEAR(SalesDate))
            FROM Sales
        )
        GROUP BY ProductID
    ) AS MediaProdotti
);


/* 4c.3
   Domanda:
   Individuare i prodotti con quantità totale venduta
   superiore alla media dell'ultimo anno censito,
   utilizzando una CTE.
*/

WITH VenditeUltimoAnno AS (
    SELECT
        ProductID,
        SUM(Quantity) AS TotaleVenduto
    FROM Sales
    WHERE YEAR(SalesDate) = (
        SELECT MAX(YEAR(SalesDate))
        FROM Sales
    )
    GROUP BY ProductID
),

MediaVendite AS (
    SELECT
        AVG(TotaleVenduto) AS MediaQuantita
    FROM VenditeUltimoAnno
)

SELECT
    p.ProductCode,
    v.TotaleVenduto
FROM VenditeUltimoAnno v
INNER JOIN Product p
    ON v.ProductID = p.ProductID
CROSS JOIN MediaVendite m
WHERE v.TotaleVenduto > m.MediaQuantita;


/* =========================================================
   TASK 4d - WINDOW FUNCTIONS
   ========================================================= */

/* 4d.1
   Domanda:
   Assegnare a ogni prodotto una posizione in classifica
   per fatturato totale, all'interno della propria categoria,
   mantenendo una riga per ogni transazione.
*/

WITH TotaleProdotto AS (
    SELECT DISTINCT
        s.ProductID,
        p.Category,
        SUM(s.SalesAmount) OVER (
            PARTITION BY s.ProductID
        ) AS FatturatoTotale
    FROM Sales s
    INNER JOIN Product p
        ON s.ProductID = p.ProductID
),

ClassificaProdotti AS (
    SELECT
        ProductID,
        Category,
        FatturatoTotale,
        RANK() OVER (
            PARTITION BY Category
            ORDER BY FatturatoTotale DESC
        ) AS PosizioneCategoria
    FROM TotaleProdotto
)

SELECT
    s.SalesID,
    s.SalesDate,
    p.ProductCode,
    p.ProductName,
    p.Category,
    s.SalesAmount,
    c.FatturatoTotale,
    c.PosizioneCategoria
FROM Sales s
INNER JOIN Product p
    ON s.ProductID = p.ProductID
INNER JOIN ClassificaProdotti c
    ON s.ProductID = c.ProductID
ORDER BY
    p.Category,
    c.PosizioneCategoria,
    s.SalesDate;
    
    
/* 4d.2
   Domanda:
   Calcolare il fatturato progressivo nel tempo
   per ciascuna regione di vendita.
*/

SELECT
    s.SalesID,
    r.SalesRegion,
    s.SalesDate,
    s.SalesAmount,

    SUM(s.SalesAmount) OVER (
        PARTITION BY r.SalesRegion
        ORDER BY s.SalesDate, s.SalesID
        ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW
    ) AS FatturatoProgressivo

FROM Sales s
INNER JOIN Region r
    ON s.RegionID = r.RegionID

ORDER BY
    r.SalesRegion,
    s.SalesDate,
    s.SalesID;
    
    
/* 4d.3
   Domanda:
   Confrontare il fatturato di ogni transazione
   con quello della transazione precedente
   appartenente alla stessa regione di vendita.
*/

SELECT
    s.SalesID,
    r.SalesRegion,
    s.SalesDate,
    s.SalesAmount,

    LAG(s.SalesAmount) OVER (
        PARTITION BY r.SalesRegion
        ORDER BY s.SalesDate, s.SalesID
    ) AS FatturatoPrecedente

FROM Sales s
INNER JOIN Region r
    ON s.RegionID = r.RegionID

ORDER BY
    r.SalesRegion,
    s.SalesDate,
    s.SalesID;
    
    
/* =========================================================
   TASK 4e - PRODOTTI INVENDUTI E VIEW
   ========================================================= */

/* 4e.1
   Domanda:
   Individuare i prodotti che non sono mai stati venduti
   utilizzando un primo approccio.
*/

SELECT
    p.ProductID,
    p.ProductCode,
    p.ProductName,
    p.Category
FROM Product p
WHERE NOT EXISTS (
    SELECT 1
    FROM Sales s
    WHERE s.ProductID = p.ProductID
);


/* 4e.2
   Domanda:
   Individuare i prodotti che non sono mai stati venduti
   utilizzando un secondo approccio diverso dal primo.
*/

SELECT
    p.ProductID,
    p.ProductCode,
    p.ProductName,
    p.Category
FROM Product p
LEFT JOIN Sales s
    ON p.ProductID = s.ProductID
WHERE s.ProductID IS NULL;


/* 4e.3
   Domanda:
   Creare una vista dei prodotti che esponga
   codice prodotto, nome prodotto e categoria.
*/

CREATE VIEW vw_ProductInfo AS
SELECT
    ProductCode,
    ProductName,
    Category
FROM Product;

SELECT *
FROM vw_ProductInfo;


/* 4e.4
   Domanda:
   Creare una vista con le informazioni geografiche
   utili per l'analisi delle vendite per area.
*/

CREATE VIEW vw_RegionInfo AS
SELECT
    RegionID,
    State,
    SalesRegion
FROM Region;

SELECT *
FROM vw_RegionInfo;


/* =========================================================
   GOVERNANCE & PRIVACY APPLICATA
   ========================================================= */

/* CASO 1 - Vista pubblica per i rivenditori

   Problema:
   La vista espone PurchaseCost, informazione interna
   non necessaria ai rivenditori.

   Correzione:
   Applicare il principio del minimo privilegio,
   mostrando soltanto le informazioni necessarie.
*/

CREATE VIEW vw_ProdottiRivenditori AS
SELECT
    ProductID,
    ProductName,
    Category
FROM Product;

/* CASO 2 - Contatti dei fornitori

   Problema:
   La tabella contiene il numero di telefono dei fornitori
   ed è condivisa con il reparto Marketing, anche se tale
   informazione potrebbe non essere necessaria.

   Correzione:
   Limitare l'accesso ai dati di contatto e fornire al
   Marketing solamente le informazioni strettamente necessarie.
*/

CREATE TABLE SupplierContact (
    SupplierID INT PRIMARY KEY,
    Phone VARCHAR(20) NOT NULL
);

CREATE VIEW vw_MarketingSuppliers AS
SELECT
    SupplierID
FROM SupplierContact;

/* CASO 3 - Vista commerciale

   Problema:
   La vista espone PurchaseCost e Margin, informazioni
   economiche interne non necessarie a tutti gli utenti
   commerciali.

   Correzione:
   Esporre solamente le informazioni di vendita necessarie.
*/

CREATE VIEW vw_SalesCommerciale AS
SELECT
    SalesID,
    SalesAmount
FROM Sales;

/* CASO 4 - Log di reporting

   Problema:
   I log degli accessi vengono conservati senza una
   scadenza definita, causando una conservazione
   potenzialmente illimitata dei dati.

   Correzione:
   Definire una politica di retention e cancellare
   periodicamente i log più vecchi del periodo previsto.
*/

CREATE TABLE ReportAccessLog (
    LogID INT AUTO_INCREMENT PRIMARY KEY,
    UserID INT NOT NULL,
    QueryText TEXT NOT NULL,
    AccessDate DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP
);

-- Esempio di politica di retention: eliminazione dei log
-- con più di 90 giorni.
DELETE FROM ReportAccessLog
WHERE AccessDate < NOW() - INTERVAL 90 DAY;