-- Create a new database for Project 2
CREATE DATABASE IF NOT EXISTS lagos_hospital;

-- ================================================
-- PROJECT 2: HOSPITAL PATIENT FLOW & RESOURCE 
-- ANALYSIS
-- IDA/3MTT Data Analysis Bootcamp — Capstone
-- Database: lagos_hospital
-- Table: hospital_patients
-- Rows: 59,950
-- Period: 2021 - 2023
-- ================================================

-- Disable strict mode
SET sql_mode = '';

-- Select database
USE lagos_hospital;


-- ================================================
-- Task 62 — Create hospital_patients table
-- ================================================

CREATE TABLE IF NOT EXISTS hospital_patients (
    patient_id          VARCHAR(20),
    age                 INT,
    gender              VARCHAR(10),
    state_of_origin     VARCHAR(50),
    department          VARCHAR(50),
    diagnosis           VARCHAR(100),
    admission_date      DATE,
    admission_time      TIME,
    discharge_date      DATE,
    length_of_stay_days INT,
    outcome             VARCHAR(50),
    insurance_type      VARCHAR(50),
    total_bill_ngn      DECIMAL(12,2),
    amount_paid_ngn     DECIMAL(12,2),
    attending_doctor_id VARCHAR(20),
    ward                VARCHAR(20),
    readmitted          VARCHAR(5)
);

-- Confirm successful import
USE lagos_hospital;
SELECT COUNT(*) AS total_rows FROM hospital_patients;

-- ================================================
-- Task 63 — Total admissions and average length 
-- of stay per department
-- ================================================

SELECT 
    department,
    COUNT(patient_id)                    AS total_admissions,
    ROUND(AVG(length_of_stay_days), 2)   AS avg_length_of_stay,
    MIN(length_of_stay_days)             AS min_stay,
    MAX(length_of_stay_days)             AS max_stay
FROM hospital_patients
GROUP BY department
ORDER BY total_admissions DESC;

-- ================================================
-- Task 64 — Monthly admissions trend with 
-- year-over-year comparison
-- ================================================

SELECT 
    YEAR(admission_date)        AS year,
    MONTH(admission_date)       AS month,
    COUNT(patient_id)           AS total_admissions,
    LAG(COUNT(patient_id)) OVER (
        PARTITION BY MONTH(admission_date) 
        ORDER BY YEAR(admission_date)
    )                           AS prev_year_admissions,
    ROUND(
        (COUNT(patient_id) - LAG(COUNT(patient_id)) OVER (
            PARTITION BY MONTH(admission_date) 
            ORDER BY YEAR(admission_date)
        )) * 100.0 / NULLIF(LAG(COUNT(patient_id)) OVER (
            PARTITION BY MONTH(admission_date) 
            ORDER BY YEAR(admission_date)
        ), 0), 2
    )                           AS yoy_growth_pct
FROM hospital_patients
GROUP BY year, month
ORDER BY year, month;

-- ================================================
-- Task 65 — Top 10 diagnoses by frequency
-- Shows most common reasons for admission
-- ================================================

SELECT 
    diagnosis,
    COUNT(patient_id)                       AS total_cases,
    ROUND(COUNT(patient_id) * 100.0 / 
          (SELECT COUNT(*) FROM hospital_patients), 2) 
                                            AS pct_of_total
FROM hospital_patients
GROUP BY diagnosis
ORDER BY total_cases DESC
LIMIT 10;

-- ================================================
-- Task 66 — Readmission rate per department
-- % of patients readmitted per department
-- ================================================

SELECT 
    department,
    COUNT(patient_id)                               AS total_patients,
    SUM(CASE WHEN readmitted = 'Yes' THEN 1 
        ELSE 0 END)                                 AS readmitted_patients,
    ROUND(
        SUM(CASE WHEN readmitted = 'Yes' THEN 1 
            ELSE 0 END) * 100.0 
        / COUNT(patient_id), 2
    )                                               AS readmission_rate_pct
FROM hospital_patients
GROUP BY department
ORDER BY readmission_rate_pct DESC;

-- ================================================
-- Task 67 — Revenue gap: total billed vs total 
-- collected per insurance type
-- ================================================

SELECT 
    insurance_type,
    ROUND(SUM(total_bill_ngn), 2)       AS total_billed,
    ROUND(SUM(amount_paid_ngn), 2)      AS total_collected,
    ROUND(SUM(total_bill_ngn) - 
          SUM(amount_paid_ngn), 2)      AS revenue_gap,
    ROUND(SUM(amount_paid_ngn) * 100.0 
          / SUM(total_bill_ngn), 2)     AS collection_rate_pct
FROM hospital_patients
GROUP BY insurance_type
ORDER BY revenue_gap DESC;


-- ================================================
-- Task 68 — Peak admission hours
-- Admissions grouped by hour of day
-- ================================================

SELECT 
    HOUR(admission_time)        AS hour_of_day,
    COUNT(patient_id)           AS total_admissions,
    ROUND(COUNT(patient_id) * 100.0 / 
          (SELECT COUNT(*) FROM hospital_patients), 2) 
                                AS pct_of_total
FROM hospital_patients
GROUP BY hour_of_day
ORDER BY total_admissions DESC;

-- ================================================
-- Task 69 — Patients with length of stay > 14 days
-- Identifies long stay patients requiring attention
-- ================================================

