CREATE DEFINER=`root`@`localhost` PROCEDURE `InsertItem`(item_id int, transactions_id int, store_id int, price int, item_type ENUM ('Electronics', 'Books', 'Home', 'Toys', 'Health'), name VARCHAR(20), description VARCHAR(200))
BEGIN
IF(transactions_id is NULL)
	THEN
		signal sqlstate '45000' set message_text = 'transactions_id is NULL';
       
    end if;

END