
-- ===================================================================================================
-- PROJECT PHASE: Exploratory Data Analysis (EDA) & Feature Engineering
-- DESCRIPTION: Following the completion of data ingestion and cleaning, the core Viewership data 
--              and demographic User Profiles were merged using a FULL OUTER JOIN. 
--              
--              With the resulting master dataset ('BrightTV_Combined') finalized, this stage focuses 
--              on audience segmentation and feature engineering. The script extracts critical datetime 
--              components and transforms continuous variables (time, age, duration) into high-value 
--              categorical segments optimized for viewership behavior dashboards. All remaining NULL 
--              values across non-string fields are explicitly handled.
-- ===================================================================================================

SELECT 
    UserID, 
    RecordDate2_SAST,
    
    -- 1. Date & Time Extractions (FIXED: Uses NULL for Date type to prevent casting errors)
    CASE 
        WHEN RecordDate2_SAST IS NULL THEN NULL 
        ELSE CAST(RecordDate2_SAST AS DATE) 
    END                                       AS Viewing_Date,
    
    CASE 
        WHEN RecordDate2_SAST IS NULL THEN 'Day_Missing'
        ELSE DATE_FORMAT(RecordDate2_SAST, 'EEEE')
    END                                       AS Day_of_Week,
    
    CASE 
        WHEN RecordDate2_SAST IS NULL THEN 'Time_Missing'
        ELSE DATE_FORMAT(RecordDate2_SAST, 'HH:mm:ss') 
    END                                       AS Viewing_Time,
    
    -- 2. Broadcast Daypart Segmentation
    CASE 
        WHEN RecordDate2_SAST IS NULL                 THEN 'Time_Missing'
        WHEN HOUR(RecordDate2_SAST) BETWEEN 5 AND 11  THEN 'Morning'
        WHEN HOUR(RecordDate2_SAST) BETWEEN 12 AND 16 THEN 'Afternoon'
        WHEN HOUR(RecordDate2_SAST) BETWEEN 17 AND 20 THEN 'Evening'
        ELSE 'Night'
    END AS Time_Category,

    -- 3. Duration & Engagement Tracking
    Duration2,
    -- Column 1: Numeric math column (Leaves missing rows blank/NULL so averages don't skew)
    CASE 
        WHEN Duration2 IS NULL THEN NULL 
        ELSE (HOUR(Duration2) * 60) + MINUTE(Duration2) 
    END                                       AS Duration_Minutes, 
    
    -- Column 2: Categorical text column (Explicitly labels missing fields for dashboard filters)
    CASE 
        WHEN Duration2 IS NULL                                 THEN 'Duration_Missing'
        WHEN (HOUR(Duration2) * 60) + MINUTE(Duration2) BETWEEN 0 AND 1    THEN 'Glancer'
        WHEN (HOUR(Duration2) * 60) + MINUTE(Duration2) BETWEEN 2 AND 15   THEN 'Casual Viewer'
        WHEN (HOUR(Duration2) * 60) + MINUTE(Duration2) BETWEEN 16 AND 45  THEN 'Standard Show'
        WHEN (HOUR(Duration2) * 60) + MINUTE(Duration2) BETWEEN 46 AND 120 THEN 'Feature Watcher'
        WHEN (HOUR(Duration2) * 60) + MINUTE(Duration2) > 120              THEN 'Heavy Binge Viewer'
        ELSE 'Duration_Missing'
    END AS Engagement_Category,

    -- 4. Content Categorization (Cleaned from Table Update)
    Channel2,
    CASE 
        WHEN Channel2 IN ('CNN', 'BBC', 'Sky News', 'eNCA') THEN 'News'
        WHEN Channel2 IN ('ESPN', 'SuperSport', 'Sky Sports', 'SuperSport Blitz', 'Supersport Live Events', 'ICC Cricket World Cup 2011') THEN 'Sports'
        WHEN Channel2 IN ('MTV', 'Channel O', 'Trace TV') THEN 'Music'
        WHEN Channel2 IN ('Cartoon Network', 'Disney', 'Nickelodeon', 'Boomerang') THEN 'Kids'
        WHEN Channel2 IN ('HBO', 'Netflix', 'M-Net', 'Showmax', 'Africa Magic', 'Vuzu', 'E! Entertainment', 'KykNet') THEN 'Entertainment'
        ELSE 'Channel_Missing'
    END AS Channel_Category, 

    -- 5. Demographic Segmentation (Safeguard for Numeric Age)
    IFNULL(Age, -1) AS Age, 
    CASE 
        WHEN Age IS NULL            THEN 'Age_Missing'
        WHEN Age BETWEEN 0 AND 12   THEN 'Children'
        WHEN Age BETWEEN 13 AND 19  THEN 'Teens'
        WHEN Age BETWEEN 20 AND 34  THEN 'Young Adults'
        WHEN Age BETWEEN 35 AND 49  THEN 'Middle-Aged'
        WHEN Age BETWEEN 50 AND 64  THEN 'Older Adults'
        WHEN Age BETWEEN 65 AND 114 THEN 'Seniors'
        ELSE 'Age_Missing'
    END AS Age_Group, 

    -- 6. Raw Profile Dimensions (Cleaned from Table Update)
    Race, 
    Gender, 
    Province 

FROM `workspace`.`default`.`BrightTV_Combined`;
FROM `workspace`.`default`.`BrightTV_Combined`;
