CREATE DATABASE fitness_tracker;
USE fitness_tracker;
-- Primary keys → INT AUTO_INCREMENT
-- Foreign keys → same datatype as PK
-- Dates → DATE, timestamps → DATETIME

-- INDEPENDENT TABLES ---------------------------

CREATE TABLE users (
user_id INT AUTO_INCREMENT PRIMARY KEY,
`name` VARCHAR(100) NOT NULL,
email VARCHAR (150) NOT NULL UNIQUE,
date_of_birth DATE,
height_cm DECIMAL(5,2),
weight_kg DECIMAL(5,2),
created_at DATETIME DEFAULT CURRENT_TIMESTAMP);

CREATE TABLE devices (
device_id INT AUTO_INCREMENT PRIMARY KEY,
device_name VARCHAR(100) NOT NULL,
brand_model VARCHAR(100) NOT NULL);

CREATE TABLE exercises (
exercise_id INT AUTO_INCREMENT PRIMARY KEY,
exercise_name VARCHAR(100) NOT NULL,
category VARCHAR(50) NOT NULL);

CREATE TABLE badges (
badge_id INT AUTO_INCREMENT PRIMARY KEY,
badge_name VARCHAR(100) NOT NULL UNIQUE);

CREATE TABLE challenges(
challenge_id INT AUTO_INCREMENT PRIMARY KEY,
challenge_name VARCHAR(100) NOT NULL, 
start_date DATE NOT NULL,
end_date DATE NOT NULL );

CREATE TABLE subscriptions (
subscription_id INT AUTO_INCREMENT PRIMARY KEY,
plan_name VARCHAR(100) NOT NULL UNIQUE,
price DECIMAL(8,2) NOT NULL);

CREATE TABLE features(

feature_id INT PRIMARY KEY AUTO_INCREMENT,
featured_name VARCHAR(100) NOT NULL UNIQUE );

ALTER TABLE features
CHANGE featured_name feature_name VARCHAR(100) NOT NULL UNIQUE;

-- DEPENDENT TABLES ---------------------

CREATE TABLE user_devices(
user_device_id INT AUTO_INCREMENT PRIMARY KEY,
user_id INT NOT NULL,
device_id INT NOT NULL,
connected_at DATETIME DEFAULT CURRENT_TIMESTAMP,
disconnected_at DATETIME,

FOREIGN KEY (user_id) REFERENCES users(user_id) ON DELETE CASCADE,
FOREIGN KEY (device_id) REFERENCES devices(device_id) ON DELETE RESTRICT );

CREATE TABLE workout_logs(
workout_id INT AUTO_INCREMENT PRIMARY KEY,
user_id INT NOT NULL,
workout_date DATE NOT NULL,
duration_minutes INT NOT NULL CHECK (duration_minutes > 0 ),
calories_burned INT CHECK (calories_burned >= 0),

FOREIGN KEY (user_id) REFERENCES users (user_id) ON DELETE CASCADE );

CREATE TABLE workout_exercises (
workout_exercise_id INT AUTO_INCREMENT PRIMARY KEY,
workout_id INT NOT NULL,
exercise_id INT NOT NULL,
sets INT NOT NULL CHECK (sets > 0),
reps INT NOT NULL CHECK (reps > 0),

FOREIGN KEY (workout_id) REFERENCES workout_logs(workout_id) ON DELETE CASCADE,
FOREIGN KEY (exercise_id)  REFERENCES exercises(exercise_id) ON DELETE RESTRICT );

ALTER TABLE workout_exercises
ADD duration_minutes INT CHECK (duration_minutes >= 0),
MODIFY reps INT NULL;
ALTER TABLE workout_exercises
MODIFY sets INT NULL;

CREATE TABLE user_challenges (
user_challenges INT AUTO_INCREMENT PRIMARY KEY,
user_id INT NOT NULL,
challenge_id INT NOT NULL,
joined_date DATE NOT NULL,

FOREIGN KEY (user_id) REFERENCES users(user_id) ON DELETE CASCADE,
FOREIGN KEY (challenge_id) REFERENCES challenges(challenge_id) ON DELETE RESTRICT);
 
