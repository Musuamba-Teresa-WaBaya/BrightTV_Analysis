

-- ===================================================================================================
-- PROJECT PHASE: Exploratory Data Analysis (EDA) & Feature Engineering
-- DESCRIPTION: Following the completion of data ingestion and cleaning, the core Viewership data 
--              and demographic User Profiles were merged using a FULL OUTER JOIN. 
--              
--              With the resulting master dataset ('BrightTV_Combined') finalized, this stage focuses 
--              on audience segmentation and feature engineering.
--====================================================================================================
SELECT 
    UserID, 
    RecordDate2_SAST,
    
    -- Date extraction
    CASE 
        WHEN RecordDate2_SAST IS NULL THEN NULL 
        ELSE CAST(RecordDate2_SAST AS DATE) 
    END AS Viewing_Date,
    
    -- Weekday name extraction
    CASE 
        WHEN RecordDate2_SAST IS NULL THEN 'Day_Missing'
        ELSE DATE_FORMAT(RecordDate2_SAST, 'EEEE')
    END AS Day_of_Week,

    -- Weekday vs Weekend split
    CASE 
        WHEN RecordDate2_SAST IS NULL THEN 'Date_Missing'
        WHEN DATE_FORMAT(RecordDate2_SAST, 'EEEE') IN ('Saturday', 'Sunday') THEN 'Weekend'
        ELSE 'Weekday'
    END AS Day_Classification,
    
    -- Month name extraction
    CASE 
        WHEN RecordDate2_SAST IS NULL THEN 'Date_Missing'
        ELSE DATE_FORMAT(RecordDate2_SAST, 'MMMM')
    END AS Viewing_Month,
    
    -- Timestamp string conversion
    CASE 
        WHEN RecordDate2_SAST IS NULL THEN 'Time_Missing'
        ELSE DATE_FORMAT(RecordDate2_SAST, 'HH:mm:ss') 
    END AS Viewing_Time,
    
    -- Peak viewing hour extraction
    CASE 
        WHEN RecordDate2_SAST IS NULL THEN 'Time_Missing'
        ELSE DATE_FORMAT(RecordDate2_SAST, 'HH')
    END AS Viewing_Hour,
    
    -- Broadcast day categorization
    CASE 
        WHEN RecordDate2_SAST IS NULL                 THEN 'Time_Missing'
        WHEN HOUR(RecordDate2_SAST) BETWEEN 5 AND 11  THEN 'Morning'
        WHEN HOUR(RecordDate2_SAST) BETWEEN 12 AND 16 THEN 'Afternoon'
        WHEN HOUR(RecordDate2_SAST) BETWEEN 17 AND 20 THEN 'Evening'
        ELSE 'Night'
    END AS Time_Category,

    Duration2,
    
-- Total watch time calculation in numbers
    CASE 
        WHEN Duration2 IS NULL THEN NULL 
        ELSE (HOUR(Duration2) * 60) + MINUTE(Duration2) 
    END AS Duration_Minutes, 
    
-- Watch length segmentation for filtering
    CASE 
        WHEN Duration2 IS NULL                                              THEN 'Duration_Missing'
        WHEN (HOUR(Duration2) * 60) + MINUTE(Duration2) BETWEEN 0 AND 1     THEN 'Brief View (0-1 min)'
        WHEN (HOUR(Duration2) * 60) + MINUTE(Duration2) BETWEEN 2 AND 15    THEN 'Short Watch (2-15 mins)'
        WHEN (HOUR(Duration2) * 60) + MINUTE(Duration2) BETWEEN 16 AND 45   THEN 'Mid-Length Watch (16-45 mins)'
        WHEN (HOUR(Duration2) * 60) + MINUTE(Duration2) BETWEEN 46 AND 120  THEN 'Long Watch (46-120 mins)'
        WHEN (HOUR(Duration2) * 60) + MINUTE(Duration2) > 120               THEN 'Extended Watch (120+ mins)'
        ELSE 'Duration_Missing'
    END AS Engagement_Category,

    Channel2,
    
    -- Content genre grouping
    CASE 
        WHEN Channel2 IN ('CNN', 'BBC', 'Sky News', 'eNCA') THEN 'News'
        WHEN Channel2 IN ('ESPN', 'SuperSport', 'Sky Sports', 'SuperSport Blitz', 'Supersport Live Events', 'ICC Cricket World Cup 2011') THEN 'Sports'
        WHEN Channel2 IN ('MTV', 'Channel O', 'Trace TV') THEN 'Music'
        WHEN Channel2 IN ('Cartoon Network', 'Disney', 'Nickelodeon', 'Boomerang') THEN 'Kids'
        WHEN Channel2 IN ('HBO', 'Netflix', 'M-Net', 'Showmax', 'Africa Magic', 'Vuzu', 'E! Entertainment', 'KykNet') THEN 'Entertainment'
        ELSE 'Channel_Missing'
    END AS Channel_Category, 


-- Raw numeric demographic field
    IFNULL(Age, -1) AS Age, 
    
    -- Life-stage demographic segmentation
    CASE 
        WHEN Age IS NULL            THEN 'Age_Missing'
        WHEN Age BETWEEN 0 AND 12   THEN 'Children (0-12 yrs)'
        WHEN Age BETWEEN 13 AND 19  THEN 'Teens (13-19 yrs)'
        WHEN Age BETWEEN 20 AND 34  THEN 'Young Adults (20-34 yrs)'
        WHEN Age BETWEEN 35 AND 49  THEN 'Middle-Aged (35-49 yrs)'
        WHEN Age BETWEEN 50 AND 64  THEN 'Older Adults (50-64 yrs)'
        WHEN Age BETWEEN 65 AND 114 THEN 'Seniors (65-114 yrs)'
        ELSE 'Age_Missing'
    END AS Age_Group,

    Race, 
    Gender, 
    Province 

FROM `workspace`.`default`.`BrightTV_Combined`;
