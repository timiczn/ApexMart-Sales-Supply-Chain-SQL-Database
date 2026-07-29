# ApexMart-Sales-Supply-Chain-SQL-Database

## Overview

This project is a full relational database design and implementation for ApexMart, an FMCG distribution company operating through regional warehouses across Nigeria.

<img width="9188" height="7469" alt="ApexMart Database ERD" src="https://github.com/user-attachments/assets/63bb7a32-4ac9-4437-b9d8-6fefc8ea4fc1" />

The database manages the company’s complete sales and supply chain process, including suppliers, procurement, goods receiving, warehouse inventory, customer orders, stock movements, employee responsibilities, and monthly sales targets.

The project replaces disconnected operational records with a structured SQL Server database capable of supporting reliable reporting across sales, inventory, procurement, supplier performance, warehouse operations, and customer activity.


## The Problem

ApexMart’s operations require data to move consistently across several departments.

Products are purchased from suppliers, received into warehouses, sold to customers, and deducted from inventory. Without a properly structured database, these processes can easily produce:

- Suppliers assigned to products they do not provide
- Purchase orders disconnected from received goods
- Warehouse inventory with no record of how the stock was acquired
- Sales orders containing products unavailable in the assigned warehouse
- Duplicate products within the same customer order
- Inventory balances that do not agree with stock movements
- Sales activity with no performance targets
- Repeated customer, product, employee, and location information
- No reliable way to analyse operations across warehouses, products, suppliers, customers, and regions


## Solution

A fully normalised relational database implemented in Microsoft SQL Server, consisting of **22 related tables** covering:

- Geography
- Customers
- Products
- Suppliers
- Employees
- Warehouses
- Procurement
- Goods receiving
- Inventory
- Sales
- Sales targets

The database includes primary keys, foreign keys, unique constraints, check constraints, default values, audit columns, and indexes.

Transactional data was generated around the company’s actual operational sequence rather than treating each table independently.


## Database Schema

#### Entity Relationship Summary

```text
Region ──< State ──< City
                       │
                       ├──< Customer
                       ├──< Supplier
                       ├──< Employee
                       └──< Warehouse

Category ──< Product >── Brand
                 │
                 └── Unit of Measure

Supplier ──< Purchase Order ──< Purchase Order Item >── Product
                    │
                    └── Warehouse
                            │
                            v
                    Goods Receipt ──< Goods Receipt Item
                            │
                            v
                    Warehouse Inventory
                            │
                            v
Customer ──< Sales Order ──< Sales Order Item >── Product
                    │
                    ├── Warehouse
                    └── Sales Representative

Warehouse Inventory ──< Inventory Transaction

Sales Representative ──< Sales Target
```


## Tables

| Table | Description |
|---|---|
| `Regions` | Nigeria’s geopolitical regions |
| `States` | States linked to their respective regions |
| `Cities` | Operational cities linked to states |
| `Customer_Types` | Customer classifications such as supermarkets, wholesalers, and retailers |
| `Customers` | Customer profiles, contact details, credit limits, and payment terms |
| `Categories` | FMCG product categories |
| `Brands` | Product brand definitions |
| `Units_Of_Measure` | Units used to store and sell products |
| `Products` | Product catalogue containing codes, SKUs, prices, categories, brands, and units |
| `Suppliers` | Supplier profiles, locations, contact information, and payment terms |
| `Departments` | Organisational department records |
| `Employees` | Employee profiles, job roles, locations, and departments |
| `Warehouses` | Regional warehouse locations and assigned managers |
| `Purchase_Orders` | Procurement order headers |
| `Purchase_Order_Items` | Products, quantities, and unit costs within each purchase order |
| `Goods_Receipts` | Deliveries received against purchase orders |
| `Goods_Receipt_Items` | Accepted and rejected quantities received for each purchase-order item |
| `Warehouse_Inventory` | Current stock balance for each product within each warehouse |
| `Inventory_Transactions` | Complete record of inventory receipts and dispatches |
| `Sales_Orders` | Customer order headers linked to warehouses and sales representatives |
| `Sales_Order_Items` | Products, quantities, prices, and discounts within each sales order |
| `Sales_Targets` | Monthly revenue targets assigned to sales representatives |


## Key Design Decisions

#### Grain

The grain of each transactional table was clearly defined before implementation.

- One row in `Purchase_Orders` represents one supplier order.
- One row in `Purchase_Order_Items` represents one product within a purchase order.
- One row in `Goods_Receipts` represents one delivery received against a purchase order.
- One row in `Goods_Receipt_Items` represents one received purchase-order item.
- One row in `Warehouse_Inventory` represents one product in one warehouse.
- One row in `Sales_Orders` represents one customer order.
- One row in `Sales_Order_Items` represents one product within a customer order.
- One row in `Inventory_Transactions` represents one stock movement.
- One row in `Sales_Targets` represents one employee’s target for one month.

#### Header and Line-Item Structure

