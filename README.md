# BrightTV Viewership Analytics


## Overview

This project presents an end-to-end analysis of BrightTV's user profiles and viewership data to support the CEO's objective of growing the subscription base. The analysis focuses on understanding user behaviour, content consumption patterns, and engagement drivers to provide actionable insights for the Customer Value Management (CVM) team.


## Project Objectives
- What are the key user and viewership trends?
- Which factors influence content consumption?
- What content strategies can increase engagement on low-activity days?
- What initiatives can drive user growth and retention?
- ho are the female viewers and how do we reach underserved segments?


## How the Case Study Was Conducted

### 1. Data Ingestion & Setup

- Loaded raw datasets into Databricks (Lakehouse environment)
- Combined two primary data sources:
- User Profile Data — demographics, location, race, gender
- Viewership Data — sessions, channels, timestamps, duration

### 2. Data Cleaning & Quality Checks

- Handled NULL values by replacing them with meaningful category flags
- Validated and standardised categorical fields (Province, Race, Gender, Channel)
- Converted timestamps from UTC to South African Standard Time (SAST / GMT+2)
- Cleaned and transformed session duration into usable numeric format

### 3. Feature Engineering

- Created analytical features using Spark SQL to enhance insights:
- Time-Based Features
- Day of week, Month, Viewing Hour
- Time buckets — Morning (05–11h), Afternoon (12–16h), Evening (17–20h), Night (else)
- Weekday vs Weekend classification
- Channel category grouping — News, Sports, Music, Kids, Entertainment
- Engagement category — Brief View (0–1 min), Short Watch (2–15 min), Mid-Length (16–45 min), Long Watch (46–120 min), Extended Watch (120+ min)
- Age group segmentation — Children, Teens, Young Adults, Middle-Aged, Older Adults, Seniors
- Gender and race-based audience composition

### 4. Exploratory Data Analysis (EDA)

Used SQL to analyse:

- User engagement trends over time — daily, weekly, monthly
- Content consumption by channel and genre
- Viewing behaviour across time buckets
- Demographic analysis — age, gender, race, province
- Peak viewing hours and low-consumption day patterns
- Female audience composition and underserved segments by race group


### 5. Data Visualisation & Reporting

- Visualised key metrics including user growth trends, engagement patterns by time of day, channel performance, demographic distribution, and female viewership segmentation.

# Key Insights: 

#### User & Engagement

- 5,375 unique subscribers across 10,989 sessions — average session 8.7 minutes
- Young Adults (20–34) make up 50% of all sessions; 80% of sessions are from male subscribers

#### Time-Based

- Peak consumption occurs in the afternoon (12:00–18:00)
- Saturday is the highest day; Monday the lowest (23% below weekly average)
- March saw a 116% spike in viewing minutes driven by ICC Cricket World Cup

#### Content Performance

- Sports dominates at 54% of all viewing time; Music second at 25%
- ICC Cricket World Cup and Supersport Live Events are the top channels by total minutes
- 47% of sessions are brief views under 1 minute — high churn at the top of the funnel

#### Demographic
- Gauteng leads with 1,704 unique subscribers (32% of identified users)
- Black women make up 59.4% of the female audience — the largest female group
- Indian/Asian women are the most underserved at 5.9% female share within their group, despite Indian/Asian men being the longest-watching group on the platform (13.2 min avg)


# Recommendations

#### Content Strategy

- Secure exclusive live sports rights — every major event is a subscriber acquisition window
- Introduce female-targeted content (local drama, Bollywood, reality TV, lifestyle) to address the 10% female viewership share
- Programme Monday and Sunday deliberately — music and short-form on Mondays, family and sports content on Sundays


#### Engagement Optimisation


- Send personalised push notifications during the 12:00–18:00 peak window to convert brief viewers
- Create binge-worthy content blocks and marathon weekends to increase session duration
- Implement watch streaks or rewards systems to improve retention


#### User Growth Strategy


- Target Mpumalanga and Limpopo with localised content — strong engagement but low subscriber counts
- Launch a dedicated South Asian content block to reach Indian/Asian women
- Introduce a Youth tier with gaming, animation, and eSports for the teen segment


#### Retention Strategy


- Use CVM micro-segmentation: Sports Males 20–49, Music Youth, Kids Parents, News Professionals, Female Entertainment
- Monitor low-session users as early churn risk and intervene with targeted campaigns
- Run a profile completion campaign — 16.6% of sessions have incomplete demographic data, limiting personalisation



### Tools Used
- atabricks (Spark SQL)
- Microsoft Excel (Pivot Tables & Charts)
- Microsoft PowerPoint
- Miro (Flow Diagram)
- Canva (Gantt Chart)
- GitHub
