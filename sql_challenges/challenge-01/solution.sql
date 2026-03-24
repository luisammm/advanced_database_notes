
BEGIN
    EXECUTE IMMEDIATE 'DROP TABLE pet_care_log CASCADE CONSTRAINTS';
EXCEPTION
    WHEN OTHERS THEN NULL;
END;
/

BEGIN
    EXECUTE IMMEDIATE 'DROP TABLE sale_item CASCADE CONSTRAINTS';
EXCEPTION
    WHEN OTHERS THEN NULL;
END;
/

BEGIN
    EXECUTE IMMEDIATE 'DROP TABLE customer_sale CASCADE CONSTRAINTS';
EXCEPTION
    WHEN OTHERS THEN NULL;
END;
/

BEGIN
    EXECUTE IMMEDIATE 'DROP TABLE customer CASCADE CONSTRAINTS';
EXCEPTION
    WHEN OTHERS THEN NULL;
END;
/

BEGIN
    EXECUTE IMMEDIATE 'DROP TABLE product CASCADE CONSTRAINTS';
EXCEPTION
    WHEN OTHERS THEN NULL;
END;
/

CREATE TABLE product (
    product_id NUMBER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    product_name VARCHAR2(30) NOT NULL,
    package_id NUMBER(10),
    current_inventory_count NUMBER(5) DEFAULT 0 NOT NULL,
    store_cost NUMBER(10,2) DEFAULT 0 NOT NULL,
    sale_price NUMBER(10,2) DEFAULT 0 NOT NULL,
    last_update_date DATE DEFAULT SYSDATE,
    updated_by_user VARCHAR2(30) DEFAULT USER,
    pet_flag VARCHAR2(1) DEFAULT 'N' NOT NULL,

    CONSTRAINT chk_product_inventory
        CHECK (current_inventory_count >= 0),

    CONSTRAINT chk_product_store_cost
        CHECK (store_cost >= 0),

    CONSTRAINT chk_product_sale_price
        CHECK (sale_price >= 0),

    CONSTRAINT chk_product_pet_flag
        CHECK (pet_flag IN ('Y', 'N')),

    CONSTRAINT fk_product_package
        FOREIGN KEY (package_id)
        REFERENCES product(product_id)
);

CREATE TABLE customer (
    cust_id NUMBER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    firstname VARCHAR2(20) NOT NULL,
    lastname VARCHAR2(25) NOT NULL,
    address VARCHAR2(32),
    city VARCHAR2(20),
    state VARCHAR2(2),
    zip VARCHAR2(9),

    CONSTRAINT chk_customer_state
        CHECK (state IS NULL OR REGEXP_LIKE(state, '^[A-Z]{2}$')),

    CONSTRAINT chk_customer_zip
        CHECK (zip IS NULL OR REGEXP_LIKE(zip, '^[0-9]{5}([0-9]{4})?$'))
);

CREATE TABLE customer_sale (
    sales_id NUMBER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    cust_id NUMBER(10) NOT NULL,
    total_item_amount NUMBER(10,2) DEFAULT 0 NOT NULL,
    tax_amount NUMBER(10,2) DEFAULT 0 NOT NULL,
    total_sale_amount NUMBER(10,2) DEFAULT 0 NOT NULL,
    sales_date DATE DEFAULT SYSDATE NOT NULL,
    shipping_handling_fee NUMBER(5,2) DEFAULT 0 NOT NULL,

    CONSTRAINT fk_customer_sale_customer
        FOREIGN KEY (cust_id)
        REFERENCES customer(cust_id),

    CONSTRAINT chk_customer_sale_total_item
        CHECK (total_item_amount >= 0),

    CONSTRAINT chk_customer_sale_tax
        CHECK (tax_amount >= 0),

    CONSTRAINT chk_customer_sale_total_sale
        CHECK (total_sale_amount >= 0),

    CONSTRAINT chk_customer_sale_shipping
        CHECK (shipping_handling_fee >= 0)
);

CREATE TABLE sale_item (
    sales_id NUMBER(10) NOT NULL,
    product_id NUMBER(10) NOT NULL,
    sale_amount NUMBER(10,2) DEFAULT 0 NOT NULL,

    CONSTRAINT pk_sale_item
        PRIMARY KEY (sales_id, product_id),

    CONSTRAINT fk_sale_item_sale
        FOREIGN KEY (sales_id)
        REFERENCES customer_sale(sales_id),

    CONSTRAINT fk_sale_item_product
        FOREIGN KEY (product_id)
        REFERENCES product(product_id),

    CONSTRAINT chk_sale_item_amount
        CHECK (sale_amount >= 0)
);

