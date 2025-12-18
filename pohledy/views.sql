-- Helper view to not retype the concatenation every time
CREATE VIEW v_caretakers_full_name AS
SELECT
    *,
    concat(first_name, ' ', last_name) AS full_name
FROM caretakers;

-- Animals with their habitats
CREATE VIEW v_animals_with_habitat AS
SELECT
    a.id,
    a.name,
    a.species,
    a.born_at,
    h.name as habitat_name,
    h.description as habitat_description
FROM animals a
LEFT JOIN habitats h
    ON a.habitat_id = h.id;

-- List of all caretakers and assigned animals, including those that currently have none
CREATE VIEW v_caretakers_with_animals AS
SELECT
    c.id as caretaker_id,
    c.full_name as caretaker_name,
    c.info as caretaker_info,
    c.email,
    c.phone,
    a.name as managed_animal_name,
    a.species as managed_animal_species,
    h.name as animal_habitat_name
FROM v_caretakers_full_name c
LEFT JOIN animal_caretaker ac
    ON c.id = ac.caretaker_id
LEFT JOIN animals a
    ON a.id = ac.animal_id
LEFT JOIN habitats h
    ON h.id = a.habitat_id;


-- List of caretakers who currently don't care for any animals (see who is available for work)
CREATE VIEW v_caretakers_without_animals AS
SELECT
    caretaker_id as id,
    caretaker_name as full_name,
    email,
    phone,
    caretaker_info as info
FROM v_caretakers_with_animals
WHERE managed_animal_name IS NULL;


-- All caretakers and their "responsibility load"
CREATE VIEW v_caretaker_responsibilities AS
SELECT
    c.id,
    c.full_name,
    c.info,
    COUNT(ac.caretaker_id) as managed_animals_count
FROM v_caretakers_full_name c
LEFT JOIN animal_caretaker ac
    ON ac.caretaker_id = c.id
GROUP BY
    c.id,
    c.full_name,
    c.info;


-- List of all administered treatments, treated animal and responsible caretaker
CREATE VIEW v_treatments_detail AS
SELECT
    t.id as treatment_id,
    t.administered_at,
    t.medication_qty_used,
    m.name as medication_name,
    t.notes as procedure_notes,
    c.full_name as caretaker_name,
    a.name as animal_name,
    a.species as animal_species,
    a.born_at as animal_born_at
FROM treatments t
INNER JOIN animals a
    ON t.animal_id = a.id
INNER JOIN v_caretakers_full_name c
    ON t.caretaker_id = c.id
INNER JOIN medications m
    ON t.medication_id = m.id;

-- List of all feeding events, animal being fed and responsible caretaker
CREATE VIEW v_feeding_event_detail AS
SELECT
    f.id as feeding_event_id,
    f.fed_at,
    i.name as feed_type_name,
    f.feed_item_qty_used as qty_used,
    f.notes as feeding_notes,
    c.full_name as caretaker_name,
    a.name as animal_name,
    a.species as animal_species,
    a.born_at as animal_born_at
FROM feeding_events f
INNER JOIN animals a
    ON f.animal_id = a.id
INNER JOIN v_caretakers_full_name c
    ON f.caretaker_id = c.id
INNER JOIN feed_items i
    ON f.feed_item_id = i.id