ALTER TABLE user_challenges
ADD status VARCHAR(20) DEFAULT 'JOINED';
ALTER TABLE user_challenges
CHANGE user_challenges user_challenge_id INT AUTO_INCREMENT;


CREATE TABLE user_subscriptions (
user_subscription_id INT AUTO_INCREMENT PRIMARY KEY,
user_id INT NOT NULL,
subscription_id INT NOT NULL,
start_date DATE NOT NULL,
end_date DATE,

FOREIGN KEY (user_id) REFERENCES users(user_id) ON DELETE CASCADE,
FOREIGN KEY (subscription_id) REFERENCES subscriptions(subscription_id) ON DELETE RESTRICT);

CREATE TABLE user_badges (
user_badge_id INT AUTO_INCREMENT PRIMARY KEY,
user_id INT NOT NULL,
badge_id INT NOT NULL,
awarded_date DATE NOT NULL,

FOREIGN KEY (user_id) REFERENCES users(user_id) ON DELETE CASCADE,
FOREIGN KEY (badge_id) REFERENCES badges(badge_id) ON DELETE RESTRICT);

CREATE TABLE plan_features (

subscription_id INT NOT NULL,
feature_id INT NOT NULL,

PRIMARY KEY (subscription_id, feature_id),

FOREIGN KEY (subscription_id) REFERENCES subscriptions(subscription_id) ON DELETE CASCADE,
FOREIGN KEY (feature_id) REFERENCES features(feature_id) ON DELETE RESTRICT);

 -- LOG & EVENT TABLES -------------

CREATE TABLE activity_logs(
activity_id INT AUTO_INCREMENT PRIMARY KEY,
user_id INT NOT NULL,
user_device_id INT NOT NULL,
activity_date DATE NOT NULL,
steps INT CHECK (steps >= 0),
calories_burned INT CHECK (calories_burned >= 0),

FOREIGN KEY (user_id) REFERENCES users(user_id) ON DELETE CASCADE,
FOREIGN KEY (user_device_id) REFERENCES user_devices(user_device_id) ON DELETE RESTRICT);

CREATE TABLE heart_rate_logs (
hr_id INT AUTO_INCREMENT PRIMARY KEY, 
user_id INT NOT NULL,
user_device_id INT NOT NULL,
recorded_at DATETIME NOT NULL,
heart_rate INT NOT NULL CHECK(heart_rate > 0),

FOREIGN KEY (user_id) REFERENCES users(user_id) ON DELETE CASCADE,
FOREIGN KEY (user_device_id) REFERENCES user_devices(user_device_id) ON DELETE RESTRICT);

CREATE TABLE sleep_logs(
sleep_id INT AUTO_INCREMENT PRIMARY KEY,
user_id INT NOT NULL,
user_device_id INT NOT NULL,
sleep_date DATE NOT NULL,
sleep_hours DECIMAL(4,2) NOT NULL CHECK (sleep_hours >= 0),

FOREIGN KEY (user_id) REFERENCES users(user_id) ON DELETE CASCADE,
FOREIGN KEY (user_device_id) REFERENCES user_devices(user_device_id) ON DELETE RESTRICT);
ALTER TABLE sleep_logs
ADD UNIQUE (user_id, sleep_date);

CREATE TABLE nutrition_logs(
food_log_id INT AUTO_INCREMENT PRIMARY KEY,
user_id INT NOT NULL,
logged_at DATETIME NOT NULL,
calories INT NOT NULL CHECK(calories >= 0),

FOREIGN KEY (user_id) REFERENCES users(user_id) ON DELETE CASCADE); 

