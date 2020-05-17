CREATE DEFINER=`root`@`localhost` PROCEDURE `SelectAllCustomers`(Spe int, name varchar(20), psw varchar(20), user_id varchar(20))
BEGIN
SELECT * FROM specialist;
END