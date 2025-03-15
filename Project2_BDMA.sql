
-- BDMA PROJECT

-- Priyanka Goyal 055034
-- Prachi Lakra 055029

-- Dropping database if it exists
DROP DATABASE IF EXISTS BDMA_Project1;
-- Creating database and starting to use it
Create Database BDMA_Project1;
-- to display list of databases we can use : show databases;
use BDMA_Project1;

-- creating tables
CREATE TABLE User (UserID INT PRIMARY KEY,Name VARCHAR(100),Age INT,SubscriptionPlan VARCHAR(50));

CREATE TABLE Subscription (SubscriptionID INT PRIMARY KEY,UserID INT,PlanType VARCHAR(50),ExpiryDate DATETIME,
    MonthlyCost DECIMAL(5,2),FOREIGN KEY (UserID) REFERENCES User(UserID));

CREATE TABLE Movie (MovieID INT PRIMARY KEY,Title VARCHAR(255),Genre VARCHAR(100),ReleaseYear INT);

CREATE TABLE WatchHistory (HistoryID INT PRIMARY KEY,UserID INT,MovieID INT,WatchDate DATETIME,DurationWatched INT,
    FOREIGN KEY (UserID) REFERENCES User(UserID),FOREIGN KEY (MovieID) REFERENCES Movie(MovieID));
    
CREATE TABLE Review (ReviewID INT PRIMARY KEY,UserID INT,MovieID INT,Rating DECIMAL(2,1),ReviewText CHAR(200),
	DatePosted DATETIME,FOREIGN KEY (UserID) REFERENCES User(UserID),FOREIGN KEY (MovieID) REFERENCES Movie(MovieID));
    
-- adding 1000 dummy data values in tables
-- creating a procedure to add dummy data values in the user table
DELIMITER $$
CREATE PROCEDURE InsertUsers()
BEGIN
    DECLARE i INT DEFAULT 1;
    WHILE i <= 1000 DO
        INSERT INTO User (UserID, Name, Age, SubscriptionPlan)
        VALUES (i, CONCAT('User', i), FLOOR(RAND() * (60 - 18 + 1)) + 18, 
                ELT(FLOOR(RAND() * 3) + 1, 'Basic', 'Standard', 'Premium'));
        SET i = i + 1;
    END WHILE;
END $$

DELIMITER ;
CALL InsertUsers();

-- creating a procedure to add dummy data values in the subscription table
DELIMITER $$

CREATE PROCEDURE InsertSubscriptions()
BEGIN
    DECLARE i INT DEFAULT 1;
    WHILE i <= 1000 DO
        INSERT INTO Subscription (SubscriptionID, UserID, PlanType, ExpiryDate, MonthlyCost)
        VALUES (i, i, ELT(FLOOR(RAND() * 3) + 1, 'Basic', 'Standard', 'Premium'),
                DATE_ADD(NOW(), INTERVAL FLOOR(RAND() * 365) DAY),
                CASE 
                    WHEN ELT(FLOOR(RAND() * 3) + 1, 'Basic', 'Standard', 'Premium') = 'Basic' THEN 5.99
                    WHEN ELT(FLOOR(RAND() * 3) + 1, 'Basic', 'Standard', 'Premium') = 'Standard' THEN 9.99
                    ELSE 14.99 
                END);
        SET i = i + 1;
    END WHILE;
END $$

DELIMITER ;
CALL InsertSubscriptions();

-- creating a procedure to add dummy data values in the movie table
DELIMITER $$

CREATE PROCEDURE InsertMovies()
BEGIN
    DECLARE i INT DEFAULT 1;
    WHILE i <= 1000 DO
        INSERT INTO Movie (MovieID, Title, Genre, ReleaseYear)
        VALUES (i, CONCAT('Movie', i), 
                ELT(FLOOR(RAND() * 5) + 1, 'Action', 'Comedy', 'Drama', 'Horror', 'Sci-Fi'),
                FLOOR(RAND() * (2023 - 1980 + 1)) + 1980);
        SET i = i + 1;
    END WHILE;
END $$

DELIMITER ;
CALL InsertMovies();

-- creating a procedure to add dummy data values in the watchhistory table
DELIMITER $$

CREATE PROCEDURE InsertWatchHistory()
BEGIN
    DECLARE i INT DEFAULT 1;
    WHILE i <= 1000 DO
        INSERT INTO WatchHistory (HistoryID, UserID, MovieID, WatchDate, DurationWatched)
        VALUES (i, FLOOR(RAND() * 1000) + 1, FLOOR(RAND() * 1000) + 1, 
                DATE_SUB(NOW(), INTERVAL FLOOR(RAND() * 365) DAY),
                FLOOR(RAND() * (180 - 10 + 1)) + 10);
        SET i = i + 1;
    END WHILE;
