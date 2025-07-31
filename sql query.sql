CREATE DATABASE tennis_data;
USE tennis_data;
-- 1. Categories Table
CREATE TABLE categories (
    category_id VARCHAR(50) PRIMARY KEY,
    category_name VARCHAR(100) NOT NULL
);

-- 2. Competitions Table
CREATE TABLE competitions (
    competition_id VARCHAR(50) PRIMARY KEY,
    competition_name VARCHAR(100) NOT NULL,
    type VARCHAR(20),
    gender VARCHAR(10),
    category_id VARCHAR(50),
    level VARCHAR(50),
    parent_id VARCHAR(50),
    FOREIGN KEY (category_id) REFERENCES categories(category_id)
);

-- 3. Complexes Table
CREATE TABLE complexes (
    complex_id VARCHAR(50) PRIMARY KEY,
    complex_name VARCHAR(100)
);
-- 4. Venues Table
CREATE TABLE venues (
    venue_id VARCHAR(50) PRIMARY KEY,
    venue_name VARCHAR(100),
    city_name VARCHAR(100),
    country_name VARCHAR(100),
    country_code CHAR(3),
    timezone VARCHAR(100),
    complex_id VARCHAR(50),
    FOREIGN KEY (complex_id) REFERENCES complexes(complex_id)
);



-- 5. Competitors Table
CREATE TABLE competitorss (
    competitor_id VARCHAR(50) PRIMARY KEY,
    name VARCHAR(100),
    country VARCHAR(100),
    country_code CHAR(3),
    abbreviation VARCHAR(10)
);

-- 6. Competitor Rankings Table
CREATE TABLE competitor_rankingss (
    rank_id INT AUTO_INCREMENT PRIMARY KEY,
    competitor_id VARCHAR(50),
    ranks INT,
    points INT,
    movement INT,
    tour VARCHAR(10),
    gender VARCHAR(10),
    FOREIGN KEY (competitor_id) REFERENCES competitors(competitor_id)
);
SET FOREIGN_KEY_CHECKS = 0;
-- (You can optionally drop competitor_rankings if corrupted)
-- DROP TABLE competitor_rankings;

TRUNCATE TABLE competitor_rankings;
TRUNCATE TABLE competitors;
SET FOREIGN_KEY_CHECKS = 1;
SHOW TABLES;
CREATE TABLE competitor_rankings (
    rank_id INT AUTO_INCREMENT PRIMARY KEY,
    competitor_id VARCHAR(50),
    ranks INT,
    points INT,
    movement INT,
    tour VARCHAR(10),
    gender VARCHAR(10),
    FOREIGN KEY (competitor_id) REFERENCES competitors(competitor_id)
);
RENAME TABLE competitorss TO competitors;
RENAME TABLE competitor_rankingss TO competitor_rankings;



/*Part 1: Competitions & Categories*/
/*1. List all competitions along with their category name*/ 
SELECT c.competition_name, cat.category_name
FROM competitions c
JOIN categories cat ON c.category_id = cat.category_id;

/*2. Count the number of competitions in each category*/
SELECT cat.category_name, COUNT(*) AS competition_count
FROM competitions c
JOIN categories cat ON c.category_id = cat.category_id
GROUP BY cat.category_name;

/*3. Find all competitions of type 'doubles'*/
SELECT competition_name, type
FROM competitions
WHERE type = 'doubles';

/* 4. Get competitions that belong to a specific category (e.g., ITF Men)*/
SELECT competition_name
FROM competitions c
JOIN categories cat ON c.category_id = cat.category_id
WHERE cat.category_name = 'ITF Men';

/* 5. Identify parent competitions and their sub-competitions*/
SELECT parent.competition_name AS parent_competition, child.competition_name AS sub_competition
FROM competitions child
JOIN competitions parent ON child.parent_id = parent.competition_id;

/*6. Analyze the distribution of competition types by category*/
SELECT cat.category_name, c.type, COUNT(*) AS total
FROM competitions c
JOIN categories cat ON c.category_id = cat.category_id
GROUP BY cat.category_name, c.type;

/* 7. List all competitions with no parent (top-level competitions)*/
SELECT competition_name
FROM competitions
WHERE parent_id IS NULL;


/* Part 2: Complexes & Venues/
/*1. List all venues along with their associated complex name*/
SELECT v.venue_name, c.complex_name
FROM venues v
JOIN complexes c ON v.complex_id = c.complex_id;

/*2. Count the number of venues in each complex*/
SELECT c.complex_name, COUNT(*) AS venue_count
FROM venues v
JOIN complexes c ON v.complex_id = c.complex_id
GROUP BY c.complex_name;

/*3. Get details of venues in a specific country (e.g., Chile)*/
SELECT *
FROM venues
WHERE country_name = 'Chile';

/*4. Identify all venues and their timezones*/
SELECT venue_name, timezone
FROM venues;

/*5. Find complexes that have more than one venue*/
SELECT c.complex_name, COUNT(*) AS venue_count
FROM venues v
JOIN complexes c ON v.complex_id = c.complex_id
GROUP BY c.complex_name
HAVING venue_count > 1;

/*6. List venues grouped by country*/
SELECT country_name, COUNT(*) AS total_venues
FROM venues
GROUP BY country_name;

/* 7. Find all venues for a specific complex (e.g., Nacional)*/
SELECT v.venue_name
FROM venues v
JOIN complexes c ON v.complex_id = c.complex_id
WHERE c.complex_name = 'Nacional';


/*Part 3: Competitor Rankings*/
/*1. Get all competitors with their rank and points*/
SELECT name, ranks, points
FROM competitors comp
JOIN competitor_rankings cr ON comp.competitor_id = cr.competitor_id;

/*2. Find competitors ranked in the top 5*/
SELECT name, ranks
FROM competitors comp
JOIN competitor_rankings cr ON comp.competitor_id = cr.competitor_id
WHERE ranks <= 5
ORDER BY ranks;

/*3. List competitors with no rank movement (stable rank)*/
SELECT name, ranks, movement
FROM competitors comp
JOIN competitor_rankings cr ON comp.competitor_id = cr.competitor_id
WHERE movement = 0;

/* 4. Get total points of competitors from a specific country (e.g., Croatia)*/
SELECT country, SUM(points) AS total_points
FROM competitors comp
JOIN competitor_rankings cr ON comp.competitor_id = cr.competitor_id
WHERE country = 'Croatia'
GROUP BY country;

/* 5. Count the number of competitors per country*/
SELECT country, COUNT(*) AS competitor_count
FROM competitors
GROUP BY country
ORDER BY competitor_count DESC;

/*6. Find competitors with the highest point*/
SELECT name, points
FROM competitors comp
JOIN competitor_rankings cr ON comp.competitor_id = cr.competitor_id
ORDER BY points DESC
LIMIT 5;
