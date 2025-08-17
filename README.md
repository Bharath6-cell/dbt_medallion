# DBT Medallion Architecture Project (Bronze → Silver → Gold)

## 🎯 Objective
This project demonstrates how to build a data pipeline using **DBT** and the **Medallion Architecture**.  
It ingests transactional data (Customers, Orders, OrderItems, Products, Suppliers) into **Snowflake** (or any warehouse), and transforms it into a **star schema** with dimensions and facts.

---

## 🏗️ Architecture
- **BRONZE Layer (Raw)**  
  Direct ingestion from source OLTP tables.  
  Stored in schema: `DBT_BMANDHA_BRONZE`.

- **SILVER Layer (Cleansed)**  
  Standardized, type-correct, conformed data models.  
  Stored in schema: `DBT_BMANDHA_SILVER`.  
  Examples: `silver_customers`, `silver_orders`, etc.

- **GOLD Layer (Dimensional)**  
  Analytical models optimized for reporting.  
  Stored in schema: `DBT_BMANDHA_GOLD`.  
  Examples: `dim_customer`, `dim_product`, `dim_supplier`, `dim_date`, `fact_sales`.

---

## 📂 Project Structure
├── models/
│ ├── DBT_MEDALLION
│ │ ├── bronze/ # Raw sources
│ │ ├── silver/ # Cleansed staging models
│ │ ├── gold/ # Dimensional star schema
│ └── schema.yml # Tests + documentation
├── seeds/
├── dbt_project.yml
└── README.md
