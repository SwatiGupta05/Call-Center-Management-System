CREATE DEFINER=`root`@`localhost` PROCEDURE `InsertProblemcategory`(problem_category_id INT, administrator_id INT, description VARCHAR(200), solution_id INT, solution VARCHAR(200))
BEGIN
INSERT INTO ProblemCategory (problem_category_id, administrator_id, description, created) VALUES (problem_category_id, administrator_id, description, CURRENT_TIMESTAMP);
INSERT INTO Solution (solution_id, problem_category_id, solution, created) VALUES (solution_id, problem_category_id, solution_id, CURRENT_TIMESTAMP);
END