CREATE TABLE fitness_recommendations(
recommendation_id INT AUTO_INCREMENT PRIMARY KEY,
user_id INT NOT NULL,
recommendation_type VARCHAR (100),
message TEXT NOT NULL,
generated_at DATETIME DEFAULT CURRENT_TIMESTAMP,

FOREIGN KEY (user_id) REFERENCES users(user_id) ON DELETE CASCADE);

CREATE TABLE emergency_alerts(
alert_id INT AUTO_INCREMENT PRIMARY KEY,
user_id INT NOT NULL,
hr_id INT,
alert_type VARCHAR(100) NOT NULL,
severity VARCHAR(20),
triggered_at DATETIME DEFAULT CURRENT_TIMESTAMP,
`status` VARCHAR(20) DEFAULT 'ACTIVE',

FOREIGN KEY (user_id) REFERENCES users(user_id) ON DELETE CASCADE,
FOREIGN KEY (hr_id) REFERENCES heart_rate_logs(hr_id) ON DELETE RESTRICT);

SHOW TABLES;
describe subscriptions;

--   Sample Data   ----------------


--   USERS  ------------------------
INSERT INTO users (name, email, date_of_birth, height_cm, weight_kg)
VALUES
('Aarav Sharma', 'aarav@gmail.com', '1998-05-12', 175.0, 78.0),
('Neha Verma', 'neha@gmail.com', '2008-08-22', 162.0, 68.0),
('Anil Shrivastava', 'anil@gmail.com', '1995-09-18', 180.0, 75.0);

--   DEVICES  ------------------------
INSERT INTO devices (device_name, brand_model)
VALUES 
('Smart Watch', 'Fitbit Verse'),
('Fitness Band', 'Mi Band 7');

--   EXERCISES  -----------------------
INSERT INTO exercises (exercise_name, category)
VALUES
('Push Ups', 'Strength'),  -- 1
('Running', 'Cardio'),     -- 2
('Squats', 'Strength'),    -- 3
('Yin', 'Yoga');           -- 4

--   SUBSCRIPTIONS  --------------------
INSERT INTO subscriptions (plan_name, price)
VALUES
('Free', 0.00),
('Premium', 1200.00);

--   FEATURES  --------------------------
INSERT INTO features (feature_name)
VALUES
('AI Fitness Coaching'),
('Advanced Analytics'),
('Personalised Diet Plan');

--   BADGES  -----------------------------
INSERT INTO badges (badge_name)
VALUES
('10K Steps Badges'),
('Goal Achievement Badge'),
('Workout Streak Badge');

--   CHALLENGES  --------------------------
INSERT INTO challenges (challenge_name, start_date, end_date)
VALUES
('January Step Challenge', '2026-01-01', '2026-01-31'),
('Weekly Cardio Challenge', '2026-01-10', '2026-01-17');


--   USER_DEVICES  -------------------------
INSERT INTO user_devices (user_id, device_id)
VALUES
(1, 1),
(2, 2),
(3, 1);

--   USER_SUBSCRIPTIONS  --------------------
INSERT INTO user_subscriptions (user_id, subscription_id, start_date, end_date)
VALUES
(1, 2, '2026-01-01', '2026-12-31'),
(2, 1, '2026-01-05', NULL),
(3, 2, '2026-01-10', '2026-12-31');

--   PLAN FEATURES  -----------------------
INSERT INTO plan_features (subscription_id, feature_id)
VALUES
(2, 1),
(2, 2),
(2, 3);

--   USER_CHALLENGES  ---------------------
INSERT INTO user_challenges (user_id, challenge_id, joined_date)
VALUES
(1, 1, '2026-01-02'),
(1, 2, '2026-01-10'),
(2, 1, '2026-01-03'),
(3, 2, '2026-01-11');

--   USER_BADGES  -------------------------
INSERT INTO user_badges (user_id, badge_id, awarded_date)
VALUES
(1, 1, '2026-01-15'),
(3, 2, '2026-01-16');

