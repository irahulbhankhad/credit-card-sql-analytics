SET GLOBAL local_infile = 1;

-- Temporary column for raw date
ALTER TABLE cc_transactions
ADD COLUMN transaction_date_str VARCHAR(50);

LOAD DATA LOCAL INFILE '/Users/rahulchaudhary/Downloads/credit_card_transactions.csv'
INTO TABLE cc_transactions
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS
(id, city, transaction_date_str, card_type, exp_type, gender, amount);

UPDATE cc_transactions
SET transaction_date = STR_TO_DATE(transaction_date_str, '%m/%d/%Y');

ALTER TABLE cc_transactions
DROP COLUMN transaction_date_str;
