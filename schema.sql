CREATE DATABASE credit_card_transactions;
USE credit_card_transactions;

DROP TABLE IF EXISTS cc_transactions;

CREATE TABLE cc_transactions (
    id INT PRIMARY KEY,
    city VARCHAR(50),
    transaction_date DATE,
    card_type VARCHAR(30),
    exp_type VARCHAR(30),
    gender VARCHAR(10),
    amount DECIMAL(10,2)
);
