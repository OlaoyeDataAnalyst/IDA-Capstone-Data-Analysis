# 📊 Project 1 — Retail Sales Performance Analysis

## 🏢 Business Background
ShopEase Nigeria is a mid-sized retail company operating across 8 major cities in Nigeria, selling products across 8 categories through both physical stores and an online platform. Management noticed that while overall revenue had grown, some regions and product categories were consistently underperforming. This analysis investigates sales trends, customer behaviour, and produces a comprehensive performance dashboard to guide strategic decisions.

---

## 📁 Project Structure
```
Project1_ShopEase/
├── Project1_Retail_Sales_EDA.ipynb      # Python EDA notebook with 6+ visualizations
├── Project1_Retail_Sales_SQL.sql        # 11 SQL queries including window functions & CTEs
├── Project1_Retail_Sales_Excel.xlsx     # Pivot tables, charts & KPI summary sheet
├── Project1_Retail_Sales_Dashboard.pdf  # Power BI interactive dashboard export
└── Project1_ShopEase_Summary.docx       # Written findings & recommendations report
```

---

## 🎯 Objectives
- Perform end-to-end data cleaning and exploratory analysis in Python
- Write SQL queries to answer business KPI questions
- Build pivot table summaries and trend charts in Excel
- Design an interactive sales dashboard in Power BI
- Identify actionable insights from sales patterns

---

## 📊 Dataset
- **Source:** IDA/3MTT Data Analysis Bootcamp (educational purposes)
- **Records:** 79,931 orders after cleaning
- **Period:** January 2021 — December 2023
- **Columns:** 17 (order details, product info, revenue, customer & salesperson data)
- **Note:** Raw dataset not included in this repository

---

## 🛠️ Tools & Techniques Used
| Tool | Purpose | Techniques Applied |
|------|---------|-------------------|
| Python (Pandas, Matplotlib, Seaborn) | Data cleaning & EDA | Feature engineering, correlation analysis, heatmaps |
| MySQL | Business queries | Window functions (LAG, RANK), CTEs, GROUP BY |
| Microsoft Excel | Pivot tables & reporting | SUMIF, COUNTIF, conditional formatting |
| Power BI | Interactive dashboard | DAX measures, slicers, page-level filters |

---

## 🔍 Key Findings

**1. Lagos Leads in Total Revenue**
Lagos recorded the highest total revenue across all 8 regions, reflecting its status as Nigeria's commercial capital with the highest population and purchasing power.

**2. Electronics Dominates Revenue**
Electronics contributed the highest percentage of total revenue while Food & Beverages contributed the least — suggesting limited competitiveness in that segment.

**3. Smartphones are the Top Product**
Smartphones ranked #1 by net revenue and appeared in the top 3 products by revenue per unit sold, confirming high-value electronics as the primary revenue driver.

**4. Near-Zero Repeat Purchase Rate**
The maximum number of orders placed by any single customer was just 2, with only 2 customers achieving this. ShopEase is almost entirely dependent on new customer acquisition.

**5. Clothing Has the Highest Return Rate**
Clothing recorded the highest return rate among all categories, likely due to sizing mismatches and product expectation gaps from online descriptions.

**6. Delivery Time Does Not Drive Returns**
Pearson correlation between delivery days and return rate was only 0.064 — an extremely weak relationship, meaning logistics speed is not the primary cause of returns.

---

## 📈 KPI Summary
| Metric | Value |
|--------|-------|
| Total Net Revenue | ₦15,971,958,650 |
| Total Orders | 79,931 |
| Average Order Value | ₦199,821.83 |
| Overall Return Rate | 8.06% |
| Top Region | Lagos |
| Top Category | Electronics |
| Top Product | Smartphone |
| Top Salesperson | SP-049 |
| Number of Regions | 8 |
| Number of Categories | 8 |
| Number of Salespersons | 50 |

---

## 💡 Recommendations
1. **Launch a customer loyalty programme** immediately to address the critically low repeat purchase rate and reduce dependence on new customer acquisition
2. **Improve Clothing category** quality control, size guides, and product descriptions to reduce the high return rate
3. **Prioritise POS infrastructure** reliability as the most used payment channel — any downtime significantly impacts sales
4. **Explore growth in underperforming regions** by replicating Lagos and Port Harcourt success strategies
5. **Review Food & Beverages strategy** — consider scaling down or differentiating from local market competition
6. **Implement salesperson incentive structure** based on RANK() analysis to motivate mid and low performers

---

## 📸 Dashboard Preview
*See **Project1_Retail_Sales_Dashboard.pdf** for the full Power BI dashboard featuring:*
- 4 KPI Cards (Total Revenue, Total Orders, AOV, Return Rate)
- Bar Chart: Revenue by Region
- Donut Chart: Revenue by Category
- Line Chart: Monthly Revenue Trend 2021–2023
- Matrix: Region × Category Revenue Breakdown
- Slicers: Year, Region, Category, Payment Method

---

## 👩‍💻 Author
**Olaoye Abosede Esther**
- 📧 esthobossy@gmail.com
- 💼 [LinkedIn](https://linkedin.com/in/abosede-olaoye-49b320324)
- 🐙 [GitHub](https://github.com/OlaoyeDataAnalyst)

---

*This project was completed as part of the IDA/3MTT Data Analysis Bootcamp Capstone (2026)*
