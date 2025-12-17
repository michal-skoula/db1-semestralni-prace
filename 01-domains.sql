CREATE DOMAIN phone_cz AS VARCHAR(16)
CONSTRAINT ck_phone_format
CHECK (VALUE ~ '^(\+420)?[1-9][0-9]{8}');

CREATE DOMAIN email AS VARCHAR(254)
CONSTRAINT ck_email_format
CHECK (VALUE ~ '^[^@\s]+@[^@\s]+\.[^@\s]+$');