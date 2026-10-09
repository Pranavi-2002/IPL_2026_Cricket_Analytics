create database IPL;
use IPL;

CREATE TABLE matches(
    match_id INT,
    date DATE,
    venue VARCHAR(200),
    team1 VARCHAR(100),
    team2 VARCHAR(100),
    stage VARCHAR(50),
    toss_winner VARCHAR(100),
    toss_decision VARCHAR(20),
    first_ings_score INT,
    first_ings_wkts INT,
    second_ings_score INT,
    second_ings_wkts INT,
    match_result VARCHAR(100),
    match_winner VARCHAR(100),
    wb_runs INT,
    wb_wickets INT,
    balls_left INT,
    player_of_the_match VARCHAR(100),
    top_scorer VARCHAR(100),
    highscore INT,
    best_bowling VARCHAR(100),
    best_bowling_figure VARCHAR(50),
    super_over_match VARCHAR(20)
);

select * from matches;

CREATE TABLE `deliveries` (
   `match_no` int DEFAULT NULL,
   `date` date DEFAULT NULL,
   `stage` varchar(50) DEFAULT NULL,
   `venue` varchar(200) DEFAULT NULL,
   `batting_team` varchar(100) DEFAULT NULL,
   `bowling_team` varchar(100) DEFAULT NULL,
   `innings` int DEFAULT NULL,
   `over` decimal(4,1) DEFAULT NULL,
   `striker` varchar(100) DEFAULT NULL,
   `bowler` varchar(100) DEFAULT NULL,
   `runs_of_bat` int DEFAULT NULL,
   `extras` int DEFAULT NULL,
   `wide` int DEFAULT NULL,
   `legbyes` int DEFAULT NULL,
   `byes` int DEFAULT NULL,
   `noballs` int DEFAULT NULL,
   `wicket_type` varchar(50) DEFAULT NULL,
   `player_dismissed` varchar(100) DEFAULT NULL,
   `fielder` varchar(100) DEFAULT NULL
 ) ;

select count(*) from deliveries;

select * from deliveries;

SELECT
    MIN(date) AS first_date,
    MAX(date) AS latest_date
FROM deliveries;

SHOW VARIABLES LIKE 'local_infile';
SET GLOBAL local_infile = 1;

LOAD DATA LOCAL INFILE 'C:/Users/user/Desktop/Powerbi/IPL/deliveries.csv'
INTO TABLE deliveries
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\r\n'
IGNORE 1 ROWS;

CREATE TABLE squads(
    team_no INT,
    team_name VARCHAR(100),
    player VARCHAR(100),
    nationality VARCHAR(50),
    role VARCHAR(50),
    designation VARCHAR(100)
);

select * from squads;

CREATE TABLE venues(
    venue_stadium VARCHAR(200),
    city VARCHAR(100),
    state VARCHAR(100),
    capacity INT,
    home_team VARCHAR(100)
);

select * from venues;

INSERT INTO venues(venue_stadium, city, state, capacity, home_team) VALUES ('Shaheed Veer Narayan Singh International Stadium','Raipur','Chhattisgarh',NULL,NULL);
update venues set state='Gujarat' where city='Ahmedabad';
CREATE TABLE points_table(
    position INT,
    team VARCHAR(100),
    matches INT,
    wins INT,
    defeats INT,
    ties INT,
    abandoned INT,
    points INT,
    nrr DECIMAL(6,3)
);

-------------------------- DATA CLEANING and DATA VALIDAION ----------------------------

SELECT DISTINCT team_name FROM squads;

UPDATE squads SET team_name = 'Gujarat Titans' WHERE team_name = 'Gujrat Titans';
UPDATE squads SET team_name = 'Kolkata Knight Riders' WHERE team_name = 'Kolkata Night Riders';

CREATE TABLE team_mapping (
    team_code VARCHAR(10) PRIMARY KEY,
    team_name VARCHAR(100) NOT NULL
);

INSERT INTO team_mapping (team_code, team_name)
VALUES
('MI', 'Mumbai Indians'),
('CSK', 'Chennai Super Kings'),
('KKR', 'Kolkata Knight Riders'),
('RCB', 'Royal Challengers Bengaluru'),
('GT', 'Gujarat Titans'),
('RR', 'Rajasthan Royals'),
('SRH', 'Sunrisers Hyderabad'),
('PBKS', 'Punjab Kings'),
('DC', 'Delhi Capitals'),
('LSG', 'Lucknow Super Giants');

