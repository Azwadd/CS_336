USE `family-relations`;

-- SPOUSES Table
DROP TABLE IF EXISTS SPOUSES;
CREATE TABLE SPOUSES(hid INT REFERENCES Persons(Id), wid INT REFERENCES Persons(Id), PRIMARY KEY (hid, wid));

-- Insert Info Into Husband-Wife Table
-- Family 1 - My Family
INSERT INTO SPOUSES VALUES(4, 5);
-- Family 2 - Cousins From Mother's side -
INSERT INTO SPOUSES VALUES(10, 11);
-- Family 3 - Cousins From Father's side
INSERT INTO SPOUSES VALUES(16, 17);
-- Family 4 - Mother's Parents
INSERT INTO SPOUSES VALUES(18, 19);
-- Family 5 - Father's Parents
INSERT INTO SPOUSES VALUES(20, 21);


-- View All In SPOUSES Table
SELECT * FROM SPOUSES;