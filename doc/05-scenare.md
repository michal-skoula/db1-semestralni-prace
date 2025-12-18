## Testovací scénáře

Tato sekce dokumentace popisuje dva testovací scénáře demonstrující praktické použití databázového systému pro správu zoologické zahrady.

> **Poznámka:** Výsledky dotazů v tabulkách mohou být upraveny pro lepší čitelnost - některé sloupce jsou vynechány a počet řádků může být omezen.

---

### Scénář 1: Příchod nového zvířete do ZOO

Tento scénář simuluje proces přijetí nového zvířete - zebry jménem Márty - do zoologické zahrady. Zahrnuje výběr vhodného výběhu, registraci zvířete a přiřazení ošetřovatele.

#### Krok 1: Výběr vhodného výběhu

Nejprve zjistíme, jaké výběhy jsou v zoo k dispozici.

```postgresql
SELECT * FROM habitats;
```

| id | name |
|----|------|
| 1 | Africká savana |
| 2 | Tropický pavilon |
| 3 | Severský výběh |
| 4 | Ptačí dům |
| 5 | Noční pavilon |
| 6 | Akvárium |
| 7 | Pouštní expozice |
| 8 | Dětská zoo |
| 9 | Horský výběh |
| 10 | Zázemí |

Pro zebru je nejvhodnější **Africká savana** (id 1).

#### Krok 2: Vložení nového zvířete

Zaregistrujeme zebru Márty do systému s přiřazením do vybraného výběhu.

```postgresql
INSERT INTO animals (habitat_id, name, species, born_at)
VALUES (1, 'Márty', 'Zebra Grévyho', '2018-10-02');
```

#### Krok 3: Ověření vložení záznamu

Zkontrolujeme, zda bylo zvíře správně přidáno.

```postgresql
SELECT id, name, lower(species) FROM animals
WHERE name LIKE '%Márty%';
```

| id | name | species |
|----|------|---------|
| 11 | Márty | zebra grévyho |

#### Krok 4: Hledání vhodného ošetřovatele

Nejprve zjistíme, zda jsou k dispozici ošetřovatelé bez přiřazených zvířat.

```postgresql
SELECT id, full_name, info FROM v_caretakers_without_animals;
```

| id | full_name | info |
|----|-----------|------|
| 2 | Petra Svobodová | Specialistka na plazy |
| 6 | Eva Procházková | Krmení ptactva |

Volní ošetřovatelé jsou specialisté na plazy a ptactvo, což není vhodné pro zebru. Rozšíříme proto vyhledávání na ošetřovatele s nízkou vytížeností.

```postgresql
SELECT id, full_name, info, managed_animals_count
FROM v_caretaker_responsibilities
WHERE managed_animals_count <= 2
ORDER BY managed_animals_count;
```

| id | full_name | info | managed_animals_count |
|----|-----------|------|-----------------------|
| 6 | Eva Procházková | Krmení ptactva | 0 |
| 2 | Petra Svobodová | Specialistka na plazy | 0 |
| 7 | Pavel Beneš | Expert na africké savce a hmyz | 2 |
| 8 | Alena Horáková | Administrativa | 2 |
| 5 | Martin Černý | | 2 |

**Pavel Beneš** (id 7) je expert na africké savce s pouze dvěma přiřazenými zvířaty - ideální kandidát.

#### Krok 5: Přiřazení ošetřovatele ke zvířeti

```postgresql
INSERT INTO animal_caretaker (animal_id, caretaker_id)
VALUES (11, 7);
```

#### Krok 6: Kontrola výsledku operace

Ověříme, že přiřazení proběhlo správně.

```postgresql
SELECT caretaker_name, managed_animal_name, managed_animal_species
FROM v_caretakers_with_animals
WHERE managed_animal_name = 'Márty';
```

| caretaker_name | managed_animal_name | managed_animal_species |
|----------------|---------------------|------------------------|
| Pavel Beneš | Márty | Zebra Grévyho |

Zebra Márty byla úspěšně přidána do zoo a přiřazena ošetřovateli Pavlu Benešovi.

---

### Scénář 2: Krmení zvířete a následné veterinární ošetření

Tento scénář simuluje běžný pracovní den - krmení zvířete, při kterém je objevena zdravotní komplikace vyžadující veterinární zákrok.

#### Krok 1: Výběr ošetřovatele pro krmení

Hledáme volného ošetřovatele, který může provést krmení.

```postgresql
SELECT id, full_name, info FROM v_caretakers_without_animals;
```

| id | full_name | info |
|----|-----------|------|
| 2 | Petra Svobodová | Specialistka na plazy |
| 6 | Eva Procházková | Krmení ptactva |

Nejzkušenější s krmením je **Eva Procházková** (id 6).

#### Krok 2: Identifikace zvířat vyžadujících krmení

Vyhledáme zvířata, která nebyla krmena více než 20 dní nebo nemají žádný záznam o krmení.