Purchase orders, goods receipts, and sales orders were separated into header and line-item tables.

This prevents order-level information such as supplier, customer, warehouse, employee, and transaction date from being repeated for every product.

```text
Purchase_Orders ──< Purchase_Order_Items

Goods_Receipts ──< Goods_Receipt_Items

Sales_Orders ──< Sales_Order_Items
```

#### Geography Normalisation

Location information was separated into `Regions`, `States`, and `Cities`.

Customers, suppliers, employees, and warehouses reference a valid city rather than storing inconsistent free-text locations.

This allows performance to be analysed reliably by:

- City
- State
- Region

#### Surrogate Primary Keys

Every table uses an auto-generated numeric primary key.

Business identifiers such as customer codes, product codes, warehouse codes, employee codes, and order references are protected with `UNIQUE` constraints but are not used as primary keys. This prevents changes to business-facing identifiers from affecting table relationships.

#### Duplicate Products Prevented

The same product cannot appear more than once within a single sales order.
A composite unique constraint was applied to:

```sql
UNIQUE (Sales_Order_ID, Product_ID)
```
#### Inventory Transaction Ledger

The `Inventory_Transactions` table records the source of every stock movement.

Goods received create positive movements:

```text
Goods Receipt → Positive Quantity
```

Sales dispatches create negative movements:

```text
Sales Dispatch → Negative Quantity
```
Cancelled and unfulfilled orders do not reduce inventory.
The warehouse stock balance is therefore calculated as:

```text
Current Stock =
Total Goods Received − Total Goods Dispatched
```

#### Calculated Values Not Stored

Values that can be derived reliably from existing columns were not stored.
These include:
- Purchase-order value
- Sales revenue
- Gross profit
- Order totals
- Inventory value
- Target achievement percentage
- Supplier lead time
- Average order value

They are calculated during analysis using quantities, prices, unit costs, discounts, dates, and aggregations. This prevents calculated values from becoming inconsistent with their source transactions.

## Implementation Process

#### 01. Database Planning and ERD Design

The major business entities and relationships were identified before writing the SQL schema.

The ERD was designed in Excalidraw and reviewed table by table to confirm:

- Table grain
- Primary keys
- Foreign keys
- One-to-many relationships
- Required business entities
- Operational sequence
- Removal of unnecessary tables and columns

#### 02. Schema Creation

The full database schema was implemented in SQL Server.

The schema includes:

- 22 relational tables
- Primary and foreign keys
- Unique constraints
- Check constraints
- Default constraints
- Audit columns
- Indexes
- Referential integrity rules

#### 03. Initial Data Population

The first seed script populated the database with:

- Nigerian regions, states, and cities
- Customer types and customers
- Product categories, brands, units, and products
- Suppliers
- Departments and employees
- Warehouses
- Purchase orders and items
- Goods receipts and items
- Warehouse inventory
- Sales orders and items

### Business Questions Answered

The completed database supports analysis across sales, procurement, inventory, customers, suppliers, and warehouse operations.

#### 01. Which sales representatives achieved their monthly targets?

Compares monthly sales revenue against the target assigned to each representative.

#### 02. Which products and categories generate the highest revenue?

Ranks products and categories using quantities sold, prices, and discounts.

#### 03. Which customers contribute the most revenue?

Measures total customer value, purchase frequency, and average order value.

#### 04. Which suppliers account for the highest procurement spend?

Calculates purchase value from ordered quantities and unit costs.

#### 05. Which suppliers have the highest rejection rates?

Compares accepted and rejected goods across supplier deliveries.

#### 06. Which warehouses record the highest sales and stock movement?

Measures goods received, quantities dispatched, revenue, and current stock by warehouse.

#### 07. Which products are below their reorder level?

Compares current warehouse stock against the reorder level for each product.

#### 08. Which products are slow-moving or inactive?

Identifies products with inventory receipts but low or no sales activity.

#### 09. How does sales performance vary by region?

Connects customers and warehouses to the geography hierarchy for regional reporting.

#### 10. Does warehouse inventory reconcile with the transaction ledger?

Compares recorded warehouse stock with the sum of all positive and negative inventory movements.

### Constraints Applied

| Constraint Type | Example |
|---|---|
| `PRIMARY KEY` | Auto-generated identifier on every table |
| `FOREIGN KEY` | Customers to Cities, Products to Categories, Orders to Warehouses |
| `UNIQUE` | Customer code, product code, employee code, warehouse code, order references |
| `COMPOSITE UNIQUE` | Product per sales order, employee target per month |
| `CHECK` | Positive quantities, valid statuses, valid months, non-negative prices |
| `DEFAULT` | Active status, created date, rejected quantity, discount percentage |
| `NOT NULL` | All essential business and transactional columns |

### Tools Used

- **SQL Server Management Studio**. schema creation, query execution, debugging, and validation
- **Microsoft SQL Server**. relational database implementation
- **Excalidraw**. entity relationship diagram design
