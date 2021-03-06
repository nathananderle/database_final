SPOOL project.out 
SET ECHO ON 
SET WRAP OFF
SET LINESIZE 3000
/* 
CIS 353
 - Database Design Project 
    <Ryan Gole> 
    <Nathan Anderle>
    <Nicholas Spruit>
    <Edward Johnson>
*/ 
--
-- Drop the tables (in case they already exist)
--
DROP TABLE Team CASCADE CONSTRAINTS;
DROP TABLE Teams CASCADE CONSTRAINTS;
DROP TABLE Championship CASCADE CONSTRAINTS;
DROP TABLE Championships CASCADE CONSTRAINTS;
DROP TABLE Player CASCADE CONSTRAINTS;
DROP TABLE Players CASCADE CONSTRAINTS;
DROP TABLE Coach CASCADE CONSTRAINTS;
DROP TABLE Performance CASCADE CONSTRAINTS;
DROP TABLE Performances CASCADE CONSTRAINTS;
DROP TABLE Game CASCADE CONSTRAINTS;
DROP TABLE Games CASCADE CONSTRAINTS;
DROP TABLE Coaches CASCADE CONSTRAINTS;
DROP TABLE Season CASCADE CONSTRAINTS;
DROP TABLE History CASCADE CONSTRAINTS;