```postgresql
SELECT a.id, a.name, a.species, f.fed_at
FROM animals a
LEFT JOIN feeding_events f ON f.animal_id = a.id
WHERE fed_at < current_date - interval '20 days' OR fed_at IS NULL
ORDER BY fed_at
LIMIT 5;
```

| id | name | species | last_fed |
|----|------|---------|----------|
| 1 | Simba | Lev africký | 2025-09-24 |
| 2 | Nala | Lvice | 2025-09-24 |
| 3 | Nanuq | Lední medvěd | 2025-09-29 |
| 4 | Azura | Leguán zelený | 2025-10-09 |
| 5 | Kiki | Ara ararauna | 2025-10-14 |

**Simba** (id 1) je nejdéle bez krmení.

#### Krok 3: Výběr vhodného krmiva

Pro lva hledáme masité krmivo s dostatečnou zásobou.

```postgresql
SELECT id, lower(name) AS name, qty_available
FROM feed_items
WHERE name LIKE '%maso%'
ORDER BY qty_available DESC;
```

| id | name | qty_available |
|----|------|---------------|
| 1 | hovězí maso | 500 |
| 2 | kuřecí maso | 300 |

**Hovězí maso** (id 1) má nejvyšší zásobu.

#### Krok 4: Provedení krmení a aktualizace skladu

Operace je provedena v transakci pro zajištění konzistence dat.

```postgresql
BEGIN;

INSERT INTO feeding_events (animal_id, caretaker_id, feed_item_id, fed_at, feed_item_qty_used, notes)
VALUES (1, 6, 1, now(), 40, 'Při krmení nalezena zanícená rána na krku');

UPDATE feed_items
SET qty_available = qty_available - 40
WHERE id = 1;

COMMIT;
```

#### Krok 5: Ověření výsledků krmení

```postgresql
SELECT fed_at, feed_type_name, qty_used, feeding_notes
FROM v_feeding_event_detail
WHERE animal_name = 'Simba'
ORDER BY fed_at DESC
LIMIT 1;
```

| fed_at | feed_type_name | qty_used | feeding_notes |
|--------|----------------|----------|---------------|
| 2025-12-18 | Hovězí maso | 40 | Při krmení nalezena zanícená rána na krku |

Při krmení byla nalezena zdravotní komplikace, kterou je třeba řešit.

#### Krok 6: Výběr veterináře

Hledáme nejzkušenějšího ošetřovatele podle počtu provedených ošetření.

```postgresql
SELECT c.id, c.full_name, COUNT(t.id) AS treatment_count
FROM v_caretakers_full_name c
LEFT JOIN treatments t ON t.caretaker_id = c.id
GROUP BY c.id, c.full_name
ORDER BY treatment_count DESC
LIMIT 1;
```

| id | full_name | treatment_count |
|----|-----------|-----------------|
| 4 | Lucie Králová | 9 |

**Lucie Králová** (id 4) má nejvíce provedených ošetření.

#### Krok 7: Kontrola dostupnosti léčiv

Pro ošetření rány je zapotřebí sedativum a dezinfekce.

```postgresql
SELECT id, name, qty_available
FROM medications
WHERE lower(name) LIKE '%sedativ%' OR lower(name) LIKE '%dezinfek%'
ORDER BY name;
```

| id | name | qty_available |
|----|------|---------------|
| 6 | Dezinfekce F | 80 |
| 3 | Sedativum C | 20 |
| 10 | Sedativum J | 0 |

**Sedativum C** (id 3) a **Dezinfekce F** (id 6) jsou skladem.

#### Krok 8: Provedení veterinárního zákroku

Celý zákrok je proveden v jedné transakci. Bez uspání nelze provést dezinfekci - při selhání dojde k rollbacku celé operace.

```postgresql
BEGIN;

-- Uspání zvířete
INSERT INTO treatments (animal_id, caretaker_id, medication_id, administered_at, medication_qty_used, notes)
VALUES (1, 4, 3, now(), 1, 'Uspání před ošetřením rány');

UPDATE medications
SET qty_available = qty_available - 1
WHERE id = 3;

-- Dezinfekce rány (10 minut po uspání)
INSERT INTO treatments (animal_id, caretaker_id, medication_id, administered_at, medication_qty_used, notes)
VALUES (1, 4, 6, now() + interval '10 minutes', 2, 'Dezinfekce zanícené rány na krku');

UPDATE medications
SET qty_available = qty_available - 2
WHERE id = 6;

COMMIT;
```

#### Krok 9: Ověření provedených zákroků

```postgresql
SELECT administered_at, medication_name, procedure_notes
FROM v_treatments_detail
WHERE animal_name = 'Simba'
ORDER BY administered_at DESC
LIMIT 2;
```

| administered_at | medication_name | procedure_notes |
|-----------------|-----------------|-----------------|
| 2025-12-18 14:10 | Dezinfekce F | Dezinfekce zanícené rány na krku |
| 2025-12-18 14:00 | Sedativum C | Uspání před ošetřením rány |

Lev Simba byl úspěšně nakrmen a ošetřen. Oba zákroky (uspání i dezinfekce) proběhly v rámci jedné transakce.
