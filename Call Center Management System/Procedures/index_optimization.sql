CREATE DEFINER=`root`@`localhost` PROCEDURE `index_optimization`()
begin
declare v_max int default 5000;
declare v_counter int default 0;
  start transaction;
  while v_counter < v_max do
    # random query
	UPDATE transactions set transactions.time = '2020-01-26 08:49:09' where time = '2020-01-26 08:49:09';
    set v_counter = v_counter + 1;
  end while;
  commit;
end