-- WORKOUT_LOGS  -------------------------
INSERT INTO workout_logs (user_id, workout_date, duration_minutes, calories_burned)
VALUES
(1, '2026-01-18', 45, 358),
(1, '2026-01-19', 30, 270),
(2, '2026-01-18', 20, 186),
(3, '2026-01-19', 60, 500);

--   WORKOUT_EXERCISES  ---------------------
INSERT INTO workout_exercises(workout_id, exercise_id, sets, reps, duration_minutes)
VALUES
-- Strength exercises
(1, 1, 3, 15, NULL),  -- push_ups
(1, 3, 3, 20, NULL),  -- squats
(2, 3, 1, 20, NULL),   -- squats
(4, 1, 1, 10, NUll),   -- push_ups

-- Cardio Exercises
(2, 2, 1, NULL, 30),  -- running
(4, 4, 1, NULL, 15);  -- yoga

--   ACTIVITY_LOG  --------------------------
INSERT INTO activity_logs (user_id, user_device_id, activity_date, steps, calories_burned)
VALUES
(1, 1, CURDATE(), 12000, 500),
(2, 2, CURDATE(), 6000, 300),
(3, 1, CURDATE(), 9000, 400);

--   HEART_RATE_LOGS  ----------------------
INSERT INTO heart_rate_logs (user_id, user_device_id, recorded_at, heart_rate)
VALUES
(1, 1, NOW(), 78),
(1, 1, NOW(), 145),
(2, 2, NOW(), 82),
(3, 1, NOW(), 160);


--   SLEEP_LOGS  -------------------------
INSERT INTO sleep_logs(user_id, user_device_id, sleep_date, sleep_hours)
VALUES
(1, 1, '2026-01-18', 7.5),
(2, 1, '2026-01-18', 6.0),
(3, 1, '2026-01-18', 8.0);

select * from sleep_logs;
--   NUTRITION_LOGS  ---------------------
INSERT INTO nutrition_logs (user_id, logged_at, calories)
VALUES
(1, NOW(), 2200),
(2, NOW(), 1800),
(3, NOW(), 2500);

--   FITNESS_RECOMMENDATIONS  ---------------
INSERT INTO fitness_recommendations (user_id, recommendation_type, message)
VALUES
(1, 'Workout', 'Increase cardio to burn fat'),
(2, 'Hydration', 'Drink more water today'),
(3, 'Sleep', 'Aim for at least 7 hours of sleep');

--   EMERGENCY_ALERTS  ------------------------
INSERT INTO emergency_alerts(user_id, hr_id, alert_type, severity)
VALUES
(3, 4, 'High Heart Rate', 'High');



-- RELATION & INTEGRATION  ---------------------------


--    1USER - M.SUBSCRIPTION    --
SELECT u.name, s.plan_name, us.start_date, us.end_date
FROM users u 
JOIN user_subscriptions us ON u.user_id = us.user_id
JOIN subscriptions s ON us.subscription_id = s.subscription_id;

--   1SUBSCRIPTIONS - M.FEATURES   --
SELECT s.plan_name, f.feature_name
FROM subscriptions s 
JOIN plan_features pf ON s.subscription_id = pf.subscription_id
JOIN features f ON pf.feature_id = f.feature_id;

--   1USER - M.DEVICES - M.HEARTRATE
SELECT u.name, d.device_name, h.heart_rate, h.recorded_at
FROM heart_rate_logs h
JOIN users u ON h.user_id = u.user_id
JOIN user_devices ud ON h.user_device_id = ud.user_device_id
JOIN devices d ON ud.device_id = d.device_id;

--   EMERGENCY ALERT  --
SELECT u.name, h.heart_rate, e.alert_type, e.severity, e.triggered_at
FROM emergency_alerts e
JOIN heart_rate_logs h ON e.hr_id = h.hr_id
JOIN users u ON e.user_id = u.user_id;

--   WORKOUT FLEXIBILITY  --
Select e.exercise_name, we.sets, we.reps, we.duration_minutes
FROM workout_exercises we
JOIN exercises e ON we.exercise_id = e.exercise_id;