/*
< The SQL/DDL code that creates your schema > 
In the DDL, every IC must have a unique name; e.g. IC5, IC10, IC15, etc. 
*/
--
CREATE TABLE Team
(
    teamID      INTEGER,
    name        CHAR(15)    NOT NULL,
    mascot      CHAR(40)    NOT NULL,
--
    --Team ID is unique for each team
    CONSTRAINT teamIC1 PRIMARY KEY (teamID)
);
-- ------------------------------------------------------
CREATE TABLE Championship
(
    teamID      INTEGER,
    yearWon     INTEGER,
--
        --teamID corresponds to team ID in Team table
        CONSTRAINT champIC1 FOREIGN KEY (teamID) REFERENCES Team(teamID) ON DELETE CASCADE,
        --each row corresponds to a team and a year that team won the championship
        CONSTRAINT champIC2 PRIMARY KEY(teamID, yearWon),
		--only one champion per year
		CONSTRAINT champIC3 UNIQUE(yearWon)
);
-- -------------------------------------------------------
CREATE TABLE Player
(
    playerID    INTEGER,
    num         INTEGER     NOT NULL,
    firstName   char(15)    NOT NULL,
    lastName    char(15)    NOT NULL,
    height      INTEGER     NOT NULL,
    year        char(15)    NOT NULL,
    teamID      INTEGER     NOT NULL,
--
        --Each row is a player defined by a unique playerID
        CONSTRAINT playerIC1 PRIMARY KEY (playerID),
        --Player's team is taken from Team table,
        CONSTRAINT playerIC2 FOREIGN KEY (teamID) REFERENCES Team(teamID) ON DELETE CASCADE,
        --Checks to make sure player grade is freshnan, sophomore, junior, or senior
        CONSTRAINT playerIC3 CHECK (year IN ('Fr', 'Sr', 'Jr', 'So'))
);
--  -------------------------------------------------------
CREATE TABLE Game
(
    gameID      INTEGER,
    region      CHAR(15)   NOT NULL,
    gDate       DATE       NOT NULL,
    winScore    INTEGER    NOT NULL,
    loseScore   INTEGER    NOT NULL,
    winner      INTEGER    NOT NULL,
    loser       INTEGER    NOT NULL,
    nextGameID  INTEGER,
--
    --each game has a unqiue gameID
    CONSTRAINT gameIC1 PRIMARY KEY (gameID),
    --each game takes place in one of these regions
    CONSTRAINT gameIC2 CHECK (region IN('South', 'West', 'Midwest', 'East','Final Four')),
    --scores cannot be negative, and winner has the higher score
    CONSTRAINT gameIC3 CHECK(loseScore >= 0 AND winScore > loseScore),
    --winner is a team in the Team table
    CONSTRAINT gameIC4 FOREIGN KEY (winner) REFERENCES Team(teamID),
    --loser is a team in the  Team table
    CONSTRAINT gameIC5 FOREIGN KEY (loser) REFERENCES Team(teamID),
    --next game is in game table
    CONSTRAINT gameIC7 FOREIGN KEY (nextGameID) REFERENCES Game(gameID)
);
--  -------------------------------------------------------
CREATE TABLE Coach
(
    coachID     INTEGER,
    firstName   CHAR(15)     NOT NULL,
    lastName    CHAR(15)     NOT NULL,
    wins        INTEGER      NOT NULL,
    losses      INTEGER      NOT NULL,
--
    -- Every coach is identified by an ID number
    CONSTRAINT coachIC1 PRIMARY KEY(coachID),
    -- Number of wins cannot be negative
    CONSTRAINT coachIC2 CHECK(wins >= 0),
    -- Number of losses cannot be negative
    CONSTRAINT coachIC3 CHECK(losses >= 0)
);
--  -------------------------------------------------------
CREATE TABLE Performance
(
    playerID    INTEGER,
    gameID      INTEGER,
    points      INTEGER    NOT NULL,
    rebounds    INTEGER    NOT NULL,
    assists     INTEGER    NOT NULL,
--
    --points can't be negative
    CONSTRAINT perIC1 CHECK(points >= 0),
    --rebounds can't be negative
    CONSTRAINT perIC2 CHECK(rebounds >= 0),
    --assists can't be negative
    CONSTRAINT perIC3 CHECK(assists >= 0),
    --playerID refers to a player with the same playerID in Player table
    CONSTRAINT perIC4 FOREIGN KEY (playerID) REFERENCES Player(playerID),
    --game ID belongs to a game with the same gameID in game table
    CONSTRAINT perIC5 FOREIGN KEY (gameID) REFERENCES Game(gameID),
    --each row corresponds to a certain player in a certain game
    CONSTRAINT perIC6 PRIMARY KEY (playerID, gameID) 
);
---------------------------------------------------------
CREATE TABLE Coaches
(
    coachID       INTEGER,
    teamID        INTEGER,
    startYear     INTEGER    Not NULL,
    endYear       INTEGER,
--
    -- Every person who coaches is defined by a coach ID
    CONSTRAINT cIC1 FOREIGN KEY (coachID) REFERENCES Coach(coachID),
    -- Every person who coaches is also defined by a team ID
    CONSTRAINT cIC2 FOREIGN KEY (teamID) REFERENCES Team(teamID),
    -- Every person who coaches is defined by both a coach ID and a team ID
    CONSTRAINT cIC3 PRIMARY KEY (coachID, teamID),
    -- Every coach must have started coaching sometime in the past
    CONSTRAINT cIC4 CHECK( startYear <= endYear)
);
-- ------------------------------------------------------
CREATE TABLE Season
(
    teamID      INTEGER,
    year        INTEGER     NOT NULL,
    wins        INTEGER     NOT NULL,
    losses      INTEGER     NOT NULL,
    region      CHAR(15),
    seed        INTEGER,
--
    -- Every team's past/current seasons reference the team's ID
    CONSTRAINT hIC1 FOREIGN KEY(teamID) REFERENCES Team(teamID),
    -- Every season is defined by a team and the year of a particular season
    CONSTRAINT hIC2 PRIMARY KEY(teamID, year),
    -- Every team's past/current season cannot have a negative number of wins
    CONSTRAINT hIC3 CHECK (wins >= 0),
    -- Every team's past/current season cannout have a negative number of losses 
    CONSTRAINT hIC4 CHECK (losses >= 0),
    -- If the team made it to the NCAA tournament, they must have played in one of these four regions
    CONSTRAINT hIC5 CHECK (region IN ('West', 'South', 'Midwest', 'East')),
    -- Every team's seed is unique to the region that they play in for a given year
    CONSTRAINT hIC6 UNIQUE (year, seed, region),
    -- Every seed number is limited by the number of teams that play in a region
    CONSTRAINT hIC7 CHECK(seed >= 1 AND seed <= 16)
);
-- ------------------------------------------------------
SET FEEDBACK OFF 
/*< The INSERT statements that populate the tables> 
    Important: Keep the number of rows in each
    table small enough so that the results of 
    your queries can be verified by hand. 
    See the Sailors database as an example.
*/
--Team
INSERT INTO Team VALUES (1,'Villanova','Will D. Cat');
INSERT INTO Team VALUES (2,'Syracuse','Otto the Orange');
INSERT INTO Team VALUES(3,'Oklahoma','Boomer and Sooner');
INSERT INTO Team VALUES(4,'UNC','Rameses');
INSERT INTO Team VALUES(5,'Kansas','Big Jay');
INSERT INTO Team VALUES(6,'Texas AM','Reveille IX');
--2016 Season Data
INSERT INTO Season VALUES(1, 2016, 29, 5, 'South', 2);
INSERT INTO Season VALUES(2, 2016, 19, 13, 'Midwest', 10);
INSERT INTO Season VALUES(3, 2016, 25, 7, 'West', 2);
INSERT INTO Season VALUES(4, 2016, 28, 5, 'East', 2);
--2015 Season Data
INSERT INTO Season VALUES(1, 2015, 33, 3, 'East', 1);
INSERT INTO Season VALUES(5, 2015, 27, 9, 'Midwest', 2);
INSERT INTO Season VALUES(3, 2015, 24, 11, 'West', 10);
INSERT INTO Season VALUES(4, 2015, 26, 12, 'East', 4);
INSERT INTO Season VALUES(6, 2015, 21, 12, , );
--Villanova Players
INSERT INTO Player VALUES (1,0,'Henry','Lowe',71,'Sr',1);
INSERT INTO Player VALUES(2,1 ,'Jalen' ,'Brunson' ,75 ,'Fr' ,1);
INSERT INTO Player VALUES(3,2 ,'Kris' ,'Jenkins' ,78 ,'Jr' ,1);
INSERT INTO Player VALUES(4,3 ,'Josh' ,'Hart' ,77 ,'Jr' ,1);
INSERT INTO Player VALUES(5,4 ,'Eric' ,'Paschall' ,79 ,'Fr' ,1);
INSERT INTO Player VALUES(6,5 ,'Phil' ,'Booth' ,75 ,'So' ,1);
INSERT INTO Player VALUES(7,10 ,'Donte' ,'DiVencenzo' ,77 ,'Fr' ,1);
INSERT INTO Player VALUES(8,15 ,'Ryan' ,'Arcidiacono' ,75 ,'Sr' ,1);
INSERT INTO Player VALUES(9,20 ,'Patrick' ,'Farrel' ,77 ,'Sr' ,1);
INSERT INTO Player VALUES(10,23 ,'Daniel' ,'Ochefu' ,83 ,'Sr' ,1);
INSERT INTO Player VALUES(11,25 ,'Mikal' ,'Bridges' ,79 ,'Fr' ,1);
INSERT INTO Player VALUES(12,34 ,'Tim','Delaney' ,81 ,'Fr' ,1);
INSERT INTO Player VALUES(13,45 ,'Darryl','Reynolds' ,80 ,'Jr' ,1);
INSERT INTO Player VALUES(14,52 ,'Kevin','Rafferty' ,80 ,'Sr' ,1);
--Syracuse Players
INSERT INTO Player VALUES(15,0,'Michael','Gbinije',79,'Sr',2);
INSERT INTO Player VALUES(16,1,'Franklin','Howard',76,'Fr',2);
INSERT INTO Player VALUES(17,3,'Shaun','Belby',70,'Fr',2);
INSERT INTO Player VALUES(18,4,'Mike','Sutton',74,'So',2);
INSERT INTO Player VALUES(19,10,'Trevor','Cooney',76,'Sr',2);
INSERT INTO Player VALUES(20,11,'Adrian','Autry',72,'Fr',2);
INSERT INTO Player VALUES(21,13,'Paschal','Chukwu',86,'So',2);
INSERT INTO Player VALUES(22,14,'Kaleb','Joseph',75,'So',2);
INSERT INTO Player VALUES(23,20,'Tyler','Lydon',80,'Fr',2);
INSERT INTO Player VALUES(24,21,'Tyler','Roberson',80,'Jr',2);
INSERT INTO Player VALUES(25,23,'Malachi','Richardson',78,'Fr',2);
INSERT INTO Player VALUES(26,25,'Evan','Dourdas',72,'Fr',2);
INSERT INTO Player VALUES(27,32,'DaJuan','Coleman',81,'Sr',2);
INSERT INTO Player VALUES(28,33,'Jonathon','Radner',70,'Fr',2);
INSERT INTO Player VALUES(29,34,'Doyin','Akintobi',78,'So',2);
INSERT INTO Player VALUES(30,35,'Chinonso','Obokoh',81,'So',2);
INSERT INTO Player VALUES(31,54,'Ky','Feldman',70, 'Fr',2);
INSERT INTO Player VALUES(32,55,'Christian','White',70,'Sr',2);
--Oklahoma Players
INSERT INTO Player VALUES(33,14,'Bola','Alade',76,'Fr',3);
INSERT INTO Player VALUES(34,21,'Dante','Buford',79,'Fr',3);
INSERT INTO Player VALUES(35,25,'C.J.','Cole',79,'Jr',3);
INSERT INTO Player VALUES(36,11,'Isaiah','Cousins',76,'Sr',3);
INSERT INTO Player VALUES(37,5,'Matt','Freeman',82,'Fr',3);
INSERT INTO Player VALUES(38,45,'Austin','Grandstaff',77,'Fr',3);
INSERT INTO Player VALUES(39,22,'Daniel','Harper',73,'Jr',3);
INSERT INTO Player VALUES(40,24,'Buddy','Hield',76,'Sr',3);
INSERT INTO Player VALUES(41,3,'Christian','James',76,'Fr',3);
INSERT INTO Player VALUES(42,12,'Khadeem','Lattin',81,'So',3);
INSERT INTO Player VALUES(43,41,'Austin','Mankin',79,'Sr',3);
INSERT INTO Player VALUES(44,30,'Akolda','Manyang',84,'Jr',3);
INSERT INTO Player VALUES(45,4,'Jamuni','McNeace',82,'Fr',3);
INSERT INTO Player VALUES(46,1,'Rashard','Odomes',78,'Fr',3);
INSERT INTO Player VALUES(47,0,'Ryan','Spangler',80,'Sr',3);
INSERT INTO Player VALUES(48,2,'Dinjiyl','Walker',73,'Sr',3);
INSERT INTO Player VALUES(49,10,'Jordan','Woodard',72,'Jr',3);
--North Carolina Players
INSERT INTO Player VALUES(50,0,'Nate','Britt',73,'Jr',4);
INSERT INTO Player VALUES(51,1,'Theo','Pinson',78,'So',4);
INSERT INTO Player VALUES(52,2,'Joel','Berry',72,'So',4);
INSERT INTO Player VALUES(53,3,'Kennedy','Meeks',82,'Jr',4);
INSERT INTO Player VALUES(54,4,'Isaiah','Hicks',81,'Jr',4);
INSERT INTO Player VALUES(55,5,'Marcus','Paige',74,'Sr',4);
INSERT INTO Player VALUES(56,11,'Brice','Johnson',82,'Sr',4);
INSERT INTO Player VALUES(57,13,'Kanler','Coker',76,'Jr',4);
INSERT INTO Player VALUES(58,24,'Kenny','Williams',76,'Fr',4);
INSERT INTO Player VALUES(59,30,'Stilman','White',73,'Jr',4);
INSERT INTO Player VALUES(60,31,'Justin','Coleman',73,'Sr',4);
INSERT INTO Player VALUES(61,32,'Luke','Maye',80,'Fr',4);
INSERT INTO Player VALUES(62,34,'Toby','Egbuna',76,'Sr',4);
INSERT INTO Player VALUES(63,42,'Joel','James',83,'Sr',4);
INSERT INTO Player VALUES(64,43,'Spenser','Dalton',75,'Sr',4);
INSERT INTO Player VALUES(65,44,'Justin','Jackson',80,'So',4);
--Kansas Players
INSERT INTO Player VALUES(66,11,'Tyler','Self',74,'Jr',5);
INSERT INTO Player VALUES(67,34,'Perry','Ellis',80,'Sr',5);
--Texas AM Players
INSERT INTO Player VALUES(68,0,'Kobie','Eubanks',77,'Fr',6);
INSERT INTO Player VALUES(69,12,'Jalen','Jones',79,'Sr',6);
--Championship
INSERT INTO Championship VALUES(1,2016);
INSERT INTO Championship VALUES(1,1985);
INSERT INTO Championship VALUES(2,2003);
INSERT INTO Championship VALUES(4,2009);
INSERT INTO Championship VALUES(4,2005);
INSERT INTO Championship VALUES(4,1993);
INSERT INTO Championship VALUES(4,1982);
INSERT INTO Championship VALUES(4,1957);
INSERT INTO Championship VALUES(5,1952);
INSERT INTO Championship VALUES(5,1988);
INSERT INTO Championship VALUES(5,2008);
--Games
INSERT INTO Game VALUES(3,'Final Four',date '2016-04-04',77,74,1,4,NULL);
INSERT INTO Game VALUES(2,'Final Four',date '2016-04-02',83,66,4,2,3);
INSERT INTO Game VALUES(1,'Final Four',date '2016-04-02',95,51,1,3,3);
--Coaches
INSERT INTO Coach VALUES(1,'Jay','Wright',441,237);
INSERT INTO Coach VALUES(2,'Jim','Boeheim',988,346);
INSERT INTO Coach VALUES(3,'Roy','Williams',783,209);
INSERT INTO Coach VALUES(4,'Lon','Kruger',590,361);
INSERT INTO Coach VALUES(5,'Bill','Self',385,83);
INSERT INTO Coach VALUES(6,'Billy','Kennedy',99,70);
--When and Where coaches coached
INSERT INTO Coaches VALUES(1,1,2001,NULL);
INSERT INTO Coaches VALUES(2,2,1976,NULL);
INSERT INTO Coaches VALUES(3,4,2003,NULL);
INSERT INTO Coaches VALUES(4,3,2011,NULL);
INSERT INTO Coaches VALUES(3,5,1988,2004);
INSERT INTO Coaches VALUES(4,6,1982,1986);
INSERT INTO Coaches VALUES(5,5,2003,NULL);
INSERT INTO Coaches VALUES(6,6,2011,NULL);
 
