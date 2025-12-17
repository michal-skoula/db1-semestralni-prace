DROP TABLE IF EXISTS animals;
DROP TABLE IF EXISTS caretakers;
DROP TABLE IF EXISTS habitats;
DROP TABLE IF EXISTS feed_items;
DROP TABLE IF EXISTS medications;
DROP TABLE IF EXISTS feeding_events;
DROP TABLE IF EXISTS treatments;
DROP TABLE IF EXISTS animal_caretaker;


CREATE TABLE animals
(
    id INT PRIMARY KEY GENERATED ALWAYS AS IDENTITY,
    name VARCHAR(100) NOT NULL,
    species VARCHAR(100) NOT NULL,
    habitat_id INT NOT NULL, -- TODO: add fk
    date_of_birth DATE NOT NULL
);

CREATE TABLE caretakers
(
    id INT PRIMARY KEY GENERATED ALWAYS AS IDENTITY,
    first_name VARCHAR(100) NOT NULL,
    last_name VARCHAR(100) NOT NULL,
    email VARCHAR(254) UNIQUE NOT NULL, -- TODO: regex for email
    phone VARCHAR(16) UNIQUE NOT NULL, -- TODO: regex for phone with country code enforcement
    info TEXT
);

CREATE TABLE habitats
(
    id INT PRIMARY KEY GENERATED ALWAYS AS IDENTITY,
    name VARCHAR(100) NOT NULL,
    description TEXT
);

CREATE TABLE feed_items
(
    id INT PRIMARY KEY GENERATED ALWAYS AS IDENTITY,
    name VARCHAR(100) NOT NULL,
    quantity INT NOT NULL CHECK (quantity >= 0), -- TODO: prevent creation of feed event when 0
    description TEXT
);

CREATE TABLE medications
(
    id INT PRIMARY KEY GENERATED ALWAYS AS IDENTITY,
    name VARCHAR(100) NOT NULL,
    instructions TEXT NOT NULL,
    description TEXT
);

CREATE TABLE feeding_events
(
    id INT PRIMARY KEY GENERATED ALWAYS AS IDENTITY,
    happened_at TIMESTAMP NOT NULL,
    animal_id INT NOT NULL, -- TODO: fk
    caretaker_id INT NOT NULL, -- TODO: fk
    feed_item_id INT NOT NULL, -- TODO: fk
    quantity NUMERIC(5, 3) NOT NULL CHECK (quantity > 0),
    unit VARCHAR(10) NOT NULL,
    notes TEXT
);

CREATE TABLE treatments
(
    id INT PRIMARY KEY GENERATED ALWAYS AS IDENTITY,
    happened_at TIMESTAMP NOT NULL,
    animal_id INT NOT NULL, -- TODO: fk
    caretaker_id INT NOT NULL, -- TODO: fk
    medication_id INT NOT NULL, -- TODO: fk
    quantity NUMERIC(5, 3) NOT NULL CHECK (quantity > 0),
    unit VARCHAR(10) NOT NULL,
    notes TEXT
);

CREATE TABLE animal_caretaker
(
    animal_id INT NOT NULL, -- TODO: fk
    caretaker_id INT NOT NULL, -- TODO: fk

    PRIMARY KEY (animal_id, caretaker_id)
);

-- TODO: add an animal_food pivot to tell which food is which and limit the events to it
-- TODO: add an animal_medicine pivot to tell which medicine is which and limit the events to it