--   PERSONALISED RECOMMENDATIONS   --
SELECT u.name, fr.recommendation_type, fr.message
FROM fitness_recommendations fr
JOIN users u ON fr.user_id = u.user_id;

--  DAILY ACTIVITY DASHBOARD  --
SELECT u.name, a.activity_date, a.steps, a.calories_burned
FROM activity_logs a
JOIN users u ON a.user_id = u.user_id;

-- FITNESS DASHBOARD --
SELECT 
u.name,
COUNT(DISTINCT wl.workout_id) AS workouts,
SUM(a.steps) AS steps,
COUNT(DISTINCT ub.badge_id) AS badges
FROM users u
LEFT JOIN workout_logs wl ON u.user_id = wl.user_id
LEFT JOIN activity_logs a ON u.user_id = a.user_id
LEFT JOIN user_badges ub ON u.user_id = ub.user_id
GROUP BY u.name;


 
 -- TRIGGERS & STORED PROCEDURES  -----------------
 
 
 -- AUTO-AWARD BADGE ON 10000 STEPS COMPLETION --
 DELIMITER $$
 
 CREATE TRIGGER trg_award_10k_steps_badge
 AFTER INSERT ON activity_logs
 FOR EACH ROW
 BEGIN
       DECLARE badgeId INT;
       
       -- Get badge_id
       SELECT badge_id INTO badgeId
       FROM badges
       WHERE badge_name = '10K Steps Badges';
       
       -- award badge if steps >= 10000 and not already awarded
       IF NEW.steps >= 10000 AND
       NOT EXISTS (
			SELECT 1 FROM user_badges
            WHERE user_id = NEW.user_id
            AND badge_id = badgeId
            )
		THEN
            INSERT INTO user_badges(user_id, badge_id, awarded_date)
            VALUES(NEW.user_id, badgeId, CURDATE());
        END IF;
END$$

DELIMITER ;        
       
       
--  ABNORMAL HEART-RATE AS EMERGENCY ALERT  --
DELIMITER $$

CREATE TRIGGER trg_heart_rate_emergency
AFTER INSERT ON heart_rate_logs
FOR EACH ROW
BEGIN
     IF NEW.heart_rate > 150 THEN 
        INSERT INTO emergency_alerts (
        user_id,
        hr_id,
        alert_type,
        severity,
        triggered_at,
        status
        )
        VALUES (
                NEW.user_id,
                NEW.hr_id,
                'High Heart Rate',
                'HIGH',
                NOW(),
                'ACTIVE'
			);
		END IF;
	END$$
    
DELIMITER ;
    

-- STORED PROCEDURE: INACTIVE USER REMINDER --
DELIMITER $$

CREATE PROCEDURE sp_inactivity_reminder()
BEGIN 
	INSERT INTO fitness_recommendations(
    user_id,
    recommendation_type,
    message,
    generated_at
)
SELECT
	u.user_id,
    'Inactivity Reminder',
    'You have not logged any activity in the last 3 days.Let''s get moving!',
    NOW()
 FROM users u
 WHERE
       NOT EXISTS (
       SELECT 1
       FROM activity_logs a 
       WHERE a.user_id = u.user_id
       AND a.activity_date >= CURDATE() - INTERVAL 3 DAY
	)
       AND NOT EXISTS(
		   SELECT 1
           FROM fitness_recommendations fr
           WHERE fr.user_id = u.user_id
           AND fr.recommendation_type = 'Inactivity Reminder'
           AND DATE (fr.generated_at) = CURDATE()
	);
END$$

DELIMITER ;

-- INDEXES --

-- ACTIVITY LOGS --
CREATE INDEX idx_activity_user_date 
ON activity_logs(user_id, activity_date);

-- HEART-RATE LOGS --
CREATE INDEX idx_hr_user_time
ON heart_rate_logs(user_id, recorded_at);

-- WORKOUT LOGS --
CREATE INDEX idx_workout_user_date
ON workout_logs(user_id, workout_date);