-- Performances for Villanova in game 1
INSERT INTO Performance VALUES(10,1,10,6,3);		
INSERT INTO Performance VALUES(3,1,18,8,1);		
INSERT INTO Performance VALUES(9,1,0,0,0);	
INSERT INTO Performance VALUES(14,1,0,0,0);		
INSERT INTO Performance VALUES(13,1,0,2,1);		
INSERT INTO Performance VALUES(6,1,10,2,0);		
INSERT INTO Performance VALUES(8,1,15,3,3);		
INSERT INTO Performance VALUES(2,1,8,1,2);		
INSERT INTO Performance VALUES(1,1,0,0,0);		
INSERT INTO Performance VALUES(4,1,23,8,4);		
INSERT INTO Performance VALUES(11,1,11,2,0);		
--Performances for Oklahoma in game 1 							
INSERT INTO Performance VALUES(45,1,4,0,0);		
INSERT INTO Performance VALUES(35,1,0,0,0);		
INSERT INTO Performance VALUES(38,1,0,1,0);		
INSERT INTO Performance VALUES(42,1,2,5,0);		
INSERT INTO Performance VALUES(47,1,6,4,1);		
INSERT INTO Performance VALUES(34,1,0,1,1);		
INSERT INTO Performance VALUES(48,1,1,2,0);	
INSERT INTO Performance VALUES(32,1,5,0,1);		
INSERT INTO Performance VALUES(36,1,8,1,1);		
INSERT INTO Performance VALUES(49,1,12,4,2);		
INSERT INTO Performance VALUES(46,1,4,1,0);	
INSERT INTO Performance VALUES(33,1,0,0,0);		
INSERT INTO Performance VALUES(39,1,0,0,0);	
INSERT INTO Performance VALUES(40,1,9,7,2);		
--Performances for North Carolina Game 2
 INSERT INTO Performance VALUES(62,2,0,0,0);
 INSERT INTO Performance VALUES(56,2,16,4,9);
 INSERT INTO Performance VALUES(52,2,4,2,3);
 INSERT INTO Performance VALUES(53,2,15,5,8);
 INSERT INTO Performance VALUES(54,2,6,1,4);
 INSERT INTO Performance VALUES(61,2,0,0,0);
 INSERT INTO Performance VALUES(65,2,16,0,3);
 INSERT INTO Performance VALUES(51,2,5,2,5);
 INSERT INTO Performance VALUES(58,2,0,0,0);
 INSERT INTO Performance VALUES(50,2,0,1,2);
 INSERT INTO Performance VALUES(57,2,0,0,0);
 INSERT INTO Performance VALUES(64,2,0,0,0);
 INSERT INTO Performance VALUES(55,2,13,0,2);
 INSERT INTO Performance VALUES(63,2,8,1,7);
 INSERT INTO Performance VALUES(59,2,0,0,0);
 --Performances for Syracuse Game 2
 INSERT INTO Performance VALUES(15,2,12,0,3);
 INSERT INTO Performance VALUES(24,2,2,6,9);
 INSERT INTO Performance VALUES(27,2,5,4,4);
 INSERT INTO Performance VALUES(23,2,8,2,5);
 INSERT INTO Performance VALUES(25,2,17,2,5);
 INSERT INTO Performance VALUES(19,2,22,2,5);
 INSERT INTO Performance VALUES(16,2,0,0,0);
