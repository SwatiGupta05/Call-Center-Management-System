DELIMITER //
CREATE DEFINER=`root`@`localhost` PROCEDURE `InsertItem`(item_id int, transactions_id int, store_id int, price int, item_type ENUM ('Electronics', 'Books', 'Home', 'Toys', 'Health'), name VARCHAR(20), description VARCHAR(200))
BEGIN
IF(transactions_id is NULL)
	THEN
		signal sqlstate '45000' set message_text = 'transactions_id is NULL';
       
    end if;

END //
DELIMITER ;


DELIMITER //
CREATE DEFINER=`root`@`localhost` PROCEDURE `InsertProblemcategory`(problem_category_id INT, administrator_id INT, description VARCHAR(200), solution_id INT, solution VARCHAR(200))
BEGIN
INSERT INTO ProblemCategory (problem_category_id, administrator_id, description, created) VALUES (problem_category_id, administrator_id, description, CURRENT_TIMESTAMP);
INSERT INTO Solution (solution_id, problem_category_id, solution, created) VALUES (solution_id, problem_category_id, solution_id, CURRENT_TIMESTAMP);
END
DELIMITER ;


DELIMITER //
CREATE DEFINER=`root`@`localhost` PROCEDURE `InsertSpecialist`(Spe int, name varchar(20), psw varchar(20), user_id varchar(20), specialization_id int)
BEGIN
IF(specialization_id is NULL)
	THEN
		signal sqlstate '45000' set message_text = 'specialization is NULL';
       
    end if;
INSERT INTO Specialist (specialist_id, name, psw, user_id, created) VALUES (Spe, name, psw, user_id, CURRENT_TIMESTAMP);
INSERT INTO Specialist_Specialization (specialist_id, specialization_id, created) VALUES (Spe, specialization_id, CURRENT_TIMESTAMP);
END
DELIMITER ;


DELIMITER //
CREATE DEFINER=`root`@`localhost` PROCEDURE `InsertTransaction`(transactions_id int, time DATETIME, payment_method ENUM ('PayPal', 'CC', 'DebitCard', 'NetBanking'), item_id int, store_id int, price int, item_type ENUM ('Electronics', 'Books', 'Home', 'Toys', 'Health'), name VARCHAR(20), description VARCHAR(200))
BEGIN
INSERT INTO Transactions (transactions_id, time, payment_method, created) VALUES (transactions_id, time, payment_method, CURRENT_TIMESTAMP);
INSERT INTO Item (item_id, transactions_id, store_id, price, item_type, name, description, created) VALUES (item_id, transactions_id, store_id, price, item_type, name, description, CURRENT_TIMESTAMP);
END
DELIMITER ;


DELIMITER //
CREATE DEFINER=`root`@`localhost` PROCEDURE `SelectAllCustomers`(Spe int, name varchar(20), psw varchar(20), user_id varchar(20))
BEGIN
SELECT * FROM specialist;
END
DELIMITER ;


SELECT * FROM SOLUTION WHERE SOLUTION.problem_category_id = 6 LIMIT 0, 1000;
DELETE FROM problemcategory WHERE problem_category_id = 7;


delete from PhoneCall where phonecall_id = 755;

INSERT INTO PhoneCall ( phonecall_id, customer_id, operator_id, start_time, duration, created) VALUES (755, 3, 1, '2010-01-19 16:35:05', 451, CURRENT_TIMESTAMP);
delete from Transactions where transactions_id = 3284;


INSERT INTO Transactions (transactions_id, time, payment_method, created) VALUES (3284, '2020-02-14 14:33:43', 'DebitCard', CURRENT_TIMESTAMP);

delete from problem where problem_id = 5190;

INSERT INTO Problem (problem_id, transactions_id, phonecall_id, problem_category_id, specialist_id, status, description, created) VALUES (5190, 3284, 755, 4, 3, 'Solved by Specialist', 'description_51', CURRENT_TIMESTAMP);


/* Query */

