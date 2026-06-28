-- ==========================================================================================================================================================================================
-- PROJECT: BrightTV Viewership Analysis
-- PHASE: Data Exploration & Data Cleaning (EDA)
-- DESCRIPTION: Standardizing missing values, adjusting timezones to SAST, merging datasets, 
--              and formatting date/time features for analysis.
-- ============================================================================================================================================================================================

-- ----------------------------------------------------------------------------------------------
-- STEP 1: Initial Data Inspection
-- ----------------------------------------------------------------------------------------------
-- Preview user profile schema and records
SELECT * FROM `workspace`.`default`.`bright_tv_user_profiles`
LIMIT 100;

-- Preview viewership behavior metrics
SELECT *
FROM `workspace`.`default`.`bright_tv_viewership`
LIMIT 100;

-- ----------------------------------------------------------------------------------------------
-- STEP 2: Standardizing Missing Values (Handling Hidden Text Constraints)
-- ----------------------------------------------------------------------------------------------
-- Investigation revealed that 'None' text strings and blank spaces (' ') exist where data 
-- was unrecorded. Converting these to true database NULLs ensures computational accuracy.

-- Convert 'None' strings to NULL
UPDATE `workspace`.`default`.`bright_tv_user_profiles`
SET 
    Name = NULLIF(BTRIM(Name), 'None'),
    Surname = NULLIF(BTRIM(Surname), 'None'),
    Email = NULLIF(BTRIM(Email), 'None'),
    Gender = NULLIF(BTRIM(Gender), 'None'),
    Race = NULLIF(BTRIM(Race), 'None'),
    Province = NULLIF(BTRIM(Province), 'None'),
    `Social Media Handle` = NULLIF(BTRIM(`Social Media Handle`), 'None');

-- Convert empty/blank text spaces to NULL
UPDATE `workspace`.`default`.`bright_tv_user_profiles`
SET 
    Name = NULLIF(TRIM(Name), ''),
    Surname = NULLIF(TRIM(Surname), ''),
    Email = NULLIF(TRIM(Email), ''),
    Gender = NULLIF(TRIM(Gender), ''),
    Race = NULLIF(TRIM(Race), ''),
    Province = NULLIF(TRIM(Province), ''),
    `Social Media Handle` = NULLIF(TRIM(`Social Media Handle`), '');

-- ----------------------------------------------------------------------------------------------
-- STEP 3: Localization (Converting UTC to South African Standard Time)
-- ----------------------------------------------------------------------------------------------

---3. Converting UTC time to SA time
---South African Standard Time (SAST) is exactly 2 hours ahead of Coordinated Universal Time (UTC)

--Alter the main table / adding blank column 
ALTER TABLE `workspace`.`default`.`bright_tv_viewership` 
ADD COLUMNS (RecordDate2_SAST TIMESTAMP);

--Convert and permanently save the SAST data
UPDATE `workspace`.`default`.`bright_tv_viewership`
SET RecordDate2_SAST = from_utc_timestamp(RecordDate2, 'Africa/Johannesburg');

-- Drop the original UTC column
ALTER TABLE `workspace`.`default`.`bright_tv_viewership` 
DROP COLUMN RecordDate2;

-- ----------------------------------------------------------------------------------------------
-- STEP 4: Data Consolidation (Full Outer Integration via Coalesce)
-- ----------------------------------------------------------------------------------------------
-- Merging demographics and behavioral data streams without losing orphan nodes on either side.

CREATE OR REPLACE TABLE workspace.default.BrightTV_Combined AS
SELECT 
    COALESCE(A.UserID, B.UserID) AS UserID,
    A.`Duration 2` AS Duration2,
    A.RecordDate2_SAST,
    A.Channel2,
    B.Gender,
    B.Race,
    B.Age,
    B.Province
FROM `workspace`.`default`.`bright_tv_viewership` AS A
FULL OUTER JOIN `workspace`.`default`.`bright_tv_user_profiles` AS B
    ON A.UserID = B.UserID;

---Checking the combined table 
SELECT *
FROM workspace.default.BrightTV_Combined; 


-- ----------------------------------------------------------------------------------------------
-- STEP 5: Exploratory Data Profiling 
-- ----------------------------------------------------------------------------------------------

Select count(Distinct(UserID)) AS Number_of_records ---5375 unique UserIDs / Profiles 
from `workspace`.`default`.`BrightTV_Combined`;

Select Distinct(Channel2) --21 Channels, 1 Null
from `workspace`.`default`.`BrightTV_Combined`;

Select Distinct(Race) --6 races , 1 Null
from `workspace`.`default`.`BrightTV_Combined`;

Select Distinct(Age) --71 different ages 
from `workspace`.`default`.`BrightTV_Combined`;

Select Distinct(Province) --9 provinces , 1 Null
from `workspace`.`default`.`BrightTV_Combined`;

--- Checking Age min and Max 
Select min(age) AS minimum_age  --min = 0
from `workspace`.`default`.`BrightTV_Combined`;

Select max(age) AS maximum_age  --max = 114
from `workspace`.`default`.`BrightTV_Combined`;


-- ----------------------------------------------------------------------------------------------
-- STEP 6: Feature Extraction & Formatted Output Views
-- ----------------------------------------------------------------------------------------------
-- Handling NULL Values 

UPDATE `workspace`.`default`.`BrightTV_Combined`
SET 
    Channel2 = IFNULL(Channel2, 'Channel_Missing'),
    Gender   = IFNULL(Gender, 'Gender_Missing'),
    Race     = IFNULL(Race, 'Race_Missing'),
    Province = IFNULL(Province, 'Province_Missing');

--Splitting record date into a date and time columns

   select RecordDate2_SAST,                                             
    --  Extracting just the Date (YYYY-MM-DD)
    CAST(RecordDate2_SAST AS DATE) AS Viewing_Date,
    --  Extracting just the Time (HH:MM:SS)
   DATE_FORMAT(RecordDate2_SAST, 'HH:mm:ss') AS Viewing_Time
FROM `workspace`.`default`.`BrightTV_Combined`;

 --Extracting the specific duration
       
SELECT Duration2,
    -- Extracts just the HH:mm:ss from the default base date timestamp
    DATE_FORMAT(Duration2, 'HH:mm:ss') AS Duration
    
FROM `workspace`.`default`.`BrightTV_Combined`;
