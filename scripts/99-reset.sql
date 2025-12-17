DROP VIEW IF EXISTS
    v_caretakers_without_animals,
    v_caretaker_responsibilities,
    v_feeding_event_detail,
    v_treatments_detail,
    v_caretakers_with_animals,
    v_caretakers_full_name
;

DROP TABLE IF EXISTS
    feeding_events,
    treatments,
    animal_caretaker,
    animals,
    caretakers,
    habitats,
    feed_items,
    medications
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
    idx_treatments_administered_at
;