CREATE DATABASE IF NOT EXISTS cricsheet_db;
USE cricsheet_db;

DROP TABLE IF EXISTS ipl_matches;
CREATE TABLE ipl_matches (
    match_id VARCHAR(100) PRIMARY KEY,
    date DATE,
    match_type VARCHAR(20),
    team1 VARCHAR(100),
    team2 VARCHAR(100),
    venue VARCHAR(200),
    city VARCHAR(100),
    toss_winner VARCHAR(100),
    winner VARCHAR(100)
);

DROP TABLE IF EXISTS odi_matches;
CREATE TABLE odi_matches LIKE ipl_matches;

DROP TABLE IF EXISTS t20_matches;
CREATE TABLE t20_matches LIKE ipl_matches;

DROP TABLE IF EXISTS test_matches;
CREATE TABLE test_matches LIKE ipl_matches;