CREATE TABLE venue_mapping (
    raw_venue VARCHAR(150) PRIMARY KEY,
    venue_stadium VARCHAR(100),
    city VARCHAR(100)
);

INSERT INTO venue_mapping
    (raw_venue, venue_stadium, city)
VALUES

-- 1. Arun Jaitley Stadium
('Arun Jaitley Stadium, Delhi',
 'Arun Jaitley Stadium',
 'New Delhi'),

-- 2. Barsapara Stadium
('Barsapara Stadium, Guwahati',
 'Barsapara Stadium',
 'Guwahati'),

('Barsapara Cricket Stadium, Guwahati',
 'Barsapara Stadium',
 'Guwahati'),

-- 3. Eden Gardens
('Eden Gardens, Kolkata',
 'Eden Gardens',
 'Kolkata'),

-- 4. Ekana Cricket Stadium
('Ekana Cricket Stadium, Lucknow',
 'Ekana Cricket Stadium',
 'Lucknow'),

('Bharat Ratna Shri Atal Bihari Vajpayee Ekana Cricket Stadium, Lucknow',
 'Ekana Cricket Stadium',
 'Lucknow'),

-- 5. HPCA Stadium
('HPCA Stadium, Dharamshala',
 'HPCA Stadium',
 'Dharamshala'),

('Himachal Pradesh Cricket Association Stadium, Dharamsala',
 'HPCA Stadium',
 'Dharamshala'),

-- 6. M. Chinnaswamy Stadium
('M. Chinnaswamy Stadium, Bangalore',
 'M. Chinnaswamy Stadium',
 'Bengaluru'),

('M.Chinnaswamy Stadium, Bengaluru',
 'M. Chinnaswamy Stadium',
 'Bengaluru'),

-- 7. MA Chidambaram Stadium
('MA Chidambaram Stadium, Chennai',
 'MA Chidambaram Stadium',
 'Chennai'),

-- 8. New PCA Cricket Stadium
('New PCA Cricket Stadium, Mullanpur',
 'New PCA Cricket Stadium',
 'Chandigarh'),

('Maharaja Yadavindra Singh International Cricket Stadium, Mullanpur, New Chandigarh',
 'New PCA Cricket Stadium',
 'Chandigarh'),

-- 9. Narendra Modi Stadium
('Narendra Modi Stadium, Ahmedabad',
 'Narendra Modi Stadium',
 'Ahmedabad'),

-- 10. Rajiv Gandhi International Stadium
('Rajiv Gandhi International Stadium, Hyderabad',
 'Rajiv Gandhi International Stadium',
 'Hyderabad'),

-- 11. Sawai Mansingh Stadium
('Sawai Mansingh Stadium, Jaipur',
 'Sawai Mansingh Stadium',
 'Jaipur'),

-- 12. Shaheed Veer Narayan Singh International Stadium
('Shaheed Veer Narayan Singh International Stadium, Raipur',
 'Shaheed Veer Narayan Singh International Stadium',
 'Raipur'),

-- 13. Wankhede Stadium
('Wankhede Stadium, Mumbai',
 'Wankhede Stadium',
 'Mumbai');
 
 
 SELECT
    m.match_id,
    m.venue AS original_venue,
    vm.venue_stadium,
    vm.city
FROM matches m
LEFT JOIN venue_mapping vm
    ON m.venue = vm.raw_venue;
    
SELECT
    d.match_no,
    d.venue AS original_venue,
    vm.venue_stadium,
    vm.city
FROM deliveries d
LEFT JOIN venue_mapping vm
    ON d.venue = vm.raw_venue;
    
SELECT DISTINCT venue
FROM matches m
LEFT JOIN venue_mapping vm
    ON m.venue = vm.raw_venue
WHERE vm.raw_venue IS NULL;

SELECT DISTINCT venue
FROM deliveries d
LEFT JOIN venue_mapping vm
    ON d.venue = vm.raw_venue
WHERE vm.raw_venue IS NULL;

SELECT DISTINCT team
FROM (
    SELECT team1 AS team
    FROM matches

    UNION

    SELECT team2 AS team
    FROM matches
) AS match_teams
LEFT JOIN team_mapping tm
    ON match_teams.team = tm.team_code
WHERE tm.team_code IS NULL;

SELECT DISTINCT team
FROM (
    SELECT batting_team AS team
    FROM deliveries

    UNION

    SELECT bowling_team AS team
    FROM deliveries
) AS delivery_teams
LEFT JOIN team_mapping tm
    ON delivery_teams.team = tm.team_code