SELECT 
    patient_id,
    age,
    gender,
    department,
    diagnosis,
    length_of_stay_days,
    outcome,
    insurance_type,
    total_bill_ngn,
    amount_paid_ngn,
    ROUND(total_bill_ngn - amount_paid_ngn, 2)  AS bill_gap
FROM hospital_patients
WHERE length_of_stay_days > 14
ORDER BY length_of_stay_days DESC;

-- ================================================
-- Task 69a & 69b — Follow up investigation queries
-- Run to get exact counts and department breakdown
-- for patients with length of stay > 14 days
-- ================================================

-- ================================================
-- Task 69a — Count of patients with stay > 14 days
-- ================================================

SELECT 
    COUNT(patient_id)       AS patients_over_14_days
FROM hospital_patients
WHERE length_of_stay_days > 14;

-- ================================================
-- Task 69b — Department with most long stay patients
-- ================================================

SELECT 
    department,
    COUNT(patient_id)       AS long_stay_patients
FROM hospital_patients
WHERE length_of_stay_days > 14
GROUP BY department
ORDER BY long_stay_patients DESC;

-- ================================================
-- Task 70 — Mortality rate by department and year
-- outcome = 'Deceased' represents mortality
-- ================================================

SELECT 
    department,
    YEAR(admission_date)                    AS year,
    COUNT(patient_id)                       AS total_patients,
    SUM(CASE WHEN outcome = 'Deceased' 
        THEN 1 ELSE 0 END)                  AS total_deceased,
    ROUND(
        SUM(CASE WHEN outcome = 'Deceased' 
            THEN 1 ELSE 0 END) * 100.0 
        / COUNT(patient_id), 2
    )                                       AS mortality_rate_pct
FROM hospital_patients
GROUP BY department, year
ORDER BY department, year;

-- ================================================
-- Task 70a — Follow up: Overall mortality rate
-- by department across all years combined
-- ================================================

-- ================================================
-- Task 70a — Overall mortality rate by department
-- Across all years combined
-- ================================================

SELECT 
    department,
    COUNT(patient_id)                       AS total_patients,
    SUM(CASE WHEN outcome = 'Deceased' 
        THEN 1 ELSE 0 END)                  AS total_deceased,
    ROUND(
        SUM(CASE WHEN outcome = 'Deceased' 
            THEN 1 ELSE 0 END) * 100.0 
        / COUNT(patient_id), 2
    )                                       AS mortality_rate_pct
FROM hospital_patients
GROUP BY department
ORDER BY mortality_rate_pct DESC;

-- ================================================
-- Task 71 — Rank departments by average bill 
-- amount using RANK() window function
-- ================================================

SELECT 
    department,
    ROUND(AVG(total_bill_ngn), 2)           AS avg_bill,
    ROUND(AVG(amount_paid_ngn), 2)          AS avg_paid,
    ROUND(AVG(total_bill_ngn) - 
          AVG(amount_paid_ngn), 2)          AS avg_gap,
    RANK() OVER (
        ORDER BY AVG(total_bill_ngn) DESC
    )                                       AS bill_rank
FROM hospital_patients
GROUP BY department
ORDER BY bill_rank;

-- ================================================
-- Task 72 — CTE: Top 5 wards by patient load 
-- each year
-- ================================================

WITH ward_yearly AS (
    SELECT 
        ward,
        YEAR(admission_date)        AS year,
        COUNT(patient_id)           AS total_patients
    FROM hospital_patients
    GROUP BY ward, year
),
ward_ranked AS (
    SELECT 
        ward,
        year,
        total_patients,
        RANK() OVER (
            PARTITION BY year 
            ORDER BY total_patients DESC
        )                           AS ward_rank
    FROM ward_yearly
)
SELECT 
    ward,
    year,
    total_patients,
    ward_rank
FROM ward_ranked
WHERE ward_rank <= 5
ORDER BY year, ward_rank;

-- ================================================
-- PROJECT 2 — SQL FINDINGS & INSIGHTS SUMMARY
-- ================================================

/*
INSIGHT 1 — Pediatrics is Most Burdened Department
Pediatrics has the highest admissions, highest readmission 
rate and second highest mortality rate. Despite this it has 
the lowest average bill — suggesting underpricing of services.

INSIGHT 2 — COVID-19 Leading Diagnosis (2021-2023)
COVID-19 accounted for 6.37% of all admissions reflecting 
the pandemic's significant impact on hospital operations 
during the analysis period.

INSIGHT 3 — 45% of Patients Stay Longer than 14 Days
27,032 patients stayed beyond 14 days indicating high 
resource consumption. Pediatrics and Neurology lead in 
long stay patients requiring priority resource allocation.

INSIGHT 4 — Peak Hours are 5PM and 9AM
Two distinct admission peaks identified — morning scheduled 
appointments at 9AM and post work emergencies at 5PM.
Maximum staffing required at both periods daily.

INSIGHT 5 — Oncology Leads Mortality, Pediatrics Second
While Oncology mortality is clinically expected, Pediatrics 
ranking second is alarming. The 2022 Pediatrics mortality 
spike from 3.0% to 3.74% warrants urgent investigation.

INSIGHT 6 — Ward 16 Chronically Overloaded
Ward 16 appeared in top 5 busiest wards all three years.
Ward 20 also consistently ranked 2nd and 3rd. Both need 
permanent additional capacity and staffing.

INSIGHT 7 — NHIS Largest Revenue Gap
Despite having the highest collection rate NHIS has the 
largest absolute revenue gap due to high patient volume.
Stronger billing enforcement needed across all insurance types.
*/



