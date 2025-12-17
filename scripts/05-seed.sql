INSERT INTO caretakers (first_name, last_name, email, phone, info) VALUES
('Jan', 'Novák', 'jan.novak@zoo.cz', '+420601123456', 'Vedoucí chovatel savců'),
('Petra', 'Svobodová', 'petra.svobodova@zoo.cz', '+420602234567', 'Specialistka na plazy'),
('Tomáš', 'Dvořák', 'tomas.dvorak@zoo.cz', '+420603345678', NULL),
('Lucie', 'Králová', 'lucie.kralova@zoo.cz', '+420604456789', 'Veterinární asistentka'),
('Martin', 'Černý', 'martin.cerny@zoo.cz', '+420605567890', NULL),
('Eva', 'Procházková', 'eva.prochazkova@zoo.cz', '+420606678901', 'Krmení ptactva'),
('Pavel', 'Beneš', 'pavel.benes@zoo.cz', '+420607789012', NULL),
('Alena', 'Horáková', 'alena.horakova@zoo.cz', '+420608890123', 'Administrativa'),
('Marek', 'Veselý', 'marek.vesely@zoo.cz', '+420609901234', NULL),
('Ivana', 'Malá', 'ivana.mala@zoo.cz', '+420610012345', 'Zástup za nemocné');

INSERT INTO habitats (name, description) VALUES
('Africká savana', 'Otevřený výběh pro africké savce'),
('Tropický pavilon', 'Vlhké prostředí pro plazy'),
('Severský výběh', 'Chladné klima'),
('Ptačí dům', NULL),
('Noční pavilon', 'Zvířata aktivní v noci'),
('Akvárium', 'Sladkovodní i mořské ryby'),
('Pouštní expozice', NULL),
('Dětská zoo', 'Kontaktní výběh'),
('Horský výběh', 'Kozorožci a kamzíci'),
('Zázemí', 'Neveřejná část zoo');

INSERT INTO animals (habitat_id, name, species, born_at) VALUES
(1, 'Simba', 'Lev africký', '2018-05-12'),
(1, 'Nala', 'Lvice', '2019-07-01'),
(3, 'Nanuq', 'Lední medvěd', '2016-11-02'),
(2, 'Azura', 'Leguán zelený', '2020-06-21'),
(4, 'Kiki', 'Ara ararauna', '2015-03-18'),
(6, 'Bublina', 'Rejnok', '2017-09-09'),
(7, 'Sahara', 'Fenek', '2021-01-30'),
(8, 'Míša', 'Koza domácí', '2014-04-14'),
(9, 'Roko', 'Kozorožec alpský', '2013-12-05'),
(5, 'Stín', 'Netopýr kaloně', '2022-08-10');

INSERT INTO feed_items (name, qty_available, description) VALUES
('Hovězí maso', 500, 'Pro šelmy'),
('Kuřecí maso', 300, NULL),
('Ryby mražené', 200, 'Losos, makrela'),
('Zelenina mix', 400, NULL),
('Ovoce mix', 350, 'Jablka, banány'),
('Granule savci', 600, NULL),
('Granule ptáci', 250, NULL),
('Hmyz sušený', 150, 'Cvrčci'),
('Seno', 1000, NULL),
('Listí', 0, 'Dočasně nedostupné');

INSERT INTO medications (name, instructions, qty_available, description) VALUES
('Antibiotikum A', '1x denně 5 dní', 50, NULL),
('Vitamínový doplněk B', 'Do krmiva', 120, 'Preventivní'),
('Sedativum C', 'Pouze veterinář', 20, NULL),
('Antiparazitikum D', 'Jednorázově', 35, NULL),
('Očkování E', 'Dle plánu', 15, 'Skladovat v chladu'),
('Dezinfekce F', 'Lokálně', 80, NULL),
('Analgetikum G', 'Podle váhy', 60, NULL),
('Rehydratační roztok H', 'Při dehydrataci', 40, NULL),
('Mast I', '2x denně', 25, NULL),
('Sedativum J', 'Krátkodobě', 0, 'Vyprodáno');

INSERT INTO feeding_events
(animal_id, caretaker_id, feed_item_id, fed_at, feed_item_qty_used, notes)
VALUES
(1, 3, 1, '2024-03-01 09:00', 5, NULL),
(2, 3, 1, '2024-03-01 09:10', 4, 'Menší porce'),
(3, 1, 3, '2024-03-01 10:00', 8, NULL),
(4, 2, 8, '2024-03-02 11:30', 2, 'Ruční krmení'),
(5, 6, 7, '2024-03-02 12:00', 1, NULL),
(6, 5, 3, '2024-03-02 13:00', 6, NULL),
(7, 7, 2, '2024-03-03 09:00', 3, NULL),
(8, 9, 9, '2024-03-03 10:15', 7, 'Děti přítomny'),
(9, 1, 9, '2024-03-03 11:00', 5, NULL),
(10, 10, 8, '2024-03-03 20:00', 1, 'Noční krmení');

INSERT INTO treatments
(animal_id, caretaker_id, medication_id, administered_at, medication_qty_used, notes)
VALUES
(1, 4, 2, '2024-02-20 08:30', 1, 'Preventivně'),
(2, 4, 5, '2024-02-21 09:00', 1, NULL),
(3, 4, 3, '2024-02-22 16:00', 1, 'Vyšetření'),
(4, 2, 1, '2024-02-23 10:15', 1, NULL),
(5, 4, 6, '2024-02-24 11:00', 1, 'Drobná rána'),
(6, 4, 7, '2024-02-25 12:30', 2, NULL),
(7, 4, 4, '2024-02-26 09:45', 1, NULL),
(8, 4, 8, '2024-02-27 14:00', 1, 'Dehydratace'),
(9, 4, 2, '2024-02-28 08:20', 1, NULL),
(10, 4, 3, '2024-03-01 18:00', 1, 'Noční zákrok');

-- =====================
-- ANIMAL ↔ CARETAKER (pivot) (>=10 rows)
-- =====================
INSERT INTO animal_caretaker (animal_id, caretaker_id) VALUES
(2, 1),
(2, 5),

(3, 1),
(3, 4),
(3, 8),
(3, 9),

(4, 4),

(5, 1),
(5, 10),
(5, 3),


(6, 5),
(6, 7),

(7, 7),

(8, 9),
(8, 8),
(8, 1),

(9, 1),
(9, 10),

-- Stín (kaloně) - noční pavilon + vet
(10, 3),
(10, 4);
