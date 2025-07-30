
-- The Effects of Social Media on Mental Health
-- ===========================================

-- Step 1: Data Cleaning and Preparation
WITH survey AS (
  SELECT
    Timestamp,
    CASE 
      WHEN [_2__Gender] = 'Female' THEN 'female'
      WHEN [_2__Gender] = 'Male' THEN 'male'
      ELSE 'other' 
    END AS gender,
    CAST([_1__What_is_your_age_] AS INT) AS age,
    [_3__Relationship_Status] AS relationship,
    [_4__Occupation_Status] AS occupation,
    [_6__Do_you_use_social_media_] AS use_social_media,
    [_7__What_social_media_platforms_do_you_commonly_use_] AS platforms,
    [_8__What_is_the_average_time_you_spend_on_social_media_every_day_] AS time_online,
    [_9__How_often_do_you_find_yourself_using_Social_media_without_a_specific_purpose_] AS purposeless_scrolling,
    [_10__How_often_do_you_get_distracted_by_Social_media_when_you_are_busy_doing_something_] AS often_distracted,
    [_11__Do_you_feel_restless_if_you_haven_t_used_Social_media_in_a_while_] AS restless,
    [_12__On_a_scale_of_1_to_5__how_easily_distracted_are_you_] AS how_distracted,
    [_13__On_a_scale_of_1_to_5__how_much_are_you_bothered_by_worries_] AS worried,
    [_14__Do_you_find_it_difficult_to_concentrate_on_things_] AS difficulty_concentrating,
    [_15__On_a_scale_of_1_5__how_often_do_you_compare_yourself_to_other_successful_people_through_the_use_of_social_media_] AS compare,
    [_17__How_often_do_you_look_to_seek_validation_from_features_of_social_media_] AS seek_validation,
    [_18__How_often_do_you_feel_depressed_or_down_] AS often_depressed,
    [_19__On_a_scale_of_1_to_5__how_frequently_does_your_interest_in_daily_activities_fluctuate_] AS daily_interest,
    [_20__On_a_scale_of_1_to_5__how_often_do_you_face_issues_regarding_sleep_] AS sleep_problems,

    -- Platform flags
    CASE WHEN LOWER([_7__What_social_media_platforms_do_you_commonly_use_]) LIKE '%tiktok%' THEN 1 ELSE 0 END AS use_tiktok,
    CASE WHEN LOWER([_7__What_social_media_platforms_do_you_commonly_use_]) LIKE '%facebook%' THEN 1 ELSE 0 END AS use_facebook,
    CASE WHEN LOWER([_7__What_social_media_platforms_do_you_commonly_use_]) LIKE '%twitter%' THEN 1 ELSE 0 END AS use_twitter,
    CASE WHEN LOWER([_7__What_social_media_platforms_do_you_commonly_use_]) LIKE '%pinterest%' THEN 1 ELSE 0 END AS use_pinterest,
    CASE WHEN LOWER([_7__What_social_media_platforms_do_you_commonly_use_]) LIKE '%snapchat%' THEN 1 ELSE 0 END AS use_snapchat,
    CASE WHEN LOWER([_7__What_social_media_platforms_do_you_commonly_use_]) LIKE '%discord%' THEN 1 ELSE 0 END AS use_discord,
    CASE WHEN LOWER([_7__What_social_media_platforms_do_you_commonly_use_]) LIKE '%instagram%' THEN 1 ELSE 0 END AS use_instagram,
    CASE WHEN LOWER([_7__What_social_media_platforms_do_you_commonly_use_]) LIKE '%youtube%' THEN 1 ELSE 0 END AS use_youtube,
    CASE WHEN LOWER([_7__What_social_media_platforms_do_you_commonly_use_]) LIKE '%reddit%' THEN 1 ELSE 0 END AS use_reddit
  FROM social_media_survey
)
SELECT * FROM survey;

-- Question 1: Correlation between Age and Time Online
WITH time_online_correlation AS (
  SELECT
    age,
    CASE 
      WHEN time_online = 'More than 5 hours' THEN 6
      WHEN time_online = 'Between 4 and 5 hours' THEN 5
      WHEN time_online = 'Between 3 and 4 hours' THEN 4
      WHEN time_online = 'Between 2 and 3 hours' THEN 3
      WHEN time_online = 'Between 1 and 2 hours' THEN 2
      ELSE 1
    END AS time_on_sm
  FROM survey
)
-- Use correlation via external tool; MSSQL doesn't support CORR()
SELECT 
  AVG(CAST(age AS FLOAT)) AS avg_age,
  AVG(CAST(time_on_sm AS FLOAT)) AS avg_time_online
FROM time_online_correlation;

-- Question 2: Social Media Platform Usage
SELECT
  ROUND(SUM(use_tiktok) * 100.0 / COUNT(*), 2) AS tiktok_percentage,
  ROUND(SUM(use_facebook) * 100.0 / COUNT(*), 2) AS facebook_percentage,
  ROUND(SUM(use_twitter) * 100.0 / COUNT(*), 2) AS twitter_percentage,
  ROUND(SUM(use_pinterest) * 100.0 / COUNT(*), 2) AS pinterest_percentage,
  ROUND(SUM(use_snapchat) * 100.0 / COUNT(*), 2) AS snapchat_percentage,
  ROUND(SUM(use_discord) * 100.0 / COUNT(*), 2) AS discord_percentage,
  ROUND(SUM(use_instagram) * 100.0 / COUNT(*), 2) AS instagram_percentage,
  ROUND(SUM(use_youtube) * 100.0 / COUNT(*), 2) AS youtube_percentage
FROM survey;

-- Question 3: Mental Health Trends by Time Online
SELECT 
  time_online,
  AVG(CAST((purposeless_scrolling + often_distracted + how_distracted + difficulty_concentrating) / 4.0 AS FLOAT)) AS adhd_mean,
  AVG(CAST((restless + worried) / 2.0 AS FLOAT)) AS anxiety_mean,
  AVG(CAST((often_depressed + daily_interest + sleep_problems) / 3.0 AS FLOAT)) AS depression_mean,
  AVG(CAST((compare + seek_validation) / 2.0 AS FLOAT)) AS self_esteem_mean
FROM survey
GROUP BY time_online
ORDER BY 
  CASE 
    WHEN time_online = 'Less than an Hour' THEN 1
    WHEN time_online = 'Between 1 and 2 hours' THEN 2
    WHEN time_online = 'Between 2 and 3 hours' THEN 3
    WHEN time_online = 'Between 3 and 4 hours' THEN 4
    WHEN time_online = 'Between 4 and 5 hours' THEN 5
    WHEN time_online = 'More than 5 hours' THEN 6
  END;

-- Question 4: Most Common Time Online by Relationship Group
WITH ranked_times AS (
  SELECT 
    relationship,
    time_online,
    ROW_NUMBER() OVER (PARTITION BY relationship ORDER BY COUNT(*) DESC) AS row_num
  FROM survey
  GROUP BY relationship, time_online
)
SELECT 
  relationship,
  time_online AS most_common_time_online
FROM ranked_times
WHERE row_num = 1;
