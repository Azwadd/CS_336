USE `family-relations`;

-- SPOUSES Table
DROP TABLE IF EXISTS BROTHERINLAW;
CREATE TABLE BROTHERINLAW(id INT REFERENCES PERSONS(id), bid  INT REFERENCES PERSONS(id), PRIMARY KEY (id, bid));

INSERT INTO BROTHERINLAW
-- Husband of a person's sister
 SELECT P1.Id, P2.Id AS 'In-Law' FROM PERSONS P1, PERSONS P2 WHERE P1.Sex = 'M' AND P1.id != P2.id AND P2.id IN
     (SELECT hid FROM SPOUSES WHERE wid IN
         (SELECT sid FROM BROTHERSISTER WHERE bid = P1.id))
UNION
-- Brother of a person's spouse
SELECT P1.id, P2.id AS 'In-Law' FROM PERSONS P1, PERSONS P2 WHERE P1.Sex = 'M' AND P1.id != P2.id AND P2.id IN
    (SELECT bid FROM BROTHERSISTER WHERE sid IN
        (SELECT wid FROM SPOUSES WHERE hid = P1.id))
-- Husband of a sister of a person's spouse
UNION
SELECT P1.id, P2.id AS 'In-Law' FROM PERSONS P1, PERSONS P2 WHERE P1.Sex = 'M' AND P1.id != P2.id AND P2.id IN
    (SELECT hid FROM SPOUSES WHERE wid IN
        (SELECT sid FROM SISTER WHERE pid IN
            (SELECT wid FROM SPOUSES WHERE hid = P1.id)))

-- Person is a female
UNION

-- Husband of a person's sister
SELECT P1.id, P2.id AS 'In-Law' FROM PERSONS P1, PERSONS P2 WHERE P1.Sex = 'M' AND P1.id != P2.id AND P2.id IN
    (SELECT hid FROM SPOUSES WHERE wid IN
        (SELECT sid FROM SISTER WHERE pid= P1.id))
# Brother of a person's spouse
UNION
SELECT P1.id, P2.id AS 'In-Law Id' FROM PERSONS P1, PERSONS P2 WHERE P1.Sex = 'M' AND P1.id != P2.id AND P2.id IN
    (SELECT bid FROM BROTHER WHERE pid IN
        (SELECT hid FROM SPOUSES WHERE wid = P1.id))
# Husband of a sister of a person's spouse
UNION
    SELECT P1.id, P2.id AS 'In-Law Id' FROM PERSONS P1, PERSONS P2 WHERE P1.Sex = 'M' AND P1.id != P2.id AND P2.id IN
    (SELECT hid FROM SPOUSES WHERE wid IN
        (SELECT sid FROM BROTHERSISTER WHERE bid IN
            (SELECT hid FROM SPOUSES WHERE wid = P1.id)));

SELECT * FROM BROTHERINLAW;