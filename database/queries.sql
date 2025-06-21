USE cricsheet_db;

-- 1. Total matches played in each format
SELECT 'IPL' AS Format, COUNT(*) AS Total_Matches FROM ipl_matches
UNION
SELECT 'ODI', COUNT(*) FROM odi_matches
UNION
SELECT 'T20', COUNT(*) FROM t20_matches
UNION
SELECT 'Test', COUNT(*) FROM test_matches;

-- 2. Unique venues used in all formats
SELECT DISTINCT venue FROM ipl_matches
UNION
SELECT DISTINCT venue FROM odi_matches
UNION
SELECT DISTINCT venue FROM t20_matches
UNION
SELECT DISTINCT venue FROM test_matches;

-- 3. Total wins per team in IPL
SELECT winner AS Team, COUNT(*) AS Wins
FROM ipl_matches
WHERE winner IS NOT NULL
GROUP BY winner
ORDER BY Wins DESC;

-- 4. Toss winner vs Match winner (T20)
SELECT toss_winner, winner, COUNT(*) AS Matches
FROM t20_matches
WHERE toss_winner IS NOT NULL AND winner IS NOT NULL
GROUP BY toss_winner, winner
ORDER BY Matches DESC;

-- 5. Top 5 cities with most matches (ODI)
SELECT city, COUNT(*) AS Match_Count
FROM odi_matches
GROUP BY city
ORDER BY Match_Count DESC
LIMIT 5;

-- 6. Number of matches without a winner (Test - likely Draw)
SELECT COUNT(*) AS Draws
FROM test_matches
WHERE winner IS NULL;

-- 7. Most played team combinations in IPL
SELECT team1, team2, COUNT(*) AS Total_Clashes
FROM ipl_matches
GROUP BY team1, team2
ORDER BY Total_Clashes DESC
LIMIT 5;

-- 8. Total matches per city (across formats)
SELECT city, COUNT(*) AS Total_Matches
FROM (
    SELECT city FROM ipl_matches
    UNION ALL
    SELECT city FROM odi_matches
    UNION ALL
    SELECT city FROM t20_matches
    UNION ALL
    SELECT city FROM test_matches
) AS all_matches
GROUP BY city
ORDER BY Total_Matches DESC;

-- 9. Teams that won most tosses (ODI)
SELECT toss_winner, COUNT(*) AS Toss_Wins
FROM odi_matches
GROUP BY toss_winner
ORDER BY Toss_Wins DESC
LIMIT 5;

-- 10. Teams with highest number of wins in T20
SELECT winner AS Team, COUNT(*) AS Wins
FROM t20_matches
GROUP BY winner
ORDER BY Wins DESC
LIMIT 5;

-- 11. Matches per year (IPL)
SELECT YEAR(date) AS Year, COUNT(*) AS Matches
FROM ipl_matches
GROUP BY Year
ORDER BY Year;

-- 12. Win percentage for each team (IPL)
SELECT winner AS Team,
       COUNT(*) * 100.0 / (SELECT COUNT(*) FROM ipl_matches WHERE winner IS NOT NULL) AS Win_Percentage
FROM ipl_matches
WHERE winner IS NOT NULL
GROUP BY winner
ORDER BY Win_Percentage DESC;

-- 13. Top venues for Test matches
SELECT venue, COUNT(*) AS Matches
FROM test_matches
GROUP BY venue
ORDER BY Matches DESC
LIMIT 5;

-- 14. Team win distribution in all formats
SELECT 'ipl' AS Format, winner, COUNT(*) AS Wins FROM ipl_matches GROUP BY winner
UNION
SELECT 'odi', winner, COUNT(*) FROM odi_matches GROUP BY winner
UNION
SELECT 't20', winner, COUNT(*) FROM t20_matches GROUP BY winner
UNION
SELECT 'test', winner, COUNT(*) FROM test_matches GROUP BY winner;

-- 15. Most toss wins by a team in Test format
SELECT toss_winner, COUNT(*) AS Toss_Wins
FROM test_matches
GROUP BY toss_winner
ORDER BY Toss_Wins DESC;

-- 16. Matches played in neutral venues (if known)
SELECT venue, COUNT(*) AS Neutral_Matches
FROM odi_matches
WHERE city IS NULL
GROUP BY venue;

-- 17. First match date per format
SELECT 'IPL' AS Format, MIN(date) AS First_Match FROM ipl_matches
UNION
SELECT 'ODI', MIN(date) FROM odi_matches
UNION
SELECT 'T20', MIN(date) FROM t20_matches
UNION
SELECT 'Test', MIN(date) FROM test_matches;

-- 18. Win trends per year (IPL)
SELECT YEAR(date) AS Year, winner, COUNT(*) AS Wins
FROM ipl_matches
WHERE winner IS NOT NULL
GROUP BY Year, winner
ORDER BY Year, Wins DESC;

-- 19. City with most toss wins in ODI
SELECT city, COUNT(*) AS Toss_Win_City
FROM odi_matches
WHERE toss_winner IS NOT NULL
GROUP BY city
ORDER BY Toss_Win_City DESC
LIMIT 5;

-- 20. Team most consistent with toss & match win (IPL)
SELECT toss_winner, winner, COUNT(*) AS Matches
FROM ipl_matches
WHERE toss_winner = winner
GROUP BY toss_winner
ORDER BY Matches DESC
LIMIT 5;