--performance villanova game 3
INSERT INTO Performance VALUES(3,3,14,0,2);
INSERT INTO Performance VALUES(10,3,9,1,6);
INSERT INTO Performance VALUES (13,3,0,0,0);
INSERT INTO Performance VALUES(2,3,4,0,1);
INSERT INTO Performance VALUES(4,3,12,1,8);
INSERT INTO Performance VALUES(8,3,16,0,2);
INSERT INTO Performance VALUES(6,3,20,0,2);
INSERT INTO Performance VALUES(11,3,2,0,2);
--Performance UNC game 3
INSERT INTO Performance VALUES(56,3,14,1,8);
INSERT INTO Performance VALUES(63,3,0,0,1);
INSERT INTO Performance VALUES(54,3,4,2,4);
INSERT INTO Performance VALUES(53,3,4,6,7);
INSERT INTO Performance VALUES(65,3,9,2,4);
INSERT INTO Performance VALUES(51,3,0,0,0);
INSERT INTO Performance VALUES(50,3,2,1,1);
INSERT INTO Performance VALUES(55,3,21,2,5);
INSERT INTO Performance VALUES(52,3,20,0,3);
SET FEEDBACK ON 
COMMIT;
-- 
/*
< One query (per table) of the form: SELECT * FROM table; in order to print out your database > 
*/
SELECT * 
FROM Coach;
--
SELECT * 
FROM Player;
--
SELECT * 
FROM Team;
--
SELECT * 
FROM Performance;
--
SELECT *
FROM Championship;
--
SELECT * 
FROM Game;
--
SELECT *
FROM Coaches;
--
SELECT *
FROM Season;
--
------------------------------------------------------
/*
< The SQL queries>. Include the following for each query: 
1.A comment line stating the query number and the feature(s) it demonstrates (e.g. – Q25 – correlated subquery). 
2.A comment line stating the query in English. 
3.The SQL code for the query. 
*/
--Query 1: Join invloving four tables
--Query finds the first and last name and points of players for all performances of
--players from team 1 from game 1
SELECT P.firstName, P.lastName, T.name AS team, R.points
FROM Player P, Team T, Game G, Performance R
WHERE P.teamID = T.teamID AND 
      P.playerID = R.playerID AND 
      R.gameID = G.gameID AND
      T.teamID = 1 AND G.gameID = 1;