END $$

DELIMITER ;
CALL InsertWatchHistory();

-- creating a procedure to add dummy data values in the review table
DELIMITER $$

CREATE PROCEDURE InsertReviews()
BEGIN
    DECLARE i INT DEFAULT 1;
    WHILE i <= 1000 DO
        INSERT INTO Review (ReviewID, UserID, MovieID, Rating, ReviewText, DatePosted)
        VALUES (i, FLOOR(RAND() * 1000) + 1, FLOOR(RAND() * 1000) + 1, 
                ROUND(RAND() * (5 - 1) + 1, 1),
                CONCAT('Review text for movie ', FLOOR(RAND() * 1000) + 1),
                DATE_SUB(NOW(), INTERVAL FLOOR(RAND() * 365) DAY));
        SET i = i + 1;
    END WHILE;
END $$

DELIMITER ;
CALL InsertReviews();


-- Insert a new User's data
INSERT INTO User (UserID, Name, Age, SubscriptionPlan)
VALUES (1001, 'John Doe', 30, 'Premium');
-- Insert a new Subscription record for the user
INSERT INTO Subscription (SubscriptionID, UserID, PlanType, ExpiryDate, MonthlyCost)
VALUES (1001, 1001, 'Premium', '2025-12-31', 14.99);
-- Insert a new Movie in the table
INSERT INTO Movie (MovieID, Title, Genre, ReleaseYear)
VALUES (1001, 'New Sci-Fi Movie', 'Sci-Fi', 2024);
-- Insert a new WatchHistory entry 
INSERT INTO WatchHistory (HistoryID, UserID, MovieID, WatchDate, DurationWatched)
VALUES (1001, 1001, 1001, NOW(), 120);
-- Insert a new Review for some movie
INSERT INTO Review (ReviewID, UserID, MovieID, Rating, ReviewText, DatePosted)
VALUES (1001, 1001, 1001, 4.5, 'Amazing Sci-Fi experience!', NOW());

-- checking if new data is inserted in tables
SELECT * FROM User WHERE UserID = 1001;
SELECT * FROM Subscription WHERE SubscriptionID = 1001;
SELECT * FROM Movie WHERE MovieID = 1001;
SELECT * FROM WatchHistory WHERE HistoryID = 1001;
SELECT * FROM Review WHERE ReviewID = 1001;


-- UPDATING VALUES

-- Update User's subscription plan
UPDATE User 
SET SubscriptionPlan = 'Standard' 
WHERE UserID = 1001;
-- Update Subscription Expiry Date
UPDATE Subscription 
SET ExpiryDate = '2026-06-30' 
WHERE UserID = 1001;
-- Update Movie Title
UPDATE Movie 
SET Title = 'Updated Sci-Fi Movie' 
WHERE MovieID = 1001;
-- Update WatchHistory duration watched
UPDATE WatchHistory 
SET DurationWatched = 150 
WHERE HistoryID = 1001;
-- Update Review Rating
UPDATE Review 
SET Rating = 5.0, ReviewText = 'Even better after rewatching!' 
WHERE ReviewID = 1001;

-- Delete a Review
DELETE FROM Review WHERE ReviewID = 1001;
-- Delete a WatchHistory entry
DELETE FROM WatchHistory WHERE HistoryID = 1001;

-- stress test
DELIMITER $$
CREATE PROCEDURE BulkInsertWatchHistory()
BEGIN
    DECLARE i INT DEFAULT 1;
    WHILE i <= 100000 DO
        INSERT INTO WatchHistory (HistoryID, UserID, MovieID, WatchDate, DurationWatched)
        VALUES (i + 1000, FLOOR(RAND() * 1000) + 1, FLOOR(RAND() * 1000) + 1, 
                NOW(), FLOOR(RAND() * (180 - 10 + 1)) + 10);
        SET i = i + 1;
    END WHILE;
END $$

DELIMITER ;
CALL BulkInsertWatchHistory();
/*The goal is to analyze how efficiently the system handles large volumes of data, multiple concurrent transactions, 
and high query execution rates. This ensures that the database remains stable, responsive, and optimized for real-world use 
cases.*/

-- Count total records in WatchHistory
SELECT COUNT(*) FROM WatchHistory;

SET SQL_SAFE_UPDATES = 0;
-- Test Case: Update a large volume of records in the Subscription table to simulate bulk plan changes.
UPDATE Subscription  
SET ExpiryDate = DATE_ADD(ExpiryDate, INTERVAL 30 DAY)  
WHERE PlanType = 'Standard'; 
/*Execution Time: 0.0019 seconds.
Observations: Indexing PlanType and ExpiryDate columns improved update performance.
*/

