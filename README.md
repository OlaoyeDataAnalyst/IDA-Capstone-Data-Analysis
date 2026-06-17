# 💰 Project 5 — Personal Finance & Budget Analysis

## 🏢 Business Background
FinTrack is a Nigerian fintech startup building a personal finance application. Before launch, the product team commissioned an analysis of three years of synthetic transaction data from 5,000 test users to understand spending patterns, savings behaviour, and budgetary pressures. The findings inform in-app budget recommendations, alert features, and marketing segmentation strategies.

---

## 📁 Project Structure
```
Project5_FinTrack/
├── Project5_Personal_Finance_EDA.ipynb      # Python EDA with 10 financial visualizations
├── Project5_Personal_Finance_SQL.sql        # 11 SQL queries including cumulative window functions
├── Project5_Personal_Finance_Excel.xlsx     # Pivot tables, 50/30/20 budget model & KPI sheet
├── Project5_Personal_Finance_Dashboard.pdf  # Power BI dashboard with DAX savings rate measure
└── Project5_FinTrack_Summary.docx           # Written findings & product recommendations
```

---

## 🎯 Objectives
- Aggregate and analyse financial transaction data across users and time
- Build a multi-user SQL financial database with meaningful queries
- Create a personal budget model in Excel using the 50/30/20 rule
- Design a consumer-facing finance dashboard in Power BI
- Identify actionable product insights for the FinTrack app team

---

## 📊 Dataset
- **Source:** IDA/3MTT Data Analysis Bootcamp (educational purposes)
- **Records:** 74,922 transactions after cleaning
- **Users:** 5,000 unique users
- **Period:** January 2021 — December 2023
- **Columns:** 14 (transaction details, categories, payment methods, banking data)
- **Data Quality:** 24,994 missing savings_goal_met filled with 'N/A'; 21,618 missing notes filled with 'Unknown'
- **Note:** Raw dataset not included in this repository

---

## 🛠️ Tools & Techniques Used
| Tool | Purpose | Techniques Applied |
|------|---------|-------------------|
| Python (Pandas, Matplotlib, Seaborn) | Data cleaning & financial EDA | Income/expense separation, over-spender flagging, income bracket analysis |
| MySQL | Financial queries | Cumulative SUM() OVER, NTILE(), CTEs, CASE WHEN |
| Microsoft Excel | Budget model & reporting | 50/30/20 dynamic model, SUMIFS, conditional formatting |
| Power BI | Consumer dashboard | DAX Savings Rate measure, 5 slicers, slicer-responsive measures |

---

## 🔍 Key Findings

**1. 99.6% of Users Overspend**
4,982 out of 5,000 users overspent in more than 3 months across the analysis period. The average user overspent in 10.1 out of 36 months — struggling financially for nearly one-third of the year. This strongly validates FinTrack's core product concept.

**2. Overall Savings Rate is 16.80%**
Total income of ₦4,399,924,700 against total expenses of ₦3,660,710,070 yields a net savings of ₦739,214,630. The savings rate falls below the recommended 20% threshold.

**3. 1,655 Users Have Never Saved**
33.1% of users have never recorded a single savings transaction despite actively spending. These are FinTrack's highest priority users for automated savings nudges and goal-setting features.

**4. Low Income Users Struggle Most**
Users earning below ₦1M monthly show negative average savings — consistently spending more than they earn. Only users above ₦2M monthly income show meaningfully positive savings behaviour.

**5. August is Peak Spending Month**
August recorded the highest total spending for both Savings (₦32.0M) and Entertainment (₦30.9M). It is also the only month where collective expenses exceeded income (-₦3,031,360 net savings in August 2023).

**6. All 8 Banks Equally Popular**
GTBank leads narrowly in transaction volume at 12.66% but all banks share transactions almost equally at ~12.5% each. FinTrack should integrate all 8 banks equally.

---

## 📈 KPI Summary
| Metric | Value |
|--------|-------|
| Total Income | ₦4,399,924,700 |
| Total Expenses | ₦3,660,710,070 |
| Net Savings | ₦739,214,630 |
| Overall Savings Rate | 16.80% |
| Total Users | 5,000 |
| Over-spenders (>3 months) | 4,982 (99.6%) |
| Users Who Never Saved | 1,655 (33.1%) |
| Users with Savings Rate >20% | 2,245 (44.9%) |
| Top Spending Category | Savings (8.9%) |
| Most Used Bank | GTBank (12.66%) |
| Peak Income Month | December |
| Peak Spending Month | August |

---

## 💡 Recommendations
1. **Make budget alerts core features** — not optional — given 99.6% of users overspend in some months
2. **Implement automated savings nudges** for the 1,655 users who have never saved, starting with low-commitment options like transaction round-ups
3. **Send proactive budget reminders in July** to prepare users for the August spending surge
4. **Offer simplified budget templates** for users earning below ₦1M monthly — this segment needs the most structural financial support
5. **Integrate all 8 banks equally** to serve the diverse banking preferences of the user base
6. **Introduce savings milestones and badges** to celebrate and reinforce positive savings behaviour among the 44.9% already saving above 20%

---

## 🧮 50/30/20 Budget Model
A dynamic Excel budget model was built that automatically calculates recommended category budgets when a monthly income amount is entered:
- **50% Needs** — Rent, Food, Utilities, Transport, Healthcare
- **30% Wants** — Entertainment, Clothing, Airtime/Data, Miscellaneous
- **20% Savings** — Savings deposits and Investments

---

## 📸 Dashboard Preview
*See **Project5_Personal_Finance_Dashboard.pdf** for the full Power BI dashboard featuring:*
- 4 KPI Cards (Total Income, Total Expenses, Net Savings, Savings Rate %)
- Donut Chart: Spending by Category
- Line Chart: Monthly Income vs Expense Trend
- Bar Chart: Top 10 Spending Categories
- Table: User-Level Income, Expenses & Savings Rate
- DAX Measure: Savings Rate fully responsive to all 5 slicers
- Slicers: Year, Month, Transaction Type, Category, Bank

---

## 👩‍💻 Author
**Olaoye Abosede Esther**
- 📧 esthobossy@gmail.com
- 💼 [LinkedIn](https://linkedin.com/in/abosede-olaoye-49b320324)
- 🐙 [GitHub](https://github.com/OlaoyeDataAnalyst)

---

*This project was completed as part of the IDA/3MTT Data Analysis Bootcamp Capstone (2026)*
