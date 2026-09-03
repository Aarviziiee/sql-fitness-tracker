SQL Fitness Tracker

A relational database design for a fitness-tracking platform — built to model real usage patterns of a fitness app: workouts, wearable device data, subscriptions, health safety alerts, and progress tracking.



What it models

The schema covers a fitness platform end-to-end, not just workout logging:

Users & devices — user profiles, connected wearables, and the device history per user
Activity tracking — daily steps, calories, workouts, exercises performed (sets/reps or duration-based)
Health monitoring — heart rate logs and automatic emergency alerts when readings exceed a safe threshold
Sleep & nutrition logs
Engagement — challenges, badges, and personalized fitness recommendations
Business layer — subscription plans, plan features, and premium-tier access

18 tables in total, split into independent entities (users, devices, exercises), join/dependent tables (workout_exercises, user_subscriptions, plan_features), and log/event tables (activity_logs, heart_rate_logs, emergency_alerts).

Key design features
Trigger — emergency_alerts are inserted automatically whenever a heart rate reading exceeds 150 bpm, without any application-level code needed
Stored procedure — sp_inactivity_reminder() scans for users with no logged activity in 3 days and generates a reminder, skipping anyone already reminded that day
2 views — vw_daily_activity and vw_health_monitoring for simplified reporting
4 indexes on frequently filtered columns (user + date lookups) for query performance
Data integrity — CHECK constraints on numeric fields (steps, heart rate, calories), ON DELETE CASCADE/RESTRICT chosen deliberately per relationship (e.g. deleting a user cascades to their logs, but not to shared reference data like devices or exercises)
Example queries

The project includes 25 analytical queries. A few examples:

sql
-- Users inactive for the last 7 days
SELECT u.name
FROM users u
LEFT JOIN activity_logs a
  ON u.user_id = a.user_id AND a.activity_date >= CURDATE() - INTERVAL 7 DAY
WHERE a.user_id IS NULL;

-- Users nearing subscription expiry (7 days out)
SELECT u.name, us.end_date
FROM user_subscriptions us
JOIN users u ON us.user_id = u.user_id
WHERE us.end_date BETWEEN CURDATE() AND CURDATE() + INTERVAL 7 DAY;

-- High-severity emergency alerts
SELECT * FROM emergency_alerts WHERE severity = 'HIGH';

Full query set is in FINAL_PROJECT(FITNESS_TRACKER).sql, organized by category: data retrieval, activity/workout analysis, subscriptions, nutrition, emergency alerts, and reporting.

Tech

MySQL

Files
FINAL_PROJECT(FITNESS_TRACKER).sql — full schema, triggers, procedure, views, indexes, and queries
FITNESSTRACKER_ERDIAGRAM.png — entity-relationship diagram
Fitness Tracker Database Management System.pdf — design documentation