WHERE tm.team_code IS NULL;

SELECT pt.team
FROM points_table pt
LEFT JOIN team_mapping tm
    ON pt.team = tm.team_name
WHERE tm.team_name IS NULL;

SELECT DISTINCT s.team_name
FROM squads s
LEFT JOIN team_mapping tm
    ON s.team_name = tm.team_name
WHERE tm.team_name IS NULL;

SELECT
    tm.team_code,
    tm.team_name,
    COUNT(DISTINCT m.match_id) AS matches_played
FROM team_mapping tm
LEFT JOIN matches m
    ON tm.team_code = m.team1
    OR tm.team_code = m.team2
GROUP BY
    tm.team_code,
    tm.team_name
ORDER BY matches_played DESC;

SELECT
    m.match_id,
    m.date,
    m.team1,
    m.team2
FROM matches m
LEFT JOIN (
    SELECT DISTINCT match_no
    FROM deliveries
) d
    ON m.match_id = d.match_no
WHERE d.match_no IS NULL;

SELECT DISTINCT
    d.match_no
FROM deliveries d
LEFT JOIN matches m
    ON d.match_no = m.match_id
WHERE m.match_id IS NULL;

SELECT DISTINCT
    m.team1 AS team_code
FROM matches m
LEFT JOIN team_mapping tm
    ON m.team1 = tm.team_code
WHERE tm.team_code IS NULL

UNION

SELECT DISTINCT
    m.team2 AS team_code
FROM matches m
LEFT JOIN team_mapping tm
    ON m.team2 = tm.team_code
WHERE tm.team_code IS NULL;

SELECT DISTINCT
    d.venue
FROM deliveries d
LEFT JOIN venue_mapping vm
    ON d.venue = vm.raw_venue
WHERE vm.raw_venue IS NULL;
SELECT DISTINCT
    vm.venue_stadium
FROM venue_mapping vm
LEFT JOIN venues v
    ON vm.venue_stadium = v.venue_stadium
WHERE v.venue_stadium IS NULL;

SELECT
    COUNT(DISTINCT match_no) AS delivery_matches_count
FROM deliveries;

SELECT DISTINCT
    d.match_no,
    d.batting_team,
    d.bowling_team,
    m.team1,
    m.team2
FROM deliveries d
JOIN matches m
    ON d.match_no = m.match_id
WHERE
    (
        d.batting_team NOT IN (m.team1, m.team2)
        OR
        d.bowling_team NOT IN (m.team1, m.team2)
    );
    
    SELECT *
FROM deliveries
WHERE batting_team = bowling_team;

SELECT
    innings,
    COUNT(*) AS deliveries
FROM deliveries
GROUP BY innings
ORDER BY innings;

SELECT
    d.match_no,
    d.innings,
    d.batting_team,
    d.bowling_team,
    d.`over`,
    d.striker,
    d.bowler,
    d.runs_of_bat,
    d.extras,
    d.wicket_type
FROM deliveries d
WHERE d.innings IN (3, 4)
ORDER BY d.match_no, d.innings, d.`over`;

SELECT DISTINCT
    match_id,
    team1,
    team2,
    super_over_match,
    match_result,
    match_winner
FROM matches
WHERE super_over_match IS NOT NULL;

SELECT
    match_id,
    team1,
    team2,
    super_over_match,
    match_result,
    match_winner
FROM matches
WHERE super_over_match = 'Yes';

SELECT
    match_no,
    innings,
    COUNT(*) AS deliveries
FROM deliveries
WHERE innings > 2
GROUP BY match_no, innings
ORDER BY match_no, innings;


SELECT *
FROM deliveries
WHERE runs_of_bat < 0
   OR extras < 0;
   
SELECT
    m.match_id,
    m.team1,
    m.team2,
    m.match_result,
    COUNT(DISTINCT d.match_no) AS delivery_match
FROM matches m
LEFT JOIN deliveries d
    ON m.match_id = d.match_no
GROUP BY
    m.match_id,
    m.team1,
    m.team2,
    m.match_result
ORDER BY m.match_id;

SELECT
    match_no,
    COUNT(*) AS deliveries,
    COUNT(DISTINCT innings) AS innings
FROM deliveries
WHERE match_no = 12
GROUP BY match_no;

SELECT
    match_no,
    innings,
    batting_team,
    bowling_team,
    COUNT(*) AS deliveries
FROM deliveries
WHERE match_no = 12
GROUP BY
    match_no,
    innings,
    batting_team,
    bowling_team;
