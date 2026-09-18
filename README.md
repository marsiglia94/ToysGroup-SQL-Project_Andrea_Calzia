# ToysGroup SQL Project

Progetto finale dedicato alla progettazione e all'analisi di un database relazionale per il caso ToysGroup.

## Obiettivo

Il progetto modella le vendite di ToysGroup attraverso tre entità principali:

- Product
- Region
- Sales

Il lavoro comprende la progettazione del modello dati, la creazione e il popolamento del database, l'analisi tramite query SQL e l'applicazione di principi di Governance & Privacy.

## Tecnologie utilizzate

- MySQL
- MySQL Workbench
- SQL
- diagrams.net / draw.io
- GitHub
- Microsoft Word

## Struttura del database

Il database è composto da tre tabelle principali.

### Product
Contiene le informazioni relative ai prodotti:
- ProductID
- ProductCode
- ProductName
- Category
- PurchaseCost

### Region
Contiene le informazioni geografiche:
- RegionID
- State
- SalesRegion

### Sales
Contiene le transazioni di vendita:
- SalesID
- ProductID
- RegionID
- SalesDate
- Quantity
- SalesAmount

Le relazioni principali sono:

- Product 1:N Sales
- Region 1:N Sales

## Attività svolte

Il progetto comprende:

- progettazione concettuale del database;
- progettazione logica;
- creazione delle tabelle tramite DDL;
- popolamento dei dati;
- controllo di Primary Key e Foreign Key;
- INNER JOIN;
- aggregazioni con GROUP BY e HAVING;
- subquery;
- Common Table Expressions (CTE);
- Window Functions;
- RANK;
- totale progressivo;
- LAG;
- ricerca dei prodotti invenduti;
- creazione di VIEW;
- applicazione di principi di Governance & Privacy.

## File presenti

- `progetto SQL.sql`  
  Script SQL completo del progetto.

- `Relazione_ToysGroup_SQL.docx`  
  Relazione completa con descrizione del processo, diagrammi e risultati.

## Esecuzione

Lo script SQL può essere eseguito tramite MySQL Workbench.

Lo script:

1. elimina eventualmente il database ToysGroup esistente;
2. crea il database;
3. crea le tabelle;
4. inserisce i dati;
5. esegue le query richieste;
6. crea le VIEW;
7. implementa gli esempi relativi a Governance & Privacy.

## Autore

Andrea Calzia
