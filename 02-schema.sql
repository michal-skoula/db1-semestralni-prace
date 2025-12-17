CREATE TABLE caretakers
(
    id INT GENERATED ALWAYS AS IDENTITY,
    first_name VARCHAR(100) NOT NULL,
    last_name VARCHAR(100) NOT NULL,
    email email NOT NULL,
    phone phone_cz NOT NULL,
    info TEXT,

    CONSTRAINT pk_caretakers PRIMARY KEY (id),
    CONSTRAINT uq_caretakers_email UNIQUE (email),
    CONSTRAINT uq_caretakers_phone UNIQUE (phone)
);

CREATE TABLE habitats
(
    id INT GENERATED ALWAYS AS IDENTITY,
    name VARCHAR(100) NOT NULL,
    description TEXT,

    CONSTRAINT pk_habitats PRIMARY KEY (id),
    CONSTRAINT uq_habitats_name UNIQUE (name)
);

CREATE TABLE animals
(
    id INT GENERATED ALWAYS AS IDENTITY,
    habitat_id INT NOT NULL,
    name VARCHAR(100) NOT NULL,
    species VARCHAR(100) NOT NULL,
    born_at DATE NOT NULL,

    CONSTRAINT pk_animals PRIMARY KEY (id),
    CONSTRAINT fk_animals_habitat FOREIGN KEY (habitat_id) REFERENCES habitats(id)
);

CREATE TABLE feed_items
(
    id INT GENERATED ALWAYS AS IDENTITY,
    name VARCHAR(100) NOT NULL,
    qty_available INT NOT NULL, -- TODO: prevent creation of feed event when 0
    description TEXT,

    CONSTRAINT pk_feed_items PRIMARY KEY (id),
    CONSTRAINT uq_feed_items_name UNIQUE (name),

    CONSTRAINT ck_feed_items_qty_available_valid CHECK (qty_available >= 0)
);

CREATE TABLE medications
(
    id INT GENERATED ALWAYS AS IDENTITY,
    name VARCHAR(100) NOT NULL,
    instructions TEXT NOT NULL,
    qty_available INT NOT NULL, -- TODO: prevent creation of medication event when 0
    description TEXT,

    CONSTRAINT pk_medications PRIMARY KEY (id),
    CONSTRAINT uq_medications_name UNIQUE (name),

    CONSTRAINT ck_medications_qty_available_valid CHECK (qty_available >= 0)

);

CREATE TABLE feeding_events
(
    id INT GENERATED ALWAYS AS IDENTITY,
    animal_id INT NOT NULL,
    caretaker_id INT NOT NULL,
    feed_item_id INT NOT NULL,
    fed_at TIMESTAMP NOT NULL,
    feed_item_qty_used INT NOT NULL,
    notes TEXT,

    CONSTRAINT pk_feeding_events PRIMARY KEY (id),

    CONSTRAINT fk_feeding_events_animal FOREIGN KEY (animal_id) REFERENCES animals(id),
    CONSTRAINT fk_feeding_events_caretaker FOREIGN KEY (caretaker_id) REFERENCES caretakers(id),
    CONSTRAINT fk_feeding_events_feed_item FOREIGN KEY (feed_item_id) REFERENCES feed_items(id),

    CONSTRAINT ck_feeding_events_feed_item_qty_valid CHECK (feed_item_qty_used > 0)
);

CREATE TABLE treatments
(
    id INT GENERATED ALWAYS AS IDENTITY,
    animal_id INT NOT NULL,
    caretaker_id INT NOT NULL,
    medication_id INT NOT NULL,
    administered_at TIMESTAMP NOT NULL,
    medication_qty_used INT NOT NULL,
    notes TEXT,

    CONSTRAINT pk_treatments PRIMARY KEY (id),

    CONSTRAINT fk_treatments_animal FOREIGN KEY (animal_id) REFERENCES animals(id),
    CONSTRAINT fk_treatments_caretaker FOREIGN KEY (caretaker_id) REFERENCES caretakers(id),
    CONSTRAINT fk_treatments_medication FOREIGN KEY (medication_id) REFERENCES medications(id),

    CONSTRAINT ck_treatments_medication_qty_valid CHECK (medication_qty_used > 0)

);

CREATE TABLE animal_caretaker
(
    animal_id INT NOT NULL,
    caretaker_id INT NOT NULL,

    CONSTRAINT pk_animal_caretaker PRIMARY KEY (animal_id, caretaker_id),

    CONSTRAINT fk_animal_caretaker_animal FOREIGN KEY (animal_id) REFERENCES animals(id),
    CONSTRAINT fk_animal_caretaker_caretaker FOREIGN KEY (caretaker_id) REFERENCES caretakers(id)

);

-- TODO: add an animal_food pivot to tell which food is which and limit the events to it
-- TODO: add an animal_medicine pivot to tell which medicine is which and limit the events to it
-- TODO: figure out case insensitivity for names (?)