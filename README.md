# 🏥 Project 2 — Hospital Patient Flow & Resource Analysis

## 🏢 Business Background
Lagos General Hospital is a busy tertiary care facility serving patients from across Lagos and neighbouring states. Hospital management raised concerns about long patient waiting times, high readmission rates, and revenue collection gaps. This analysis was commissioned to understand patient flow patterns, identify high-demand periods, and generate insights to guide resource allocation, staffing improvements, and billing efficiency.

---

## 📁 Project Structure
```
Project2_Hospital/
├── Project2_Hospital_Patient_Flow_EDA.ipynb  # Python EDA with 10 clinical visualizations
├── Project2_Hospital_SQL.sql                 # 11 SQL queries including CTEs & window functions
├── Project2_Hospital_Excel.xlsx              # Pivot tables, collection rate analysis & KPI sheet
├── Project2_Hospital_Dashboard.pdf           # Power BI dashboard with drill-through
└── Project2_Hospital_Summary.docx            # Written findings & operational recommendations
```

---

## 🎯 Objectives
- Analyse healthcare operational data to identify inefficiencies
- Calculate clinical KPIs including readmission rate and collection rate
- Use SQL to query complex multi-condition patient records
- Build an operational dashboard with drill-through for hospital management
- Identify actionable insights for resource allocation and billing improvement

---

## 📊 Dataset
- **Source:** IDA/3MTT Data Analysis Bootcamp (educational purposes)
- **Records:** 59,950 patient records after cleaning
- **Period:** January 2021 — December 2023
- **Columns:** 17 (patient demographics, admission details, outcomes, billing data)
- **Data Quality:** 12,122 missing insurance_type values filled with 'Unknown'
- **Note:** Raw dataset not included in this repository

---

## 🛠️ Tools & Techniques Used
| Tool | Purpose | Techniques Applied |
|------|---------|-------------------|
| Python (Pandas, Matplotlib, Seaborn) | Data cleaning & clinical EDA | Bill gap analysis, heatmaps, box plots, scatter plots |
| MySQL | Patient flow queries | CTEs, RANK(), year-over-year comparison, CASE WHEN |
| Microsoft Excel | Pivot tables & reporting | Collection rate formulas, conditional formatting |
| Power BI | Operational dashboard | Drill-through pages, DAX measures, 4 slicers |

---

## 🔍 Key Findings

**1. Pediatrics is the Most Burdened Department**
Pediatrics recorded the highest admissions (7,641), highest readmission rate, and second-highest mortality rate. Paradoxically it also has the lowest average bill — indicating critical underpricing of pediatric services relative to resource consumption.

**2. ₦6 Billion Revenue Collection Gap**
Total uncollected revenue across 2021–2023 was ₦6,074,943,600. All insurance types show a consistent ~75% collection rate, confirming this is a systemic hospital-wide problem rather than insurance-type specific.

**3. Dual Peak Admission Periods**
Friday at 17:00 (5PM) and Saturday at 01:00 (1AM) both recorded 401 admissions — the highest in the dataset. These represent post-work healthcare seeking and late-night weekend emergencies respectively.

**4. 45% of Patients Stay Longer Than 14 Days**
27,032 patients (45% of all admissions) stayed beyond 14 days, indicating high resource consumption and bed occupancy. Pediatrics and Neurology lead in long-stay patients.

**5. COVID-19 is the Leading Diagnosis**
COVID-19 accounted for 6.37% of all admissions reflecting the significant impact of the pandemic on hospital operations during the 2021–2023 period.

**6. Ward 16 Chronically Overloaded**
Ward 16 appeared in the top 5 busiest wards across all three years. Ward 20 also consistently ranked 2nd and 3rd — both require permanent additional capacity.

---

## 📈 KPI Summary
| Metric | Value |
|--------|-------|
| Total Admissions | 59,950 |
| Average Length of Stay | ~15 days |
| Overall Readmission Rate | ~20% |
| Collection Rate | ~74.9% |
| Total Bill Gap | ₦6,074,943,600 |
| Busiest Department | Pediatrics (7,641 admissions) |
| Top Diagnosis | COVID-19 (6.37%) |
| Peak Admission Hour | 17:00 (5PM — Friday) |
| Highest Mortality Dept | Oncology |
| Most Overloaded Ward | Ward 16 |

---

## 💡 Recommendations
1. **Urgently investigate Pediatrics** mortality and readmission rates, particularly the 2022 mortality spike from 3.0% to 3.74%
2. **Implement hospital-wide payment enforcement** to address the systemic 25% collection gap across all insurance types
3. **Deploy maximum staffing** on Friday evenings and Saturday overnight shifts to manage dual peak admission periods
4. **Expand capacity in Ward 16 and Ward 20** through additional beds, equipment, and dedicated nursing staff
5. **Review and increase Pediatric billing rates** to reflect actual resource consumption
6. **Improve insurance data collection** at admission to reduce the 20% Unknown insurance category

---

## 📸 Dashboard Preview
*See **Project2_Hospital_Dashboard.pdf** for the full Power BI dashboard featuring:*
- 4 KPI Cards (Total Admissions, Avg Length of Stay, Readmission Rate, Collection Rate)
- Bar Chart: Admissions by Department
- Line Chart: Monthly Admissions Trend 2021–2023
- Donut Chart: Insurance Type Distribution
- Table: Revenue Billed vs Collected by Insurance Type
- Drill-through Page: Department-level patient detail view
- Slicers: Year, Department, Outcome, Insurance Type

---

## 👩‍💻 Author
**Olaoye Abosede Esther**
- 📧 esthobossy@gmail.com
- 💼 [LinkedIn](https://linkedin.com/in/abosede-olaoye-49b320324)
- 🐙 [GitHub](https://github.com/OlaoyeDataAnalyst)

---

*This project was completed as part of the IDA/3MTT Data Analysis Bootcamp Capstone (2026)*