-------------------------------------------------------
--Query 2: A self join (involving 5 tables)
--Query finds every player who had more than one performance with 10+ points
--and prints the player's name, which team they played for, how many points they had,
--and the date of the game for each of those performances
SELECT DISTINCT P.playerID, P.firstName, P.lastName, T.name AS Team, A.points, G.gDate AS gameDate
FROM Performance A, Performance B, Player P, Game G, Team T
WHERE A.playerID = B.playerID AND
	  A.playerID = P.playerID AND
	  A.gameID != B.gameID AND
	  P.teamID = T.teamID AND
	  G.gameID = A.gameID AND
	  A.points >= 10 AND
	  B.points >= 10
ORDER BY P.playerID;
-------------------------------------------------------
--Query 3: Intersect Query
--Query finds Freshman players that had standout performances (more than 15 points in a performance)
SELECT pl.playerID, pl.firstName, pl.lastName
FROM Player pl
WHERE year = 'Fr'
INTERSECT
SELECT pl.playerID, pl.firstName, pl.lastName
FROM Player pl, Performance pe
WHERE pl.playerID = pe.PlayerID AND
      pe.points >= 15;
------------------------------------------------------
--Query 4 and 5: Aggregate query with GROUP BY, HAVING, and ORDER BY
--Query finds the points per game, rebounds per game, and assists per game (all averages)
--for players with more than 15 points per
--and orders them points per game descending.
SELECT PlayerID, AVG(points) AS ppg, AVG(rebounds) AS rpg, AVG(assists) AS apg
FROM PERFORMANCE
GROUP BY playerID
HAVING AVG(points) >= 15
ORDER BY AVG(points) DESC;
------------------------------------------------------
--Query 6: Correlated subquery
--Query finds all the teams that did not play in the 2015 tournament (i.e., they have
--no record for their tournament region that year)
SELECT t.teamID, t.name
FROM Team t
WHERE NOT EXISTS (SELECT s.teamID
                  FROM Season s
                  WHERE s.teamID = t.teamID AND
				  s.year = 2015 AND
				  s.region IS NOT NULL);
