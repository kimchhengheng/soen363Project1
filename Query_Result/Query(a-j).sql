
--A THE RESULT WITHOUT DISTNCT IS 21 ROW, BUT THERE ARE DUPLICATE NAME SO WE MAKE IT DISTINCT WHICH YIELD THE RESULT ONLY 19 ROWS
SELECT DISTINCT M.TITLE
FROM MOVIES M, ACTORS A
WHERE M.MID = A.MID AND A.NAME LIKE 'Daniel Craig'
ORDER BY M.TITLE ASC;
--B
SELECT A.NAME
FROM MOVIES M, ACTORS A
WHERE M.MID = A.MID AND M.TITLE ='The Dark Knight'
ORDER BY A.NAME ASC;
--C
SELECT COUNT(*) AS NUM_MOVIES , GENRE
FROM GENRES
GROUP BY GENRE
HAVING COUNT(*) > 1000
ORDER BY NUM_MOVIES;
--D  THERE ARE DUPICATE ROW
SELECT TITLE, YEAR , RATING
FROM MOVIES
ORDER BY YEAR ASC, RATING DESC;

--E
SELECT M.TITLE
FROM MOVIES M
WHERE M.MID IN (
    SELECT DISTINCT T1.MID
    FROM TAGS T1, TAGS T2, TAG_NAMES TN1, TAG_NAMES TN2
    WHERE T1.MID = T2.MID AND T1.TID <> T2.TID AND T1.TID =TN1.TID AND T2.TID = TN2.TID
      AND ((TN1.TAG LIKE '%good%' AND TN2.TAG LIKE '%bad%') OR (TN1.TAG LIKE '%bad%' AND TN2.TAG LIKE '%good%')));
--F
--F I
SELECT *
FROM MOVIES M
WHERE M.RATING = (
    SELECT MAX(RATING)
    FROM MOVIES);
--F II
SELECT *
FROM MOVIES M
WHERE M.RATING = (
    SELECT MAX(RATING)
    FROM MOVIES)
ORDER BY M.MID;
--F III
SELECT *
FROM MOVIES M
WHERE M.RATING = (
    SELECT MAX(RATING)
    FROM MOVIES) AND M.NUM_RATING =(
    SELECT MAX(NUM_RATING)
    FROM MOVIES);
--F IV
SELECT *
FROM MOVIES M
WHERE M.RATING = (
    SELECT MIN(RATING)
    FROM MOVIES);

--F V
SELECT *
FROM MOVIES M
WHERE M.RATING = (
    SELECT MIN(RATING)
    FROM MOVIES)
ORDER BY M.MID;


SELECT *
FROM MOVIES M
WHERE M.RATING = (
    SELECT MIN(RATING)
    FROM MOVIES) AND M.RATING =(
    SELECT MAX(NUM_RATING)
    FROM MOVIES);
--THE HIGHEST NUMBER OF USER RATING IS 1768593 BUT RATING IS 3.8 AND THE HIGHEST RATING IS 5 AND NUMBER OF RATING IS 5
--THE HYPOTHESIS IS NOT RIGHT, THE HIGEST NUMBER OF RATING DOES NOT HAVE THE HIGHEST NUMBER OF USER RATING
--IN THE LOWEST RATING THERE IS NOT THE HIGHEST NUMBER OF RATING, NORMALLY THE LOWERST RATING WOULD HAVE THE 0 NUMBER OF RATING

--G
CREATE VIEW MIN_RATING_EACH_YEAR AS
SELECT YEAR AS YEAR, MIN(RATING) AS MIN_RATING
        FROM MOVIES
        WHERE YEAR BETWEEN 2005 AND 2011
        GROUP BY YEAR

CREATE VIEW MAX_RATING_EACH_YEAR AS
SELECT YEAR, MAX(RATING) AS MAX_RATING
        FROM MOVIES
        WHERE YEAR BETWEEN 2005 AND 2011
        GROUP BY YEAR

SELECT T.YEAR, T.TITLE, T.RATING
FROM ( SELECT TEMP.YEAR, M.TITLE, M.RATING
       FROM MOVIES M, MIN_RATING_EACH_YEAR TEMP
       WHERE M.RATING = TEMP.MIN_RATING AND M.YEAR = TEMP.YEAR
       UNION
       SELECT TEMP.YEAR, M.TITLE, M.RATING
       FROM MOVIES M, MAX_RATING_EACH_YEAR TEMP
       WHERE M.RATING = TEMP.MAX_RATING AND M.YEAR = TEMP.YEAR) T
ORDER BY T.YEAR ASC, T.RATING ASC, T.TITLE ASC;

--H
CREATE VIEW HIGH_RATING AS
SELECT A.NAME AS HR_NAME
FROM MOVIES M, ACTORS A
WHERE M.MID = A.MID AND M.RATING >=4;

CREATE VIEW LOW_RATING AS
SELECT A.NAME AS LR_NAME
FROM MOVIES M, ACTORS A
WHERE M.MID = A.MID AND M.RATING <4;

SELECT COUNT(*) AS NUM_HR FROM HIGH_RATING;
SELECT COUNT(*) AS NUM_LR FROM LOW_RATING;

SELECT COUNT(*) AS NUM_NO_FLOP FROM HIGH_RATING;

SELECT *
FROM (
         SELECT HR.HR_NAME , COUNT(*) AS NUM_MOVIES
         FROM MOVIES M, HIGH_RATING HR, ACTORS A
         WHERE M.MID = A.MID AND A.NAME =HR.HR_NAME
         GROUP BY HR.HR_NAME
         ORDER BY NUM_MOVIES DESC) T
WHERE ROWNUM<=10;

--I
SELECT *
FROM (
         SELECT MAX(T.YEAR)- MIN(T.YEAR) AS LONGEVITY, T.NAME
         FROM (
                  SELECT M.MID, M.YEAR, A.NAME
                  FROM MOVIES M, ACTORS A
                  WHERE M.MID = A.MID) T
         GROUP BY T.NAME
         ORDER BY LONGEVITY DESC)
WHERE ROWNUM=1;
--J
CREATE VIEW CO_ACTORS AS
SELECT DISTINCT A2.NAME AS CA_NAMES
FROM MOVIES M, ACTORS A1, ACTORS A2
WHERE A1.NAME = 'Annette Nicole' AND A1.MID = M.MID AND A2.MID=M.MID AND A2.NAME <> 'Annette Nicole'

DROP VIEW CO_ACTORS;
SELECT COUNT(*) AS NUM_CA FROM CO_ACTORS;

CREATE VIEW ALL_COMBINATIONS AS
SELECT *
FROM CO_ACTORS, (SELECT MID FROM ACTORS A WHERE A.NAME = 'Annette Nicole')
SELECT COUNT(*) FROM ALL_COMBINATIONS;
--select count(*) from co_actors , (select mid from actors where name= 'Annette Nicole')


CREATE VIEW NON_EXISTENT AS
SELECT * FROM ALL_COMBINATIONS
                  MINUS
SELECT A.NAME , A.MID FROM ACTORS A
SELECT COUNT(*) FROM NON_EXISTENT

SELECT DISTINCT A.CA_NAMES FROM CO_ACTORS A
    MINUS
SELECT DISTINCT NE.CA_NAMES FROM NON_EXISTENT NE);
