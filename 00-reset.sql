DROP TABLE IF EXISTS
    animals,
    caretakers,
    habitats,
    feed_items,
    medications,
    feeding_events,
    treatments,
    animal_caretaker
;

DROP DOMAIN IF EXISTS
    phone_cz,
    mail
;

DROP INDEX IF EXISTS
    idx_animals_habitat,
    idx_feeding_events_animal,
    idx_feeding_events_caretaker,
    idx_feeding_events_feed_item,
    idx_treatments_animal,
    idx_treatments_caretaker,
    idx_treatments_medication,
    idx_animal_caretaker_animal,
    idx_animal_caretaker_caretaker,
    idx_feeding_events_fed_at,
    idx_treatments_administered_at;