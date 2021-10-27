USE `family-relations`;

-- Persons Table
DROP TABLE IF EXISTS PERSONS;
CREATE TABLE PERSONS(id INT PRIMARY KEY, Name VARCHAR(64), Sex CHAR CHECK(Sex = 'M' OR Sex = 'F'));

-- Insert Info Into Persons Table
-- Family 1 - My Family
INSERT INTO PERSONS VALUES (1, 'Azwad Shameem', 'M');
INSERT INTO PERSONS VALUES (2, 'Sister', 'F');
INSERT INTO PERSONS VALUES (3, 'Brother', 'M');
INSERT INTO PERSONS VALUES (4, 'Father', 'M');
INSERT INTO PERSONS VALUES (5, 'Mother', 'F');
-- Family 2 - Cousins From Mother's side -- RULE: Mother Side Family Has _
INSERT INTO PERSONS VALUES (6, 'Cousin_1', 'M');
INSERT INTO PERSONS VALUES (7, 'Cousin_2', 'M');
INSERT INTO PERSONS VALUES (8, 'Cousin_3', 'F');
INSERT INTO PERSONS VALUES (9, 'Cousin_4', 'F');
INSERT INTO PERSONS VALUES (10, 'Uncle_1', 'M');
INSERT INTO PERSONS VALUES (11, 'Aunt_1', 'F');
-- Family 3 - Cousins From Father's side
INSERT INTO PERSONS VALUES (12, 'Cousin 1', 'M');
INSERT INTO PERSONS VALUES (13, 'Cousin 2', 'M');
INSERT INTO PERSONS VALUES (14, 'Cousin 3', 'F');
INSERT INTO PERSONS VALUES (15, 'Cousin 4', 'F');
INSERT INTO PERSONS VALUES (16, 'Uncle 1', 'M');
INSERT INTO PERSONS VALUES (17, 'Aunt 1', 'F');
-- Family 4 - Mother's Parents -- RULE: Mother Side Family Has _
INSERT INTO PERSONS VALUES (18, 'Grandpa_1', 'M');
INSERT INTO PERSONS VALUES (19, 'Grandma_1', 'F');
-- Family 5 - Father's Parents
INSERT INTO PERSONS VALUES (20, 'Grandpa 1', 'M');
INSERT INTO PERSONS VALUES (21, 'Grandma 1', 'F');

-- View All In Persons Table
SELECT * FROM PERSONS;