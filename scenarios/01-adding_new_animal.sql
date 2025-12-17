-- Scénář 1: Příchod nového zvířete do ZOO
-- Demonstrace přidání nového zvířete, výběru výběhu a přiřazení ošetřovatele.


-- Krok 1: Výběr vhodného výběhu pro novou zebru

SELECT * FROM habitats;


-- Krok 2: Vložení nového zvířete do systému
-- Pro zebru byl vybrán výběh Africká savana (id 1).

INSERT INTO animals (habitat_id, name, species, born_at)
VALUES (1, 'Márty', 'Zebra Grévyho', '2018-10-02');


-- Krok 3: Ověření vložení záznamu

SELECT id, name, lower(species) FROM animals
WHERE name LIKE '%Márty%';


-- Krok 4: Hledání vhodného ošetřovatele
-- Nejprve zjistíme, zda jsou k dispozici ošetřovatelé bez přiřazených zvířat.

SELECT id, full_name, info FROM v_caretakers_without_animals;

-- Volní ošetřovatelé jsou specialisté na plazy a ptactvo, což není vhodné pro zebru.
-- Rozšíříme vyhledávání na ošetřovatele s nízkou vytížeností.
-- Pavel (id 7) je expert na africké savce s pouze jedním přiřazeným zvířetem.

SELECT * FROM v_caretaker_responsibilities
WHERE managed_animals_count <= 2
ORDER BY managed_animals_count;


-- Krok 5: Přiřazení ošetřovatele ke zvířeti

INSERT INTO animal_caretaker (animal_id, caretaker_id)
VALUES (11, 7);


-- Krok 6: Kontrola výsledku operace

SELECT * FROM v_caretakers_with_animals
WHERE
    managed_animal_name = 'Márty' AND
    caretaker_name LIKE 'Pavel%';