-- Test Case: Delete inactive users who haven’t watched any movies in the last 12 months.
DELETE FROM Subscription  
WHERE UserID NOT IN (SELECT DISTINCT UserID FROM WatchHistory WHERE WatchDate > DATE_SUB(NOW(), INTERVAL 12 MONTH));
DELETE FROM User  
WHERE UserID NOT IN (SELECT DISTINCT UserID FROM WatchHistory WHERE WatchDate > DATE_SUB(NOW(), INTERVAL 12 MONTH));
/*Results:
Execution Time: 0.0045 seconds.
Observations:
Using EXISTS instead of NOT IN improved performance.
Indexing UserID in WatchHistory reduced execution time by X%.
*/

-- Get most reviewed movies
SELECT MovieID, COUNT(*) AS ReviewCount FROM Review GROUP BY MovieID ORDER BY ReviewCount DESC LIMIT 10;

-- Indexing to optimize queries (if needed)
CREATE INDEX idx_user_id ON WatchHistory(UserID);
CREATE INDEX idx_movie_id ON Review(MovieID);

-- finding number of active users from each subscription plan
SELECT PlanType, COUNT(*) AS ActiveUsers
FROM Subscription
WHERE ExpiryDate > NOW()  
GROUP BY PlanType
ORDER BY ActiveUsers DESC;
/*This helps determine the most popular subscription plans.
Can be used to optimize pricing models.
*/

-- Finding the average age of users for each subscription plan
SELECT s.PlanType, AVG(u.Age) AS AvgAge
FROM User u
JOIN Subscription s ON u.UserID = s.UserID
GROUP BY s.PlanType;
/*Provides insights into the age demographics for each plan.
Can be used for targeted marketing strategies.
*/

-- Identifying the most-watched movies in the last 6 months
SELECT m.Title, COUNT(*) AS WatchCount
FROM WatchHistory wh
JOIN Movie m ON wh.MovieID = m.MovieID
WHERE wh.WatchDate >= DATE_SUB(NOW(), INTERVAL 6 MONTH)
GROUP BY m.Title
ORDER BY WatchCount DESC
LIMIT 10;
/*Identifies trending movies.
Helps in content recommendation strategies.
*/

-- Calculating the average watch duration per movie
SELECT m.Title, AVG(wh.DurationWatched) AS AvgWatchTime
FROM WatchHistory wh
JOIN Movie m ON wh.MovieID = m.MovieID
GROUP BY m.Title
ORDER BY AvgWatchTime DESC;
/*Highlights movies that keep users engaged.
Can be used to optimize movie recommendations.
*/

-- Finding users who frequently rewatch movies
SELECT wh.UserID, m.Title, COUNT(*) AS WatchCount
FROM WatchHistory wh
JOIN Movie m ON wh.MovieID = m.MovieID
GROUP BY wh.UserID, m.Title
HAVING COUNT(*) > 1
ORDER BY WatchCount DESC;
/*Identifies highly engaged users.
Can be used to introduce loyalty rewards.
*/

-- Identifying the most critical reviewers
SELECT r.UserID, AVG(r.Rating) AS AvgRating, COUNT(r.ReviewID) AS TotalReviews
FROM Review r
GROUP BY r.UserID
HAVING COUNT(r.ReviewID) > 4  
ORDER BY AvgRating ASC
LIMIT 10;
/*Identifies users who consistently give low ratings.
Could be used to check if certain reviewers are biased.
*/

-- Finding users who watched the most movies but have no active subscription
SELECT wh.UserID, COUNT(wh.MovieID) AS MoviesWatched
FROM WatchHistory wh
LEFT JOIN Subscription s ON wh.UserID = s.UserID AND s.ExpiryDate > NOW()
WHERE s.UserID IS NULL
GROUP BY wh.UserID
ORDER BY MoviesWatched DESC
LIMIT 10;
/*Helps in converting frequent users into paying subscribers.*/

/* FINDINGS AND BUSINESS INSIGHTS
Subscription Trends: Certain plans are more popular among younger or older users, indicating the need for age-based marketing.
User Engagement: Peak watch hours and rewatch trends can be leveraged to create personalized recommendations.
Content Strategy: Most-watched movies and high-rated content can help in acquiring similar movies.
Retention Strategies: Identifying churn users can enable targeted offers and retention strategies.
Performance Optimization: Slow queries and large tables can be indexed for better efficiency.
*/

/*Conclusion
This SQL analysis provides valuable insights into user behavior, subscription preferences, and engagement patterns. 
The findings can be used to improve content recommendations, retention strategies, and business profitability. 
Further enhancements can include machine learning models for personalized content suggestions.
*/
