CREATE DEFINER=`root`@`localhost` PROCEDURE `InsertTransaction`(transactions_id int, time DATETIME, payment_method ENUM ('PayPal', 'CC', 'DebitCard', 'NetBanking'), item_id int, store_id int, price int, item_type ENUM ('Electronics', 'Books', 'Home', 'Toys', 'Health'), name VARCHAR(20), description VARCHAR(200))
BEGIN
INSERT INTO Transactions (transactions_id, time, payment_method, created) VALUES (transactions_id, time, payment_method, CURRENT_TIMESTAMP);
INSERT INTO Item (item_id, transactions_id, store_id, price, item_type, name, description, created) VALUES (item_id, transactions_id, store_id, price, item_type, name, description, CURRENT_TIMESTAMP);
END