-------------------------------------------------------
--Query 7: Non-correlated subquery
--Query finds all the team IDs and names that do not have any championships
SELECT t.teamID, t.name
FROM Team t
WHERE t.teamID NOT IN (SELECT c.teamID
                       FROM Championship c);
-------------------------------------------------------
--Query 8: Relational Division
--Query finds all the teams where in all of their games for the current year, 
--the highest score was less than 85 (the last part excludes the teams that
--are in the database but didn't play any games)
SELECT t.name
FROM Team t, Season s
WHERE NOT EXISTS((SELECT g.gameID
				  FROM Game g
				  WHERE winner = t.teamID OR
				  loser = t.teamID)
				  MINUS
				  (SELECT g.gameID
				  FROM Game g
				  WHERE winScore < 85)) AND
t.teamID = s.teamID AND
s.year = 2016 AND
s.region IS NOT NULL;

-------------------------------------------------------
--Query 9: Outer Join Query
--Query finds all the teams and the years they won championships
SELECT t.name, c.yearWon
FROM Team t
LEFT JOIN Championship c ON t.teamID = c.teamID
ORDER BY c.yearWon;
-------------------------------------------------------
/*
< The insert/delete/update statements  to test the enforcement of ICs> 
Include the following items for every IC that you test
    -A comment line stating: Testing: < IC name> 
    -A SQL INSERT, DELETE, or UPDATE that will test the IC.
*/
--testing perIC6, adding a duplicate key 
INSERT INTO Performance VALUES(3,3,14,0,2);
--testing playerIC2, adding a player with a non-existant team
INSERT INTO Player VALUES(99,0,'test','player',73,'Jr',9);
--testing gameIC2, game with invalid region
INSERT INTO Game VALUES(4,'North',date '2016-04-02',95,51,1,3,NULL);
--testing cIC4, coach with start year after end year
INSERT INTO Coaches VALUES(9,6,1987,1986); 
    COMMIT 
-- 
SPOOL OFF

