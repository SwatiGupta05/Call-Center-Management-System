CREATE DEFINER=`root`@`localhost` PROCEDURE `InsertSpecialist`(Spe int, name varchar(20), psw varchar(20), user_id varchar(20), specialization_id int)
BEGIN
IF(specialization_id is NULL)
	THEN
		signal sqlstate '45000' set message_text = 'specialization is NULL';
       
    end if;
INSERT INTO Specialist (specialist_id, name, psw, user_id, created) VALUES (Spe, name, psw, user_id, CURRENT_TIMESTAMP);
INSERT INTO Specialist_Specialization (specialist_id, specialization_id, created) VALUES (Spe, specialization_id, CURRENT_TIMESTAMP);
END