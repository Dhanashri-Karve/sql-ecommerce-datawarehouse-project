# Naming Conventions
### Brazilian Olist Data Warehouse

This document defines the naming standards used throughout the **Brazilian Olist E-commerce Data Warehouse project**.  


The warehouse follows a **Medallion Architecture** consisting of three layers:

- Bronze (Raw Data)
- Silver (Cleaned Data)
- Gold (Business-Level Data)

---

# 1. General Naming Rules

The following standards apply to all database objects.

| Rule | Description |
|-----|-------------|
| Case Style | Use `snake_case` with lowercase letters and underscores |
| Language | All object names must be written in **English** |
| Reserved Keywords | Avoid SQL reserved words as database object names |
| Clarity | Names should clearly represent the entity they describe |

Example:
- customer_orders
- order_items


---

# 2. Table Naming Conventions


## Bronze Layer

The **Bronze layer** contains raw data ingested directly from the source system with minimal processing.

### Naming Pattern
**`<sourcesystem>_<entity>`**

| Component | Description |
|-----------|-------------|
| `<sourcesystem>` | Name of the source system |
| `<entity>` | Original table name from the source system |

### Rules

- Table names must match the **original source table names**.
- No renaming of source entities is allowed.
- The source system name must appear as a prefix.

### Example
- olist_orders
- olist_products


---

## Silver Layer

The **Silver layer** contains cleaned, validated, and standardized data.

### Naming Pattern
**`<sourcesystem>_<entity>`**


| Component | Description |
|-----------|-------------|
| `<sourcesystem>` | Name of the source system |
| `<entity>` | Original entity name from the source |

### Rules

- Table names remain consistent with the Bronze layer.
- Only **data cleaning and transformation** occurs.
- Table names should not be renamed.

### Example
- olist_orders
- olist_products


---

## Gold Layer

The **Gold layer** contains business-level models designed for analytics.

### Naming Pattern
**`<category>_<entity>`**


| Component | Description |
|-----------|-------------|
| `<category>` | Defines the role of the table |
| `<entity>` | Business-oriented descriptive name |

### Category Prefixes

| Prefix | Purpose |
|------|--------|
| dim | Dimension tables |
| fact | Fact tables |
| agg | Aggregation Tables |

### Example Tables
- dim_customers
- fact_sales

# 3. Column Naming Conventions

Column names should be descriptive and follow consistent patterns.

---

## Surrogate Keys

All primary keys in **dimension tables** must use the `_key` suffix.

### Pattern
**`<table_entity>_key`**


| Component | Description |
|-----------|-------------|
| `<table_entity>` | Entity associated with the key |
| `_key` | Indicates a surrogate key |

### Example
- customer_key
- product_key


---

## Technical Metadata Columns

Technical columns track **data warehouse metadata**.

### Pattern
**`dwh_<column_name>`**


| Component | Description |
|-----------|-------------|
| dwh | Prefix used for system-generated metadata |
| `<column_name>` | Description of the metadata column |

### Example Columns
- dwh_load_date
- dwh_update_date

# 4. Stored Procedure Naming

Stored procedures responsible for loading data must follow a consistent naming pattern.

### Pattern
**`load_<layer>`**

| Component | Description |
|-----------|-------------|
| load | Indicates a data loading operation |
| `<layer>` | Target data warehouse layer |

### Example Procedures
- load_bronze
- load_silver
- load_gold
