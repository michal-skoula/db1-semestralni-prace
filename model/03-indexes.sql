-- =====================================================
-- Indexes for foreign keys
-- =====================================================

-- animals → habitats
CREATE INDEX idx_animals_habitat
ON animals (habitat_id);

-- feeding_events → animals / caretakers / feed_items
CREATE INDEX idx_feeding_events_animal
ON feeding_events (animal_id);

CREATE INDEX idx_feeding_events_caretaker
ON feeding_events (caretaker_id);

CREATE INDEX idx_feeding_events_feed_item
ON feeding_events (feed_item_id);

-- treatments → animals / caretakers / medications
CREATE INDEX idx_treatments_animal
ON treatments (animal_id);

CREATE INDEX idx_treatments_caretaker
ON treatments (caretaker_id);

CREATE INDEX idx_treatments_medication
ON treatments (medication_id);

-- animal_caretaker pivot table
CREATE INDEX idx_animal_caretaker_animal
ON animal_caretaker (animal_id);

CREATE INDEX idx_animal_caretaker_caretaker
ON animal_caretaker (caretaker_id);

-- =====================================================
-- Indexes for time-based queries
-- =====================================================

CREATE INDEX idx_feeding_events_fed_at
ON feeding_events (fed_at);

CREATE INDEX idx_treatments_administered_at
ON treatments (administered_at);