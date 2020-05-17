CREATE DEFINER=`root`@`localhost` PROCEDURE `proc_name`()
BEGIN
DECLARE site_id INT(4) DEFAULT 0;
REPEAT
    UPDATE transactions set transactions.time = '2020-01-26 08:49:09' where time = '2020-01-26 08:49:09';
    SET site_id = site_id + 1;
UNTIL site_id < 10000000000000000 END REPEAT;
END