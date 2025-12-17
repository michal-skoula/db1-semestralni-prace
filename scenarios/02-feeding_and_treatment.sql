-- Scénář 2: Krmení zvířete a následné veterinární ošetření
-- Demonstrace krmení, při kterém je objevena zdravotní komplikace.
-- Scénář ukazuje práci s transakcemi a aktualizaci skladových zásob.


-- Krok 1: Výběr ošetřovatele pro krmení
-- Hledáme nejméně vytíženého ošetřovatele.

SELECT * FROM v_caretakers_without_animals;

-- K dispozici je Eva (id 6).


-- Krok 2: Identifikace zvířat vyžadujících krmení
-- Vyhledáme zvířata, která nebyla krmena více než 20 dní nebo nemají záznam.

SELECT
    a.id,
    a.name,
    a.species,
    f.fed_at
FROM animals a
LEFT JOIN feeding_events f ON f.animal_id = a.id
WHERE
    fed_at < current_date - interval '20 days' OR
    fed_at IS NULL
ORDER BY fed_at
LIMIT 5;

-- Simba (id 1) je nejdéle bez krmení.


-- Krok 3: Výběr vhodného krmiva
-- Pro lva hledáme masité krmivo s dostatečnou zásobou.

SELECT
    id,
    qty_available AS qty,
    lower(name) AS name
FROM feed_items
WHERE name LIKE '%maso%'
ORDER BY qty_available DESC;

-- Hovězí maso (id 1) má nejvyšší zásobu.


-- Krok 4: Provedení krmení a aktualizace skladu
-- Operace je provedena v transakci pro zajištění konzistence dat.

BEGIN;

INSERT INTO feeding_events (animal_id, caretaker_id, feed_item_id, fed_at, feed_item_qty_used, notes)
VALUES (1, 6, 1, now(), 40, 'Při krmení nalezena zanícená rána na krku');

UPDATE feed_items
SET qty_available = qty_available - 40
WHERE id = 1;

COMMIT;


-- Krok 5: Ověření výsledků krmení

SELECT * FROM v_feeding_event_detail WHERE animal_name = 'Simba' ORDER BY fed_at DESC LIMIT 1;
SELECT id, name, qty_available FROM feed_items WHERE id = 1;


-- Krok 6: Řešení zdravotní komplikace - výběr veterináře
-- Při krmení byla nalezena zanícená rána. Hledáme nejzkušenějšího ošetřovatele.

SELECT
    c.id,
    c.full_name,
    COUNT(t.id) AS treatment_count
FROM v_caretakers_full_name c
LEFT JOIN treatments t ON t.caretaker_id = c.id
GROUP BY c.id, c.full_name
ORDER BY treatment_count DESC
LIMIT 1;

-- Lucie (id 4) má nejvíce provedených ošetření.


-- Krok 7: Kontrola dostupnosti potřebných léčiv
-- Pro ošetření rány je zapotřebí sedativum a dezinfekce.

SELECT
    id,
    name,
    qty_available AS qty
FROM medications
WHERE lower(name) LIKE '%sedativ%' OR lower(name) LIKE '%dezinfek%'
ORDER BY name;

-- Sedativum C (id 3) a Dezinfekce F (id 6) jsou skladem.


-- Krok 8: Provedení veterinárního zákroku
-- Celý zákrok je proveden v jedné transakci, jelikož se jedná o jeden logický celek.
-- Bez uspání nelze provést dezinfekci, při selhání dojde k rollbacku.

BEGIN;

INSERT INTO treatments (animal_id, caretaker_id, medication_id, administered_at, medication_qty_used, notes)
VALUES (1, 4, 3, now(), 1, 'Uspání před ošetřením rány');

UPDATE medications
SET qty_available = qty_available - 1
WHERE id = 3;

INSERT INTO treatments (animal_id, caretaker_id, medication_id, administered_at, medication_qty_used, notes)
VALUES (1, 4, 6, now() + interval '10 minutes', 2, 'Dezinfekce zanícené rány na krku');

UPDATE medications
SET qty_available = qty_available - 2
WHERE id = 6;

COMMIT;


-- Krok 9: Ověření provedených zákroků

SELECT * FROM v_treatments_detail WHERE animal_name = 'Simba' ORDER BY administered_at DESC LIMIT 2;