-- USER SUBSCRIPTION --
CREATE INDEX idx_subscription_end
ON user_subscriptions(end_date);
      
  
--  VIEW  --

-- DAILY ACTIVITY --
CREATE VIEW vw_daily_activity AS
SELECT
u.user_id,
u.name,
a.activity_date,
a.steps,
a.calories_burned
FROM activity_logs a
JOIN users u ON a.user_id = u.user_id;

-- HEALTH MONITORING --
CREATE VIEW vw_health_monitoring AS
SELECT 
u.name,
h.heart_rate,
h.recorded_at,
e.alert_type,
e.severity
FROM heart_rate_logs h
LEFT JOIN emergency_alerts e ON h.hr_id = e.hr_id
JOIN users u on h.user_id = u.user_id;



-- TASK QUERIES  --------


--  DATA RETRIEVAL  --

-- 1.LIST ALL USERS  --
SELECT * FROM users;
 
 -- 2.USER WITH ACTIVE SUBSCRIPTIONS  --
 SELECT u.name, s.plan_name
 FROM users u 
 JOIN user_subscriptions us ON u.user_id = us.user_id
 JOIN subscriptions s ON us.subscription_id = s.subscription_id
 WHERE us.end_date >= CURDATE();
 
 --  3.USERS WITHOUT SUBSCRIPTIONS  --
 SELECT u.name 
 FROM users u
 LEFT JOIN user_subscriptions us ON u.user_id = us.user_id
 WHERE us.user_id IS NULL;
 
 --  4. DEVICES USED BY EACH USER  --
 SELECT u.name, d.device_name
 FROM users u 
 JOIN user_devices ud ON u.user_id = ud.user_id
 JOIN devices d ON ud.device_id = d.device_id;
 
 
 
 -- ACTIVITY & WORKOUT ANALYSIS  --
 
 --  5.USERS INACTIVE FOR LAST 7 DAYS  --
 SELECT u.name
 FROM users u
 LEFT JOIN activity_logs a
 ON u.user_id = a.user_id
 AND a.activity_date >= CURDATE()  - INTERVAL 7 DAY
 WHERE a.user_id IS NULL;
 
 --  6.MOST POPULAR WORKOUT (by count)
SELECT 
e.exercise_name,
COUNT(*) AS total_logs
FROM workout_exercises we
JOIN exercises e on we.exercise_id = e.exercise_id 
GROUP BY e.exercise_name
ORDER BY total_logs DESC
LIMIT 1;

--  7 AVERAGE HEART RATE PER USER(LAST 24HRS)  --
SELECT u.name, AVG(h.heart_rate) AS avg_hr
FROM heart_rate_logs h
JOIN users u ON h.user_id = u.user_id
WHERE h.recorded_at >= NOW() - INTERVAL 1 DAY 
GROUP BY u.name;

--  8.CALORIESS BURNED  PER USER  --
SELECT u.name, SUM(a.calories_burned) AS total_calories
FROM activity_logs a
JOIN users u ON a.user_id = u.user_id
GROUP by u.name;
 
 

 -- SUBSCRIPTIONS & FEATURES  --
 
 -- 9. SUBSCRIPTION REVENUE PER PLAN  --
 SELECT s.plan_name, COUNT(us.user_id) AS users_count
 FROM subscriptions s
 JOIN user_subscriptions us ON s.subscription_id = us.subscription_id
 GROUP BY s.plan_name;
 
 -- 10. USERS WITH PREMIUM FEATURES  --
 SELECT DISTINCT u.name
 FROM users u
 JOIN user_subscriptions us ON u.user_id = us.user_id
 JOIN subscriptions s ON us.subscription_id = s.subscription_id
 WHERE s.plan_name = 'Premium';
 
 
 -- NUTRITION & HEALTH  --
 
 --  11. DAILY CALORIE INTEKE PER USER  --
 SELECT u.name, n.logged_at, SUM(n.calories) AS total_intake
 FROM nutrition_logs n
 JOIN users u ON n.user_id = u.user_id
 GROUP BY u.name, n.logged_at;
 
 -- 12. USERS EXCEEDING CALORIE LIMIT  --
 SELECT u.name, SUM(n.calories) AS total
 FROM nutrition_logs n
 JOIN users u ON n.user_id = u.user_id
 GROUP BY u.name, DATE(n.logged_at);
 
 