/* Query 2 */
select operator_id, avg(phonecall.duration) from phonecall group by operator_id ;	

/* Query 4 */
select store_id, count(item_id) as c from item group by store_id order by c desc;

/* query 7 */
select store.store_id, count(distinct customer.name) as c from customer, phonecall, problem, transactions, item, store
where customer.customer_id = phonecall.customer_id and problem.phonecall_id = phonecall.phonecall_id and transactions.transactions_id = problem.transactions_id and item.transactions_id = transactions.transactions_id and item.store_id = store.store_id
group by store.store_id order by c desc;

/* query 12 */
SELECT administrator.administrator_id, count(*) from ProblemCategory, Problem, Administrator where problemcategory.problem_category_id = Problem.problem_category_id and administrator.administrator_id = problemcategory.administrator_id and (Problem.status = 'Solved by Standard Solution' or Problem.status = 'Solved by Specialist')
group by administrator.administrator_id;


/* Query 6 */
select
  sum(case when problem.status = "Solved by Standard Solution" then 1 else 0 end) as solved_by_std_sol,
  sum(case when problem.status = "Solved by Specialist" then 1 else 0 end) as solved_by_spec
from problem;

/* Query 10 */
select customer.name, count(*) from customer, phonecall, problem, transactions, item
where customer.customer_id = phonecall.customer_id and problem.phonecall_id = phonecall.phonecall_id and transactions.transactions_id = problem.transactions_id and item.transactions_id = transactions.transactions_id
group by customer.name;

/* Query 8  */
select distinct store.store_id from store, item
where item.store_id = store.store_id and item_type = "Electronics";


/* Query 5  */
SELECT specialist.specialist_id, count(*) as c from Specialist, Problem where specialist.specialist_id = problem.specialist_id
group by specialist.specialist_id order by c desc;

/* Query 3  */
SELECT item.item_type, count(*) from Item, Problem, transactions where item.transactions_id = transactions.transactions_id and transactions.transactions_id = problem.transactions_id
group by item.item_type;

/* Query 1  */
select customer.customer_id, sum(item.price) as c from customer, phonecall, problem, transactions, item
where customer.customer_id = phonecall.customer_id and problem.phonecall_id = phonecall.phonecall_id and transactions.transactions_id = problem.transactions_id and item.transactions_id = transactions.transactions_id
group by customer.customer_id order by c desc;

/* Query 11  */
SELECT operator.operator_id, count(*) as c from Operator, Phonecall where operator.operator_id = phonecall.operator_id
group by operator.operator_id having c>=10;

/* Query 13  */
select distinct store.store_id, item.item_type from store, item
where item.store_id = store.store_id;

/* Query 14 display all the user_ids in the system  */
select user_id from operator
union
select user_id from administrator;

/* Query 15 display all the phonecalls and their problems (problem_id, problem_category if any)  */
select phonecall.phonecall_id, duration, problem_id, problem_category_id from phonecall
left join problem on phonecall.phonecall_id = problem.phonecall_id;

/* Query 16 display everything from operator excluding the psw  */
create view NoRootOpData as
select operator_id, name, user_id from operator;


/* Query 17 display total price of transactions  */
select transactions.transactions_id, sum(price) as c from transactions, item
where transactions.transactions_id = item.item_id
group by transactions.transactions_id
order by c desc;

/* Query 18 display all the transactions before specific time  */
select transactions_id, time from transactions where time < '2020-01-26 08:49:09'

DELIMITER $$
use test$$
create procedure load_user_test_data()
begin
declare v_max int default 1000;
declare v_counter int default 0;
  truncate table users;
  start transaction;
  while v_counter < v_max do
    # random query
    UPDATE transactions set transactions.time = '2020-01-26 08:49:09' where time = '2020-01-26 08:49:09';
    set v_counter = v_counter + 1;
  end while;
  commit;
end
DELIMITER ;
SET SQL_SAFE_UPDATES=0; 
call load_user_test_data();