CREATE TABLE pet_care_log (
    product_id NUMBER(10) NOT NULL,
    log_datetime DATE DEFAULT SYSDATE NOT NULL,
    created_by_user VARCHAR2(30) DEFAULT USER NOT NULL,
    log_text VARCHAR2(500) NOT NULL,
    last_update_datetime DATE DEFAULT SYSDATE,

    CONSTRAINT pk_pet_care_log
        PRIMARY KEY (product_id, log_datetime),

    CONSTRAINT fk_pet_care_log_product
        FOREIGN KEY (product_id)
        REFERENCES product(product_id)
);

CREATE OR REPLACE TRIGGER trg_product_set_update_date
BEFORE UPDATE ON product
FOR EACH ROW
BEGIN
    :NEW.last_update_date := SYSDATE;
    :NEW.updated_by_user := USER;
END;
/

CREATE OR REPLACE TRIGGER trg_pet_care_log_set_update
BEFORE UPDATE ON pet_care_log
FOR EACH ROW
BEGIN
    :NEW.last_update_datetime := SYSDATE;
END;
/

CREATE OR REPLACE TRIGGER trg_pet_care_log_pet_only
BEFORE INSERT OR UPDATE ON pet_care_log
FOR EACH ROW
DECLARE
    v_pet_flag product.pet_flag%TYPE;
BEGIN
    SELECT pet_flag
      INTO v_pet_flag
      FROM product
     WHERE product_id = :NEW.product_id;

    IF v_pet_flag <> 'Y' THEN
        RAISE_APPLICATION_ERROR(
            -20001,
            'Solo productos marcados como mascota (PET_FLAG = Y) pueden tener registros en PET_CARE_LOG'
        );
    END IF;
END;
/

CREATE OR REPLACE TRIGGER trg_customer_sale_calc_total
BEFORE INSERT OR UPDATE ON customer_sale
FOR EACH ROW
BEGIN
    :NEW.total_sale_amount :=
        NVL(:NEW.total_item_amount, 0)
        + NVL(:NEW.tax_amount, 0)
        + NVL(:NEW.shipping_handling_fee, 0);
END;
/

INSERT INTO product (
    product_name,
    package_id,
    current_inventory_count,
    store_cost,
    sale_price,
    pet_flag
) VALUES (
    'Golden Retriever',
    NULL,
    2,
    500.00,
    850.00,
    'Y'
);

INSERT INTO product (
    product_name,
    package_id,
    current_inventory_count,
    store_cost,
    sale_price,
    pet_flag
) VALUES (
    'Dog Food 20lb',
    NULL,
    25,
    18.00,
    29.99,
    'N'
);

INSERT INTO product (
    product_name,
    package_id,
    current_inventory_count,
    store_cost,
    sale_price,
    pet_flag
) VALUES (
    'Leash',
    NULL,
    15,
    4.50,
    9.99,
    'N'
);

INSERT INTO customer (
    firstname,
    lastname,
    address,
    city,
    state,
    zip
) VALUES (
    'Juan',
    'Perez',
    '123 Main St',
    'Miami',
    'FL',
    '331010000'
);

INSERT INTO customer (
    firstname,
    lastname,
    address,
    city,
    state,
    zip
) VALUES (
    'Maria',
    'Lopez',
    '456 Oak Ave',
    'Orlando',
    'FL',
    '328010000'
);

INSERT INTO customer_sale (
    cust_id,
    total_item_amount,
    tax_amount,
    shipping_handling_fee
) VALUES (
    1,
    859.99,
    68.80,
    15.00
);

INSERT INTO sale_item (
    sales_id,
    product_id,
    sale_amount
) VALUES (
    1,
    1,
    850.00
);

INSERT INTO sale_item (
    sales_id,
    product_id,
    sale_amount
) VALUES (
    1,
    3,
    9.99
);

INSERT INTO pet_care_log (
    product_id,
    log_text
) VALUES (
    1,
    'Feed twice daily and schedule first vet visit within 7 days.'
);

COMMIT;
------------------------------------------------------------------------
-- CONSULTAS DE PRUEBA
------------------------------------------------------------------------
SELECT * FROM product;
SELECT * FROM customer;
SELECT * FROM customer_sale;
SELECT * FROM sale_item;
SELECT * FROM pet_care_log;