--  EMERGENCY & SAFETY  --
 
 -- 13. EMERGENCY ALERTS PER USER  --
 SELECT u.name, COUNT(*) AS alert_count
 FROM emergency_alerts e
 JOIN users u ON e.user_id = u.user_id
 GROUP BY u.name;
 
 -- 14. HIGH SEVERITY ALERTS  --
  SELECT * FROM emergency_alerts
  where severity = 'HIGH';
  
-- CHALLENEGES & BADGES  --

--  15. COMPLETED CHALLENGES PER USER --
SELECT u.name, COUNT(*) AS completed
FROM user_challenges uc
JOIN users u ON uc.user_id = u.user_id
WHERE uc.status = 'COMPLETED'
GROUP BY u.name;

-- 16. BADGES EARNED BY USERS  --
SELECT u.name, b.badge_name
FROM user_badges ub
JOIN users u ON ub.user_id = u.user_id
JOIN badges b ON ub.badge_id = b.badge_id;

-- AUTOMATION/REPORTING  --

--  17. MONTHLY ACTIVITY SUMMARY  --
SELECT user_id, MONTH(activity_date) AS month,
SUM(steps) AS total_steps
FROM activity_logs
GROUP BY user_id, month;

-- 18. USERS NEARING SUBSCRIPTION EXPIRY (7DAYS PRIOR)  --
SELECT u.name, us.end_date
FROM user_subscriptions us
JOIN users u ON us.user_id = u.user_id
WHERE us.end_date BETWEEN CURDATE() AND CURDATE() + INTERVAL 7 DAY;

-- 19. AVERAGE WORKOUT DURATION PER USER  --
SELECT u.name, AVG(wl.duration_minutes) AS avg_duration
FROM workout_logs wl
JOIN users u ON wl.user_id = u.user_id
GROUP BY u.name;



-- ADVANCDED --

-- 20. AVERAGE WORKOUT DURATION PER USER --
SELECT u.name, COUNT(*) AS device_count
FROM user_devices ud
JOIN users u ON ud.user_id = u.user_id
GROUP BY u.name
HAVING device_count >= 1;

-- 21. MOST USED DEVICE  --
SELECT d.device_name, COUNT(*) AS usage_count
FROM user_devices ud
JOIN devices d ON ud.device_id = d.device_id
GROUP BY d.device_name
ORDER BY usage_count DESC
LIMIT 1;

-- 22. USERS WITH NO WORKOUTS --
SELECT u.name
FROM users u
LEFT JOIN workout_logs wl ON u.user_id = wl.user_id
WHERE wl.user_id IS NULL;

-- 23. WORKOUT COUNT PER USER --
SELECT u.name, COUNT(*) AS workouts
FROM workout_logs wl
JOIN users u ON wl.user_id = u.user_id
GROUP BY u.name;
 
 -- 24. MOST ACTIVE USER --
 SELECT u.name, SUM(a.steps) as total_steps
 FROM activity_logs a 
 JOIN users u ON a.user_id = u.user_id
 GROUP BY u.name
 ORDER BY total_steps DESC
 LIMIT 1;
 
 -- 25. MONTHLY FITNESS REPORT --
 SELECT u.name,
 SUM(a.steps) AS steps,
 SUM(a.calories_burned) AS calories
 FROM users u
 JOIN activity_logs a ON u.user_id = a.user_id
 WHERE MONTH (a.activity_date) = MONTH(CURDATE())
 GROUP BY u.name;
 

  
 
 
 





