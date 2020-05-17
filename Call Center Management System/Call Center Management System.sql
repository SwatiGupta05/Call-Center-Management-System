DROP TABLE IF EXISTS Item ; 
DROP TABLE IF EXISTS Store ;
DROP TABLE IF EXISTS Problem ;
DROP TABLE IF EXISTS Transactions ; 
DROP TABLE IF EXISTS Specialist_Specialization ;
DROP TABLE IF EXISTS Specialization_ProblemCategory ;
DROP TABLE IF EXISTS Specialization ;
DROP TABLE IF EXISTS Specialist ;
DROP TABLE IF EXISTS Solution ;
DROP TABLE IF EXISTS ProblemCategory ;
DROP TABLE IF EXISTS Administrator ;
DROP TABLE IF EXISTS PhoneCall ;
DROP TABLE IF EXISTS Operator ;
DROP TABLE IF EXISTS Customer ; 

CREATE TABLE Customer (
  customer_id int unsigned NOT NULL AUTO_INCREMENT,
  name VARCHAR(20) NOT NULL,
  email VARCHAR(50) NOT NULL,
  phone VARCHAR(20),
  gender ENUM('m','f'), 
  created TIMESTAMP DEFAULT NOW(),
  CONSTRAINT pk_customer_id PRIMARY KEY (customer_id)
);


CREATE TABLE Operator (
  operator_id INT NOT NULL AUTO_INCREMENT, 
  name VARCHAR(20) NOT NULL,
  psw VARCHAR(20) NOT NULL,
  user_id VARCHAR(20) NOT NULL UNIQUE,
  created TIMESTAMP DEFAULT NOW(),
  CONSTRAINT pk_operator_id PRIMARY KEY (operator_id)
);


CREATE TABLE PhoneCall (
  phonecall_id INT NOT NULL AUTO_INCREMENT,
  customer_id INT unsigned NOT NULL,
  operator_id INT NOT NULL,
  start_time DATETIME NOT NULL,
  duration INT NOT NULL,
  created TIMESTAMP DEFAULT NOW(),
  CONSTRAINT pk_call_id PRIMARY KEY (phonecall_id),
  CONSTRAINT fk_call_operator
    FOREIGN KEY (operator_id)
    REFERENCES Operator (operator_id),
  CONSTRAINT fk_customer_id
    FOREIGN KEY (customer_id)
    REFERENCES Customer (customer_id)
);


CREATE TABLE Administrator (
  administrator_id INT NOT NULL AUTO_INCREMENT, 
  psw VARCHAR(25) NOT NULL,
  user_id VARCHAR(25) NOT NULL UNIQUE,
  created TIMESTAMP DEFAULT NOW(),
  CONSTRAINT pk_administrator_id PRIMARY KEY (administrator_id)
);


CREATE TABLE ProblemCategory (
  problem_category_id INT NOT NULL AUTO_INCREMENT,
  administrator_id INT NOT NULL,
  description VARCHAR(200),
  created TIMESTAMP DEFAULT NOW(),
  CONSTRAINT pk_problem_category_id PRIMARY KEY (problem_category_id),
  CONSTRAINT fk_administrator_id
    FOREIGN KEY (administrator_id)
    REFERENCES Administrator (administrator_id)
);


CREATE TABLE Solution (
  solution_id INT NOT NULL AUTO_INCREMENT,
  problem_category_id INT NOT NULL,
  solution VARCHAR(200),
  created TIMESTAMP DEFAULT NOW(),
  CONSTRAINT pk_solution_id PRIMARY KEY (solution_id),
  CONSTRAINT fk_problem_category_id
    FOREIGN KEY (problem_category_id)
    REFERENCES ProblemCategory (problem_category_id)
);


CREATE TABLE Specialist (
  specialist_id INT NOT NULL AUTO_INCREMENT,
  name VARCHAR(20) NOT NULL,
  psw VARCHAR(20) NOT NULL,
  user_id VARCHAR(20) NOT NULL UNIQUE,
  created TIMESTAMP DEFAULT NOW(),
  CONSTRAINT pk_specialist_id PRIMARY KEY (specialist_id)
);


CREATE TABLE Specialization (
  specialization_id INT NOT NULL AUTO_INCREMENT, 
  description VARCHAR(50) NOT NULL,
  created TIMESTAMP DEFAULT NOW(),
  CONSTRAINT pk_specialization_id PRIMARY KEY (specialization_id)
);


CREATE TABLE Specialization_ProblemCategory (
  specialization_id INT NOT NULL,
  problem_category_id INT NOT NULL,
  created TIMESTAMP DEFAULT NOW(),
  CONSTRAINT pk_specialization_problemcategory PRIMARY KEY (problem_category_id, specialization_id), 
  CONSTRAINT fk_problem_category_id_second
    FOREIGN KEY (problem_category_id)
    REFERENCES ProblemCategory (problem_category_id),
  CONSTRAINT fk_specialization_id
    FOREIGN KEY (specialization_id)
    REFERENCES Specialization (specialization_id)
);


CREATE TABLE Specialist_Specialization (
  specialist_id INT NOT NULL,
  specialization_id INT NOT NULL,
  created TIMESTAMP DEFAULT NOW(),
  CONSTRAINT pk_specialist_specialization PRIMARY KEY (specialist_id, specialization_id), 
  CONSTRAINT fk_specialization_id_second
    FOREIGN KEY (specialization_id)
    REFERENCES Specialization (specialization_id),
  CONSTRAINT fk_specialist_id
    FOREIGN KEY (specialist_id)
    REFERENCES Specialist (specialist_id)
);


CREATE TABLE Transactions (
  transactions_id INT unsigned NOT NULL AUTO_INCREMENT,
  time DATETIME NOT NULL,
  payment_method ENUM ('PayPal', 'CC', 'DebitCard', 'NetBanking'),
  created TIMESTAMP DEFAULT NOW(),
  CONSTRAINT pk_transactions_id PRIMARY KEY (transactions_id),
  index(time)
);


CREATE TABLE Problem (
  problem_id INT NOT NULL AUTO_INCREMENT,
  transactions_id INT unsigned,
  phonecall_id INT,
  problem_category_id INT,
  specialist_id INT,
  status ENUM ('Pending', 'Solved by Specialist', 'Solved by Standard Solution'),
  description VARCHAR(200),
  created TIMESTAMP DEFAULT NOW(),
  CONSTRAINT pk_problem_id PRIMARY KEY (problem_id),
  CONSTRAINT fk_problem_category_id_third
    FOREIGN KEY (problem_category_id)
    REFERENCES ProblemCategory (problem_category_id),
  CONSTRAINT fk_specialist_id_second
    FOREIGN KEY (specialist_id)
    REFERENCES Specialist (specialist_id),
  CONSTRAINT fk_transactions_id_second
    FOREIGN KEY (transactions_id)
    REFERENCES Transactions (transactions_id),
      CONSTRAINT fk_phonecall_id
    FOREIGN KEY (phonecall_id)
    REFERENCES PhoneCall (phonecall_id)
);


CREATE TABLE Store (
  store_id INT NOT NULL AUTO_INCREMENT,
  name VARCHAR(20) NOT NULL,
  description VARCHAR(200),
  created TIMESTAMP DEFAULT NOW(),
  CONSTRAINT pk_store_id PRIMARY KEY (store_id)
);


CREATE TABLE Item (
  item_id INT unsigned NOT NULL AUTO_INCREMENT,
  transactions_id INT unsigned NOT NULL,
  store_id INT NOT NULL,
  price mediumint unsigned NOT NULL,
  item_type ENUM ('Electronics', 'Books', 'Home', 'Toys', 'Health'), 
  name VARCHAR(20) NOT NULL,
  description VARCHAR(200),
  created TIMESTAMP DEFAULT NOW(),
  CONSTRAINT pk_item_id PRIMARY KEY (item_id),
  CONSTRAINT fk_transactions_id
    FOREIGN KEY (transactions_id)
    REFERENCES Transactions (transactions_id),
  CONSTRAINT fk_store_id
    FOREIGN KEY (store_id)
    REFERENCES Store (store_id)
);


DELIMITER //
CREATE DEFINER=`root`@`localhost` TRIGGER `test`.`operator_BEFORE_INSERT` BEFORE INSERT ON `operator` FOR EACH ROW

BEGIN
DECLARE	c int;

 SELECT count(*) into c
 from administrator where administrator.user_id = new.user_id;
 IF(c > 0)
	THEN
		signal sqlstate '45000' set message_text = 'user_id exist!';
    end if;
    
 SELECT count(*) into c
 from specialist where specialist.user_id = new.user_id;
 IF(c > 0)
	THEN
		signal sqlstate '45000' set message_text = 'user_id exist!';
    end if;

END
DELIMITER ;

DELIMITER //
CREATE DEFINER=`root`@`localhost` TRIGGER `test`.`operator_BEFORE_UPDATE` BEFORE UPDATE ON `operator` FOR EACH ROW

BEGIN
DECLARE	c int;

 SELECT count(*) into c
 from administrator where administrator.user_id = new.user_id;
 IF(c > 0)
	THEN
		signal sqlstate '45000' set message_text = 'user_id exist!';
    end if;
    
 SELECT count(*) into c
 from specialist where specialist.user_id = new.user_id;
 IF(c > 0)
	THEN
		signal sqlstate '45000' set message_text = 'user_id exist!';
    end if;

END
DELIMITER ;


DELIMITER //
CREATE DEFINER=`root`@`localhost` TRIGGER `test`.`administrator_BEFORE_INSERT` BEFORE INSERT ON `administrator` FOR EACH ROW

BEGIN
DECLARE	c int;

 SELECT count(*) into c
 from operator where operator.user_id = new.user_id;
 IF(c > 0)
	THEN
		signal sqlstate '45000' set message_text = 'user_id exist!';
    end if;
    
 SELECT count(*) into c
 from specialist where specialist.user_id = new.user_id;
 IF(c > 0)
	THEN
		signal sqlstate '45000' set message_text = 'user_id exist!';
    end if;

END //

DELIMITER ;
DELIMITER //
CREATE DEFINER=`root`@`localhost` TRIGGER `test`.`administrator_BEFORE_UPDATE` BEFORE UPDATE ON `administrator` FOR EACH ROW

BEGIN
DECLARE	c int;

 SELECT count(*) into c
 from operator where operator.user_id = new.user_id;
 IF(c > 0)
	THEN
		signal sqlstate '45000' set message_text = 'user_id exist!';
    end if;

 SELECT count(*) into c
 from specialist where specialist.user_id = new.user_id;
 IF(c > 0)
	THEN
		signal sqlstate '45000' set message_text = 'user_id exist!';
    end if;

END
DELIMITER ;


DELIMITER //
CREATE DEFINER=`root`@`localhost` TRIGGER `test`.`specialist_BEFORE_INSERT` BEFORE INSERT ON `specialist` FOR EACH ROW

BEGIN
DECLARE	c int;

 SELECT count(*) into c
 from operator where operator.user_id = new.user_id;
 IF(c > 0)
	THEN
		signal sqlstate '45000' set message_text = 'user_id exist!';
    end if;
    
 SELECT count(*) into c
 from administrator where administrator.user_id = new.user_id;
 IF(c > 0)
	THEN
		signal sqlstate '45000' set message_text = 'user_id exist!';
    end if;

END //

DELIMITER ;
DELIMITER //
CREATE DEFINER=`root`@`localhost` TRIGGER `test`.`specialist_BEFORE_UPDATE` BEFORE UPDATE ON `specialist` FOR EACH ROW

BEGIN
DECLARE	c int;

 SELECT count(*) into c
 from operator where operator.user_id = new.user_id;
 IF(c > 0)
	THEN
		signal sqlstate '45000' set message_text = 'user_id exist!';
    end if;

 SELECT count(*) into c
 from administrator where administrator.user_id = new.user_id;
 IF(c > 0)
	THEN
		signal sqlstate '45000' set message_text = 'user_id exist!';
    end if;

END
DELIMITER ;



DELIMITER //
CREATE DEFINER=`root`@`localhost` TRIGGER `test`.`PROBLEM_BEFORE_INSERT` BEFORE INSERT ON `problem` FOR EACH ROW

BEGIN
DECLARE t_time datetime;
DECLARE c_time datetime;

 IF(new.status = 'Pending' and new.specialist_id is not NULL) or (new.status = 'Solved by Specialist' and new.specialist_id is NULL)
	THEN
		signal sqlstate '45000' set message_text = 'invalid status';
       
    end if;
 IF(new.problem_category_id = NULL and new.specialist_id is NULL)
	THEN
		signal sqlstate '45000' set message_text = 'invalid specialist_id';
       
    end if;
    
    
    
     SELECT time into t_time
 from transactions where transactions.transactions_id = new.transactions_id;
 SELECT start_time into c_time
 from phonecall where phonecall.phonecall_id = new.phonecall_id;
 IF(c_time < t_time)
	THEN
		signal sqlstate '45000' set message_text = 'transaction time is invalid!';
    end if;

END
DELIMITER ;

DELIMITER //
CREATE DEFINER=`root`@`localhost` TRIGGER `test`.`PROBLEM_BEFORE_UPDATE` BEFORE UPDATE ON `problem` FOR EACH ROW

BEGIN
 IF(new.status = 'Pending' and new.specialist_id is not NULL) or (new.status = 'Solved by Specialist' and new.specialist_id is NULL)
	THEN
		signal sqlstate '45000' set message_text = 'invalid problem status';
       
    end if;
 IF(new.problem_category_id = NULL and new.specialist_id is NULL)
	THEN
		signal sqlstate '45000' set message_text = 'invalid specialist_id';
       
    end if;

END
DELIMITER ;

DELIMITER //
CREATE DEFINER=`root`@`localhost` TRIGGER `test`.`PROBLEMCATEGORY_BEFORE_DELETE` BEFORE DELETE ON `problemcategory` FOR EACH ROW

BEGIN
UPDATE PROBLEM set problem.problem_category_id = NULL where problem.problem_category_id = old.problem_category_id;
DELETE FROM specialization_problemcategory WHERE specialization_problemcategory.problem_category_id = old.problem_category_id;
DELETE FROM solution WHERE solution.problem_category_id = old.problem_category_id;

END
DELIMITER ;
DELIMITER //
CREATE DEFINER=`root`@`localhost` TRIGGER `test`.`TRANSACTIONS_BEFORE_DELETE` BEFORE DELETE ON `transactions` FOR EACH ROW

BEGIN
DELETE FROM item WHERE item.transactions_id = old.transactions_id;

END
DELIMITER ;



INSERT INTO Administrator (administrator_id, user_id, psw, created) VALUES (1, 'administrator_user_1', 'administrator_psw_0', CURRENT_TIMESTAMP);
INSERT INTO Administrator (administrator_id, user_id, psw, created) VALUES (2, 'administrator_user_2', 'administrator_psw_0', CURRENT_TIMESTAMP);
INSERT INTO Administrator (administrator_id, user_id, psw, created) VALUES (3, 'administrator_user_3', 'administrator_psw_3', CURRENT_TIMESTAMP);
INSERT INTO ProblemCategory (problem_category_id, administrator_id, description, created) VALUES (1, 2, 'description_1', CURRENT_TIMESTAMP);
INSERT INTO ProblemCategory (problem_category_id, administrator_id, description, created) VALUES (2, 3, 'description_2', CURRENT_TIMESTAMP);
INSERT INTO ProblemCategory (problem_category_id, administrator_id, description, created) VALUES (3, 3, 'description_3', CURRENT_TIMESTAMP);
INSERT INTO ProblemCategory (problem_category_id, administrator_id, description, created) VALUES (4, 3, 'description_4', CURRENT_TIMESTAMP);
INSERT INTO ProblemCategory (problem_category_id, administrator_id, description, created) VALUES (5, 3, 'description_5', CURRENT_TIMESTAMP);
INSERT INTO ProblemCategory (problem_category_id, administrator_id, description, created) VALUES (6, 3, 'description_6', CURRENT_TIMESTAMP);
INSERT INTO ProblemCategory (problem_category_id, administrator_id, description, created) VALUES (7, 1, 'description_7', CURRENT_TIMESTAMP);
INSERT INTO ProblemCategory (problem_category_id, administrator_id, description, created) VALUES (8, 1, 'description_8', CURRENT_TIMESTAMP);
INSERT INTO ProblemCategory (problem_category_id, administrator_id, description, created) VALUES (9, 3, 'description_9', CURRENT_TIMESTAMP);
INSERT INTO Solution (solution_id, problem_category_id, solution, created) VALUES (1, 8, 'solution_1', CURRENT_TIMESTAMP);
INSERT INTO Solution (solution_id, problem_category_id, solution, created) VALUES (2, 9, 'solution_2', CURRENT_TIMESTAMP);
INSERT INTO Solution (solution_id, problem_category_id, solution, created) VALUES (3, 7, 'solution_3', CURRENT_TIMESTAMP);
INSERT INTO Solution (solution_id, problem_category_id, solution, created) VALUES (4, 7, 'solution_4', CURRENT_TIMESTAMP);
INSERT INTO Solution (solution_id, problem_category_id, solution, created) VALUES (5, 8, 'solution_5', CURRENT_TIMESTAMP);
INSERT INTO Solution (solution_id, problem_category_id, solution, created) VALUES (6, 2, 'solution_6', CURRENT_TIMESTAMP);
INSERT INTO Solution (solution_id, problem_category_id, solution, created) VALUES (7, 4, 'solution_7', CURRENT_TIMESTAMP);
INSERT INTO Solution (solution_id, problem_category_id, solution, created) VALUES (8, 2, 'solution_8', CURRENT_TIMESTAMP);
INSERT INTO Solution (solution_id, problem_category_id, solution, created) VALUES (9, 9, 'solution_9', CURRENT_TIMESTAMP);
INSERT INTO Solution (solution_id, problem_category_id, solution, created) VALUES (10, 8, 'solution_10', CURRENT_TIMESTAMP);
INSERT INTO Solution (solution_id, problem_category_id, solution, created) VALUES (11, 5, 'solution_11', CURRENT_TIMESTAMP);
INSERT INTO Solution (solution_id, problem_category_id, solution, created) VALUES (12, 1, 'solution_12', CURRENT_TIMESTAMP);
INSERT INTO Solution (solution_id, problem_category_id, solution, created) VALUES (13, 4, 'solution_13', CURRENT_TIMESTAMP);
INSERT INTO Solution (solution_id, problem_category_id, solution, created) VALUES (14, 1, 'solution_14', CURRENT_TIMESTAMP);
INSERT INTO Solution (solution_id, problem_category_id, solution, created) VALUES (15, 7, 'solution_15', CURRENT_TIMESTAMP);
INSERT INTO Solution (solution_id, problem_category_id, solution, created) VALUES (16, 2, 'solution_16', CURRENT_TIMESTAMP);
INSERT INTO Solution (solution_id, problem_category_id, solution, created) VALUES (17, 1, 'solution_17', CURRENT_TIMESTAMP);
INSERT INTO Solution (solution_id, problem_category_id, solution, created) VALUES (18, 6, 'solution_18', CURRENT_TIMESTAMP);
INSERT INTO Solution (solution_id, problem_category_id, solution, created) VALUES (19, 6, 'solution_19', CURRENT_TIMESTAMP);
INSERT INTO Solution (solution_id, problem_category_id, solution, created) VALUES (20, 5, 'solution_20', CURRENT_TIMESTAMP);
INSERT INTO Solution (solution_id, problem_category_id, solution, created) VALUES (21, 1, 'solution_21', CURRENT_TIMESTAMP);
INSERT INTO Solution (solution_id, problem_category_id, solution, created) VALUES (22, 8, 'solution_22', CURRENT_TIMESTAMP);
INSERT INTO Solution (solution_id, problem_category_id, solution, created) VALUES (23, 7, 'solution_23', CURRENT_TIMESTAMP);
INSERT INTO Solution (solution_id, problem_category_id, solution, created) VALUES (24, 3, 'solution_24', CURRENT_TIMESTAMP);
INSERT INTO Solution (solution_id, problem_category_id, solution, created) VALUES (25, 3, 'solution_25', CURRENT_TIMESTAMP);
INSERT INTO Solution (solution_id, problem_category_id, solution, created) VALUES (26, 2, 'solution_26', CURRENT_TIMESTAMP);
INSERT INTO Solution (solution_id, problem_category_id, solution, created) VALUES (27, 4, 'solution_27', CURRENT_TIMESTAMP);
INSERT INTO Solution (solution_id, problem_category_id, solution, created) VALUES (28, 7, 'solution_28', CURRENT_TIMESTAMP);
INSERT INTO Solution (solution_id, problem_category_id, solution, created) VALUES (29, 8, 'solution_29', CURRENT_TIMESTAMP);
INSERT INTO Solution (solution_id, problem_category_id, solution, created) VALUES (30, 5, 'solution_30', CURRENT_TIMESTAMP);
INSERT INTO Solution (solution_id, problem_category_id, solution, created) VALUES (31, 2, 'solution_31', CURRENT_TIMESTAMP);
INSERT INTO Solution (solution_id, problem_category_id, solution, created) VALUES (32, 6, 'solution_32', CURRENT_TIMESTAMP);
INSERT INTO Solution (solution_id, problem_category_id, solution, created) VALUES (33, 4, 'solution_33', CURRENT_TIMESTAMP);
INSERT INTO Solution (solution_id, problem_category_id, solution, created) VALUES (34, 7, 'solution_34', CURRENT_TIMESTAMP);
INSERT INTO Solution (solution_id, problem_category_id, solution, created) VALUES (35, 6, 'solution_35', CURRENT_TIMESTAMP);
INSERT INTO Solution (solution_id, problem_category_id, solution, created) VALUES (36, 6, 'solution_36', CURRENT_TIMESTAMP);
INSERT INTO Solution (solution_id, problem_category_id, solution, created) VALUES (37, 3, 'solution_37', CURRENT_TIMESTAMP);
INSERT INTO Solution (solution_id, problem_category_id, solution, created) VALUES (38, 6, 'solution_38', CURRENT_TIMESTAMP);
INSERT INTO Solution (solution_id, problem_category_id, solution, created) VALUES (39, 8, 'solution_39', CURRENT_TIMESTAMP);
INSERT INTO Solution (solution_id, problem_category_id, solution, created) VALUES (40, 2, 'solution_40', CURRENT_TIMESTAMP);
INSERT INTO Solution (solution_id, problem_category_id, solution, created) VALUES (41, 7, 'solution_41', CURRENT_TIMESTAMP);
INSERT INTO Solution (solution_id, problem_category_id, solution, created) VALUES (42, 4, 'solution_42', CURRENT_TIMESTAMP);
INSERT INTO Solution (solution_id, problem_category_id, solution, created) VALUES (43, 8, 'solution_43', CURRENT_TIMESTAMP);
INSERT INTO Solution (solution_id, problem_category_id, solution, created) VALUES (44, 8, 'solution_44', CURRENT_TIMESTAMP);
INSERT INTO Solution (solution_id, problem_category_id, solution, created) VALUES (45, 2, 'solution_45', CURRENT_TIMESTAMP);
INSERT INTO Solution (solution_id, problem_category_id, solution, created) VALUES (46, 2, 'solution_46', CURRENT_TIMESTAMP);
INSERT INTO Solution (solution_id, problem_category_id, solution, created) VALUES (47, 3, 'solution_47', CURRENT_TIMESTAMP);
INSERT INTO Solution (solution_id, problem_category_id, solution, created) VALUES (48, 2, 'solution_48', CURRENT_TIMESTAMP);
INSERT INTO Solution (solution_id, problem_category_id, solution, created) VALUES (49, 9, 'solution_49', CURRENT_TIMESTAMP);
INSERT INTO Solution (solution_id, problem_category_id, solution, created) VALUES (50, 7, 'solution_50', CURRENT_TIMESTAMP);
INSERT INTO Specialization (specialization_id, description, created) VALUES (1, 'description_1', CURRENT_TIMESTAMP);
INSERT INTO Specialization (specialization_id, description, created) VALUES (2, 'description_2', CURRENT_TIMESTAMP);
INSERT INTO Specialization (specialization_id, description, created) VALUES (3, 'description_3', CURRENT_TIMESTAMP);
INSERT INTO Specialization (specialization_id, description, created) VALUES (4, 'description_4', CURRENT_TIMESTAMP);
INSERT INTO Specialization (specialization_id, description, created) VALUES (5, 'description_5', CURRENT_TIMESTAMP);
INSERT INTO Specialization (specialization_id, description, created) VALUES (6, 'description_6', CURRENT_TIMESTAMP);
INSERT INTO Specialization (specialization_id, description, created) VALUES (7, 'description_7', CURRENT_TIMESTAMP);
INSERT INTO Specialization (specialization_id, description, created) VALUES (8, 'description_8', CURRENT_TIMESTAMP);
INSERT INTO Specialization (specialization_id, description, created) VALUES (9, 'description_9', CURRENT_TIMESTAMP);
INSERT INTO Specialist (specialist_id, name, psw, user_id, created) VALUES (1, 'name_1', 'psw_1', 'user_id_1', CURRENT_TIMESTAMP);
INSERT INTO Specialist_Specialization (specialist_id, specialization_id, created) VALUES (1, 2, CURRENT_TIMESTAMP);
INSERT INTO Specialist (specialist_id, name, psw, user_id, created) VALUES (2, 'name_2', 'psw_0', 'user_id_2', CURRENT_TIMESTAMP);
INSERT INTO Specialist_Specialization (specialist_id, specialization_id, created) VALUES (2, 3, CURRENT_TIMESTAMP);
INSERT INTO Specialist (specialist_id, name, psw, user_id, created) VALUES (3, 'name_3', 'psw_3', 'user_id_3', CURRENT_TIMESTAMP);
INSERT INTO Specialist_Specialization (specialist_id, specialization_id, created) VALUES (3, 9, CURRENT_TIMESTAMP);
INSERT INTO Specialist (specialist_id, name, psw, user_id, created) VALUES (4, 'name_4', 'psw_0', 'user_id_4', CURRENT_TIMESTAMP);
INSERT INTO Specialist_Specialization (specialist_id, specialization_id, created) VALUES (4, 5, CURRENT_TIMESTAMP);
INSERT INTO Specialist (specialist_id, name, psw, user_id, created) VALUES (5, 'name_0', 'psw_1', 'user_id_5', CURRENT_TIMESTAMP);
INSERT INTO Specialist_Specialization (specialist_id, specialization_id, created) VALUES (5, 8, CURRENT_TIMESTAMP);
INSERT INTO Specialist (specialist_id, name, psw, user_id, created) VALUES (6, 'name_0', 'psw_4', 'user_id_6', CURRENT_TIMESTAMP);
INSERT INTO Specialist_Specialization (specialist_id, specialization_id, created) VALUES (6, 4, CURRENT_TIMESTAMP);
INSERT INTO Specialist_Specialization (specialist_id, specialization_id, created) VALUES (2, 6, CURRENT_TIMESTAMP);
INSERT INTO Specialist_Specialization (specialist_id, specialization_id, created) VALUES (6, 7, CURRENT_TIMESTAMP);
INSERT INTO Specialist_Specialization (specialist_id, specialization_id, created) VALUES (5, 5, CURRENT_TIMESTAMP);
INSERT INTO Specialist_Specialization (specialist_id, specialization_id, created) VALUES (1, 6, CURRENT_TIMESTAMP);
INSERT INTO Specialist_Specialization (specialist_id, specialization_id, created) VALUES (3, 5, CURRENT_TIMESTAMP);
INSERT INTO Specialist_Specialization (specialist_id, specialization_id, created) VALUES (5, 1, CURRENT_TIMESTAMP);
INSERT INTO Specialist_Specialization (specialist_id, specialization_id, created) VALUES (3, 4, CURRENT_TIMESTAMP);
INSERT INTO Specialist_Specialization (specialist_id, specialization_id, created) VALUES (5, 9, CURRENT_TIMESTAMP);
INSERT INTO Specialist_Specialization (specialist_id, specialization_id, created) VALUES (4, 3, CURRENT_TIMESTAMP);
INSERT INTO Specialist_Specialization (specialist_id, specialization_id, created) VALUES (3, 2, CURRENT_TIMESTAMP);
INSERT INTO Specialist_Specialization (specialist_id, specialization_id, created) VALUES (1, 3, CURRENT_TIMESTAMP);
INSERT INTO Specialist_Specialization (specialist_id, specialization_id, created) VALUES (1, 1, CURRENT_TIMESTAMP);
INSERT INTO Specialist_Specialization (specialist_id, specialization_id, created) VALUES (6, 2, CURRENT_TIMESTAMP);
INSERT INTO Specialist_Specialization (specialist_id, specialization_id, created) VALUES (4, 8, CURRENT_TIMESTAMP);
INSERT INTO Specialist_Specialization (specialist_id, specialization_id, created) VALUES (4, 7, CURRENT_TIMESTAMP);
INSERT INTO Specialist_Specialization (specialist_id, specialization_id, created) VALUES (6, 3, CURRENT_TIMESTAMP);
INSERT INTO Specialist_Specialization (specialist_id, specialization_id, created) VALUES (4, 6, CURRENT_TIMESTAMP);
INSERT INTO Specialist_Specialization (specialist_id, specialization_id, created) VALUES (3, 7, CURRENT_TIMESTAMP);
INSERT INTO Specialist_Specialization (specialist_id, specialization_id, created) VALUES (6, 5, CURRENT_TIMESTAMP);
INSERT INTO Specialist_Specialization (specialist_id, specialization_id, created) VALUES (2, 9, CURRENT_TIMESTAMP);
INSERT INTO Specialization_ProblemCategory (specialization_id, problem_category_id, created) VALUES (3, 6, CURRENT_TIMESTAMP);
INSERT INTO Specialization_ProblemCategory (specialization_id, problem_category_id, created) VALUES (2, 2, CURRENT_TIMESTAMP);
INSERT INTO Specialization_ProblemCategory (specialization_id, problem_category_id, created) VALUES (7, 9, CURRENT_TIMESTAMP);
INSERT INTO Specialization_ProblemCategory (specialization_id, problem_category_id, created) VALUES (4, 4, CURRENT_TIMESTAMP);
INSERT INTO Specialization_ProblemCategory (specialization_id, problem_category_id, created) VALUES (3, 7, CURRENT_TIMESTAMP);
INSERT INTO Specialization_ProblemCategory (specialization_id, problem_category_id, created) VALUES (6, 5, CURRENT_TIMESTAMP);
INSERT INTO Specialization_ProblemCategory (specialization_id, problem_category_id, created) VALUES (1, 6, CURRENT_TIMESTAMP);
INSERT INTO Specialization_ProblemCategory (specialization_id, problem_category_id, created) VALUES (3, 4, CURRENT_TIMESTAMP);
INSERT INTO Specialization_ProblemCategory (specialization_id, problem_category_id, created) VALUES (5, 2, CURRENT_TIMESTAMP);
INSERT INTO Specialization_ProblemCategory (specialization_id, problem_category_id, created) VALUES (5, 4, CURRENT_TIMESTAMP);
INSERT INTO Specialization_ProblemCategory (specialization_id, problem_category_id, created) VALUES (5, 7, CURRENT_TIMESTAMP);
INSERT INTO Specialization_ProblemCategory (specialization_id, problem_category_id, created) VALUES (1, 5, CURRENT_TIMESTAMP);
INSERT INTO Specialization_ProblemCategory (specialization_id, problem_category_id, created) VALUES (9, 8, CURRENT_TIMESTAMP);
INSERT INTO Specialization_ProblemCategory (specialization_id, problem_category_id, created) VALUES (7, 4, CURRENT_TIMESTAMP);
INSERT INTO Specialization_ProblemCategory (specialization_id, problem_category_id, created) VALUES (3, 9, CURRENT_TIMESTAMP);
INSERT INTO Specialization_ProblemCategory (specialization_id, problem_category_id, created) VALUES (8, 1, CURRENT_TIMESTAMP);
INSERT INTO Specialization_ProblemCategory (specialization_id, problem_category_id, created) VALUES (8, 9, CURRENT_TIMESTAMP);
INSERT INTO Specialization_ProblemCategory (specialization_id, problem_category_id, created) VALUES (1, 1, CURRENT_TIMESTAMP);
INSERT INTO Specialization_ProblemCategory (specialization_id, problem_category_id, created) VALUES (2, 7, CURRENT_TIMESTAMP);
INSERT INTO Specialization_ProblemCategory (specialization_id, problem_category_id, created) VALUES (9, 4, CURRENT_TIMESTAMP);
INSERT INTO Specialization_ProblemCategory (specialization_id, problem_category_id, created) VALUES (5, 9, CURRENT_TIMESTAMP);
INSERT INTO Specialization_ProblemCategory (specialization_id, problem_category_id, created) VALUES (2, 1, CURRENT_TIMESTAMP);
INSERT INTO Specialization_ProblemCategory (specialization_id, problem_category_id, created) VALUES (3, 8, CURRENT_TIMESTAMP);
INSERT INTO Specialization_ProblemCategory (specialization_id, problem_category_id, created) VALUES (6, 8, CURRENT_TIMESTAMP);
INSERT INTO Specialization_ProblemCategory (specialization_id, problem_category_id, created) VALUES (3, 2, CURRENT_TIMESTAMP);
INSERT INTO Specialization_ProblemCategory (specialization_id, problem_category_id, created) VALUES (9, 7, CURRENT_TIMESTAMP);
INSERT INTO Specialization_ProblemCategory (specialization_id, problem_category_id, created) VALUES (7, 1, CURRENT_TIMESTAMP);
INSERT INTO Specialization_ProblemCategory (specialization_id, problem_category_id, created) VALUES (9, 1, CURRENT_TIMESTAMP);
INSERT INTO Specialization_ProblemCategory (specialization_id, problem_category_id, created) VALUES (9, 6, CURRENT_TIMESTAMP);
INSERT INTO Store (store_id, name, description, created) VALUES (1, 'name_1', 'description_1', CURRENT_TIMESTAMP);
INSERT INTO Store (store_id, name, description, created) VALUES (2, 'name_2', 'description_2', CURRENT_TIMESTAMP);
INSERT INTO Store (store_id, name, description, created) VALUES (3, 'name_3', 'description_3', CURRENT_TIMESTAMP);
INSERT INTO Store (store_id, name, description, created) VALUES (4, 'name_4', 'description_4', CURRENT_TIMESTAMP);
INSERT INTO Store (store_id, name, description, created) VALUES (5, 'name_5', 'description_5', CURRENT_TIMESTAMP);
INSERT INTO Store (store_id, name, description, created) VALUES (6, 'name_6', 'description_6', CURRENT_TIMESTAMP);
INSERT INTO Store (store_id, name, description, created) VALUES (7, 'name_7', 'description_7', CURRENT_TIMESTAMP);
INSERT INTO Store (store_id, name, description, created) VALUES (8, 'name_8', 'description_8', CURRENT_TIMESTAMP);
INSERT INTO Store (store_id, name, description, created) VALUES (9, 'name_9', 'description_9', CURRENT_TIMESTAMP);
INSERT INTO Store (store_id, name, description, created) VALUES (10, 'name_10', 'description_10', CURRENT_TIMESTAMP);
INSERT INTO Store (store_id, name, description, created) VALUES (11, 'name_11', 'description_11', CURRENT_TIMESTAMP);
INSERT INTO Store (store_id, name, description, created) VALUES (12, 'name_12', 'description_12', CURRENT_TIMESTAMP);
INSERT INTO Store (store_id, name, description, created) VALUES (13, 'name_13', 'description_13', CURRENT_TIMESTAMP);
INSERT INTO Store (store_id, name, description, created) VALUES (14, 'name_14', 'description_14', CURRENT_TIMESTAMP);
INSERT INTO Transactions (transactions_id, time, 	payment_method, created) VALUES (1, '2018-01-27 05:40:22', 'CC', CURRENT_TIMESTAMP);
INSERT INTO Item (item_id, transactions_id, store_id, price, item_type, name, description, created) VALUES (99999.0, 1, 10, 0, 'Home', 'name_1', 'description_1', CURRENT_TIMESTAMP);
INSERT INTO Transactions (transactions_id, time, 	payment_method, created) VALUES (2, '2018-01-20 02:44:17', 'NetBanking', CURRENT_TIMESTAMP);
INSERT INTO Item (item_id, transactions_id, store_id, price, item_type, name, description, created) VALUES (99998.0, 2, 5, 2, 'Home', 'name_2', 'description_2', CURRENT_TIMESTAMP);
INSERT INTO Transactions (transactions_id, time, 	payment_method, created) VALUES (3, '2018-02-15 11:16:17', 'NetBanking', CURRENT_TIMESTAMP);
INSERT INTO Item (item_id, transactions_id, store_id, price, item_type, name, description, created) VALUES (99997.0, 3, 4, 3, 'Health', 'name_3', 'description_3', CURRENT_TIMESTAMP);
INSERT INTO Transactions (transactions_id, time, 	payment_method, created) VALUES (4, '2018-02-01 12:43:17', 'NetBanking', CURRENT_TIMESTAMP);
INSERT INTO Item (item_id, transactions_id, store_id, price, item_type, name, description, created) VALUES (99996.0, 4, 1, 2, 'Health', 'name_4', 'description_4', CURRENT_TIMESTAMP);
INSERT INTO Transactions (transactions_id, time, 	payment_method, created) VALUES (5, '2018-01-28 09:01:15', 'NetBanking', CURRENT_TIMESTAMP);
INSERT INTO Item (item_id, transactions_id, store_id, price, item_type, name, description, created) VALUES (99995.0, 5, 3, 2, 'Books', 'name_5', 'description_5', CURRENT_TIMESTAMP);
INSERT INTO Transactions (transactions_id, time, 	payment_method, created) VALUES (6, '2018-02-03 20:37:21', 'CC', CURRENT_TIMESTAMP);
INSERT INTO Item (item_id, transactions_id, store_id, price, item_type, name, description, created) VALUES (99994.0, 6, 4, 5, 'Books', 'name_6', 'description_6', CURRENT_TIMESTAMP);
INSERT INTO Transactions (transactions_id, time, 	payment_method, created) VALUES (7, '2018-01-18 21:59:21', 'DebitCard', CURRENT_TIMESTAMP);
INSERT INTO Item (item_id, transactions_id, store_id, price, item_type, name, description, created) VALUES (99993.0, 7, 8, 7, 'Toys', 'name_7', 'description_7', CURRENT_TIMESTAMP);
INSERT INTO Transactions (transactions_id, time, 	payment_method, created) VALUES (8, '2018-01-23 04:34:18', 'NetBanking', CURRENT_TIMESTAMP);
INSERT INTO Item (item_id, transactions_id, store_id, price, item_type, name, description, created) VALUES (99992.0, 8, 11, 0, 'Home', 'name_8', 'description_8', CURRENT_TIMESTAMP);
INSERT INTO Transactions (transactions_id, time, 	payment_method, created) VALUES (9, '2018-02-12 17:10:02', 'NetBanking', CURRENT_TIMESTAMP);
INSERT INTO Item (item_id, transactions_id, store_id, price, item_type, name, description, created) VALUES (99991.0, 9, 8, 9, 'Books', 'name_9', 'description_9', CURRENT_TIMESTAMP);
INSERT INTO Transactions (transactions_id, time, 	payment_method, created) VALUES (10, '2018-01-10 05:08:54', 'DebitCard', CURRENT_TIMESTAMP);
INSERT INTO Item (item_id, transactions_id, store_id, price, item_type, name, description, created) VALUES (99990.0, 10, 10, 4, 'Home', 'name_10', 'description_10', CURRENT_TIMESTAMP);
INSERT INTO Transactions (transactions_id, time, 	payment_method, created) VALUES (11, '2018-01-23 14:21:59', 'DebitCard', CURRENT_TIMESTAMP);
INSERT INTO Item (item_id, transactions_id, store_id, price, item_type, name, description, created) VALUES (99989.0, 11, 10, 9, 'Home', 'name_11', 'description_11', CURRENT_TIMESTAMP);
INSERT INTO Transactions (transactions_id, time, 	payment_method, created) VALUES (12, '2018-02-12 04:52:34', 'NetBanking', CURRENT_TIMESTAMP);
INSERT INTO Item (item_id, transactions_id, store_id, price, item_type, name, description, created) VALUES (99988.0, 12, 6, 1, 'Health', 'name_12', 'description_12', CURRENT_TIMESTAMP);
INSERT INTO Transactions (transactions_id, time, 	payment_method, created) VALUES (13, '2018-01-24 15:34:07', 'NetBanking', CURRENT_TIMESTAMP);
INSERT INTO Item (item_id, transactions_id, store_id, price, item_type, name, description, created) VALUES (99987.0, 13, 2, 6, 'Toys', 'name_13', 'description_13', CURRENT_TIMESTAMP);
INSERT INTO Transactions (transactions_id, time, 	payment_method, created) VALUES (14, '2018-01-03 23:12:15', 'CC', CURRENT_TIMESTAMP);
INSERT INTO Item (item_id, transactions_id, store_id, price, item_type, name, description, created) VALUES (99986.0, 14, 3, 10, 'Home', 'name_14', 'description_14', CURRENT_TIMESTAMP);
INSERT INTO Transactions (transactions_id, time, 	payment_method, created) VALUES (15, '2018-02-19 05:19:44', 'PayPal', CURRENT_TIMESTAMP);
INSERT INTO Item (item_id, transactions_id, store_id, price, item_type, name, description, created) VALUES (99985.0, 15, 8, 7, 'Electronics', 'name_15', 'description_15', CURRENT_TIMESTAMP);
INSERT INTO Transactions (transactions_id, time, 	payment_method, created) VALUES (16, '2018-01-03 21:15:08', 'CC', CURRENT_TIMESTAMP);
INSERT INTO Item (item_id, transactions_id, store_id, price, item_type, name, description, created) VALUES (99984.0, 16, 3, 8, 'Home', 'name_16', 'description_16', CURRENT_TIMESTAMP);
INSERT INTO Transactions (transactions_id, time, 	payment_method, created) VALUES (17, '2018-01-14 18:41:29', 'DebitCard', CURRENT_TIMESTAMP);
INSERT INTO Item (item_id, transactions_id, store_id, price, item_type, name, description, created) VALUES (99983.0, 17, 10, 2, 'Electronics', 'name_17', 'description_17', CURRENT_TIMESTAMP);
INSERT INTO Transactions (transactions_id, time, 	payment_method, created) VALUES (18, '2018-01-19 13:23:22', 'NetBanking', CURRENT_TIMESTAMP);
INSERT INTO Item (item_id, transactions_id, store_id, price, item_type, name, description, created) VALUES (99982.0, 18, 10, 13, 'Electronics', 'name_18', 'description_18', CURRENT_TIMESTAMP);
INSERT INTO Transactions (transactions_id, time, 	payment_method, created) VALUES (19, '2018-01-15 01:43:25', 'DebitCard', CURRENT_TIMESTAMP);
INSERT INTO Item (item_id, transactions_id, store_id, price, item_type, name, description, created) VALUES (99981.0, 19, 14, 3, 'Electronics', 'name_19', 'description_19', CURRENT_TIMESTAMP);
INSERT INTO Transactions (transactions_id, time, 	payment_method, created) VALUES (20, '2018-01-16 13:24:25', 'CC', CURRENT_TIMESTAMP);
INSERT INTO Item (item_id, transactions_id, store_id, price, item_type, name, description, created) VALUES (99980.0, 20, 3, 0, 'Toys', 'name_20', 'description_20', CURRENT_TIMESTAMP);
INSERT INTO Transactions (transactions_id, time, 	payment_method, created) VALUES (21, '2018-01-31 07:22:16', 'CC', CURRENT_TIMESTAMP);
INSERT INTO Item (item_id, transactions_id, store_id, price, item_type, name, description, created) VALUES (99979.0, 21, 1, 17, 'Books', 'name_21', 'description_21', CURRENT_TIMESTAMP);
INSERT INTO Transactions (transactions_id, time, 	payment_method, created) VALUES (22, '2018-01-28 22:46:20', 'DebitCard', CURRENT_TIMESTAMP);
INSERT INTO Item (item_id, transactions_id, store_id, price, item_type, name, description, created) VALUES (99978.0, 22, 5, 8, 'Health', 'name_22', 'description_22', CURRENT_TIMESTAMP);
INSERT INTO Transactions (transactions_id, time, 	payment_method, created) VALUES (23, '2018-01-30 10:26:26', 'DebitCard', CURRENT_TIMESTAMP);
INSERT INTO Item (item_id, transactions_id, store_id, price, item_type, name, description, created) VALUES (99977.0, 23, 12, 20, 'Electronics', 'name_23', 'description_23', CURRENT_TIMESTAMP);
INSERT INTO Transactions (transactions_id, time, 	payment_method, created) VALUES (24, '2018-01-17 18:54:49', 'PayPal', CURRENT_TIMESTAMP);
INSERT INTO Item (item_id, transactions_id, store_id, price, item_type, name, description, created) VALUES (99976.0, 24, 6, 24, 'Books', 'name_24', 'description_24', CURRENT_TIMESTAMP);
INSERT INTO Transactions (transactions_id, time, 	payment_method, created) VALUES (25, '2018-01-22 04:57:49', 'CC', CURRENT_TIMESTAMP);
INSERT INTO Item (item_id, transactions_id, store_id, price, item_type, name, description, created) VALUES (99975.0, 25, 4, 24, 'Toys', 'name_25', 'description_25', CURRENT_TIMESTAMP);
INSERT INTO Transactions (transactions_id, time, 	payment_method, created) VALUES (26, '2018-02-12 19:13:39', 'NetBanking', CURRENT_TIMESTAMP);
INSERT INTO Item (item_id, transactions_id, store_id, price, item_type, name, description, created) VALUES (99974.0, 26, 2, 12, 'Electronics', 'name_26', 'description_26', CURRENT_TIMESTAMP);
INSERT INTO Transactions (transactions_id, time, 	payment_method, created) VALUES (27, '2018-01-16 14:44:17', 'CC', CURRENT_TIMESTAMP);
INSERT INTO Item (item_id, transactions_id, store_id, price, item_type, name, description, created) VALUES (99973.0, 27, 12, 19, 'Toys', 'name_27', 'description_27', CURRENT_TIMESTAMP);
INSERT INTO Transactions (transactions_id, time, 	payment_method, created) VALUES (28, '2018-02-12 11:39:47', 'PayPal', CURRENT_TIMESTAMP);
INSERT INTO Item (item_id, transactions_id, store_id, price, item_type, name, description, created) VALUES (99972.0, 28, 9, 23, 'Home', 'name_28', 'description_28', CURRENT_TIMESTAMP);
INSERT INTO Transactions (transactions_id, time, 	payment_method, created) VALUES (29, '2018-02-17 08:15:14', 'NetBanking', CURRENT_TIMESTAMP);
INSERT INTO Item (item_id, transactions_id, store_id, price, item_type, name, description, created) VALUES (99971.0, 29, 13, 29, 'Books', 'name_29', 'description_29', CURRENT_TIMESTAMP);
INSERT INTO Transactions (transactions_id, time, 	payment_method, created) VALUES (30, '2018-01-19 18:31:40', 'DebitCard', CURRENT_TIMESTAMP);
INSERT INTO Item (item_id, transactions_id, store_id, price, item_type, name, description, created) VALUES (99970.0, 30, 9, 4, 'Books', 'name_30', 'description_30', CURRENT_TIMESTAMP);
INSERT INTO Transactions (transactions_id, time, 	payment_method, created) VALUES (31, '2018-01-24 21:48:40', 'DebitCard', CURRENT_TIMESTAMP);
INSERT INTO Item (item_id, transactions_id, store_id, price, item_type, name, description, created) VALUES (99969.0, 31, 5, 14, 'Books', 'name_31', 'description_31', CURRENT_TIMESTAMP);
INSERT INTO Transactions (transactions_id, time, 	payment_method, created) VALUES (32, '2018-02-03 04:49:44', 'DebitCard', CURRENT_TIMESTAMP);
INSERT INTO Item (item_id, transactions_id, store_id, price, item_type, name, description, created) VALUES (99968.0, 32, 7, 27, 'Books', 'name_32', 'description_32', CURRENT_TIMESTAMP);
INSERT INTO Transactions (transactions_id, time, 	payment_method, created) VALUES (33, '2018-01-08 01:05:45', 'CC', CURRENT_TIMESTAMP);
INSERT INTO Item (item_id, transactions_id, store_id, price, item_type, name, description, created) VALUES (99967.0, 33, 11, 5, 'Home', 'name_33', 'description_33', CURRENT_TIMESTAMP);
INSERT INTO Transactions (transactions_id, time, 	payment_method, created) VALUES (34, '2018-02-13 16:54:02', 'PayPal', CURRENT_TIMESTAMP);
INSERT INTO Item (item_id, transactions_id, store_id, price, item_type, name, description, created) VALUES (99966.0, 34, 3, 15, 'Health', 'name_34', 'description_34', CURRENT_TIMESTAMP);
INSERT INTO Transactions (transactions_id, time, 	payment_method, created) VALUES (35, '2018-01-19 19:12:56', 'PayPal', CURRENT_TIMESTAMP);
INSERT INTO Item (item_id, transactions_id, store_id, price, item_type, name, description, created) VALUES (99965.0, 35, 9, 1, 'Toys', 'name_35', 'description_35', CURRENT_TIMESTAMP);
INSERT INTO Transactions (transactions_id, time, 	payment_method, created) VALUES (36, '2018-01-27 21:10:08', 'DebitCard', CURRENT_TIMESTAMP);
INSERT INTO Item (item_id, transactions_id, store_id, price, item_type, name, description, created) VALUES (99964.0, 36, 11, 12, 'Toys', 'name_36', 'description_36', CURRENT_TIMESTAMP);
INSERT INTO Transactions (transactions_id, time, 	payment_method, created) VALUES (37, '2018-01-15 02:31:46', 'CC', CURRENT_TIMESTAMP);
INSERT INTO Item (item_id, transactions_id, store_id, price, item_type, name, description, created) VALUES (99963.0, 37, 12, 28, 'Books', 'name_37', 'description_37', CURRENT_TIMESTAMP);
INSERT INTO Transactions (transactions_id, time, 	payment_method, created) VALUES (38, '2018-01-15 13:08:43', 'PayPal', CURRENT_TIMESTAMP);
INSERT INTO Item (item_id, transactions_id, store_id, price, item_type, name, description, created) VALUES (99962.0, 38, 1, 9, 'Toys', 'name_38', 'description_38', CURRENT_TIMESTAMP);
INSERT INTO Transactions (transactions_id, time, 	payment_method, created) VALUES (39, '2018-01-04 23:46:34', 'PayPal', CURRENT_TIMESTAMP);
INSERT INTO Item (item_id, transactions_id, store_id, price, item_type, name, description, created) VALUES (99961.0, 39, 10, 30, 'Home', 'name_39', 'description_39', CURRENT_TIMESTAMP);
INSERT INTO Transactions (transactions_id, time, 	payment_method, created) VALUES (40, '2018-02-11 18:52:16', 'DebitCard', CURRENT_TIMESTAMP);
INSERT INTO Item (item_id, transactions_id, store_id, price, item_type, name, description, created) VALUES (99960.0, 40, 11, 20, 'Health', 'name_40', 'description_40', CURRENT_TIMESTAMP);
INSERT INTO Transactions (transactions_id, time, 	payment_method, created) VALUES (41, '2018-01-28 10:46:10', 'CC', CURRENT_TIMESTAMP);
INSERT INTO Item (item_id, transactions_id, store_id, price, item_type, name, description, created) VALUES (99959.0, 41, 12, 35, 'Electronics', 'name_41', 'description_41', CURRENT_TIMESTAMP);
INSERT INTO Transactions (transactions_id, time, 	payment_method, created) VALUES (42, '2018-02-09 10:25:39', 'DebitCard', CURRENT_TIMESTAMP);
INSERT INTO Item (item_id, transactions_id, store_id, price, item_type, name, description, created) VALUES (99958.0, 42, 13, 31, 'Toys', 'name_42', 'description_42', CURRENT_TIMESTAMP);
INSERT INTO Transactions (transactions_id, time, 	payment_method, created) VALUES (43, '2018-01-23 16:22:31', 'CC', CURRENT_TIMESTAMP);
INSERT INTO Item (item_id, transactions_id, store_id, price, item_type, name, description, created) VALUES (99957.0, 43, 8, 37, 'Toys', 'name_43', 'description_43', CURRENT_TIMESTAMP);
INSERT INTO Transactions (transactions_id, time, 	payment_method, created) VALUES (44, '2018-02-16 09:12:13', 'NetBanking', CURRENT_TIMESTAMP);
INSERT INTO Item (item_id, transactions_id, store_id, price, item_type, name, description, created) VALUES (99956.0, 44, 12, 2, 'Health', 'name_44', 'description_44', CURRENT_TIMESTAMP);
INSERT INTO Transactions (transactions_id, time, 	payment_method, created) VALUES (45, '2018-01-16 15:54:22', 'PayPal', CURRENT_TIMESTAMP);
INSERT INTO Item (item_id, transactions_id, store_id, price, item_type, name, description, created) VALUES (99955.0, 45, 4, 22, 'Electronics', 'name_45', 'description_45', CURRENT_TIMESTAMP);
INSERT INTO Transactions (transactions_id, time, 	payment_method, created) VALUES (46, '2018-01-30 01:16:20', 'NetBanking', CURRENT_TIMESTAMP);
INSERT INTO Item (item_id, transactions_id, store_id, price, item_type, name, description, created) VALUES (99954.0, 46, 13, 37, 'Home', 'name_46', 'description_46', CURRENT_TIMESTAMP);
INSERT INTO Transactions (transactions_id, time, 	payment_method, created) VALUES (47, '2018-02-09 20:04:34', 'PayPal', CURRENT_TIMESTAMP);
INSERT INTO Item (item_id, transactions_id, store_id, price, item_type, name, description, created) VALUES (99953.0, 47, 10, 27, 'Toys', 'name_47', 'description_47', CURRENT_TIMESTAMP);
INSERT INTO Transactions (transactions_id, time, 	payment_method, created) VALUES (48, '2018-02-03 21:45:33', 'CC', CURRENT_TIMESTAMP);
INSERT INTO Item (item_id, transactions_id, store_id, price, item_type, name, description, created) VALUES (99952.0, 48, 2, 38, 'Home', 'name_48', 'description_48', CURRENT_TIMESTAMP);
INSERT INTO Transactions (transactions_id, time, 	payment_method, created) VALUES (49, '2018-01-11 14:17:49', 'CC', CURRENT_TIMESTAMP);
INSERT INTO Item (item_id, transactions_id, store_id, price, item_type, name, description, created) VALUES (99951.0, 49, 2, 4, 'Toys', 'name_49', 'description_49', CURRENT_TIMESTAMP);
INSERT INTO Transactions (transactions_id, time, 	payment_method, created) VALUES (50, '2018-02-09 04:42:15', 'DebitCard', CURRENT_TIMESTAMP);
INSERT INTO Item (item_id, transactions_id, store_id, price, item_type, name, description, created) VALUES (99950.0, 50, 8, 40, 'Books', 'name_50', 'description_50', CURRENT_TIMESTAMP);
INSERT INTO Transactions (transactions_id, time, 	payment_method, created) VALUES (51, '2018-01-13 15:58:59', 'DebitCard', CURRENT_TIMESTAMP);
INSERT INTO Item (item_id, transactions_id, store_id, price, item_type, name, description, created) VALUES (99949.0, 51, 10, 41, 'Books', 'name_51', 'description_51', CURRENT_TIMESTAMP);
INSERT INTO Transactions (transactions_id, time, 	payment_method, created) VALUES (52, '2018-01-30 12:39:16', 'CC', CURRENT_TIMESTAMP);
INSERT INTO Item (item_id, transactions_id, store_id, price, item_type, name, description, created) VALUES (99948.0, 52, 7, 42, 'Books', 'name_52', 'description_52', CURRENT_TIMESTAMP);
INSERT INTO Transactions (transactions_id, time, 	payment_method, created) VALUES (53, '2018-02-06 14:32:07', 'DebitCard', CURRENT_TIMESTAMP);
INSERT INTO Item (item_id, transactions_id, store_id, price, item_type, name, description, created) VALUES (99947.0, 53, 4, 36, 'Electronics', 'name_53', 'description_53', CURRENT_TIMESTAMP);
INSERT INTO Transactions (transactions_id, time, 	payment_method, created) VALUES (54, '2018-01-11 08:33:18', 'CC', CURRENT_TIMESTAMP);
INSERT INTO Item (item_id, transactions_id, store_id, price, item_type, name, description, created) VALUES (99946.0, 54, 12, 17, 'Home', 'name_54', 'description_54', CURRENT_TIMESTAMP);
INSERT INTO Transactions (transactions_id, time, 	payment_method, created) VALUES (55, '2018-01-07 16:02:11', 'DebitCard', CURRENT_TIMESTAMP);
INSERT INTO Item (item_id, transactions_id, store_id, price, item_type, name, description, created) VALUES (99945.0, 55, 8, 19, 'Health', 'name_55', 'description_55', CURRENT_TIMESTAMP);
INSERT INTO Transactions (transactions_id, time, 	payment_method, created) VALUES (56, '2018-02-13 18:25:25', 'CC', CURRENT_TIMESTAMP);
INSERT INTO Item (item_id, transactions_id, store_id, price, item_type, name, description, created) VALUES (99944.0, 56, 2, 34, 'Books', 'name_56', 'description_56', CURRENT_TIMESTAMP);
INSERT INTO Transactions (transactions_id, time, 	payment_method, created) VALUES (57, '2018-02-03 04:06:14', 'PayPal', CURRENT_TIMESTAMP);
INSERT INTO Item (item_id, transactions_id, store_id, price, item_type, name, description, created) VALUES (99943.0, 57, 10, 29, 'Books', 'name_57', 'description_57', CURRENT_TIMESTAMP);
INSERT INTO Transactions (transactions_id, time, 	payment_method, created) VALUES (58, '2018-01-10 10:14:12', 'DebitCard', CURRENT_TIMESTAMP);
INSERT INTO Item (item_id, transactions_id, store_id, price, item_type, name, description, created) VALUES (99942.0, 58, 9, 49, 'Electronics', 'name_58', 'description_58', CURRENT_TIMESTAMP);
INSERT INTO Transactions (transactions_id, time, 	payment_method, created) VALUES (59, '2018-01-06 19:25:36', 'PayPal', CURRENT_TIMESTAMP);
INSERT INTO Item (item_id, transactions_id, store_id, price, item_type, name, description, created) VALUES (99941.0, 59, 2, 44, 'Electronics', 'name_59', 'description_59', CURRENT_TIMESTAMP);
INSERT INTO Transactions (transactions_id, time, 	payment_method, created) VALUES (60, '2018-01-16 00:18:23', 'NetBanking', CURRENT_TIMESTAMP);
INSERT INTO Item (item_id, transactions_id, store_id, price, item_type, name, description, created) VALUES (99940.0, 60, 12, 8, 'Electronics', 'name_60', 'description_60', CURRENT_TIMESTAMP);
INSERT INTO Transactions (transactions_id, time, 	payment_method, created) VALUES (61, '2018-01-07 07:38:33', 'CC', CURRENT_TIMESTAMP);
INSERT INTO Item (item_id, transactions_id, store_id, price, item_type, name, description, created) VALUES (99939.0, 61, 12, 26, 'Toys', 'name_61', 'description_61', CURRENT_TIMESTAMP);
INSERT INTO Transactions (transactions_id, time, 	payment_method, created) VALUES (62, '2018-02-08 21:40:43', 'PayPal', CURRENT_TIMESTAMP);
INSERT INTO Item (item_id, transactions_id, store_id, price, item_type, name, description, created) VALUES (99938.0, 62, 3, 7, 'Books', 'name_62', 'description_62', CURRENT_TIMESTAMP);
INSERT INTO Transactions (transactions_id, time, 	payment_method, created) VALUES (63, '2018-02-10 14:03:26', 'CC', CURRENT_TIMESTAMP);
INSERT INTO Item (item_id, transactions_id, store_id, price, item_type, name, description, created) VALUES (99937.0, 63, 13, 51, 'Home', 'name_63', 'description_63', CURRENT_TIMESTAMP);
INSERT INTO Transactions (transactions_id, time, 	payment_method, created) VALUES (64, '2018-01-29 12:32:20', 'DebitCard', CURRENT_TIMESTAMP);
INSERT INTO Item (item_id, transactions_id, store_id, price, item_type, name, description, created) VALUES (99936.0, 64, 13, 39, 'Toys', 'name_64', 'description_64', CURRENT_TIMESTAMP);
INSERT INTO Transactions (transactions_id, time, 	payment_method, created) VALUES (65, '2018-01-05 17:11:14', 'PayPal', CURRENT_TIMESTAMP);
INSERT INTO Item (item_id, transactions_id, store_id, price, item_type, name, description, created) VALUES (99935.0, 65, 14, 24, 'Health', 'name_65', 'description_65', CURRENT_TIMESTAMP);
INSERT INTO Transactions (transactions_id, time, 	payment_method, created) VALUES (66, '2018-01-07 02:40:58', 'CC', CURRENT_TIMESTAMP);
INSERT INTO Item (item_id, transactions_id, store_id, price, item_type, name, description, created) VALUES (99934.0, 66, 10, 54, 'Health', 'name_66', 'description_66', CURRENT_TIMESTAMP);
INSERT INTO Transactions (transactions_id, time, 	payment_method, created) VALUES (67, '2018-02-17 19:55:37', 'CC', CURRENT_TIMESTAMP);
INSERT INTO Item (item_id, transactions_id, store_id, price, item_type, name, description, created) VALUES (99933.0, 67, 14, 23, 'Books', 'name_67', 'description_67', CURRENT_TIMESTAMP);
INSERT INTO Transactions (transactions_id, time, 	payment_method, created) VALUES (68, '2018-01-17 16:33:55', 'CC', CURRENT_TIMESTAMP);
INSERT INTO Item (item_id, transactions_id, store_id, price, item_type, name, description, created) VALUES (99932.0, 68, 1, 21, 'Electronics', 'name_68', 'description_68', CURRENT_TIMESTAMP);
INSERT INTO Transactions (transactions_id, time, 	payment_method, created) VALUES (69, '2018-02-12 22:12:37', 'NetBanking', CURRENT_TIMESTAMP);
INSERT INTO Item (item_id, transactions_id, store_id, price, item_type, name, description, created) VALUES (99931.0, 69, 7, 5, 'Electronics', 'name_69', 'description_69', CURRENT_TIMESTAMP);
INSERT INTO Transactions (transactions_id, time, 	payment_method, created) VALUES (70, '2018-01-09 02:11:19', 'DebitCard', CURRENT_TIMESTAMP);
INSERT INTO Item (item_id, transactions_id, store_id, price, item_type, name, description, created) VALUES (99930.0, 70, 13, 55, 'Health', 'name_70', 'description_70', CURRENT_TIMESTAMP);
INSERT INTO Transactions (transactions_id, time, 	payment_method, created) VALUES (71, '2018-01-31 05:54:28', 'DebitCard', CURRENT_TIMESTAMP);
INSERT INTO Item (item_id, transactions_id, store_id, price, item_type, name, description, created) VALUES (99929.0, 71, 5, 54, 'Electronics', 'name_71', 'description_71', CURRENT_TIMESTAMP);
INSERT INTO Transactions (transactions_id, time, 	payment_method, created) VALUES (72, '2018-01-28 11:13:45', 'PayPal', CURRENT_TIMESTAMP);
INSERT INTO Item (item_id, transactions_id, store_id, price, item_type, name, description, created) VALUES (99928.0, 72, 14, 12, 'Home', 'name_72', 'description_72', CURRENT_TIMESTAMP);
INSERT INTO Transactions (transactions_id, time, 	payment_method, created) VALUES (73, '2018-01-16 03:23:55', 'NetBanking', CURRENT_TIMESTAMP);
INSERT INTO Item (item_id, transactions_id, store_id, price, item_type, name, description, created) VALUES (99927.0, 73, 2, 17, 'Home', 'name_73', 'description_73', CURRENT_TIMESTAMP);
INSERT INTO Transactions (transactions_id, time, 	payment_method, created) VALUES (74, '2018-01-29 01:47:19', 'PayPal', CURRENT_TIMESTAMP);
INSERT INTO Item (item_id, transactions_id, store_id, price, item_type, name, description, created) VALUES (99926.0, 74, 3, 49, 'Toys', 'name_74', 'description_74', CURRENT_TIMESTAMP);
INSERT INTO Transactions (transactions_id, time, 	payment_method, created) VALUES (75, '2018-01-05 07:20:59', 'NetBanking', CURRENT_TIMESTAMP);
INSERT INTO Item (item_id, transactions_id, store_id, price, item_type, name, description, created) VALUES (99925.0, 75, 1, 5, 'Electronics', 'name_75', 'description_75', CURRENT_TIMESTAMP);
INSERT INTO Transactions (transactions_id, time, 	payment_method, created) VALUES (76, '2018-01-23 22:41:03', 'PayPal', CURRENT_TIMESTAMP);
INSERT INTO Item (item_id, transactions_id, store_id, price, item_type, name, description, created) VALUES (99924.0, 76, 2, 59, 'Health', 'name_76', 'description_76', CURRENT_TIMESTAMP);
INSERT INTO Transactions (transactions_id, time, 	payment_method, created) VALUES (77, '2018-01-30 07:51:11', 'PayPal', CURRENT_TIMESTAMP);
INSERT INTO Item (item_id, transactions_id, store_id, price, item_type, name, description, created) VALUES (99923.0, 77, 11, 73, 'Health', 'name_77', 'description_77', CURRENT_TIMESTAMP);
INSERT INTO Transactions (transactions_id, time, 	payment_method, created) VALUES (78, '2018-02-12 11:41:20', 'PayPal', CURRENT_TIMESTAMP);
INSERT INTO Item (item_id, transactions_id, store_id, price, item_type, name, description, created) VALUES (99922.0, 78, 13, 50, 'Health', 'name_78', 'description_78', CURRENT_TIMESTAMP);
INSERT INTO Transactions (transactions_id, time, 	payment_method, created) VALUES (79, '2018-01-14 19:35:40', 'NetBanking', CURRENT_TIMESTAMP);
INSERT INTO Item (item_id, transactions_id, store_id, price, item_type, name, description, created) VALUES (99921.0, 79, 3, 25, 'Electronics', 'name_79', 'description_79', CURRENT_TIMESTAMP);
INSERT INTO Transactions (transactions_id, time, 	payment_method, created) VALUES (80, '2018-01-09 06:08:47', 'PayPal', CURRENT_TIMESTAMP);
INSERT INTO Item (item_id, transactions_id, store_id, price, item_type, name, description, created) VALUES (99920.0, 80, 1, 33, 'Toys', 'name_80', 'description_80', CURRENT_TIMESTAMP);
INSERT INTO Transactions (transactions_id, time, 	payment_method, created) VALUES (81, '2018-01-27 05:51:03', 'DebitCard', CURRENT_TIMESTAMP);
INSERT INTO Item (item_id, transactions_id, store_id, price, item_type, name, description, created) VALUES (99919.0, 81, 2, 66, 'Home', 'name_81', 'description_81', CURRENT_TIMESTAMP);
INSERT INTO Transactions (transactions_id, time, 	payment_method, created) VALUES (82, '2018-01-07 05:03:41', 'PayPal', CURRENT_TIMESTAMP);
INSERT INTO Item (item_id, transactions_id, store_id, price, item_type, name, description, created) VALUES (99918.0, 82, 2, 58, 'Toys', 'name_82', 'description_82', CURRENT_TIMESTAMP);
INSERT INTO Transactions (transactions_id, time, 	payment_method, created) VALUES (83, '2018-02-20 09:38:59', 'NetBanking', CURRENT_TIMESTAMP);
INSERT INTO Item (item_id, transactions_id, store_id, price, item_type, name, description, created) VALUES (99917.0, 83, 7, 41, 'Toys', 'name_83', 'description_83', CURRENT_TIMESTAMP);
INSERT INTO Transactions (transactions_id, time, 	payment_method, created) VALUES (84, '2018-01-14 05:41:49', 'PayPal', CURRENT_TIMESTAMP);
INSERT INTO Item (item_id, transactions_id, store_id, price, item_type, name, description, created) VALUES (99916.0, 84, 7, 67, 'Books', 'name_84', 'description_84', CURRENT_TIMESTAMP);
INSERT INTO Transactions (transactions_id, time, 	payment_method, created) VALUES (85, '2018-02-20 07:29:17', 'DebitCard', CURRENT_TIMESTAMP);
INSERT INTO Item (item_id, transactions_id, store_id, price, item_type, name, description, created) VALUES (99915.0, 85, 1, 80, 'Health', 'name_85', 'description_85', CURRENT_TIMESTAMP);
INSERT INTO Transactions (transactions_id, time, 	payment_method, created) VALUES (86, '2018-02-07 01:11:23', 'CC', CURRENT_TIMESTAMP);
INSERT INTO Item (item_id, transactions_id, store_id, price, item_type, name, description, created) VALUES (99914.0, 86, 6, 78, 'Electronics', 'name_86', 'description_86', CURRENT_TIMESTAMP);
INSERT INTO Transactions (transactions_id, time, 	payment_method, created) VALUES (87, '2018-01-08 02:37:51', 'DebitCard', CURRENT_TIMESTAMP);
INSERT INTO Item (item_id, transactions_id, store_id, price, item_type, name, description, created) VALUES (99913.0, 87, 11, 74, 'Books', 'name_87', 'description_87', CURRENT_TIMESTAMP);
INSERT INTO Transactions (transactions_id, time, 	payment_method, created) VALUES (88, '2018-01-29 18:28:48', 'DebitCard', CURRENT_TIMESTAMP);
INSERT INTO Item (item_id, transactions_id, store_id, price, item_type, name, description, created) VALUES (99912.0, 88, 8, 64, 'Toys', 'name_88', 'description_88', CURRENT_TIMESTAMP);
INSERT INTO Transactions (transactions_id, time, 	payment_method, created) VALUES (89, '2018-01-25 07:38:52', 'CC', CURRENT_TIMESTAMP);
INSERT INTO Item (item_id, transactions_id, store_id, price, item_type, name, description, created) VALUES (99911.0, 89, 7, 62, 'Home', 'name_89', 'description_89', CURRENT_TIMESTAMP);
INSERT INTO Transactions (transactions_id, time, 	payment_method, created) VALUES (90, '2018-02-19 13:14:30', 'PayPal', CURRENT_TIMESTAMP);
INSERT INTO Item (item_id, transactions_id, store_id, price, item_type, name, description, created) VALUES (99910.0, 90, 2, 63, 'Electronics', 'name_90', 'description_90', CURRENT_TIMESTAMP);
INSERT INTO Transactions (transactions_id, time, 	payment_method, created) VALUES (91, '2018-02-14 12:34:18', 'NetBanking', CURRENT_TIMESTAMP);
INSERT INTO Item (item_id, transactions_id, store_id, price, item_type, name, description, created) VALUES (99909.0, 91, 12, 49, 'Home', 'name_91', 'description_91', CURRENT_TIMESTAMP);
INSERT INTO Transactions (transactions_id, time, 	payment_method, created) VALUES (92, '2018-02-09 20:11:53', 'NetBanking', CURRENT_TIMESTAMP);
INSERT INTO Item (item_id, transactions_id, store_id, price, item_type, name, description, created) VALUES (99908.0, 92, 7, 3, 'Electronics', 'name_92', 'description_92', CURRENT_TIMESTAMP);
INSERT INTO Transactions (transactions_id, time, 	payment_method, created) VALUES (93, '2018-01-03 10:49:58', 'NetBanking', CURRENT_TIMESTAMP);
INSERT INTO Item (item_id, transactions_id, store_id, price, item_type, name, description, created) VALUES (99907.0, 93, 1, 3, 'Toys', 'name_93', 'description_93', CURRENT_TIMESTAMP);
INSERT INTO Transactions (transactions_id, time, 	payment_method, created) VALUES (94, '2018-02-13 10:08:33', 'CC', CURRENT_TIMESTAMP);
INSERT INTO Item (item_id, transactions_id, store_id, price, item_type, name, description, created) VALUES (99906.0, 94, 13, 25, 'Health', 'name_94', 'description_94', CURRENT_TIMESTAMP);
INSERT INTO Transactions (transactions_id, time, 	payment_method, created) VALUES (95, '2018-01-16 21:12:32', 'CC', CURRENT_TIMESTAMP);
INSERT INTO Item (item_id, transactions_id, store_id, price, item_type, name, description, created) VALUES (99905.0, 95, 14, 0, 'Electronics', 'name_95', 'description_95', CURRENT_TIMESTAMP);
INSERT INTO Transactions (transactions_id, time, 	payment_method, created) VALUES (96, '2018-02-13 22:04:16', 'PayPal', CURRENT_TIMESTAMP);
INSERT INTO Item (item_id, transactions_id, store_id, price, item_type, name, description, created) VALUES (99904.0, 96, 10, 27, 'Home', 'name_96', 'description_96', CURRENT_TIMESTAMP);
INSERT INTO Transactions (transactions_id, time, 	payment_method, created) VALUES (97, '2018-02-07 10:16:44', 'DebitCard', CURRENT_TIMESTAMP);
INSERT INTO Item (item_id, transactions_id, store_id, price, item_type, name, description, created) VALUES (99903.0, 97, 10, 73, 'Toys', 'name_97', 'description_97', CURRENT_TIMESTAMP);
INSERT INTO Transactions (transactions_id, time, 	payment_method, created) VALUES (98, '2018-01-15 12:40:15', 'PayPal', CURRENT_TIMESTAMP);
INSERT INTO Item (item_id, transactions_id, store_id, price, item_type, name, description, created) VALUES (99902.0, 98, 8, 95, 'Health', 'name_98', 'description_98', CURRENT_TIMESTAMP);
INSERT INTO Transactions (transactions_id, time, 	payment_method, created) VALUES (99, '2018-01-25 19:51:55', 'PayPal', CURRENT_TIMESTAMP);
INSERT INTO Item (item_id, transactions_id, store_id, price, item_type, name, description, created) VALUES (99901.0, 99, 7, 81, 'Electronics', 'name_99', 'description_99', CURRENT_TIMESTAMP);
INSERT INTO Transactions (transactions_id, time, 	payment_method, created) VALUES (100, '2018-01-09 11:12:11', 'DebitCard', CURRENT_TIMESTAMP);
INSERT INTO Item (item_id, transactions_id, store_id, price, item_type, name, description, created) VALUES (99900.0, 100, 7, 19, 'Toys', 'name_100', 'description_100', CURRENT_TIMESTAMP);
INSERT INTO Transactions (transactions_id, time, 	payment_method, created) VALUES (101, '2018-01-06 14:23:51', 'PayPal', CURRENT_TIMESTAMP);
INSERT INTO Item (item_id, transactions_id, store_id, price, item_type, name, description, created) VALUES (99899.0, 101, 12, 10, 'Books', 'name_101', 'description_101', CURRENT_TIMESTAMP);
INSERT INTO Transactions (transactions_id, time, 	payment_method, created) VALUES (102, '2018-02-04 19:37:40', 'DebitCard', CURRENT_TIMESTAMP);
INSERT INTO Item (item_id, transactions_id, store_id, price, item_type, name, description, created) VALUES (99898.0, 102, 11, 44, 'Toys', 'name_102', 'description_102', CURRENT_TIMESTAMP);
INSERT INTO Transactions (transactions_id, time, 	payment_method, created) VALUES (103, '2018-01-24 06:01:16', 'CC', CURRENT_TIMESTAMP);
INSERT INTO Item (item_id, transactions_id, store_id, price, item_type, name, description, created) VALUES (99897.0, 103, 10, 87, 'Electronics', 'name_103', 'description_103', CURRENT_TIMESTAMP);
INSERT INTO Transactions (transactions_id, time, 	payment_method, created) VALUES (104, '2018-01-16 18:50:00', 'CC', CURRENT_TIMESTAMP);
INSERT INTO Item (item_id, transactions_id, store_id, price, item_type, name, description, created) VALUES (99896.0, 104, 3, 29, 'Books', 'name_104', 'description_104', CURRENT_TIMESTAMP);
INSERT INTO Transactions (transactions_id, time, 	payment_method, created) VALUES (105, '2018-01-12 17:08:55', 'NetBanking', CURRENT_TIMESTAMP);
INSERT INTO Item (item_id, transactions_id, store_id, price, item_type, name, description, created) VALUES (99895.0, 105, 13, 77, 'Toys', 'name_105', 'description_105', CURRENT_TIMESTAMP);
INSERT INTO Transactions (transactions_id, time, 	payment_method, created) VALUES (106, '2018-02-11 10:35:35', 'NetBanking', CURRENT_TIMESTAMP);
INSERT INTO Item (item_id, transactions_id, store_id, price, item_type, name, description, created) VALUES (99894.0, 106, 13, 40, 'Electronics', 'name_106', 'description_106', CURRENT_TIMESTAMP);
INSERT INTO Transactions (transactions_id, time, 	payment_method, created) VALUES (107, '2018-01-26 08:02:42', 'DebitCard', CURRENT_TIMESTAMP);
INSERT INTO Item (item_id, transactions_id, store_id, price, item_type, name, description, created) VALUES (99893.0, 107, 13, 68, 'Health', 'name_107', 'description_107', CURRENT_TIMESTAMP);
INSERT INTO Transactions (transactions_id, time, 	payment_method, created) VALUES (108, '2018-01-09 08:25:06', 'CC', CURRENT_TIMESTAMP);
INSERT INTO Item (item_id, transactions_id, store_id, price, item_type, name, description, created) VALUES (99892.0, 108, 5, 40, 'Toys', 'name_108', 'description_108', CURRENT_TIMESTAMP);
INSERT INTO Transactions (transactions_id, time, 	payment_method, created) VALUES (109, '2018-01-31 16:15:23', 'CC', CURRENT_TIMESTAMP);
INSERT INTO Item (item_id, transactions_id, store_id, price, item_type, name, description, created) VALUES (99891.0, 109, 13, 65, 'Health', 'name_109', 'description_109', CURRENT_TIMESTAMP);
INSERT INTO Transactions (transactions_id, time, 	payment_method, created) VALUES (110, '2018-01-16 02:34:40', 'DebitCard', CURRENT_TIMESTAMP);
INSERT INTO Item (item_id, transactions_id, store_id, price, item_type, name, description, created) VALUES (99890.0, 110, 12, 27, 'Health', 'name_110', 'description_110', CURRENT_TIMESTAMP);
INSERT INTO Transactions (transactions_id, time, 	payment_method, created) VALUES (111, '2018-02-05 05:12:28', 'NetBanking', CURRENT_TIMESTAMP);
INSERT INTO Item (item_id, transactions_id, store_id, price, item_type, name, description, created) VALUES (99889.0, 111, 5, 77, 'Electronics', 'name_111', 'description_111', CURRENT_TIMESTAMP);
INSERT INTO Transactions (transactions_id, time, 	payment_method, created) VALUES (112, '2018-02-15 05:50:37', 'NetBanking', CURRENT_TIMESTAMP);
INSERT INTO Item (item_id, transactions_id, store_id, price, item_type, name, description, created) VALUES (99888.0, 112, 2, 102, 'Health', 'name_112', 'description_112', CURRENT_TIMESTAMP);
INSERT INTO Transactions (transactions_id, time, 	payment_method, created) VALUES (113, '2018-01-11 09:53:08', 'PayPal', CURRENT_TIMESTAMP);
INSERT INTO Item (item_id, transactions_id, store_id, price, item_type, name, description, created) VALUES (99887.0, 113, 11, 24, 'Books', 'name_113', 'description_113', CURRENT_TIMESTAMP);
INSERT INTO Transactions (transactions_id, time, 	payment_method, created) VALUES (114, '2018-02-07 09:17:19', 'DebitCard', CURRENT_TIMESTAMP);
INSERT INTO Item (item_id, transactions_id, store_id, price, item_type, name, description, created) VALUES (99886.0, 114, 1, 16, 'Toys', 'name_114', 'description_114', CURRENT_TIMESTAMP);
INSERT INTO Transactions (transactions_id, time, 	payment_method, created) VALUES (115, '2018-02-12 00:59:18', 'DebitCard', CURRENT_TIMESTAMP);
INSERT INTO Item (item_id, transactions_id, store_id, price, item_type, name, description, created) VALUES (99885.0, 115, 1, 82, 'Toys', 'name_115', 'description_115', CURRENT_TIMESTAMP);
INSERT INTO Transactions (transactions_id, time, 	payment_method, created) VALUES (116, '2018-02-06 19:46:32', 'DebitCard', CURRENT_TIMESTAMP);
INSERT INTO Item (item_id, transactions_id, store_id, price, item_type, name, description, created) VALUES (99884.0, 116, 13, 110, 'Home', 'name_116', 'description_116', CURRENT_TIMESTAMP);
INSERT INTO Transactions (transactions_id, time, 	payment_method, created) VALUES (117, '2018-02-05 23:09:00', 'NetBanking', CURRENT_TIMESTAMP);
INSERT INTO Item (item_id, transactions_id, store_id, price, item_type, name, description, created) VALUES (99883.0, 117, 14, 97, 'Health', 'name_117', 'description_117', CURRENT_TIMESTAMP);
INSERT INTO Transactions (transactions_id, time, 	payment_method, created) VALUES (118, '2018-02-14 16:59:46', 'CC', CURRENT_TIMESTAMP);
INSERT INTO Item (item_id, transactions_id, store_id, price, item_type, name, description, created) VALUES (99882.0, 118, 8, 33, 'Books', 'name_118', 'description_118', CURRENT_TIMESTAMP);
INSERT INTO Transactions (transactions_id, time, 	payment_method, created) VALUES (119, '2018-01-04 03:34:35', 'NetBanking', CURRENT_TIMESTAMP);
INSERT INTO Item (item_id, transactions_id, store_id, price, item_type, name, description, created) VALUES (99881.0, 119, 2, 113, 'Home', 'name_119', 'description_119', CURRENT_TIMESTAMP);
INSERT INTO Transactions (transactions_id, time, 	payment_method, created) VALUES (120, '2018-01-16 01:59:33', 'CC', CURRENT_TIMESTAMP);
INSERT INTO Item (item_id, transactions_id, store_id, price, item_type, name, description, created) VALUES (99880.0, 120, 5, 119, 'Books', 'name_120', 'description_120', CURRENT_TIMESTAMP);
INSERT INTO Transactions (transactions_id, time, 	payment_method, created) VALUES (121, '2018-01-08 09:32:19', 'PayPal', CURRENT_TIMESTAMP);
INSERT INTO Item (item_id, transactions_id, store_id, price, item_type, name, description, created) VALUES (99879.0, 121, 9, 50, 'Home', 'name_121', 'description_121', CURRENT_TIMESTAMP);
INSERT INTO Transactions (transactions_id, time, 	payment_method, created) VALUES (122, '2018-01-07 07:06:33', 'PayPal', CURRENT_TIMESTAMP);
INSERT INTO Item (item_id, transactions_id, store_id, price, item_type, name, description, created) VALUES (99878.0, 122, 13, 35, 'Home', 'name_122', 'description_122', CURRENT_TIMESTAMP);
INSERT INTO Transactions (transactions_id, time, 	payment_method, created) VALUES (123, '2018-01-27 07:48:24', 'NetBanking', CURRENT_TIMESTAMP);
INSERT INTO Item (item_id, transactions_id, store_id, price, item_type, name, description, created) VALUES (99877.0, 123, 4, 12, 'Health', 'name_123', 'description_123', CURRENT_TIMESTAMP);
INSERT INTO Transactions (transactions_id, time, 	payment_method, created) VALUES (124, '2018-02-12 09:48:09', 'DebitCard', CURRENT_TIMESTAMP);
INSERT INTO Item (item_id, transactions_id, store_id, price, item_type, name, description, created) VALUES (99876.0, 124, 13, 37, 'Home', 'name_124', 'description_124', CURRENT_TIMESTAMP);
INSERT INTO Transactions (transactions_id, time, 	payment_method, created) VALUES (125, '2018-01-17 08:59:38', 'CC', CURRENT_TIMESTAMP);
INSERT INTO Item (item_id, transactions_id, store_id, price, item_type, name, description, created) VALUES (99875.0, 125, 11, 95, 'Books', 'name_125', 'description_125', CURRENT_TIMESTAMP);
INSERT INTO Transactions (transactions_id, time, 	payment_method, created) VALUES (126, '2018-02-18 16:36:09', 'DebitCard', CURRENT_TIMESTAMP);
INSERT INTO Item (item_id, transactions_id, store_id, price, item_type, name, description, created) VALUES (99874.0, 126, 14, 75, 'Electronics', 'name_126', 'description_126', CURRENT_TIMESTAMP);
INSERT INTO Transactions (transactions_id, time, 	payment_method, created) VALUES (127, '2018-01-26 08:25:15', 'NetBanking', CURRENT_TIMESTAMP);
INSERT INTO Item (item_id, transactions_id, store_id, price, item_type, name, description, created) VALUES (99873.0, 127, 9, 116, 'Health', 'name_127', 'description_127', CURRENT_TIMESTAMP);
INSERT INTO Transactions (transactions_id, time, 	payment_method, created) VALUES (128, '2018-01-30 13:06:46', 'DebitCard', CURRENT_TIMESTAMP);
INSERT INTO Item (item_id, transactions_id, store_id, price, item_type, name, description, created) VALUES (99872.0, 128, 1, 107, 'Toys', 'name_128', 'description_128', CURRENT_TIMESTAMP);
INSERT INTO Transactions (transactions_id, time, 	payment_method, created) VALUES (129, '2018-02-18 18:54:48', 'NetBanking', CURRENT_TIMESTAMP);
INSERT INTO Item (item_id, transactions_id, store_id, price, item_type, name, description, created) VALUES (99871.0, 129, 10, 45, 'Electronics', 'name_129', 'description_129', CURRENT_TIMESTAMP);
INSERT INTO Transactions (transactions_id, time, 	payment_method, created) VALUES (130, '2018-02-20 16:08:13', 'CC', CURRENT_TIMESTAMP);
INSERT INTO Item (item_id, transactions_id, store_id, price, item_type, name, description, created) VALUES (99870.0, 130, 14, 32, 'Health', 'name_130', 'description_130', CURRENT_TIMESTAMP);
INSERT INTO Transactions (transactions_id, time, 	payment_method, created) VALUES (131, '2018-01-26 02:00:49', 'DebitCard', CURRENT_TIMESTAMP);
INSERT INTO Item (item_id, transactions_id, store_id, price, item_type, name, description, created) VALUES (99869.0, 131, 9, 79, 'Books', 'name_131', 'description_131', CURRENT_TIMESTAMP);
INSERT INTO Transactions (transactions_id, time, 	payment_method, created) VALUES (132, '2018-01-25 17:26:26', 'PayPal', CURRENT_TIMESTAMP);
INSERT INTO Item (item_id, transactions_id, store_id, price, item_type, name, description, created) VALUES (99868.0, 132, 12, 74, 'Toys', 'name_132', 'description_132', CURRENT_TIMESTAMP);
INSERT INTO Transactions (transactions_id, time, 	payment_method, created) VALUES (133, '2018-01-26 03:35:27', 'CC', CURRENT_TIMESTAMP);
INSERT INTO Item (item_id, transactions_id, store_id, price, item_type, name, description, created) VALUES (99867.0, 133, 14, 112, 'Electronics', 'name_133', 'description_133', CURRENT_TIMESTAMP);
INSERT INTO Transactions (transactions_id, time, 	payment_method, created) VALUES (134, '2018-02-09 10:21:31', 'DebitCard', CURRENT_TIMESTAMP);
INSERT INTO Item (item_id, transactions_id, store_id, price, item_type, name, description, created) VALUES (99866.0, 134, 2, 48, 'Toys', 'name_134', 'description_134', CURRENT_TIMESTAMP);
INSERT INTO Transactions (transactions_id, time, 	payment_method, created) VALUES (135, '2018-02-06 07:09:03', 'DebitCard', CURRENT_TIMESTAMP);
INSERT INTO Item (item_id, transactions_id, store_id, price, item_type, name, description, created) VALUES (99865.0, 135, 5, 134, 'Toys', 'name_135', 'description_135', CURRENT_TIMESTAMP);
INSERT INTO Transactions (transactions_id, time, 	payment_method, created) VALUES (136, '2018-02-04 19:41:04', 'DebitCard', CURRENT_TIMESTAMP);
INSERT INTO Item (item_id, transactions_id, store_id, price, item_type, name, description, created) VALUES (99864.0, 136, 10, 30, 'Books', 'name_136', 'description_136', CURRENT_TIMESTAMP);
INSERT INTO Transactions (transactions_id, time, 	payment_method, created) VALUES (137, '2018-02-18 21:21:16', 'PayPal', CURRENT_TIMESTAMP);
INSERT INTO Item (item_id, transactions_id, store_id, price, item_type, name, description, created) VALUES (99863.0, 137, 13, 49, 'Health', 'name_137', 'description_137', CURRENT_TIMESTAMP);
INSERT INTO Transactions (transactions_id, time, 	payment_method, created) VALUES (138, '2018-01-22 02:52:49', 'DebitCard', CURRENT_TIMESTAMP);
INSERT INTO Item (item_id, transactions_id, store_id, price, item_type, name, description, created) VALUES (99862.0, 138, 1, 76, 'Toys', 'name_138', 'description_138', CURRENT_TIMESTAMP);
INSERT INTO Transactions (transactions_id, time, 	payment_method, created) VALUES (139, '2018-01-19 14:28:17', 'PayPal', CURRENT_TIMESTAMP);
INSERT INTO Item (item_id, transactions_id, store_id, price, item_type, name, description, created) VALUES (99861.0, 139, 4, 78, 'Electronics', 'name_139', 'description_139', CURRENT_TIMESTAMP);
INSERT INTO Transactions (transactions_id, time, 	payment_method, created) VALUES (140, '2018-01-18 17:21:20', 'NetBanking', CURRENT_TIMESTAMP);
INSERT INTO Item (item_id, transactions_id, store_id, price, item_type, name, description, created) VALUES (99860.0, 140, 2, 16, 'Home', 'name_140', 'description_140', CURRENT_TIMESTAMP);
INSERT INTO Transactions (transactions_id, time, 	payment_method, created) VALUES (141, '2018-02-15 04:20:15', 'NetBanking', CURRENT_TIMESTAMP);
INSERT INTO Item (item_id, transactions_id, store_id, price, item_type, name, description, created) VALUES (99859.0, 141, 13, 117, 'Health', 'name_141', 'description_141', CURRENT_TIMESTAMP);
INSERT INTO Transactions (transactions_id, time, 	payment_method, created) VALUES (142, '2018-01-15 16:35:06', 'NetBanking', CURRENT_TIMESTAMP);
INSERT INTO Item (item_id, transactions_id, store_id, price, item_type, name, description, created) VALUES (99858.0, 142, 1, 44, 'Toys', 'name_142', 'description_142', CURRENT_TIMESTAMP);
INSERT INTO Transactions (transactions_id, time, 	payment_method, created) VALUES (143, '2018-02-03 05:37:25', 'NetBanking', CURRENT_TIMESTAMP);
INSERT INTO Item (item_id, transactions_id, store_id, price, item_type, name, description, created) VALUES (99857.0, 143, 2, 77, 'Electronics', 'name_143', 'description_143', CURRENT_TIMESTAMP);
INSERT INTO Transactions (transactions_id, time, 	payment_method, created) VALUES (144, '2018-02-04 05:30:34', 'DebitCard', CURRENT_TIMESTAMP);
INSERT INTO Item (item_id, transactions_id, store_id, price, item_type, name, description, created) VALUES (99856.0, 144, 4, 2, 'Books', 'name_144', 'description_144', CURRENT_TIMESTAMP);
INSERT INTO Transactions (transactions_id, time, 	payment_method, created) VALUES (145, '2018-02-19 11:06:34', 'CC', CURRENT_TIMESTAMP);
INSERT INTO Item (item_id, transactions_id, store_id, price, item_type, name, description, created) VALUES (99855.0, 145, 11, 17, 'Home', 'name_145', 'description_145', CURRENT_TIMESTAMP);
INSERT INTO Transactions (transactions_id, time, 	payment_method, created) VALUES (146, '2018-01-24 09:42:02', 'CC', CURRENT_TIMESTAMP);
INSERT INTO Item (item_id, transactions_id, store_id, price, item_type, name, description, created) VALUES (99854.0, 146, 2, 111, 'Electronics', 'name_146', 'description_146', CURRENT_TIMESTAMP);
INSERT INTO Transactions (transactions_id, time, 	payment_method, created) VALUES (147, '2018-02-10 17:42:28', 'PayPal', CURRENT_TIMESTAMP);
INSERT INTO Item (item_id, transactions_id, store_id, price, item_type, name, description, created) VALUES (99853.0, 147, 4, 110, 'Books', 'name_147', 'description_147', CURRENT_TIMESTAMP);
INSERT INTO Transactions (transactions_id, time, 	payment_method, created) VALUES (148, '2018-01-26 16:10:40', 'DebitCard', CURRENT_TIMESTAMP);
INSERT INTO Item (item_id, transactions_id, store_id, price, item_type, name, description, created) VALUES (99852.0, 148, 10, 118, 'Health', 'name_148', 'description_148', CURRENT_TIMESTAMP);
INSERT INTO Transactions (transactions_id, time, 	payment_method, created) VALUES (149, '2018-02-11 10:14:09', 'NetBanking', CURRENT_TIMESTAMP);
INSERT INTO Item (item_id, transactions_id, store_id, price, item_type, name, description, created) VALUES (99851.0, 149, 10, 35, 'Books', 'name_149', 'description_149', CURRENT_TIMESTAMP);
INSERT INTO Transactions (transactions_id, time, 	payment_method, created) VALUES (150, '2018-02-06 21:59:22', 'CC', CURRENT_TIMESTAMP);
INSERT INTO Item (item_id, transactions_id, store_id, price, item_type, name, description, created) VALUES (99850.0, 150, 8, 80, 'Toys', 'name_150', 'description_150', CURRENT_TIMESTAMP);
INSERT INTO Transactions (transactions_id, time, 	payment_method, created) VALUES (151, '2018-02-11 22:49:34', 'DebitCard', CURRENT_TIMESTAMP);
INSERT INTO Item (item_id, transactions_id, store_id, price, item_type, name, description, created) VALUES (99849.0, 151, 4, 14, 'Health', 'name_151', 'description_151', CURRENT_TIMESTAMP);
INSERT INTO Transactions (transactions_id, time, 	payment_method, created) VALUES (152, '2018-01-23 09:20:05', 'NetBanking', CURRENT_TIMESTAMP);
INSERT INTO Item (item_id, transactions_id, store_id, price, item_type, name, description, created) VALUES (99848.0, 152, 1, 72, 'Books', 'name_152', 'description_152', CURRENT_TIMESTAMP);
INSERT INTO Transactions (transactions_id, time, 	payment_method, created) VALUES (153, '2018-01-19 15:42:08', 'CC', CURRENT_TIMESTAMP);
INSERT INTO Item (item_id, transactions_id, store_id, price, item_type, name, description, created) VALUES (99847.0, 153, 7, 149, 'Electronics', 'name_153', 'description_153', CURRENT_TIMESTAMP);
INSERT INTO Transactions (transactions_id, time, 	payment_method, created) VALUES (154, '2018-01-05 17:35:30', 'PayPal', CURRENT_TIMESTAMP);
INSERT INTO Item (item_id, transactions_id, store_id, price, item_type, name, description, created) VALUES (99846.0, 154, 14, 113, 'Books', 'name_154', 'description_154', CURRENT_TIMESTAMP);
INSERT INTO Transactions (transactions_id, time, 	payment_method, created) VALUES (155, '2018-01-16 03:10:02', 'DebitCard', CURRENT_TIMESTAMP);
INSERT INTO Item (item_id, transactions_id, store_id, price, item_type, name, description, created) VALUES (99845.0, 155, 3, 60, 'Toys', 'name_155', 'description_155', CURRENT_TIMESTAMP);
INSERT INTO Transactions (transactions_id, time, 	payment_method, created) VALUES (156, '2018-01-23 18:31:50', 'CC', CURRENT_TIMESTAMP);
INSERT INTO Item (item_id, transactions_id, store_id, price, item_type, name, description, created) VALUES (99844.0, 156, 3, 149, 'Electronics', 'name_156', 'description_156', CURRENT_TIMESTAMP);
INSERT INTO Transactions (transactions_id, time, 	payment_method, created) VALUES (157, '2018-01-24 18:52:24', 'PayPal', CURRENT_TIMESTAMP);
INSERT INTO Item (item_id, transactions_id, store_id, price, item_type, name, description, created) VALUES (99843.0, 157, 1, 37, 'Health', 'name_157', 'description_157', CURRENT_TIMESTAMP);
INSERT INTO Transactions (transactions_id, time, 	payment_method, created) VALUES (158, '2018-01-03 03:30:38', 'PayPal', CURRENT_TIMESTAMP);
INSERT INTO Item (item_id, transactions_id, store_id, price, item_type, name, description, created) VALUES (99842.0, 158, 6, 58, 'Toys', 'name_158', 'description_158', CURRENT_TIMESTAMP);
INSERT INTO Transactions (transactions_id, time, 	payment_method, created) VALUES (159, '2018-02-20 18:44:55', 'PayPal', CURRENT_TIMESTAMP);
INSERT INTO Item (item_id, transactions_id, store_id, price, item_type, name, description, created) VALUES (99841.0, 159, 1, 6, 'Toys', 'name_159', 'description_159', CURRENT_TIMESTAMP);
INSERT INTO Transactions (transactions_id, time, 	payment_method, created) VALUES (160, '2018-01-16 13:22:09', 'CC', CURRENT_TIMESTAMP);
INSERT INTO Item (item_id, transactions_id, store_id, price, item_type, name, description, created) VALUES (99840.0, 160, 10, 24, 'Books', 'name_160', 'description_160', CURRENT_TIMESTAMP);
INSERT INTO Transactions (transactions_id, time, 	payment_method, created) VALUES (161, '2018-01-13 06:06:05', 'NetBanking', CURRENT_TIMESTAMP);
INSERT INTO Item (item_id, transactions_id, store_id, price, item_type, name, description, created) VALUES (99839.0, 161, 3, 77, 'Toys', 'name_161', 'description_161', CURRENT_TIMESTAMP);
INSERT INTO Transactions (transactions_id, time, 	payment_method, created) VALUES (162, '2018-01-24 21:04:36', 'DebitCard', CURRENT_TIMESTAMP);
INSERT INTO Item (item_id, transactions_id, store_id, price, item_type, name, description, created) VALUES (99838.0, 162, 6, 161, 'Electronics', 'name_162', 'description_162', CURRENT_TIMESTAMP);
INSERT INTO Transactions (transactions_id, time, 	payment_method, created) VALUES (163, '2018-02-10 16:22:44', 'PayPal', CURRENT_TIMESTAMP);
INSERT INTO Item (item_id, transactions_id, store_id, price, item_type, name, description, created) VALUES (99837.0, 163, 3, 30, 'Books', 'name_163', 'description_163', CURRENT_TIMESTAMP);
INSERT INTO Transactions (transactions_id, time, 	payment_method, created) VALUES (164, '2018-01-09 04:02:13', 'DebitCard', CURRENT_TIMESTAMP);
INSERT INTO Item (item_id, transactions_id, store_id, price, item_type, name, description, created) VALUES (99836.0, 164, 3, 49, 'Books', 'name_164', 'description_164', CURRENT_TIMESTAMP);
INSERT INTO Transactions (transactions_id, time, 	payment_method, created) VALUES (165, '2018-01-24 06:36:22', 'NetBanking', CURRENT_TIMESTAMP);
INSERT INTO Item (item_id, transactions_id, store_id, price, item_type, name, description, created) VALUES (99835.0, 165, 6, 46, 'Home', 'name_165', 'description_165', CURRENT_TIMESTAMP);
INSERT INTO Transactions (transactions_id, time, 	payment_method, created) VALUES (166, '2018-02-13 15:01:59', 'PayPal', CURRENT_TIMESTAMP);
INSERT INTO Item (item_id, transactions_id, store_id, price, item_type, name, description, created) VALUES (99834.0, 166, 10, 50, 'Toys', 'name_166', 'description_166', CURRENT_TIMESTAMP);
INSERT INTO Transactions (transactions_id, time, 	payment_method, created) VALUES (167, '2018-02-14 21:50:36', 'PayPal', CURRENT_TIMESTAMP);
INSERT INTO Item (item_id, transactions_id, store_id, price, item_type, name, description, created) VALUES (99833.0, 167, 11, 3, 'Electronics', 'name_167', 'description_167', CURRENT_TIMESTAMP);
INSERT INTO Transactions (transactions_id, time, 	payment_method, created) VALUES (168, '2018-02-09 03:13:25', 'CC', CURRENT_TIMESTAMP);
INSERT INTO Item (item_id, transactions_id, store_id, price, item_type, name, description, created) VALUES (99832.0, 168, 12, 168, 'Books', 'name_168', 'description_168', CURRENT_TIMESTAMP);
INSERT INTO Transactions (transactions_id, time, 	payment_method, created) VALUES (169, '2018-01-26 08:06:12', 'DebitCard', CURRENT_TIMESTAMP);
INSERT INTO Item (item_id, transactions_id, store_id, price, item_type, name, description, created) VALUES (99831.0, 169, 2, 114, 'Books', 'name_169', 'description_169', CURRENT_TIMESTAMP);
INSERT INTO Transactions (transactions_id, time, 	payment_method, created) VALUES (170, '2018-02-14 13:22:26', 'CC', CURRENT_TIMESTAMP);
INSERT INTO Item (item_id, transactions_id, store_id, price, item_type, name, description, created) VALUES (99830.0, 170, 9, 120, 'Toys', 'name_170', 'description_170', CURRENT_TIMESTAMP);
INSERT INTO Transactions (transactions_id, time, 	payment_method, created) VALUES (171, '2018-02-05 16:20:44', 'DebitCard', CURRENT_TIMESTAMP);
INSERT INTO Item (item_id, transactions_id, store_id, price, item_type, name, description, created) VALUES (99829.0, 171, 6, 116, 'Toys', 'name_171', 'description_171', CURRENT_TIMESTAMP);
INSERT INTO Transactions (transactions_id, time, 	payment_method, created) VALUES (172, '2018-01-08 12:53:03', 'CC', CURRENT_TIMESTAMP);
INSERT INTO Item (item_id, transactions_id, store_id, price, item_type, name, description, created) VALUES (99828.0, 172, 6, 94, 'Home', 'name_172', 'description_172', CURRENT_TIMESTAMP);
INSERT INTO Transactions (transactions_id, time, 	payment_method, created) VALUES (173, '2018-01-27 08:00:35', 'PayPal', CURRENT_TIMESTAMP);
INSERT INTO Item (item_id, transactions_id, store_id, price, item_type, name, description, created) VALUES (99827.0, 173, 8, 113, 'Toys', 'name_173', 'description_173', CURRENT_TIMESTAMP);
INSERT INTO Transactions (transactions_id, time, 	payment_method, created) VALUES (174, '2018-02-09 09:21:38', 'CC', CURRENT_TIMESTAMP);
INSERT INTO Item (item_id, transactions_id, store_id, price, item_type, name, description, created) VALUES (99826.0, 174, 3, 82, 'Health', 'name_174', 'description_174', CURRENT_TIMESTAMP);
INSERT INTO Transactions (transactions_id, time, 	payment_method, created) VALUES (175, '2018-01-07 11:26:24', 'PayPal', CURRENT_TIMESTAMP);
INSERT INTO Item (item_id, transactions_id, store_id, price, item_type, name, description, created) VALUES (99825.0, 175, 3, 171, 'Electronics', 'name_175', 'description_175', CURRENT_TIMESTAMP);
INSERT INTO Transactions (transactions_id, time, 	payment_method, created) VALUES (176, '2018-01-29 11:17:50', 'CC', CURRENT_TIMESTAMP);
INSERT INTO Item (item_id, transactions_id, store_id, price, item_type, name, description, created) VALUES (99824.0, 176, 13, 88, 'Electronics', 'name_176', 'description_176', CURRENT_TIMESTAMP);
INSERT INTO Transactions (transactions_id, time, 	payment_method, created) VALUES (177, '2018-01-18 11:59:29', 'PayPal', CURRENT_TIMESTAMP);
INSERT INTO Item (item_id, transactions_id, store_id, price, item_type, name, description, created) VALUES (99823.0, 177, 14, 170, 'Books', 'name_177', 'description_177', CURRENT_TIMESTAMP);
INSERT INTO Transactions (transactions_id, time, 	payment_method, created) VALUES (178, '2018-02-14 00:24:18', 'CC', CURRENT_TIMESTAMP);
INSERT INTO Item (item_id, transactions_id, store_id, price, item_type, name, description, created) VALUES (99822.0, 178, 9, 17, 'Electronics', 'name_178', 'description_178', CURRENT_TIMESTAMP);
INSERT INTO Transactions (transactions_id, time, 	payment_method, created) VALUES (179, '2018-02-05 06:00:35', 'CC', CURRENT_TIMESTAMP);
INSERT INTO Item (item_id, transactions_id, store_id, price, item_type, name, description, created) VALUES (99821.0, 179, 5, 170, 'Health', 'name_179', 'description_179', CURRENT_TIMESTAMP);
INSERT INTO Transactions (transactions_id, time, 	payment_method, created) VALUES (180, '2018-02-10 07:16:05', 'NetBanking', CURRENT_TIMESTAMP);
INSERT INTO Item (item_id, transactions_id, store_id, price, item_type, name, description, created) VALUES (99820.0, 180, 8, 13, 'Books', 'name_180', 'description_180', CURRENT_TIMESTAMP);
INSERT INTO Transactions (transactions_id, time, 	payment_method, created) VALUES (181, '2018-01-21 12:11:37', 'DebitCard', CURRENT_TIMESTAMP);
INSERT INTO Item (item_id, transactions_id, store_id, price, item_type, name, description, created) VALUES (99819.0, 181, 4, 88, 'Health', 'name_181', 'description_181', CURRENT_TIMESTAMP);
INSERT INTO Transactions (transactions_id, time, 	payment_method, created) VALUES (182, '2018-01-22 12:20:01', 'DebitCard', CURRENT_TIMESTAMP);
INSERT INTO Item (item_id, transactions_id, store_id, price, item_type, name, description, created) VALUES (99818.0, 182, 9, 156, 'Home', 'name_182', 'description_182', CURRENT_TIMESTAMP);
INSERT INTO Transactions (transactions_id, time, 	payment_method, created) VALUES (183, '2018-01-26 09:15:36', 'CC', CURRENT_TIMESTAMP);
INSERT INTO Item (item_id, transactions_id, store_id, price, item_type, name, description, created) VALUES (99817.0, 183, 2, 114, 'Home', 'name_183', 'description_183', CURRENT_TIMESTAMP);
INSERT INTO Transactions (transactions_id, time, 	payment_method, created) VALUES (184, '2018-01-26 08:18:24', 'DebitCard', CURRENT_TIMESTAMP);
INSERT INTO Item (item_id, transactions_id, store_id, price, item_type, name, description, created) VALUES (99816.0, 184, 12, 164, 'Toys', 'name_184', 'description_184', CURRENT_TIMESTAMP);
INSERT INTO Transactions (transactions_id, time, 	payment_method, created) VALUES (185, '2018-02-15 21:16:40', 'PayPal', CURRENT_TIMESTAMP);
INSERT INTO Item (item_id, transactions_id, store_id, price, item_type, name, description, created) VALUES (99815.0, 185, 4, 85, 'Electronics', 'name_185', 'description_185', CURRENT_TIMESTAMP);
INSERT INTO Transactions (transactions_id, time, 	payment_method, created) VALUES (186, '2018-01-30 07:19:43', 'PayPal', CURRENT_TIMESTAMP);
INSERT INTO Item (item_id, transactions_id, store_id, price, item_type, name, description, created) VALUES (99814.0, 186, 1, 31, 'Books', 'name_186', 'description_186', CURRENT_TIMESTAMP);
INSERT INTO Transactions (transactions_id, time, 	payment_method, created) VALUES (187, '2018-01-11 04:57:23', 'NetBanking', CURRENT_TIMESTAMP);
INSERT INTO Item (item_id, transactions_id, store_id, price, item_type, name, description, created) VALUES (99813.0, 187, 12, 38, 'Home', 'name_187', 'description_187', CURRENT_TIMESTAMP);
INSERT INTO Transactions (transactions_id, time, 	payment_method, created) VALUES (188, '2018-01-30 02:15:18', 'NetBanking', CURRENT_TIMESTAMP);
INSERT INTO Item (item_id, transactions_id, store_id, price, item_type, name, description, created) VALUES (99812.0, 188, 2, 93, 'Health', 'name_188', 'description_188', CURRENT_TIMESTAMP);
INSERT INTO Transactions (transactions_id, time, 	payment_method, created) VALUES (189, '2018-02-04 00:05:25', 'CC', CURRENT_TIMESTAMP);
INSERT INTO Item (item_id, transactions_id, store_id, price, item_type, name, description, created) VALUES (99811.0, 189, 4, 36, 'Home', 'name_189', 'description_189', CURRENT_TIMESTAMP);
INSERT INTO Transactions (transactions_id, time, 	payment_method, created) VALUES (190, '2018-01-29 19:55:59', 'NetBanking', CURRENT_TIMESTAMP);
INSERT INTO Item (item_id, transactions_id, store_id, price, item_type, name, description, created) VALUES (99810.0, 190, 1, 33, 'Health', 'name_190', 'description_190', CURRENT_TIMESTAMP);
INSERT INTO Transactions (transactions_id, time, 	payment_method, created) VALUES (191, '2018-01-19 12:58:25', 'DebitCard', CURRENT_TIMESTAMP);
INSERT INTO Item (item_id, transactions_id, store_id, price, item_type, name, description, created) VALUES (99809.0, 191, 12, 146, 'Electronics', 'name_191', 'description_191', CURRENT_TIMESTAMP);
INSERT INTO Transactions (transactions_id, time, 	payment_method, created) VALUES (192, '2018-01-16 00:31:22', 'PayPal', CURRENT_TIMESTAMP);
INSERT INTO Item (item_id, transactions_id, store_id, price, item_type, name, description, created) VALUES (99808.0, 192, 4, 93, 'Health', 'name_192', 'description_192', CURRENT_TIMESTAMP);
INSERT INTO Transactions (transactions_id, time, 	payment_method, created) VALUES (193, '2018-01-21 15:52:15', 'NetBanking', CURRENT_TIMESTAMP);
INSERT INTO Item (item_id, transactions_id, store_id, price, item_type, name, description, created) VALUES (99807.0, 193, 2, 158, 'Books', 'name_193', 'description_193', CURRENT_TIMESTAMP);
INSERT INTO Transactions (transactions_id, time, 	payment_method, created) VALUES (194, '2018-01-19 05:54:04', 'PayPal', CURRENT_TIMESTAMP);
INSERT INTO Item (item_id, transactions_id, store_id, price, item_type, name, description, created) VALUES (99806.0, 194, 9, 122, 'Books', 'name_194', 'description_194', CURRENT_TIMESTAMP);
INSERT INTO Transactions (transactions_id, time, 	payment_method, created) VALUES (195, '2018-02-09 14:15:11', 'CC', CURRENT_TIMESTAMP);
INSERT INTO Item (item_id, transactions_id, store_id, price, item_type, name, description, created) VALUES (99805.0, 195, 11, 36, 'Toys', 'name_195', 'description_195', CURRENT_TIMESTAMP);
INSERT INTO Transactions (transactions_id, time, 	payment_method, created) VALUES (196, '2018-01-01 22:32:10', 'DebitCard', CURRENT_TIMESTAMP);
INSERT INTO Item (item_id, transactions_id, store_id, price, item_type, name, description, created) VALUES (99804.0, 196, 6, 17, 'Electronics', 'name_196', 'description_196', CURRENT_TIMESTAMP);
INSERT INTO Transactions (transactions_id, time, 	payment_method, created) VALUES (197, '2018-02-03 14:53:37', 'PayPal', CURRENT_TIMESTAMP);
INSERT INTO Item (item_id, transactions_id, store_id, price, item_type, name, description, created) VALUES (99803.0, 197, 14, 80, 'Books', 'name_197', 'description_197', CURRENT_TIMESTAMP);
INSERT INTO Transactions (transactions_id, time, 	payment_method, created) VALUES (198, '2018-01-06 20:20:43', 'NetBanking', CURRENT_TIMESTAMP);
INSERT INTO Item (item_id, transactions_id, store_id, price, item_type, name, description, created) VALUES (99802.0, 198, 4, 98, 'Electronics', 'name_198', 'description_198', CURRENT_TIMESTAMP);
INSERT INTO Transactions (transactions_id, time, 	payment_method, created) VALUES (199, '2018-02-04 04:13:00', 'NetBanking', CURRENT_TIMESTAMP);
INSERT INTO Item (item_id, transactions_id, store_id, price, item_type, name, description, created) VALUES (99801.0, 199, 3, 79, 'Books', 'name_199', 'description_199', CURRENT_TIMESTAMP);
INSERT INTO Transactions (transactions_id, time, 	payment_method, created) VALUES (200, '2018-01-11 00:58:14', 'DebitCard', CURRENT_TIMESTAMP);
INSERT INTO Item (item_id, transactions_id, store_id, price, item_type, name, description, created) VALUES (99800.0, 200, 14, 107, 'Electronics', 'name_200', 'description_200', CURRENT_TIMESTAMP);
INSERT INTO Transactions (transactions_id, time, 	payment_method, created) VALUES (201, '2018-02-20 07:52:15', 'PayPal', CURRENT_TIMESTAMP);
INSERT INTO Item (item_id, transactions_id, store_id, price, item_type, name, description, created) VALUES (99799.0, 201, 14, 135, 'Home', 'name_201', 'description_201', CURRENT_TIMESTAMP);
INSERT INTO Transactions (transactions_id, time, 	payment_method, created) VALUES (202, '2018-01-19 08:42:12', 'NetBanking', CURRENT_TIMESTAMP);
INSERT INTO Item (item_id, transactions_id, store_id, price, item_type, name, description, created) VALUES (99798.0, 202, 5, 19, 'Health', 'name_202', 'description_202', CURRENT_TIMESTAMP);
INSERT INTO Transactions (transactions_id, time, 	payment_method, created) VALUES (203, '2018-01-19 05:49:48', 'DebitCard', CURRENT_TIMESTAMP);
INSERT INTO Item (item_id, transactions_id, store_id, price, item_type, name, description, created) VALUES (99797.0, 203, 11, 139, 'Electronics', 'name_203', 'description_203', CURRENT_TIMESTAMP);
INSERT INTO Transactions (transactions_id, time, 	payment_method, created) VALUES (204, '2018-01-29 06:05:14', 'PayPal', CURRENT_TIMESTAMP);
INSERT INTO Item (item_id, transactions_id, store_id, price, item_type, name, description, created) VALUES (99796.0, 204, 12, 188, 'Toys', 'name_204', 'description_204', CURRENT_TIMESTAMP);
INSERT INTO Transactions (transactions_id, time, 	payment_method, created) VALUES (205, '2018-01-23 20:40:51', 'NetBanking', CURRENT_TIMESTAMP);
INSERT INTO Item (item_id, transactions_id, store_id, price, item_type, name, description, created) VALUES (99795.0, 205, 10, 106, 'Electronics', 'name_205', 'description_205', CURRENT_TIMESTAMP);
INSERT INTO Transactions (transactions_id, time, 	payment_method, created) VALUES (206, '2018-02-12 06:08:50', 'CC', CURRENT_TIMESTAMP);
INSERT INTO Item (item_id, transactions_id, store_id, price, item_type, name, description, created) VALUES (99794.0, 206, 11, 122, 'Electronics', 'name_206', 'description_206', CURRENT_TIMESTAMP);
INSERT INTO Transactions (transactions_id, time, 	payment_method, created) VALUES (207, '2018-01-16 23:03:23', 'CC', CURRENT_TIMESTAMP);
INSERT INTO Item (item_id, transactions_id, store_id, price, item_type, name, description, created) VALUES (99793.0, 207, 5, 127, 'Home', 'name_207', 'description_207', CURRENT_TIMESTAMP);
INSERT INTO Transactions (transactions_id, time, 	payment_method, created) VALUES (208, '2018-02-12 18:08:57', 'PayPal', CURRENT_TIMESTAMP);
INSERT INTO Item (item_id, transactions_id, store_id, price, item_type, name, description, created) VALUES (99792.0, 208, 7, 151, 'Books', 'name_208', 'description_208', CURRENT_TIMESTAMP);
INSERT INTO Transactions (transactions_id, time, 	payment_method, created) VALUES (209, '2018-02-14 00:41:26', 'CC', CURRENT_TIMESTAMP);
INSERT INTO Item (item_id, transactions_id, store_id, price, item_type, name, description, created) VALUES (99791.0, 209, 6, 85, 'Health', 'name_209', 'description_209', CURRENT_TIMESTAMP);
INSERT INTO Transactions (transactions_id, time, 	payment_method, created) VALUES (210, '2018-01-29 16:41:16', 'NetBanking', CURRENT_TIMESTAMP);
INSERT INTO Item (item_id, transactions_id, store_id, price, item_type, name, description, created) VALUES (99790.0, 210, 12, 126, 'Electronics', 'name_210', 'description_210', CURRENT_TIMESTAMP);
INSERT INTO Transactions (transactions_id, time, 	payment_method, created) VALUES (211, '2018-01-20 19:19:45', 'PayPal', CURRENT_TIMESTAMP);
INSERT INTO Item (item_id, transactions_id, store_id, price, item_type, name, description, created) VALUES (99789.0, 211, 10, 77, 'Toys', 'name_211', 'description_211', CURRENT_TIMESTAMP);
INSERT INTO Transactions (transactions_id, time, 	payment_method, created) VALUES (212, '2018-02-03 06:08:50', 'NetBanking', CURRENT_TIMESTAMP);
INSERT INTO Item (item_id, transactions_id, store_id, price, item_type, name, description, created) VALUES (99788.0, 212, 12, 9, 'Electronics', 'name_212', 'description_212', CURRENT_TIMESTAMP);
INSERT INTO Transactions (transactions_id, time, 	payment_method, created) VALUES (213, '2018-01-11 14:38:30', 'CC', CURRENT_TIMESTAMP);
INSERT INTO Item (item_id, transactions_id, store_id, price, item_type, name, description, created) VALUES (99787.0, 213, 14, 134, 'Home', 'name_213', 'description_213', CURRENT_TIMESTAMP);
INSERT INTO Transactions (transactions_id, time, 	payment_method, created) VALUES (214, '2018-01-03 14:44:35', 'PayPal', CURRENT_TIMESTAMP);
INSERT INTO Item (item_id, transactions_id, store_id, price, item_type, name, description, created) VALUES (99786.0, 214, 10, 182, 'Electronics', 'name_214', 'description_214', CURRENT_TIMESTAMP);
INSERT INTO Transactions (transactions_id, time, 	payment_method, created) VALUES (215, '2018-01-22 01:08:13', 'PayPal', CURRENT_TIMESTAMP);
INSERT INTO Item (item_id, transactions_id, store_id, price, item_type, name, description, created) VALUES (99785.0, 215, 3, 116, 'Toys', 'name_215', 'description_215', CURRENT_TIMESTAMP);
INSERT INTO Transactions (transactions_id, time, 	payment_method, created) VALUES (216, '2018-01-23 08:40:07', 'PayPal', CURRENT_TIMESTAMP);
INSERT INTO Item (item_id, transactions_id, store_id, price, item_type, name, description, created) VALUES (99784.0, 216, 12, 101, 'Home', 'name_216', 'description_216', CURRENT_TIMESTAMP);
INSERT INTO Transactions (transactions_id, time, 	payment_method, created) VALUES (217, '2018-02-10 08:06:19', 'CC', CURRENT_TIMESTAMP);
INSERT INTO Item (item_id, transactions_id, store_id, price, item_type, name, description, created) VALUES (99783.0, 217, 5, 110, 'Toys', 'name_217', 'description_217', CURRENT_TIMESTAMP);
INSERT INTO Transactions (transactions_id, time, 	payment_method, created) VALUES (218, '2018-02-15 20:52:57', 'NetBanking', CURRENT_TIMESTAMP);
INSERT INTO Item (item_id, transactions_id, store_id, price, item_type, name, description, created) VALUES (99782.0, 218, 7, 89, 'Home', 'name_218', 'description_218', CURRENT_TIMESTAMP);
INSERT INTO Transactions (transactions_id, time, 	payment_method, created) VALUES (219, '2018-02-10 19:58:14', 'PayPal', CURRENT_TIMESTAMP);
INSERT INTO Item (item_id, transactions_id, store_id, price, item_type, name, description, created) VALUES (99781.0, 219, 10, 114, 'Home', 'name_219', 'description_219', CURRENT_TIMESTAMP);
INSERT INTO Transactions (transactions_id, time, 	payment_method, created) VALUES (220, '2018-02-07 01:16:05', 'NetBanking', CURRENT_TIMESTAMP);
INSERT INTO Item (item_id, transactions_id, store_id, price, item_type, name, description, created) VALUES (99780.0, 220, 5, 157, 'Electronics', 'name_220', 'description_220', CURRENT_TIMESTAMP);
INSERT INTO Transactions (transactions_id, time, 	payment_method, created) VALUES (221, '2018-02-20 14:03:30', 'DebitCard', CURRENT_TIMESTAMP);
INSERT INTO Item (item_id, transactions_id, store_id, price, item_type, name, description, created) VALUES (99779.0, 221, 5, 96, 'Books', 'name_221', 'description_221', CURRENT_TIMESTAMP);
INSERT INTO Transactions (transactions_id, time, 	payment_method, created) VALUES (222, '2018-01-09 01:22:42', 'DebitCard', CURRENT_TIMESTAMP);
INSERT INTO Item (item_id, transactions_id, store_id, price, item_type, name, description, created) VALUES (99778.0, 222, 7, 116, 'Home', 'name_222', 'description_222', CURRENT_TIMESTAMP);
INSERT INTO Transactions (transactions_id, time, 	payment_method, created) VALUES (223, '2018-01-04 04:16:33', 'NetBanking', CURRENT_TIMESTAMP);
INSERT INTO Item (item_id, transactions_id, store_id, price, item_type, name, description, created) VALUES (99777.0, 223, 5, 71, 'Home', 'name_223', 'description_223', CURRENT_TIMESTAMP);
INSERT INTO Transactions (transactions_id, time, 	payment_method, created) VALUES (224, '2018-01-25 13:59:57', 'PayPal', CURRENT_TIMESTAMP);
INSERT INTO Item (item_id, transactions_id, store_id, price, item_type, name, description, created) VALUES (99776.0, 224, 4, 80, 'Electronics', 'name_224', 'description_224', CURRENT_TIMESTAMP);
INSERT INTO Transactions (transactions_id, time, 	payment_method, created) VALUES (225, '2018-02-03 01:44:17', 'PayPal', CURRENT_TIMESTAMP);
INSERT INTO Item (item_id, transactions_id, store_id, price, item_type, name, description, created) VALUES (99775.0, 225, 6, 112, 'Toys', 'name_225', 'description_225', CURRENT_TIMESTAMP);
INSERT INTO Transactions (transactions_id, time, 	payment_method, created) VALUES (226, '2018-02-01 06:34:33', 'DebitCard', CURRENT_TIMESTAMP);
INSERT INTO Item (item_id, transactions_id, store_id, price, item_type, name, description, created) VALUES (99774.0, 226, 8, 134, 'Books', 'name_226', 'description_226', CURRENT_TIMESTAMP);
INSERT INTO Transactions (transactions_id, time, 	payment_method, created) VALUES (227, '2018-01-09 10:48:26', 'DebitCard', CURRENT_TIMESTAMP);
INSERT INTO Item (item_id, transactions_id, store_id, price, item_type, name, description, created) VALUES (99773.0, 227, 4, 96, 'Electronics', 'name_227', 'description_227', CURRENT_TIMESTAMP);
INSERT INTO Transactions (transactions_id, time, 	payment_method, created) VALUES (228, '2018-01-20 10:28:17', 'CC', CURRENT_TIMESTAMP);
INSERT INTO Item (item_id, transactions_id, store_id, price, item_type, name, description, created) VALUES (99772.0, 228, 2, 212, 'Toys', 'name_228', 'description_228', CURRENT_TIMESTAMP);
INSERT INTO Transactions (transactions_id, time, 	payment_method, created) VALUES (229, '2018-01-12 12:55:40', 'NetBanking', CURRENT_TIMESTAMP);
INSERT INTO Item (item_id, transactions_id, store_id, price, item_type, name, description, created) VALUES (99771.0, 229, 1, 143, 'Health', 'name_229', 'description_229', CURRENT_TIMESTAMP);
INSERT INTO Transactions (transactions_id, time, 	payment_method, created) VALUES (230, '2018-01-09 05:43:18', 'CC', CURRENT_TIMESTAMP);
INSERT INTO Item (item_id, transactions_id, store_id, price, item_type, name, description, created) VALUES (99770.0, 230, 12, 213, 'Toys', 'name_230', 'description_230', CURRENT_TIMESTAMP);
INSERT INTO Transactions (transactions_id, time, 	payment_method, created) VALUES (231, '2018-01-10 22:50:25', 'DebitCard', CURRENT_TIMESTAMP);
INSERT INTO Item (item_id, transactions_id, store_id, price, item_type, name, description, created) VALUES (99769.0, 231, 6, 79, 'Electronics', 'name_231', 'description_231', CURRENT_TIMESTAMP);
INSERT INTO Transactions (transactions_id, time, 	payment_method, created) VALUES (232, '2018-01-05 11:37:57', 'DebitCard', CURRENT_TIMESTAMP);
INSERT INTO Item (item_id, transactions_id, store_id, price, item_type, name, description, created) VALUES (99768.0, 232, 14, 67, 'Electronics', 'name_232', 'description_232', CURRENT_TIMESTAMP);
INSERT INTO Transactions (transactions_id, time, 	payment_method, created) VALUES (233, '2018-02-06 02:58:31', 'NetBanking', CURRENT_TIMESTAMP);
INSERT INTO Item (item_id, transactions_id, store_id, price, item_type, name, description, created) VALUES (99767.0, 233, 2, 107, 'Books', 'name_233', 'description_233', CURRENT_TIMESTAMP);
INSERT INTO Transactions (transactions_id, time, 	payment_method, created) VALUES (234, '2018-01-03 12:20:17', 'PayPal', CURRENT_TIMESTAMP);
INSERT INTO Item (item_id, transactions_id, store_id, price, item_type, name, description, created) VALUES (99766.0, 234, 11, 230, 'Health', 'name_234', 'description_234', CURRENT_TIMESTAMP);
INSERT INTO Transactions (transactions_id, time, 	payment_method, created) VALUES (235, '2018-01-12 04:22:18', 'NetBanking', CURRENT_TIMESTAMP);
INSERT INTO Item (item_id, transactions_id, store_id, price, item_type, name, description, created) VALUES (99765.0, 235, 2, 84, 'Books', 'name_235', 'description_235', CURRENT_TIMESTAMP);
INSERT INTO Transactions (transactions_id, time, 	payment_method, created) VALUES (236, '2018-01-08 18:27:38', 'PayPal', CURRENT_TIMESTAMP);
INSERT INTO Item (item_id, transactions_id, store_id, price, item_type, name, description, created) VALUES (99764.0, 236, 7, 155, 'Electronics', 'name_236', 'description_236', CURRENT_TIMESTAMP);
INSERT INTO Transactions (transactions_id, time, 	payment_method, created) VALUES (237, '2018-02-02 06:10:12', 'PayPal', CURRENT_TIMESTAMP);
INSERT INTO Item (item_id, transactions_id, store_id, price, item_type, name, description, created) VALUES (99763.0, 237, 14, 44, 'Home', 'name_237', 'description_237', CURRENT_TIMESTAMP);
INSERT INTO Transactions (transactions_id, time, 	payment_method, created) VALUES (238, '2018-02-01 09:26:33', 'DebitCard', CURRENT_TIMESTAMP);
INSERT INTO Item (item_id, transactions_id, store_id, price, item_type, name, description, created) VALUES (99762.0, 238, 12, 89, 'Home', 'name_238', 'description_238', CURRENT_TIMESTAMP);
INSERT INTO Transactions (transactions_id, time, 	payment_method, created) VALUES (239, '2018-01-01 03:16:10', 'CC', CURRENT_TIMESTAMP);
INSERT INTO Item (item_id, transactions_id, store_id, price, item_type, name, description, created) VALUES (99761.0, 239, 13, 6, 'Home', 'name_239', 'description_239', CURRENT_TIMESTAMP);
INSERT INTO Transactions (transactions_id, time, 	payment_method, created) VALUES (240, '2018-01-04 05:55:22', 'CC', CURRENT_TIMESTAMP);
INSERT INTO Item (item_id, transactions_id, store_id, price, item_type, name, description, created) VALUES (99760.0, 240, 12, 98, 'Home', 'name_240', 'description_240', CURRENT_TIMESTAMP);
INSERT INTO Transactions (transactions_id, time, 	payment_method, created) VALUES (241, '2018-02-01 17:38:37', 'PayPal', CURRENT_TIMESTAMP);
INSERT INTO Item (item_id, transactions_id, store_id, price, item_type, name, description, created) VALUES (99759.0, 241, 6, 29, 'Electronics', 'name_241', 'description_241', CURRENT_TIMESTAMP);
INSERT INTO Transactions (transactions_id, time, 	payment_method, created) VALUES (242, '2018-02-09 00:40:35', 'NetBanking', CURRENT_TIMESTAMP);
INSERT INTO Item (item_id, transactions_id, store_id, price, item_type, name, description, created) VALUES (99758.0, 242, 1, 170, 'Home', 'name_242', 'description_242', CURRENT_TIMESTAMP);
INSERT INTO Transactions (transactions_id, time, 	payment_method, created) VALUES (243, '2018-02-16 00:32:02', 'CC', CURRENT_TIMESTAMP);
INSERT INTO Item (item_id, transactions_id, store_id, price, item_type, name, description, created) VALUES (99757.0, 243, 8, 141, 'Electronics', 'name_243', 'description_243', CURRENT_TIMESTAMP);
INSERT INTO Transactions (transactions_id, time, 	payment_method, created) VALUES (244, '2018-01-06 11:43:25', 'PayPal', CURRENT_TIMESTAMP);
INSERT INTO Item (item_id, transactions_id, store_id, price, item_type, name, description, created) VALUES (99756.0, 244, 13, 236, 'Books', 'name_244', 'description_244', CURRENT_TIMESTAMP);
INSERT INTO Transactions (transactions_id, time, 	payment_method, created) VALUES (245, '2018-02-05 07:43:52', 'NetBanking', CURRENT_TIMESTAMP);
INSERT INTO Item (item_id, transactions_id, store_id, price, item_type, name, description, created) VALUES (99755.0, 245, 3, 206, 'Electronics', 'name_245', 'description_245', CURRENT_TIMESTAMP);
INSERT INTO Transactions (transactions_id, time, 	payment_method, created) VALUES (246, '2018-01-09 11:13:21', 'PayPal', CURRENT_TIMESTAMP);
INSERT INTO Item (item_id, transactions_id, store_id, price, item_type, name, description, created) VALUES (99754.0, 246, 5, 127, 'Electronics', 'name_246', 'description_246', CURRENT_TIMESTAMP);
INSERT INTO Transactions (transactions_id, time, 	payment_method, created) VALUES (247, '2018-01-26 12:13:12', 'DebitCard', CURRENT_TIMESTAMP);
INSERT INTO Item (item_id, transactions_id, store_id, price, item_type, name, description, created) VALUES (99753.0, 247, 4, 25, 'Toys', 'name_247', 'description_247', CURRENT_TIMESTAMP);
INSERT INTO Transactions (transactions_id, time, 	payment_method, created) VALUES (248, '2018-01-19 16:16:00', 'NetBanking', CURRENT_TIMESTAMP);
INSERT INTO Item (item_id, transactions_id, store_id, price, item_type, name, description, created) VALUES (99752.0, 248, 10, 247, 'Books', 'name_248', 'description_248', CURRENT_TIMESTAMP);
INSERT INTO Transactions (transactions_id, time, 	payment_method, created) VALUES (249, '2018-01-28 23:38:20', 'CC', CURRENT_TIMESTAMP);
INSERT INTO Item (item_id, transactions_id, store_id, price, item_type, name, description, created) VALUES (99751.0, 249, 8, 10, 'Toys', 'name_249', 'description_249', CURRENT_TIMESTAMP);
INSERT INTO Transactions (transactions_id, time, 	payment_method, created) VALUES (250, '2018-01-10 00:36:42', 'CC', CURRENT_TIMESTAMP);
INSERT INTO Item (item_id, transactions_id, store_id, price, item_type, name, description, created) VALUES (99750.0, 250, 9, 71, 'Health', 'name_250', 'description_250', CURRENT_TIMESTAMP);
INSERT INTO Transactions (transactions_id, time, 	payment_method, created) VALUES (251, '2018-01-23 14:29:43', 'PayPal', CURRENT_TIMESTAMP);
INSERT INTO Item (item_id, transactions_id, store_id, price, item_type, name, description, created) VALUES (99749.0, 251, 10, 120, 'Home', 'name_251', 'description_251', CURRENT_TIMESTAMP);
INSERT INTO Transactions (transactions_id, time, 	payment_method, created) VALUES (252, '2018-02-09 05:07:56', 'NetBanking', CURRENT_TIMESTAMP);
INSERT INTO Item (item_id, transactions_id, store_id, price, item_type, name, description, created) VALUES (99748.0, 252, 2, 55, 'Toys', 'name_252', 'description_252', CURRENT_TIMESTAMP);
INSERT INTO Transactions (transactions_id, time, 	payment_method, created) VALUES (253, '2018-02-07 04:26:51', 'NetBanking', CURRENT_TIMESTAMP);
INSERT INTO Item (item_id, transactions_id, store_id, price, item_type, name, description, created) VALUES (99747.0, 253, 4, 50, 'Health', 'name_253', 'description_253', CURRENT_TIMESTAMP);
INSERT INTO Transactions (transactions_id, time, 	payment_method, created) VALUES (254, '2018-01-06 13:43:52', 'NetBanking', CURRENT_TIMESTAMP);
INSERT INTO Item (item_id, transactions_id, store_id, price, item_type, name, description, created) VALUES (99746.0, 254, 8, 52, 'Electronics', 'name_254', 'description_254', CURRENT_TIMESTAMP);
INSERT INTO Transactions (transactions_id, time, 	payment_method, created) VALUES (255, '2018-01-26 16:08:13', 'CC', CURRENT_TIMESTAMP);
INSERT INTO Item (item_id, transactions_id, store_id, price, item_type, name, description, created) VALUES (99745.0, 255, 13, 47, 'Electronics', 'name_255', 'description_255', CURRENT_TIMESTAMP);
INSERT INTO Transactions (transactions_id, time, 	payment_method, created) VALUES (256, '2018-01-22 07:42:50', 'PayPal', CURRENT_TIMESTAMP);
INSERT INTO Item (item_id, transactions_id, store_id, price, item_type, name, description, created) VALUES (99744.0, 256, 1, 183, 'Toys', 'name_256', 'description_256', CURRENT_TIMESTAMP);
INSERT INTO Transactions (transactions_id, time, 	payment_method, created) VALUES (257, '2018-02-06 15:05:20', 'PayPal', CURRENT_TIMESTAMP);
INSERT INTO Item (item_id, transactions_id, store_id, price, item_type, name, description, created) VALUES (99743.0, 257, 4, 25, 'Home', 'name_257', 'description_257', CURRENT_TIMESTAMP);
INSERT INTO Transactions (transactions_id, time, 	payment_method, created) VALUES (258, '2018-02-09 11:41:27', 'DebitCard', CURRENT_TIMESTAMP);
INSERT INTO Item (item_id, transactions_id, store_id, price, item_type, name, description, created) VALUES (99742.0, 258, 14, 2, 'Books', 'name_258', 'description_258', CURRENT_TIMESTAMP);
INSERT INTO Transactions (transactions_id, time, 	payment_method, created) VALUES (259, '2018-01-28 07:14:43', 'CC', CURRENT_TIMESTAMP);
INSERT INTO Item (item_id, transactions_id, store_id, price, item_type, name, description, created) VALUES (99741.0, 259, 5, 140, 'Health', 'name_259', 'description_259', CURRENT_TIMESTAMP);
INSERT INTO Transactions (transactions_id, time, 	payment_method, created) VALUES (260, '2018-01-14 21:12:31', 'DebitCard', CURRENT_TIMESTAMP);
INSERT INTO Item (item_id, transactions_id, store_id, price, item_type, name, description, created) VALUES (99740.0, 260, 9, 112, 'Toys', 'name_260', 'description_260', CURRENT_TIMESTAMP);
INSERT INTO Transactions (transactions_id, time, 	payment_method, created) VALUES (261, '2018-01-20 19:47:51', 'DebitCard', CURRENT_TIMESTAMP);
INSERT INTO Item (item_id, transactions_id, store_id, price, item_type, name, description, created) VALUES (99739.0, 261, 4, 86, 'Electronics', 'name_261', 'description_261', CURRENT_TIMESTAMP);
INSERT INTO Transactions (transactions_id, time, 	payment_method, created) VALUES (262, '2018-01-13 00:27:02', 'NetBanking', CURRENT_TIMESTAMP);
INSERT INTO Item (item_id, transactions_id, store_id, price, item_type, name, description, created) VALUES (99738.0, 262, 9, 7, 'Electronics', 'name_262', 'description_262', CURRENT_TIMESTAMP);
INSERT INTO Transactions (transactions_id, time, 	payment_method, created) VALUES (263, '2018-01-18 04:38:58', 'DebitCard', CURRENT_TIMESTAMP);
INSERT INTO Item (item_id, transactions_id, store_id, price, item_type, name, description, created) VALUES (99737.0, 263, 3, 156, 'Toys', 'name_263', 'description_263', CURRENT_TIMESTAMP);
INSERT INTO Transactions (transactions_id, time, 	payment_method, created) VALUES (264, '2018-01-24 02:40:36', 'CC', CURRENT_TIMESTAMP);
INSERT INTO Item (item_id, transactions_id, store_id, price, item_type, name, description, created) VALUES (99736.0, 264, 4, 6, 'Home', 'name_264', 'description_264', CURRENT_TIMESTAMP);
INSERT INTO Transactions (transactions_id, time, 	payment_method, created) VALUES (265, '2018-02-07 04:26:42', 'NetBanking', CURRENT_TIMESTAMP);
INSERT INTO Item (item_id, transactions_id, store_id, price, item_type, name, description, created) VALUES (99735.0, 265, 6, 62, 'Health', 'name_265', 'description_265', CURRENT_TIMESTAMP);
INSERT INTO Transactions (transactions_id, time, 	payment_method, created) VALUES (266, '2018-01-09 11:59:22', 'DebitCard', CURRENT_TIMESTAMP);
INSERT INTO Item (item_id, transactions_id, store_id, price, item_type, name, description, created) VALUES (99734.0, 266, 6, 242, 'Toys', 'name_266', 'description_266', CURRENT_TIMESTAMP);
INSERT INTO Transactions (transactions_id, time, 	payment_method, created) VALUES (267, '2018-02-13 12:41:09', 'NetBanking', CURRENT_TIMESTAMP);
INSERT INTO Item (item_id, transactions_id, store_id, price, item_type, name, description, created) VALUES (99733.0, 267, 8, 244, 'Books', 'name_267', 'description_267', CURRENT_TIMESTAMP);
INSERT INTO Transactions (transactions_id, time, 	payment_method, created) VALUES (268, '2018-01-20 17:03:53', 'PayPal', CURRENT_TIMESTAMP);
INSERT INTO Item (item_id, transactions_id, store_id, price, item_type, name, description, created) VALUES (99732.0, 268, 12, 158, 'Electronics', 'name_268', 'description_268', CURRENT_TIMESTAMP);
INSERT INTO Transactions (transactions_id, time, 	payment_method, created) VALUES (269, '2018-01-11 20:07:55', 'CC', CURRENT_TIMESTAMP);
INSERT INTO Item (item_id, transactions_id, store_id, price, item_type, name, description, created) VALUES (99731.0, 269, 11, 167, 'Health', 'name_269', 'description_269', CURRENT_TIMESTAMP);
INSERT INTO Transactions (transactions_id, time, 	payment_method, created) VALUES (270, '2018-02-20 05:55:07', 'CC', CURRENT_TIMESTAMP);
INSERT INTO Item (item_id, transactions_id, store_id, price, item_type, name, description, created) VALUES (99730.0, 270, 8, 0, 'Toys', 'name_270', 'description_270', CURRENT_TIMESTAMP);
INSERT INTO Transactions (transactions_id, time, 	payment_method, created) VALUES (271, '2018-02-08 19:39:50', 'DebitCard', CURRENT_TIMESTAMP);
INSERT INTO Item (item_id, transactions_id, store_id, price, item_type, name, description, created) VALUES (99729.0, 271, 2, 154, 'Health', 'name_271', 'description_271', CURRENT_TIMESTAMP);
INSERT INTO Transactions (transactions_id, time, 	payment_method, created) VALUES (272, '2018-01-04 00:26:32', 'NetBanking', CURRENT_TIMESTAMP);
INSERT INTO Item (item_id, transactions_id, store_id, price, item_type, name, description, created) VALUES (99728.0, 272, 10, 28, 'Books', 'name_272', 'description_272', CURRENT_TIMESTAMP);
INSERT INTO Transactions (transactions_id, time, 	payment_method, created) VALUES (273, '2018-01-05 07:18:27', 'PayPal', CURRENT_TIMESTAMP);
INSERT INTO Item (item_id, transactions_id, store_id, price, item_type, name, description, created) VALUES (99727.0, 273, 4, 210, 'Health', 'name_273', 'description_273', CURRENT_TIMESTAMP);
INSERT INTO Transactions (transactions_id, time, 	payment_method, created) VALUES (274, '2018-01-22 04:03:30', 'DebitCard', CURRENT_TIMESTAMP);
INSERT INTO Item (item_id, transactions_id, store_id, price, item_type, name, description, created) VALUES (99726.0, 274, 9, 50, 'Health', 'name_274', 'description_274', CURRENT_TIMESTAMP);
INSERT INTO Transactions (transactions_id, time, 	payment_method, created) VALUES (275, '2018-01-16 09:05:59', 'PayPal', CURRENT_TIMESTAMP);
INSERT INTO Item (item_id, transactions_id, store_id, price, item_type, name, description, created) VALUES (99725.0, 275, 9, 155, 'Books', 'name_275', 'description_275', CURRENT_TIMESTAMP);
INSERT INTO Transactions (transactions_id, time, 	payment_method, created) VALUES (276, '2018-01-30 08:27:48', 'NetBanking', CURRENT_TIMESTAMP);
INSERT INTO Item (item_id, transactions_id, store_id, price, item_type, name, description, created) VALUES (99724.0, 276, 9, 80, 'Electronics', 'name_276', 'description_276', CURRENT_TIMESTAMP);
INSERT INTO Transactions (transactions_id, time, 	payment_method, created) VALUES (277, '2018-02-15 00:45:13', 'CC', CURRENT_TIMESTAMP);
INSERT INTO Item (item_id, transactions_id, store_id, price, item_type, name, description, created) VALUES (99723.0, 277, 12, 77, 'Toys', 'name_277', 'description_277', CURRENT_TIMESTAMP);
INSERT INTO Transactions (transactions_id, time, 	payment_method, created) VALUES (278, '2018-01-02 22:45:29', 'NetBanking', CURRENT_TIMESTAMP);
INSERT INTO Item (item_id, transactions_id, store_id, price, item_type, name, description, created) VALUES (99722.0, 278, 7, 184, 'Electronics', 'name_278', 'description_278', CURRENT_TIMESTAMP);
INSERT INTO Transactions (transactions_id, time, 	payment_method, created) VALUES (279, '2018-01-20 14:17:22', 'DebitCard', CURRENT_TIMESTAMP);
INSERT INTO Item (item_id, transactions_id, store_id, price, item_type, name, description, created) VALUES (99721.0, 279, 5, 191, 'Home', 'name_279', 'description_279', CURRENT_TIMESTAMP);
INSERT INTO Transactions (transactions_id, time, 	payment_method, created) VALUES (280, '2018-02-16 21:43:36', 'DebitCard', CURRENT_TIMESTAMP);
INSERT INTO Item (item_id, transactions_id, store_id, price, item_type, name, description, created) VALUES (99720.0, 280, 7, 131, 'Health', 'name_280', 'description_280', CURRENT_TIMESTAMP);
INSERT INTO Transactions (transactions_id, time, 	payment_method, created) VALUES (281, '2018-02-17 11:46:27', 'NetBanking', CURRENT_TIMESTAMP);
INSERT INTO Item (item_id, transactions_id, store_id, price, item_type, name, description, created) VALUES (99719.0, 281, 12, 170, 'Toys', 'name_281', 'description_281', CURRENT_TIMESTAMP);
INSERT INTO Transactions (transactions_id, time, 	payment_method, created) VALUES (282, '2018-02-01 23:30:22', 'CC', CURRENT_TIMESTAMP);
INSERT INTO Item (item_id, transactions_id, store_id, price, item_type, name, description, created) VALUES (99718.0, 282, 2, 138, 'Books', 'name_282', 'description_282', CURRENT_TIMESTAMP);
INSERT INTO Transactions (transactions_id, time, 	payment_method, created) VALUES (283, '2018-02-13 14:24:10', 'DebitCard', CURRENT_TIMESTAMP);
INSERT INTO Item (item_id, transactions_id, store_id, price, item_type, name, description, created) VALUES (99717.0, 283, 14, 106, 'Home', 'name_283', 'description_283', CURRENT_TIMESTAMP);
INSERT INTO Transactions (transactions_id, time, 	payment_method, created) VALUES (284, '2018-01-24 22:59:04', 'PayPal', CURRENT_TIMESTAMP);
INSERT INTO Item (item_id, transactions_id, store_id, price, item_type, name, description, created) VALUES (99716.0, 284, 2, 25, 'Health', 'name_284', 'description_284', CURRENT_TIMESTAMP);
INSERT INTO Transactions (transactions_id, time, 	payment_method, created) VALUES (285, '2018-01-02 23:26:49', 'CC', CURRENT_TIMESTAMP);
INSERT INTO Item (item_id, transactions_id, store_id, price, item_type, name, description, created) VALUES (99715.0, 285, 10, 222, 'Electronics', 'name_285', 'description_285', CURRENT_TIMESTAMP);
INSERT INTO Transactions (transactions_id, time, 	payment_method, created) VALUES (286, '2018-01-09 13:19:42', 'DebitCard', CURRENT_TIMESTAMP);
INSERT INTO Item (item_id, transactions_id, store_id, price, item_type, name, description, created) VALUES (99714.0, 286, 1, 140, 'Toys', 'name_286', 'description_286', CURRENT_TIMESTAMP);
INSERT INTO Transactions (transactions_id, time, 	payment_method, created) VALUES (287, '2018-02-12 22:16:55', 'DebitCard', CURRENT_TIMESTAMP);
INSERT INTO Item (item_id, transactions_id, store_id, price, item_type, name, description, created) VALUES (99713.0, 287, 9, 257, 'Home', 'name_287', 'description_287', CURRENT_TIMESTAMP);
INSERT INTO Transactions (transactions_id, time, 	payment_method, created) VALUES (288, '2018-01-25 20:17:23', 'DebitCard', CURRENT_TIMESTAMP);
INSERT INTO Item (item_id, transactions_id, store_id, price, item_type, name, description, created) VALUES (99712.0, 288, 11, 16, 'Health', 'name_288', 'description_288', CURRENT_TIMESTAMP);
INSERT INTO Transactions (transactions_id, time, 	payment_method, created) VALUES (289, '2018-01-21 23:59:52', 'NetBanking', CURRENT_TIMESTAMP);
INSERT INTO Item (item_id, transactions_id, store_id, price, item_type, name, description, created) VALUES (99711.0, 289, 9, 201, 'Books', 'name_289', 'description_289', CURRENT_TIMESTAMP);
INSERT INTO Transactions (transactions_id, time, 	payment_method, created) VALUES (290, '2018-01-05 00:58:17', 'DebitCard', CURRENT_TIMESTAMP);
INSERT INTO Item (item_id, transactions_id, store_id, price, item_type, name, description, created) VALUES (99710.0, 290, 11, 144, 'Electronics', 'name_290', 'description_290', CURRENT_TIMESTAMP);
INSERT INTO Transactions (transactions_id, time, 	payment_method, created) VALUES (291, '2018-01-28 11:28:49', 'DebitCard', CURRENT_TIMESTAMP);
INSERT INTO Item (item_id, transactions_id, store_id, price, item_type, name, description, created) VALUES (99709.0, 291, 4, 68, 'Health', 'name_291', 'description_291', CURRENT_TIMESTAMP);
INSERT INTO Transactions (transactions_id, time, 	payment_method, created) VALUES (292, '2018-01-12 06:40:25', 'NetBanking', CURRENT_TIMESTAMP);
INSERT INTO Item (item_id, transactions_id, store_id, price, item_type, name, description, created) VALUES (99708.0, 292, 12, 218, 'Toys', 'name_292', 'description_292', CURRENT_TIMESTAMP);
INSERT INTO Transactions (transactions_id, time, 	payment_method, created) VALUES (293, '2018-01-04 13:24:51', 'NetBanking', CURRENT_TIMESTAMP);
INSERT INTO Item (item_id, transactions_id, store_id, price, item_type, name, description, created) VALUES (99707.0, 293, 2, 19, 'Health', 'name_293', 'description_293', CURRENT_TIMESTAMP);
INSERT INTO Transactions (transactions_id, time, 	payment_method, created) VALUES (294, '2018-01-04 10:26:33', 'CC', CURRENT_TIMESTAMP);
INSERT INTO Item (item_id, transactions_id, store_id, price, item_type, name, description, created) VALUES (99706.0, 294, 6, 7, 'Electronics', 'name_294', 'description_294', CURRENT_TIMESTAMP);
INSERT INTO Transactions (transactions_id, time, 	payment_method, created) VALUES (295, '2018-02-02 02:37:59', 'NetBanking', CURRENT_TIMESTAMP);
INSERT INTO Item (item_id, transactions_id, store_id, price, item_type, name, description, created) VALUES (99705.0, 295, 14, 249, 'Electronics', 'name_295', 'description_295', CURRENT_TIMESTAMP);
INSERT INTO Transactions (transactions_id, time, 	payment_method, created) VALUES (296, '2018-01-28 07:09:48', 'PayPal', CURRENT_TIMESTAMP);
INSERT INTO Item (item_id, transactions_id, store_id, price, item_type, name, description, created) VALUES (99704.0, 296, 3, 206, 'Books', 'name_296', 'description_296', CURRENT_TIMESTAMP);
INSERT INTO Transactions (transactions_id, time, 	payment_method, created) VALUES (297, '2018-01-30 11:32:52', 'NetBanking', CURRENT_TIMESTAMP);
INSERT INTO Item (item_id, transactions_id, store_id, price, item_type, name, description, created) VALUES (99703.0, 297, 3, 91, 'Electronics', 'name_297', 'description_297', CURRENT_TIMESTAMP);
INSERT INTO Transactions (transactions_id, time, 	payment_method, created) VALUES (298, '2018-02-11 19:53:31', 'PayPal', CURRENT_TIMESTAMP);
INSERT INTO Item (item_id, transactions_id, store_id, price, item_type, name, description, created) VALUES (99702.0, 298, 8, 84, 'Electronics', 'name_298', 'description_298', CURRENT_TIMESTAMP);
INSERT INTO Transactions (transactions_id, time, 	payment_method, created) VALUES (299, '2018-02-07 02:59:07', 'CC', CURRENT_TIMESTAMP);
INSERT INTO Item (item_id, transactions_id, store_id, price, item_type, name, description, created) VALUES (99701.0, 299, 14, 230, 'Health', 'name_299', 'description_299', CURRENT_TIMESTAMP);
INSERT INTO Transactions (transactions_id, time, 	payment_method, created) VALUES (300, '2018-01-09 02:02:32', 'DebitCard', CURRENT_TIMESTAMP);
INSERT INTO Item (item_id, transactions_id, store_id, price, item_type, name, description, created) VALUES (99700.0, 300, 5, 178, 'Toys', 'name_300', 'description_300', CURRENT_TIMESTAMP);
INSERT INTO Transactions (transactions_id, time, 	payment_method, created) VALUES (301, '2018-01-12 17:38:03', 'NetBanking', CURRENT_TIMESTAMP);
INSERT INTO Item (item_id, transactions_id, store_id, price, item_type, name, description, created) VALUES (99699.0, 301, 13, 237, 'Health', 'name_301', 'description_301', CURRENT_TIMESTAMP);
INSERT INTO Transactions (transactions_id, time, 	payment_method, created) VALUES (302, '2018-02-18 03:49:14', 'DebitCard', CURRENT_TIMESTAMP);
INSERT INTO Item (item_id, transactions_id, store_id, price, item_type, name, description, created) VALUES (99698.0, 302, 12, 106, 'Home', 'name_302', 'description_302', CURRENT_TIMESTAMP);
INSERT INTO Transactions (transactions_id, time, 	payment_method, created) VALUES (303, '2018-01-03 08:14:50', 'DebitCard', CURRENT_TIMESTAMP);
INSERT INTO Item (item_id, transactions_id, store_id, price, item_type, name, description, created) VALUES (99697.0, 303, 1, 5, 'Health', 'name_303', 'description_303', CURRENT_TIMESTAMP);
INSERT INTO Transactions (transactions_id, time, 	payment_method, created) VALUES (304, '2018-01-14 02:12:55', 'PayPal', CURRENT_TIMESTAMP);
INSERT INTO Item (item_id, transactions_id, store_id, price, item_type, name, description, created) VALUES (99696.0, 304, 13, 257, 'Toys', 'name_304', 'description_304', CURRENT_TIMESTAMP);
INSERT INTO Transactions (transactions_id, time, 	payment_method, created) VALUES (305, '2018-01-09 08:06:42', 'PayPal', CURRENT_TIMESTAMP);
INSERT INTO Item (item_id, transactions_id, store_id, price, item_type, name, description, created) VALUES (99695.0, 305, 5, 182, 'Books', 'name_305', 'description_305', CURRENT_TIMESTAMP);
INSERT INTO Transactions (transactions_id, time, 	payment_method, created) VALUES (306, '2018-01-20 05:57:07', 'CC', CURRENT_TIMESTAMP);
INSERT INTO Item (item_id, transactions_id, store_id, price, item_type, name, description, created) VALUES (99694.0, 306, 8, 243, 'Books', 'name_306', 'description_306', CURRENT_TIMESTAMP);
INSERT INTO Transactions (transactions_id, time, 	payment_method, created) VALUES (307, '2018-01-08 20:12:38', 'CC', CURRENT_TIMESTAMP);
INSERT INTO Item (item_id, transactions_id, store_id, price, item_type, name, description, created) VALUES (99693.0, 307, 7, 175, 'Toys', 'name_307', 'description_307', CURRENT_TIMESTAMP);
INSERT INTO Transactions (transactions_id, time, 	payment_method, created) VALUES (308, '2018-02-02 21:02:00', 'PayPal', CURRENT_TIMESTAMP);
INSERT INTO Item (item_id, transactions_id, store_id, price, item_type, name, description, created) VALUES (99692.0, 308, 2, 179, 'Books', 'name_308', 'description_308', CURRENT_TIMESTAMP);
INSERT INTO Transactions (transactions_id, time, 	payment_method, created) VALUES (309, '2018-01-16 19:26:14', 'NetBanking', CURRENT_TIMESTAMP);
INSERT INTO Item (item_id, transactions_id, store_id, price, item_type, name, description, created) VALUES (99691.0, 309, 10, 292, 'Toys', 'name_309', 'description_309', CURRENT_TIMESTAMP);
INSERT INTO Transactions (transactions_id, time, 	payment_method, created) VALUES (310, '2018-01-28 22:35:36', 'PayPal', CURRENT_TIMESTAMP);
INSERT INTO Item (item_id, transactions_id, store_id, price, item_type, name, description, created) VALUES (99690.0, 310, 13, 173, 'Toys', 'name_310', 'description_310', CURRENT_TIMESTAMP);
INSERT INTO Transactions (transactions_id, time, 	payment_method, created) VALUES (311, '2018-01-15 15:03:25', 'CC', CURRENT_TIMESTAMP);
INSERT INTO Item (item_id, transactions_id, store_id, price, item_type, name, description, created) VALUES (99689.0, 311, 8, 264, 'Health', 'name_311', 'description_311', CURRENT_TIMESTAMP);
INSERT INTO Transactions (transactions_id, time, 	payment_method, created) VALUES (312, '2018-01-20 20:04:38', 'PayPal', CURRENT_TIMESTAMP);
INSERT INTO Item (item_id, transactions_id, store_id, price, item_type, name, description, created) VALUES (99688.0, 312, 9, 53, 'Home', 'name_312', 'description_312', CURRENT_TIMESTAMP);
INSERT INTO Transactions (transactions_id, time, 	payment_method, created) VALUES (313, '2018-01-07 21:31:25', 'NetBanking', CURRENT_TIMESTAMP);
INSERT INTO Item (item_id, transactions_id, store_id, price, item_type, name, description, created) VALUES (99687.0, 313, 14, 171, 'Toys', 'name_313', 'description_313', CURRENT_TIMESTAMP);
INSERT INTO Transactions (transactions_id, time, 	payment_method, created) VALUES (314, '2018-02-19 23:53:55', 'NetBanking', CURRENT_TIMESTAMP);
INSERT INTO Item (item_id, transactions_id, store_id, price, item_type, name, description, created) VALUES (99686.0, 314, 6, 136, 'Toys', 'name_314', 'description_314', CURRENT_TIMESTAMP);
INSERT INTO Transactions (transactions_id, time, 	payment_method, created) VALUES (315, '2018-01-30 05:30:38', 'NetBanking', CURRENT_TIMESTAMP);
INSERT INTO Item (item_id, transactions_id, store_id, price, item_type, name, description, created) VALUES (99685.0, 315, 8, 121, 'Books', 'name_315', 'description_315', CURRENT_TIMESTAMP);
INSERT INTO Transactions (transactions_id, time, 	payment_method, created) VALUES (316, '2018-01-30 21:41:29', 'NetBanking', CURRENT_TIMESTAMP);
INSERT INTO Item (item_id, transactions_id, store_id, price, item_type, name, description, created) VALUES (99684.0, 316, 6, 17, 'Books', 'name_316', 'description_316', CURRENT_TIMESTAMP);
INSERT INTO Transactions (transactions_id, time, 	payment_method, created) VALUES (317, '2018-01-21 00:55:50', 'DebitCard', CURRENT_TIMESTAMP);
INSERT INTO Item (item_id, transactions_id, store_id, price, item_type, name, description, created) VALUES (99683.0, 317, 3, 124, 'Electronics', 'name_317', 'description_317', CURRENT_TIMESTAMP);
INSERT INTO Transactions (transactions_id, time, 	payment_method, created) VALUES (318, '2018-02-05 13:44:50', 'CC', CURRENT_TIMESTAMP);
INSERT INTO Item (item_id, transactions_id, store_id, price, item_type, name, description, created) VALUES (99682.0, 318, 4, 190, 'Home', 'name_318', 'description_318', CURRENT_TIMESTAMP);
INSERT INTO Transactions (transactions_id, time, 	payment_method, created) VALUES (319, '2018-02-17 21:02:34', 'DebitCard', CURRENT_TIMESTAMP);
INSERT INTO Item (item_id, transactions_id, store_id, price, item_type, name, description, created) VALUES (99681.0, 319, 5, 62, 'Books', 'name_319', 'description_319', CURRENT_TIMESTAMP);
INSERT INTO Transactions (transactions_id, time, 	payment_method, created) VALUES (320, '2018-01-11 06:55:55', 'CC', CURRENT_TIMESTAMP);
INSERT INTO Item (item_id, transactions_id, store_id, price, item_type, name, description, created) VALUES (99680.0, 320, 6, 273, 'Toys', 'name_320', 'description_320', CURRENT_TIMESTAMP);
INSERT INTO Transactions (transactions_id, time, 	payment_method, created) VALUES (321, '2018-01-26 23:39:33', 'NetBanking', CURRENT_TIMESTAMP);
INSERT INTO Item (item_id, transactions_id, store_id, price, item_type, name, description, created) VALUES (99679.0, 321, 9, 149, 'Home', 'name_321', 'description_321', CURRENT_TIMESTAMP);
INSERT INTO Transactions (transactions_id, time, 	payment_method, created) VALUES (322, '2018-02-05 16:52:13', 'DebitCard', CURRENT_TIMESTAMP);
INSERT INTO Item (item_id, transactions_id, store_id, price, item_type, name, description, created) VALUES (99678.0, 322, 10, 91, 'Books', 'name_322', 'description_322', CURRENT_TIMESTAMP);
INSERT INTO Transactions (transactions_id, time, 	payment_method, created) VALUES (323, '2018-02-15 16:21:34', 'NetBanking', CURRENT_TIMESTAMP);
INSERT INTO Item (item_id, transactions_id, store_id, price, item_type, name, description, created) VALUES (99677.0, 323, 2, 218, 'Home', 'name_323', 'description_323', CURRENT_TIMESTAMP);
INSERT INTO Transactions (transactions_id, time, 	payment_method, created) VALUES (324, '2018-02-05 16:46:37', 'NetBanking', CURRENT_TIMESTAMP);
INSERT INTO Item (item_id, transactions_id, store_id, price, item_type, name, description, created) VALUES (99676.0, 324, 11, 134, 'Electronics', 'name_324', 'description_324', CURRENT_TIMESTAMP);
INSERT INTO Transactions (transactions_id, time, 	payment_method, created) VALUES (325, '2018-02-13 04:35:41', 'DebitCard', CURRENT_TIMESTAMP);
INSERT INTO Item (item_id, transactions_id, store_id, price, item_type, name, description, created) VALUES (99675.0, 325, 3, 115, 'Toys', 'name_325', 'description_325', CURRENT_TIMESTAMP);
INSERT INTO Transactions (transactions_id, time, 	payment_method, created) VALUES (326, '2018-02-12 10:28:50', 'PayPal', CURRENT_TIMESTAMP);
INSERT INTO Item (item_id, transactions_id, store_id, price, item_type, name, description, created) VALUES (99674.0, 326, 9, 292, 'Electronics', 'name_326', 'description_326', CURRENT_TIMESTAMP);
INSERT INTO Transactions (transactions_id, time, 	payment_method, created) VALUES (327, '2018-02-16 04:43:57', 'NetBanking', CURRENT_TIMESTAMP);
INSERT INTO Item (item_id, transactions_id, store_id, price, item_type, name, description, created) VALUES (99673.0, 327, 12, 275, 'Health', 'name_327', 'description_327', CURRENT_TIMESTAMP);
INSERT INTO Transactions (transactions_id, time, 	payment_method, created) VALUES (328, '2018-01-06 05:13:30', 'CC', CURRENT_TIMESTAMP);
INSERT INTO Item (item_id, transactions_id, store_id, price, item_type, name, description, created) VALUES (99672.0, 328, 13, 145, 'Health', 'name_328', 'description_328', CURRENT_TIMESTAMP);
INSERT INTO Transactions (transactions_id, time, 	payment_method, created) VALUES (329, '2018-01-02 09:13:49', 'DebitCard', CURRENT_TIMESTAMP);
INSERT INTO Item (item_id, transactions_id, store_id, price, item_type, name, description, created) VALUES (99671.0, 329, 13, 81, 'Books', 'name_329', 'description_329', CURRENT_TIMESTAMP);
INSERT INTO Transactions (transactions_id, time, 	payment_method, created) VALUES (330, '2018-01-03 13:37:58', 'CC', CURRENT_TIMESTAMP);
INSERT INTO Item (item_id, transactions_id, store_id, price, item_type, name, description, created) VALUES (99670.0, 330, 13, 114, 'Health', 'name_330', 'description_330', CURRENT_TIMESTAMP);
INSERT INTO Transactions (transactions_id, time, 	payment_method, created) VALUES (331, '2018-02-06 08:04:16', 'CC', CURRENT_TIMESTAMP);
INSERT INTO Item (item_id, transactions_id, store_id, price, item_type, name, description, created) VALUES (99669.0, 331, 3, 136, 'Health', 'name_331', 'description_331', CURRENT_TIMESTAMP);
INSERT INTO Transactions (transactions_id, time, 	payment_method, created) VALUES (332, '2018-01-29 00:47:30', 'DebitCard', CURRENT_TIMESTAMP);
INSERT INTO Item (item_id, transactions_id, store_id, price, item_type, name, description, created) VALUES (99668.0, 332, 14, 171, 'Toys', 'name_332', 'description_332', CURRENT_TIMESTAMP);
INSERT INTO Transactions (transactions_id, time, 	payment_method, created) VALUES (333, '2018-01-04 08:09:45', 'CC', CURRENT_TIMESTAMP);
INSERT INTO Item (item_id, transactions_id, store_id, price, item_type, name, description, created) VALUES (99667.0, 333, 11, 70, 'Books', 'name_333', 'description_333', CURRENT_TIMESTAMP);
INSERT INTO Transactions (transactions_id, time, 	payment_method, created) VALUES (334, '2018-02-18 18:34:36', 'CC', CURRENT_TIMESTAMP);
INSERT INTO Item (item_id, transactions_id, store_id, price, item_type, name, description, created) VALUES (99666.0, 334, 10, 323, 'Electronics', 'name_334', 'description_334', CURRENT_TIMESTAMP);
INSERT INTO Transactions (transactions_id, time, 	payment_method, created) VALUES (335, '2018-01-07 19:26:49', 'DebitCard', CURRENT_TIMESTAMP);
INSERT INTO Item (item_id, transactions_id, store_id, price, item_type, name, description, created) VALUES (99665.0, 335, 8, 224, 'Home', 'name_335', 'description_335', CURRENT_TIMESTAMP);
INSERT INTO Transactions (transactions_id, time, 	payment_method, created) VALUES (336, '2018-01-12 16:39:55', 'PayPal', CURRENT_TIMESTAMP);
INSERT INTO Item (item_id, transactions_id, store_id, price, item_type, name, description, created) VALUES (99664.0, 336, 4, 321, 'Toys', 'name_336', 'description_336', CURRENT_TIMESTAMP);
INSERT INTO Transactions (transactions_id, time, 	payment_method, created) VALUES (337, '2018-01-20 21:30:19', 'PayPal', CURRENT_TIMESTAMP);
INSERT INTO Item (item_id, transactions_id, store_id, price, item_type, name, description, created) VALUES (99663.0, 337, 1, 157, 'Home', 'name_337', 'description_337', CURRENT_TIMESTAMP);
INSERT INTO Transactions (transactions_id, time, 	payment_method, created) VALUES (338, '2018-01-17 17:26:17', 'CC', CURRENT_TIMESTAMP);
INSERT INTO Item (item_id, transactions_id, store_id, price, item_type, name, description, created) VALUES (99662.0, 338, 12, 200, 'Toys', 'name_338', 'description_338', CURRENT_TIMESTAMP);
INSERT INTO Transactions (transactions_id, time, 	payment_method, created) VALUES (339, '2018-01-01 04:19:00', 'NetBanking', CURRENT_TIMESTAMP);
INSERT INTO Item (item_id, transactions_id, store_id, price, item_type, name, description, created) VALUES (99661.0, 339, 3, 197, 'Toys', 'name_339', 'description_339', CURRENT_TIMESTAMP);
INSERT INTO Transactions (transactions_id, time, 	payment_method, created) VALUES (340, '2018-02-17 08:00:02', 'NetBanking', CURRENT_TIMESTAMP);
INSERT INTO Item (item_id, transactions_id, store_id, price, item_type, name, description, created) VALUES (99660.0, 340, 4, 20, 'Health', 'name_340', 'description_340', CURRENT_TIMESTAMP);
INSERT INTO Transactions (transactions_id, time, 	payment_method, created) VALUES (341, '2018-02-13 08:13:56', 'PayPal', CURRENT_TIMESTAMP);
INSERT INTO Item (item_id, transactions_id, store_id, price, item_type, name, description, created) VALUES (99659.0, 341, 10, 147, 'Health', 'name_341', 'description_341', CURRENT_TIMESTAMP);
INSERT INTO Transactions (transactions_id, time, 	payment_method, created) VALUES (342, '2018-02-18 16:06:53', 'PayPal', CURRENT_TIMESTAMP);
INSERT INTO Item (item_id, transactions_id, store_id, price, item_type, name, description, created) VALUES (99658.0, 342, 13, 242, 'Books', 'name_342', 'description_342', CURRENT_TIMESTAMP);
INSERT INTO Transactions (transactions_id, time, 	payment_method, created) VALUES (343, '2018-01-05 01:13:58', 'CC', CURRENT_TIMESTAMP);
INSERT INTO Item (item_id, transactions_id, store_id, price, item_type, name, description, created) VALUES (99657.0, 343, 10, 44, 'Home', 'name_343', 'description_343', CURRENT_TIMESTAMP);
INSERT INTO Transactions (transactions_id, time, 	payment_method, created) VALUES (344, '2018-02-18 15:51:22', 'DebitCard', CURRENT_TIMESTAMP);
INSERT INTO Item (item_id, transactions_id, store_id, price, item_type, name, description, created) VALUES (99656.0, 344, 14, 83, 'Home', 'name_344', 'description_344', CURRENT_TIMESTAMP);
INSERT INTO Transactions (transactions_id, time, 	payment_method, created) VALUES (345, '2018-02-01 09:26:06', 'NetBanking', CURRENT_TIMESTAMP);
INSERT INTO Item (item_id, transactions_id, store_id, price, item_type, name, description, created) VALUES (99655.0, 345, 10, 117, 'Electronics', 'name_345', 'description_345', CURRENT_TIMESTAMP);
INSERT INTO Transactions (transactions_id, time, 	payment_method, created) VALUES (346, '2018-01-29 02:14:28', 'DebitCard', CURRENT_TIMESTAMP);
INSERT INTO Item (item_id, transactions_id, store_id, price, item_type, name, description, created) VALUES (99654.0, 346, 2, 36, 'Toys', 'name_346', 'description_346', CURRENT_TIMESTAMP);
INSERT INTO Transactions (transactions_id, time, 	payment_method, created) VALUES (347, '2018-01-14 04:51:31', 'PayPal', CURRENT_TIMESTAMP);
INSERT INTO Item (item_id, transactions_id, store_id, price, item_type, name, description, created) VALUES (99653.0, 347, 7, 178, 'Home', 'name_347', 'description_347', CURRENT_TIMESTAMP);
INSERT INTO Transactions (transactions_id, time, 	payment_method, created) VALUES (348, '2018-01-08 17:16:57', 'DebitCard', CURRENT_TIMESTAMP);
INSERT INTO Item (item_id, transactions_id, store_id, price, item_type, name, description, created) VALUES (99652.0, 348, 14, 57, 'Electronics', 'name_348', 'description_348', CURRENT_TIMESTAMP);
INSERT INTO Transactions (transactions_id, time, 	payment_method, created) VALUES (349, '2018-02-16 17:05:06', 'DebitCard', CURRENT_TIMESTAMP);
INSERT INTO Item (item_id, transactions_id, store_id, price, item_type, name, description, created) VALUES (99651.0, 349, 5, 97, 'Books', 'name_349', 'description_349', CURRENT_TIMESTAMP);
INSERT INTO Transactions (transactions_id, time, 	payment_method, created) VALUES (350, '2018-02-14 14:58:18', 'DebitCard', CURRENT_TIMESTAMP);
INSERT INTO Item (item_id, transactions_id, store_id, price, item_type, name, description, created) VALUES (99650.0, 350, 1, 286, 'Health', 'name_350', 'description_350', CURRENT_TIMESTAMP);
INSERT INTO Transactions (transactions_id, time, 	payment_method, created) VALUES (351, '2018-01-10 12:16:33', 'PayPal', CURRENT_TIMESTAMP);
INSERT INTO Item (item_id, transactions_id, store_id, price, item_type, name, description, created) VALUES (99649.0, 351, 6, 146, 'Toys', 'name_351', 'description_351', CURRENT_TIMESTAMP);
INSERT INTO Transactions (transactions_id, time, 	payment_method, created) VALUES (352, '2018-02-09 01:07:49', 'PayPal', CURRENT_TIMESTAMP);
INSERT INTO Item (item_id, transactions_id, store_id, price, item_type, name, description, created) VALUES (99648.0, 352, 13, 60, 'Electronics', 'name_352', 'description_352', CURRENT_TIMESTAMP);
INSERT INTO Transactions (transactions_id, time, 	payment_method, created) VALUES (353, '2018-02-12 05:57:05', 'NetBanking', CURRENT_TIMESTAMP);
INSERT INTO Item (item_id, transactions_id, store_id, price, item_type, name, description, created) VALUES (99647.0, 353, 4, 114, 'Home', 'name_353', 'description_353', CURRENT_TIMESTAMP);
INSERT INTO Transactions (transactions_id, time, 	payment_method, created) VALUES (354, '2018-01-16 05:06:00', 'NetBanking', CURRENT_TIMESTAMP);
INSERT INTO Item (item_id, transactions_id, store_id, price, item_type, name, description, created) VALUES (99646.0, 354, 13, 8, 'Books', 'name_354', 'description_354', CURRENT_TIMESTAMP);
INSERT INTO Transactions (transactions_id, time, 	payment_method, created) VALUES (355, '2018-02-08 09:36:54', 'NetBanking', CURRENT_TIMESTAMP);
INSERT INTO Item (item_id, transactions_id, store_id, price, item_type, name, description, created) VALUES (99645.0, 355, 12, 49, 'Toys', 'name_355', 'description_355', CURRENT_TIMESTAMP);
INSERT INTO Transactions (transactions_id, time, 	payment_method, created) VALUES (356, '2018-02-04 01:31:30', 'CC', CURRENT_TIMESTAMP);
INSERT INTO Item (item_id, transactions_id, store_id, price, item_type, name, description, created) VALUES (99644.0, 356, 14, 64, 'Toys', 'name_356', 'description_356', CURRENT_TIMESTAMP);
INSERT INTO Transactions (transactions_id, time, 	payment_method, created) VALUES (357, '2018-01-31 03:40:31', 'CC', CURRENT_TIMESTAMP);
INSERT INTO Item (item_id, transactions_id, store_id, price, item_type, name, description, created) VALUES (99643.0, 357, 5, 84, 'Books', 'name_357', 'description_357', CURRENT_TIMESTAMP);
INSERT INTO Transactions (transactions_id, time, 	payment_method, created) VALUES (358, '2018-02-18 23:49:11', 'CC', CURRENT_TIMESTAMP);
INSERT INTO Item (item_id, transactions_id, store_id, price, item_type, name, description, created) VALUES (99642.0, 358, 10, 80, 'Books', 'name_358', 'description_358', CURRENT_TIMESTAMP);
INSERT INTO Transactions (transactions_id, time, 	payment_method, created) VALUES (359, '2018-01-22 00:03:24', 'NetBanking', CURRENT_TIMESTAMP);
INSERT INTO Item (item_id, transactions_id, store_id, price, item_type, name, description, created) VALUES (99641.0, 359, 6, 291, 'Electronics', 'name_359', 'description_359', CURRENT_TIMESTAMP);
INSERT INTO Transactions (transactions_id, time, 	payment_method, created) VALUES (360, '2018-01-18 09:11:24', 'DebitCard', CURRENT_TIMESTAMP);
INSERT INTO Item (item_id, transactions_id, store_id, price, item_type, name, description, created) VALUES (99640.0, 360, 1, 169, 'Toys', 'name_360', 'description_360', CURRENT_TIMESTAMP);
INSERT INTO Transactions (transactions_id, time, 	payment_method, created) VALUES (361, '2018-01-09 19:12:18', 'DebitCard', CURRENT_TIMESTAMP);
INSERT INTO Item (item_id, transactions_id, store_id, price, item_type, name, description, created) VALUES (99639.0, 361, 12, 61, 'Toys', 'name_361', 'description_361', CURRENT_TIMESTAMP);
INSERT INTO Transactions (transactions_id, time, 	payment_method, created) VALUES (362, '2018-02-07 00:28:44', 'DebitCard', CURRENT_TIMESTAMP);
INSERT INTO Item (item_id, transactions_id, store_id, price, item_type, name, description, created) VALUES (99638.0, 362, 2, 134, 'Books', 'name_362', 'description_362', CURRENT_TIMESTAMP);
INSERT INTO Transactions (transactions_id, time, 	payment_method, created) VALUES (363, '2018-01-02 01:16:38', 'PayPal', CURRENT_TIMESTAMP);
INSERT INTO Item (item_id, transactions_id, store_id, price, item_type, name, description, created) VALUES (99637.0, 363, 12, 187, 'Home', 'name_363', 'description_363', CURRENT_TIMESTAMP);
INSERT INTO Transactions (transactions_id, time, 	payment_method, created) VALUES (364, '2018-01-13 11:46:31', 'DebitCard', CURRENT_TIMESTAMP);
INSERT INTO Item (item_id, transactions_id, store_id, price, item_type, name, description, created) VALUES (99636.0, 364, 7, 29, 'Health', 'name_364', 'description_364', CURRENT_TIMESTAMP);
INSERT INTO Transactions (transactions_id, time, 	payment_method, created) VALUES (365, '2018-02-18 10:47:14', 'DebitCard', CURRENT_TIMESTAMP);
INSERT INTO Item (item_id, transactions_id, store_id, price, item_type, name, description, created) VALUES (99635.0, 365, 4, 333, 'Home', 'name_365', 'description_365', CURRENT_TIMESTAMP);
INSERT INTO Transactions (transactions_id, time, 	payment_method, created) VALUES (366, '2018-02-02 06:59:31', 'NetBanking', CURRENT_TIMESTAMP);
INSERT INTO Item (item_id, transactions_id, store_id, price, item_type, name, description, created) VALUES (99634.0, 366, 13, 6, 'Toys', 'name_366', 'description_366', CURRENT_TIMESTAMP);
INSERT INTO Transactions (transactions_id, time, 	payment_method, created) VALUES (367, '2018-01-08 06:55:14', 'PayPal', CURRENT_TIMESTAMP);
INSERT INTO Item (item_id, transactions_id, store_id, price, item_type, name, description, created) VALUES (99633.0, 367, 11, 47, 'Home', 'name_367', 'description_367', CURRENT_TIMESTAMP);
INSERT INTO Transactions (transactions_id, time, 	payment_method, created) VALUES (368, '2018-02-17 10:53:56', 'DebitCard', CURRENT_TIMESTAMP);
INSERT INTO Item (item_id, transactions_id, store_id, price, item_type, name, description, created) VALUES (99632.0, 368, 10, 140, 'Health', 'name_368', 'description_368', CURRENT_TIMESTAMP);
INSERT INTO Transactions (transactions_id, time, 	payment_method, created) VALUES (369, '2018-02-18 20:45:07', 'NetBanking', CURRENT_TIMESTAMP);
INSERT INTO Item (item_id, transactions_id, store_id, price, item_type, name, description, created) VALUES (99631.0, 369, 8, 208, 'Books', 'name_369', 'description_369', CURRENT_TIMESTAMP);
INSERT INTO Transactions (transactions_id, time, 	payment_method, created) VALUES (370, '2018-02-15 19:40:51', 'NetBanking', CURRENT_TIMESTAMP);
INSERT INTO Item (item_id, transactions_id, store_id, price, item_type, name, description, created) VALUES (99630.0, 370, 7, 14, 'Books', 'name_370', 'description_370', CURRENT_TIMESTAMP);
INSERT INTO Transactions (transactions_id, time, 	payment_method, created) VALUES (371, '2018-02-13 00:03:24', 'CC', CURRENT_TIMESTAMP);
INSERT INTO Item (item_id, transactions_id, store_id, price, item_type, name, description, created) VALUES (99629.0, 371, 14, 366, 'Home', 'name_371', 'description_371', CURRENT_TIMESTAMP);
INSERT INTO Transactions (transactions_id, time, 	payment_method, created) VALUES (372, '2018-01-29 20:56:26', 'NetBanking', CURRENT_TIMESTAMP);
INSERT INTO Item (item_id, transactions_id, store_id, price, item_type, name, description, created) VALUES (99628.0, 372, 10, 6, 'Electronics', 'name_372', 'description_372', CURRENT_TIMESTAMP);
INSERT INTO Transactions (transactions_id, time, 	payment_method, created) VALUES (373, '2018-01-07 14:32:22', 'PayPal', CURRENT_TIMESTAMP);
INSERT INTO Item (item_id, transactions_id, store_id, price, item_type, name, description, created) VALUES (99627.0, 373, 4, 201, 'Electronics', 'name_373', 'description_373', CURRENT_TIMESTAMP);
INSERT INTO Transactions (transactions_id, time, 	payment_method, created) VALUES (374, '2018-02-13 04:49:21', 'NetBanking', CURRENT_TIMESTAMP);
INSERT INTO Item (item_id, transactions_id, store_id, price, item_type, name, description, created) VALUES (99626.0, 374, 6, 245, 'Books', 'name_374', 'description_374', CURRENT_TIMESTAMP);
INSERT INTO Transactions (transactions_id, time, 	payment_method, created) VALUES (375, '2018-02-16 06:39:50', 'CC', CURRENT_TIMESTAMP);
INSERT INTO Item (item_id, transactions_id, store_id, price, item_type, name, description, created) VALUES (99625.0, 375, 9, 97, 'Books', 'name_375', 'description_375', CURRENT_TIMESTAMP);
INSERT INTO Transactions (transactions_id, time, 	payment_method, created) VALUES (376, '2018-02-11 05:34:47', 'DebitCard', CURRENT_TIMESTAMP);
INSERT INTO Item (item_id, transactions_id, store_id, price, item_type, name, description, created) VALUES (99624.0, 376, 1, 278, 'Toys', 'name_376', 'description_376', CURRENT_TIMESTAMP);
INSERT INTO Transactions (transactions_id, time, 	payment_method, created) VALUES (377, '2018-02-05 07:47:06', 'CC', CURRENT_TIMESTAMP);
INSERT INTO Item (item_id, transactions_id, store_id, price, item_type, name, description, created) VALUES (99623.0, 377, 8, 142, 'Health', 'name_377', 'description_377', CURRENT_TIMESTAMP);
INSERT INTO Transactions (transactions_id, time, 	payment_method, created) VALUES (378, '2018-02-05 20:52:36', 'CC', CURRENT_TIMESTAMP);
INSERT INTO Item (item_id, transactions_id, store_id, price, item_type, name, description, created) VALUES (99622.0, 378, 9, 125, 'Electronics', 'name_378', 'description_378', CURRENT_TIMESTAMP);
INSERT INTO Transactions (transactions_id, time, 	payment_method, created) VALUES (379, '2018-02-08 23:08:09', 'PayPal', CURRENT_TIMESTAMP);
INSERT INTO Item (item_id, transactions_id, store_id, price, item_type, name, description, created) VALUES (99621.0, 379, 14, 118, 'Electronics', 'name_379', 'description_379', CURRENT_TIMESTAMP);
INSERT INTO Transactions (transactions_id, time, 	payment_method, created) VALUES (380, '2018-01-24 12:49:09', 'NetBanking', CURRENT_TIMESTAMP);
INSERT INTO Item (item_id, transactions_id, store_id, price, item_type, name, description, created) VALUES (99620.0, 380, 13, 220, 'Home', 'name_380', 'description_380', CURRENT_TIMESTAMP);
INSERT INTO Transactions (transactions_id, time, 	payment_method, created) VALUES (381, '2018-01-30 00:37:55', 'CC', CURRENT_TIMESTAMP);
INSERT INTO Item (item_id, transactions_id, store_id, price, item_type, name, description, created) VALUES (99619.0, 381, 2, 363, 'Health', 'name_381', 'description_381', CURRENT_TIMESTAMP);
INSERT INTO Transactions (transactions_id, time, 	payment_method, created) VALUES (382, '2018-01-30 03:04:48', 'CC', CURRENT_TIMESTAMP);
INSERT INTO Item (item_id, transactions_id, store_id, price, item_type, name, description, created) VALUES (99618.0, 382, 12, 103, 'Home', 'name_382', 'description_382', CURRENT_TIMESTAMP);
INSERT INTO Transactions (transactions_id, time, 	payment_method, created) VALUES (383, '2018-01-28 13:53:50', 'CC', CURRENT_TIMESTAMP);
INSERT INTO Item (item_id, transactions_id, store_id, price, item_type, name, description, created) VALUES (99617.0, 383, 14, 163, 'Books', 'name_383', 'description_383', CURRENT_TIMESTAMP);
INSERT INTO Transactions (transactions_id, time, 	payment_method, created) VALUES (384, '2018-02-13 11:11:36', 'NetBanking', CURRENT_TIMESTAMP);
INSERT INTO Item (item_id, transactions_id, store_id, price, item_type, name, description, created) VALUES (99616.0, 384, 5, 330, 'Books', 'name_384', 'description_384', CURRENT_TIMESTAMP);
INSERT INTO Transactions (transactions_id, time, 	payment_method, created) VALUES (385, '2018-02-20 19:53:24', 'CC', CURRENT_TIMESTAMP);
INSERT INTO Item (item_id, transactions_id, store_id, price, item_type, name, description, created) VALUES (99615.0, 385, 1, 221, 'Home', 'name_385', 'description_385', CURRENT_TIMESTAMP);
INSERT INTO Transactions (transactions_id, time, 	payment_method, created) VALUES (386, '2018-01-22 10:29:37', 'PayPal', CURRENT_TIMESTAMP);
INSERT INTO Item (item_id, transactions_id, store_id, price, item_type, name, description, created) VALUES (99614.0, 386, 12, 284, 'Health', 'name_386', 'description_386', CURRENT_TIMESTAMP);
INSERT INTO Transactions (transactions_id, time, 	payment_method, created) VALUES (387, '2018-02-15 09:15:41', 'CC', CURRENT_TIMESTAMP);
INSERT INTO Item (item_id, transactions_id, store_id, price, item_type, name, description, created) VALUES (99613.0, 387, 1, 267, 'Electronics', 'name_387', 'description_387', CURRENT_TIMESTAMP);
INSERT INTO Transactions (transactions_id, time, 	payment_method, created) VALUES (388, '2018-01-12 21:29:30', 'PayPal', CURRENT_TIMESTAMP);
INSERT INTO Item (item_id, transactions_id, store_id, price, item_type, name, description, created) VALUES (99612.0, 388, 3, 256, 'Electronics', 'name_388', 'description_388', CURRENT_TIMESTAMP);
INSERT INTO Transactions (transactions_id, time, 	payment_method, created) VALUES (389, '2018-01-12 11:02:13', 'NetBanking', CURRENT_TIMESTAMP);
INSERT INTO Item (item_id, transactions_id, store_id, price, item_type, name, description, created) VALUES (99611.0, 389, 7, 190, 'Books', 'name_389', 'description_389', CURRENT_TIMESTAMP);
INSERT INTO Transactions (transactions_id, time, 	payment_method, created) VALUES (390, '2018-02-14 18:25:14', 'PayPal', CURRENT_TIMESTAMP);
INSERT INTO Item (item_id, transactions_id, store_id, price, item_type, name, description, created) VALUES (99610.0, 390, 3, 226, 'Toys', 'name_390', 'description_390', CURRENT_TIMESTAMP);
INSERT INTO Transactions (transactions_id, time, 	payment_method, created) VALUES (391, '2018-02-04 23:32:54', 'DebitCard', CURRENT_TIMESTAMP);
INSERT INTO Item (item_id, transactions_id, store_id, price, item_type, name, description, created) VALUES (99609.0, 391, 4, 310, 'Health', 'name_391', 'description_391', CURRENT_TIMESTAMP);
INSERT INTO Transactions (transactions_id, time, 	payment_method, created) VALUES (392, '2018-01-15 04:05:54', 'PayPal', CURRENT_TIMESTAMP);
INSERT INTO Item (item_id, transactions_id, store_id, price, item_type, name, description, created) VALUES (99608.0, 392, 8, 276, 'Books', 'name_392', 'description_392', CURRENT_TIMESTAMP);
INSERT INTO Transactions (transactions_id, time, 	payment_method, created) VALUES (393, '2018-02-06 21:56:50', 'DebitCard', CURRENT_TIMESTAMP);
INSERT INTO Item (item_id, transactions_id, store_id, price, item_type, name, description, created) VALUES (99607.0, 393, 13, 320, 'Toys', 'name_393', 'description_393', CURRENT_TIMESTAMP);
INSERT INTO Transactions (transactions_id, time, 	payment_method, created) VALUES (394, '2018-01-31 17:44:01', 'NetBanking', CURRENT_TIMESTAMP);
INSERT INTO Item (item_id, transactions_id, store_id, price, item_type, name, description, created) VALUES (99606.0, 394, 7, 2, 'Health', 'name_394', 'description_394', CURRENT_TIMESTAMP);
INSERT INTO Transactions (transactions_id, time, 	payment_method, created) VALUES (395, '2018-02-08 13:04:45', 'DebitCard', CURRENT_TIMESTAMP);
INSERT INTO Item (item_id, transactions_id, store_id, price, item_type, name, description, created) VALUES (99605.0, 395, 9, 106, 'Books', 'name_395', 'description_395', CURRENT_TIMESTAMP);
INSERT INTO Transactions (transactions_id, time, 	payment_method, created) VALUES (396, '2018-01-14 02:45:06', 'NetBanking', CURRENT_TIMESTAMP);
INSERT INTO Item (item_id, transactions_id, store_id, price, item_type, name, description, created) VALUES (99604.0, 396, 4, 352, 'Books', 'name_396', 'description_396', CURRENT_TIMESTAMP);
INSERT INTO Transactions (transactions_id, time, 	payment_method, created) VALUES (397, '2018-02-18 05:12:40', 'PayPal', CURRENT_TIMESTAMP);
INSERT INTO Item (item_id, transactions_id, store_id, price, item_type, name, description, created) VALUES (99603.0, 397, 5, 296, 'Health', 'name_397', 'description_397', CURRENT_TIMESTAMP);
INSERT INTO Transactions (transactions_id, time, 	payment_method, created) VALUES (398, '2018-01-01 15:01:02', 'PayPal', CURRENT_TIMESTAMP);
INSERT INTO Item (item_id, transactions_id, store_id, price, item_type, name, description, created) VALUES (99602.0, 398, 6, 228, 'Health', 'name_398', 'description_398', CURRENT_TIMESTAMP);
INSERT INTO Transactions (transactions_id, time, 	payment_method, created) VALUES (399, '2018-02-17 06:08:17', 'NetBanking', CURRENT_TIMESTAMP);
INSERT INTO Item (item_id, transactions_id, store_id, price, item_type, name, description, created) VALUES (99601.0, 399, 13, 149, 'Health', 'name_399', 'description_399', CURRENT_TIMESTAMP);
INSERT INTO Transactions (transactions_id, time, 	payment_method, created) VALUES (400, '2018-02-07 19:45:11', 'PayPal', CURRENT_TIMESTAMP);
INSERT INTO Item (item_id, transactions_id, store_id, price, item_type, name, description, created) VALUES (99600.0, 400, 1, 44, 'Toys', 'name_400', 'description_400', CURRENT_TIMESTAMP);
INSERT INTO Transactions (transactions_id, time, 	payment_method, created) VALUES (401, '2018-01-14 10:14:04', 'CC', CURRENT_TIMESTAMP);
INSERT INTO Item (item_id, transactions_id, store_id, price, item_type, name, description, created) VALUES (99599.0, 401, 14, 323, 'Books', 'name_401', 'description_401', CURRENT_TIMESTAMP);
INSERT INTO Transactions (transactions_id, time, 	payment_method, created) VALUES (402, '2018-01-22 10:13:13', 'CC', CURRENT_TIMESTAMP);
INSERT INTO Item (item_id, transactions_id, store_id, price, item_type, name, description, created) VALUES (99598.0, 402, 9, 94, 'Electronics', 'name_402', 'description_402', CURRENT_TIMESTAMP);
INSERT INTO Transactions (transactions_id, time, 	payment_method, created) VALUES (403, '2018-01-02 08:55:53', 'PayPal', CURRENT_TIMESTAMP);
INSERT INTO Item (item_id, transactions_id, store_id, price, item_type, name, description, created) VALUES (99597.0, 403, 3, 105, 'Electronics', 'name_403', 'description_403', CURRENT_TIMESTAMP);
INSERT INTO Transactions (transactions_id, time, 	payment_method, created) VALUES (404, '2018-02-09 13:52:49', 'DebitCard', CURRENT_TIMESTAMP);
INSERT INTO Item (item_id, transactions_id, store_id, price, item_type, name, description, created) VALUES (99596.0, 404, 6, 258, 'Home', 'name_404', 'description_404', CURRENT_TIMESTAMP);
INSERT INTO Transactions (transactions_id, time, 	payment_method, created) VALUES (405, '2018-02-05 16:44:14', 'CC', CURRENT_TIMESTAMP);
INSERT INTO Item (item_id, transactions_id, store_id, price, item_type, name, description, created) VALUES (99595.0, 405, 9, 265, 'Toys', 'name_405', 'description_405', CURRENT_TIMESTAMP);
INSERT INTO Transactions (transactions_id, time, 	payment_method, created) VALUES (406, '2018-02-15 08:41:41', 'NetBanking', CURRENT_TIMESTAMP);
INSERT INTO Item (item_id, transactions_id, store_id, price, item_type, name, description, created) VALUES (99594.0, 406, 11, 328, 'Health', 'name_406', 'description_406', CURRENT_TIMESTAMP);
INSERT INTO Transactions (transactions_id, time, 	payment_method, created) VALUES (407, '2018-02-03 23:36:10', 'CC', CURRENT_TIMESTAMP);
INSERT INTO Item (item_id, transactions_id, store_id, price, item_type, name, description, created) VALUES (99593.0, 407, 9, 366, 'Books', 'name_407', 'description_407', CURRENT_TIMESTAMP);
INSERT INTO Transactions (transactions_id, time, 	payment_method, created) VALUES (408, '2018-01-14 01:13:01', 'PayPal', CURRENT_TIMESTAMP);
INSERT INTO Item (item_id, transactions_id, store_id, price, item_type, name, description, created) VALUES (99592.0, 408, 14, 180, 'Health', 'name_408', 'description_408', CURRENT_TIMESTAMP);
INSERT INTO Transactions (transactions_id, time, 	payment_method, created) VALUES (409, '2018-02-02 17:19:47', 'PayPal', CURRENT_TIMESTAMP);
INSERT INTO Item (item_id, transactions_id, store_id, price, item_type, name, description, created) VALUES (99591.0, 409, 2, 406, 'Health', 'name_409', 'description_409', CURRENT_TIMESTAMP);
INSERT INTO Transactions (transactions_id, time, 	payment_method, created) VALUES (410, '2018-01-30 00:28:17', 'DebitCard', CURRENT_TIMESTAMP);
INSERT INTO Item (item_id, transactions_id, store_id, price, item_type, name, description, created) VALUES (99590.0, 410, 11, 294, 'Health', 'name_410', 'description_410', CURRENT_TIMESTAMP);
INSERT INTO Transactions (transactions_id, time, 	payment_method, created) VALUES (411, '2018-02-15 05:03:21', 'CC', CURRENT_TIMESTAMP);
INSERT INTO Item (item_id, transactions_id, store_id, price, item_type, name, description, created) VALUES (99589.0, 411, 7, 144, 'Toys', 'name_411', 'description_411', CURRENT_TIMESTAMP);
INSERT INTO Transactions (transactions_id, time, 	payment_method, created) VALUES (412, '2018-01-09 01:41:17', 'NetBanking', CURRENT_TIMESTAMP);
INSERT INTO Item (item_id, transactions_id, store_id, price, item_type, name, description, created) VALUES (99588.0, 412, 12, 373, 'Home', 'name_412', 'description_412', CURRENT_TIMESTAMP);
INSERT INTO Transactions (transactions_id, time, 	payment_method, created) VALUES (413, '2018-01-23 22:43:10', 'DebitCard', CURRENT_TIMESTAMP);
INSERT INTO Item (item_id, transactions_id, store_id, price, item_type, name, description, created) VALUES (99587.0, 413, 12, 115, 'Books', 'name_413', 'description_413', CURRENT_TIMESTAMP);
INSERT INTO Transactions (transactions_id, time, 	payment_method, created) VALUES (414, '2018-02-01 03:27:32', 'PayPal', CURRENT_TIMESTAMP);
INSERT INTO Item (item_id, transactions_id, store_id, price, item_type, name, description, created) VALUES (99586.0, 414, 8, 26, 'Electronics', 'name_414', 'description_414', CURRENT_TIMESTAMP);
INSERT INTO Transactions (transactions_id, time, 	payment_method, created) VALUES (415, '2018-01-02 19:40:28', 'PayPal', CURRENT_TIMESTAMP);
INSERT INTO Item (item_id, transactions_id, store_id, price, item_type, name, description, created) VALUES (99585.0, 415, 12, 358, 'Books', 'name_415', 'description_415', CURRENT_TIMESTAMP);
INSERT INTO Transactions (transactions_id, time, 	payment_method, created) VALUES (416, '2018-02-03 07:35:12', 'PayPal', CURRENT_TIMESTAMP);
INSERT INTO Item (item_id, transactions_id, store_id, price, item_type, name, description, created) VALUES (99584.0, 416, 9, 204, 'Electronics', 'name_416', 'description_416', CURRENT_TIMESTAMP);
INSERT INTO Transactions (transactions_id, time, 	payment_method, created) VALUES (417, '2018-01-21 11:13:02', 'CC', CURRENT_TIMESTAMP);
INSERT INTO Item (item_id, transactions_id, store_id, price, item_type, name, description, created) VALUES (99583.0, 417, 9, 293, 'Home', 'name_417', 'description_417', CURRENT_TIMESTAMP);
INSERT INTO Transactions (transactions_id, time, 	payment_method, created) VALUES (418, '2018-01-22 04:47:39', 'DebitCard', CURRENT_TIMESTAMP);
INSERT INTO Item (item_id, transactions_id, store_id, price, item_type, name, description, created) VALUES (99582.0, 418, 12, 393, 'Books', 'name_418', 'description_418', CURRENT_TIMESTAMP);
INSERT INTO Transactions (transactions_id, time, 	payment_method, created) VALUES (419, '2018-01-31 23:57:36', 'PayPal', CURRENT_TIMESTAMP);
INSERT INTO Item (item_id, transactions_id, store_id, price, item_type, name, description, created) VALUES (99581.0, 419, 4, 251, 'Home', 'name_419', 'description_419', CURRENT_TIMESTAMP);
INSERT INTO Transactions (transactions_id, time, 	payment_method, created) VALUES (420, '2018-01-10 09:28:16', 'NetBanking', CURRENT_TIMESTAMP);
INSERT INTO Item (item_id, transactions_id, store_id, price, item_type, name, description, created) VALUES (99580.0, 420, 4, 21, 'Health', 'name_420', 'description_420', CURRENT_TIMESTAMP);
INSERT INTO Transactions (transactions_id, time, 	payment_method, created) VALUES (421, '2018-01-14 17:28:39', 'NetBanking', CURRENT_TIMESTAMP);
INSERT INTO Item (item_id, transactions_id, store_id, price, item_type, name, description, created) VALUES (99579.0, 421, 13, 192, 'Books', 'name_421', 'description_421', CURRENT_TIMESTAMP);
INSERT INTO Transactions (transactions_id, time, 	payment_method, created) VALUES (422, '2018-02-12 05:03:34', 'NetBanking', CURRENT_TIMESTAMP);
INSERT INTO Item (item_id, transactions_id, store_id, price, item_type, name, description, created) VALUES (99578.0, 422, 8, 191, 'Electronics', 'name_422', 'description_422', CURRENT_TIMESTAMP);
INSERT INTO Transactions (transactions_id, time, 	payment_method, created) VALUES (423, '2018-01-23 13:35:07', 'CC', CURRENT_TIMESTAMP);
INSERT INTO Item (item_id, transactions_id, store_id, price, item_type, name, description, created) VALUES (99577.0, 423, 4, 49, 'Books', 'name_423', 'description_423', CURRENT_TIMESTAMP);
INSERT INTO Transactions (transactions_id, time, 	payment_method, created) VALUES (424, '2018-01-08 00:55:04', 'NetBanking', CURRENT_TIMESTAMP);
INSERT INTO Item (item_id, transactions_id, store_id, price, item_type, name, description, created) VALUES (99576.0, 424, 2, 17, 'Health', 'name_424', 'description_424', CURRENT_TIMESTAMP);
INSERT INTO Transactions (transactions_id, time, 	payment_method, created) VALUES (425, '2018-01-25 17:24:35', 'PayPal', CURRENT_TIMESTAMP);
INSERT INTO Item (item_id, transactions_id, store_id, price, item_type, name, description, created) VALUES (99575.0, 425, 4, 44, 'Electronics', 'name_425', 'description_425', CURRENT_TIMESTAMP);
INSERT INTO Transactions (transactions_id, time, 	payment_method, created) VALUES (426, '2018-01-04 09:43:52', 'CC', CURRENT_TIMESTAMP);
INSERT INTO Item (item_id, transactions_id, store_id, price, item_type, name, description, created) VALUES (99574.0, 426, 14, 368, 'Electronics', 'name_426', 'description_426', CURRENT_TIMESTAMP);
INSERT INTO Transactions (transactions_id, time, 	payment_method, created) VALUES (427, '2018-01-02 14:53:03', 'PayPal', CURRENT_TIMESTAMP);
INSERT INTO Item (item_id, transactions_id, store_id, price, item_type, name, description, created) VALUES (99573.0, 427, 4, 279, 'Toys', 'name_427', 'description_427', CURRENT_TIMESTAMP);
INSERT INTO Transactions (transactions_id, time, 	payment_method, created) VALUES (428, '2018-01-03 00:11:34', 'CC', CURRENT_TIMESTAMP);
INSERT INTO Item (item_id, transactions_id, store_id, price, item_type, name, description, created) VALUES (99572.0, 428, 6, 48, 'Electronics', 'name_428', 'description_428', CURRENT_TIMESTAMP);
INSERT INTO Transactions (transactions_id, time, 	payment_method, created) VALUES (429, '2018-02-05 08:50:54', 'NetBanking', CURRENT_TIMESTAMP);
INSERT INTO Item (item_id, transactions_id, store_id, price, item_type, name, description, created) VALUES (99571.0, 429, 11, 133, 'Toys', 'name_429', 'description_429', CURRENT_TIMESTAMP);
INSERT INTO Transactions (transactions_id, time, 	payment_method, created) VALUES (430, '2018-01-04 08:31:36', 'PayPal', CURRENT_TIMESTAMP);
INSERT INTO Item (item_id, transactions_id, store_id, price, item_type, name, description, created) VALUES (99570.0, 430, 6, 219, 'Health', 'name_430', 'description_430', CURRENT_TIMESTAMP);
INSERT INTO Transactions (transactions_id, time, 	payment_method, created) VALUES (431, '2018-02-05 14:30:01', 'PayPal', CURRENT_TIMESTAMP);
INSERT INTO Item (item_id, transactions_id, store_id, price, item_type, name, description, created) VALUES (99569.0, 431, 11, 279, 'Electronics', 'name_431', 'description_431', CURRENT_TIMESTAMP);
INSERT INTO Transactions (transactions_id, time, 	payment_method, created) VALUES (432, '2018-01-19 01:58:30', 'PayPal', CURRENT_TIMESTAMP);
INSERT INTO Item (item_id, transactions_id, store_id, price, item_type, name, description, created) VALUES (99568.0, 432, 12, 101, 'Toys', 'name_432', 'description_432', CURRENT_TIMESTAMP);
INSERT INTO Transactions (transactions_id, time, 	payment_method, created) VALUES (433, '2018-02-05 06:23:31', 'DebitCard', CURRENT_TIMESTAMP);
INSERT INTO Item (item_id, transactions_id, store_id, price, item_type, name, description, created) VALUES (99567.0, 433, 4, 96, 'Health', 'name_433', 'description_433', CURRENT_TIMESTAMP);
INSERT INTO Transactions (transactions_id, time, 	payment_method, created) VALUES (434, '2018-01-04 21:07:32', 'PayPal', CURRENT_TIMESTAMP);
INSERT INTO Item (item_id, transactions_id, store_id, price, item_type, name, description, created) VALUES (99566.0, 434, 2, 235, 'Books', 'name_434', 'description_434', CURRENT_TIMESTAMP);
INSERT INTO Transactions (transactions_id, time, 	payment_method, created) VALUES (435, '2018-01-08 07:44:38', 'DebitCard', CURRENT_TIMESTAMP);
INSERT INTO Item (item_id, transactions_id, store_id, price, item_type, name, description, created) VALUES (99565.0, 435, 5, 84, 'Electronics', 'name_435', 'description_435', CURRENT_TIMESTAMP);
INSERT INTO Transactions (transactions_id, time, 	payment_method, created) VALUES (436, '2018-01-20 11:24:11', 'PayPal', CURRENT_TIMESTAMP);
INSERT INTO Item (item_id, transactions_id, store_id, price, item_type, name, description, created) VALUES (99564.0, 436, 8, 101, 'Health', 'name_436', 'description_436', CURRENT_TIMESTAMP);
INSERT INTO Transactions (transactions_id, time, 	payment_method, created) VALUES (437, '2018-01-16 07:15:24', 'PayPal', CURRENT_TIMESTAMP);
INSERT INTO Item (item_id, transactions_id, store_id, price, item_type, name, description, created) VALUES (99563.0, 437, 2, 415, 'Home', 'name_437', 'description_437', CURRENT_TIMESTAMP);
INSERT INTO Transactions (transactions_id, time, 	payment_method, created) VALUES (438, '2018-01-12 01:02:59', 'PayPal', CURRENT_TIMESTAMP);
INSERT INTO Item (item_id, transactions_id, store_id, price, item_type, name, description, created) VALUES (99562.0, 438, 2, 402, 'Home', 'name_438', 'description_438', CURRENT_TIMESTAMP);
INSERT INTO Transactions (transactions_id, time, 	payment_method, created) VALUES (439, '2018-01-19 22:29:04', 'DebitCard', CURRENT_TIMESTAMP);
INSERT INTO Item (item_id, transactions_id, store_id, price, item_type, name, description, created) VALUES (99561.0, 439, 13, 265, 'Health', 'name_439', 'description_439', CURRENT_TIMESTAMP);
INSERT INTO Transactions (transactions_id, time, 	payment_method, created) VALUES (440, '2018-02-20 11:42:24', 'CC', CURRENT_TIMESTAMP);
INSERT INTO Item (item_id, transactions_id, store_id, price, item_type, name, description, created) VALUES (99560.0, 440, 11, 253, 'Toys', 'name_440', 'description_440', CURRENT_TIMESTAMP);
INSERT INTO Transactions (transactions_id, time, 	payment_method, created) VALUES (441, '2018-02-13 16:46:57', 'PayPal', CURRENT_TIMESTAMP);
INSERT INTO Item (item_id, transactions_id, store_id, price, item_type, name, description, created) VALUES (99559.0, 441, 7, 121, 'Books', 'name_441', 'description_441', CURRENT_TIMESTAMP);
INSERT INTO Transactions (transactions_id, time, 	payment_method, created) VALUES (442, '2018-01-05 23:33:38', 'PayPal', CURRENT_TIMESTAMP);
INSERT INTO Item (item_id, transactions_id, store_id, price, item_type, name, description, created) VALUES (99558.0, 442, 3, 36, 'Home', 'name_442', 'description_442', CURRENT_TIMESTAMP);
INSERT INTO Transactions (transactions_id, time, 	payment_method, created) VALUES (443, '2018-01-19 05:16:25', 'CC', CURRENT_TIMESTAMP);
INSERT INTO Item (item_id, transactions_id, store_id, price, item_type, name, description, created) VALUES (99557.0, 443, 6, 5, 'Books', 'name_443', 'description_443', CURRENT_TIMESTAMP);
INSERT INTO Transactions (transactions_id, time, 	payment_method, created) VALUES (444, '2018-01-25 10:05:18', 'PayPal', CURRENT_TIMESTAMP);
INSERT INTO Item (item_id, transactions_id, store_id, price, item_type, name, description, created) VALUES (99556.0, 444, 5, 323, 'Books', 'name_444', 'description_444', CURRENT_TIMESTAMP);
INSERT INTO Transactions (transactions_id, time, 	payment_method, created) VALUES (445, '2018-01-26 07:35:38', 'DebitCard', CURRENT_TIMESTAMP);
INSERT INTO Item (item_id, transactions_id, store_id, price, item_type, name, description, created) VALUES (99555.0, 445, 5, 146, 'Toys', 'name_445', 'description_445', CURRENT_TIMESTAMP);
INSERT INTO Transactions (transactions_id, time, 	payment_method, created) VALUES (446, '2018-01-10 03:22:48', 'PayPal', CURRENT_TIMESTAMP);
INSERT INTO Item (item_id, transactions_id, store_id, price, item_type, name, description, created) VALUES (99554.0, 446, 8, 205, 'Electronics', 'name_446', 'description_446', CURRENT_TIMESTAMP);
INSERT INTO Transactions (transactions_id, time, 	payment_method, created) VALUES (447, '2018-02-09 09:03:47', 'CC', CURRENT_TIMESTAMP);
INSERT INTO Item (item_id, transactions_id, store_id, price, item_type, name, description, created) VALUES (99553.0, 447, 6, 131, 'Home', 'name_447', 'description_447', CURRENT_TIMESTAMP);
INSERT INTO Transactions (transactions_id, time, 	payment_method, created) VALUES (448, '2018-01-06 16:41:50', 'CC', CURRENT_TIMESTAMP);
INSERT INTO Item (item_id, transactions_id, store_id, price, item_type, name, description, created) VALUES (99552.0, 448, 5, 275, 'Toys', 'name_448', 'description_448', CURRENT_TIMESTAMP);
INSERT INTO Transactions (transactions_id, time, 	payment_method, created) VALUES (449, '2018-01-22 06:50:27', 'NetBanking', CURRENT_TIMESTAMP);
INSERT INTO Item (item_id, transactions_id, store_id, price, item_type, name, description, created) VALUES (99551.0, 449, 4, 192, 'Health', 'name_449', 'description_449', CURRENT_TIMESTAMP);
INSERT INTO Transactions (transactions_id, time, 	payment_method, created) VALUES (450, '2018-01-11 01:26:46', 'PayPal', CURRENT_TIMESTAMP);
INSERT INTO Item (item_id, transactions_id, store_id, price, item_type, name, description, created) VALUES (99550.0, 450, 1, 241, 'Toys', 'name_450', 'description_450', CURRENT_TIMESTAMP);
INSERT INTO Transactions (transactions_id, time, 	payment_method, created) VALUES (451, '2018-02-02 08:44:34', 'PayPal', CURRENT_TIMESTAMP);
INSERT INTO Item (item_id, transactions_id, store_id, price, item_type, name, description, created) VALUES (99549.0, 451, 12, 396, 'Books', 'name_451', 'description_451', CURRENT_TIMESTAMP);
INSERT INTO Transactions (transactions_id, time, 	payment_method, created) VALUES (452, '2018-01-06 22:28:05', 'CC', CURRENT_TIMESTAMP);
INSERT INTO Item (item_id, transactions_id, store_id, price, item_type, name, description, created) VALUES (99548.0, 452, 8, 209, 'Books', 'name_452', 'description_452', CURRENT_TIMESTAMP);
INSERT INTO Transactions (transactions_id, time, 	payment_method, created) VALUES (453, '2018-02-12 21:54:10', 'DebitCard', CURRENT_TIMESTAMP);
INSERT INTO Item (item_id, transactions_id, store_id, price, item_type, name, description, created) VALUES (99547.0, 453, 9, 387, 'Electronics', 'name_453', 'description_453', CURRENT_TIMESTAMP);
INSERT INTO Transactions (transactions_id, time, 	payment_method, created) VALUES (454, '2018-01-21 12:07:16', 'NetBanking', CURRENT_TIMESTAMP);
INSERT INTO Item (item_id, transactions_id, store_id, price, item_type, name, description, created) VALUES (99546.0, 454, 11, 357, 'Health', 'name_454', 'description_454', CURRENT_TIMESTAMP);
INSERT INTO Transactions (transactions_id, time, 	payment_method, created) VALUES (455, '2018-01-15 02:12:01', 'DebitCard', CURRENT_TIMESTAMP);
INSERT INTO Item (item_id, transactions_id, store_id, price, item_type, name, description, created) VALUES (99545.0, 455, 8, 157, 'Toys', 'name_455', 'description_455', CURRENT_TIMESTAMP);
INSERT INTO Transactions (transactions_id, time, 	payment_method, created) VALUES (456, '2018-02-01 11:30:25', 'DebitCard', CURRENT_TIMESTAMP);
INSERT INTO Item (item_id, transactions_id, store_id, price, item_type, name, description, created) VALUES (99544.0, 456, 12, 40, 'Home', 'name_456', 'description_456', CURRENT_TIMESTAMP);
INSERT INTO Transactions (transactions_id, time, 	payment_method, created) VALUES (457, '2018-02-06 03:20:07', 'CC', CURRENT_TIMESTAMP);
INSERT INTO Item (item_id, transactions_id, store_id, price, item_type, name, description, created) VALUES (99543.0, 457, 4, 50, 'Health', 'name_457', 'description_457', CURRENT_TIMESTAMP);
INSERT INTO Transactions (transactions_id, time, 	payment_method, created) VALUES (458, '2018-01-27 12:24:46', 'CC', CURRENT_TIMESTAMP);
INSERT INTO Item (item_id, transactions_id, store_id, price, item_type, name, description, created) VALUES (99542.0, 458, 10, 187, 'Books', 'name_458', 'description_458', CURRENT_TIMESTAMP);
INSERT INTO Transactions (transactions_id, time, 	payment_method, created) VALUES (459, '2018-01-10 11:29:37', 'CC', CURRENT_TIMESTAMP);
INSERT INTO Item (item_id, transactions_id, store_id, price, item_type, name, description, created) VALUES (99541.0, 459, 4, 65, 'Health', 'name_459', 'description_459', CURRENT_TIMESTAMP);
INSERT INTO Transactions (transactions_id, time, 	payment_method, created) VALUES (460, '2018-01-29 04:51:37', 'CC', CURRENT_TIMESTAMP);
INSERT INTO Item (item_id, transactions_id, store_id, price, item_type, name, description, created) VALUES (99540.0, 460, 6, 46, 'Electronics', 'name_460', 'description_460', CURRENT_TIMESTAMP);
INSERT INTO Transactions (transactions_id, time, 	payment_method, created) VALUES (461, '2018-02-06 04:09:26', 'CC', CURRENT_TIMESTAMP);
INSERT INTO Item (item_id, transactions_id, store_id, price, item_type, name, description, created) VALUES (99539.0, 461, 6, 263, 'Electronics', 'name_461', 'description_461', CURRENT_TIMESTAMP);
INSERT INTO Transactions (transactions_id, time, 	payment_method, created) VALUES (462, '2018-02-06 05:14:47', 'NetBanking', CURRENT_TIMESTAMP);
INSERT INTO Item (item_id, transactions_id, store_id, price, item_type, name, description, created) VALUES (99538.0, 462, 6, 40, 'Home', 'name_462', 'description_462', CURRENT_TIMESTAMP);
INSERT INTO Transactions (transactions_id, time, 	payment_method, created) VALUES (463, '2018-02-04 23:53:43', 'CC', CURRENT_TIMESTAMP);
INSERT INTO Item (item_id, transactions_id, store_id, price, item_type, name, description, created) VALUES (99537.0, 463, 7, 439, 'Electronics', 'name_463', 'description_463', CURRENT_TIMESTAMP);
INSERT INTO Transactions (transactions_id, time, 	payment_method, created) VALUES (464, '2018-02-10 15:43:01', 'CC', CURRENT_TIMESTAMP);
INSERT INTO Item (item_id, transactions_id, store_id, price, item_type, name, description, created) VALUES (99536.0, 464, 4, 247, 'Health', 'name_464', 'description_464', CURRENT_TIMESTAMP);
INSERT INTO Transactions (transactions_id, time, 	payment_method, created) VALUES (465, '2018-01-31 04:25:32', 'CC', CURRENT_TIMESTAMP);
INSERT INTO Item (item_id, transactions_id, store_id, price, item_type, name, description, created) VALUES (99535.0, 465, 9, 264, 'Health', 'name_465', 'description_465', CURRENT_TIMESTAMP);
INSERT INTO Transactions (transactions_id, time, 	payment_method, created) VALUES (466, '2018-01-18 15:48:36', 'NetBanking', CURRENT_TIMESTAMP);
INSERT INTO Item (item_id, transactions_id, store_id, price, item_type, name, description, created) VALUES (99534.0, 466, 4, 170, 'Health', 'name_466', 'description_466', CURRENT_TIMESTAMP);
INSERT INTO Transactions (transactions_id, time, 	payment_method, created) VALUES (467, '2018-02-06 22:59:28', 'CC', CURRENT_TIMESTAMP);
INSERT INTO Item (item_id, transactions_id, store_id, price, item_type, name, description, created) VALUES (99533.0, 467, 10, 38, 'Electronics', 'name_467', 'description_467', CURRENT_TIMESTAMP);
INSERT INTO Transactions (transactions_id, time, 	payment_method, created) VALUES (468, '2018-02-03 16:39:37', 'NetBanking', CURRENT_TIMESTAMP);
INSERT INTO Item (item_id, transactions_id, store_id, price, item_type, name, description, created) VALUES (99532.0, 468, 6, 19, 'Electronics', 'name_468', 'description_468', CURRENT_TIMESTAMP);
INSERT INTO Transactions (transactions_id, time, 	payment_method, created) VALUES (469, '2018-01-09 08:45:26', 'DebitCard', CURRENT_TIMESTAMP);
INSERT INTO Item (item_id, transactions_id, store_id, price, item_type, name, description, created) VALUES (99531.0, 469, 6, 276, 'Home', 'name_469', 'description_469', CURRENT_TIMESTAMP);
INSERT INTO Transactions (transactions_id, time, 	payment_method, created) VALUES (470, '2018-01-19 16:01:56', 'NetBanking', CURRENT_TIMESTAMP);
INSERT INTO Item (item_id, transactions_id, store_id, price, item_type, name, description, created) VALUES (99530.0, 470, 14, 414, 'Home', 'name_470', 'description_470', CURRENT_TIMESTAMP);
INSERT INTO Transactions (transactions_id, time, 	payment_method, created) VALUES (471, '2018-01-25 14:09:35', 'PayPal', CURRENT_TIMESTAMP);
INSERT INTO Item (item_id, transactions_id, store_id, price, item_type, name, description, created) VALUES (99529.0, 471, 13, 430, 'Toys', 'name_471', 'description_471', CURRENT_TIMESTAMP);
INSERT INTO Transactions (transactions_id, time, 	payment_method, created) VALUES (472, '2018-01-07 15:41:28', 'DebitCard', CURRENT_TIMESTAMP);
INSERT INTO Item (item_id, transactions_id, store_id, price, item_type, name, description, created) VALUES (99528.0, 472, 8, 154, 'Electronics', 'name_472', 'description_472', CURRENT_TIMESTAMP);
INSERT INTO Transactions (transactions_id, time, 	payment_method, created) VALUES (473, '2018-01-04 04:32:46', 'CC', CURRENT_TIMESTAMP);
INSERT INTO Item (item_id, transactions_id, store_id, price, item_type, name, description, created) VALUES (99527.0, 473, 11, 454, 'Electronics', 'name_473', 'description_473', CURRENT_TIMESTAMP);
INSERT INTO Transactions (transactions_id, time, 	payment_method, created) VALUES (474, '2018-01-14 20:56:43', 'NetBanking', CURRENT_TIMESTAMP);
INSERT INTO Item (item_id, transactions_id, store_id, price, item_type, name, description, created) VALUES (99526.0, 474, 4, 305, 'Health', 'name_474', 'description_474', CURRENT_TIMESTAMP);
INSERT INTO Transactions (transactions_id, time, 	payment_method, created) VALUES (475, '2018-02-07 05:22:43', 'DebitCard', CURRENT_TIMESTAMP);
INSERT INTO Item (item_id, transactions_id, store_id, price, item_type, name, description, created) VALUES (99525.0, 475, 7, 50, 'Books', 'name_475', 'description_475', CURRENT_TIMESTAMP);
INSERT INTO Transactions (transactions_id, time, 	payment_method, created) VALUES (476, '2018-01-05 06:41:55', 'PayPal', CURRENT_TIMESTAMP);
INSERT INTO Item (item_id, transactions_id, store_id, price, item_type, name, description, created) VALUES (99524.0, 476, 9, 218, 'Electronics', 'name_476', 'description_476', CURRENT_TIMESTAMP);
INSERT INTO Transactions (transactions_id, time, 	payment_method, created) VALUES (477, '2018-01-04 03:55:38', 'NetBanking', CURRENT_TIMESTAMP);
INSERT INTO Item (item_id, transactions_id, store_id, price, item_type, name, description, created) VALUES (99523.0, 477, 2, 244, 'Home', 'name_477', 'description_477', CURRENT_TIMESTAMP);
INSERT INTO Transactions (transactions_id, time, 	payment_method, created) VALUES (478, '2018-01-22 14:30:45', 'CC', CURRENT_TIMESTAMP);
INSERT INTO Item (item_id, transactions_id, store_id, price, item_type, name, description, created) VALUES (99522.0, 478, 8, 379, 'Home', 'name_478', 'description_478', CURRENT_TIMESTAMP);
INSERT INTO Transactions (transactions_id, time, 	payment_method, created) VALUES (479, '2018-02-07 07:34:53', 'NetBanking', CURRENT_TIMESTAMP);
INSERT INTO Item (item_id, transactions_id, store_id, price, item_type, name, description, created) VALUES (99521.0, 479, 11, 302, 'Health', 'name_479', 'description_479', CURRENT_TIMESTAMP);
INSERT INTO Transactions (transactions_id, time, 	payment_method, created) VALUES (480, '2018-02-06 14:33:53', 'NetBanking', CURRENT_TIMESTAMP);
INSERT INTO Item (item_id, transactions_id, store_id, price, item_type, name, description, created) VALUES (99520.0, 480, 8, 204, 'Toys', 'name_480', 'description_480', CURRENT_TIMESTAMP);
INSERT INTO Transactions (transactions_id, time, 	payment_method, created) VALUES (481, '2018-01-06 10:45:20', 'PayPal', CURRENT_TIMESTAMP);
INSERT INTO Item (item_id, transactions_id, store_id, price, item_type, name, description, created) VALUES (99519.0, 481, 7, 32, 'Health', 'name_481', 'description_481', CURRENT_TIMESTAMP);
INSERT INTO Transactions (transactions_id, time, 	payment_method, created) VALUES (482, '2018-02-19 08:18:49', 'CC', CURRENT_TIMESTAMP);
INSERT INTO Item (item_id, transactions_id, store_id, price, item_type, name, description, created) VALUES (99518.0, 482, 14, 419, 'Books', 'name_482', 'description_482', CURRENT_TIMESTAMP);
INSERT INTO Transactions (transactions_id, time, 	payment_method, created) VALUES (483, '2018-02-03 19:12:09', 'NetBanking', CURRENT_TIMESTAMP);
INSERT INTO Item (item_id, transactions_id, store_id, price, item_type, name, description, created) VALUES (99517.0, 483, 9, 115, 'Electronics', 'name_483', 'description_483', CURRENT_TIMESTAMP);
INSERT INTO Transactions (transactions_id, time, 	payment_method, created) VALUES (484, '2018-01-08 13:16:08', 'NetBanking', CURRENT_TIMESTAMP);
INSERT INTO Item (item_id, transactions_id, store_id, price, item_type, name, description, created) VALUES (99516.0, 484, 6, 266, 'Books', 'name_484', 'description_484', CURRENT_TIMESTAMP);
INSERT INTO Transactions (transactions_id, time, 	payment_method, created) VALUES (485, '2018-01-20 05:15:23', 'PayPal', CURRENT_TIMESTAMP);
INSERT INTO Item (item_id, transactions_id, store_id, price, item_type, name, description, created) VALUES (99515.0, 485, 10, 16, 'Electronics', 'name_485', 'description_485', CURRENT_TIMESTAMP);
INSERT INTO Transactions (transactions_id, time, 	payment_method, created) VALUES (486, '2018-02-17 07:44:44', 'CC', CURRENT_TIMESTAMP);
INSERT INTO Item (item_id, transactions_id, store_id, price, item_type, name, description, created) VALUES (99514.0, 486, 12, 69, 'Toys', 'name_486', 'description_486', CURRENT_TIMESTAMP);
INSERT INTO Transactions (transactions_id, time, 	payment_method, created) VALUES (487, '2018-01-28 11:14:38', 'DebitCard', CURRENT_TIMESTAMP);
INSERT INTO Item (item_id, transactions_id, store_id, price, item_type, name, description, created) VALUES (99513.0, 487, 6, 139, 'Toys', 'name_487', 'description_487', CURRENT_TIMESTAMP);
INSERT INTO Transactions (transactions_id, time, 	payment_method, created) VALUES (488, '2018-02-06 05:42:21', 'NetBanking', CURRENT_TIMESTAMP);
INSERT INTO Item (item_id, transactions_id, store_id, price, item_type, name, description, created) VALUES (99512.0, 488, 4, 456, 'Electronics', 'name_488', 'description_488', CURRENT_TIMESTAMP);
INSERT INTO Transactions (transactions_id, time, 	payment_method, created) VALUES (489, '2018-02-06 08:50:04', 'CC', CURRENT_TIMESTAMP);
INSERT INTO Item (item_id, transactions_id, store_id, price, item_type, name, description, created) VALUES (99511.0, 489, 12, 346, 'Toys', 'name_489', 'description_489', CURRENT_TIMESTAMP);
INSERT INTO Transactions (transactions_id, time, 	payment_method, created) VALUES (490, '2018-01-12 20:44:11', 'PayPal', CURRENT_TIMESTAMP);
INSERT INTO Item (item_id, transactions_id, store_id, price, item_type, name, description, created) VALUES (99510.0, 490, 12, 5, 'Books', 'name_490', 'description_490', CURRENT_TIMESTAMP);
INSERT INTO Transactions (transactions_id, time, 	payment_method, created) VALUES (491, '2018-02-01 15:23:58', 'DebitCard', CURRENT_TIMESTAMP);
INSERT INTO Item (item_id, transactions_id, store_id, price, item_type, name, description, created) VALUES (99509.0, 491, 5, 296, 'Health', 'name_491', 'description_491', CURRENT_TIMESTAMP);
INSERT INTO Transactions (transactions_id, time, 	payment_method, created) VALUES (492, '2018-02-10 09:28:55', 'NetBanking', CURRENT_TIMESTAMP);
INSERT INTO Item (item_id, transactions_id, store_id, price, item_type, name, description, created) VALUES (99508.0, 492, 5, 481, 'Electronics', 'name_492', 'description_492', CURRENT_TIMESTAMP);
INSERT INTO Transactions (transactions_id, time, 	payment_method, created) VALUES (493, '2018-01-14 14:41:20', 'NetBanking', CURRENT_TIMESTAMP);
INSERT INTO Item (item_id, transactions_id, store_id, price, item_type, name, description, created) VALUES (99507.0, 493, 10, 335, 'Toys', 'name_493', 'description_493', CURRENT_TIMESTAMP);
INSERT INTO Transactions (transactions_id, time, 	payment_method, created) VALUES (494, '2018-02-20 01:32:34', 'DebitCard', CURRENT_TIMESTAMP);
INSERT INTO Item (item_id, transactions_id, store_id, price, item_type, name, description, created) VALUES (99506.0, 494, 13, 251, 'Books', 'name_494', 'description_494', CURRENT_TIMESTAMP);
INSERT INTO Transactions (transactions_id, time, 	payment_method, created) VALUES (495, '2018-01-26 19:23:26', 'PayPal', CURRENT_TIMESTAMP);
INSERT INTO Item (item_id, transactions_id, store_id, price, item_type, name, description, created) VALUES (99505.0, 495, 10, 161, 'Health', 'name_495', 'description_495', CURRENT_TIMESTAMP);
INSERT INTO Transactions (transactions_id, time, 	payment_method, created) VALUES (496, '2018-01-11 13:03:21', 'CC', CURRENT_TIMESTAMP);
INSERT INTO Item (item_id, transactions_id, store_id, price, item_type, name, description, created) VALUES (99504.0, 496, 2, 381, 'Books', 'name_496', 'description_496', CURRENT_TIMESTAMP);
INSERT INTO Transactions (transactions_id, time, 	payment_method, created) VALUES (497, '2018-01-24 15:36:19', 'DebitCard', CURRENT_TIMESTAMP);
INSERT INTO Item (item_id, transactions_id, store_id, price, item_type, name, description, created) VALUES (99503.0, 497, 14, 104, 'Electronics', 'name_497', 'description_497', CURRENT_TIMESTAMP);
INSERT INTO Transactions (transactions_id, time, 	payment_method, created) VALUES (498, '2018-02-02 16:46:50', 'CC', CURRENT_TIMESTAMP);
INSERT INTO Item (item_id, transactions_id, store_id, price, item_type, name, description, created) VALUES (99502.0, 498, 6, 254, 'Health', 'name_498', 'description_498', CURRENT_TIMESTAMP);
INSERT INTO Transactions (transactions_id, time, 	payment_method, created) VALUES (499, '2018-01-01 10:50:18', 'PayPal', CURRENT_TIMESTAMP);
INSERT INTO Item (item_id, transactions_id, store_id, price, item_type, name, description, created) VALUES (99501.0, 499, 13, 443, 'Electronics', 'name_499', 'description_499', CURRENT_TIMESTAMP);
INSERT INTO Transactions (transactions_id, time, 	payment_method, created) VALUES (500, '2018-02-02 22:52:45', 'PayPal', CURRENT_TIMESTAMP);
INSERT INTO Item (item_id, transactions_id, store_id, price, item_type, name, description, created) VALUES (99500.0, 500, 3, 465, 'Home', 'name_500', 'description_500', CURRENT_TIMESTAMP);
INSERT INTO Item (item_id, transactions_id, store_id, price, item_type, name, description, created) VALUES (1, 331, 11, 0, 'Books', 'name_1', 'description_1', CURRENT_TIMESTAMP);
INSERT INTO Item (item_id, transactions_id, store_id, price, item_type, name, description, created) VALUES (2, 306, 13, 1, 'Health', 'name_2', 'description_2', CURRENT_TIMESTAMP);
INSERT INTO Item (item_id, transactions_id, store_id, price, item_type, name, description, created) VALUES (3, 117, 13, 1, 'Home', 'name_3', 'description_3', CURRENT_TIMESTAMP);
INSERT INTO Item (item_id, transactions_id, store_id, price, item_type, name, description, created) VALUES (4, 408, 4, 2, 'Home', 'name_4', 'description_4', CURRENT_TIMESTAMP);
INSERT INTO Item (item_id, transactions_id, store_id, price, item_type, name, description, created) VALUES (5, 110, 4, 4, 'Electronics', 'name_5', 'description_5', CURRENT_TIMESTAMP);
INSERT INTO Item (item_id, transactions_id, store_id, price, item_type, name, description, created) VALUES (6, 173, 4, 5, 'Books', 'name_6', 'description_6', CURRENT_TIMESTAMP);
INSERT INTO Item (item_id, transactions_id, store_id, price, item_type, name, description, created) VALUES (7, 246, 8, 4, 'Electronics', 'name_7', 'description_7', CURRENT_TIMESTAMP);
INSERT INTO Item (item_id, transactions_id, store_id, price, item_type, name, description, created) VALUES (8, 262, 12, 6, 'Health', 'name_8', 'description_8', CURRENT_TIMESTAMP);
INSERT INTO Item (item_id, transactions_id, store_id, price, item_type, name, description, created) VALUES (9, 45, 10, 7, 'Toys', 'name_9', 'description_9', CURRENT_TIMESTAMP);
INSERT INTO Item (item_id, transactions_id, store_id, price, item_type, name, description, created) VALUES (10, 213, 7, 2, 'Health', 'name_10', 'description_10', CURRENT_TIMESTAMP);
INSERT INTO Item (item_id, transactions_id, store_id, price, item_type, name, description, created) VALUES (11, 122, 3, 5, 'Home', 'name_11', 'description_11', CURRENT_TIMESTAMP);
INSERT INTO Item (item_id, transactions_id, store_id, price, item_type, name, description, created) VALUES (12, 69, 7, 5, 'Home', 'name_12', 'description_12', CURRENT_TIMESTAMP);
INSERT INTO Item (item_id, transactions_id, store_id, price, item_type, name, description, created) VALUES (13, 353, 8, 7, 'Home', 'name_13', 'description_13', CURRENT_TIMESTAMP);
INSERT INTO Item (item_id, transactions_id, store_id, price, item_type, name, description, created) VALUES (14, 203, 2, 6, 'Health', 'name_14', 'description_14', CURRENT_TIMESTAMP);
INSERT INTO Item (item_id, transactions_id, store_id, price, item_type, name, description, created) VALUES (15, 62, 13, 5, 'Home', 'name_15', 'description_15', CURRENT_TIMESTAMP);
INSERT INTO Item (item_id, transactions_id, store_id, price, item_type, name, description, created) VALUES (16, 469, 8, 4, 'Home', 'name_16', 'description_16', CURRENT_TIMESTAMP);
INSERT INTO Item (item_id, transactions_id, store_id, price, item_type, name, description, created) VALUES (17, 189, 11, 7, 'Home', 'name_17', 'description_17', CURRENT_TIMESTAMP);
INSERT INTO Item (item_id, transactions_id, store_id, price, item_type, name, description, created) VALUES (18, 301, 6, 6, 'Books', 'name_18', 'description_18', CURRENT_TIMESTAMP);
INSERT INTO Item (item_id, transactions_id, store_id, price, item_type, name, description, created) VALUES (19, 271, 4, 10, 'Home', 'name_19', 'description_19', CURRENT_TIMESTAMP);
INSERT INTO Item (item_id, transactions_id, store_id, price, item_type, name, description, created) VALUES (20, 292, 2, 11, 'Health', 'name_20', 'description_20', CURRENT_TIMESTAMP);
INSERT INTO Item (item_id, transactions_id, store_id, price, item_type, name, description, created) VALUES (21, 466, 4, 8, 'Home', 'name_21', 'description_21', CURRENT_TIMESTAMP);
INSERT INTO Item (item_id, transactions_id, store_id, price, item_type, name, description, created) VALUES (22, 477, 2, 5, 'Electronics', 'name_22', 'description_22', CURRENT_TIMESTAMP);
INSERT INTO Item (item_id, transactions_id, store_id, price, item_type, name, description, created) VALUES (23, 119, 10, 9, 'Home', 'name_23', 'description_23', CURRENT_TIMESTAMP);
INSERT INTO Item (item_id, transactions_id, store_id, price, item_type, name, description, created) VALUES (24, 139, 14, 2, 'Health', 'name_24', 'description_24', CURRENT_TIMESTAMP);
INSERT INTO Item (item_id, transactions_id, store_id, price, item_type, name, description, created) VALUES (25, 361, 6, 24, 'Toys', 'name_25', 'description_25', CURRENT_TIMESTAMP);
INSERT INTO Item (item_id, transactions_id, store_id, price, item_type, name, description, created) VALUES (26, 279, 13, 15, 'Electronics', 'name_26', 'description_26', CURRENT_TIMESTAMP);
INSERT INTO Item (item_id, transactions_id, store_id, price, item_type, name, description, created) VALUES (27, 352, 2, 6, 'Home', 'name_27', 'description_27', CURRENT_TIMESTAMP);
INSERT INTO Item (item_id, transactions_id, store_id, price, item_type, name, description, created) VALUES (28, 222, 6, 20, 'Books', 'name_28', 'description_28', CURRENT_TIMESTAMP);
INSERT INTO Item (item_id, transactions_id, store_id, price, item_type, name, description, created) VALUES (29, 3, 12, 11, 'Books', 'name_29', 'description_29', CURRENT_TIMESTAMP);
INSERT INTO Item (item_id, transactions_id, store_id, price, item_type, name, description, created) VALUES (30, 273, 11, 2, 'Electronics', 'name_30', 'description_30', CURRENT_TIMESTAMP);
INSERT INTO Item (item_id, transactions_id, store_id, price, item_type, name, description, created) VALUES (31, 188, 10, 15, 'Health', 'name_31', 'description_31', CURRENT_TIMESTAMP);
INSERT INTO Item (item_id, transactions_id, store_id, price, item_type, name, description, created) VALUES (32, 352, 2, 31, 'Health', 'name_32', 'description_32', CURRENT_TIMESTAMP);
INSERT INTO Item (item_id, transactions_id, store_id, price, item_type, name, description, created) VALUES (33, 145, 2, 18, 'Books', 'name_33', 'description_33', CURRENT_TIMESTAMP);
INSERT INTO Item (item_id, transactions_id, store_id, price, item_type, name, description, created) VALUES (34, 268, 3, 17, 'Books', 'name_34', 'description_34', CURRENT_TIMESTAMP);
INSERT INTO Item (item_id, transactions_id, store_id, price, item_type, name, description, created) VALUES (35, 136, 8, 31, 'Toys', 'name_35', 'description_35', CURRENT_TIMESTAMP);
INSERT INTO Item (item_id, transactions_id, store_id, price, item_type, name, description, created) VALUES (36, 281, 10, 2, 'Toys', 'name_36', 'description_36', CURRENT_TIMESTAMP);
INSERT INTO Item (item_id, transactions_id, store_id, price, item_type, name, description, created) VALUES (37, 437, 1, 32, 'Books', 'name_37', 'description_37', CURRENT_TIMESTAMP);
INSERT INTO Item (item_id, transactions_id, store_id, price, item_type, name, description, created) VALUES (38, 466, 3, 18, 'Books', 'name_38', 'description_38', CURRENT_TIMESTAMP);
INSERT INTO Item (item_id, transactions_id, store_id, price, item_type, name, description, created) VALUES (39, 148, 6, 25, 'Health', 'name_39', 'description_39', CURRENT_TIMESTAMP);
INSERT INTO Item (item_id, transactions_id, store_id, price, item_type, name, description, created) VALUES (40, 9, 11, 4, 'Toys', 'name_40', 'description_40', CURRENT_TIMESTAMP);
INSERT INTO Item (item_id, transactions_id, store_id, price, item_type, name, description, created) VALUES (41, 177, 7, 6, 'Electronics', 'name_41', 'description_41', CURRENT_TIMESTAMP);
INSERT INTO Item (item_id, transactions_id, store_id, price, item_type, name, description, created) VALUES (42, 52, 6, 41, 'Books', 'name_42', 'description_42', CURRENT_TIMESTAMP);
INSERT INTO Item (item_id, transactions_id, store_id, price, item_type, name, description, created) VALUES (43, 171, 4, 23, 'Health', 'name_43', 'description_43', CURRENT_TIMESTAMP);
INSERT INTO Item (item_id, transactions_id, store_id, price, item_type, name, description, created) VALUES (44, 394, 3, 37, 'Home', 'name_44', 'description_44', CURRENT_TIMESTAMP);
INSERT INTO Item (item_id, transactions_id, store_id, price, item_type, name, description, created) VALUES (45, 174, 9, 31, 'Electronics', 'name_45', 'description_45', CURRENT_TIMESTAMP);
INSERT INTO Item (item_id, transactions_id, store_id, price, item_type, name, description, created) VALUES (46, 400, 10, 13, 'Toys', 'name_46', 'description_46', CURRENT_TIMESTAMP);
INSERT INTO Item (item_id, transactions_id, store_id, price, item_type, name, description, created) VALUES (47, 81, 7, 30, 'Toys', 'name_47', 'description_47', CURRENT_TIMESTAMP);
INSERT INTO Item (item_id, transactions_id, store_id, price, item_type, name, description, created) VALUES (48, 492, 2, 36, 'Toys', 'name_48', 'description_48', CURRENT_TIMESTAMP);
INSERT INTO Item (item_id, transactions_id, store_id, price, item_type, name, description, created) VALUES (49, 27, 9, 24, 'Books', 'name_49', 'description_49', CURRENT_TIMESTAMP);
INSERT INTO Item (item_id, transactions_id, store_id, price, item_type, name, description, created) VALUES (50, 238, 8, 20, 'Health', 'name_50', 'description_50', CURRENT_TIMESTAMP);
INSERT INTO Item (item_id, transactions_id, store_id, price, item_type, name, description, created) VALUES (51, 124, 4, 24, 'Home', 'name_51', 'description_51', CURRENT_TIMESTAMP);
INSERT INTO Item (item_id, transactions_id, store_id, price, item_type, name, description, created) VALUES (52, 342, 3, 14, 'Toys', 'name_52', 'description_52', CURRENT_TIMESTAMP);
INSERT INTO Item (item_id, transactions_id, store_id, price, item_type, name, description, created) VALUES (53, 277, 9, 10, 'Books', 'name_53', 'description_53', CURRENT_TIMESTAMP);
INSERT INTO Item (item_id, transactions_id, store_id, price, item_type, name, description, created) VALUES (54, 166, 6, 43, 'Health', 'name_54', 'description_54', CURRENT_TIMESTAMP);
INSERT INTO Item (item_id, transactions_id, store_id, price, item_type, name, description, created) VALUES (55, 223, 14, 30, 'Toys', 'name_55', 'description_55', CURRENT_TIMESTAMP);
INSERT INTO Item (item_id, transactions_id, store_id, price, item_type, name, description, created) VALUES (56, 401, 1, 11, 'Electronics', 'name_56', 'description_56', CURRENT_TIMESTAMP);
INSERT INTO Item (item_id, transactions_id, store_id, price, item_type, name, description, created) VALUES (57, 428, 10, 4, 'Toys', 'name_57', 'description_57', CURRENT_TIMESTAMP);
INSERT INTO Item (item_id, transactions_id, store_id, price, item_type, name, description, created) VALUES (58, 448, 9, 13, 'Health', 'name_58', 'description_58', CURRENT_TIMESTAMP);
INSERT INTO Item (item_id, transactions_id, store_id, price, item_type, name, description, created) VALUES (59, 253, 3, 8, 'Books', 'name_59', 'description_59', CURRENT_TIMESTAMP);
INSERT INTO Item (item_id, transactions_id, store_id, price, item_type, name, description, created) VALUES (60, 438, 10, 9, 'Home', 'name_60', 'description_60', CURRENT_TIMESTAMP);
INSERT INTO Item (item_id, transactions_id, store_id, price, item_type, name, description, created) VALUES (61, 11, 7, 58, 'Electronics', 'name_61', 'description_61', CURRENT_TIMESTAMP);
INSERT INTO Item (item_id, transactions_id, store_id, price, item_type, name, description, created) VALUES (62, 288, 9, 16, 'Toys', 'name_62', 'description_62', CURRENT_TIMESTAMP);
INSERT INTO Item (item_id, transactions_id, store_id, price, item_type, name, description, created) VALUES (63, 498, 12, 6, 'Toys', 'name_63', 'description_63', CURRENT_TIMESTAMP);
INSERT INTO Item (item_id, transactions_id, store_id, price, item_type, name, description, created) VALUES (64, 158, 5, 39, 'Books', 'name_64', 'description_64', CURRENT_TIMESTAMP);
INSERT INTO Item (item_id, transactions_id, store_id, price, item_type, name, description, created) VALUES (65, 26, 5, 44, 'Electronics', 'name_65', 'description_65', CURRENT_TIMESTAMP);
INSERT INTO Item (item_id, transactions_id, store_id, price, item_type, name, description, created) VALUES (66, 415, 8, 66, 'Toys', 'name_66', 'description_66', CURRENT_TIMESTAMP);
INSERT INTO Item (item_id, transactions_id, store_id, price, item_type, name, description, created) VALUES (67, 209, 9, 9, 'Home', 'name_67', 'description_67', CURRENT_TIMESTAMP);
INSERT INTO Item (item_id, transactions_id, store_id, price, item_type, name, description, created) VALUES (68, 292, 14, 18, 'Electronics', 'name_68', 'description_68', CURRENT_TIMESTAMP);
INSERT INTO Item (item_id, transactions_id, store_id, price, item_type, name, description, created) VALUES (69, 311, 14, 65, 'Toys', 'name_69', 'description_69', CURRENT_TIMESTAMP);
INSERT INTO Item (item_id, transactions_id, store_id, price, item_type, name, description, created) VALUES (70, 288, 7, 8, 'Books', 'name_70', 'description_70', CURRENT_TIMESTAMP);
INSERT INTO Item (item_id, transactions_id, store_id, price, item_type, name, description, created) VALUES (71, 249, 13, 46, 'Health', 'name_71', 'description_71', CURRENT_TIMESTAMP);
INSERT INTO Item (item_id, transactions_id, store_id, price, item_type, name, description, created) VALUES (72, 358, 4, 50, 'Electronics', 'name_72', 'description_72', CURRENT_TIMESTAMP);
INSERT INTO Item (item_id, transactions_id, store_id, price, item_type, name, description, created) VALUES (73, 120, 14, 51, 'Toys', 'name_73', 'description_73', CURRENT_TIMESTAMP);
INSERT INTO Item (item_id, transactions_id, store_id, price, item_type, name, description, created) VALUES (74, 344, 7, 14, 'Books', 'name_74', 'description_74', CURRENT_TIMESTAMP);
INSERT INTO Item (item_id, transactions_id, store_id, price, item_type, name, description, created) VALUES (75, 86, 2, 20, 'Home', 'name_75', 'description_75', CURRENT_TIMESTAMP);
INSERT INTO Item (item_id, transactions_id, store_id, price, item_type, name, description, created) VALUES (76, 374, 3, 7, 'Toys', 'name_76', 'description_76', CURRENT_TIMESTAMP);
INSERT INTO Item (item_id, transactions_id, store_id, price, item_type, name, description, created) VALUES (77, 121, 14, 55, 'Toys', 'name_77', 'description_77', CURRENT_TIMESTAMP);
INSERT INTO Item (item_id, transactions_id, store_id, price, item_type, name, description, created) VALUES (78, 15, 13, 41, 'Books', 'name_78', 'description_78', CURRENT_TIMESTAMP);
INSERT INTO Item (item_id, transactions_id, store_id, price, item_type, name, description, created) VALUES (79, 122, 5, 36, 'Books', 'name_79', 'description_79', CURRENT_TIMESTAMP);
INSERT INTO Item (item_id, transactions_id, store_id, price, item_type, name, description, created) VALUES (80, 152, 8, 49, 'Electronics', 'name_80', 'description_80', CURRENT_TIMESTAMP);
INSERT INTO Item (item_id, transactions_id, store_id, price, item_type, name, description, created) VALUES (81, 140, 2, 77, 'Home', 'name_81', 'description_81', CURRENT_TIMESTAMP);
INSERT INTO Item (item_id, transactions_id, store_id, price, item_type, name, description, created) VALUES (82, 263, 13, 26, 'Toys', 'name_82', 'description_82', CURRENT_TIMESTAMP);
INSERT INTO Item (item_id, transactions_id, store_id, price, item_type, name, description, created) VALUES (83, 416, 8, 16, 'Books', 'name_83', 'description_83', CURRENT_TIMESTAMP);
INSERT INTO Item (item_id, transactions_id, store_id, price, item_type, name, description, created) VALUES (84, 422, 6, 63, 'Health', 'name_84', 'description_84', CURRENT_TIMESTAMP);
INSERT INTO Item (item_id, transactions_id, store_id, price, item_type, name, description, created) VALUES (85, 369, 9, 74, 'Home', 'name_85', 'description_85', CURRENT_TIMESTAMP);
INSERT INTO Item (item_id, transactions_id, store_id, price, item_type, name, description, created) VALUES (86, 2, 8, 76, 'Electronics', 'name_86', 'description_86', CURRENT_TIMESTAMP);
INSERT INTO Item (item_id, transactions_id, store_id, price, item_type, name, description, created) VALUES (87, 373, 13, 81, 'Books', 'name_87', 'description_87', CURRENT_TIMESTAMP);
INSERT INTO Item (item_id, transactions_id, store_id, price, item_type, name, description, created) VALUES (88, 127, 13, 15, 'Toys', 'name_88', 'description_88', CURRENT_TIMESTAMP);
INSERT INTO Item (item_id, transactions_id, store_id, price, item_type, name, description, created) VALUES (89, 419, 14, 80, 'Electronics', 'name_89', 'description_89', CURRENT_TIMESTAMP);
INSERT INTO Item (item_id, transactions_id, store_id, price, item_type, name, description, created) VALUES (90, 163, 4, 81, 'Home', 'name_90', 'description_90', CURRENT_TIMESTAMP);
INSERT INTO Item (item_id, transactions_id, store_id, price, item_type, name, description, created) VALUES (91, 223, 4, 39, 'Health', 'name_91', 'description_91', CURRENT_TIMESTAMP);
INSERT INTO Item (item_id, transactions_id, store_id, price, item_type, name, description, created) VALUES (92, 145, 8, 19, 'Home', 'name_92', 'description_92', CURRENT_TIMESTAMP);
INSERT INTO Item (item_id, transactions_id, store_id, price, item_type, name, description, created) VALUES (93, 244, 3, 11, 'Books', 'name_93', 'description_93', CURRENT_TIMESTAMP);
INSERT INTO Item (item_id, transactions_id, store_id, price, item_type, name, description, created) VALUES (94, 50, 3, 20, 'Books', 'name_94', 'description_94', CURRENT_TIMESTAMP);
INSERT INTO Item (item_id, transactions_id, store_id, price, item_type, name, description, created) VALUES (95, 402, 8, 51, 'Toys', 'name_95', 'description_95', CURRENT_TIMESTAMP);
INSERT INTO Item (item_id, transactions_id, store_id, price, item_type, name, description, created) VALUES (96, 197, 2, 58, 'Books', 'name_96', 'description_96', CURRENT_TIMESTAMP);
INSERT INTO Item (item_id, transactions_id, store_id, price, item_type, name, description, created) VALUES (97, 423, 9, 33, 'Health', 'name_97', 'description_97', CURRENT_TIMESTAMP);
INSERT INTO Item (item_id, transactions_id, store_id, price, item_type, name, description, created) VALUES (98, 25, 2, 68, 'Books', 'name_98', 'description_98', CURRENT_TIMESTAMP);
INSERT INTO Item (item_id, transactions_id, store_id, price, item_type, name, description, created) VALUES (99, 422, 5, 66, 'Home', 'name_99', 'description_99', CURRENT_TIMESTAMP);
INSERT INTO Item (item_id, transactions_id, store_id, price, item_type, name, description, created) VALUES (100, 364, 6, 19, 'Books', 'name_100', 'description_100', CURRENT_TIMESTAMP);
INSERT INTO Item (item_id, transactions_id, store_id, price, item_type, name, description, created) VALUES (101, 51, 7, 84, 'Home', 'name_101', 'description_101', CURRENT_TIMESTAMP);
INSERT INTO Item (item_id, transactions_id, store_id, price, item_type, name, description, created) VALUES (102, 249, 3, 102, 'Health', 'name_102', 'description_102', CURRENT_TIMESTAMP);
INSERT INTO Item (item_id, transactions_id, store_id, price, item_type, name, description, created) VALUES (103, 283, 12, 0, 'Home', 'name_103', 'description_103', CURRENT_TIMESTAMP);
INSERT INTO Item (item_id, transactions_id, store_id, price, item_type, name, description, created) VALUES (104, 197, 6, 78, 'Electronics', 'name_104', 'description_104', CURRENT_TIMESTAMP);
INSERT INTO Item (item_id, transactions_id, store_id, price, item_type, name, description, created) VALUES (105, 66, 3, 27, 'Health', 'name_105', 'description_105', CURRENT_TIMESTAMP);
INSERT INTO Item (item_id, transactions_id, store_id, price, item_type, name, description, created) VALUES (106, 52, 12, 17, 'Electronics', 'name_106', 'description_106', CURRENT_TIMESTAMP);
INSERT INTO Item (item_id, transactions_id, store_id, price, item_type, name, description, created) VALUES (107, 331, 2, 85, 'Health', 'name_107', 'description_107', CURRENT_TIMESTAMP);
INSERT INTO Item (item_id, transactions_id, store_id, price, item_type, name, description, created) VALUES (108, 492, 9, 40, 'Toys', 'name_108', 'description_108', CURRENT_TIMESTAMP);
INSERT INTO Item (item_id, transactions_id, store_id, price, item_type, name, description, created) VALUES (109, 88, 1, 98, 'Toys', 'name_109', 'description_109', CURRENT_TIMESTAMP);
INSERT INTO Item (item_id, transactions_id, store_id, price, item_type, name, description, created) VALUES (110, 66, 11, 2, 'Home', 'name_110', 'description_110', CURRENT_TIMESTAMP);
INSERT INTO Item (item_id, transactions_id, store_id, price, item_type, name, description, created) VALUES (111, 101, 12, 45, 'Home', 'name_111', 'description_111', CURRENT_TIMESTAMP);
INSERT INTO Item (item_id, transactions_id, store_id, price, item_type, name, description, created) VALUES (112, 347, 14, 12, 'Home', 'name_112', 'description_112', CURRENT_TIMESTAMP);
INSERT INTO Item (item_id, transactions_id, store_id, price, item_type, name, description, created) VALUES (113, 421, 14, 69, 'Health', 'name_113', 'description_113', CURRENT_TIMESTAMP);
INSERT INTO Item (item_id, transactions_id, store_id, price, item_type, name, description, created) VALUES (114, 372, 7, 47, 'Health', 'name_114', 'description_114', CURRENT_TIMESTAMP);
INSERT INTO Item (item_id, transactions_id, store_id, price, item_type, name, description, created) VALUES (115, 356, 12, 37, 'Books', 'name_115', 'description_115', CURRENT_TIMESTAMP);
INSERT INTO Item (item_id, transactions_id, store_id, price, item_type, name, description, created) VALUES (116, 470, 6, 96, 'Toys', 'name_116', 'description_116', CURRENT_TIMESTAMP);
INSERT INTO Item (item_id, transactions_id, store_id, price, item_type, name, description, created) VALUES (117, 102, 14, 11, 'Home', 'name_117', 'description_117', CURRENT_TIMESTAMP);
INSERT INTO Item (item_id, transactions_id, store_id, price, item_type, name, description, created) VALUES (118, 205, 3, 41, 'Toys', 'name_118', 'description_118', CURRENT_TIMESTAMP);
INSERT INTO Item (item_id, transactions_id, store_id, price, item_type, name, description, created) VALUES (119, 39, 1, 111, 'Electronics', 'name_119', 'description_119', CURRENT_TIMESTAMP);
INSERT INTO Item (item_id, transactions_id, store_id, price, item_type, name, description, created) VALUES (120, 190, 7, 10, 'Home', 'name_120', 'description_120', CURRENT_TIMESTAMP);
INSERT INTO Item (item_id, transactions_id, store_id, price, item_type, name, description, created) VALUES (121, 396, 3, 71, 'Books', 'name_121', 'description_121', CURRENT_TIMESTAMP);
INSERT INTO Item (item_id, transactions_id, store_id, price, item_type, name, description, created) VALUES (122, 335, 10, 17, 'Books', 'name_122', 'description_122', CURRENT_TIMESTAMP);
INSERT INTO Item (item_id, transactions_id, store_id, price, item_type, name, description, created) VALUES (123, 95, 6, 54, 'Books', 'name_123', 'description_123', CURRENT_TIMESTAMP);
INSERT INTO Item (item_id, transactions_id, store_id, price, item_type, name, description, created) VALUES (124, 80, 4, 57, 'Health', 'name_124', 'description_124', CURRENT_TIMESTAMP);
INSERT INTO Item (item_id, transactions_id, store_id, price, item_type, name, description, created) VALUES (125, 32, 8, 21, 'Books', 'name_125', 'description_125', CURRENT_TIMESTAMP);
INSERT INTO Item (item_id, transactions_id, store_id, price, item_type, name, description, created) VALUES (126, 63, 8, 91, 'Home', 'name_126', 'description_126', CURRENT_TIMESTAMP);
INSERT INTO Item (item_id, transactions_id, store_id, price, item_type, name, description, created) VALUES (127, 261, 1, 31, 'Toys', 'name_127', 'description_127', CURRENT_TIMESTAMP);
INSERT INTO Item (item_id, transactions_id, store_id, price, item_type, name, description, created) VALUES (128, 165, 6, 41, 'Toys', 'name_128', 'description_128', CURRENT_TIMESTAMP);
INSERT INTO Item (item_id, transactions_id, store_id, price, item_type, name, description, created) VALUES (129, 109, 6, 50, 'Electronics', 'name_129', 'description_129', CURRENT_TIMESTAMP);
INSERT INTO Item (item_id, transactions_id, store_id, price, item_type, name, description, created) VALUES (130, 258, 1, 9, 'Electronics', 'name_130', 'description_130', CURRENT_TIMESTAMP);
INSERT INTO Item (item_id, transactions_id, store_id, price, item_type, name, description, created) VALUES (131, 499, 8, 24, 'Electronics', 'name_131', 'description_131', CURRENT_TIMESTAMP);
INSERT INTO Item (item_id, transactions_id, store_id, price, item_type, name, description, created) VALUES (132, 486, 1, 132, 'Health', 'name_132', 'description_132', CURRENT_TIMESTAMP);
INSERT INTO Item (item_id, transactions_id, store_id, price, item_type, name, description, created) VALUES (133, 95, 11, 100, 'Home', 'name_133', 'description_133', CURRENT_TIMESTAMP);
INSERT INTO Item (item_id, transactions_id, store_id, price, item_type, name, description, created) VALUES (134, 359, 4, 46, 'Books', 'name_134', 'description_134', CURRENT_TIMESTAMP);
INSERT INTO Item (item_id, transactions_id, store_id, price, item_type, name, description, created) VALUES (135, 80, 6, 9, 'Health', 'name_135', 'description_135', CURRENT_TIMESTAMP);
INSERT INTO Item (item_id, transactions_id, store_id, price, item_type, name, description, created) VALUES (136, 71, 4, 102, 'Health', 'name_136', 'description_136', CURRENT_TIMESTAMP);
INSERT INTO Item (item_id, transactions_id, store_id, price, item_type, name, description, created) VALUES (137, 362, 6, 127, 'Electronics', 'name_137', 'description_137', CURRENT_TIMESTAMP);
INSERT INTO Item (item_id, transactions_id, store_id, price, item_type, name, description, created) VALUES (138, 152, 7, 110, 'Books', 'name_138', 'description_138', CURRENT_TIMESTAMP);
INSERT INTO Item (item_id, transactions_id, store_id, price, item_type, name, description, created) VALUES (139, 425, 11, 35, 'Toys', 'name_139', 'description_139', CURRENT_TIMESTAMP);
INSERT INTO Item (item_id, transactions_id, store_id, price, item_type, name, description, created) VALUES (140, 254, 13, 135, 'Health', 'name_140', 'description_140', CURRENT_TIMESTAMP);
INSERT INTO Item (item_id, transactions_id, store_id, price, item_type, name, description, created) VALUES (141, 167, 13, 105, 'Toys', 'name_141', 'description_141', CURRENT_TIMESTAMP);
INSERT INTO Item (item_id, transactions_id, store_id, price, item_type, name, description, created) VALUES (142, 172, 11, 65, 'Health', 'name_142', 'description_142', CURRENT_TIMESTAMP);
INSERT INTO Item (item_id, transactions_id, store_id, price, item_type, name, description, created) VALUES (143, 38, 7, 124, 'Home', 'name_143', 'description_143', CURRENT_TIMESTAMP);
INSERT INTO Item (item_id, transactions_id, store_id, price, item_type, name, description, created) VALUES (144, 479, 4, 121, 'Books', 'name_144', 'description_144', CURRENT_TIMESTAMP);
INSERT INTO Item (item_id, transactions_id, store_id, price, item_type, name, description, created) VALUES (145, 113, 6, 21, 'Home', 'name_145', 'description_145', CURRENT_TIMESTAMP);
INSERT INTO Item (item_id, transactions_id, store_id, price, item_type, name, description, created) VALUES (146, 184, 8, 127, 'Health', 'name_146', 'description_146', CURRENT_TIMESTAMP);
INSERT INTO Item (item_id, transactions_id, store_id, price, item_type, name, description, created) VALUES (147, 359, 11, 38, 'Home', 'name_147', 'description_147', CURRENT_TIMESTAMP);
INSERT INTO Item (item_id, transactions_id, store_id, price, item_type, name, description, created) VALUES (148, 127, 7, 109, 'Books', 'name_148', 'description_148', CURRENT_TIMESTAMP);
INSERT INTO Item (item_id, transactions_id, store_id, price, item_type, name, description, created) VALUES (149, 296, 1, 132, 'Books', 'name_149', 'description_149', CURRENT_TIMESTAMP);
INSERT INTO Item (item_id, transactions_id, store_id, price, item_type, name, description, created) VALUES (150, 109, 12, 127, 'Books', 'name_150', 'description_150', CURRENT_TIMESTAMP);
INSERT INTO Item (item_id, transactions_id, store_id, price, item_type, name, description, created) VALUES (151, 267, 10, 34, 'Toys', 'name_151', 'description_151', CURRENT_TIMESTAMP);
INSERT INTO Item (item_id, transactions_id, store_id, price, item_type, name, description, created) VALUES (152, 67, 14, 152, 'Health', 'name_152', 'description_152', CURRENT_TIMESTAMP);
INSERT INTO Item (item_id, transactions_id, store_id, price, item_type, name, description, created) VALUES (153, 234, 14, 59, 'Health', 'name_153', 'description_153', CURRENT_TIMESTAMP);
INSERT INTO Item (item_id, transactions_id, store_id, price, item_type, name, description, created) VALUES (154, 289, 14, 107, 'Electronics', 'name_154', 'description_154', CURRENT_TIMESTAMP);
INSERT INTO Item (item_id, transactions_id, store_id, price, item_type, name, description, created) VALUES (155, 438, 6, 14, 'Health', 'name_155', 'description_155', CURRENT_TIMESTAMP);
INSERT INTO Item (item_id, transactions_id, store_id, price, item_type, name, description, created) VALUES (156, 350, 2, 121, 'Health', 'name_156', 'description_156', CURRENT_TIMESTAMP);
INSERT INTO Item (item_id, transactions_id, store_id, price, item_type, name, description, created) VALUES (157, 223, 8, 157, 'Electronics', 'name_157', 'description_157', CURRENT_TIMESTAMP);
INSERT INTO Item (item_id, transactions_id, store_id, price, item_type, name, description, created) VALUES (158, 246, 14, 94, 'Toys', 'name_158', 'description_158', CURRENT_TIMESTAMP);
INSERT INTO Item (item_id, transactions_id, store_id, price, item_type, name, description, created) VALUES (159, 66, 1, 144, 'Books', 'name_159', 'description_159', CURRENT_TIMESTAMP);
INSERT INTO Item (item_id, transactions_id, store_id, price, item_type, name, description, created) VALUES (160, 33, 3, 122, 'Books', 'name_160', 'description_160', CURRENT_TIMESTAMP);
INSERT INTO Item (item_id, transactions_id, store_id, price, item_type, name, description, created) VALUES (161, 117, 9, 143, 'Books', 'name_161', 'description_161', CURRENT_TIMESTAMP);
INSERT INTO Item (item_id, transactions_id, store_id, price, item_type, name, description, created) VALUES (162, 291, 13, 160, 'Home', 'name_162', 'description_162', CURRENT_TIMESTAMP);
INSERT INTO Item (item_id, transactions_id, store_id, price, item_type, name, description, created) VALUES (163, 424, 12, 62, 'Electronics', 'name_163', 'description_163', CURRENT_TIMESTAMP);
INSERT INTO Item (item_id, transactions_id, store_id, price, item_type, name, description, created) VALUES (164, 1, 7, 100, 'Books', 'name_164', 'description_164', CURRENT_TIMESTAMP);
INSERT INTO Item (item_id, transactions_id, store_id, price, item_type, name, description, created) VALUES (165, 200, 14, 112, 'Home', 'name_165', 'description_165', CURRENT_TIMESTAMP);
INSERT INTO Item (item_id, transactions_id, store_id, price, item_type, name, description, created) VALUES (166, 203, 3, 110, 'Home', 'name_166', 'description_166', CURRENT_TIMESTAMP);
INSERT INTO Item (item_id, transactions_id, store_id, price, item_type, name, description, created) VALUES (167, 13, 2, 90, 'Home', 'name_167', 'description_167', CURRENT_TIMESTAMP);
INSERT INTO Item (item_id, transactions_id, store_id, price, item_type, name, description, created) VALUES (168, 173, 14, 151, 'Health', 'name_168', 'description_168', CURRENT_TIMESTAMP);
INSERT INTO Item (item_id, transactions_id, store_id, price, item_type, name, description, created) VALUES (169, 449, 6, 19, 'Books', 'name_169', 'description_169', CURRENT_TIMESTAMP);
INSERT INTO Item (item_id, transactions_id, store_id, price, item_type, name, description, created) VALUES (170, 68, 9, 76, 'Health', 'name_170', 'description_170', CURRENT_TIMESTAMP);
INSERT INTO Item (item_id, transactions_id, store_id, price, item_type, name, description, created) VALUES (171, 440, 1, 99, 'Home', 'name_171', 'description_171', CURRENT_TIMESTAMP);
INSERT INTO Item (item_id, transactions_id, store_id, price, item_type, name, description, created) VALUES (172, 176, 7, 156, 'Home', 'name_172', 'description_172', CURRENT_TIMESTAMP);
INSERT INTO Item (item_id, transactions_id, store_id, price, item_type, name, description, created) VALUES (173, 230, 9, 53, 'Books', 'name_173', 'description_173', CURRENT_TIMESTAMP);
INSERT INTO Item (item_id, transactions_id, store_id, price, item_type, name, description, created) VALUES (174, 481, 5, 134, 'Electronics', 'name_174', 'description_174', CURRENT_TIMESTAMP);
INSERT INTO Item (item_id, transactions_id, store_id, price, item_type, name, description, created) VALUES (175, 337, 11, 102, 'Health', 'name_175', 'description_175', CURRENT_TIMESTAMP);
INSERT INTO Item (item_id, transactions_id, store_id, price, item_type, name, description, created) VALUES (176, 317, 11, 103, 'Home', 'name_176', 'description_176', CURRENT_TIMESTAMP);
INSERT INTO Item (item_id, transactions_id, store_id, price, item_type, name, description, created) VALUES (177, 500, 5, 114, 'Health', 'name_177', 'description_177', CURRENT_TIMESTAMP);
INSERT INTO Item (item_id, transactions_id, store_id, price, item_type, name, description, created) VALUES (178, 400, 12, 100, 'Books', 'name_178', 'description_178', CURRENT_TIMESTAMP);
INSERT INTO Item (item_id, transactions_id, store_id, price, item_type, name, description, created) VALUES (179, 226, 5, 121, 'Health', 'name_179', 'description_179', CURRENT_TIMESTAMP);
INSERT INTO Item (item_id, transactions_id, store_id, price, item_type, name, description, created) VALUES (180, 255, 10, 178, 'Health', 'name_180', 'description_180', CURRENT_TIMESTAMP);
INSERT INTO Item (item_id, transactions_id, store_id, price, item_type, name, description, created) VALUES (181, 35, 10, 123, 'Health', 'name_181', 'description_181', CURRENT_TIMESTAMP);
INSERT INTO Item (item_id, transactions_id, store_id, price, item_type, name, description, created) VALUES (182, 304, 14, 6, 'Home', 'name_182', 'description_182', CURRENT_TIMESTAMP);
INSERT INTO Item (item_id, transactions_id, store_id, price, item_type, name, description, created) VALUES (183, 336, 5, 111, 'Books', 'name_183', 'description_183', CURRENT_TIMESTAMP);
INSERT INTO Item (item_id, transactions_id, store_id, price, item_type, name, description, created) VALUES (184, 426, 14, 163, 'Home', 'name_184', 'description_184', CURRENT_TIMESTAMP);
INSERT INTO Item (item_id, transactions_id, store_id, price, item_type, name, description, created) VALUES (185, 415, 9, 105, 'Electronics', 'name_185', 'description_185', CURRENT_TIMESTAMP);
INSERT INTO Item (item_id, transactions_id, store_id, price, item_type, name, description, created) VALUES (186, 212, 14, 133, 'Toys', 'name_186', 'description_186', CURRENT_TIMESTAMP);
INSERT INTO Item (item_id, transactions_id, store_id, price, item_type, name, description, created) VALUES (187, 181, 7, 22, 'Books', 'name_187', 'description_187', CURRENT_TIMESTAMP);
INSERT INTO Item (item_id, transactions_id, store_id, price, item_type, name, description, created) VALUES (188, 20, 10, 86, 'Books', 'name_188', 'description_188', CURRENT_TIMESTAMP);
INSERT INTO Item (item_id, transactions_id, store_id, price, item_type, name, description, created) VALUES (189, 358, 12, 32, 'Electronics', 'name_189', 'description_189', CURRENT_TIMESTAMP);
INSERT INTO Item (item_id, transactions_id, store_id, price, item_type, name, description, created) VALUES (190, 408, 6, 77, 'Home', 'name_190', 'description_190', CURRENT_TIMESTAMP);
INSERT INTO Item (item_id, transactions_id, store_id, price, item_type, name, description, created) VALUES (191, 64, 14, 40, 'Health', 'name_191', 'description_191', CURRENT_TIMESTAMP);
INSERT INTO Item (item_id, transactions_id, store_id, price, item_type, name, description, created) VALUES (192, 362, 8, 156, 'Books', 'name_192', 'description_192', CURRENT_TIMESTAMP);
INSERT INTO Item (item_id, transactions_id, store_id, price, item_type, name, description, created) VALUES (193, 88, 1, 129, 'Toys', 'name_193', 'description_193', CURRENT_TIMESTAMP);
INSERT INTO Item (item_id, transactions_id, store_id, price, item_type, name, description, created) VALUES (194, 171, 13, 8, 'Home', 'name_194', 'description_194', CURRENT_TIMESTAMP);
INSERT INTO Item (item_id, transactions_id, store_id, price, item_type, name, description, created) VALUES (195, 197, 6, 169, 'Books', 'name_195', 'description_195', CURRENT_TIMESTAMP);
INSERT INTO Item (item_id, transactions_id, store_id, price, item_type, name, description, created) VALUES (196, 109, 13, 191, 'Electronics', 'name_196', 'description_196', CURRENT_TIMESTAMP);
INSERT INTO Item (item_id, transactions_id, store_id, price, item_type, name, description, created) VALUES (197, 407, 6, 161, 'Toys', 'name_197', 'description_197', CURRENT_TIMESTAMP);
INSERT INTO Item (item_id, transactions_id, store_id, price, item_type, name, description, created) VALUES (198, 203, 2, 97, 'Health', 'name_198', 'description_198', CURRENT_TIMESTAMP);
INSERT INTO Item (item_id, transactions_id, store_id, price, item_type, name, description, created) VALUES (199, 16, 13, 60, 'Toys', 'name_199', 'description_199', CURRENT_TIMESTAMP);
INSERT INTO Item (item_id, transactions_id, store_id, price, item_type, name, description, created) VALUES (200, 136, 14, 56, 'Home', 'name_200', 'description_200', CURRENT_TIMESTAMP);
INSERT INTO Item (item_id, transactions_id, store_id, price, item_type, name, description, created) VALUES (201, 66, 8, 125, 'Books', 'name_201', 'description_201', CURRENT_TIMESTAMP);
INSERT INTO Item (item_id, transactions_id, store_id, price, item_type, name, description, created) VALUES (202, 290, 6, 195, 'Books', 'name_202', 'description_202', CURRENT_TIMESTAMP);
INSERT INTO Item (item_id, transactions_id, store_id, price, item_type, name, description, created) VALUES (203, 103, 14, 189, 'Health', 'name_203', 'description_203', CURRENT_TIMESTAMP);
INSERT INTO Item (item_id, transactions_id, store_id, price, item_type, name, description, created) VALUES (204, 383, 3, 108, 'Toys', 'name_204', 'description_204', CURRENT_TIMESTAMP);
INSERT INTO Item (item_id, transactions_id, store_id, price, item_type, name, description, created) VALUES (205, 494, 10, 22, 'Toys', 'name_205', 'description_205', CURRENT_TIMESTAMP);
INSERT INTO Item (item_id, transactions_id, store_id, price, item_type, name, description, created) VALUES (206, 34, 4, 35, 'Health', 'name_206', 'description_206', CURRENT_TIMESTAMP);
INSERT INTO Item (item_id, transactions_id, store_id, price, item_type, name, description, created) VALUES (207, 41, 13, 139, 'Home', 'name_207', 'description_207', CURRENT_TIMESTAMP);
INSERT INTO Item (item_id, transactions_id, store_id, price, item_type, name, description, created) VALUES (208, 33, 7, 100, 'Electronics', 'name_208', 'description_208', CURRENT_TIMESTAMP);
INSERT INTO Item (item_id, transactions_id, store_id, price, item_type, name, description, created) VALUES (209, 192, 14, 112, 'Toys', 'name_209', 'description_209', CURRENT_TIMESTAMP);
INSERT INTO Item (item_id, transactions_id, store_id, price, item_type, name, description, created) VALUES (210, 12, 10, 119, 'Health', 'name_210', 'description_210', CURRENT_TIMESTAMP);
INSERT INTO Item (item_id, transactions_id, store_id, price, item_type, name, description, created) VALUES (211, 166, 8, 38, 'Home', 'name_211', 'description_211', CURRENT_TIMESTAMP);
INSERT INTO Item (item_id, transactions_id, store_id, price, item_type, name, description, created) VALUES (212, 73, 3, 199, 'Toys', 'name_212', 'description_212', CURRENT_TIMESTAMP);
INSERT INTO Item (item_id, transactions_id, store_id, price, item_type, name, description, created) VALUES (213, 6, 9, 96, 'Electronics', 'name_213', 'description_213', CURRENT_TIMESTAMP);
INSERT INTO Item (item_id, transactions_id, store_id, price, item_type, name, description, created) VALUES (214, 327, 1, 118, 'Books', 'name_214', 'description_214', CURRENT_TIMESTAMP);
INSERT INTO Item (item_id, transactions_id, store_id, price, item_type, name, description, created) VALUES (215, 271, 1, 99, 'Home', 'name_215', 'description_215', CURRENT_TIMESTAMP);
INSERT INTO Item (item_id, transactions_id, store_id, price, item_type, name, description, created) VALUES (216, 449, 8, 101, 'Books', 'name_216', 'description_216', CURRENT_TIMESTAMP);
INSERT INTO Item (item_id, transactions_id, store_id, price, item_type, name, description, created) VALUES (217, 471, 5, 31, 'Health', 'name_217', 'description_217', CURRENT_TIMESTAMP);
INSERT INTO Item (item_id, transactions_id, store_id, price, item_type, name, description, created) VALUES (218, 386, 4, 179, 'Electronics', 'name_218', 'description_218', CURRENT_TIMESTAMP);
INSERT INTO Item (item_id, transactions_id, store_id, price, item_type, name, description, created) VALUES (219, 172, 8, 50, 'Health', 'name_219', 'description_219', CURRENT_TIMESTAMP);
INSERT INTO Item (item_id, transactions_id, store_id, price, item_type, name, description, created) VALUES (220, 247, 2, 142, 'Toys', 'name_220', 'description_220', CURRENT_TIMESTAMP);
INSERT INTO Item (item_id, transactions_id, store_id, price, item_type, name, description, created) VALUES (221, 219, 2, 92, 'Health', 'name_221', 'description_221', CURRENT_TIMESTAMP);
INSERT INTO Item (item_id, transactions_id, store_id, price, item_type, name, description, created) VALUES (222, 56, 9, 24, 'Health', 'name_222', 'description_222', CURRENT_TIMESTAMP);
INSERT INTO Item (item_id, transactions_id, store_id, price, item_type, name, description, created) VALUES (223, 244, 4, 112, 'Books', 'name_223', 'description_223', CURRENT_TIMESTAMP);
INSERT INTO Item (item_id, transactions_id, store_id, price, item_type, name, description, created) VALUES (224, 143, 10, 24, 'Health', 'name_224', 'description_224', CURRENT_TIMESTAMP);
INSERT INTO Item (item_id, transactions_id, store_id, price, item_type, name, description, created) VALUES (225, 286, 9, 170, 'Toys', 'name_225', 'description_225', CURRENT_TIMESTAMP);
INSERT INTO Item (item_id, transactions_id, store_id, price, item_type, name, description, created) VALUES (226, 147, 7, 15, 'Toys', 'name_226', 'description_226', CURRENT_TIMESTAMP);
INSERT INTO Item (item_id, transactions_id, store_id, price, item_type, name, description, created) VALUES (227, 403, 6, 38, 'Electronics', 'name_227', 'description_227', CURRENT_TIMESTAMP);
INSERT INTO Item (item_id, transactions_id, store_id, price, item_type, name, description, created) VALUES (228, 395, 6, 43, 'Books', 'name_228', 'description_228', CURRENT_TIMESTAMP);
INSERT INTO Item (item_id, transactions_id, store_id, price, item_type, name, description, created) VALUES (229, 276, 7, 209, 'Health', 'name_229', 'description_229', CURRENT_TIMESTAMP);
INSERT INTO Item (item_id, transactions_id, store_id, price, item_type, name, description, created) VALUES (230, 165, 13, 181, 'Home', 'name_230', 'description_230', CURRENT_TIMESTAMP);
INSERT INTO Item (item_id, transactions_id, store_id, price, item_type, name, description, created) VALUES (231, 440, 8, 134, 'Health', 'name_231', 'description_231', CURRENT_TIMESTAMP);
INSERT INTO Item (item_id, transactions_id, store_id, price, item_type, name, description, created) VALUES (232, 340, 14, 181, 'Electronics', 'name_232', 'description_232', CURRENT_TIMESTAMP);
INSERT INTO Item (item_id, transactions_id, store_id, price, item_type, name, description, created) VALUES (233, 47, 8, 174, 'Books', 'name_233', 'description_233', CURRENT_TIMESTAMP);
INSERT INTO Item (item_id, transactions_id, store_id, price, item_type, name, description, created) VALUES (234, 280, 2, 51, 'Health', 'name_234', 'description_234', CURRENT_TIMESTAMP);
INSERT INTO Item (item_id, transactions_id, store_id, price, item_type, name, description, created) VALUES (235, 25, 11, 218, 'Toys', 'name_235', 'description_235', CURRENT_TIMESTAMP);
INSERT INTO Item (item_id, transactions_id, store_id, price, item_type, name, description, created) VALUES (236, 496, 3, 169, 'Health', 'name_236', 'description_236', CURRENT_TIMESTAMP);
INSERT INTO Item (item_id, transactions_id, store_id, price, item_type, name, description, created) VALUES (237, 21, 8, 162, 'Books', 'name_237', 'description_237', CURRENT_TIMESTAMP);
INSERT INTO Item (item_id, transactions_id, store_id, price, item_type, name, description, created) VALUES (238, 450, 11, 57, 'Toys', 'name_238', 'description_238', CURRENT_TIMESTAMP);
INSERT INTO Item (item_id, transactions_id, store_id, price, item_type, name, description, created) VALUES (239, 23, 8, 182, 'Toys', 'name_239', 'description_239', CURRENT_TIMESTAMP);
INSERT INTO Item (item_id, transactions_id, store_id, price, item_type, name, description, created) VALUES (240, 153, 2, 142, 'Electronics', 'name_240', 'description_240', CURRENT_TIMESTAMP);
INSERT INTO Item (item_id, transactions_id, store_id, price, item_type, name, description, created) VALUES (241, 368, 11, 180, 'Health', 'name_241', 'description_241', CURRENT_TIMESTAMP);
INSERT INTO Item (item_id, transactions_id, store_id, price, item_type, name, description, created) VALUES (242, 330, 8, 173, 'Health', 'name_242', 'description_242', CURRENT_TIMESTAMP);
INSERT INTO Item (item_id, transactions_id, store_id, price, item_type, name, description, created) VALUES (243, 202, 12, 165, 'Health', 'name_243', 'description_243', CURRENT_TIMESTAMP);
INSERT INTO Item (item_id, transactions_id, store_id, price, item_type, name, description, created) VALUES (244, 461, 3, 99, 'Health', 'name_244', 'description_244', CURRENT_TIMESTAMP);
INSERT INTO Item (item_id, transactions_id, store_id, price, item_type, name, description, created) VALUES (245, 276, 14, 120, 'Books', 'name_245', 'description_245', CURRENT_TIMESTAMP);
INSERT INTO Item (item_id, transactions_id, store_id, price, item_type, name, description, created) VALUES (246, 238, 8, 92, 'Home', 'name_246', 'description_246', CURRENT_TIMESTAMP);
INSERT INTO Item (item_id, transactions_id, store_id, price, item_type, name, description, created) VALUES (247, 56, 13, 219, 'Books', 'name_247', 'description_247', CURRENT_TIMESTAMP);
INSERT INTO Item (item_id, transactions_id, store_id, price, item_type, name, description, created) VALUES (248, 186, 9, 239, 'Health', 'name_248', 'description_248', CURRENT_TIMESTAMP);
INSERT INTO Item (item_id, transactions_id, store_id, price, item_type, name, description, created) VALUES (249, 228, 10, 176, 'Books', 'name_249', 'description_249', CURRENT_TIMESTAMP);
INSERT INTO Item (item_id, transactions_id, store_id, price, item_type, name, description, created) VALUES (250, 52, 12, 38, 'Books', 'name_250', 'description_250', CURRENT_TIMESTAMP);
INSERT INTO Item (item_id, transactions_id, store_id, price, item_type, name, description, created) VALUES (251, 253, 3, 33, 'Books', 'name_251', 'description_251', CURRENT_TIMESTAMP);
INSERT INTO Item (item_id, transactions_id, store_id, price, item_type, name, description, created) VALUES (252, 48, 6, 233, 'Home', 'name_252', 'description_252', CURRENT_TIMESTAMP);
INSERT INTO Item (item_id, transactions_id, store_id, price, item_type, name, description, created) VALUES (253, 337, 5, 131, 'Toys', 'name_253', 'description_253', CURRENT_TIMESTAMP);
INSERT INTO Item (item_id, transactions_id, store_id, price, item_type, name, description, created) VALUES (254, 378, 14, 180, 'Health', 'name_254', 'description_254', CURRENT_TIMESTAMP);
INSERT INTO Item (item_id, transactions_id, store_id, price, item_type, name, description, created) VALUES (255, 128, 9, 194, 'Health', 'name_255', 'description_255', CURRENT_TIMESTAMP);
INSERT INTO Item (item_id, transactions_id, store_id, price, item_type, name, description, created) VALUES (256, 102, 8, 184, 'Toys', 'name_256', 'description_256', CURRENT_TIMESTAMP);
INSERT INTO Item (item_id, transactions_id, store_id, price, item_type, name, description, created) VALUES (257, 25, 11, 195, 'Health', 'name_257', 'description_257', CURRENT_TIMESTAMP);
INSERT INTO Item (item_id, transactions_id, store_id, price, item_type, name, description, created) VALUES (258, 473, 7, 197, 'Books', 'name_258', 'description_258', CURRENT_TIMESTAMP);
INSERT INTO Item (item_id, transactions_id, store_id, price, item_type, name, description, created) VALUES (259, 159, 13, 212, 'Home', 'name_259', 'description_259', CURRENT_TIMESTAMP);
INSERT INTO Item (item_id, transactions_id, store_id, price, item_type, name, description, created) VALUES (260, 407, 3, 132, 'Books', 'name_260', 'description_260', CURRENT_TIMESTAMP);
INSERT INTO Item (item_id, transactions_id, store_id, price, item_type, name, description, created) VALUES (261, 118, 10, 141, 'Health', 'name_261', 'description_261', CURRENT_TIMESTAMP);
INSERT INTO Item (item_id, transactions_id, store_id, price, item_type, name, description, created) VALUES (262, 235, 3, 57, 'Health', 'name_262', 'description_262', CURRENT_TIMESTAMP);
INSERT INTO Item (item_id, transactions_id, store_id, price, item_type, name, description, created) VALUES (263, 155, 14, 133, 'Toys', 'name_263', 'description_263', CURRENT_TIMESTAMP);
INSERT INTO Item (item_id, transactions_id, store_id, price, item_type, name, description, created) VALUES (264, 129, 3, 75, 'Electronics', 'name_264', 'description_264', CURRENT_TIMESTAMP);
INSERT INTO Item (item_id, transactions_id, store_id, price, item_type, name, description, created) VALUES (265, 146, 9, 138, 'Books', 'name_265', 'description_265', CURRENT_TIMESTAMP);
INSERT INTO Item (item_id, transactions_id, store_id, price, item_type, name, description, created) VALUES (266, 193, 4, 66, 'Home', 'name_266', 'description_266', CURRENT_TIMESTAMP);
INSERT INTO Item (item_id, transactions_id, store_id, price, item_type, name, description, created) VALUES (267, 212, 12, 24, 'Home', 'name_267', 'description_267', CURRENT_TIMESTAMP);
INSERT INTO Item (item_id, transactions_id, store_id, price, item_type, name, description, created) VALUES (268, 77, 13, 110, 'Health', 'name_268', 'description_268', CURRENT_TIMESTAMP);
INSERT INTO Item (item_id, transactions_id, store_id, price, item_type, name, description, created) VALUES (269, 51, 5, 216, 'Health', 'name_269', 'description_269', CURRENT_TIMESTAMP);
INSERT INTO Item (item_id, transactions_id, store_id, price, item_type, name, description, created) VALUES (270, 237, 7, 170, 'Books', 'name_270', 'description_270', CURRENT_TIMESTAMP);
INSERT INTO Item (item_id, transactions_id, store_id, price, item_type, name, description, created) VALUES (271, 3, 7, 143, 'Electronics', 'name_271', 'description_271', CURRENT_TIMESTAMP);
INSERT INTO Item (item_id, transactions_id, store_id, price, item_type, name, description, created) VALUES (272, 133, 12, 22, 'Health', 'name_272', 'description_272', CURRENT_TIMESTAMP);
INSERT INTO Item (item_id, transactions_id, store_id, price, item_type, name, description, created) VALUES (273, 459, 11, 45, 'Electronics', 'name_273', 'description_273', CURRENT_TIMESTAMP);
INSERT INTO Item (item_id, transactions_id, store_id, price, item_type, name, description, created) VALUES (274, 26, 10, 80, 'Electronics', 'name_274', 'description_274', CURRENT_TIMESTAMP);
INSERT INTO Item (item_id, transactions_id, store_id, price, item_type, name, description, created) VALUES (275, 275, 14, 84, 'Home', 'name_275', 'description_275', CURRENT_TIMESTAMP);
INSERT INTO Item (item_id, transactions_id, store_id, price, item_type, name, description, created) VALUES (276, 348, 6, 184, 'Health', 'name_276', 'description_276', CURRENT_TIMESTAMP);
INSERT INTO Item (item_id, transactions_id, store_id, price, item_type, name, description, created) VALUES (277, 369, 9, 245, 'Home', 'name_277', 'description_277', CURRENT_TIMESTAMP);
INSERT INTO Item (item_id, transactions_id, store_id, price, item_type, name, description, created) VALUES (278, 443, 1, 32, 'Electronics', 'name_278', 'description_278', CURRENT_TIMESTAMP);
INSERT INTO Item (item_id, transactions_id, store_id, price, item_type, name, description, created) VALUES (279, 299, 14, 15, 'Electronics', 'name_279', 'description_279', CURRENT_TIMESTAMP);
INSERT INTO Item (item_id, transactions_id, store_id, price, item_type, name, description, created) VALUES (280, 110, 12, 154, 'Home', 'name_280', 'description_280', CURRENT_TIMESTAMP);
INSERT INTO Item (item_id, transactions_id, store_id, price, item_type, name, description, created) VALUES (281, 500, 12, 110, 'Home', 'name_281', 'description_281', CURRENT_TIMESTAMP);
INSERT INTO Item (item_id, transactions_id, store_id, price, item_type, name, description, created) VALUES (282, 83, 14, 257, 'Toys', 'name_282', 'description_282', CURRENT_TIMESTAMP);
INSERT INTO Item (item_id, transactions_id, store_id, price, item_type, name, description, created) VALUES (283, 53, 1, 153, 'Health', 'name_283', 'description_283', CURRENT_TIMESTAMP);
INSERT INTO Item (item_id, transactions_id, store_id, price, item_type, name, description, created) VALUES (284, 298, 13, 196, 'Home', 'name_284', 'description_284', CURRENT_TIMESTAMP);
INSERT INTO Item (item_id, transactions_id, store_id, price, item_type, name, description, created) VALUES (285, 179, 8, 178, 'Home', 'name_285', 'description_285', CURRENT_TIMESTAMP);
INSERT INTO Item (item_id, transactions_id, store_id, price, item_type, name, description, created) VALUES (286, 104, 6, 284, 'Home', 'name_286', 'description_286', CURRENT_TIMESTAMP);
INSERT INTO Item (item_id, transactions_id, store_id, price, item_type, name, description, created) VALUES (287, 269, 13, 44, 'Health', 'name_287', 'description_287', CURRENT_TIMESTAMP);
INSERT INTO Item (item_id, transactions_id, store_id, price, item_type, name, description, created) VALUES (288, 125, 11, 204, 'Home', 'name_288', 'description_288', CURRENT_TIMESTAMP);
INSERT INTO Item (item_id, transactions_id, store_id, price, item_type, name, description, created) VALUES (289, 266, 5, 70, 'Home', 'name_289', 'description_289', CURRENT_TIMESTAMP);
INSERT INTO Item (item_id, transactions_id, store_id, price, item_type, name, description, created) VALUES (290, 210, 6, 54, 'Books', 'name_290', 'description_290', CURRENT_TIMESTAMP);
INSERT INTO Item (item_id, transactions_id, store_id, price, item_type, name, description, created) VALUES (291, 494, 9, 152, 'Electronics', 'name_291', 'description_291', CURRENT_TIMESTAMP);
INSERT INTO Item (item_id, transactions_id, store_id, price, item_type, name, description, created) VALUES (292, 445, 7, 188, 'Toys', 'name_292', 'description_292', CURRENT_TIMESTAMP);
INSERT INTO Item (item_id, transactions_id, store_id, price, item_type, name, description, created) VALUES (293, 128, 4, 123, 'Books', 'name_293', 'description_293', CURRENT_TIMESTAMP);
INSERT INTO Item (item_id, transactions_id, store_id, price, item_type, name, description, created) VALUES (294, 50, 10, 290, 'Books', 'name_294', 'description_294', CURRENT_TIMESTAMP);
INSERT INTO Item (item_id, transactions_id, store_id, price, item_type, name, description, created) VALUES (295, 203, 10, 180, 'Books', 'name_295', 'description_295', CURRENT_TIMESTAMP);
INSERT INTO Item (item_id, transactions_id, store_id, price, item_type, name, description, created) VALUES (296, 234, 3, 104, 'Health', 'name_296', 'description_296', CURRENT_TIMESTAMP);
INSERT INTO Item (item_id, transactions_id, store_id, price, item_type, name, description, created) VALUES (297, 423, 1, 286, 'Books', 'name_297', 'description_297', CURRENT_TIMESTAMP);
INSERT INTO Item (item_id, transactions_id, store_id, price, item_type, name, description, created) VALUES (298, 452, 10, 214, 'Health', 'name_298', 'description_298', CURRENT_TIMESTAMP);
INSERT INTO Item (item_id, transactions_id, store_id, price, item_type, name, description, created) VALUES (299, 29, 2, 260, 'Home', 'name_299', 'description_299', CURRENT_TIMESTAMP);
INSERT INTO Item (item_id, transactions_id, store_id, price, item_type, name, description, created) VALUES (300, 319, 6, 74, 'Health', 'name_300', 'description_300', CURRENT_TIMESTAMP);
INSERT INTO Item (item_id, transactions_id, store_id, price, item_type, name, description, created) VALUES (301, 48, 3, 227, 'Books', 'name_301', 'description_301', CURRENT_TIMESTAMP);
INSERT INTO Item (item_id, transactions_id, store_id, price, item_type, name, description, created) VALUES (302, 47, 9, 10, 'Books', 'name_302', 'description_302', CURRENT_TIMESTAMP);
INSERT INTO Item (item_id, transactions_id, store_id, price, item_type, name, description, created) VALUES (303, 345, 9, 289, 'Books', 'name_303', 'description_303', CURRENT_TIMESTAMP);
INSERT INTO Item (item_id, transactions_id, store_id, price, item_type, name, description, created) VALUES (304, 306, 8, 250, 'Books', 'name_304', 'description_304', CURRENT_TIMESTAMP);
INSERT INTO Item (item_id, transactions_id, store_id, price, item_type, name, description, created) VALUES (305, 263, 4, 298, 'Books', 'name_305', 'description_305', CURRENT_TIMESTAMP);
INSERT INTO Item (item_id, transactions_id, store_id, price, item_type, name, description, created) VALUES (306, 498, 11, 220, 'Electronics', 'name_306', 'description_306', CURRENT_TIMESTAMP);
INSERT INTO Item (item_id, transactions_id, store_id, price, item_type, name, description, created) VALUES (307, 86, 3, 39, 'Health', 'name_307', 'description_307', CURRENT_TIMESTAMP);
INSERT INTO Item (item_id, transactions_id, store_id, price, item_type, name, description, created) VALUES (308, 413, 9, 121, 'Electronics', 'name_308', 'description_308', CURRENT_TIMESTAMP);
INSERT INTO Item (item_id, transactions_id, store_id, price, item_type, name, description, created) VALUES (309, 481, 2, 51, 'Electronics', 'name_309', 'description_309', CURRENT_TIMESTAMP);
INSERT INTO Item (item_id, transactions_id, store_id, price, item_type, name, description, created) VALUES (310, 492, 10, 213, 'Health', 'name_310', 'description_310', CURRENT_TIMESTAMP);
INSERT INTO Item (item_id, transactions_id, store_id, price, item_type, name, description, created) VALUES (311, 191, 7, 189, 'Home', 'name_311', 'description_311', CURRENT_TIMESTAMP);
INSERT INTO Item (item_id, transactions_id, store_id, price, item_type, name, description, created) VALUES (312, 161, 4, 256, 'Health', 'name_312', 'description_312', CURRENT_TIMESTAMP);
INSERT INTO Item (item_id, transactions_id, store_id, price, item_type, name, description, created) VALUES (313, 285, 7, 181, 'Toys', 'name_313', 'description_313', CURRENT_TIMESTAMP);
INSERT INTO Item (item_id, transactions_id, store_id, price, item_type, name, description, created) VALUES (314, 72, 9, 263, 'Home', 'name_314', 'description_314', CURRENT_TIMESTAMP);
INSERT INTO Item (item_id, transactions_id, store_id, price, item_type, name, description, created) VALUES (315, 167, 7, 225, 'Books', 'name_315', 'description_315', CURRENT_TIMESTAMP);
INSERT INTO Item (item_id, transactions_id, store_id, price, item_type, name, description, created) VALUES (316, 67, 1, 99, 'Electronics', 'name_316', 'description_316', CURRENT_TIMESTAMP);
INSERT INTO Item (item_id, transactions_id, store_id, price, item_type, name, description, created) VALUES (317, 493, 8, 238, 'Health', 'name_317', 'description_317', CURRENT_TIMESTAMP);
INSERT INTO Item (item_id, transactions_id, store_id, price, item_type, name, description, created) VALUES (318, 136, 1, 95, 'Books', 'name_318', 'description_318', CURRENT_TIMESTAMP);
INSERT INTO Item (item_id, transactions_id, store_id, price, item_type, name, description, created) VALUES (319, 127, 7, 296, 'Books', 'name_319', 'description_319', CURRENT_TIMESTAMP);
INSERT INTO Item (item_id, transactions_id, store_id, price, item_type, name, description, created) VALUES (320, 446, 9, 95, 'Home', 'name_320', 'description_320', CURRENT_TIMESTAMP);
INSERT INTO Item (item_id, transactions_id, store_id, price, item_type, name, description, created) VALUES (321, 262, 12, 64, 'Toys', 'name_321', 'description_321', CURRENT_TIMESTAMP);
INSERT INTO Item (item_id, transactions_id, store_id, price, item_type, name, description, created) VALUES (322, 391, 3, 46, 'Health', 'name_322', 'description_322', CURRENT_TIMESTAMP);
INSERT INTO Item (item_id, transactions_id, store_id, price, item_type, name, description, created) VALUES (323, 50, 6, 91, 'Books', 'name_323', 'description_323', CURRENT_TIMESTAMP);
INSERT INTO Item (item_id, transactions_id, store_id, price, item_type, name, description, created) VALUES (324, 469, 10, 119, 'Electronics', 'name_324', 'description_324', CURRENT_TIMESTAMP);
INSERT INTO Item (item_id, transactions_id, store_id, price, item_type, name, description, created) VALUES (325, 470, 6, 222, 'Electronics', 'name_325', 'description_325', CURRENT_TIMESTAMP);
INSERT INTO Item (item_id, transactions_id, store_id, price, item_type, name, description, created) VALUES (326, 102, 3, 83, 'Electronics', 'name_326', 'description_326', CURRENT_TIMESTAMP);
INSERT INTO Item (item_id, transactions_id, store_id, price, item_type, name, description, created) VALUES (327, 36, 4, 17, 'Health', 'name_327', 'description_327', CURRENT_TIMESTAMP);
INSERT INTO Item (item_id, transactions_id, store_id, price, item_type, name, description, created) VALUES (328, 342, 13, 284, 'Home', 'name_328', 'description_328', CURRENT_TIMESTAMP);
INSERT INTO Item (item_id, transactions_id, store_id, price, item_type, name, description, created) VALUES (329, 173, 3, 151, 'Books', 'name_329', 'description_329', CURRENT_TIMESTAMP);
INSERT INTO Item (item_id, transactions_id, store_id, price, item_type, name, description, created) VALUES (330, 295, 1, 149, 'Health', 'name_330', 'description_330', CURRENT_TIMESTAMP);
INSERT INTO Item (item_id, transactions_id, store_id, price, item_type, name, description, created) VALUES (331, 7, 9, 59, 'Toys', 'name_331', 'description_331', CURRENT_TIMESTAMP);
INSERT INTO Item (item_id, transactions_id, store_id, price, item_type, name, description, created) VALUES (332, 26, 1, 310, 'Home', 'name_332', 'description_332', CURRENT_TIMESTAMP);
INSERT INTO Item (item_id, transactions_id, store_id, price, item_type, name, description, created) VALUES (333, 101, 12, 330, 'Home', 'name_333', 'description_333', CURRENT_TIMESTAMP);
INSERT INTO Item (item_id, transactions_id, store_id, price, item_type, name, description, created) VALUES (334, 174, 2, 232, 'Books', 'name_334', 'description_334', CURRENT_TIMESTAMP);
INSERT INTO Item (item_id, transactions_id, store_id, price, item_type, name, description, created) VALUES (335, 236, 4, 311, 'Electronics', 'name_335', 'description_335', CURRENT_TIMESTAMP);
INSERT INTO Item (item_id, transactions_id, store_id, price, item_type, name, description, created) VALUES (336, 498, 4, 219, 'Health', 'name_336', 'description_336', CURRENT_TIMESTAMP);
INSERT INTO Item (item_id, transactions_id, store_id, price, item_type, name, description, created) VALUES (337, 77, 12, 324, 'Home', 'name_337', 'description_337', CURRENT_TIMESTAMP);
INSERT INTO Item (item_id, transactions_id, store_id, price, item_type, name, description, created) VALUES (338, 140, 9, 4, 'Books', 'name_338', 'description_338', CURRENT_TIMESTAMP);
INSERT INTO Item (item_id, transactions_id, store_id, price, item_type, name, description, created) VALUES (339, 273, 3, 130, 'Health', 'name_339', 'description_339', CURRENT_TIMESTAMP);
INSERT INTO Item (item_id, transactions_id, store_id, price, item_type, name, description, created) VALUES (340, 431, 4, 87, 'Home', 'name_340', 'description_340', CURRENT_TIMESTAMP);
INSERT INTO Item (item_id, transactions_id, store_id, price, item_type, name, description, created) VALUES (341, 108, 14, 125, 'Home', 'name_341', 'description_341', CURRENT_TIMESTAMP);
INSERT INTO Item (item_id, transactions_id, store_id, price, item_type, name, description, created) VALUES (342, 261, 14, 297, 'Electronics', 'name_342', 'description_342', CURRENT_TIMESTAMP);
INSERT INTO Item (item_id, transactions_id, store_id, price, item_type, name, description, created) VALUES (343, 10, 3, 277, 'Electronics', 'name_343', 'description_343', CURRENT_TIMESTAMP);
INSERT INTO Item (item_id, transactions_id, store_id, price, item_type, name, description, created) VALUES (344, 370, 3, 179, 'Home', 'name_344', 'description_344', CURRENT_TIMESTAMP);
INSERT INTO Item (item_id, transactions_id, store_id, price, item_type, name, description, created) VALUES (345, 12, 9, 237, 'Books', 'name_345', 'description_345', CURRENT_TIMESTAMP);
INSERT INTO Item (item_id, transactions_id, store_id, price, item_type, name, description, created) VALUES (346, 158, 9, 305, 'Health', 'name_346', 'description_346', CURRENT_TIMESTAMP);
INSERT INTO Item (item_id, transactions_id, store_id, price, item_type, name, description, created) VALUES (347, 7, 14, 147, 'Home', 'name_347', 'description_347', CURRENT_TIMESTAMP);
INSERT INTO Item (item_id, transactions_id, store_id, price, item_type, name, description, created) VALUES (348, 446, 4, 74, 'Health', 'name_348', 'description_348', CURRENT_TIMESTAMP);
INSERT INTO Item (item_id, transactions_id, store_id, price, item_type, name, description, created) VALUES (349, 444, 7, 151, 'Home', 'name_349', 'description_349', CURRENT_TIMESTAMP);
INSERT INTO Item (item_id, transactions_id, store_id, price, item_type, name, description, created) VALUES (350, 463, 9, 159, 'Electronics', 'name_350', 'description_350', CURRENT_TIMESTAMP);
INSERT INTO Item (item_id, transactions_id, store_id, price, item_type, name, description, created) VALUES (351, 328, 6, 128, 'Books', 'name_351', 'description_351', CURRENT_TIMESTAMP);
INSERT INTO Item (item_id, transactions_id, store_id, price, item_type, name, description, created) VALUES (352, 332, 3, 271, 'Home', 'name_352', 'description_352', CURRENT_TIMESTAMP);
INSERT INTO Item (item_id, transactions_id, store_id, price, item_type, name, description, created) VALUES (353, 17, 8, 248, 'Toys', 'name_353', 'description_353', CURRENT_TIMESTAMP);
INSERT INTO Item (item_id, transactions_id, store_id, price, item_type, name, description, created) VALUES (354, 406, 8, 69, 'Toys', 'name_354', 'description_354', CURRENT_TIMESTAMP);
INSERT INTO Item (item_id, transactions_id, store_id, price, item_type, name, description, created) VALUES (355, 356, 3, 235, 'Books', 'name_355', 'description_355', CURRENT_TIMESTAMP);
INSERT INTO Item (item_id, transactions_id, store_id, price, item_type, name, description, created) VALUES (356, 144, 11, 1, 'Electronics', 'name_356', 'description_356', CURRENT_TIMESTAMP);
INSERT INTO Item (item_id, transactions_id, store_id, price, item_type, name, description, created) VALUES (357, 301, 3, 305, 'Home', 'name_357', 'description_357', CURRENT_TIMESTAMP);
INSERT INTO Item (item_id, transactions_id, store_id, price, item_type, name, description, created) VALUES (358, 475, 6, 228, 'Health', 'name_358', 'description_358', CURRENT_TIMESTAMP);
INSERT INTO Item (item_id, transactions_id, store_id, price, item_type, name, description, created) VALUES (359, 365, 1, 33, 'Home', 'name_359', 'description_359', CURRENT_TIMESTAMP);
INSERT INTO Item (item_id, transactions_id, store_id, price, item_type, name, description, created) VALUES (360, 402, 5, 264, 'Electronics', 'name_360', 'description_360', CURRENT_TIMESTAMP);
INSERT INTO Item (item_id, transactions_id, store_id, price, item_type, name, description, created) VALUES (361, 331, 9, 20, 'Toys', 'name_361', 'description_361', CURRENT_TIMESTAMP);
INSERT INTO Item (item_id, transactions_id, store_id, price, item_type, name, description, created) VALUES (362, 64, 4, 1, 'Toys', 'name_362', 'description_362', CURRENT_TIMESTAMP);
INSERT INTO Item (item_id, transactions_id, store_id, price, item_type, name, description, created) VALUES (363, 478, 4, 97, 'Toys', 'name_363', 'description_363', CURRENT_TIMESTAMP);
INSERT INTO Item (item_id, transactions_id, store_id, price, item_type, name, description, created) VALUES (364, 449, 8, 303, 'Electronics', 'name_364', 'description_364', CURRENT_TIMESTAMP);
INSERT INTO Item (item_id, transactions_id, store_id, price, item_type, name, description, created) VALUES (365, 84, 11, 109, 'Toys', 'name_365', 'description_365', CURRENT_TIMESTAMP);
INSERT INTO Item (item_id, transactions_id, store_id, price, item_type, name, description, created) VALUES (366, 260, 2, 111, 'Books', 'name_366', 'description_366', CURRENT_TIMESTAMP);
INSERT INTO Item (item_id, transactions_id, store_id, price, item_type, name, description, created) VALUES (367, 3, 4, 132, 'Health', 'name_367', 'description_367', CURRENT_TIMESTAMP);
INSERT INTO Item (item_id, transactions_id, store_id, price, item_type, name, description, created) VALUES (368, 331, 4, 364, 'Toys', 'name_368', 'description_368', CURRENT_TIMESTAMP);
INSERT INTO Item (item_id, transactions_id, store_id, price, item_type, name, description, created) VALUES (369, 327, 8, 125, 'Toys', 'name_369', 'description_369', CURRENT_TIMESTAMP);
INSERT INTO Item (item_id, transactions_id, store_id, price, item_type, name, description, created) VALUES (370, 216, 7, 94, 'Home', 'name_370', 'description_370', CURRENT_TIMESTAMP);
INSERT INTO Item (item_id, transactions_id, store_id, price, item_type, name, description, created) VALUES (371, 349, 4, 3, 'Toys', 'name_371', 'description_371', CURRENT_TIMESTAMP);
INSERT INTO Item (item_id, transactions_id, store_id, price, item_type, name, description, created) VALUES (372, 237, 6, 186, 'Electronics', 'name_372', 'description_372', CURRENT_TIMESTAMP);
INSERT INTO Item (item_id, transactions_id, store_id, price, item_type, name, description, created) VALUES (373, 369, 10, 251, 'Home', 'name_373', 'description_373', CURRENT_TIMESTAMP);
INSERT INTO Item (item_id, transactions_id, store_id, price, item_type, name, description, created) VALUES (374, 140, 4, 39, 'Books', 'name_374', 'description_374', CURRENT_TIMESTAMP);
INSERT INTO Item (item_id, transactions_id, store_id, price, item_type, name, description, created) VALUES (375, 141, 2, 263, 'Health', 'name_375', 'description_375', CURRENT_TIMESTAMP);
INSERT INTO Item (item_id, transactions_id, store_id, price, item_type, name, description, created) VALUES (376, 118, 13, 209, 'Toys', 'name_376', 'description_376', CURRENT_TIMESTAMP);
INSERT INTO Item (item_id, transactions_id, store_id, price, item_type, name, description, created) VALUES (377, 196, 11, 374, 'Home', 'name_377', 'description_377', CURRENT_TIMESTAMP);
INSERT INTO Item (item_id, transactions_id, store_id, price, item_type, name, description, created) VALUES (378, 210, 5, 242, 'Health', 'name_378', 'description_378', CURRENT_TIMESTAMP);
INSERT INTO Item (item_id, transactions_id, store_id, price, item_type, name, description, created) VALUES (379, 105, 3, 244, 'Electronics', 'name_379', 'description_379', CURRENT_TIMESTAMP);
INSERT INTO Item (item_id, transactions_id, store_id, price, item_type, name, description, created) VALUES (380, 152, 14, 77, 'Toys', 'name_380', 'description_380', CURRENT_TIMESTAMP);
INSERT INTO Item (item_id, transactions_id, store_id, price, item_type, name, description, created) VALUES (381, 317, 2, 254, 'Toys', 'name_381', 'description_381', CURRENT_TIMESTAMP);
INSERT INTO Item (item_id, transactions_id, store_id, price, item_type, name, description, created) VALUES (382, 70, 8, 294, 'Home', 'name_382', 'description_382', CURRENT_TIMESTAMP);
INSERT INTO Item (item_id, transactions_id, store_id, price, item_type, name, description, created) VALUES (383, 416, 12, 110, 'Electronics', 'name_383', 'description_383', CURRENT_TIMESTAMP);
INSERT INTO Item (item_id, transactions_id, store_id, price, item_type, name, description, created) VALUES (384, 399, 10, 180, 'Electronics', 'name_384', 'description_384', CURRENT_TIMESTAMP);
INSERT INTO Item (item_id, transactions_id, store_id, price, item_type, name, description, created) VALUES (385, 390, 9, 101, 'Electronics', 'name_385', 'description_385', CURRENT_TIMESTAMP);
INSERT INTO Item (item_id, transactions_id, store_id, price, item_type, name, description, created) VALUES (386, 110, 12, 279, 'Home', 'name_386', 'description_386', CURRENT_TIMESTAMP);
INSERT INTO Item (item_id, transactions_id, store_id, price, item_type, name, description, created) VALUES (387, 355, 4, 147, 'Toys', 'name_387', 'description_387', CURRENT_TIMESTAMP);
INSERT INTO Item (item_id, transactions_id, store_id, price, item_type, name, description, created) VALUES (388, 71, 4, 328, 'Electronics', 'name_388', 'description_388', CURRENT_TIMESTAMP);
INSERT INTO Item (item_id, transactions_id, store_id, price, item_type, name, description, created) VALUES (389, 223, 9, 275, 'Home', 'name_389', 'description_389', CURRENT_TIMESTAMP);
INSERT INTO Item (item_id, transactions_id, store_id, price, item_type, name, description, created) VALUES (390, 415, 12, 240, 'Health', 'name_390', 'description_390', CURRENT_TIMESTAMP);
INSERT INTO Item (item_id, transactions_id, store_id, price, item_type, name, description, created) VALUES (391, 380, 3, 368, 'Health', 'name_391', 'description_391', CURRENT_TIMESTAMP);
INSERT INTO Item (item_id, transactions_id, store_id, price, item_type, name, description, created) VALUES (392, 30, 8, 278, 'Books', 'name_392', 'description_392', CURRENT_TIMESTAMP);
INSERT INTO Item (item_id, transactions_id, store_id, price, item_type, name, description, created) VALUES (393, 274, 5, 261, 'Health', 'name_393', 'description_393', CURRENT_TIMESTAMP);
INSERT INTO Item (item_id, transactions_id, store_id, price, item_type, name, description, created) VALUES (394, 171, 14, 168, 'Home', 'name_394', 'description_394', CURRENT_TIMESTAMP);
INSERT INTO Item (item_id, transactions_id, store_id, price, item_type, name, description, created) VALUES (395, 193, 7, 197, 'Health', 'name_395', 'description_395', CURRENT_TIMESTAMP);
INSERT INTO Item (item_id, transactions_id, store_id, price, item_type, name, description, created) VALUES (396, 451, 2, 314, 'Home', 'name_396', 'description_396', CURRENT_TIMESTAMP);
INSERT INTO Item (item_id, transactions_id, store_id, price, item_type, name, description, created) VALUES (397, 484, 13, 351, 'Health', 'name_397', 'description_397', CURRENT_TIMESTAMP);
INSERT INTO Item (item_id, transactions_id, store_id, price, item_type, name, description, created) VALUES (398, 6, 9, 185, 'Books', 'name_398', 'description_398', CURRENT_TIMESTAMP);
INSERT INTO Item (item_id, transactions_id, store_id, price, item_type, name, description, created) VALUES (399, 333, 9, 9, 'Home', 'name_399', 'description_399', CURRENT_TIMESTAMP);
INSERT INTO Item (item_id, transactions_id, store_id, price, item_type, name, description, created) VALUES (400, 380, 6, 44, 'Books', 'name_400', 'description_400', CURRENT_TIMESTAMP);
INSERT INTO Item (item_id, transactions_id, store_id, price, item_type, name, description, created) VALUES (401, 290, 1, 45, 'Home', 'name_401', 'description_401', CURRENT_TIMESTAMP);
INSERT INTO Item (item_id, transactions_id, store_id, price, item_type, name, description, created) VALUES (402, 291, 5, 148, 'Books', 'name_402', 'description_402', CURRENT_TIMESTAMP);
INSERT INTO Item (item_id, transactions_id, store_id, price, item_type, name, description, created) VALUES (403, 286, 5, 233, 'Books', 'name_403', 'description_403', CURRENT_TIMESTAMP);
INSERT INTO Item (item_id, transactions_id, store_id, price, item_type, name, description, created) VALUES (404, 168, 2, 386, 'Electronics', 'name_404', 'description_404', CURRENT_TIMESTAMP);
INSERT INTO Item (item_id, transactions_id, store_id, price, item_type, name, description, created) VALUES (405, 115, 6, 360, 'Electronics', 'name_405', 'description_405', CURRENT_TIMESTAMP);
INSERT INTO Item (item_id, transactions_id, store_id, price, item_type, name, description, created) VALUES (406, 325, 4, 403, 'Electronics', 'name_406', 'description_406', CURRENT_TIMESTAMP);
INSERT INTO Item (item_id, transactions_id, store_id, price, item_type, name, description, created) VALUES (407, 495, 2, 263, 'Electronics', 'name_407', 'description_407', CURRENT_TIMESTAMP);
INSERT INTO Item (item_id, transactions_id, store_id, price, item_type, name, description, created) VALUES (408, 374, 5, 231, 'Home', 'name_408', 'description_408', CURRENT_TIMESTAMP);
INSERT INTO Item (item_id, transactions_id, store_id, price, item_type, name, description, created) VALUES (409, 161, 9, 241, 'Books', 'name_409', 'description_409', CURRENT_TIMESTAMP);
INSERT INTO Item (item_id, transactions_id, store_id, price, item_type, name, description, created) VALUES (410, 9, 5, 390, 'Books', 'name_410', 'description_410', CURRENT_TIMESTAMP);
INSERT INTO Item (item_id, transactions_id, store_id, price, item_type, name, description, created) VALUES (411, 470, 12, 133, 'Electronics', 'name_411', 'description_411', CURRENT_TIMESTAMP);
INSERT INTO Item (item_id, transactions_id, store_id, price, item_type, name, description, created) VALUES (412, 100, 11, 134, 'Toys', 'name_412', 'description_412', CURRENT_TIMESTAMP);
INSERT INTO Item (item_id, transactions_id, store_id, price, item_type, name, description, created) VALUES (413, 123, 11, 131, 'Home', 'name_413', 'description_413', CURRENT_TIMESTAMP);
INSERT INTO Item (item_id, transactions_id, store_id, price, item_type, name, description, created) VALUES (414, 373, 13, 121, 'Books', 'name_414', 'description_414', CURRENT_TIMESTAMP);
INSERT INTO Item (item_id, transactions_id, store_id, price, item_type, name, description, created) VALUES (415, 466, 10, 203, 'Health', 'name_415', 'description_415', CURRENT_TIMESTAMP);
INSERT INTO Item (item_id, transactions_id, store_id, price, item_type, name, description, created) VALUES (416, 119, 5, 355, 'Books', 'name_416', 'description_416', CURRENT_TIMESTAMP);
INSERT INTO Item (item_id, transactions_id, store_id, price, item_type, name, description, created) VALUES (417, 304, 5, 19, 'Health', 'name_417', 'description_417', CURRENT_TIMESTAMP);
INSERT INTO Item (item_id, transactions_id, store_id, price, item_type, name, description, created) VALUES (418, 428, 7, 267, 'Health', 'name_418', 'description_418', CURRENT_TIMESTAMP);
INSERT INTO Item (item_id, transactions_id, store_id, price, item_type, name, description, created) VALUES (419, 72, 14, 117, 'Toys', 'name_419', 'description_419', CURRENT_TIMESTAMP);
INSERT INTO Item (item_id, transactions_id, store_id, price, item_type, name, description, created) VALUES (420, 211, 14, 341, 'Books', 'name_420', 'description_420', CURRENT_TIMESTAMP);
INSERT INTO Item (item_id, transactions_id, store_id, price, item_type, name, description, created) VALUES (421, 154, 5, 223, 'Toys', 'name_421', 'description_421', CURRENT_TIMESTAMP);
INSERT INTO Item (item_id, transactions_id, store_id, price, item_type, name, description, created) VALUES (422, 312, 5, 162, 'Home', 'name_422', 'description_422', CURRENT_TIMESTAMP);
INSERT INTO Item (item_id, transactions_id, store_id, price, item_type, name, description, created) VALUES (423, 101, 14, 198, 'Home', 'name_423', 'description_423', CURRENT_TIMESTAMP);
INSERT INTO Item (item_id, transactions_id, store_id, price, item_type, name, description, created) VALUES (424, 274, 3, 420, 'Electronics', 'name_424', 'description_424', CURRENT_TIMESTAMP);
INSERT INTO Item (item_id, transactions_id, store_id, price, item_type, name, description, created) VALUES (425, 5, 1, 203, 'Home', 'name_425', 'description_425', CURRENT_TIMESTAMP);
INSERT INTO Item (item_id, transactions_id, store_id, price, item_type, name, description, created) VALUES (426, 475, 12, 242, 'Electronics', 'name_426', 'description_426', CURRENT_TIMESTAMP);
INSERT INTO Item (item_id, transactions_id, store_id, price, item_type, name, description, created) VALUES (427, 17, 13, 408, 'Toys', 'name_427', 'description_427', CURRENT_TIMESTAMP);
INSERT INTO Item (item_id, transactions_id, store_id, price, item_type, name, description, created) VALUES (428, 445, 4, 365, 'Books', 'name_428', 'description_428', CURRENT_TIMESTAMP);
INSERT INTO Item (item_id, transactions_id, store_id, price, item_type, name, description, created) VALUES (429, 35, 5, 221, 'Toys', 'name_429', 'description_429', CURRENT_TIMESTAMP);
INSERT INTO Item (item_id, transactions_id, store_id, price, item_type, name, description, created) VALUES (430, 155, 5, 384, 'Home', 'name_430', 'description_430', CURRENT_TIMESTAMP);
INSERT INTO Item (item_id, transactions_id, store_id, price, item_type, name, description, created) VALUES (431, 236, 14, 429, 'Books', 'name_431', 'description_431', CURRENT_TIMESTAMP);
INSERT INTO Item (item_id, transactions_id, store_id, price, item_type, name, description, created) VALUES (432, 474, 3, 206, 'Health', 'name_432', 'description_432', CURRENT_TIMESTAMP);
INSERT INTO Item (item_id, transactions_id, store_id, price, item_type, name, description, created) VALUES (433, 447, 2, 72, 'Toys', 'name_433', 'description_433', CURRENT_TIMESTAMP);
INSERT INTO Item (item_id, transactions_id, store_id, price, item_type, name, description, created) VALUES (434, 303, 6, 136, 'Home', 'name_434', 'description_434', CURRENT_TIMESTAMP);
INSERT INTO Item (item_id, transactions_id, store_id, price, item_type, name, description, created) VALUES (435, 316, 11, 390, 'Books', 'name_435', 'description_435', CURRENT_TIMESTAMP);
INSERT INTO Item (item_id, transactions_id, store_id, price, item_type, name, description, created) VALUES (436, 335, 5, 390, 'Home', 'name_436', 'description_436', CURRENT_TIMESTAMP);
INSERT INTO Item (item_id, transactions_id, store_id, price, item_type, name, description, created) VALUES (437, 496, 5, 39, 'Electronics', 'name_437', 'description_437', CURRENT_TIMESTAMP);
INSERT INTO Item (item_id, transactions_id, store_id, price, item_type, name, description, created) VALUES (438, 33, 7, 3, 'Electronics', 'name_438', 'description_438', CURRENT_TIMESTAMP);
INSERT INTO Item (item_id, transactions_id, store_id, price, item_type, name, description, created) VALUES (439, 95, 11, 289, 'Electronics', 'name_439', 'description_439', CURRENT_TIMESTAMP);
INSERT INTO Item (item_id, transactions_id, store_id, price, item_type, name, description, created) VALUES (440, 489, 6, 263, 'Toys', 'name_440', 'description_440', CURRENT_TIMESTAMP);
INSERT INTO Item (item_id, transactions_id, store_id, price, item_type, name, description, created) VALUES (441, 82, 6, 186, 'Books', 'name_441', 'description_441', CURRENT_TIMESTAMP);
INSERT INTO Item (item_id, transactions_id, store_id, price, item_type, name, description, created) VALUES (442, 75, 3, 8, 'Health', 'name_442', 'description_442', CURRENT_TIMESTAMP);
INSERT INTO Item (item_id, transactions_id, store_id, price, item_type, name, description, created) VALUES (443, 276, 1, 301, 'Home', 'name_443', 'description_443', CURRENT_TIMESTAMP);
INSERT INTO Item (item_id, transactions_id, store_id, price, item_type, name, description, created) VALUES (444, 319, 11, 14, 'Health', 'name_444', 'description_444', CURRENT_TIMESTAMP);
INSERT INTO Item (item_id, transactions_id, store_id, price, item_type, name, description, created) VALUES (445, 352, 12, 235, 'Toys', 'name_445', 'description_445', CURRENT_TIMESTAMP);
INSERT INTO Item (item_id, transactions_id, store_id, price, item_type, name, description, created) VALUES (446, 122, 9, 259, 'Health', 'name_446', 'description_446', CURRENT_TIMESTAMP);
INSERT INTO Item (item_id, transactions_id, store_id, price, item_type, name, description, created) VALUES (447, 464, 12, 318, 'Toys', 'name_447', 'description_447', CURRENT_TIMESTAMP);
INSERT INTO Item (item_id, transactions_id, store_id, price, item_type, name, description, created) VALUES (448, 300, 13, 410, 'Home', 'name_448', 'description_448', CURRENT_TIMESTAMP);
INSERT INTO Item (item_id, transactions_id, store_id, price, item_type, name, description, created) VALUES (449, 417, 2, 436, 'Books', 'name_449', 'description_449', CURRENT_TIMESTAMP);
INSERT INTO Item (item_id, transactions_id, store_id, price, item_type, name, description, created) VALUES (450, 415, 6, 445, 'Books', 'name_450', 'description_450', CURRENT_TIMESTAMP);
INSERT INTO Item (item_id, transactions_id, store_id, price, item_type, name, description, created) VALUES (451, 306, 11, 312, 'Toys', 'name_451', 'description_451', CURRENT_TIMESTAMP);
INSERT INTO Item (item_id, transactions_id, store_id, price, item_type, name, description, created) VALUES (452, 183, 14, 291, 'Home', 'name_452', 'description_452', CURRENT_TIMESTAMP);
INSERT INTO Item (item_id, transactions_id, store_id, price, item_type, name, description, created) VALUES (453, 155, 10, 131, 'Electronics', 'name_453', 'description_453', CURRENT_TIMESTAMP);
INSERT INTO Item (item_id, transactions_id, store_id, price, item_type, name, description, created) VALUES (454, 161, 2, 437, 'Home', 'name_454', 'description_454', CURRENT_TIMESTAMP);
INSERT INTO Item (item_id, transactions_id, store_id, price, item_type, name, description, created) VALUES (455, 403, 2, 355, 'Books', 'name_455', 'description_455', CURRENT_TIMESTAMP);
INSERT INTO Item (item_id, transactions_id, store_id, price, item_type, name, description, created) VALUES (456, 246, 5, 134, 'Toys', 'name_456', 'description_456', CURRENT_TIMESTAMP);
INSERT INTO Item (item_id, transactions_id, store_id, price, item_type, name, description, created) VALUES (457, 186, 5, 410, 'Home', 'name_457', 'description_457', CURRENT_TIMESTAMP);
INSERT INTO Item (item_id, transactions_id, store_id, price, item_type, name, description, created) VALUES (458, 183, 1, 75, 'Electronics', 'name_458', 'description_458', CURRENT_TIMESTAMP);
INSERT INTO Item (item_id, transactions_id, store_id, price, item_type, name, description, created) VALUES (459, 2, 7, 279, 'Health', 'name_459', 'description_459', CURRENT_TIMESTAMP);
INSERT INTO Item (item_id, transactions_id, store_id, price, item_type, name, description, created) VALUES (460, 485, 4, 366, 'Electronics', 'name_460', 'description_460', CURRENT_TIMESTAMP);
INSERT INTO Item (item_id, transactions_id, store_id, price, item_type, name, description, created) VALUES (461, 400, 14, 257, 'Health', 'name_461', 'description_461', CURRENT_TIMESTAMP);
INSERT INTO Item (item_id, transactions_id, store_id, price, item_type, name, description, created) VALUES (462, 107, 8, 7, 'Electronics', 'name_462', 'description_462', CURRENT_TIMESTAMP);
INSERT INTO Item (item_id, transactions_id, store_id, price, item_type, name, description, created) VALUES (463, 128, 8, 345, 'Home', 'name_463', 'description_463', CURRENT_TIMESTAMP);
INSERT INTO Item (item_id, transactions_id, store_id, price, item_type, name, description, created) VALUES (464, 214, 13, 356, 'Home', 'name_464', 'description_464', CURRENT_TIMESTAMP);
INSERT INTO Item (item_id, transactions_id, store_id, price, item_type, name, description, created) VALUES (465, 329, 1, 371, 'Home', 'name_465', 'description_465', CURRENT_TIMESTAMP);
INSERT INTO Item (item_id, transactions_id, store_id, price, item_type, name, description, created) VALUES (466, 158, 6, 294, 'Toys', 'name_466', 'description_466', CURRENT_TIMESTAMP);
INSERT INTO Item (item_id, transactions_id, store_id, price, item_type, name, description, created) VALUES (467, 436, 11, 244, 'Toys', 'name_467', 'description_467', CURRENT_TIMESTAMP);
INSERT INTO Item (item_id, transactions_id, store_id, price, item_type, name, description, created) VALUES (468, 264, 10, 135, 'Health', 'name_468', 'description_468', CURRENT_TIMESTAMP);
INSERT INTO Item (item_id, transactions_id, store_id, price, item_type, name, description, created) VALUES (469, 64, 6, 75, 'Toys', 'name_469', 'description_469', CURRENT_TIMESTAMP);
INSERT INTO Item (item_id, transactions_id, store_id, price, item_type, name, description, created) VALUES (470, 290, 9, 163, 'Toys', 'name_470', 'description_470', CURRENT_TIMESTAMP);
INSERT INTO Item (item_id, transactions_id, store_id, price, item_type, name, description, created) VALUES (471, 128, 11, 89, 'Electronics', 'name_471', 'description_471', CURRENT_TIMESTAMP);
INSERT INTO Item (item_id, transactions_id, store_id, price, item_type, name, description, created) VALUES (472, 97, 11, 404, 'Electronics', 'name_472', 'description_472', CURRENT_TIMESTAMP);
INSERT INTO Item (item_id, transactions_id, store_id, price, item_type, name, description, created) VALUES (473, 489, 11, 392, 'Health', 'name_473', 'description_473', CURRENT_TIMESTAMP);
INSERT INTO Item (item_id, transactions_id, store_id, price, item_type, name, description, created) VALUES (474, 130, 1, 374, 'Toys', 'name_474', 'description_474', CURRENT_TIMESTAMP);
INSERT INTO Item (item_id, transactions_id, store_id, price, item_type, name, description, created) VALUES (475, 367, 2, 410, 'Home', 'name_475', 'description_475', CURRENT_TIMESTAMP);
INSERT INTO Item (item_id, transactions_id, store_id, price, item_type, name, description, created) VALUES (476, 17, 4, 337, 'Home', 'name_476', 'description_476', CURRENT_TIMESTAMP);
INSERT INTO Item (item_id, transactions_id, store_id, price, item_type, name, description, created) VALUES (477, 194, 11, 238, 'Home', 'name_477', 'description_477', CURRENT_TIMESTAMP);
INSERT INTO Item (item_id, transactions_id, store_id, price, item_type, name, description, created) VALUES (478, 313, 4, 141, 'Toys', 'name_478', 'description_478', CURRENT_TIMESTAMP);
INSERT INTO Item (item_id, transactions_id, store_id, price, item_type, name, description, created) VALUES (479, 376, 12, 61, 'Home', 'name_479', 'description_479', CURRENT_TIMESTAMP);
INSERT INTO Item (item_id, transactions_id, store_id, price, item_type, name, description, created) VALUES (480, 113, 2, 328, 'Electronics', 'name_480', 'description_480', CURRENT_TIMESTAMP);
INSERT INTO Item (item_id, transactions_id, store_id, price, item_type, name, description, created) VALUES (481, 381, 4, 237, 'Home', 'name_481', 'description_481', CURRENT_TIMESTAMP);
INSERT INTO Item (item_id, transactions_id, store_id, price, item_type, name, description, created) VALUES (482, 5, 7, 453, 'Toys', 'name_482', 'description_482', CURRENT_TIMESTAMP);
INSERT INTO Item (item_id, transactions_id, store_id, price, item_type, name, description, created) VALUES (483, 335, 6, 77, 'Health', 'name_483', 'description_483', CURRENT_TIMESTAMP);
INSERT INTO Item (item_id, transactions_id, store_id, price, item_type, name, description, created) VALUES (484, 11, 8, 56, 'Books', 'name_484', 'description_484', CURRENT_TIMESTAMP);
INSERT INTO Item (item_id, transactions_id, store_id, price, item_type, name, description, created) VALUES (485, 475, 11, 200, 'Books', 'name_485', 'description_485', CURRENT_TIMESTAMP);
INSERT INTO Item (item_id, transactions_id, store_id, price, item_type, name, description, created) VALUES (486, 478, 14, 461, 'Home', 'name_486', 'description_486', CURRENT_TIMESTAMP);
INSERT INTO Item (item_id, transactions_id, store_id, price, item_type, name, description, created) VALUES (487, 405, 6, 426, 'Toys', 'name_487', 'description_487', CURRENT_TIMESTAMP);
INSERT INTO Item (item_id, transactions_id, store_id, price, item_type, name, description, created) VALUES (488, 61, 9, 84, 'Home', 'name_488', 'description_488', CURRENT_TIMESTAMP);
INSERT INTO Item (item_id, transactions_id, store_id, price, item_type, name, description, created) VALUES (489, 68, 14, 297, 'Electronics', 'name_489', 'description_489', CURRENT_TIMESTAMP);
INSERT INTO Item (item_id, transactions_id, store_id, price, item_type, name, description, created) VALUES (490, 324, 7, 256, 'Health', 'name_490', 'description_490', CURRENT_TIMESTAMP);
INSERT INTO Item (item_id, transactions_id, store_id, price, item_type, name, description, created) VALUES (491, 361, 1, 231, 'Toys', 'name_491', 'description_491', CURRENT_TIMESTAMP);
INSERT INTO Item (item_id, transactions_id, store_id, price, item_type, name, description, created) VALUES (492, 101, 4, 142, 'Health', 'name_492', 'description_492', CURRENT_TIMESTAMP);
INSERT INTO Item (item_id, transactions_id, store_id, price, item_type, name, description, created) VALUES (493, 64, 6, 333, 'Electronics', 'name_493', 'description_493', CURRENT_TIMESTAMP);
INSERT INTO Item (item_id, transactions_id, store_id, price, item_type, name, description, created) VALUES (494, 101, 6, 49, 'Electronics', 'name_494', 'description_494', CURRENT_TIMESTAMP);
INSERT INTO Item (item_id, transactions_id, store_id, price, item_type, name, description, created) VALUES (495, 247, 11, 182, 'Health', 'name_495', 'description_495', CURRENT_TIMESTAMP);
INSERT INTO Item (item_id, transactions_id, store_id, price, item_type, name, description, created) VALUES (496, 494, 5, 495, 'Health', 'name_496', 'description_496', CURRENT_TIMESTAMP);
INSERT INTO Item (item_id, transactions_id, store_id, price, item_type, name, description, created) VALUES (497, 417, 2, 51, 'Toys', 'name_497', 'description_497', CURRENT_TIMESTAMP);
INSERT INTO Item (item_id, transactions_id, store_id, price, item_type, name, description, created) VALUES (498, 5, 5, 250, 'Toys', 'name_498', 'description_498', CURRENT_TIMESTAMP);
INSERT INTO Item (item_id, transactions_id, store_id, price, item_type, name, description, created) VALUES (499, 437, 4, 49, 'Electronics', 'name_499', 'description_499', CURRENT_TIMESTAMP);
INSERT INTO Item (item_id, transactions_id, store_id, price, item_type, name, description, created) VALUES (500, 433, 13, 37, 'Health', 'name_500', 'description_500', CURRENT_TIMESTAMP);
INSERT INTO Item (item_id, transactions_id, store_id, price, item_type, name, description, created) VALUES (501, 158, 10, 500, 'Toys', 'name_501', 'description_501', CURRENT_TIMESTAMP);
INSERT INTO Item (item_id, transactions_id, store_id, price, item_type, name, description, created) VALUES (502, 362, 1, 204, 'Health', 'name_502', 'description_502', CURRENT_TIMESTAMP);
INSERT INTO Item (item_id, transactions_id, store_id, price, item_type, name, description, created) VALUES (503, 397, 3, 396, 'Health', 'name_503', 'description_503', CURRENT_TIMESTAMP);
INSERT INTO Item (item_id, transactions_id, store_id, price, item_type, name, description, created) VALUES (504, 239, 4, 20, 'Toys', 'name_504', 'description_504', CURRENT_TIMESTAMP);
INSERT INTO Item (item_id, transactions_id, store_id, price, item_type, name, description, created) VALUES (505, 431, 8, 152, 'Toys', 'name_505', 'description_505', CURRENT_TIMESTAMP);
INSERT INTO Item (item_id, transactions_id, store_id, price, item_type, name, description, created) VALUES (506, 279, 11, 63, 'Books', 'name_506', 'description_506', CURRENT_TIMESTAMP);
INSERT INTO Item (item_id, transactions_id, store_id, price, item_type, name, description, created) VALUES (507, 166, 2, 428, 'Books', 'name_507', 'description_507', CURRENT_TIMESTAMP);
INSERT INTO Item (item_id, transactions_id, store_id, price, item_type, name, description, created) VALUES (508, 481, 5, 110, 'Toys', 'name_508', 'description_508', CURRENT_TIMESTAMP);
INSERT INTO Item (item_id, transactions_id, store_id, price, item_type, name, description, created) VALUES (509, 155, 2, 306, 'Books', 'name_509', 'description_509', CURRENT_TIMESTAMP);
INSERT INTO Item (item_id, transactions_id, store_id, price, item_type, name, description, created) VALUES (510, 67, 5, 249, 'Home', 'name_510', 'description_510', CURRENT_TIMESTAMP);
INSERT INTO Item (item_id, transactions_id, store_id, price, item_type, name, description, created) VALUES (511, 409, 3, 510, 'Toys', 'name_511', 'description_511', CURRENT_TIMESTAMP);
INSERT INTO Item (item_id, transactions_id, store_id, price, item_type, name, description, created) VALUES (512, 58, 1, 90, 'Toys', 'name_512', 'description_512', CURRENT_TIMESTAMP);
INSERT INTO Item (item_id, transactions_id, store_id, price, item_type, name, description, created) VALUES (513, 446, 6, 115, 'Home', 'name_513', 'description_513', CURRENT_TIMESTAMP);
INSERT INTO Item (item_id, transactions_id, store_id, price, item_type, name, description, created) VALUES (514, 48, 1, 187, 'Books', 'name_514', 'description_514', CURRENT_TIMESTAMP);
INSERT INTO Item (item_id, transactions_id, store_id, price, item_type, name, description, created) VALUES (515, 279, 6, 490, 'Home', 'name_515', 'description_515', CURRENT_TIMESTAMP);
INSERT INTO Item (item_id, transactions_id, store_id, price, item_type, name, description, created) VALUES (516, 378, 8, 277, 'Books', 'name_516', 'description_516', CURRENT_TIMESTAMP);
INSERT INTO Item (item_id, transactions_id, store_id, price, item_type, name, description, created) VALUES (517, 401, 7, 158, 'Health', 'name_517', 'description_517', CURRENT_TIMESTAMP);
INSERT INTO Item (item_id, transactions_id, store_id, price, item_type, name, description, created) VALUES (518, 189, 9, 166, 'Electronics', 'name_518', 'description_518', CURRENT_TIMESTAMP);
INSERT INTO Item (item_id, transactions_id, store_id, price, item_type, name, description, created) VALUES (519, 261, 9, 39, 'Home', 'name_519', 'description_519', CURRENT_TIMESTAMP);
INSERT INTO Item (item_id, transactions_id, store_id, price, item_type, name, description, created) VALUES (520, 393, 12, 224, 'Books', 'name_520', 'description_520', CURRENT_TIMESTAMP);
INSERT INTO Item (item_id, transactions_id, store_id, price, item_type, name, description, created) VALUES (521, 245, 1, 418, 'Home', 'name_521', 'description_521', CURRENT_TIMESTAMP);
INSERT INTO Item (item_id, transactions_id, store_id, price, item_type, name, description, created) VALUES (522, 422, 8, 419, 'Electronics', 'name_522', 'description_522', CURRENT_TIMESTAMP);
INSERT INTO Item (item_id, transactions_id, store_id, price, item_type, name, description, created) VALUES (523, 241, 2, 367, 'Books', 'name_523', 'description_523', CURRENT_TIMESTAMP);
INSERT INTO Item (item_id, transactions_id, store_id, price, item_type, name, description, created) VALUES (524, 112, 12, 274, 'Toys', 'name_524', 'description_524', CURRENT_TIMESTAMP);
INSERT INTO Item (item_id, transactions_id, store_id, price, item_type, name, description, created) VALUES (525, 180, 5, 2, 'Home', 'name_525', 'description_525', CURRENT_TIMESTAMP);
INSERT INTO Item (item_id, transactions_id, store_id, price, item_type, name, description, created) VALUES (526, 200, 10, 218, 'Toys', 'name_526', 'description_526', CURRENT_TIMESTAMP);
INSERT INTO Item (item_id, transactions_id, store_id, price, item_type, name, description, created) VALUES (527, 385, 6, 367, 'Electronics', 'name_527', 'description_527', CURRENT_TIMESTAMP);
INSERT INTO Item (item_id, transactions_id, store_id, price, item_type, name, description, created) VALUES (528, 271, 9, 3, 'Home', 'name_528', 'description_528', CURRENT_TIMESTAMP);
INSERT INTO Item (item_id, transactions_id, store_id, price, item_type, name, description, created) VALUES (529, 44, 1, 370, 'Electronics', 'name_529', 'description_529', CURRENT_TIMESTAMP);
INSERT INTO Item (item_id, transactions_id, store_id, price, item_type, name, description, created) VALUES (530, 426, 11, 79, 'Electronics', 'name_530', 'description_530', CURRENT_TIMESTAMP);
INSERT INTO Item (item_id, transactions_id, store_id, price, item_type, name, description, created) VALUES (531, 101, 13, 147, 'Toys', 'name_531', 'description_531', CURRENT_TIMESTAMP);
INSERT INTO Item (item_id, transactions_id, store_id, price, item_type, name, description, created) VALUES (532, 191, 3, 27, 'Books', 'name_532', 'description_532', CURRENT_TIMESTAMP);
INSERT INTO Item (item_id, transactions_id, store_id, price, item_type, name, description, created) VALUES (533, 146, 6, 209, 'Home', 'name_533', 'description_533', CURRENT_TIMESTAMP);
INSERT INTO Item (item_id, transactions_id, store_id, price, item_type, name, description, created) VALUES (534, 232, 13, 144, 'Health', 'name_534', 'description_534', CURRENT_TIMESTAMP);
INSERT INTO Item (item_id, transactions_id, store_id, price, item_type, name, description, created) VALUES (535, 479, 9, 207, 'Books', 'name_535', 'description_535', CURRENT_TIMESTAMP);
INSERT INTO Item (item_id, transactions_id, store_id, price, item_type, name, description, created) VALUES (536, 175, 4, 475, 'Books', 'name_536', 'description_536', CURRENT_TIMESTAMP);
INSERT INTO Item (item_id, transactions_id, store_id, price, item_type, name, description, created) VALUES (537, 163, 6, 65, 'Electronics', 'name_537', 'description_537', CURRENT_TIMESTAMP);
INSERT INTO Item (item_id, transactions_id, store_id, price, item_type, name, description, created) VALUES (538, 98, 4, 67, 'Books', 'name_538', 'description_538', CURRENT_TIMESTAMP);
INSERT INTO Item (item_id, transactions_id, store_id, price, item_type, name, description, created) VALUES (539, 414, 11, 396, 'Books', 'name_539', 'description_539', CURRENT_TIMESTAMP);
INSERT INTO Item (item_id, transactions_id, store_id, price, item_type, name, description, created) VALUES (540, 276, 11, 404, 'Health', 'name_540', 'description_540', CURRENT_TIMESTAMP);
INSERT INTO Item (item_id, transactions_id, store_id, price, item_type, name, description, created) VALUES (541, 183, 6, 287, 'Books', 'name_541', 'description_541', CURRENT_TIMESTAMP);
INSERT INTO Item (item_id, transactions_id, store_id, price, item_type, name, description, created) VALUES (542, 269, 13, 262, 'Toys', 'name_542', 'description_542', CURRENT_TIMESTAMP);
INSERT INTO Item (item_id, transactions_id, store_id, price, item_type, name, description, created) VALUES (543, 5, 11, 499, 'Books', 'name_543', 'description_543', CURRENT_TIMESTAMP);
INSERT INTO Item (item_id, transactions_id, store_id, price, item_type, name, description, created) VALUES (544, 472, 13, 398, 'Health', 'name_544', 'description_544', CURRENT_TIMESTAMP);
INSERT INTO Item (item_id, transactions_id, store_id, price, item_type, name, description, created) VALUES (545, 389, 8, 132, 'Toys', 'name_545', 'description_545', CURRENT_TIMESTAMP);
INSERT INTO Item (item_id, transactions_id, store_id, price, item_type, name, description, created) VALUES (546, 445, 2, 289, 'Books', 'name_546', 'description_546', CURRENT_TIMESTAMP);
INSERT INTO Item (item_id, transactions_id, store_id, price, item_type, name, description, created) VALUES (547, 421, 5, 48, 'Home', 'name_547', 'description_547', CURRENT_TIMESTAMP);
INSERT INTO Item (item_id, transactions_id, store_id, price, item_type, name, description, created) VALUES (548, 366, 13, 500, 'Electronics', 'name_548', 'description_548', CURRENT_TIMESTAMP);
INSERT INTO Item (item_id, transactions_id, store_id, price, item_type, name, description, created) VALUES (549, 449, 5, 345, 'Toys', 'name_549', 'description_549', CURRENT_TIMESTAMP);
INSERT INTO Item (item_id, transactions_id, store_id, price, item_type, name, description, created) VALUES (550, 481, 7, 331, 'Toys', 'name_550', 'description_550', CURRENT_TIMESTAMP);
INSERT INTO Item (item_id, transactions_id, store_id, price, item_type, name, description, created) VALUES (551, 339, 9, 142, 'Books', 'name_551', 'description_551', CURRENT_TIMESTAMP);
INSERT INTO Item (item_id, transactions_id, store_id, price, item_type, name, description, created) VALUES (552, 276, 3, 205, 'Home', 'name_552', 'description_552', CURRENT_TIMESTAMP);
INSERT INTO Item (item_id, transactions_id, store_id, price, item_type, name, description, created) VALUES (553, 284, 4, 224, 'Home', 'name_553', 'description_553', CURRENT_TIMESTAMP);
INSERT INTO Item (item_id, transactions_id, store_id, price, item_type, name, description, created) VALUES (554, 435, 6, 238, 'Electronics', 'name_554', 'description_554', CURRENT_TIMESTAMP);
INSERT INTO Item (item_id, transactions_id, store_id, price, item_type, name, description, created) VALUES (555, 188, 7, 434, 'Toys', 'name_555', 'description_555', CURRENT_TIMESTAMP);
INSERT INTO Item (item_id, transactions_id, store_id, price, item_type, name, description, created) VALUES (556, 233, 2, 90, 'Electronics', 'name_556', 'description_556', CURRENT_TIMESTAMP);
INSERT INTO Item (item_id, transactions_id, store_id, price, item_type, name, description, created) VALUES (557, 220, 14, 258, 'Electronics', 'name_557', 'description_557', CURRENT_TIMESTAMP);
INSERT INTO Item (item_id, transactions_id, store_id, price, item_type, name, description, created) VALUES (558, 436, 6, 368, 'Health', 'name_558', 'description_558', CURRENT_TIMESTAMP);
INSERT INTO Item (item_id, transactions_id, store_id, price, item_type, name, description, created) VALUES (559, 218, 6, 227, 'Health', 'name_559', 'description_559', CURRENT_TIMESTAMP);
INSERT INTO Item (item_id, transactions_id, store_id, price, item_type, name, description, created) VALUES (560, 28, 13, 259, 'Health', 'name_560', 'description_560', CURRENT_TIMESTAMP);
INSERT INTO Item (item_id, transactions_id, store_id, price, item_type, name, description, created) VALUES (561, 403, 13, 559, 'Health', 'name_561', 'description_561', CURRENT_TIMESTAMP);
INSERT INTO Item (item_id, transactions_id, store_id, price, item_type, name, description, created) VALUES (562, 497, 3, 462, 'Toys', 'name_562', 'description_562', CURRENT_TIMESTAMP);
INSERT INTO Item (item_id, transactions_id, store_id, price, item_type, name, description, created) VALUES (563, 456, 6, 110, 'Books', 'name_563', 'description_563', CURRENT_TIMESTAMP);
INSERT INTO Item (item_id, transactions_id, store_id, price, item_type, name, description, created) VALUES (564, 417, 12, 208, 'Toys', 'name_564', 'description_564', CURRENT_TIMESTAMP);
INSERT INTO Item (item_id, transactions_id, store_id, price, item_type, name, description, created) VALUES (565, 371, 8, 66, 'Health', 'name_565', 'description_565', CURRENT_TIMESTAMP);
INSERT INTO Item (item_id, transactions_id, store_id, price, item_type, name, description, created) VALUES (566, 95, 6, 154, 'Electronics', 'name_566', 'description_566', CURRENT_TIMESTAMP);
INSERT INTO Item (item_id, transactions_id, store_id, price, item_type, name, description, created) VALUES (567, 250, 1, 496, 'Books', 'name_567', 'description_567', CURRENT_TIMESTAMP);
INSERT INTO Item (item_id, transactions_id, store_id, price, item_type, name, description, created) VALUES (568, 440, 4, 345, 'Toys', 'name_568', 'description_568', CURRENT_TIMESTAMP);
INSERT INTO Item (item_id, transactions_id, store_id, price, item_type, name, description, created) VALUES (569, 433, 2, 286, 'Home', 'name_569', 'description_569', CURRENT_TIMESTAMP);
INSERT INTO Item (item_id, transactions_id, store_id, price, item_type, name, description, created) VALUES (570, 256, 7, 184, 'Home', 'name_570', 'description_570', CURRENT_TIMESTAMP);
INSERT INTO Item (item_id, transactions_id, store_id, price, item_type, name, description, created) VALUES (571, 259, 8, 111, 'Electronics', 'name_571', 'description_571', CURRENT_TIMESTAMP);
INSERT INTO Item (item_id, transactions_id, store_id, price, item_type, name, description, created) VALUES (572, 381, 2, 50, 'Health', 'name_572', 'description_572', CURRENT_TIMESTAMP);
INSERT INTO Item (item_id, transactions_id, store_id, price, item_type, name, description, created) VALUES (573, 340, 7, 310, 'Toys', 'name_573', 'description_573', CURRENT_TIMESTAMP);
INSERT INTO Item (item_id, transactions_id, store_id, price, item_type, name, description, created) VALUES (574, 477, 14, 89, 'Home', 'name_574', 'description_574', CURRENT_TIMESTAMP);
INSERT INTO Item (item_id, transactions_id, store_id, price, item_type, name, description, created) VALUES (575, 385, 13, 310, 'Health', 'name_575', 'description_575', CURRENT_TIMESTAMP);
INSERT INTO Item (item_id, transactions_id, store_id, price, item_type, name, description, created) VALUES (576, 96, 12, 205, 'Toys', 'name_576', 'description_576', CURRENT_TIMESTAMP);
INSERT INTO Item (item_id, transactions_id, store_id, price, item_type, name, description, created) VALUES (577, 390, 5, 310, 'Health', 'name_577', 'description_577', CURRENT_TIMESTAMP);
INSERT INTO Item (item_id, transactions_id, store_id, price, item_type, name, description, created) VALUES (578, 219, 3, 398, 'Toys', 'name_578', 'description_578', CURRENT_TIMESTAMP);
INSERT INTO Item (item_id, transactions_id, store_id, price, item_type, name, description, created) VALUES (579, 322, 11, 272, 'Books', 'name_579', 'description_579', CURRENT_TIMESTAMP);
INSERT INTO Item (item_id, transactions_id, store_id, price, item_type, name, description, created) VALUES (580, 80, 9, 89, 'Electronics', 'name_580', 'description_580', CURRENT_TIMESTAMP);
INSERT INTO Item (item_id, transactions_id, store_id, price, item_type, name, description, created) VALUES (581, 416, 10, 224, 'Electronics', 'name_581', 'description_581', CURRENT_TIMESTAMP);
INSERT INTO Item (item_id, transactions_id, store_id, price, item_type, name, description, created) VALUES (582, 405, 2, 103, 'Toys', 'name_582', 'description_582', CURRENT_TIMESTAMP);
INSERT INTO Item (item_id, transactions_id, store_id, price, item_type, name, description, created) VALUES (583, 304, 12, 505, 'Toys', 'name_583', 'description_583', CURRENT_TIMESTAMP);
INSERT INTO Item (item_id, transactions_id, store_id, price, item_type, name, description, created) VALUES (584, 240, 8, 299, 'Electronics', 'name_584', 'description_584', CURRENT_TIMESTAMP);
INSERT INTO Item (item_id, transactions_id, store_id, price, item_type, name, description, created) VALUES (585, 159, 8, 222, 'Home', 'name_585', 'description_585', CURRENT_TIMESTAMP);
INSERT INTO Item (item_id, transactions_id, store_id, price, item_type, name, description, created) VALUES (586, 310, 13, 278, 'Health', 'name_586', 'description_586', CURRENT_TIMESTAMP);
INSERT INTO Item (item_id, transactions_id, store_id, price, item_type, name, description, created) VALUES (587, 297, 10, 91, 'Books', 'name_587', 'description_587', CURRENT_TIMESTAMP);
INSERT INTO Item (item_id, transactions_id, store_id, price, item_type, name, description, created) VALUES (588, 282, 1, 404, 'Toys', 'name_588', 'description_588', CURRENT_TIMESTAMP);
INSERT INTO Item (item_id, transactions_id, store_id, price, item_type, name, description, created) VALUES (589, 470, 7, 18, 'Health', 'name_589', 'description_589', CURRENT_TIMESTAMP);
INSERT INTO Item (item_id, transactions_id, store_id, price, item_type, name, description, created) VALUES (590, 426, 14, 190, 'Home', 'name_590', 'description_590', CURRENT_TIMESTAMP);
INSERT INTO Item (item_id, transactions_id, store_id, price, item_type, name, description, created) VALUES (591, 129, 5, 140, 'Toys', 'name_591', 'description_591', CURRENT_TIMESTAMP);
INSERT INTO Item (item_id, transactions_id, store_id, price, item_type, name, description, created) VALUES (592, 360, 6, 163, 'Books', 'name_592', 'description_592', CURRENT_TIMESTAMP);
INSERT INTO Item (item_id, transactions_id, store_id, price, item_type, name, description, created) VALUES (593, 48, 1, 516, 'Books', 'name_593', 'description_593', CURRENT_TIMESTAMP);
INSERT INTO Item (item_id, transactions_id, store_id, price, item_type, name, description, created) VALUES (594, 34, 5, 256, 'Toys', 'name_594', 'description_594', CURRENT_TIMESTAMP);
INSERT INTO Item (item_id, transactions_id, store_id, price, item_type, name, description, created) VALUES (595, 222, 9, 467, 'Books', 'name_595', 'description_595', CURRENT_TIMESTAMP);
INSERT INTO Item (item_id, transactions_id, store_id, price, item_type, name, description, created) VALUES (596, 305, 4, 299, 'Books', 'name_596', 'description_596', CURRENT_TIMESTAMP);
INSERT INTO Item (item_id, transactions_id, store_id, price, item_type, name, description, created) VALUES (597, 295, 10, 125, 'Health', 'name_597', 'description_597', CURRENT_TIMESTAMP);
INSERT INTO Item (item_id, transactions_id, store_id, price, item_type, name, description, created) VALUES (598, 317, 1, 278, 'Electronics', 'name_598', 'description_598', CURRENT_TIMESTAMP);
INSERT INTO Item (item_id, transactions_id, store_id, price, item_type, name, description, created) VALUES (599, 245, 9, 578, 'Home', 'name_599', 'description_599', CURRENT_TIMESTAMP);
INSERT INTO Item (item_id, transactions_id, store_id, price, item_type, name, description, created) VALUES (600, 104, 5, 451, 'Health', 'name_600', 'description_600', CURRENT_TIMESTAMP);
INSERT INTO Item (item_id, transactions_id, store_id, price, item_type, name, description, created) VALUES (601, 31, 12, 200, 'Toys', 'name_601', 'description_601', CURRENT_TIMESTAMP);
INSERT INTO Item (item_id, transactions_id, store_id, price, item_type, name, description, created) VALUES (602, 126, 5, 479, 'Home', 'name_602', 'description_602', CURRENT_TIMESTAMP);
INSERT INTO Item (item_id, transactions_id, store_id, price, item_type, name, description, created) VALUES (603, 488, 1, 318, 'Books', 'name_603', 'description_603', CURRENT_TIMESTAMP);
INSERT INTO Item (item_id, transactions_id, store_id, price, item_type, name, description, created) VALUES (604, 284, 11, 447, 'Health', 'name_604', 'description_604', CURRENT_TIMESTAMP);
INSERT INTO Item (item_id, transactions_id, store_id, price, item_type, name, description, created) VALUES (605, 229, 5, 6, 'Home', 'name_605', 'description_605', CURRENT_TIMESTAMP);
INSERT INTO Item (item_id, transactions_id, store_id, price, item_type, name, description, created) VALUES (606, 97, 11, 368, 'Electronics', 'name_606', 'description_606', CURRENT_TIMESTAMP);
INSERT INTO Item (item_id, transactions_id, store_id, price, item_type, name, description, created) VALUES (607, 17, 7, 424, 'Health', 'name_607', 'description_607', CURRENT_TIMESTAMP);
INSERT INTO Item (item_id, transactions_id, store_id, price, item_type, name, description, created) VALUES (608, 192, 14, 384, 'Books', 'name_608', 'description_608', CURRENT_TIMESTAMP);
INSERT INTO Item (item_id, transactions_id, store_id, price, item_type, name, description, created) VALUES (609, 82, 12, 307, 'Books', 'name_609', 'description_609', CURRENT_TIMESTAMP);
INSERT INTO Item (item_id, transactions_id, store_id, price, item_type, name, description, created) VALUES (610, 199, 8, 366, 'Health', 'name_610', 'description_610', CURRENT_TIMESTAMP);
INSERT INTO Item (item_id, transactions_id, store_id, price, item_type, name, description, created) VALUES (611, 318, 7, 98, 'Books', 'name_611', 'description_611', CURRENT_TIMESTAMP);
INSERT INTO Item (item_id, transactions_id, store_id, price, item_type, name, description, created) VALUES (612, 149, 5, 251, 'Home', 'name_612', 'description_612', CURRENT_TIMESTAMP);
INSERT INTO Item (item_id, transactions_id, store_id, price, item_type, name, description, created) VALUES (613, 122, 5, 237, 'Home', 'name_613', 'description_613', CURRENT_TIMESTAMP);
INSERT INTO Item (item_id, transactions_id, store_id, price, item_type, name, description, created) VALUES (614, 323, 11, 200, 'Home', 'name_614', 'description_614', CURRENT_TIMESTAMP);
INSERT INTO Item (item_id, transactions_id, store_id, price, item_type, name, description, created) VALUES (615, 112, 6, 187, 'Health', 'name_615', 'description_615', CURRENT_TIMESTAMP);
INSERT INTO Item (item_id, transactions_id, store_id, price, item_type, name, description, created) VALUES (616, 148, 4, 140, 'Health', 'name_616', 'description_616', CURRENT_TIMESTAMP);
INSERT INTO Item (item_id, transactions_id, store_id, price, item_type, name, description, created) VALUES (617, 345, 14, 364, 'Health', 'name_617', 'description_617', CURRENT_TIMESTAMP);
INSERT INTO Item (item_id, transactions_id, store_id, price, item_type, name, description, created) VALUES (618, 301, 6, 163, 'Toys', 'name_618', 'description_618', CURRENT_TIMESTAMP);
INSERT INTO Item (item_id, transactions_id, store_id, price, item_type, name, description, created) VALUES (619, 196, 1, 31, 'Toys', 'name_619', 'description_619', CURRENT_TIMESTAMP);
INSERT INTO Item (item_id, transactions_id, store_id, price, item_type, name, description, created) VALUES (620, 311, 6, 536, 'Toys', 'name_620', 'description_620', CURRENT_TIMESTAMP);
INSERT INTO Item (item_id, transactions_id, store_id, price, item_type, name, description, created) VALUES (621, 243, 4, 473, 'Health', 'name_621', 'description_621', CURRENT_TIMESTAMP);
INSERT INTO Item (item_id, transactions_id, store_id, price, item_type, name, description, created) VALUES (622, 135, 3, 298, 'Health', 'name_622', 'description_622', CURRENT_TIMESTAMP);
INSERT INTO Item (item_id, transactions_id, store_id, price, item_type, name, description, created) VALUES (623, 396, 14, 307, 'Home', 'name_623', 'description_623', CURRENT_TIMESTAMP);
INSERT INTO Item (item_id, transactions_id, store_id, price, item_type, name, description, created) VALUES (624, 213, 12, 455, 'Electronics', 'name_624', 'description_624', CURRENT_TIMESTAMP);
INSERT INTO Item (item_id, transactions_id, store_id, price, item_type, name, description, created) VALUES (625, 318, 4, 579, 'Electronics', 'name_625', 'description_625', CURRENT_TIMESTAMP);
INSERT INTO Item (item_id, transactions_id, store_id, price, item_type, name, description, created) VALUES (626, 15, 5, 303, 'Toys', 'name_626', 'description_626', CURRENT_TIMESTAMP);
INSERT INTO Item (item_id, transactions_id, store_id, price, item_type, name, description, created) VALUES (627, 113, 13, 209, 'Health', 'name_627', 'description_627', CURRENT_TIMESTAMP);
INSERT INTO Item (item_id, transactions_id, store_id, price, item_type, name, description, created) VALUES (628, 32, 13, 10, 'Electronics', 'name_628', 'description_628', CURRENT_TIMESTAMP);
INSERT INTO Item (item_id, transactions_id, store_id, price, item_type, name, description, created) VALUES (629, 215, 6, 195, 'Health', 'name_629', 'description_629', CURRENT_TIMESTAMP);
INSERT INTO Item (item_id, transactions_id, store_id, price, item_type, name, description, created) VALUES (630, 473, 1, 454, 'Toys', 'name_630', 'description_630', CURRENT_TIMESTAMP);
INSERT INTO Item (item_id, transactions_id, store_id, price, item_type, name, description, created) VALUES (631, 435, 13, 268, 'Books', 'name_631', 'description_631', CURRENT_TIMESTAMP);
INSERT INTO Item (item_id, transactions_id, store_id, price, item_type, name, description, created) VALUES (632, 146, 11, 497, 'Books', 'name_632', 'description_632', CURRENT_TIMESTAMP);
INSERT INTO Item (item_id, transactions_id, store_id, price, item_type, name, description, created) VALUES (633, 365, 11, 94, 'Books', 'name_633', 'description_633', CURRENT_TIMESTAMP);
INSERT INTO Item (item_id, transactions_id, store_id, price, item_type, name, description, created) VALUES (634, 495, 3, 324, 'Health', 'name_634', 'description_634', CURRENT_TIMESTAMP);
INSERT INTO Item (item_id, transactions_id, store_id, price, item_type, name, description, created) VALUES (635, 388, 4, 217, 'Electronics', 'name_635', 'description_635', CURRENT_TIMESTAMP);
INSERT INTO Item (item_id, transactions_id, store_id, price, item_type, name, description, created) VALUES (636, 38, 9, 494, 'Toys', 'name_636', 'description_636', CURRENT_TIMESTAMP);
INSERT INTO Item (item_id, transactions_id, store_id, price, item_type, name, description, created) VALUES (637, 251, 1, 248, 'Electronics', 'name_637', 'description_637', CURRENT_TIMESTAMP);
INSERT INTO Item (item_id, transactions_id, store_id, price, item_type, name, description, created) VALUES (638, 498, 5, 179, 'Health', 'name_638', 'description_638', CURRENT_TIMESTAMP);
INSERT INTO Item (item_id, transactions_id, store_id, price, item_type, name, description, created) VALUES (639, 464, 5, 104, 'Home', 'name_639', 'description_639', CURRENT_TIMESTAMP);
INSERT INTO Item (item_id, transactions_id, store_id, price, item_type, name, description, created) VALUES (640, 211, 3, 382, 'Toys', 'name_640', 'description_640', CURRENT_TIMESTAMP);
INSERT INTO Item (item_id, transactions_id, store_id, price, item_type, name, description, created) VALUES (641, 386, 6, 584, 'Books', 'name_641', 'description_641', CURRENT_TIMESTAMP);
INSERT INTO Item (item_id, transactions_id, store_id, price, item_type, name, description, created) VALUES (642, 6, 2, 125, 'Books', 'name_642', 'description_642', CURRENT_TIMESTAMP);
INSERT INTO Item (item_id, transactions_id, store_id, price, item_type, name, description, created) VALUES (643, 232, 10, 280, 'Health', 'name_643', 'description_643', CURRENT_TIMESTAMP);
INSERT INTO Item (item_id, transactions_id, store_id, price, item_type, name, description, created) VALUES (644, 170, 13, 182, 'Health', 'name_644', 'description_644', CURRENT_TIMESTAMP);
INSERT INTO Item (item_id, transactions_id, store_id, price, item_type, name, description, created) VALUES (645, 487, 1, 12, 'Electronics', 'name_645', 'description_645', CURRENT_TIMESTAMP);
INSERT INTO Item (item_id, transactions_id, store_id, price, item_type, name, description, created) VALUES (646, 64, 12, 521, 'Books', 'name_646', 'description_646', CURRENT_TIMESTAMP);
INSERT INTO Item (item_id, transactions_id, store_id, price, item_type, name, description, created) VALUES (647, 119, 12, 77, 'Electronics', 'name_647', 'description_647', CURRENT_TIMESTAMP);
INSERT INTO Item (item_id, transactions_id, store_id, price, item_type, name, description, created) VALUES (648, 476, 11, 533, 'Toys', 'name_648', 'description_648', CURRENT_TIMESTAMP);
INSERT INTO Item (item_id, transactions_id, store_id, price, item_type, name, description, created) VALUES (649, 66, 14, 309, 'Electronics', 'name_649', 'description_649', CURRENT_TIMESTAMP);
INSERT INTO Item (item_id, transactions_id, store_id, price, item_type, name, description, created) VALUES (650, 141, 12, 473, 'Toys', 'name_650', 'description_650', CURRENT_TIMESTAMP);
INSERT INTO Item (item_id, transactions_id, store_id, price, item_type, name, description, created) VALUES (651, 168, 1, 508, 'Toys', 'name_651', 'description_651', CURRENT_TIMESTAMP);
INSERT INTO Item (item_id, transactions_id, store_id, price, item_type, name, description, created) VALUES (652, 139, 13, 325, 'Toys', 'name_652', 'description_652', CURRENT_TIMESTAMP);
INSERT INTO Item (item_id, transactions_id, store_id, price, item_type, name, description, created) VALUES (653, 327, 2, 212, 'Health', 'name_653', 'description_653', CURRENT_TIMESTAMP);
INSERT INTO Item (item_id, transactions_id, store_id, price, item_type, name, description, created) VALUES (654, 90, 11, 384, 'Health', 'name_654', 'description_654', CURRENT_TIMESTAMP);
INSERT INTO Item (item_id, transactions_id, store_id, price, item_type, name, description, created) VALUES (655, 67, 5, 572, 'Electronics', 'name_655', 'description_655', CURRENT_TIMESTAMP);
INSERT INTO Item (item_id, transactions_id, store_id, price, item_type, name, description, created) VALUES (656, 252, 1, 629, 'Health', 'name_656', 'description_656', CURRENT_TIMESTAMP);
INSERT INTO Item (item_id, transactions_id, store_id, price, item_type, name, description, created) VALUES (657, 129, 10, 200, 'Toys', 'name_657', 'description_657', CURRENT_TIMESTAMP);
INSERT INTO Item (item_id, transactions_id, store_id, price, item_type, name, description, created) VALUES (658, 199, 13, 565, 'Books', 'name_658', 'description_658', CURRENT_TIMESTAMP);
INSERT INTO Item (item_id, transactions_id, store_id, price, item_type, name, description, created) VALUES (659, 397, 1, 349, 'Electronics', 'name_659', 'description_659', CURRENT_TIMESTAMP);
INSERT INTO Item (item_id, transactions_id, store_id, price, item_type, name, description, created) VALUES (660, 472, 4, 451, 'Home', 'name_660', 'description_660', CURRENT_TIMESTAMP);
INSERT INTO Item (item_id, transactions_id, store_id, price, item_type, name, description, created) VALUES (661, 34, 7, 506, 'Electronics', 'name_661', 'description_661', CURRENT_TIMESTAMP);
INSERT INTO Item (item_id, transactions_id, store_id, price, item_type, name, description, created) VALUES (662, 88, 2, 618, 'Books', 'name_662', 'description_662', CURRENT_TIMESTAMP);
INSERT INTO Item (item_id, transactions_id, store_id, price, item_type, name, description, created) VALUES (663, 108, 8, 415, 'Home', 'name_663', 'description_663', CURRENT_TIMESTAMP);
INSERT INTO Item (item_id, transactions_id, store_id, price, item_type, name, description, created) VALUES (664, 360, 1, 368, 'Home', 'name_664', 'description_664', CURRENT_TIMESTAMP);
INSERT INTO Item (item_id, transactions_id, store_id, price, item_type, name, description, created) VALUES (665, 437, 4, 121, 'Books', 'name_665', 'description_665', CURRENT_TIMESTAMP);
INSERT INTO Item (item_id, transactions_id, store_id, price, item_type, name, description, created) VALUES (666, 37, 4, 618, 'Health', 'name_666', 'description_666', CURRENT_TIMESTAMP);
INSERT INTO Item (item_id, transactions_id, store_id, price, item_type, name, description, created) VALUES (667, 200, 3, 234, 'Toys', 'name_667', 'description_667', CURRENT_TIMESTAMP);
INSERT INTO Item (item_id, transactions_id, store_id, price, item_type, name, description, created) VALUES (668, 363, 9, 90, 'Home', 'name_668', 'description_668', CURRENT_TIMESTAMP);
INSERT INTO Item (item_id, transactions_id, store_id, price, item_type, name, description, created) VALUES (669, 376, 1, 586, 'Electronics', 'name_669', 'description_669', CURRENT_TIMESTAMP);
INSERT INTO Item (item_id, transactions_id, store_id, price, item_type, name, description, created) VALUES (670, 124, 7, 402, 'Home', 'name_670', 'description_670', CURRENT_TIMESTAMP);
INSERT INTO Item (item_id, transactions_id, store_id, price, item_type, name, description, created) VALUES (671, 348, 13, 605, 'Health', 'name_671', 'description_671', CURRENT_TIMESTAMP);
INSERT INTO Item (item_id, transactions_id, store_id, price, item_type, name, description, created) VALUES (672, 198, 6, 85, 'Toys', 'name_672', 'description_672', CURRENT_TIMESTAMP);
INSERT INTO Item (item_id, transactions_id, store_id, price, item_type, name, description, created) VALUES (673, 439, 5, 315, 'Books', 'name_673', 'description_673', CURRENT_TIMESTAMP);
INSERT INTO Item (item_id, transactions_id, store_id, price, item_type, name, description, created) VALUES (674, 160, 2, 98, 'Toys', 'name_674', 'description_674', CURRENT_TIMESTAMP);
INSERT INTO Item (item_id, transactions_id, store_id, price, item_type, name, description, created) VALUES (675, 450, 8, 287, 'Health', 'name_675', 'description_675', CURRENT_TIMESTAMP);
INSERT INTO Item (item_id, transactions_id, store_id, price, item_type, name, description, created) VALUES (676, 349, 1, 577, 'Books', 'name_676', 'description_676', CURRENT_TIMESTAMP);
INSERT INTO Item (item_id, transactions_id, store_id, price, item_type, name, description, created) VALUES (677, 491, 9, 298, 'Books', 'name_677', 'description_677', CURRENT_TIMESTAMP);
INSERT INTO Item (item_id, transactions_id, store_id, price, item_type, name, description, created) VALUES (678, 304, 12, 576, 'Electronics', 'name_678', 'description_678', CURRENT_TIMESTAMP);
INSERT INTO Item (item_id, transactions_id, store_id, price, item_type, name, description, created) VALUES (679, 220, 14, 116, 'Books', 'name_679', 'description_679', CURRENT_TIMESTAMP);
INSERT INTO Item (item_id, transactions_id, store_id, price, item_type, name, description, created) VALUES (680, 52, 9, 499, 'Health', 'name_680', 'description_680', CURRENT_TIMESTAMP);
INSERT INTO Item (item_id, transactions_id, store_id, price, item_type, name, description, created) VALUES (681, 304, 7, 438, 'Home', 'name_681', 'description_681', CURRENT_TIMESTAMP);
INSERT INTO Item (item_id, transactions_id, store_id, price, item_type, name, description, created) VALUES (682, 285, 1, 229, 'Toys', 'name_682', 'description_682', CURRENT_TIMESTAMP);
INSERT INTO Item (item_id, transactions_id, store_id, price, item_type, name, description, created) VALUES (683, 214, 12, 263, 'Home', 'name_683', 'description_683', CURRENT_TIMESTAMP);
INSERT INTO Item (item_id, transactions_id, store_id, price, item_type, name, description, created) VALUES (684, 64, 8, 318, 'Health', 'name_684', 'description_684', CURRENT_TIMESTAMP);
INSERT INTO Item (item_id, transactions_id, store_id, price, item_type, name, description, created) VALUES (685, 103, 13, 595, 'Books', 'name_685', 'description_685', CURRENT_TIMESTAMP);
INSERT INTO Item (item_id, transactions_id, store_id, price, item_type, name, description, created) VALUES (686, 178, 11, 303, 'Electronics', 'name_686', 'description_686', CURRENT_TIMESTAMP);
INSERT INTO Item (item_id, transactions_id, store_id, price, item_type, name, description, created) VALUES (687, 338, 14, 32, 'Electronics', 'name_687', 'description_687', CURRENT_TIMESTAMP);
INSERT INTO Item (item_id, transactions_id, store_id, price, item_type, name, description, created) VALUES (688, 228, 7, 117, 'Electronics', 'name_688', 'description_688', CURRENT_TIMESTAMP);
INSERT INTO Item (item_id, transactions_id, store_id, price, item_type, name, description, created) VALUES (689, 458, 5, 225, 'Electronics', 'name_689', 'description_689', CURRENT_TIMESTAMP);
INSERT INTO Item (item_id, transactions_id, store_id, price, item_type, name, description, created) VALUES (690, 331, 10, 612, 'Electronics', 'name_690', 'description_690', CURRENT_TIMESTAMP);
INSERT INTO Item (item_id, transactions_id, store_id, price, item_type, name, description, created) VALUES (691, 197, 9, 348, 'Books', 'name_691', 'description_691', CURRENT_TIMESTAMP);
INSERT INTO Item (item_id, transactions_id, store_id, price, item_type, name, description, created) VALUES (692, 263, 4, 499, 'Electronics', 'name_692', 'description_692', CURRENT_TIMESTAMP);
INSERT INTO Item (item_id, transactions_id, store_id, price, item_type, name, description, created) VALUES (693, 132, 1, 316, 'Toys', 'name_693', 'description_693', CURRENT_TIMESTAMP);
INSERT INTO Item (item_id, transactions_id, store_id, price, item_type, name, description, created) VALUES (694, 398, 3, 447, 'Books', 'name_694', 'description_694', CURRENT_TIMESTAMP);
INSERT INTO Item (item_id, transactions_id, store_id, price, item_type, name, description, created) VALUES (695, 481, 10, 64, 'Electronics', 'name_695', 'description_695', CURRENT_TIMESTAMP);
INSERT INTO Item (item_id, transactions_id, store_id, price, item_type, name, description, created) VALUES (696, 464, 5, 63, 'Toys', 'name_696', 'description_696', CURRENT_TIMESTAMP);
INSERT INTO Item (item_id, transactions_id, store_id, price, item_type, name, description, created) VALUES (697, 184, 9, 311, 'Books', 'name_697', 'description_697', CURRENT_TIMESTAMP);
INSERT INTO Item (item_id, transactions_id, store_id, price, item_type, name, description, created) VALUES (698, 442, 11, 369, 'Health', 'name_698', 'description_698', CURRENT_TIMESTAMP);
INSERT INTO Item (item_id, transactions_id, store_id, price, item_type, name, description, created) VALUES (699, 291, 9, 606, 'Home', 'name_699', 'description_699', CURRENT_TIMESTAMP);
INSERT INTO Item (item_id, transactions_id, store_id, price, item_type, name, description, created) VALUES (700, 213, 9, 173, 'Books', 'name_700', 'description_700', CURRENT_TIMESTAMP);
INSERT INTO Item (item_id, transactions_id, store_id, price, item_type, name, description, created) VALUES (701, 449, 13, 631, 'Electronics', 'name_701', 'description_701', CURRENT_TIMESTAMP);
INSERT INTO Item (item_id, transactions_id, store_id, price, item_type, name, description, created) VALUES (702, 500, 2, 158, 'Electronics', 'name_702', 'description_702', CURRENT_TIMESTAMP);
INSERT INTO Item (item_id, transactions_id, store_id, price, item_type, name, description, created) VALUES (703, 268, 3, 582, 'Books', 'name_703', 'description_703', CURRENT_TIMESTAMP);
INSERT INTO Item (item_id, transactions_id, store_id, price, item_type, name, description, created) VALUES (704, 317, 10, 465, 'Home', 'name_704', 'description_704', CURRENT_TIMESTAMP);
INSERT INTO Item (item_id, transactions_id, store_id, price, item_type, name, description, created) VALUES (705, 497, 3, 635, 'Health', 'name_705', 'description_705', CURRENT_TIMESTAMP);
INSERT INTO Item (item_id, transactions_id, store_id, price, item_type, name, description, created) VALUES (706, 43, 8, 640, 'Health', 'name_706', 'description_706', CURRENT_TIMESTAMP);
INSERT INTO Item (item_id, transactions_id, store_id, price, item_type, name, description, created) VALUES (707, 430, 8, 108, 'Home', 'name_707', 'description_707', CURRENT_TIMESTAMP);
INSERT INTO Item (item_id, transactions_id, store_id, price, item_type, name, description, created) VALUES (708, 399, 2, 95, 'Books', 'name_708', 'description_708', CURRENT_TIMESTAMP);
INSERT INTO Item (item_id, transactions_id, store_id, price, item_type, name, description, created) VALUES (709, 193, 7, 359, 'Books', 'name_709', 'description_709', CURRENT_TIMESTAMP);
INSERT INTO Item (item_id, transactions_id, store_id, price, item_type, name, description, created) VALUES (710, 187, 6, 99, 'Books', 'name_710', 'description_710', CURRENT_TIMESTAMP);
INSERT INTO Item (item_id, transactions_id, store_id, price, item_type, name, description, created) VALUES (711, 56, 6, 455, 'Home', 'name_711', 'description_711', CURRENT_TIMESTAMP);
INSERT INTO Item (item_id, transactions_id, store_id, price, item_type, name, description, created) VALUES (712, 398, 7, 125, 'Electronics', 'name_712', 'description_712', CURRENT_TIMESTAMP);
INSERT INTO Item (item_id, transactions_id, store_id, price, item_type, name, description, created) VALUES (713, 156, 14, 506, 'Books', 'name_713', 'description_713', CURRENT_TIMESTAMP);
INSERT INTO Item (item_id, transactions_id, store_id, price, item_type, name, description, created) VALUES (714, 346, 13, 159, 'Electronics', 'name_714', 'description_714', CURRENT_TIMESTAMP);
INSERT INTO Item (item_id, transactions_id, store_id, price, item_type, name, description, created) VALUES (715, 8, 2, 312, 'Electronics', 'name_715', 'description_715', CURRENT_TIMESTAMP);
INSERT INTO Item (item_id, transactions_id, store_id, price, item_type, name, description, created) VALUES (716, 265, 2, 607, 'Toys', 'name_716', 'description_716', CURRENT_TIMESTAMP);
INSERT INTO Item (item_id, transactions_id, store_id, price, item_type, name, description, created) VALUES (717, 284, 3, 593, 'Books', 'name_717', 'description_717', CURRENT_TIMESTAMP);
INSERT INTO Item (item_id, transactions_id, store_id, price, item_type, name, description, created) VALUES (718, 302, 6, 183, 'Electronics', 'name_718', 'description_718', CURRENT_TIMESTAMP);
INSERT INTO Item (item_id, transactions_id, store_id, price, item_type, name, description, created) VALUES (719, 425, 3, 216, 'Toys', 'name_719', 'description_719', CURRENT_TIMESTAMP);
INSERT INTO Item (item_id, transactions_id, store_id, price, item_type, name, description, created) VALUES (720, 449, 14, 323, 'Books', 'name_720', 'description_720', CURRENT_TIMESTAMP);
INSERT INTO Item (item_id, transactions_id, store_id, price, item_type, name, description, created) VALUES (721, 144, 14, 124, 'Books', 'name_721', 'description_721', CURRENT_TIMESTAMP);
INSERT INTO Item (item_id, transactions_id, store_id, price, item_type, name, description, created) VALUES (722, 75, 4, 92, 'Toys', 'name_722', 'description_722', CURRENT_TIMESTAMP);
INSERT INTO Item (item_id, transactions_id, store_id, price, item_type, name, description, created) VALUES (723, 455, 12, 497, 'Home', 'name_723', 'description_723', CURRENT_TIMESTAMP);
INSERT INTO Item (item_id, transactions_id, store_id, price, item_type, name, description, created) VALUES (724, 75, 8, 228, 'Books', 'name_724', 'description_724', CURRENT_TIMESTAMP);
INSERT INTO Item (item_id, transactions_id, store_id, price, item_type, name, description, created) VALUES (725, 146, 6, 548, 'Home', 'name_725', 'description_725', CURRENT_TIMESTAMP);
INSERT INTO Item (item_id, transactions_id, store_id, price, item_type, name, description, created) VALUES (726, 13, 1, 352, 'Health', 'name_726', 'description_726', CURRENT_TIMESTAMP);
INSERT INTO Item (item_id, transactions_id, store_id, price, item_type, name, description, created) VALUES (727, 491, 13, 614, 'Home', 'name_727', 'description_727', CURRENT_TIMESTAMP);
INSERT INTO Item (item_id, transactions_id, store_id, price, item_type, name, description, created) VALUES (728, 276, 4, 602, 'Toys', 'name_728', 'description_728', CURRENT_TIMESTAMP);
INSERT INTO Item (item_id, transactions_id, store_id, price, item_type, name, description, created) VALUES (729, 494, 4, 392, 'Home', 'name_729', 'description_729', CURRENT_TIMESTAMP);
INSERT INTO Item (item_id, transactions_id, store_id, price, item_type, name, description, created) VALUES (730, 80, 14, 689, 'Books', 'name_730', 'description_730', CURRENT_TIMESTAMP);
INSERT INTO Item (item_id, transactions_id, store_id, price, item_type, name, description, created) VALUES (731, 257, 7, 151, 'Books', 'name_731', 'description_731', CURRENT_TIMESTAMP);
INSERT INTO Item (item_id, transactions_id, store_id, price, item_type, name, description, created) VALUES (732, 279, 13, 589, 'Electronics', 'name_732', 'description_732', CURRENT_TIMESTAMP);
INSERT INTO Item (item_id, transactions_id, store_id, price, item_type, name, description, created) VALUES (733, 128, 13, 264, 'Health', 'name_733', 'description_733', CURRENT_TIMESTAMP);
INSERT INTO Item (item_id, transactions_id, store_id, price, item_type, name, description, created) VALUES (734, 467, 12, 249, 'Home', 'name_734', 'description_734', CURRENT_TIMESTAMP);
INSERT INTO Item (item_id, transactions_id, store_id, price, item_type, name, description, created) VALUES (735, 66, 6, 177, 'Health', 'name_735', 'description_735', CURRENT_TIMESTAMP);
INSERT INTO Item (item_id, transactions_id, store_id, price, item_type, name, description, created) VALUES (736, 347, 10, 321, 'Health', 'name_736', 'description_736', CURRENT_TIMESTAMP);
INSERT INTO Item (item_id, transactions_id, store_id, price, item_type, name, description, created) VALUES (737, 369, 3, 204, 'Home', 'name_737', 'description_737', CURRENT_TIMESTAMP);
INSERT INTO Item (item_id, transactions_id, store_id, price, item_type, name, description, created) VALUES (738, 141, 3, 350, 'Toys', 'name_738', 'description_738', CURRENT_TIMESTAMP);
INSERT INTO Item (item_id, transactions_id, store_id, price, item_type, name, description, created) VALUES (739, 474, 3, 35, 'Home', 'name_739', 'description_739', CURRENT_TIMESTAMP);
INSERT INTO Item (item_id, transactions_id, store_id, price, item_type, name, description, created) VALUES (740, 145, 13, 697, 'Home', 'name_740', 'description_740', CURRENT_TIMESTAMP);
INSERT INTO Item (item_id, transactions_id, store_id, price, item_type, name, description, created) VALUES (741, 129, 12, 53, 'Toys', 'name_741', 'description_741', CURRENT_TIMESTAMP);
INSERT INTO Item (item_id, transactions_id, store_id, price, item_type, name, description, created) VALUES (742, 39, 4, 259, 'Books', 'name_742', 'description_742', CURRENT_TIMESTAMP);
INSERT INTO Item (item_id, transactions_id, store_id, price, item_type, name, description, created) VALUES (743, 5, 5, 612, 'Home', 'name_743', 'description_743', CURRENT_TIMESTAMP);
INSERT INTO Item (item_id, transactions_id, store_id, price, item_type, name, description, created) VALUES (744, 243, 12, 678, 'Books', 'name_744', 'description_744', CURRENT_TIMESTAMP);
INSERT INTO Item (item_id, transactions_id, store_id, price, item_type, name, description, created) VALUES (745, 203, 3, 315, 'Electronics', 'name_745', 'description_745', CURRENT_TIMESTAMP);
INSERT INTO Item (item_id, transactions_id, store_id, price, item_type, name, description, created) VALUES (746, 290, 5, 151, 'Books', 'name_746', 'description_746', CURRENT_TIMESTAMP);
INSERT INTO Item (item_id, transactions_id, store_id, price, item_type, name, description, created) VALUES (747, 320, 10, 744, 'Books', 'name_747', 'description_747', CURRENT_TIMESTAMP);
INSERT INTO Item (item_id, transactions_id, store_id, price, item_type, name, description, created) VALUES (748, 449, 7, 298, 'Toys', 'name_748', 'description_748', CURRENT_TIMESTAMP);
INSERT INTO Item (item_id, transactions_id, store_id, price, item_type, name, description, created) VALUES (749, 273, 7, 424, 'Home', 'name_749', 'description_749', CURRENT_TIMESTAMP);
INSERT INTO Item (item_id, transactions_id, store_id, price, item_type, name, description, created) VALUES (750, 258, 3, 487, 'Books', 'name_750', 'description_750', CURRENT_TIMESTAMP);
INSERT INTO Item (item_id, transactions_id, store_id, price, item_type, name, description, created) VALUES (751, 60, 8, 536, 'Home', 'name_751', 'description_751', CURRENT_TIMESTAMP);
INSERT INTO Item (item_id, transactions_id, store_id, price, item_type, name, description, created) VALUES (752, 130, 10, 72, 'Health', 'name_752', 'description_752', CURRENT_TIMESTAMP);
INSERT INTO Item (item_id, transactions_id, store_id, price, item_type, name, description, created) VALUES (753, 256, 1, 244, 'Health', 'name_753', 'description_753', CURRENT_TIMESTAMP);
INSERT INTO Item (item_id, transactions_id, store_id, price, item_type, name, description, created) VALUES (754, 330, 8, 447, 'Health', 'name_754', 'description_754', CURRENT_TIMESTAMP);
INSERT INTO Item (item_id, transactions_id, store_id, price, item_type, name, description, created) VALUES (755, 368, 7, 393, 'Home', 'name_755', 'description_755', CURRENT_TIMESTAMP);
INSERT INTO Item (item_id, transactions_id, store_id, price, item_type, name, description, created) VALUES (756, 497, 13, 131, 'Books', 'name_756', 'description_756', CURRENT_TIMESTAMP);
INSERT INTO Item (item_id, transactions_id, store_id, price, item_type, name, description, created) VALUES (757, 184, 3, 518, 'Health', 'name_757', 'description_757', CURRENT_TIMESTAMP);
INSERT INTO Item (item_id, transactions_id, store_id, price, item_type, name, description, created) VALUES (758, 81, 7, 757, 'Home', 'name_758', 'description_758', CURRENT_TIMESTAMP);
INSERT INTO Item (item_id, transactions_id, store_id, price, item_type, name, description, created) VALUES (759, 73, 5, 650, 'Books', 'name_759', 'description_759', CURRENT_TIMESTAMP);
INSERT INTO Item (item_id, transactions_id, store_id, price, item_type, name, description, created) VALUES (760, 443, 8, 16, 'Home', 'name_760', 'description_760', CURRENT_TIMESTAMP);
INSERT INTO Item (item_id, transactions_id, store_id, price, item_type, name, description, created) VALUES (761, 461, 6, 289, 'Books', 'name_761', 'description_761', CURRENT_TIMESTAMP);
INSERT INTO Item (item_id, transactions_id, store_id, price, item_type, name, description, created) VALUES (762, 339, 7, 565, 'Books', 'name_762', 'description_762', CURRENT_TIMESTAMP);
INSERT INTO Item (item_id, transactions_id, store_id, price, item_type, name, description, created) VALUES (763, 87, 4, 628, 'Home', 'name_763', 'description_763', CURRENT_TIMESTAMP);
INSERT INTO Item (item_id, transactions_id, store_id, price, item_type, name, description, created) VALUES (764, 150, 8, 4, 'Books', 'name_764', 'description_764', CURRENT_TIMESTAMP);
INSERT INTO Item (item_id, transactions_id, store_id, price, item_type, name, description, created) VALUES (765, 73, 4, 63, 'Health', 'name_765', 'description_765', CURRENT_TIMESTAMP);
INSERT INTO Item (item_id, transactions_id, store_id, price, item_type, name, description, created) VALUES (766, 272, 9, 624, 'Home', 'name_766', 'description_766', CURRENT_TIMESTAMP);
INSERT INTO Item (item_id, transactions_id, store_id, price, item_type, name, description, created) VALUES (767, 448, 3, 436, 'Toys', 'name_767', 'description_767', CURRENT_TIMESTAMP);
INSERT INTO Item (item_id, transactions_id, store_id, price, item_type, name, description, created) VALUES (768, 129, 12, 761, 'Electronics', 'name_768', 'description_768', CURRENT_TIMESTAMP);
INSERT INTO Item (item_id, transactions_id, store_id, price, item_type, name, description, created) VALUES (769, 449, 1, 681, 'Health', 'name_769', 'description_769', CURRENT_TIMESTAMP);
INSERT INTO Item (item_id, transactions_id, store_id, price, item_type, name, description, created) VALUES (770, 418, 14, 748, 'Home', 'name_770', 'description_770', CURRENT_TIMESTAMP);
INSERT INTO Item (item_id, transactions_id, store_id, price, item_type, name, description, created) VALUES (771, 80, 12, 130, 'Electronics', 'name_771', 'description_771', CURRENT_TIMESTAMP);
INSERT INTO Item (item_id, transactions_id, store_id, price, item_type, name, description, created) VALUES (772, 287, 3, 72, 'Books', 'name_772', 'description_772', CURRENT_TIMESTAMP);
INSERT INTO Item (item_id, transactions_id, store_id, price, item_type, name, description, created) VALUES (773, 95, 13, 271, 'Electronics', 'name_773', 'description_773', CURRENT_TIMESTAMP);
INSERT INTO Item (item_id, transactions_id, store_id, price, item_type, name, description, created) VALUES (774, 144, 5, 661, 'Toys', 'name_774', 'description_774', CURRENT_TIMESTAMP);
INSERT INTO Item (item_id, transactions_id, store_id, price, item_type, name, description, created) VALUES (775, 436, 4, 663, 'Home', 'name_775', 'description_775', CURRENT_TIMESTAMP);
INSERT INTO Item (item_id, transactions_id, store_id, price, item_type, name, description, created) VALUES (776, 480, 3, 638, 'Electronics', 'name_776', 'description_776', CURRENT_TIMESTAMP);
INSERT INTO Item (item_id, transactions_id, store_id, price, item_type, name, description, created) VALUES (777, 426, 4, 317, 'Toys', 'name_777', 'description_777', CURRENT_TIMESTAMP);
INSERT INTO Item (item_id, transactions_id, store_id, price, item_type, name, description, created) VALUES (778, 273, 6, 159, 'Home', 'name_778', 'description_778', CURRENT_TIMESTAMP);
INSERT INTO Item (item_id, transactions_id, store_id, price, item_type, name, description, created) VALUES (779, 391, 3, 180, 'Home', 'name_779', 'description_779', CURRENT_TIMESTAMP);
INSERT INTO Item (item_id, transactions_id, store_id, price, item_type, name, description, created) VALUES (780, 120, 10, 703, 'Toys', 'name_780', 'description_780', CURRENT_TIMESTAMP);
INSERT INTO Item (item_id, transactions_id, store_id, price, item_type, name, description, created) VALUES (781, 357, 10, 116, 'Books', 'name_781', 'description_781', CURRENT_TIMESTAMP);
INSERT INTO Item (item_id, transactions_id, store_id, price, item_type, name, description, created) VALUES (782, 224, 10, 309, 'Electronics', 'name_782', 'description_782', CURRENT_TIMESTAMP);
INSERT INTO Item (item_id, transactions_id, store_id, price, item_type, name, description, created) VALUES (783, 472, 6, 230, 'Health', 'name_783', 'description_783', CURRENT_TIMESTAMP);
INSERT INTO Item (item_id, transactions_id, store_id, price, item_type, name, description, created) VALUES (784, 181, 2, 55, 'Books', 'name_784', 'description_784', CURRENT_TIMESTAMP);
INSERT INTO Item (item_id, transactions_id, store_id, price, item_type, name, description, created) VALUES (785, 44, 5, 481, 'Health', 'name_785', 'description_785', CURRENT_TIMESTAMP);
INSERT INTO Item (item_id, transactions_id, store_id, price, item_type, name, description, created) VALUES (786, 52, 4, 206, 'Books', 'name_786', 'description_786', CURRENT_TIMESTAMP);
INSERT INTO Item (item_id, transactions_id, store_id, price, item_type, name, description, created) VALUES (787, 30, 8, 541, 'Books', 'name_787', 'description_787', CURRENT_TIMESTAMP);
INSERT INTO Item (item_id, transactions_id, store_id, price, item_type, name, description, created) VALUES (788, 286, 8, 156, 'Home', 'name_788', 'description_788', CURRENT_TIMESTAMP);
INSERT INTO Item (item_id, transactions_id, store_id, price, item_type, name, description, created) VALUES (789, 16, 10, 714, 'Health', 'name_789', 'description_789', CURRENT_TIMESTAMP);
INSERT INTO Item (item_id, transactions_id, store_id, price, item_type, name, description, created) VALUES (790, 372, 5, 550, 'Home', 'name_790', 'description_790', CURRENT_TIMESTAMP);
INSERT INTO Item (item_id, transactions_id, store_id, price, item_type, name, description, created) VALUES (791, 435, 6, 561, 'Toys', 'name_791', 'description_791', CURRENT_TIMESTAMP);
INSERT INTO Item (item_id, transactions_id, store_id, price, item_type, name, description, created) VALUES (792, 413, 14, 177, 'Toys', 'name_792', 'description_792', CURRENT_TIMESTAMP);
INSERT INTO Item (item_id, transactions_id, store_id, price, item_type, name, description, created) VALUES (793, 475, 13, 341, 'Books', 'name_793', 'description_793', CURRENT_TIMESTAMP);
INSERT INTO Item (item_id, transactions_id, store_id, price, item_type, name, description, created) VALUES (794, 406, 6, 386, 'Books', 'name_794', 'description_794', CURRENT_TIMESTAMP);
INSERT INTO Item (item_id, transactions_id, store_id, price, item_type, name, description, created) VALUES (795, 232, 11, 783, 'Books', 'name_795', 'description_795', CURRENT_TIMESTAMP);
INSERT INTO Item (item_id, transactions_id, store_id, price, item_type, name, description, created) VALUES (796, 21, 10, 295, 'Books', 'name_796', 'description_796', CURRENT_TIMESTAMP);
INSERT INTO Item (item_id, transactions_id, store_id, price, item_type, name, description, created) VALUES (797, 251, 11, 565, 'Home', 'name_797', 'description_797', CURRENT_TIMESTAMP);
INSERT INTO Item (item_id, transactions_id, store_id, price, item_type, name, description, created) VALUES (798, 439, 4, 552, 'Health', 'name_798', 'description_798', CURRENT_TIMESTAMP);
INSERT INTO Item (item_id, transactions_id, store_id, price, item_type, name, description, created) VALUES (799, 119, 4, 617, 'Electronics', 'name_799', 'description_799', CURRENT_TIMESTAMP);
INSERT INTO Item (item_id, transactions_id, store_id, price, item_type, name, description, created) VALUES (800, 175, 14, 710, 'Electronics', 'name_800', 'description_800', CURRENT_TIMESTAMP);
INSERT INTO Item (item_id, transactions_id, store_id, price, item_type, name, description, created) VALUES (801, 183, 11, 360, 'Toys', 'name_801', 'description_801', CURRENT_TIMESTAMP);
INSERT INTO Item (item_id, transactions_id, store_id, price, item_type, name, description, created) VALUES (802, 187, 12, 546, 'Home', 'name_802', 'description_802', CURRENT_TIMESTAMP);
INSERT INTO Item (item_id, transactions_id, store_id, price, item_type, name, description, created) VALUES (803, 16, 6, 638, 'Health', 'name_803', 'description_803', CURRENT_TIMESTAMP);
INSERT INTO Item (item_id, transactions_id, store_id, price, item_type, name, description, created) VALUES (804, 150, 9, 285, 'Toys', 'name_804', 'description_804', CURRENT_TIMESTAMP);
INSERT INTO Item (item_id, transactions_id, store_id, price, item_type, name, description, created) VALUES (805, 287, 9, 91, 'Health', 'name_805', 'description_805', CURRENT_TIMESTAMP);
INSERT INTO Item (item_id, transactions_id, store_id, price, item_type, name, description, created) VALUES (806, 357, 12, 455, 'Home', 'name_806', 'description_806', CURRENT_TIMESTAMP);
INSERT INTO Item (item_id, transactions_id, store_id, price, item_type, name, description, created) VALUES (807, 419, 3, 259, 'Books', 'name_807', 'description_807', CURRENT_TIMESTAMP);
INSERT INTO Item (item_id, transactions_id, store_id, price, item_type, name, description, created) VALUES (808, 348, 1, 579, 'Electronics', 'name_808', 'description_808', CURRENT_TIMESTAMP);
INSERT INTO Item (item_id, transactions_id, store_id, price, item_type, name, description, created) VALUES (809, 324, 12, 443, 'Electronics', 'name_809', 'description_809', CURRENT_TIMESTAMP);
INSERT INTO Item (item_id, transactions_id, store_id, price, item_type, name, description, created) VALUES (810, 60, 12, 371, 'Home', 'name_810', 'description_810', CURRENT_TIMESTAMP);
INSERT INTO Item (item_id, transactions_id, store_id, price, item_type, name, description, created) VALUES (811, 214, 10, 466, 'Home', 'name_811', 'description_811', CURRENT_TIMESTAMP);
INSERT INTO Item (item_id, transactions_id, store_id, price, item_type, name, description, created) VALUES (812, 212, 12, 86, 'Electronics', 'name_812', 'description_812', CURRENT_TIMESTAMP);
INSERT INTO Item (item_id, transactions_id, store_id, price, item_type, name, description, created) VALUES (813, 229, 4, 563, 'Books', 'name_813', 'description_813', CURRENT_TIMESTAMP);
INSERT INTO Item (item_id, transactions_id, store_id, price, item_type, name, description, created) VALUES (814, 305, 14, 808, 'Books', 'name_814', 'description_814', CURRENT_TIMESTAMP);
INSERT INTO Item (item_id, transactions_id, store_id, price, item_type, name, description, created) VALUES (815, 52, 12, 56, 'Electronics', 'name_815', 'description_815', CURRENT_TIMESTAMP);
INSERT INTO Item (item_id, transactions_id, store_id, price, item_type, name, description, created) VALUES (816, 335, 11, 79, 'Health', 'name_816', 'description_816', CURRENT_TIMESTAMP);
INSERT INTO Item (item_id, transactions_id, store_id, price, item_type, name, description, created) VALUES (817, 111, 7, 690, 'Electronics', 'name_817', 'description_817', CURRENT_TIMESTAMP);
INSERT INTO Item (item_id, transactions_id, store_id, price, item_type, name, description, created) VALUES (818, 497, 9, 138, 'Books', 'name_818', 'description_818', CURRENT_TIMESTAMP);
INSERT INTO Item (item_id, transactions_id, store_id, price, item_type, name, description, created) VALUES (819, 248, 7, 800, 'Toys', 'name_819', 'description_819', CURRENT_TIMESTAMP);
INSERT INTO Item (item_id, transactions_id, store_id, price, item_type, name, description, created) VALUES (820, 408, 1, 771, 'Electronics', 'name_820', 'description_820', CURRENT_TIMESTAMP);
INSERT INTO Item (item_id, transactions_id, store_id, price, item_type, name, description, created) VALUES (821, 31, 7, 509, 'Books', 'name_821', 'description_821', CURRENT_TIMESTAMP);
INSERT INTO Item (item_id, transactions_id, store_id, price, item_type, name, description, created) VALUES (822, 353, 13, 695, 'Toys', 'name_822', 'description_822', CURRENT_TIMESTAMP);
INSERT INTO Item (item_id, transactions_id, store_id, price, item_type, name, description, created) VALUES (823, 453, 7, 181, 'Home', 'name_823', 'description_823', CURRENT_TIMESTAMP);
INSERT INTO Item (item_id, transactions_id, store_id, price, item_type, name, description, created) VALUES (824, 354, 14, 765, 'Health', 'name_824', 'description_824', CURRENT_TIMESTAMP);
INSERT INTO Item (item_id, transactions_id, store_id, price, item_type, name, description, created) VALUES (825, 116, 8, 220, 'Books', 'name_825', 'description_825', CURRENT_TIMESTAMP);
INSERT INTO Item (item_id, transactions_id, store_id, price, item_type, name, description, created) VALUES (826, 22, 1, 172, 'Home', 'name_826', 'description_826', CURRENT_TIMESTAMP);
INSERT INTO Item (item_id, transactions_id, store_id, price, item_type, name, description, created) VALUES (827, 361, 6, 692, 'Home', 'name_827', 'description_827', CURRENT_TIMESTAMP);
INSERT INTO Item (item_id, transactions_id, store_id, price, item_type, name, description, created) VALUES (828, 3, 3, 234, 'Electronics', 'name_828', 'description_828', CURRENT_TIMESTAMP);
INSERT INTO Item (item_id, transactions_id, store_id, price, item_type, name, description, created) VALUES (829, 55, 9, 821, 'Books', 'name_829', 'description_829', CURRENT_TIMESTAMP);
INSERT INTO Item (item_id, transactions_id, store_id, price, item_type, name, description, created) VALUES (830, 240, 9, 13, 'Health', 'name_830', 'description_830', CURRENT_TIMESTAMP);
INSERT INTO Item (item_id, transactions_id, store_id, price, item_type, name, description, created) VALUES (831, 27, 5, 73, 'Home', 'name_831', 'description_831', CURRENT_TIMESTAMP);
INSERT INTO Item (item_id, transactions_id, store_id, price, item_type, name, description, created) VALUES (832, 33, 12, 668, 'Electronics', 'name_832', 'description_832', CURRENT_TIMESTAMP);
INSERT INTO Item (item_id, transactions_id, store_id, price, item_type, name, description, created) VALUES (833, 374, 9, 77, 'Toys', 'name_833', 'description_833', CURRENT_TIMESTAMP);
INSERT INTO Item (item_id, transactions_id, store_id, price, item_type, name, description, created) VALUES (834, 16, 1, 73, 'Electronics', 'name_834', 'description_834', CURRENT_TIMESTAMP);
INSERT INTO Item (item_id, transactions_id, store_id, price, item_type, name, description, created) VALUES (835, 402, 1, 98, 'Health', 'name_835', 'description_835', CURRENT_TIMESTAMP);
INSERT INTO Item (item_id, transactions_id, store_id, price, item_type, name, description, created) VALUES (836, 395, 5, 253, 'Health', 'name_836', 'description_836', CURRENT_TIMESTAMP);
INSERT INTO Item (item_id, transactions_id, store_id, price, item_type, name, description, created) VALUES (837, 389, 11, 216, 'Home', 'name_837', 'description_837', CURRENT_TIMESTAMP);
INSERT INTO Item (item_id, transactions_id, store_id, price, item_type, name, description, created) VALUES (838, 159, 2, 604, 'Health', 'name_838', 'description_838', CURRENT_TIMESTAMP);
INSERT INTO Item (item_id, transactions_id, store_id, price, item_type, name, description, created) VALUES (839, 4, 8, 254, 'Toys', 'name_839', 'description_839', CURRENT_TIMESTAMP);
INSERT INTO Item (item_id, transactions_id, store_id, price, item_type, name, description, created) VALUES (840, 18, 7, 777, 'Toys', 'name_840', 'description_840', CURRENT_TIMESTAMP);
INSERT INTO Item (item_id, transactions_id, store_id, price, item_type, name, description, created) VALUES (841, 394, 3, 559, 'Health', 'name_841', 'description_841', CURRENT_TIMESTAMP);
INSERT INTO Item (item_id, transactions_id, store_id, price, item_type, name, description, created) VALUES (842, 396, 14, 193, 'Electronics', 'name_842', 'description_842', CURRENT_TIMESTAMP);
INSERT INTO Item (item_id, transactions_id, store_id, price, item_type, name, description, created) VALUES (843, 61, 7, 484, 'Electronics', 'name_843', 'description_843', CURRENT_TIMESTAMP);
INSERT INTO Item (item_id, transactions_id, store_id, price, item_type, name, description, created) VALUES (844, 451, 11, 685, 'Electronics', 'name_844', 'description_844', CURRENT_TIMESTAMP);
INSERT INTO Item (item_id, transactions_id, store_id, price, item_type, name, description, created) VALUES (845, 188, 2, 138, 'Home', 'name_845', 'description_845', CURRENT_TIMESTAMP);
INSERT INTO Item (item_id, transactions_id, store_id, price, item_type, name, description, created) VALUES (846, 279, 3, 47, 'Home', 'name_846', 'description_846', CURRENT_TIMESTAMP);
INSERT INTO Item (item_id, transactions_id, store_id, price, item_type, name, description, created) VALUES (847, 350, 6, 692, 'Books', 'name_847', 'description_847', CURRENT_TIMESTAMP);
INSERT INTO Item (item_id, transactions_id, store_id, price, item_type, name, description, created) VALUES (848, 200, 9, 293, 'Home', 'name_848', 'description_848', CURRENT_TIMESTAMP);
INSERT INTO Item (item_id, transactions_id, store_id, price, item_type, name, description, created) VALUES (849, 289, 1, 778, 'Toys', 'name_849', 'description_849', CURRENT_TIMESTAMP);
INSERT INTO Item (item_id, transactions_id, store_id, price, item_type, name, description, created) VALUES (850, 155, 9, 716, 'Toys', 'name_850', 'description_850', CURRENT_TIMESTAMP);
INSERT INTO Item (item_id, transactions_id, store_id, price, item_type, name, description, created) VALUES (851, 137, 7, 780, 'Home', 'name_851', 'description_851', CURRENT_TIMESTAMP);
INSERT INTO Item (item_id, transactions_id, store_id, price, item_type, name, description, created) VALUES (852, 271, 7, 612, 'Books', 'name_852', 'description_852', CURRENT_TIMESTAMP);
INSERT INTO Item (item_id, transactions_id, store_id, price, item_type, name, description, created) VALUES (853, 354, 12, 544, 'Electronics', 'name_853', 'description_853', CURRENT_TIMESTAMP);
INSERT INTO Item (item_id, transactions_id, store_id, price, item_type, name, description, created) VALUES (854, 386, 12, 126, 'Books', 'name_854', 'description_854', CURRENT_TIMESTAMP);
INSERT INTO Item (item_id, transactions_id, store_id, price, item_type, name, description, created) VALUES (855, 308, 13, 217, 'Home', 'name_855', 'description_855', CURRENT_TIMESTAMP);
INSERT INTO Item (item_id, transactions_id, store_id, price, item_type, name, description, created) VALUES (856, 64, 1, 728, 'Health', 'name_856', 'description_856', CURRENT_TIMESTAMP);
INSERT INTO Item (item_id, transactions_id, store_id, price, item_type, name, description, created) VALUES (857, 10, 10, 539, 'Electronics', 'name_857', 'description_857', CURRENT_TIMESTAMP);
INSERT INTO Item (item_id, transactions_id, store_id, price, item_type, name, description, created) VALUES (858, 315, 1, 699, 'Electronics', 'name_858', 'description_858', CURRENT_TIMESTAMP);
INSERT INTO Item (item_id, transactions_id, store_id, price, item_type, name, description, created) VALUES (859, 265, 9, 817, 'Health', 'name_859', 'description_859', CURRENT_TIMESTAMP);
INSERT INTO Item (item_id, transactions_id, store_id, price, item_type, name, description, created) VALUES (860, 434, 3, 38, 'Toys', 'name_860', 'description_860', CURRENT_TIMESTAMP);
INSERT INTO Item (item_id, transactions_id, store_id, price, item_type, name, description, created) VALUES (861, 306, 8, 213, 'Health', 'name_861', 'description_861', CURRENT_TIMESTAMP);
INSERT INTO Item (item_id, transactions_id, store_id, price, item_type, name, description, created) VALUES (862, 382, 14, 784, 'Home', 'name_862', 'description_862', CURRENT_TIMESTAMP);
INSERT INTO Item (item_id, transactions_id, store_id, price, item_type, name, description, created) VALUES (863, 250, 14, 478, 'Health', 'name_863', 'description_863', CURRENT_TIMESTAMP);
INSERT INTO Item (item_id, transactions_id, store_id, price, item_type, name, description, created) VALUES (864, 133, 1, 14, 'Books', 'name_864', 'description_864', CURRENT_TIMESTAMP);
INSERT INTO Item (item_id, transactions_id, store_id, price, item_type, name, description, created) VALUES (865, 306, 1, 736, 'Electronics', 'name_865', 'description_865', CURRENT_TIMESTAMP);
INSERT INTO Item (item_id, transactions_id, store_id, price, item_type, name, description, created) VALUES (866, 375, 8, 720, 'Books', 'name_866', 'description_866', CURRENT_TIMESTAMP);
INSERT INTO Item (item_id, transactions_id, store_id, price, item_type, name, description, created) VALUES (867, 3, 8, 827, 'Toys', 'name_867', 'description_867', CURRENT_TIMESTAMP);
INSERT INTO Item (item_id, transactions_id, store_id, price, item_type, name, description, created) VALUES (868, 488, 3, 603, 'Electronics', 'name_868', 'description_868', CURRENT_TIMESTAMP);
INSERT INTO Item (item_id, transactions_id, store_id, price, item_type, name, description, created) VALUES (869, 315, 8, 858, 'Books', 'name_869', 'description_869', CURRENT_TIMESTAMP);
INSERT INTO Item (item_id, transactions_id, store_id, price, item_type, name, description, created) VALUES (870, 392, 3, 415, 'Books', 'name_870', 'description_870', CURRENT_TIMESTAMP);
INSERT INTO Item (item_id, transactions_id, store_id, price, item_type, name, description, created) VALUES (871, 243, 14, 396, 'Electronics', 'name_871', 'description_871', CURRENT_TIMESTAMP);
INSERT INTO Item (item_id, transactions_id, store_id, price, item_type, name, description, created) VALUES (872, 429, 8, 622, 'Health', 'name_872', 'description_872', CURRENT_TIMESTAMP);
INSERT INTO Item (item_id, transactions_id, store_id, price, item_type, name, description, created) VALUES (873, 196, 5, 349, 'Home', 'name_873', 'description_873', CURRENT_TIMESTAMP);
INSERT INTO Item (item_id, transactions_id, store_id, price, item_type, name, description, created) VALUES (874, 101, 6, 115, 'Toys', 'name_874', 'description_874', CURRENT_TIMESTAMP);
INSERT INTO Item (item_id, transactions_id, store_id, price, item_type, name, description, created) VALUES (875, 335, 9, 666, 'Health', 'name_875', 'description_875', CURRENT_TIMESTAMP);
INSERT INTO Item (item_id, transactions_id, store_id, price, item_type, name, description, created) VALUES (876, 190, 1, 460, 'Books', 'name_876', 'description_876', CURRENT_TIMESTAMP);
INSERT INTO Item (item_id, transactions_id, store_id, price, item_type, name, description, created) VALUES (877, 214, 11, 592, 'Health', 'name_877', 'description_877', CURRENT_TIMESTAMP);
INSERT INTO Item (item_id, transactions_id, store_id, price, item_type, name, description, created) VALUES (878, 70, 8, 3, 'Health', 'name_878', 'description_878', CURRENT_TIMESTAMP);
INSERT INTO Item (item_id, transactions_id, store_id, price, item_type, name, description, created) VALUES (879, 79, 3, 274, 'Toys', 'name_879', 'description_879', CURRENT_TIMESTAMP);
INSERT INTO Item (item_id, transactions_id, store_id, price, item_type, name, description, created) VALUES (880, 138, 5, 466, 'Home', 'name_880', 'description_880', CURRENT_TIMESTAMP);
INSERT INTO Item (item_id, transactions_id, store_id, price, item_type, name, description, created) VALUES (881, 326, 2, 179, 'Health', 'name_881', 'description_881', CURRENT_TIMESTAMP);
INSERT INTO Item (item_id, transactions_id, store_id, price, item_type, name, description, created) VALUES (882, 97, 4, 882, 'Books', 'name_882', 'description_882', CURRENT_TIMESTAMP);
INSERT INTO Item (item_id, transactions_id, store_id, price, item_type, name, description, created) VALUES (883, 116, 7, 799, 'Books', 'name_883', 'description_883', CURRENT_TIMESTAMP);
INSERT INTO Item (item_id, transactions_id, store_id, price, item_type, name, description, created) VALUES (884, 343, 7, 15, 'Home', 'name_884', 'description_884', CURRENT_TIMESTAMP);
INSERT INTO Item (item_id, transactions_id, store_id, price, item_type, name, description, created) VALUES (885, 481, 10, 866, 'Home', 'name_885', 'description_885', CURRENT_TIMESTAMP);
INSERT INTO Item (item_id, transactions_id, store_id, price, item_type, name, description, created) VALUES (886, 173, 14, 333, 'Books', 'name_886', 'description_886', CURRENT_TIMESTAMP);
INSERT INTO Item (item_id, transactions_id, store_id, price, item_type, name, description, created) VALUES (887, 83, 6, 437, 'Toys', 'name_887', 'description_887', CURRENT_TIMESTAMP);
INSERT INTO Item (item_id, transactions_id, store_id, price, item_type, name, description, created) VALUES (888, 121, 13, 759, 'Books', 'name_888', 'description_888', CURRENT_TIMESTAMP);
INSERT INTO Item (item_id, transactions_id, store_id, price, item_type, name, description, created) VALUES (889, 96, 7, 602, 'Toys', 'name_889', 'description_889', CURRENT_TIMESTAMP);
INSERT INTO Item (item_id, transactions_id, store_id, price, item_type, name, description, created) VALUES (890, 483, 12, 281, 'Books', 'name_890', 'description_890', CURRENT_TIMESTAMP);
INSERT INTO Item (item_id, transactions_id, store_id, price, item_type, name, description, created) VALUES (891, 349, 4, 714, 'Electronics', 'name_891', 'description_891', CURRENT_TIMESTAMP);
INSERT INTO Item (item_id, transactions_id, store_id, price, item_type, name, description, created) VALUES (892, 447, 1, 339, 'Home', 'name_892', 'description_892', CURRENT_TIMESTAMP);
INSERT INTO Item (item_id, transactions_id, store_id, price, item_type, name, description, created) VALUES (893, 500, 4, 616, 'Health', 'name_893', 'description_893', CURRENT_TIMESTAMP);
INSERT INTO Item (item_id, transactions_id, store_id, price, item_type, name, description, created) VALUES (894, 178, 4, 349, 'Toys', 'name_894', 'description_894', CURRENT_TIMESTAMP);
INSERT INTO Item (item_id, transactions_id, store_id, price, item_type, name, description, created) VALUES (895, 157, 6, 244, 'Health', 'name_895', 'description_895', CURRENT_TIMESTAMP);
INSERT INTO Item (item_id, transactions_id, store_id, price, item_type, name, description, created) VALUES (896, 253, 3, 838, 'Home', 'name_896', 'description_896', CURRENT_TIMESTAMP);
INSERT INTO Item (item_id, transactions_id, store_id, price, item_type, name, description, created) VALUES (897, 232, 1, 545, 'Home', 'name_897', 'description_897', CURRENT_TIMESTAMP);
INSERT INTO Item (item_id, transactions_id, store_id, price, item_type, name, description, created) VALUES (898, 445, 12, 204, 'Electronics', 'name_898', 'description_898', CURRENT_TIMESTAMP);
INSERT INTO Item (item_id, transactions_id, store_id, price, item_type, name, description, created) VALUES (899, 294, 14, 614, 'Home', 'name_899', 'description_899', CURRENT_TIMESTAMP);
INSERT INTO Item (item_id, transactions_id, store_id, price, item_type, name, description, created) VALUES (900, 469, 5, 783, 'Books', 'name_900', 'description_900', CURRENT_TIMESTAMP);
INSERT INTO Item (item_id, transactions_id, store_id, price, item_type, name, description, created) VALUES (901, 334, 2, 273, 'Electronics', 'name_901', 'description_901', CURRENT_TIMESTAMP);
INSERT INTO Item (item_id, transactions_id, store_id, price, item_type, name, description, created) VALUES (902, 306, 10, 359, 'Health', 'name_902', 'description_902', CURRENT_TIMESTAMP);
INSERT INTO Item (item_id, transactions_id, store_id, price, item_type, name, description, created) VALUES (903, 203, 2, 813, 'Toys', 'name_903', 'description_903', CURRENT_TIMESTAMP);
INSERT INTO Item (item_id, transactions_id, store_id, price, item_type, name, description, created) VALUES (904, 383, 12, 746, 'Toys', 'name_904', 'description_904', CURRENT_TIMESTAMP);
INSERT INTO Item (item_id, transactions_id, store_id, price, item_type, name, description, created) VALUES (905, 154, 13, 610, 'Toys', 'name_905', 'description_905', CURRENT_TIMESTAMP);
INSERT INTO Item (item_id, transactions_id, store_id, price, item_type, name, description, created) VALUES (906, 44, 3, 734, 'Health', 'name_906', 'description_906', CURRENT_TIMESTAMP);
INSERT INTO Item (item_id, transactions_id, store_id, price, item_type, name, description, created) VALUES (907, 228, 1, 118, 'Toys', 'name_907', 'description_907', CURRENT_TIMESTAMP);
INSERT INTO Item (item_id, transactions_id, store_id, price, item_type, name, description, created) VALUES (908, 371, 10, 507, 'Books', 'name_908', 'description_908', CURRENT_TIMESTAMP);
INSERT INTO Item (item_id, transactions_id, store_id, price, item_type, name, description, created) VALUES (909, 171, 5, 603, 'Electronics', 'name_909', 'description_909', CURRENT_TIMESTAMP);
INSERT INTO Item (item_id, transactions_id, store_id, price, item_type, name, description, created) VALUES (910, 116, 4, 203, 'Toys', 'name_910', 'description_910', CURRENT_TIMESTAMP);
INSERT INTO Item (item_id, transactions_id, store_id, price, item_type, name, description, created) VALUES (911, 80, 9, 128, 'Home', 'name_911', 'description_911', CURRENT_TIMESTAMP);
INSERT INTO Item (item_id, transactions_id, store_id, price, item_type, name, description, created) VALUES (912, 267, 3, 448, 'Books', 'name_912', 'description_912', CURRENT_TIMESTAMP);
INSERT INTO Item (item_id, transactions_id, store_id, price, item_type, name, description, created) VALUES (913, 106, 3, 296, 'Health', 'name_913', 'description_913', CURRENT_TIMESTAMP);
INSERT INTO Item (item_id, transactions_id, store_id, price, item_type, name, description, created) VALUES (914, 85, 5, 807, 'Books', 'name_914', 'description_914', CURRENT_TIMESTAMP);
INSERT INTO Item (item_id, transactions_id, store_id, price, item_type, name, description, created) VALUES (915, 452, 7, 267, 'Health', 'name_915', 'description_915', CURRENT_TIMESTAMP);
INSERT INTO Item (item_id, transactions_id, store_id, price, item_type, name, description, created) VALUES (916, 360, 5, 819, 'Health', 'name_916', 'description_916', CURRENT_TIMESTAMP);
INSERT INTO Item (item_id, transactions_id, store_id, price, item_type, name, description, created) VALUES (917, 428, 8, 2, 'Home', 'name_917', 'description_917', CURRENT_TIMESTAMP);
INSERT INTO Item (item_id, transactions_id, store_id, price, item_type, name, description, created) VALUES (918, 36, 3, 128, 'Home', 'name_918', 'description_918', CURRENT_TIMESTAMP);
INSERT INTO Item (item_id, transactions_id, store_id, price, item_type, name, description, created) VALUES (919, 165, 5, 563, 'Health', 'name_919', 'description_919', CURRENT_TIMESTAMP);
INSERT INTO Item (item_id, transactions_id, store_id, price, item_type, name, description, created) VALUES (920, 111, 12, 574, 'Electronics', 'name_920', 'description_920', CURRENT_TIMESTAMP);
INSERT INTO Item (item_id, transactions_id, store_id, price, item_type, name, description, created) VALUES (921, 244, 3, 587, 'Electronics', 'name_921', 'description_921', CURRENT_TIMESTAMP);
INSERT INTO Item (item_id, transactions_id, store_id, price, item_type, name, description, created) VALUES (922, 478, 6, 482, 'Toys', 'name_922', 'description_922', CURRENT_TIMESTAMP);
INSERT INTO Item (item_id, transactions_id, store_id, price, item_type, name, description, created) VALUES (923, 495, 14, 334, 'Toys', 'name_923', 'description_923', CURRENT_TIMESTAMP);
INSERT INTO Item (item_id, transactions_id, store_id, price, item_type, name, description, created) VALUES (924, 334, 3, 346, 'Health', 'name_924', 'description_924', CURRENT_TIMESTAMP);
INSERT INTO Item (item_id, transactions_id, store_id, price, item_type, name, description, created) VALUES (925, 139, 4, 461, 'Home', 'name_925', 'description_925', CURRENT_TIMESTAMP);
INSERT INTO Item (item_id, transactions_id, store_id, price, item_type, name, description, created) VALUES (926, 251, 11, 306, 'Health', 'name_926', 'description_926', CURRENT_TIMESTAMP);
INSERT INTO Item (item_id, transactions_id, store_id, price, item_type, name, description, created) VALUES (927, 284, 11, 172, 'Books', 'name_927', 'description_927', CURRENT_TIMESTAMP);
INSERT INTO Item (item_id, transactions_id, store_id, price, item_type, name, description, created) VALUES (928, 280, 2, 563, 'Electronics', 'name_928', 'description_928', CURRENT_TIMESTAMP);
INSERT INTO Item (item_id, transactions_id, store_id, price, item_type, name, description, created) VALUES (929, 354, 14, 419, 'Health', 'name_929', 'description_929', CURRENT_TIMESTAMP);
INSERT INTO Item (item_id, transactions_id, store_id, price, item_type, name, description, created) VALUES (930, 397, 12, 904, 'Electronics', 'name_930', 'description_930', CURRENT_TIMESTAMP);
INSERT INTO Item (item_id, transactions_id, store_id, price, item_type, name, description, created) VALUES (931, 209, 2, 843, 'Books', 'name_931', 'description_931', CURRENT_TIMESTAMP);
INSERT INTO Item (item_id, transactions_id, store_id, price, item_type, name, description, created) VALUES (932, 396, 7, 660, 'Health', 'name_932', 'description_932', CURRENT_TIMESTAMP);
INSERT INTO Item (item_id, transactions_id, store_id, price, item_type, name, description, created) VALUES (933, 9, 10, 568, 'Home', 'name_933', 'description_933', CURRENT_TIMESTAMP);
INSERT INTO Item (item_id, transactions_id, store_id, price, item_type, name, description, created) VALUES (934, 84, 1, 925, 'Health', 'name_934', 'description_934', CURRENT_TIMESTAMP);
INSERT INTO Item (item_id, transactions_id, store_id, price, item_type, name, description, created) VALUES (935, 320, 4, 814, 'Health', 'name_935', 'description_935', CURRENT_TIMESTAMP);
INSERT INTO Item (item_id, transactions_id, store_id, price, item_type, name, description, created) VALUES (936, 157, 9, 166, 'Electronics', 'name_936', 'description_936', CURRENT_TIMESTAMP);
INSERT INTO Item (item_id, transactions_id, store_id, price, item_type, name, description, created) VALUES (937, 476, 14, 697, 'Health', 'name_937', 'description_937', CURRENT_TIMESTAMP);
INSERT INTO Item (item_id, transactions_id, store_id, price, item_type, name, description, created) VALUES (938, 251, 9, 742, 'Electronics', 'name_938', 'description_938', CURRENT_TIMESTAMP);
INSERT INTO Item (item_id, transactions_id, store_id, price, item_type, name, description, created) VALUES (939, 156, 10, 332, 'Electronics', 'name_939', 'description_939', CURRENT_TIMESTAMP);
INSERT INTO Item (item_id, transactions_id, store_id, price, item_type, name, description, created) VALUES (940, 85, 9, 123, 'Electronics', 'name_940', 'description_940', CURRENT_TIMESTAMP);
INSERT INTO Item (item_id, transactions_id, store_id, price, item_type, name, description, created) VALUES (941, 58, 9, 442, 'Electronics', 'name_941', 'description_941', CURRENT_TIMESTAMP);
INSERT INTO Item (item_id, transactions_id, store_id, price, item_type, name, description, created) VALUES (942, 240, 13, 143, 'Electronics', 'name_942', 'description_942', CURRENT_TIMESTAMP);
INSERT INTO Item (item_id, transactions_id, store_id, price, item_type, name, description, created) VALUES (943, 55, 5, 412, 'Books', 'name_943', 'description_943', CURRENT_TIMESTAMP);
INSERT INTO Item (item_id, transactions_id, store_id, price, item_type, name, description, created) VALUES (944, 474, 11, 612, 'Toys', 'name_944', 'description_944', CURRENT_TIMESTAMP);
INSERT INTO Item (item_id, transactions_id, store_id, price, item_type, name, description, created) VALUES (945, 461, 5, 862, 'Books', 'name_945', 'description_945', CURRENT_TIMESTAMP);
INSERT INTO Item (item_id, transactions_id, store_id, price, item_type, name, description, created) VALUES (946, 324, 13, 37, 'Home', 'name_946', 'description_946', CURRENT_TIMESTAMP);
INSERT INTO Item (item_id, transactions_id, store_id, price, item_type, name, description, created) VALUES (947, 139, 12, 742, 'Electronics', 'name_947', 'description_947', CURRENT_TIMESTAMP);
INSERT INTO Item (item_id, transactions_id, store_id, price, item_type, name, description, created) VALUES (948, 457, 13, 422, 'Electronics', 'name_948', 'description_948', CURRENT_TIMESTAMP);
INSERT INTO Item (item_id, transactions_id, store_id, price, item_type, name, description, created) VALUES (949, 463, 10, 338, 'Toys', 'name_949', 'description_949', CURRENT_TIMESTAMP);
INSERT INTO Item (item_id, transactions_id, store_id, price, item_type, name, description, created) VALUES (950, 121, 11, 95, 'Toys', 'name_950', 'description_950', CURRENT_TIMESTAMP);
INSERT INTO Item (item_id, transactions_id, store_id, price, item_type, name, description, created) VALUES (951, 23, 5, 197, 'Books', 'name_951', 'description_951', CURRENT_TIMESTAMP);
INSERT INTO Item (item_id, transactions_id, store_id, price, item_type, name, description, created) VALUES (952, 166, 4, 183, 'Health', 'name_952', 'description_952', CURRENT_TIMESTAMP);
INSERT INTO Item (item_id, transactions_id, store_id, price, item_type, name, description, created) VALUES (953, 189, 9, 923, 'Toys', 'name_953', 'description_953', CURRENT_TIMESTAMP);
INSERT INTO Item (item_id, transactions_id, store_id, price, item_type, name, description, created) VALUES (954, 280, 13, 617, 'Health', 'name_954', 'description_954', CURRENT_TIMESTAMP);
INSERT INTO Item (item_id, transactions_id, store_id, price, item_type, name, description, created) VALUES (955, 261, 5, 790, 'Electronics', 'name_955', 'description_955', CURRENT_TIMESTAMP);
INSERT INTO Item (item_id, transactions_id, store_id, price, item_type, name, description, created) VALUES (956, 399, 11, 814, 'Toys', 'name_956', 'description_956', CURRENT_TIMESTAMP);
INSERT INTO Item (item_id, transactions_id, store_id, price, item_type, name, description, created) VALUES (957, 347, 13, 338, 'Books', 'name_957', 'description_957', CURRENT_TIMESTAMP);
INSERT INTO Item (item_id, transactions_id, store_id, price, item_type, name, description, created) VALUES (958, 95, 11, 584, 'Books', 'name_958', 'description_958', CURRENT_TIMESTAMP);
INSERT INTO Item (item_id, transactions_id, store_id, price, item_type, name, description, created) VALUES (959, 360, 5, 703, 'Home', 'name_959', 'description_959', CURRENT_TIMESTAMP);
INSERT INTO Item (item_id, transactions_id, store_id, price, item_type, name, description, created) VALUES (960, 165, 13, 17, 'Health', 'name_960', 'description_960', CURRENT_TIMESTAMP);
INSERT INTO Item (item_id, transactions_id, store_id, price, item_type, name, description, created) VALUES (961, 50, 6, 494, 'Books', 'name_961', 'description_961', CURRENT_TIMESTAMP);
INSERT INTO Item (item_id, transactions_id, store_id, price, item_type, name, description, created) VALUES (962, 23, 4, 579, 'Toys', 'name_962', 'description_962', CURRENT_TIMESTAMP);
INSERT INTO Item (item_id, transactions_id, store_id, price, item_type, name, description, created) VALUES (963, 432, 3, 131, 'Health', 'name_963', 'description_963', CURRENT_TIMESTAMP);
INSERT INTO Item (item_id, transactions_id, store_id, price, item_type, name, description, created) VALUES (964, 491, 2, 659, 'Books', 'name_964', 'description_964', CURRENT_TIMESTAMP);
INSERT INTO Item (item_id, transactions_id, store_id, price, item_type, name, description, created) VALUES (965, 429, 6, 351, 'Health', 'name_965', 'description_965', CURRENT_TIMESTAMP);
INSERT INTO Item (item_id, transactions_id, store_id, price, item_type, name, description, created) VALUES (966, 205, 1, 419, 'Electronics', 'name_966', 'description_966', CURRENT_TIMESTAMP);
INSERT INTO Item (item_id, transactions_id, store_id, price, item_type, name, description, created) VALUES (967, 400, 8, 458, 'Home', 'name_967', 'description_967', CURRENT_TIMESTAMP);
INSERT INTO Item (item_id, transactions_id, store_id, price, item_type, name, description, created) VALUES (968, 127, 5, 304, 'Books', 'name_968', 'description_968', CURRENT_TIMESTAMP);
INSERT INTO Item (item_id, transactions_id, store_id, price, item_type, name, description, created) VALUES (969, 141, 10, 627, 'Toys', 'name_969', 'description_969', CURRENT_TIMESTAMP);
INSERT INTO Item (item_id, transactions_id, store_id, price, item_type, name, description, created) VALUES (970, 335, 1, 839, 'Electronics', 'name_970', 'description_970', CURRENT_TIMESTAMP);
INSERT INTO Item (item_id, transactions_id, store_id, price, item_type, name, description, created) VALUES (971, 183, 5, 924, 'Books', 'name_971', 'description_971', CURRENT_TIMESTAMP);
INSERT INTO Item (item_id, transactions_id, store_id, price, item_type, name, description, created) VALUES (972, 380, 13, 80, 'Toys', 'name_972', 'description_972', CURRENT_TIMESTAMP);
INSERT INTO Item (item_id, transactions_id, store_id, price, item_type, name, description, created) VALUES (973, 272, 8, 87, 'Toys', 'name_973', 'description_973', CURRENT_TIMESTAMP);
INSERT INTO Item (item_id, transactions_id, store_id, price, item_type, name, description, created) VALUES (974, 414, 10, 779, 'Home', 'name_974', 'description_974', CURRENT_TIMESTAMP);
INSERT INTO Item (item_id, transactions_id, store_id, price, item_type, name, description, created) VALUES (975, 152, 9, 45, 'Electronics', 'name_975', 'description_975', CURRENT_TIMESTAMP);
INSERT INTO Item (item_id, transactions_id, store_id, price, item_type, name, description, created) VALUES (976, 495, 7, 116, 'Toys', 'name_976', 'description_976', CURRENT_TIMESTAMP);
INSERT INTO Item (item_id, transactions_id, store_id, price, item_type, name, description, created) VALUES (977, 476, 5, 248, 'Home', 'name_977', 'description_977', CURRENT_TIMESTAMP);
INSERT INTO Item (item_id, transactions_id, store_id, price, item_type, name, description, created) VALUES (978, 421, 8, 566, 'Toys', 'name_978', 'description_978', CURRENT_TIMESTAMP);
INSERT INTO Item (item_id, transactions_id, store_id, price, item_type, name, description, created) VALUES (979, 132, 2, 833, 'Toys', 'name_979', 'description_979', CURRENT_TIMESTAMP);
INSERT INTO Item (item_id, transactions_id, store_id, price, item_type, name, description, created) VALUES (980, 161, 3, 113, 'Electronics', 'name_980', 'description_980', CURRENT_TIMESTAMP);
INSERT INTO Item (item_id, transactions_id, store_id, price, item_type, name, description, created) VALUES (981, 202, 12, 933, 'Toys', 'name_981', 'description_981', CURRENT_TIMESTAMP);
INSERT INTO Item (item_id, transactions_id, store_id, price, item_type, name, description, created) VALUES (982, 457, 1, 864, 'Health', 'name_982', 'description_982', CURRENT_TIMESTAMP);
INSERT INTO Item (item_id, transactions_id, store_id, price, item_type, name, description, created) VALUES (983, 460, 2, 114, 'Home', 'name_983', 'description_983', CURRENT_TIMESTAMP);
INSERT INTO Item (item_id, transactions_id, store_id, price, item_type, name, description, created) VALUES (984, 275, 8, 867, 'Books', 'name_984', 'description_984', CURRENT_TIMESTAMP);
INSERT INTO Item (item_id, transactions_id, store_id, price, item_type, name, description, created) VALUES (985, 238, 11, 387, 'Books', 'name_985', 'description_985', CURRENT_TIMESTAMP);
INSERT INTO Item (item_id, transactions_id, store_id, price, item_type, name, description, created) VALUES (986, 66, 14, 483, 'Home', 'name_986', 'description_986', CURRENT_TIMESTAMP);
INSERT INTO Item (item_id, transactions_id, store_id, price, item_type, name, description, created) VALUES (987, 222, 12, 537, 'Health', 'name_987', 'description_987', CURRENT_TIMESTAMP);
INSERT INTO Item (item_id, transactions_id, store_id, price, item_type, name, description, created) VALUES (988, 361, 2, 297, 'Home', 'name_988', 'description_988', CURRENT_TIMESTAMP);
INSERT INTO Item (item_id, transactions_id, store_id, price, item_type, name, description, created) VALUES (989, 397, 10, 931, 'Home', 'name_989', 'description_989', CURRENT_TIMESTAMP);
INSERT INTO Item (item_id, transactions_id, store_id, price, item_type, name, description, created) VALUES (990, 103, 11, 753, 'Books', 'name_990', 'description_990', CURRENT_TIMESTAMP);
INSERT INTO Item (item_id, transactions_id, store_id, price, item_type, name, description, created) VALUES (991, 89, 5, 123, 'Electronics', 'name_991', 'description_991', CURRENT_TIMESTAMP);
INSERT INTO Item (item_id, transactions_id, store_id, price, item_type, name, description, created) VALUES (992, 461, 3, 447, 'Electronics', 'name_992', 'description_992', CURRENT_TIMESTAMP);
INSERT INTO Item (item_id, transactions_id, store_id, price, item_type, name, description, created) VALUES (993, 204, 8, 799, 'Health', 'name_993', 'description_993', CURRENT_TIMESTAMP);
INSERT INTO Item (item_id, transactions_id, store_id, price, item_type, name, description, created) VALUES (994, 298, 7, 23, 'Electronics', 'name_994', 'description_994', CURRENT_TIMESTAMP);
INSERT INTO Item (item_id, transactions_id, store_id, price, item_type, name, description, created) VALUES (995, 391, 12, 790, 'Electronics', 'name_995', 'description_995', CURRENT_TIMESTAMP);
INSERT INTO Item (item_id, transactions_id, store_id, price, item_type, name, description, created) VALUES (996, 401, 8, 350, 'Health', 'name_996', 'description_996', CURRENT_TIMESTAMP);
INSERT INTO Item (item_id, transactions_id, store_id, price, item_type, name, description, created) VALUES (997, 92, 5, 314, 'Health', 'name_997', 'description_997', CURRENT_TIMESTAMP);
INSERT INTO Item (item_id, transactions_id, store_id, price, item_type, name, description, created) VALUES (998, 314, 6, 250, 'Home', 'name_998', 'description_998', CURRENT_TIMESTAMP);
INSERT INTO Item (item_id, transactions_id, store_id, price, item_type, name, description, created) VALUES (999, 291, 12, 765, 'Home', 'name_999', 'description_999', CURRENT_TIMESTAMP);
INSERT INTO Item (item_id, transactions_id, store_id, price, item_type, name, description, created) VALUES (1000, 299, 12, 942, 'Health', 'name_1000', 'description_1000', CURRENT_TIMESTAMP);
INSERT INTO Item (item_id, transactions_id, store_id, price, item_type, name, description, created) VALUES (1001, 392, 13, 529, 'Home', 'name_1001', 'description_1001', CURRENT_TIMESTAMP);
INSERT INTO Item (item_id, transactions_id, store_id, price, item_type, name, description, created) VALUES (1002, 123, 12, 659, 'Health', 'name_1002', 'description_1002', CURRENT_TIMESTAMP);
INSERT INTO Item (item_id, transactions_id, store_id, price, item_type, name, description, created) VALUES (1003, 367, 7, 478, 'Toys', 'name_1003', 'description_1003', CURRENT_TIMESTAMP);
INSERT INTO Item (item_id, transactions_id, store_id, price, item_type, name, description, created) VALUES (1004, 126, 7, 711, 'Electronics', 'name_1004', 'description_1004', CURRENT_TIMESTAMP);
INSERT INTO Item (item_id, transactions_id, store_id, price, item_type, name, description, created) VALUES (1005, 415, 13, 22, 'Home', 'name_1005', 'description_1005', CURRENT_TIMESTAMP);
INSERT INTO Item (item_id, transactions_id, store_id, price, item_type, name, description, created) VALUES (1006, 194, 14, 11, 'Electronics', 'name_1006', 'description_1006', CURRENT_TIMESTAMP);
INSERT INTO Item (item_id, transactions_id, store_id, price, item_type, name, description, created) VALUES (1007, 207, 14, 545, 'Home', 'name_1007', 'description_1007', CURRENT_TIMESTAMP);
INSERT INTO Item (item_id, transactions_id, store_id, price, item_type, name, description, created) VALUES (1008, 19, 10, 514, 'Books', 'name_1008', 'description_1008', CURRENT_TIMESTAMP);
INSERT INTO Item (item_id, transactions_id, store_id, price, item_type, name, description, created) VALUES (1009, 484, 12, 134, 'Health', 'name_1009', 'description_1009', CURRENT_TIMESTAMP);
INSERT INTO Item (item_id, transactions_id, store_id, price, item_type, name, description, created) VALUES (1010, 350, 7, 444, 'Electronics', 'name_1010', 'description_1010', CURRENT_TIMESTAMP);
INSERT INTO Item (item_id, transactions_id, store_id, price, item_type, name, description, created) VALUES (1011, 206, 2, 2, 'Health', 'name_1011', 'description_1011', CURRENT_TIMESTAMP);
INSERT INTO Item (item_id, transactions_id, store_id, price, item_type, name, description, created) VALUES (1012, 261, 8, 947, 'Electronics', 'name_1012', 'description_1012', CURRENT_TIMESTAMP);
INSERT INTO Item (item_id, transactions_id, store_id, price, item_type, name, description, created) VALUES (1013, 221, 2, 526, 'Home', 'name_1013', 'description_1013', CURRENT_TIMESTAMP);
INSERT INTO Item (item_id, transactions_id, store_id, price, item_type, name, description, created) VALUES (1014, 238, 1, 250, 'Electronics', 'name_1014', 'description_1014', CURRENT_TIMESTAMP);
INSERT INTO Item (item_id, transactions_id, store_id, price, item_type, name, description, created) VALUES (1015, 487, 14, 674, 'Health', 'name_1015', 'description_1015', CURRENT_TIMESTAMP);
INSERT INTO Item (item_id, transactions_id, store_id, price, item_type, name, description, created) VALUES (1016, 175, 4, 741, 'Toys', 'name_1016', 'description_1016', CURRENT_TIMESTAMP);
INSERT INTO Item (item_id, transactions_id, store_id, price, item_type, name, description, created) VALUES (1017, 464, 6, 763, 'Books', 'name_1017', 'description_1017', CURRENT_TIMESTAMP);
INSERT INTO Item (item_id, transactions_id, store_id, price, item_type, name, description, created) VALUES (1018, 258, 1, 589, 'Home', 'name_1018', 'description_1018', CURRENT_TIMESTAMP);
INSERT INTO Item (item_id, transactions_id, store_id, price, item_type, name, description, created) VALUES (1019, 375, 5, 807, 'Health', 'name_1019', 'description_1019', CURRENT_TIMESTAMP);
INSERT INTO Item (item_id, transactions_id, store_id, price, item_type, name, description, created) VALUES (1020, 376, 8, 602, 'Books', 'name_1020', 'description_1020', CURRENT_TIMESTAMP);
INSERT INTO Item (item_id, transactions_id, store_id, price, item_type, name, description, created) VALUES (1021, 493, 14, 1005, 'Health', 'name_1021', 'description_1021', CURRENT_TIMESTAMP);
INSERT INTO Item (item_id, transactions_id, store_id, price, item_type, name, description, created) VALUES (1022, 149, 10, 383, 'Toys', 'name_1022', 'description_1022', CURRENT_TIMESTAMP);
INSERT INTO Item (item_id, transactions_id, store_id, price, item_type, name, description, created) VALUES (1023, 161, 11, 148, 'Health', 'name_1023', 'description_1023', CURRENT_TIMESTAMP);
INSERT INTO Item (item_id, transactions_id, store_id, price, item_type, name, description, created) VALUES (1024, 101, 12, 559, 'Books', 'name_1024', 'description_1024', CURRENT_TIMESTAMP);
INSERT INTO Item (item_id, transactions_id, store_id, price, item_type, name, description, created) VALUES (1025, 324, 14, 975, 'Health', 'name_1025', 'description_1025', CURRENT_TIMESTAMP);
INSERT INTO Item (item_id, transactions_id, store_id, price, item_type, name, description, created) VALUES (1026, 350, 11, 145, 'Electronics', 'name_1026', 'description_1026', CURRENT_TIMESTAMP);
INSERT INTO Item (item_id, transactions_id, store_id, price, item_type, name, description, created) VALUES (1027, 10, 7, 784, 'Electronics', 'name_1027', 'description_1027', CURRENT_TIMESTAMP);
INSERT INTO Item (item_id, transactions_id, store_id, price, item_type, name, description, created) VALUES (1028, 461, 14, 497, 'Home', 'name_1028', 'description_1028', CURRENT_TIMESTAMP);
INSERT INTO Item (item_id, transactions_id, store_id, price, item_type, name, description, created) VALUES (1029, 486, 3, 207, 'Home', 'name_1029', 'description_1029', CURRENT_TIMESTAMP);
INSERT INTO Item (item_id, transactions_id, store_id, price, item_type, name, description, created) VALUES (1030, 196, 5, 464, 'Books', 'name_1030', 'description_1030', CURRENT_TIMESTAMP);
INSERT INTO Item (item_id, transactions_id, store_id, price, item_type, name, description, created) VALUES (1031, 412, 8, 936, 'Electronics', 'name_1031', 'description_1031', CURRENT_TIMESTAMP);
INSERT INTO Item (item_id, transactions_id, store_id, price, item_type, name, description, created) VALUES (1032, 461, 12, 321, 'Electronics', 'name_1032', 'description_1032', CURRENT_TIMESTAMP);
INSERT INTO Item (item_id, transactions_id, store_id, price, item_type, name, description, created) VALUES (1033, 79, 5, 639, 'Electronics', 'name_1033', 'description_1033', CURRENT_TIMESTAMP);
INSERT INTO Item (item_id, transactions_id, store_id, price, item_type, name, description, created) VALUES (1034, 106, 14, 482, 'Toys', 'name_1034', 'description_1034', CURRENT_TIMESTAMP);
INSERT INTO Item (item_id, transactions_id, store_id, price, item_type, name, description, created) VALUES (1035, 446, 10, 937, 'Health', 'name_1035', 'description_1035', CURRENT_TIMESTAMP);
INSERT INTO Item (item_id, transactions_id, store_id, price, item_type, name, description, created) VALUES (1036, 259, 14, 810, 'Home', 'name_1036', 'description_1036', CURRENT_TIMESTAMP);
INSERT INTO Item (item_id, transactions_id, store_id, price, item_type, name, description, created) VALUES (1037, 402, 12, 232, 'Home', 'name_1037', 'description_1037', CURRENT_TIMESTAMP);
INSERT INTO Item (item_id, transactions_id, store_id, price, item_type, name, description, created) VALUES (1038, 189, 8, 757, 'Health', 'name_1038', 'description_1038', CURRENT_TIMESTAMP);
INSERT INTO Item (item_id, transactions_id, store_id, price, item_type, name, description, created) VALUES (1039, 33, 11, 136, 'Books', 'name_1039', 'description_1039', CURRENT_TIMESTAMP);
INSERT INTO Item (item_id, transactions_id, store_id, price, item_type, name, description, created) VALUES (1040, 258, 2, 976, 'Home', 'name_1040', 'description_1040', CURRENT_TIMESTAMP);
INSERT INTO Item (item_id, transactions_id, store_id, price, item_type, name, description, created) VALUES (1041, 492, 5, 106, 'Home', 'name_1041', 'description_1041', CURRENT_TIMESTAMP);
INSERT INTO Item (item_id, transactions_id, store_id, price, item_type, name, description, created) VALUES (1042, 270, 12, 960, 'Toys', 'name_1042', 'description_1042', CURRENT_TIMESTAMP);
INSERT INTO Item (item_id, transactions_id, store_id, price, item_type, name, description, created) VALUES (1043, 388, 5, 190, 'Books', 'name_1043', 'description_1043', CURRENT_TIMESTAMP);
INSERT INTO Item (item_id, transactions_id, store_id, price, item_type, name, description, created) VALUES (1044, 206, 5, 220, 'Books', 'name_1044', 'description_1044', CURRENT_TIMESTAMP);
INSERT INTO Item (item_id, transactions_id, store_id, price, item_type, name, description, created) VALUES (1045, 380, 4, 111, 'Toys', 'name_1045', 'description_1045', CURRENT_TIMESTAMP);
INSERT INTO Item (item_id, transactions_id, store_id, price, item_type, name, description, created) VALUES (1046, 366, 13, 180, 'Toys', 'name_1046', 'description_1046', CURRENT_TIMESTAMP);
INSERT INTO Item (item_id, transactions_id, store_id, price, item_type, name, description, created) VALUES (1047, 26, 7, 985, 'Home', 'name_1047', 'description_1047', CURRENT_TIMESTAMP);
INSERT INTO Item (item_id, transactions_id, store_id, price, item_type, name, description, created) VALUES (1048, 323, 2, 983, 'Books', 'name_1048', 'description_1048', CURRENT_TIMESTAMP);
INSERT INTO Item (item_id, transactions_id, store_id, price, item_type, name, description, created) VALUES (1049, 15, 12, 793, 'Health', 'name_1049', 'description_1049', CURRENT_TIMESTAMP);
INSERT INTO Item (item_id, transactions_id, store_id, price, item_type, name, description, created) VALUES (1050, 3, 11, 994, 'Health', 'name_1050', 'description_1050', CURRENT_TIMESTAMP);
INSERT INTO Item (item_id, transactions_id, store_id, price, item_type, name, description, created) VALUES (1051, 212, 5, 667, 'Home', 'name_1051', 'description_1051', CURRENT_TIMESTAMP);
INSERT INTO Item (item_id, transactions_id, store_id, price, item_type, name, description, created) VALUES (1052, 295, 2, 228, 'Books', 'name_1052', 'description_1052', CURRENT_TIMESTAMP);
INSERT INTO Item (item_id, transactions_id, store_id, price, item_type, name, description, created) VALUES (1053, 100, 11, 186, 'Health', 'name_1053', 'description_1053', CURRENT_TIMESTAMP);
INSERT INTO Item (item_id, transactions_id, store_id, price, item_type, name, description, created) VALUES (1054, 174, 12, 5, 'Health', 'name_1054', 'description_1054', CURRENT_TIMESTAMP);
INSERT INTO Item (item_id, transactions_id, store_id, price, item_type, name, description, created) VALUES (1055, 60, 2, 824, 'Electronics', 'name_1055', 'description_1055', CURRENT_TIMESTAMP);
INSERT INTO Item (item_id, transactions_id, store_id, price, item_type, name, description, created) VALUES (1056, 344, 6, 608, 'Books', 'name_1056', 'description_1056', CURRENT_TIMESTAMP);
INSERT INTO Item (item_id, transactions_id, store_id, price, item_type, name, description, created) VALUES (1057, 40, 8, 888, 'Electronics', 'name_1057', 'description_1057', CURRENT_TIMESTAMP);
INSERT INTO Item (item_id, transactions_id, store_id, price, item_type, name, description, created) VALUES (1058, 138, 10, 299, 'Electronics', 'name_1058', 'description_1058', CURRENT_TIMESTAMP);
INSERT INTO Item (item_id, transactions_id, store_id, price, item_type, name, description, created) VALUES (1059, 264, 14, 511, 'Health', 'name_1059', 'description_1059', CURRENT_TIMESTAMP);
INSERT INTO Item (item_id, transactions_id, store_id, price, item_type, name, description, created) VALUES (1060, 134, 12, 354, 'Toys', 'name_1060', 'description_1060', CURRENT_TIMESTAMP);
INSERT INTO Item (item_id, transactions_id, store_id, price, item_type, name, description, created) VALUES (1061, 155, 2, 288, 'Electronics', 'name_1061', 'description_1061', CURRENT_TIMESTAMP);
INSERT INTO Item (item_id, transactions_id, store_id, price, item_type, name, description, created) VALUES (1062, 167, 7, 412, 'Books', 'name_1062', 'description_1062', CURRENT_TIMESTAMP);
INSERT INTO Item (item_id, transactions_id, store_id, price, item_type, name, description, created) VALUES (1063, 36, 13, 294, 'Health', 'name_1063', 'description_1063', CURRENT_TIMESTAMP);
INSERT INTO Item (item_id, transactions_id, store_id, price, item_type, name, description, created) VALUES (1064, 212, 11, 32, 'Books', 'name_1064', 'description_1064', CURRENT_TIMESTAMP);
INSERT INTO Item (item_id, transactions_id, store_id, price, item_type, name, description, created) VALUES (1065, 38, 5, 910, 'Home', 'name_1065', 'description_1065', CURRENT_TIMESTAMP);
INSERT INTO Item (item_id, transactions_id, store_id, price, item_type, name, description, created) VALUES (1066, 490, 7, 604, 'Toys', 'name_1066', 'description_1066', CURRENT_TIMESTAMP);
INSERT INTO Item (item_id, transactions_id, store_id, price, item_type, name, description, created) VALUES (1067, 324, 13, 649, 'Home', 'name_1067', 'description_1067', CURRENT_TIMESTAMP);
INSERT INTO Item (item_id, transactions_id, store_id, price, item_type, name, description, created) VALUES (1068, 70, 1, 536, 'Home', 'name_1068', 'description_1068', CURRENT_TIMESTAMP);
INSERT INTO Item (item_id, transactions_id, store_id, price, item_type, name, description, created) VALUES (1069, 344, 3, 378, 'Toys', 'name_1069', 'description_1069', CURRENT_TIMESTAMP);
INSERT INTO Item (item_id, transactions_id, store_id, price, item_type, name, description, created) VALUES (1070, 215, 7, 227, 'Home', 'name_1070', 'description_1070', CURRENT_TIMESTAMP);
INSERT INTO Item (item_id, transactions_id, store_id, price, item_type, name, description, created) VALUES (1071, 38, 9, 32, 'Health', 'name_1071', 'description_1071', CURRENT_TIMESTAMP);
INSERT INTO Item (item_id, transactions_id, store_id, price, item_type, name, description, created) VALUES (1072, 170, 14, 278, 'Books', 'name_1072', 'description_1072', CURRENT_TIMESTAMP);
INSERT INTO Item (item_id, transactions_id, store_id, price, item_type, name, description, created) VALUES (1073, 244, 10, 709, 'Electronics', 'name_1073', 'description_1073', CURRENT_TIMESTAMP);
INSERT INTO Item (item_id, transactions_id, store_id, price, item_type, name, description, created) VALUES (1074, 197, 3, 49, 'Toys', 'name_1074', 'description_1074', CURRENT_TIMESTAMP);
INSERT INTO Item (item_id, transactions_id, store_id, price, item_type, name, description, created) VALUES (1075, 235, 2, 934, 'Electronics', 'name_1075', 'description_1075', CURRENT_TIMESTAMP);
INSERT INTO Item (item_id, transactions_id, store_id, price, item_type, name, description, created) VALUES (1076, 242, 7, 482, 'Health', 'name_1076', 'description_1076', CURRENT_TIMESTAMP);
INSERT INTO Item (item_id, transactions_id, store_id, price, item_type, name, description, created) VALUES (1077, 67, 3, 463, 'Toys', 'name_1077', 'description_1077', CURRENT_TIMESTAMP);
INSERT INTO Item (item_id, transactions_id, store_id, price, item_type, name, description, created) VALUES (1078, 312, 1, 323, 'Toys', 'name_1078', 'description_1078', CURRENT_TIMESTAMP);
INSERT INTO Item (item_id, transactions_id, store_id, price, item_type, name, description, created) VALUES (1079, 418, 6, 743, 'Health', 'name_1079', 'description_1079', CURRENT_TIMESTAMP);
INSERT INTO Item (item_id, transactions_id, store_id, price, item_type, name, description, created) VALUES (1080, 458, 11, 715, 'Books', 'name_1080', 'description_1080', CURRENT_TIMESTAMP);
INSERT INTO Item (item_id, transactions_id, store_id, price, item_type, name, description, created) VALUES (1081, 368, 14, 67, 'Toys', 'name_1081', 'description_1081', CURRENT_TIMESTAMP);
INSERT INTO Item (item_id, transactions_id, store_id, price, item_type, name, description, created) VALUES (1082, 319, 10, 171, 'Health', 'name_1082', 'description_1082', CURRENT_TIMESTAMP);
INSERT INTO Item (item_id, transactions_id, store_id, price, item_type, name, description, created) VALUES (1083, 306, 8, 686, 'Toys', 'name_1083', 'description_1083', CURRENT_TIMESTAMP);
INSERT INTO Item (item_id, transactions_id, store_id, price, item_type, name, description, created) VALUES (1084, 108, 8, 924, 'Books', 'name_1084', 'description_1084', CURRENT_TIMESTAMP);
INSERT INTO Item (item_id, transactions_id, store_id, price, item_type, name, description, created) VALUES (1085, 190, 7, 718, 'Home', 'name_1085', 'description_1085', CURRENT_TIMESTAMP);
INSERT INTO Item (item_id, transactions_id, store_id, price, item_type, name, description, created) VALUES (1086, 139, 9, 728, 'Health', 'name_1086', 'description_1086', CURRENT_TIMESTAMP);
INSERT INTO Item (item_id, transactions_id, store_id, price, item_type, name, description, created) VALUES (1087, 20, 6, 909, 'Toys', 'name_1087', 'description_1087', CURRENT_TIMESTAMP);
INSERT INTO Item (item_id, transactions_id, store_id, price, item_type, name, description, created) VALUES (1088, 254, 2, 912, 'Electronics', 'name_1088', 'description_1088', CURRENT_TIMESTAMP);
INSERT INTO Item (item_id, transactions_id, store_id, price, item_type, name, description, created) VALUES (1089, 239, 7, 907, 'Home', 'name_1089', 'description_1089', CURRENT_TIMESTAMP);
INSERT INTO Item (item_id, transactions_id, store_id, price, item_type, name, description, created) VALUES (1090, 202, 5, 260, 'Health', 'name_1090', 'description_1090', CURRENT_TIMESTAMP);
INSERT INTO Item (item_id, transactions_id, store_id, price, item_type, name, description, created) VALUES (1091, 203, 7, 367, 'Toys', 'name_1091', 'description_1091', CURRENT_TIMESTAMP);
INSERT INTO Item (item_id, transactions_id, store_id, price, item_type, name, description, created) VALUES (1092, 11, 1, 24, 'Toys', 'name_1092', 'description_1092', CURRENT_TIMESTAMP);
INSERT INTO Item (item_id, transactions_id, store_id, price, item_type, name, description, created) VALUES (1093, 314, 13, 1086, 'Toys', 'name_1093', 'description_1093', CURRENT_TIMESTAMP);
INSERT INTO Item (item_id, transactions_id, store_id, price, item_type, name, description, created) VALUES (1094, 457, 8, 338, 'Health', 'name_1094', 'description_1094', CURRENT_TIMESTAMP);
INSERT INTO Item (item_id, transactions_id, store_id, price, item_type, name, description, created) VALUES (1095, 277, 10, 894, 'Books', 'name_1095', 'description_1095', CURRENT_TIMESTAMP);
INSERT INTO Item (item_id, transactions_id, store_id, price, item_type, name, description, created) VALUES (1096, 174, 2, 1016, 'Health', 'name_1096', 'description_1096', CURRENT_TIMESTAMP);
INSERT INTO Item (item_id, transactions_id, store_id, price, item_type, name, description, created) VALUES (1097, 193, 7, 619, 'Toys', 'name_1097', 'description_1097', CURRENT_TIMESTAMP);
INSERT INTO Item (item_id, transactions_id, store_id, price, item_type, name, description, created) VALUES (1098, 53, 12, 274, 'Home', 'name_1098', 'description_1098', CURRENT_TIMESTAMP);
INSERT INTO Item (item_id, transactions_id, store_id, price, item_type, name, description, created) VALUES (1099, 364, 6, 70, 'Home', 'name_1099', 'description_1099', CURRENT_TIMESTAMP);
INSERT INTO Item (item_id, transactions_id, store_id, price, item_type, name, description, created) VALUES (1100, 19, 3, 358, 'Health', 'name_1100', 'description_1100', CURRENT_TIMESTAMP);
INSERT INTO Item (item_id, transactions_id, store_id, price, item_type, name, description, created) VALUES (1101, 101, 10, 351, 'Electronics', 'name_1101', 'description_1101', CURRENT_TIMESTAMP);
INSERT INTO Item (item_id, transactions_id, store_id, price, item_type, name, description, created) VALUES (1102, 277, 9, 962, 'Toys', 'name_1102', 'description_1102', CURRENT_TIMESTAMP);
INSERT INTO Item (item_id, transactions_id, store_id, price, item_type, name, description, created) VALUES (1103, 123, 13, 215, 'Books', 'name_1103', 'description_1103', CURRENT_TIMESTAMP);
INSERT INTO Item (item_id, transactions_id, store_id, price, item_type, name, description, created) VALUES (1104, 157, 7, 442, 'Health', 'name_1104', 'description_1104', CURRENT_TIMESTAMP);
INSERT INTO Item (item_id, transactions_id, store_id, price, item_type, name, description, created) VALUES (1105, 19, 9, 455, 'Home', 'name_1105', 'description_1105', CURRENT_TIMESTAMP);
INSERT INTO Item (item_id, transactions_id, store_id, price, item_type, name, description, created) VALUES (1106, 9, 11, 91, 'Home', 'name_1106', 'description_1106', CURRENT_TIMESTAMP);
INSERT INTO Item (item_id, transactions_id, store_id, price, item_type, name, description, created) VALUES (1107, 435, 9, 78, 'Electronics', 'name_1107', 'description_1107', CURRENT_TIMESTAMP);
INSERT INTO Item (item_id, transactions_id, store_id, price, item_type, name, description, created) VALUES (1108, 481, 10, 496, 'Health', 'name_1108', 'description_1108', CURRENT_TIMESTAMP);
INSERT INTO Item (item_id, transactions_id, store_id, price, item_type, name, description, created) VALUES (1109, 184, 8, 327, 'Home', 'name_1109', 'description_1109', CURRENT_TIMESTAMP);
INSERT INTO Item (item_id, transactions_id, store_id, price, item_type, name, description, created) VALUES (1110, 335, 7, 2, 'Electronics', 'name_1110', 'description_1110', CURRENT_TIMESTAMP);
INSERT INTO Item (item_id, transactions_id, store_id, price, item_type, name, description, created) VALUES (1111, 27, 8, 588, 'Books', 'name_1111', 'description_1111', CURRENT_TIMESTAMP);
INSERT INTO Item (item_id, transactions_id, store_id, price, item_type, name, description, created) VALUES (1112, 36, 4, 914, 'Toys', 'name_1112', 'description_1112', CURRENT_TIMESTAMP);
INSERT INTO Item (item_id, transactions_id, store_id, price, item_type, name, description, created) VALUES (1113, 263, 2, 26, 'Health', 'name_1113', 'description_1113', CURRENT_TIMESTAMP);
INSERT INTO Item (item_id, transactions_id, store_id, price, item_type, name, description, created) VALUES (1114, 48, 11, 183, 'Toys', 'name_1114', 'description_1114', CURRENT_TIMESTAMP);
INSERT INTO Item (item_id, transactions_id, store_id, price, item_type, name, description, created) VALUES (1115, 199, 4, 503, 'Books', 'name_1115', 'description_1115', CURRENT_TIMESTAMP);
INSERT INTO Item (item_id, transactions_id, store_id, price, item_type, name, description, created) VALUES (1116, 399, 12, 1072, 'Books', 'name_1116', 'description_1116', CURRENT_TIMESTAMP);
INSERT INTO Item (item_id, transactions_id, store_id, price, item_type, name, description, created) VALUES (1117, 44, 10, 326, 'Books', 'name_1117', 'description_1117', CURRENT_TIMESTAMP);
INSERT INTO Item (item_id, transactions_id, store_id, price, item_type, name, description, created) VALUES (1118, 216, 1, 997, 'Books', 'name_1118', 'description_1118', CURRENT_TIMESTAMP);
INSERT INTO Item (item_id, transactions_id, store_id, price, item_type, name, description, created) VALUES (1119, 199, 14, 489, 'Toys', 'name_1119', 'description_1119', CURRENT_TIMESTAMP);
INSERT INTO Item (item_id, transactions_id, store_id, price, item_type, name, description, created) VALUES (1120, 194, 7, 899, 'Home', 'name_1120', 'description_1120', CURRENT_TIMESTAMP);
INSERT INTO Item (item_id, transactions_id, store_id, price, item_type, name, description, created) VALUES (1121, 323, 4, 151, 'Electronics', 'name_1121', 'description_1121', CURRENT_TIMESTAMP);
INSERT INTO Item (item_id, transactions_id, store_id, price, item_type, name, description, created) VALUES (1122, 378, 5, 601, 'Home', 'name_1122', 'description_1122', CURRENT_TIMESTAMP);
INSERT INTO Item (item_id, transactions_id, store_id, price, item_type, name, description, created) VALUES (1123, 282, 12, 1013, 'Toys', 'name_1123', 'description_1123', CURRENT_TIMESTAMP);
INSERT INTO Item (item_id, transactions_id, store_id, price, item_type, name, description, created) VALUES (1124, 267, 6, 854, 'Health', 'name_1124', 'description_1124', CURRENT_TIMESTAMP);
INSERT INTO Item (item_id, transactions_id, store_id, price, item_type, name, description, created) VALUES (1125, 177, 6, 170, 'Home', 'name_1125', 'description_1125', CURRENT_TIMESTAMP);
INSERT INTO Item (item_id, transactions_id, store_id, price, item_type, name, description, created) VALUES (1126, 134, 2, 241, 'Electronics', 'name_1126', 'description_1126', CURRENT_TIMESTAMP);
INSERT INTO Item (item_id, transactions_id, store_id, price, item_type, name, description, created) VALUES (1127, 156, 7, 101, 'Health', 'name_1127', 'description_1127', CURRENT_TIMESTAMP);
INSERT INTO Item (item_id, transactions_id, store_id, price, item_type, name, description, created) VALUES (1128, 329, 10, 109, 'Electronics', 'name_1128', 'description_1128', CURRENT_TIMESTAMP);
INSERT INTO Item (item_id, transactions_id, store_id, price, item_type, name, description, created) VALUES (1129, 395, 1, 299, 'Electronics', 'name_1129', 'description_1129', CURRENT_TIMESTAMP);
INSERT INTO Item (item_id, transactions_id, store_id, price, item_type, name, description, created) VALUES (1130, 444, 4, 682, 'Books', 'name_1130', 'description_1130', CURRENT_TIMESTAMP);
INSERT INTO Item (item_id, transactions_id, store_id, price, item_type, name, description, created) VALUES (1131, 60, 11, 6, 'Electronics', 'name_1131', 'description_1131', CURRENT_TIMESTAMP);
INSERT INTO Item (item_id, transactions_id, store_id, price, item_type, name, description, created) VALUES (1132, 317, 13, 1044, 'Health', 'name_1132', 'description_1132', CURRENT_TIMESTAMP);
INSERT INTO Item (item_id, transactions_id, store_id, price, item_type, name, description, created) VALUES (1133, 255, 11, 315, 'Home', 'name_1133', 'description_1133', CURRENT_TIMESTAMP);
INSERT INTO Item (item_id, transactions_id, store_id, price, item_type, name, description, created) VALUES (1134, 193, 9, 405, 'Electronics', 'name_1134', 'description_1134', CURRENT_TIMESTAMP);
INSERT INTO Item (item_id, transactions_id, store_id, price, item_type, name, description, created) VALUES (1135, 149, 6, 702, 'Home', 'name_1135', 'description_1135', CURRENT_TIMESTAMP);
INSERT INTO Item (item_id, transactions_id, store_id, price, item_type, name, description, created) VALUES (1136, 317, 13, 827, 'Books', 'name_1136', 'description_1136', CURRENT_TIMESTAMP);
INSERT INTO Item (item_id, transactions_id, store_id, price, item_type, name, description, created) VALUES (1137, 479, 8, 498, 'Home', 'name_1137', 'description_1137', CURRENT_TIMESTAMP);
INSERT INTO Item (item_id, transactions_id, store_id, price, item_type, name, description, created) VALUES (1138, 231, 11, 77, 'Books', 'name_1138', 'description_1138', CURRENT_TIMESTAMP);
INSERT INTO Item (item_id, transactions_id, store_id, price, item_type, name, description, created) VALUES (1139, 17, 8, 1027, 'Electronics', 'name_1139', 'description_1139', CURRENT_TIMESTAMP);
INSERT INTO Item (item_id, transactions_id, store_id, price, item_type, name, description, created) VALUES (1140, 444, 4, 853, 'Health', 'name_1140', 'description_1140', CURRENT_TIMESTAMP);
INSERT INTO Item (item_id, transactions_id, store_id, price, item_type, name, description, created) VALUES (1141, 64, 14, 324, 'Toys', 'name_1141', 'description_1141', CURRENT_TIMESTAMP);
INSERT INTO Item (item_id, transactions_id, store_id, price, item_type, name, description, created) VALUES (1142, 345, 14, 525, 'Home', 'name_1142', 'description_1142', CURRENT_TIMESTAMP);
INSERT INTO Item (item_id, transactions_id, store_id, price, item_type, name, description, created) VALUES (1143, 184, 11, 1040, 'Health', 'name_1143', 'description_1143', CURRENT_TIMESTAMP);
INSERT INTO Item (item_id, transactions_id, store_id, price, item_type, name, description, created) VALUES (1144, 410, 2, 500, 'Electronics', 'name_1144', 'description_1144', CURRENT_TIMESTAMP);
INSERT INTO Item (item_id, transactions_id, store_id, price, item_type, name, description, created) VALUES (1145, 117, 3, 109, 'Toys', 'name_1145', 'description_1145', CURRENT_TIMESTAMP);
INSERT INTO Item (item_id, transactions_id, store_id, price, item_type, name, description, created) VALUES (1146, 113, 12, 1030, 'Books', 'name_1146', 'description_1146', CURRENT_TIMESTAMP);
INSERT INTO Item (item_id, transactions_id, store_id, price, item_type, name, description, created) VALUES (1147, 211, 3, 195, 'Toys', 'name_1147', 'description_1147', CURRENT_TIMESTAMP);
INSERT INTO Item (item_id, transactions_id, store_id, price, item_type, name, description, created) VALUES (1148, 407, 7, 33, 'Health', 'name_1148', 'description_1148', CURRENT_TIMESTAMP);
INSERT INTO Item (item_id, transactions_id, store_id, price, item_type, name, description, created) VALUES (1149, 406, 13, 75, 'Home', 'name_1149', 'description_1149', CURRENT_TIMESTAMP);
INSERT INTO Item (item_id, transactions_id, store_id, price, item_type, name, description, created) VALUES (1150, 462, 6, 335, 'Electronics', 'name_1150', 'description_1150', CURRENT_TIMESTAMP);
INSERT INTO Item (item_id, transactions_id, store_id, price, item_type, name, description, created) VALUES (1151, 103, 3, 424, 'Books', 'name_1151', 'description_1151', CURRENT_TIMESTAMP);
INSERT INTO Item (item_id, transactions_id, store_id, price, item_type, name, description, created) VALUES (1152, 16, 7, 1112, 'Electronics', 'name_1152', 'description_1152', CURRENT_TIMESTAMP);
INSERT INTO Item (item_id, transactions_id, store_id, price, item_type, name, description, created) VALUES (1153, 500, 11, 763, 'Electronics', 'name_1153', 'description_1153', CURRENT_TIMESTAMP);
INSERT INTO Item (item_id, transactions_id, store_id, price, item_type, name, description, created) VALUES (1154, 56, 5, 983, 'Electronics', 'name_1154', 'description_1154', CURRENT_TIMESTAMP);
INSERT INTO Item (item_id, transactions_id, store_id, price, item_type, name, description, created) VALUES (1155, 421, 13, 720, 'Electronics', 'name_1155', 'description_1155', CURRENT_TIMESTAMP);
INSERT INTO Item (item_id, transactions_id, store_id, price, item_type, name, description, created) VALUES (1156, 354, 9, 24, 'Electronics', 'name_1156', 'description_1156', CURRENT_TIMESTAMP);
INSERT INTO Item (item_id, transactions_id, store_id, price, item_type, name, description, created) VALUES (1157, 63, 1, 876, 'Books', 'name_1157', 'description_1157', CURRENT_TIMESTAMP);
INSERT INTO Item (item_id, transactions_id, store_id, price, item_type, name, description, created) VALUES (1158, 431, 7, 822, 'Books', 'name_1158', 'description_1158', CURRENT_TIMESTAMP);
INSERT INTO Item (item_id, transactions_id, store_id, price, item_type, name, description, created) VALUES (1159, 483, 4, 45, 'Toys', 'name_1159', 'description_1159', CURRENT_TIMESTAMP);
INSERT INTO Item (item_id, transactions_id, store_id, price, item_type, name, description, created) VALUES (1160, 94, 6, 110, 'Toys', 'name_1160', 'description_1160', CURRENT_TIMESTAMP);
INSERT INTO Item (item_id, transactions_id, store_id, price, item_type, name, description, created) VALUES (1161, 442, 7, 275, 'Home', 'name_1161', 'description_1161', CURRENT_TIMESTAMP);
INSERT INTO Item (item_id, transactions_id, store_id, price, item_type, name, description, created) VALUES (1162, 126, 5, 371, 'Toys', 'name_1162', 'description_1162', CURRENT_TIMESTAMP);
INSERT INTO Item (item_id, transactions_id, store_id, price, item_type, name, description, created) VALUES (1163, 54, 5, 292, 'Toys', 'name_1163', 'description_1163', CURRENT_TIMESTAMP);
INSERT INTO Item (item_id, transactions_id, store_id, price, item_type, name, description, created) VALUES (1164, 224, 10, 884, 'Health', 'name_1164', 'description_1164', CURRENT_TIMESTAMP);
INSERT INTO Item (item_id, transactions_id, store_id, price, item_type, name, description, created) VALUES (1165, 3, 2, 406, 'Health', 'name_1165', 'description_1165', CURRENT_TIMESTAMP);
INSERT INTO Item (item_id, transactions_id, store_id, price, item_type, name, description, created) VALUES (1166, 120, 9, 127, 'Electronics', 'name_1166', 'description_1166', CURRENT_TIMESTAMP);
INSERT INTO Item (item_id, transactions_id, store_id, price, item_type, name, description, created) VALUES (1167, 425, 11, 227, 'Toys', 'name_1167', 'description_1167', CURRENT_TIMESTAMP);
INSERT INTO Item (item_id, transactions_id, store_id, price, item_type, name, description, created) VALUES (1168, 182, 14, 611, 'Books', 'name_1168', 'description_1168', CURRENT_TIMESTAMP);
INSERT INTO Item (item_id, transactions_id, store_id, price, item_type, name, description, created) VALUES (1169, 216, 9, 147, 'Health', 'name_1169', 'description_1169', CURRENT_TIMESTAMP);
INSERT INTO Item (item_id, transactions_id, store_id, price, item_type, name, description, created) VALUES (1170, 454, 7, 277, 'Home', 'name_1170', 'description_1170', CURRENT_TIMESTAMP);
INSERT INTO Item (item_id, transactions_id, store_id, price, item_type, name, description, created) VALUES (1171, 56, 7, 542, 'Books', 'name_1171', 'description_1171', CURRENT_TIMESTAMP);
INSERT INTO Item (item_id, transactions_id, store_id, price, item_type, name, description, created) VALUES (1172, 37, 9, 931, 'Books', 'name_1172', 'description_1172', CURRENT_TIMESTAMP);
INSERT INTO Item (item_id, transactions_id, store_id, price, item_type, name, description, created) VALUES (1173, 318, 1, 469, 'Health', 'name_1173', 'description_1173', CURRENT_TIMESTAMP);
INSERT INTO Item (item_id, transactions_id, store_id, price, item_type, name, description, created) VALUES (1174, 452, 10, 1070, 'Home', 'name_1174', 'description_1174', CURRENT_TIMESTAMP);
INSERT INTO Item (item_id, transactions_id, store_id, price, item_type, name, description, created) VALUES (1175, 18, 6, 977, 'Toys', 'name_1175', 'description_1175', CURRENT_TIMESTAMP);
INSERT INTO Item (item_id, transactions_id, store_id, price, item_type, name, description, created) VALUES (1176, 202, 11, 227, 'Books', 'name_1176', 'description_1176', CURRENT_TIMESTAMP);
INSERT INTO Item (item_id, transactions_id, store_id, price, item_type, name, description, created) VALUES (1177, 107, 10, 282, 'Home', 'name_1177', 'description_1177', CURRENT_TIMESTAMP);
INSERT INTO Item (item_id, transactions_id, store_id, price, item_type, name, description, created) VALUES (1178, 269, 8, 576, 'Toys', 'name_1178', 'description_1178', CURRENT_TIMESTAMP);
INSERT INTO Item (item_id, transactions_id, store_id, price, item_type, name, description, created) VALUES (1179, 457, 8, 991, 'Toys', 'name_1179', 'description_1179', CURRENT_TIMESTAMP);
INSERT INTO Item (item_id, transactions_id, store_id, price, item_type, name, description, created) VALUES (1180, 118, 9, 1048, 'Electronics', 'name_1180', 'description_1180', CURRENT_TIMESTAMP);
INSERT INTO Item (item_id, transactions_id, store_id, price, item_type, name, description, created) VALUES (1181, 11, 8, 1067, 'Home', 'name_1181', 'description_1181', CURRENT_TIMESTAMP);
INSERT INTO Item (item_id, transactions_id, store_id, price, item_type, name, description, created) VALUES (1182, 217, 14, 401, 'Electronics', 'name_1182', 'description_1182', CURRENT_TIMESTAMP);
INSERT INTO Item (item_id, transactions_id, store_id, price, item_type, name, description, created) VALUES (1183, 310, 7, 1115, 'Books', 'name_1183', 'description_1183', CURRENT_TIMESTAMP);
INSERT INTO Item (item_id, transactions_id, store_id, price, item_type, name, description, created) VALUES (1184, 152, 3, 971, 'Home', 'name_1184', 'description_1184', CURRENT_TIMESTAMP);
INSERT INTO Item (item_id, transactions_id, store_id, price, item_type, name, description, created) VALUES (1185, 186, 9, 498, 'Home', 'name_1185', 'description_1185', CURRENT_TIMESTAMP);
INSERT INTO Item (item_id, transactions_id, store_id, price, item_type, name, description, created) VALUES (1186, 239, 12, 754, 'Health', 'name_1186', 'description_1186', CURRENT_TIMESTAMP);
INSERT INTO Item (item_id, transactions_id, store_id, price, item_type, name, description, created) VALUES (1187, 237, 3, 314, 'Home', 'name_1187', 'description_1187', CURRENT_TIMESTAMP);
INSERT INTO Item (item_id, transactions_id, store_id, price, item_type, name, description, created) VALUES (1188, 24, 12, 133, 'Home', 'name_1188', 'description_1188', CURRENT_TIMESTAMP);
INSERT INTO Item (item_id, transactions_id, store_id, price, item_type, name, description, created) VALUES (1189, 417, 6, 851, 'Home', 'name_1189', 'description_1189', CURRENT_TIMESTAMP);
INSERT INTO Item (item_id, transactions_id, store_id, price, item_type, name, description, created) VALUES (1190, 434, 3, 913, 'Electronics', 'name_1190', 'description_1190', CURRENT_TIMESTAMP);
INSERT INTO Item (item_id, transactions_id, store_id, price, item_type, name, description, created) VALUES (1191, 197, 9, 58, 'Home', 'name_1191', 'description_1191', CURRENT_TIMESTAMP);
INSERT INTO Item (item_id, transactions_id, store_id, price, item_type, name, description, created) VALUES (1192, 455, 11, 707, 'Toys', 'name_1192', 'description_1192', CURRENT_TIMESTAMP);
INSERT INTO Item (item_id, transactions_id, store_id, price, item_type, name, description, created) VALUES (1193, 10, 9, 408, 'Electronics', 'name_1193', 'description_1193', CURRENT_TIMESTAMP);
INSERT INTO Item (item_id, transactions_id, store_id, price, item_type, name, description, created) VALUES (1194, 385, 1, 457, 'Toys', 'name_1194', 'description_1194', CURRENT_TIMESTAMP);
INSERT INTO Item (item_id, transactions_id, store_id, price, item_type, name, description, created) VALUES (1195, 398, 1, 743, 'Electronics', 'name_1195', 'description_1195', CURRENT_TIMESTAMP);
INSERT INTO Item (item_id, transactions_id, store_id, price, item_type, name, description, created) VALUES (1196, 491, 9, 917, 'Toys', 'name_1196', 'description_1196', CURRENT_TIMESTAMP);
INSERT INTO Item (item_id, transactions_id, store_id, price, item_type, name, description, created) VALUES (1197, 196, 4, 789, 'Books', 'name_1197', 'description_1197', CURRENT_TIMESTAMP);
INSERT INTO Item (item_id, transactions_id, store_id, price, item_type, name, description, created) VALUES (1198, 57, 7, 747, 'Books', 'name_1198', 'description_1198', CURRENT_TIMESTAMP);
INSERT INTO Item (item_id, transactions_id, store_id, price, item_type, name, description, created) VALUES (1199, 438, 11, 1094, 'Books', 'name_1199', 'description_1199', CURRENT_TIMESTAMP);
INSERT INTO Item (item_id, transactions_id, store_id, price, item_type, name, description, created) VALUES (1200, 247, 3, 676, 'Toys', 'name_1200', 'description_1200', CURRENT_TIMESTAMP);
INSERT INTO Item (item_id, transactions_id, store_id, price, item_type, name, description, created) VALUES (1201, 104, 6, 1170, 'Books', 'name_1201', 'description_1201', CURRENT_TIMESTAMP);
INSERT INTO Item (item_id, transactions_id, store_id, price, item_type, name, description, created) VALUES (1202, 154, 10, 499, 'Electronics', 'name_1202', 'description_1202', CURRENT_TIMESTAMP);
INSERT INTO Item (item_id, transactions_id, store_id, price, item_type, name, description, created) VALUES (1203, 257, 10, 799, 'Electronics', 'name_1203', 'description_1203', CURRENT_TIMESTAMP);
INSERT INTO Item (item_id, transactions_id, store_id, price, item_type, name, description, created) VALUES (1204, 88, 12, 1147, 'Electronics', 'name_1204', 'description_1204', CURRENT_TIMESTAMP);
INSERT INTO Item (item_id, transactions_id, store_id, price, item_type, name, description, created) VALUES (1205, 124, 3, 680, 'Health', 'name_1205', 'description_1205', CURRENT_TIMESTAMP);
INSERT INTO Item (item_id, transactions_id, store_id, price, item_type, name, description, created) VALUES (1206, 463, 3, 854, 'Electronics', 'name_1206', 'description_1206', CURRENT_TIMESTAMP);
INSERT INTO Item (item_id, transactions_id, store_id, price, item_type, name, description, created) VALUES (1207, 449, 4, 685, 'Home', 'name_1207', 'description_1207', CURRENT_TIMESTAMP);
INSERT INTO Item (item_id, transactions_id, store_id, price, item_type, name, description, created) VALUES (1208, 229, 12, 637, 'Books', 'name_1208', 'description_1208', CURRENT_TIMESTAMP);
INSERT INTO Item (item_id, transactions_id, store_id, price, item_type, name, description, created) VALUES (1209, 393, 1, 398, 'Books', 'name_1209', 'description_1209', CURRENT_TIMESTAMP);
INSERT INTO Item (item_id, transactions_id, store_id, price, item_type, name, description, created) VALUES (1210, 27, 11, 990, 'Electronics', 'name_1210', 'description_1210', CURRENT_TIMESTAMP);
INSERT INTO Item (item_id, transactions_id, store_id, price, item_type, name, description, created) VALUES (1211, 219, 13, 535, 'Health', 'name_1211', 'description_1211', CURRENT_TIMESTAMP);
INSERT INTO Item (item_id, transactions_id, store_id, price, item_type, name, description, created) VALUES (1212, 216, 2, 34, 'Books', 'name_1212', 'description_1212', CURRENT_TIMESTAMP);
INSERT INTO Item (item_id, transactions_id, store_id, price, item_type, name, description, created) VALUES (1213, 294, 2, 627, 'Health', 'name_1213', 'description_1213', CURRENT_TIMESTAMP);
INSERT INTO Item (item_id, transactions_id, store_id, price, item_type, name, description, created) VALUES (1214, 160, 7, 3, 'Books', 'name_1214', 'description_1214', CURRENT_TIMESTAMP);
INSERT INTO Item (item_id, transactions_id, store_id, price, item_type, name, description, created) VALUES (1215, 36, 3, 776, 'Electronics', 'name_1215', 'description_1215', CURRENT_TIMESTAMP);
INSERT INTO Item (item_id, transactions_id, store_id, price, item_type, name, description, created) VALUES (1216, 249, 10, 615, 'Toys', 'name_1216', 'description_1216', CURRENT_TIMESTAMP);
INSERT INTO Item (item_id, transactions_id, store_id, price, item_type, name, description, created) VALUES (1217, 446, 14, 907, 'Home', 'name_1217', 'description_1217', CURRENT_TIMESTAMP);
INSERT INTO Item (item_id, transactions_id, store_id, price, item_type, name, description, created) VALUES (1218, 240, 8, 1169, 'Electronics', 'name_1218', 'description_1218', CURRENT_TIMESTAMP);
INSERT INTO Item (item_id, transactions_id, store_id, price, item_type, name, description, created) VALUES (1219, 187, 5, 1134, 'Home', 'name_1219', 'description_1219', CURRENT_TIMESTAMP);
INSERT INTO Item (item_id, transactions_id, store_id, price, item_type, name, description, created) VALUES (1220, 130, 11, 636, 'Health', 'name_1220', 'description_1220', CURRENT_TIMESTAMP);
INSERT INTO Item (item_id, transactions_id, store_id, price, item_type, name, description, created) VALUES (1221, 220, 6, 673, 'Toys', 'name_1221', 'description_1221', CURRENT_TIMESTAMP);
INSERT INTO Item (item_id, transactions_id, store_id, price, item_type, name, description, created) VALUES (1222, 121, 5, 225, 'Toys', 'name_1222', 'description_1222', CURRENT_TIMESTAMP);
INSERT INTO Item (item_id, transactions_id, store_id, price, item_type, name, description, created) VALUES (1223, 263, 14, 70, 'Toys', 'name_1223', 'description_1223', CURRENT_TIMESTAMP);
INSERT INTO Item (item_id, transactions_id, store_id, price, item_type, name, description, created) VALUES (1224, 330, 6, 26, 'Books', 'name_1224', 'description_1224', CURRENT_TIMESTAMP);
INSERT INTO Item (item_id, transactions_id, store_id, price, item_type, name, description, created) VALUES (1225, 427, 9, 118, 'Toys', 'name_1225', 'description_1225', CURRENT_TIMESTAMP);
INSERT INTO Item (item_id, transactions_id, store_id, price, item_type, name, description, created) VALUES (1226, 17, 4, 1146, 'Toys', 'name_1226', 'description_1226', CURRENT_TIMESTAMP);
INSERT INTO Item (item_id, transactions_id, store_id, price, item_type, name, description, created) VALUES (1227, 322, 4, 587, 'Books', 'name_1227', 'description_1227', CURRENT_TIMESTAMP);
INSERT INTO Item (item_id, transactions_id, store_id, price, item_type, name, description, created) VALUES (1228, 186, 3, 345, 'Health', 'name_1228', 'description_1228', CURRENT_TIMESTAMP);
INSERT INTO Item (item_id, transactions_id, store_id, price, item_type, name, description, created) VALUES (1229, 470, 3, 126, 'Health', 'name_1229', 'description_1229', CURRENT_TIMESTAMP);
INSERT INTO Item (item_id, transactions_id, store_id, price, item_type, name, description, created) VALUES (1230, 420, 6, 270, 'Books', 'name_1230', 'description_1230', CURRENT_TIMESTAMP);
INSERT INTO Item (item_id, transactions_id, store_id, price, item_type, name, description, created) VALUES (1231, 143, 14, 741, 'Electronics', 'name_1231', 'description_1231', CURRENT_TIMESTAMP);
INSERT INTO Item (item_id, transactions_id, store_id, price, item_type, name, description, created) VALUES (1232, 321, 3, 247, 'Home', 'name_1232', 'description_1232', CURRENT_TIMESTAMP);
INSERT INTO Item (item_id, transactions_id, store_id, price, item_type, name, description, created) VALUES (1233, 385, 10, 1233, 'Home', 'name_1233', 'description_1233', CURRENT_TIMESTAMP);
INSERT INTO Item (item_id, transactions_id, store_id, price, item_type, name, description, created) VALUES (1234, 322, 1, 843, 'Books', 'name_1234', 'description_1234', CURRENT_TIMESTAMP);
INSERT INTO Item (item_id, transactions_id, store_id, price, item_type, name, description, created) VALUES (1235, 374, 2, 1150, 'Home', 'name_1235', 'description_1235', CURRENT_TIMESTAMP);
INSERT INTO Item (item_id, transactions_id, store_id, price, item_type, name, description, created) VALUES (1236, 335, 4, 439, 'Home', 'name_1236', 'description_1236', CURRENT_TIMESTAMP);
INSERT INTO Item (item_id, transactions_id, store_id, price, item_type, name, description, created) VALUES (1237, 3, 2, 69, 'Books', 'name_1237', 'description_1237', CURRENT_TIMESTAMP);
INSERT INTO Item (item_id, transactions_id, store_id, price, item_type, name, description, created) VALUES (1238, 194, 6, 1204, 'Electronics', 'name_1238', 'description_1238', CURRENT_TIMESTAMP);
INSERT INTO Item (item_id, transactions_id, store_id, price, item_type, name, description, created) VALUES (1239, 291, 4, 849, 'Electronics', 'name_1239', 'description_1239', CURRENT_TIMESTAMP);
INSERT INTO Item (item_id, transactions_id, store_id, price, item_type, name, description, created) VALUES (1240, 145, 5, 233, 'Toys', 'name_1240', 'description_1240', CURRENT_TIMESTAMP);
INSERT INTO Item (item_id, transactions_id, store_id, price, item_type, name, description, created) VALUES (1241, 189, 8, 473, 'Books', 'name_1241', 'description_1241', CURRENT_TIMESTAMP);
INSERT INTO Item (item_id, transactions_id, store_id, price, item_type, name, description, created) VALUES (1242, 311, 3, 627, 'Health', 'name_1242', 'description_1242', CURRENT_TIMESTAMP);
INSERT INTO Item (item_id, transactions_id, store_id, price, item_type, name, description, created) VALUES (1243, 122, 1, 324, 'Health', 'name_1243', 'description_1243', CURRENT_TIMESTAMP);
INSERT INTO Item (item_id, transactions_id, store_id, price, item_type, name, description, created) VALUES (1244, 239, 5, 59, 'Electronics', 'name_1244', 'description_1244', CURRENT_TIMESTAMP);
INSERT INTO Item (item_id, transactions_id, store_id, price, item_type, name, description, created) VALUES (1245, 299, 13, 1187, 'Health', 'name_1245', 'description_1245', CURRENT_TIMESTAMP);
INSERT INTO Item (item_id, transactions_id, store_id, price, item_type, name, description, created) VALUES (1246, 375, 1, 789, 'Home', 'name_1246', 'description_1246', CURRENT_TIMESTAMP);
INSERT INTO Item (item_id, transactions_id, store_id, price, item_type, name, description, created) VALUES (1247, 465, 4, 255, 'Home', 'name_1247', 'description_1247', CURRENT_TIMESTAMP);
INSERT INTO Item (item_id, transactions_id, store_id, price, item_type, name, description, created) VALUES (1248, 311, 14, 488, 'Health', 'name_1248', 'description_1248', CURRENT_TIMESTAMP);
INSERT INTO Item (item_id, transactions_id, store_id, price, item_type, name, description, created) VALUES (1249, 267, 4, 528, 'Electronics', 'name_1249', 'description_1249', CURRENT_TIMESTAMP);
INSERT INTO Item (item_id, transactions_id, store_id, price, item_type, name, description, created) VALUES (1250, 486, 10, 673, 'Electronics', 'name_1250', 'description_1250', CURRENT_TIMESTAMP);
INSERT INTO Item (item_id, transactions_id, store_id, price, item_type, name, description, created) VALUES (1251, 309, 10, 33, 'Home', 'name_1251', 'description_1251', CURRENT_TIMESTAMP);
INSERT INTO Item (item_id, transactions_id, store_id, price, item_type, name, description, created) VALUES (1252, 248, 14, 851, 'Electronics', 'name_1252', 'description_1252', CURRENT_TIMESTAMP);
INSERT INTO Item (item_id, transactions_id, store_id, price, item_type, name, description, created) VALUES (1253, 131, 11, 636, 'Toys', 'name_1253', 'description_1253', CURRENT_TIMESTAMP);
INSERT INTO Item (item_id, transactions_id, store_id, price, item_type, name, description, created) VALUES (1254, 462, 9, 540, 'Health', 'name_1254', 'description_1254', CURRENT_TIMESTAMP);
INSERT INTO Item (item_id, transactions_id, store_id, price, item_type, name, description, created) VALUES (1255, 442, 10, 403, 'Health', 'name_1255', 'description_1255', CURRENT_TIMESTAMP);
INSERT INTO Item (item_id, transactions_id, store_id, price, item_type, name, description, created) VALUES (1256, 94, 13, 1011, 'Home', 'name_1256', 'description_1256', CURRENT_TIMESTAMP);
INSERT INTO Item (item_id, transactions_id, store_id, price, item_type, name, description, created) VALUES (1257, 400, 8, 963, 'Electronics', 'name_1257', 'description_1257', CURRENT_TIMESTAMP);
INSERT INTO Item (item_id, transactions_id, store_id, price, item_type, name, description, created) VALUES (1258, 89, 1, 576, 'Books', 'name_1258', 'description_1258', CURRENT_TIMESTAMP);
INSERT INTO Item (item_id, transactions_id, store_id, price, item_type, name, description, created) VALUES (1259, 153, 3, 1225, 'Health', 'name_1259', 'description_1259', CURRENT_TIMESTAMP);
INSERT INTO Item (item_id, transactions_id, store_id, price, item_type, name, description, created) VALUES (1260, 236, 6, 694, 'Toys', 'name_1260', 'description_1260', CURRENT_TIMESTAMP);
INSERT INTO Item (item_id, transactions_id, store_id, price, item_type, name, description, created) VALUES (1261, 380, 1, 473, 'Health', 'name_1261', 'description_1261', CURRENT_TIMESTAMP);
INSERT INTO Item (item_id, transactions_id, store_id, price, item_type, name, description, created) VALUES (1262, 248, 1, 141, 'Home', 'name_1262', 'description_1262', CURRENT_TIMESTAMP);
INSERT INTO Item (item_id, transactions_id, store_id, price, item_type, name, description, created) VALUES (1263, 262, 10, 82, 'Health', 'name_1263', 'description_1263', CURRENT_TIMESTAMP);
INSERT INTO Item (item_id, transactions_id, store_id, price, item_type, name, description, created) VALUES (1264, 387, 6, 577, 'Health', 'name_1264', 'description_1264', CURRENT_TIMESTAMP);
INSERT INTO Item (item_id, transactions_id, store_id, price, item_type, name, description, created) VALUES (1265, 236, 14, 193, 'Electronics', 'name_1265', 'description_1265', CURRENT_TIMESTAMP);
INSERT INTO Item (item_id, transactions_id, store_id, price, item_type, name, description, created) VALUES (1266, 437, 3, 1088, 'Electronics', 'name_1266', 'description_1266', CURRENT_TIMESTAMP);
INSERT INTO Item (item_id, transactions_id, store_id, price, item_type, name, description, created) VALUES (1267, 181, 14, 1205, 'Health', 'name_1267', 'description_1267', CURRENT_TIMESTAMP);
INSERT INTO Item (item_id, transactions_id, store_id, price, item_type, name, description, created) VALUES (1268, 463, 9, 447, 'Electronics', 'name_1268', 'description_1268', CURRENT_TIMESTAMP);
INSERT INTO Item (item_id, transactions_id, store_id, price, item_type, name, description, created) VALUES (1269, 305, 9, 1075, 'Home', 'name_1269', 'description_1269', CURRENT_TIMESTAMP);
INSERT INTO Item (item_id, transactions_id, store_id, price, item_type, name, description, created) VALUES (1270, 76, 14, 141, 'Electronics', 'name_1270', 'description_1270', CURRENT_TIMESTAMP);
INSERT INTO Item (item_id, transactions_id, store_id, price, item_type, name, description, created) VALUES (1271, 59, 12, 198, 'Books', 'name_1271', 'description_1271', CURRENT_TIMESTAMP);
INSERT INTO Item (item_id, transactions_id, store_id, price, item_type, name, description, created) VALUES (1272, 405, 5, 242, 'Electronics', 'name_1272', 'description_1272', CURRENT_TIMESTAMP);
INSERT INTO Item (item_id, transactions_id, store_id, price, item_type, name, description, created) VALUES (1273, 465, 10, 998, 'Electronics', 'name_1273', 'description_1273', CURRENT_TIMESTAMP);
INSERT INTO Item (item_id, transactions_id, store_id, price, item_type, name, description, created) VALUES (1274, 273, 5, 1092, 'Health', 'name_1274', 'description_1274', CURRENT_TIMESTAMP);
INSERT INTO Item (item_id, transactions_id, store_id, price, item_type, name, description, created) VALUES (1275, 355, 7, 541, 'Toys', 'name_1275', 'description_1275', CURRENT_TIMESTAMP);
INSERT INTO Item (item_id, transactions_id, store_id, price, item_type, name, description, created) VALUES (1276, 500, 14, 734, 'Electronics', 'name_1276', 'description_1276', CURRENT_TIMESTAMP);
INSERT INTO Item (item_id, transactions_id, store_id, price, item_type, name, description, created) VALUES (1277, 354, 9, 390, 'Home', 'name_1277', 'description_1277', CURRENT_TIMESTAMP);
INSERT INTO Item (item_id, transactions_id, store_id, price, item_type, name, description, created) VALUES (1278, 254, 11, 862, 'Home', 'name_1278', 'description_1278', CURRENT_TIMESTAMP);
INSERT INTO Item (item_id, transactions_id, store_id, price, item_type, name, description, created) VALUES (1279, 31, 4, 1095, 'Health', 'name_1279', 'description_1279', CURRENT_TIMESTAMP);
INSERT INTO Item (item_id, transactions_id, store_id, price, item_type, name, description, created) VALUES (1280, 425, 10, 1207, 'Electronics', 'name_1280', 'description_1280', CURRENT_TIMESTAMP);
INSERT INTO Item (item_id, transactions_id, store_id, price, item_type, name, description, created) VALUES (1281, 434, 9, 175, 'Books', 'name_1281', 'description_1281', CURRENT_TIMESTAMP);
INSERT INTO Item (item_id, transactions_id, store_id, price, item_type, name, description, created) VALUES (1282, 300, 10, 864, 'Home', 'name_1282', 'description_1282', CURRENT_TIMESTAMP);
INSERT INTO Item (item_id, transactions_id, store_id, price, item_type, name, description, created) VALUES (1283, 31, 4, 1136, 'Toys', 'name_1283', 'description_1283', CURRENT_TIMESTAMP);
INSERT INTO Item (item_id, transactions_id, store_id, price, item_type, name, description, created) VALUES (1284, 150, 3, 937, 'Books', 'name_1284', 'description_1284', CURRENT_TIMESTAMP);
INSERT INTO Item (item_id, transactions_id, store_id, price, item_type, name, description, created) VALUES (1285, 397, 8, 739, 'Electronics', 'name_1285', 'description_1285', CURRENT_TIMESTAMP);
INSERT INTO Item (item_id, transactions_id, store_id, price, item_type, name, description, created) VALUES (1286, 119, 13, 651, 'Electronics', 'name_1286', 'description_1286', CURRENT_TIMESTAMP);
INSERT INTO Item (item_id, transactions_id, store_id, price, item_type, name, description, created) VALUES (1287, 109, 6, 819, 'Health', 'name_1287', 'description_1287', CURRENT_TIMESTAMP);
INSERT INTO Item (item_id, transactions_id, store_id, price, item_type, name, description, created) VALUES (1288, 61, 11, 500, 'Toys', 'name_1288', 'description_1288', CURRENT_TIMESTAMP);
INSERT INTO Item (item_id, transactions_id, store_id, price, item_type, name, description, created) VALUES (1289, 326, 5, 777, 'Home', 'name_1289', 'description_1289', CURRENT_TIMESTAMP);
INSERT INTO Item (item_id, transactions_id, store_id, price, item_type, name, description, created) VALUES (1290, 355, 14, 1176, 'Toys', 'name_1290', 'description_1290', CURRENT_TIMESTAMP);
INSERT INTO Item (item_id, transactions_id, store_id, price, item_type, name, description, created) VALUES (1291, 243, 4, 380, 'Health', 'name_1291', 'description_1291', CURRENT_TIMESTAMP);
INSERT INTO Item (item_id, transactions_id, store_id, price, item_type, name, description, created) VALUES (1292, 140, 1, 777, 'Books', 'name_1292', 'description_1292', CURRENT_TIMESTAMP);
INSERT INTO Item (item_id, transactions_id, store_id, price, item_type, name, description, created) VALUES (1293, 392, 5, 908, 'Toys', 'name_1293', 'description_1293', CURRENT_TIMESTAMP);
INSERT INTO Item (item_id, transactions_id, store_id, price, item_type, name, description, created) VALUES (1294, 464, 4, 428, 'Health', 'name_1294', 'description_1294', CURRENT_TIMESTAMP);
INSERT INTO Item (item_id, transactions_id, store_id, price, item_type, name, description, created) VALUES (1295, 403, 3, 753, 'Books', 'name_1295', 'description_1295', CURRENT_TIMESTAMP);
INSERT INTO Item (item_id, transactions_id, store_id, price, item_type, name, description, created) VALUES (1296, 388, 5, 1085, 'Books', 'name_1296', 'description_1296', CURRENT_TIMESTAMP);
INSERT INTO Item (item_id, transactions_id, store_id, price, item_type, name, description, created) VALUES (1297, 62, 4, 1032, 'Health', 'name_1297', 'description_1297', CURRENT_TIMESTAMP);
INSERT INTO Item (item_id, transactions_id, store_id, price, item_type, name, description, created) VALUES (1298, 467, 8, 147, 'Books', 'name_1298', 'description_1298', CURRENT_TIMESTAMP);
INSERT INTO Item (item_id, transactions_id, store_id, price, item_type, name, description, created) VALUES (1299, 445, 2, 547, 'Home', 'name_1299', 'description_1299', CURRENT_TIMESTAMP);
INSERT INTO Item (item_id, transactions_id, store_id, price, item_type, name, description, created) VALUES (1300, 403, 1, 300, 'Toys', 'name_1300', 'description_1300', CURRENT_TIMESTAMP);
INSERT INTO Customer (customer_id, name, email, phone, gender, created) VALUES (1, 'Customer_name_1', 'customer_email_1', 'Customer_phone_1', 'F', CURRENT_TIMESTAMP);
INSERT INTO Customer (customer_id, name, email, phone, gender, created) VALUES (2, 'Customer_name_2', 'customer_email_2', 'Customer_phone_2', 'F', CURRENT_TIMESTAMP);
INSERT INTO Customer (customer_id, name, email, phone, gender, created) VALUES (3, 'Customer_name_3', 'customer_email_3', 'Customer_phone_3', 'M', CURRENT_TIMESTAMP);
INSERT INTO Customer (customer_id, name, email, phone, gender, created) VALUES (4, 'Customer_name_4', 'customer_email_4', 'Customer_phone_4', 'F', CURRENT_TIMESTAMP);
INSERT INTO Customer (customer_id, name, email, phone, gender, created) VALUES (5, 'Customer_name_5', 'customer_email_5', 'Customer_phone_5', 'M', CURRENT_TIMESTAMP);
INSERT INTO Customer (customer_id, name, email, phone, gender, created) VALUES (6, 'Customer_name_6', 'customer_email_6', 'Customer_phone_6', 'F', CURRENT_TIMESTAMP);
INSERT INTO Customer (customer_id, name, email, phone, gender, created) VALUES (7, 'Customer_name_7', 'customer_email_7', 'Customer_phone_7', 'M', CURRENT_TIMESTAMP);
INSERT INTO Customer (customer_id, name, email, phone, gender, created) VALUES (8, 'Customer_name_8', 'customer_email_8', 'Customer_phone_8', 'M', CURRENT_TIMESTAMP);
INSERT INTO Customer (customer_id, name, email, phone, gender, created) VALUES (9, 'Customer_name_9', 'customer_email_9', 'Customer_phone_9', 'M', CURRENT_TIMESTAMP);
INSERT INTO Customer (customer_id, name, email, phone, gender, created) VALUES (10, 'Customer_name_10', 'customer_email_10', 'Customer_phone_10', 'M', CURRENT_TIMESTAMP);
INSERT INTO Customer (customer_id, name, email, phone, gender, created) VALUES (11, 'Customer_name_11', 'customer_email_11', 'Customer_phone_11', 'F', CURRENT_TIMESTAMP);
INSERT INTO Customer (customer_id, name, email, phone, gender, created) VALUES (12, 'Customer_name_12', 'customer_email_12', 'Customer_phone_12', 'F', CURRENT_TIMESTAMP);
INSERT INTO Customer (customer_id, name, email, phone, gender, created) VALUES (13, 'Customer_name_13', 'customer_email_13', 'Customer_phone_13', 'M', CURRENT_TIMESTAMP);
INSERT INTO Customer (customer_id, name, email, phone, gender, created) VALUES (14, 'Customer_name_14', 'customer_email_14', 'Customer_phone_14', 'M', CURRENT_TIMESTAMP);
INSERT INTO Customer (customer_id, name, email, phone, gender, created) VALUES (15, 'Customer_name_15', 'customer_email_15', 'Customer_phone_15', 'F', CURRENT_TIMESTAMP);
INSERT INTO Customer (customer_id, name, email, phone, gender, created) VALUES (16, 'Customer_name_16', 'customer_email_16', 'Customer_phone_16', 'F', CURRENT_TIMESTAMP);
INSERT INTO Customer (customer_id, name, email, phone, gender, created) VALUES (17, 'Customer_name_17', 'customer_email_17', 'Customer_phone_17', 'F', CURRENT_TIMESTAMP);
INSERT INTO Operator ( operator_id, name, psw, user_id, created) VALUES (1, 'operator_name_1', 'operator_psw_1', 'operator_user_id_1', CURRENT_TIMESTAMP);
INSERT INTO Operator ( operator_id, name, psw, user_id, created) VALUES (2, 'operator_name_2', 'operator_psw_2', 'operator_user_id_2', CURRENT_TIMESTAMP);
INSERT INTO Operator ( operator_id, name, psw, user_id, created) VALUES (3, 'operator_name_3', 'operator_psw_3', 'operator_user_id_3', CURRENT_TIMESTAMP);
INSERT INTO Operator ( operator_id, name, psw, user_id, created) VALUES (4, 'operator_name_4', 'operator_psw_4', 'operator_user_id_4', CURRENT_TIMESTAMP);
INSERT INTO Operator ( operator_id, name, psw, user_id, created) VALUES (5, 'operator_name_5', 'operator_psw_5', 'operator_user_id_5', CURRENT_TIMESTAMP);
INSERT INTO Operator ( operator_id, name, psw, user_id, created) VALUES (6, 'operator_name_6', 'operator_psw_6', 'operator_user_id_6', CURRENT_TIMESTAMP);
INSERT INTO PhoneCall ( phonecall_id, customer_id, operator_id, start_time, duration, created) VALUES (1, 9, 5, '2020-01-26 08:49:09', 299, CURRENT_TIMESTAMP);
INSERT INTO PhoneCall ( phonecall_id, customer_id, operator_id, start_time, duration, created) VALUES (2, 17, 5, '2020-01-25 17:29:02', 240, CURRENT_TIMESTAMP);
INSERT INTO PhoneCall ( phonecall_id, customer_id, operator_id, start_time, duration, created) VALUES (3, 14, 2, '2020-01-09 03:04:51', 69, CURRENT_TIMESTAMP);
INSERT INTO PhoneCall ( phonecall_id, customer_id, operator_id, start_time, duration, created) VALUES (4, 7, 6, '2020-01-11 09:17:36', 430, CURRENT_TIMESTAMP);
INSERT INTO PhoneCall ( phonecall_id, customer_id, operator_id, start_time, duration, created) VALUES (5, 14, 5, '2020-02-01 04:01:57', 285, CURRENT_TIMESTAMP);
INSERT INTO PhoneCall ( phonecall_id, customer_id, operator_id, start_time, duration, created) VALUES (6, 16, 1, '2020-01-29 20:18:08', 232, CURRENT_TIMESTAMP);
INSERT INTO PhoneCall ( phonecall_id, customer_id, operator_id, start_time, duration, created) VALUES (7, 10, 1, '2020-01-17 02:27:08', 201, CURRENT_TIMESTAMP);
INSERT INTO PhoneCall ( phonecall_id, customer_id, operator_id, start_time, duration, created) VALUES (8, 14, 4, '2020-02-14 22:39:37', 189, CURRENT_TIMESTAMP);
INSERT INTO PhoneCall ( phonecall_id, customer_id, operator_id, start_time, duration, created) VALUES (9, 17, 1, '2020-01-16 15:56:15', 388, CURRENT_TIMESTAMP);
INSERT INTO PhoneCall ( phonecall_id, customer_id, operator_id, start_time, duration, created) VALUES (10, 17, 2, '2020-02-08 09:48:02', 451, CURRENT_TIMESTAMP);
INSERT INTO PhoneCall ( phonecall_id, customer_id, operator_id, start_time, duration, created) VALUES (11, 7, 2, '2020-02-11 23:21:02', 12, CURRENT_TIMESTAMP);
INSERT INTO PhoneCall ( phonecall_id, customer_id, operator_id, start_time, duration, created) VALUES (12, 13, 3, '2020-01-30 06:08:34', 260, CURRENT_TIMESTAMP);
INSERT INTO PhoneCall ( phonecall_id, customer_id, operator_id, start_time, duration, created) VALUES (13, 9, 2, '2020-01-16 10:33:38', 79, CURRENT_TIMESTAMP);
INSERT INTO PhoneCall ( phonecall_id, customer_id, operator_id, start_time, duration, created) VALUES (14, 2, 3, '2020-01-11 02:38:22', 44, CURRENT_TIMESTAMP);
INSERT INTO PhoneCall ( phonecall_id, customer_id, operator_id, start_time, duration, created) VALUES (15, 9, 6, '2020-02-14 02:33:17', 280, CURRENT_TIMESTAMP);
INSERT INTO PhoneCall ( phonecall_id, customer_id, operator_id, start_time, duration, created) VALUES (16, 17, 1, '2020-02-13 06:42:07', 304, CURRENT_TIMESTAMP);
INSERT INTO PhoneCall ( phonecall_id, customer_id, operator_id, start_time, duration, created) VALUES (17, 13, 3, '2020-02-20 00:53:55', 534, CURRENT_TIMESTAMP);
INSERT INTO PhoneCall ( phonecall_id, customer_id, operator_id, start_time, duration, created) VALUES (18, 11, 5, '2020-01-04 03:16:42', 248, CURRENT_TIMESTAMP);
INSERT INTO PhoneCall ( phonecall_id, customer_id, operator_id, start_time, duration, created) VALUES (19, 6, 6, '2020-02-10 13:54:11', 247, CURRENT_TIMESTAMP);
INSERT INTO PhoneCall ( phonecall_id, customer_id, operator_id, start_time, duration, created) VALUES (20, 11, 3, '2020-01-08 11:42:25', 152, CURRENT_TIMESTAMP);
INSERT INTO PhoneCall ( phonecall_id, customer_id, operator_id, start_time, duration, created) VALUES (21, 5, 1, '2020-01-04 18:19:51', 76, CURRENT_TIMESTAMP);
INSERT INTO PhoneCall ( phonecall_id, customer_id, operator_id, start_time, duration, created) VALUES (22, 1, 3, '2020-01-24 06:59:10', 310, CURRENT_TIMESTAMP);
INSERT INTO PhoneCall ( phonecall_id, customer_id, operator_id, start_time, duration, created) VALUES (23, 6, 4, '2020-01-10 13:36:41', 179, CURRENT_TIMESTAMP);
INSERT INTO PhoneCall ( phonecall_id, customer_id, operator_id, start_time, duration, created) VALUES (24, 9, 4, '2020-01-14 16:06:55', 90, CURRENT_TIMESTAMP);
INSERT INTO PhoneCall ( phonecall_id, customer_id, operator_id, start_time, duration, created) VALUES (25, 10, 3, '2020-01-03 11:26:42', 181, CURRENT_TIMESTAMP);
INSERT INTO PhoneCall ( phonecall_id, customer_id, operator_id, start_time, duration, created) VALUES (26, 6, 3, '2020-01-26 13:23:13', 395, CURRENT_TIMESTAMP);
INSERT INTO PhoneCall ( phonecall_id, customer_id, operator_id, start_time, duration, created) VALUES (27, 5, 6, '2020-02-11 04:23:38', 10, CURRENT_TIMESTAMP);
INSERT INTO PhoneCall ( phonecall_id, customer_id, operator_id, start_time, duration, created) VALUES (28, 17, 3, '2020-01-07 15:56:21', 295, CURRENT_TIMESTAMP);
INSERT INTO PhoneCall ( phonecall_id, customer_id, operator_id, start_time, duration, created) VALUES (29, 16, 5, '2020-01-07 04:54:42', 159, CURRENT_TIMESTAMP);
INSERT INTO PhoneCall ( phonecall_id, customer_id, operator_id, start_time, duration, created) VALUES (30, 4, 4, '2020-02-18 09:02:29', 347, CURRENT_TIMESTAMP);
INSERT INTO PhoneCall ( phonecall_id, customer_id, operator_id, start_time, duration, created) VALUES (31, 17, 2, '2020-01-21 20:01:10', 149, CURRENT_TIMESTAMP);
INSERT INTO PhoneCall ( phonecall_id, customer_id, operator_id, start_time, duration, created) VALUES (32, 6, 4, '2020-02-17 15:15:22', 405, CURRENT_TIMESTAMP);
INSERT INTO PhoneCall ( phonecall_id, customer_id, operator_id, start_time, duration, created) VALUES (33, 1, 3, '2020-01-22 02:28:51', 81, CURRENT_TIMESTAMP);
INSERT INTO PhoneCall ( phonecall_id, customer_id, operator_id, start_time, duration, created) VALUES (34, 10, 3, '2020-02-13 15:41:14', 51, CURRENT_TIMESTAMP);
INSERT INTO PhoneCall ( phonecall_id, customer_id, operator_id, start_time, duration, created) VALUES (35, 4, 4, '2020-02-16 06:43:19', 258, CURRENT_TIMESTAMP);
INSERT INTO PhoneCall ( phonecall_id, customer_id, operator_id, start_time, duration, created) VALUES (36, 4, 3, '2020-01-20 23:30:50', 203, CURRENT_TIMESTAMP);
INSERT INTO PhoneCall ( phonecall_id, customer_id, operator_id, start_time, duration, created) VALUES (37, 6, 1, '2020-02-19 00:58:51', 323, CURRENT_TIMESTAMP);
INSERT INTO PhoneCall ( phonecall_id, customer_id, operator_id, start_time, duration, created) VALUES (38, 2, 1, '2020-01-12 04:01:59', 56, CURRENT_TIMESTAMP);
INSERT INTO PhoneCall ( phonecall_id, customer_id, operator_id, start_time, duration, created) VALUES (39, 14, 2, '2020-02-08 21:49:46', 358, CURRENT_TIMESTAMP);
INSERT INTO PhoneCall ( phonecall_id, customer_id, operator_id, start_time, duration, created) VALUES (40, 1, 5, '2020-01-30 16:37:42', 194, CURRENT_TIMESTAMP);
INSERT INTO PhoneCall ( phonecall_id, customer_id, operator_id, start_time, duration, created) VALUES (41, 10, 1, '2020-01-27 21:42:18', 400, CURRENT_TIMESTAMP);
INSERT INTO PhoneCall ( phonecall_id, customer_id, operator_id, start_time, duration, created) VALUES (42, 11, 1, '2020-02-06 04:49:16', 349, CURRENT_TIMESTAMP);
INSERT INTO PhoneCall ( phonecall_id, customer_id, operator_id, start_time, duration, created) VALUES (43, 14, 6, '2020-01-02 07:50:36', 553, CURRENT_TIMESTAMP);
INSERT INTO PhoneCall ( phonecall_id, customer_id, operator_id, start_time, duration, created) VALUES (44, 8, 6, '2020-02-14 09:58:54', 218, CURRENT_TIMESTAMP);
INSERT INTO PhoneCall ( phonecall_id, customer_id, operator_id, start_time, duration, created) VALUES (45, 14, 1, '2020-01-31 17:26:37', 196, CURRENT_TIMESTAMP);
INSERT INTO PhoneCall ( phonecall_id, customer_id, operator_id, start_time, duration, created) VALUES (46, 7, 6, '2020-01-25 18:02:52', 224, CURRENT_TIMESTAMP);
INSERT INTO PhoneCall ( phonecall_id, customer_id, operator_id, start_time, duration, created) VALUES (47, 12, 4, '2020-01-17 17:16:22', 232, CURRENT_TIMESTAMP);
INSERT INTO PhoneCall ( phonecall_id, customer_id, operator_id, start_time, duration, created) VALUES (48, 16, 1, '2020-02-05 17:13:15', 545, CURRENT_TIMESTAMP);
INSERT INTO PhoneCall ( phonecall_id, customer_id, operator_id, start_time, duration, created) VALUES (49, 12, 6, '2020-01-19 08:43:22', 258, CURRENT_TIMESTAMP);
INSERT INTO PhoneCall ( phonecall_id, customer_id, operator_id, start_time, duration, created) VALUES (50, 12, 5, '2020-01-01 16:31:39', 442, CURRENT_TIMESTAMP);
INSERT INTO Problem (problem_id, transactions_id, phonecall_id, problem_category_id, specialist_id, status, description, created) VALUES (1, 175, 50, 9, 3, 'Solved by Standard Solution', 'description_1', CURRENT_TIMESTAMP);
INSERT INTO Problem (problem_id, transactions_id, phonecall_id, problem_category_id, specialist_id, status, description, created) VALUES (2, 414, 11, 9, 5, 'Solved by Specialist', 'description_2', CURRENT_TIMESTAMP);
INSERT INTO Problem (problem_id, transactions_id, phonecall_id, problem_category_id, specialist_id, status, description, created) VALUES (3, 353, 25, 4, NULL, 'Pending', 'description_3', CURRENT_TIMESTAMP);
INSERT INTO Problem (problem_id, transactions_id, phonecall_id, problem_category_id, specialist_id, status, description, created) VALUES (4, 188, 15, 3, 1, 'Solved by Standard Solution', 'description_4', CURRENT_TIMESTAMP);
INSERT INTO Problem (problem_id, transactions_id, phonecall_id, problem_category_id, specialist_id, status, description, created) VALUES (5, 312, 20, 3, 3, 'Solved by Standard Solution', 'description_5', CURRENT_TIMESTAMP);
INSERT INTO Problem (problem_id, transactions_id, phonecall_id, problem_category_id, specialist_id, status, description, created) VALUES (6, 473, 32, 5, 5, 'Solved by Specialist', 'description_6', CURRENT_TIMESTAMP);
INSERT INTO Problem (problem_id, transactions_id, phonecall_id, problem_category_id, specialist_id, status, description, created) VALUES (7, 356, 21, 9, 6, 'Solved by Specialist', 'description_7', CURRENT_TIMESTAMP);
INSERT INTO Problem (problem_id, transactions_id, phonecall_id, problem_category_id, specialist_id, status, description, created) VALUES (8, 44, 17, 4, 3, 'Solved by Standard Solution', 'description_8', CURRENT_TIMESTAMP);
INSERT INTO Problem (problem_id, transactions_id, phonecall_id, problem_category_id, specialist_id, status, description, created) VALUES (9, 360, 30, 1, 2, 'Solved by Standard Solution', 'description_9', CURRENT_TIMESTAMP);
INSERT INTO Problem (problem_id, transactions_id, phonecall_id, problem_category_id, specialist_id, status, description, created) VALUES (10, 378, 19, 6, 6, 'Solved by Specialist', 'description_10', CURRENT_TIMESTAMP);
INSERT INTO Problem (problem_id, transactions_id, phonecall_id, problem_category_id, specialist_id, status, description, created) VALUES (11, 121, 24, 8, 3, 'Solved by Standard Solution', 'description_11', CURRENT_TIMESTAMP);
INSERT INTO Problem (problem_id, transactions_id, phonecall_id, problem_category_id, specialist_id, status, description, created) VALUES (12, 160, 10, 4, 3, 'Solved by Standard Solution', 'description_12', CURRENT_TIMESTAMP);
INSERT INTO Problem (problem_id, transactions_id, phonecall_id, problem_category_id, specialist_id, status, description, created) VALUES (13, 327, 10, 3, NULL, 'Pending', 'description_13', CURRENT_TIMESTAMP);
INSERT INTO Problem (problem_id, transactions_id, phonecall_id, problem_category_id, specialist_id, status, description, created) VALUES (14, 308, 8, 3, 3, 'Solved by Specialist', 'description_14', CURRENT_TIMESTAMP);
INSERT INTO Problem (problem_id, transactions_id, phonecall_id, problem_category_id, specialist_id, status, description, created) VALUES (15, 233, 5, 1, 3, 'Solved by Standard Solution', 'description_15', CURRENT_TIMESTAMP);
INSERT INTO Problem (problem_id, transactions_id, phonecall_id, problem_category_id, specialist_id, status, description, created) VALUES (16, 360, 31, 3, 5, 'Solved by Standard Solution', 'description_16', CURRENT_TIMESTAMP);
INSERT INTO Problem (problem_id, transactions_id, phonecall_id, problem_category_id, specialist_id, status, description, created) VALUES (17, 392, 10, 8, 2, 'Solved by Specialist', 'description_17', CURRENT_TIMESTAMP);
INSERT INTO Problem (problem_id, transactions_id, phonecall_id, problem_category_id, specialist_id, status, description, created) VALUES (18, 241, 13, 1, 6, 'Solved by Standard Solution', 'description_18', CURRENT_TIMESTAMP);
INSERT INTO Problem (problem_id, transactions_id, phonecall_id, problem_category_id, specialist_id, status, description, created) VALUES (19, 121, 49, 7, 5, 'Solved by Standard Solution', 'description_19', CURRENT_TIMESTAMP);
INSERT INTO Problem (problem_id, transactions_id, phonecall_id, problem_category_id, specialist_id, status, description, created) VALUES (20, 484, 50, 2, NULL, 'Pending', 'description_20', CURRENT_TIMESTAMP);
INSERT INTO Problem (problem_id, transactions_id, phonecall_id, problem_category_id, specialist_id, status, description, created) VALUES (21, 12, 29, 1, NULL, 'Pending', 'description_21', CURRENT_TIMESTAMP);
INSERT INTO Problem (problem_id, transactions_id, phonecall_id, problem_category_id, specialist_id, status, description, created) VALUES (22, 82, 30, 9, NULL, 'Pending', 'description_22', CURRENT_TIMESTAMP);
INSERT INTO Problem (problem_id, transactions_id, phonecall_id, problem_category_id, specialist_id, status, description, created) VALUES (23, 438, 10, 9, 2, 'Solved by Standard Solution', 'description_23', CURRENT_TIMESTAMP);
INSERT INTO Problem (problem_id, transactions_id, phonecall_id, problem_category_id, specialist_id, status, description, created) VALUES (24, 192, 32, 4, 2, 'Solved by Specialist', 'description_24', CURRENT_TIMESTAMP);
INSERT INTO Problem (problem_id, transactions_id, phonecall_id, problem_category_id, specialist_id, status, description, created) VALUES (25, 120, 28, 2, NULL, 'Pending', 'description_25', CURRENT_TIMESTAMP);
INSERT INTO Problem (problem_id, transactions_id, phonecall_id, problem_category_id, specialist_id, status, description, created) VALUES (26, 59, 35, 5, NULL, 'Pending', 'description_26', CURRENT_TIMESTAMP);
INSERT INTO Problem (problem_id, transactions_id, phonecall_id, problem_category_id, specialist_id, status, description, created) VALUES (27, 375, 8, 1, 6, 'Solved by Specialist', 'description_27', CURRENT_TIMESTAMP);
INSERT INTO Problem (problem_id, transactions_id, phonecall_id, problem_category_id, specialist_id, status, description, created) VALUES (28, 168, 3, 6, NULL, 'Pending', 'description_28', CURRENT_TIMESTAMP);
INSERT INTO Problem (problem_id, transactions_id, phonecall_id, problem_category_id, specialist_id, status, description, created) VALUES (29, 3, 31, 6, NULL, 'Pending', 'description_29', CURRENT_TIMESTAMP);
INSERT INTO Problem (problem_id, transactions_id, phonecall_id, problem_category_id, specialist_id, status, description, created) VALUES (30, 294, 39, 8, NULL, 'Pending', 'description_30', CURRENT_TIMESTAMP);
INSERT INTO Problem (problem_id, transactions_id, phonecall_id, problem_category_id, specialist_id, status, description, created) VALUES (31, 495, 15, 8, 3, 'Solved by Standard Solution', 'description_31', CURRENT_TIMESTAMP);
INSERT INTO Problem (problem_id, transactions_id, phonecall_id, problem_category_id, specialist_id, status, description, created) VALUES (32, 6, 6, 9, 6, 'Solved by Standard Solution', 'description_32', CURRENT_TIMESTAMP);
INSERT INTO Problem (problem_id, transactions_id, phonecall_id, problem_category_id, specialist_id, status, description, created) VALUES (33, 340, 46, 2, 1, 'Solved by Standard Solution', 'description_33', CURRENT_TIMESTAMP);
INSERT INTO Problem (problem_id, transactions_id, phonecall_id, problem_category_id, specialist_id, status, description, created) VALUES (34, 3, 23, 2, 2, 'Solved by Standard Solution', 'description_34', CURRENT_TIMESTAMP);
INSERT INTO Problem (problem_id, transactions_id, phonecall_id, problem_category_id, specialist_id, status, description, created) VALUES (35, 435, 41, 3, 2, 'Solved by Specialist', 'description_35', CURRENT_TIMESTAMP);
INSERT INTO Problem (problem_id, transactions_id, phonecall_id, problem_category_id, specialist_id, status, description, created) VALUES (36, 465, 10, 7, NULL, 'Pending', 'description_36', CURRENT_TIMESTAMP);
INSERT INTO Problem (problem_id, transactions_id, phonecall_id, problem_category_id, specialist_id, status, description, created) VALUES (37, 59, 7, 9, NULL, 'Pending', 'description_37', CURRENT_TIMESTAMP);
INSERT INTO Problem (problem_id, transactions_id, phonecall_id, problem_category_id, specialist_id, status, description, created) VALUES (38, 169, 35, 5, 4, 'Solved by Standard Solution', 'description_38', CURRENT_TIMESTAMP);
INSERT INTO Problem (problem_id, transactions_id, phonecall_id, problem_category_id, specialist_id, status, description, created) VALUES (39, 228, 14, 6, NULL, 'Pending', 'description_39', CURRENT_TIMESTAMP);
INSERT INTO Problem (problem_id, transactions_id, phonecall_id, problem_category_id, specialist_id, status, description, created) VALUES (40, 196, 25, 2, 2, 'Solved by Specialist', 'description_40', CURRENT_TIMESTAMP);
INSERT INTO Problem (problem_id, transactions_id, phonecall_id, problem_category_id, specialist_id, status, description, created) VALUES (41, 181, 35, 6, 6, 'Solved by Standard Solution', 'description_41', CURRENT_TIMESTAMP);
INSERT INTO Problem (problem_id, transactions_id, phonecall_id, problem_category_id, specialist_id, status, description, created) VALUES (42, 398, 9, 1, 5, 'Solved by Specialist', 'description_42', CURRENT_TIMESTAMP);
INSERT INTO Problem (problem_id, transactions_id, phonecall_id, problem_category_id, specialist_id, status, description, created) VALUES (43, 213, 15, 5, 4, 'Solved by Standard Solution', 'description_43', CURRENT_TIMESTAMP);
INSERT INTO Problem (problem_id, transactions_id, phonecall_id, problem_category_id, specialist_id, status, description, created) VALUES (44, 211, 30, 2, NULL, 'Pending', 'description_44', CURRENT_TIMESTAMP);
INSERT INTO Problem (problem_id, transactions_id, phonecall_id, problem_category_id, specialist_id, status, description, created) VALUES (45, 47, 48, 1, 6, 'Solved by Standard Solution', 'description_45', CURRENT_TIMESTAMP);
INSERT INTO Problem (problem_id, transactions_id, phonecall_id, problem_category_id, specialist_id, status, description, created) VALUES (46, 181, 30, 8, 4, 'Solved by Specialist', 'description_46', CURRENT_TIMESTAMP);
INSERT INTO Problem (problem_id, transactions_id, phonecall_id, problem_category_id, specialist_id, status, description, created) VALUES (47, 93, 35, 9, NULL, 'Pending', 'description_47', CURRENT_TIMESTAMP);
INSERT INTO Problem (problem_id, transactions_id, phonecall_id, problem_category_id, specialist_id, status, description, created) VALUES (48, 165, 16, 4, NULL, 'Pending', 'description_48', CURRENT_TIMESTAMP);
INSERT INTO Problem (problem_id, transactions_id, phonecall_id, problem_category_id, specialist_id, status, description, created) VALUES (49, 272, 15, 2, NULL, 'Pending', 'description_49', CURRENT_TIMESTAMP);
INSERT INTO Problem (problem_id, transactions_id, phonecall_id, problem_category_id, specialist_id, status, description, created) VALUES (50, 371, 14, 5, 6, 'Solved by Standard Solution', 'description_50', CURRENT_TIMESTAMP);
INSERT INTO Problem (problem_id, transactions_id, phonecall_id, problem_category_id, specialist_id, status, description, created) VALUES (51, 9, 1, 1, 6, 'Solved by Specialist', 'description_51', CURRENT_TIMESTAMP);
INSERT INTO Problem (problem_id, transactions_id, phonecall_id, problem_category_id, specialist_id, status, description, created) VALUES (52, 429, 37, 9, 4, 'Solved by Specialist', 'description_52', CURRENT_TIMESTAMP);
INSERT INTO Problem (problem_id, transactions_id, phonecall_id, problem_category_id, specialist_id, status, description, created) VALUES (53, 85, 18, 1, 5, 'Solved by Standard Solution', 'description_53', CURRENT_TIMESTAMP);
INSERT INTO Problem (problem_id, transactions_id, phonecall_id, problem_category_id, specialist_id, status, description, created) VALUES (54, 362, 45, 2, 2, 'Solved by Specialist', 'description_54', CURRENT_TIMESTAMP);
INSERT INTO Problem (problem_id, transactions_id, phonecall_id, problem_category_id, specialist_id, status, description, created) VALUES (55, 105, 6, 9, 2, 'Solved by Standard Solution', 'description_55', CURRENT_TIMESTAMP);
INSERT INTO Problem (problem_id, transactions_id, phonecall_id, problem_category_id, specialist_id, status, description, created) VALUES (56, 240, 7, 7, 6, 'Solved by Standard Solution', 'description_56', CURRENT_TIMESTAMP);
INSERT INTO Problem (problem_id, transactions_id, phonecall_id, problem_category_id, specialist_id, status, description, created) VALUES (57, 324, 40, 6, 1, 'Solved by Specialist', 'description_57', CURRENT_TIMESTAMP);
INSERT INTO Problem (problem_id, transactions_id, phonecall_id, problem_category_id, specialist_id, status, description, created) VALUES (58, 392, 13, 8, 5, 'Solved by Specialist', 'description_58', CURRENT_TIMESTAMP);
INSERT INTO Problem (problem_id, transactions_id, phonecall_id, problem_category_id, specialist_id, status, description, created) VALUES (59, 90, 23, 8, NULL, 'Pending', 'description_59', CURRENT_TIMESTAMP);
INSERT INTO Problem (problem_id, transactions_id, phonecall_id, problem_category_id, specialist_id, status, description, created) VALUES (60, 346, 4, 3, 3, 'Solved by Specialist', 'description_60', CURRENT_TIMESTAMP);
