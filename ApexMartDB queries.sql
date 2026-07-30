/*==============================================================
  ApexMart Sales & Supply Chain Database
==============================================================*/

USE master;
GO

IF DB_ID('ApexMartDB') IS NULL
BEGIN
    CREATE DATABASE ApexMartDB;
END;
GO

USE ApexMartDB;
GO

/*==============================================================
   GEOGRAPHY
==============================================================*/

CREATE TABLE dbo.Regions
(
    Region_ID       TINYINT IDENTITY(1,1) NOT NULL,
    Region_Name     NVARCHAR(50) NOT NULL,
    Region_Code     CHAR(2) NOT NULL,
    Is_Active       BIT NOT NULL CONSTRAINT DF_Regions_IsActive DEFAULT (1),
    Created_Date    DATETIME2(0) NOT NULL CONSTRAINT DF_Regions_CreatedDate DEFAULT (SYSDATETIME()),
    Modified_Date   DATETIME2(0) NULL,

    CONSTRAINT PK_Regions PRIMARY KEY (Region_ID),
    CONSTRAINT UQ_Regions_RegionName UNIQUE (Region_Name),
    CONSTRAINT UQ_Regions_RegionCode UNIQUE (Region_Code)
);
GO
SELECT * FROM dbo.Regions;
GO

CREATE TABLE dbo.States
(
    State_ID        TINYINT IDENTITY(1,1) NOT NULL,
    Region_ID       TINYINT NOT NULL,
    State_Name      NVARCHAR(50) NOT NULL,
    State_Code      CHAR(3) NOT NULL,
    Is_Active       BIT NOT NULL CONSTRAINT DF_States_IsActive DEFAULT (1),
    Created_Date    DATETIME2(0) NOT NULL CONSTRAINT DF_States_CreatedDate DEFAULT (SYSDATETIME()),
    Modified_Date   DATETIME2(0) NULL,

    CONSTRAINT PK_States PRIMARY KEY (State_ID),
    CONSTRAINT FK_States_Regions FOREIGN KEY (Region_ID)
        REFERENCES dbo.Regions (Region_ID),
    CONSTRAINT UQ_States_StateName UNIQUE (State_Name),
    CONSTRAINT UQ_States_StateCode UNIQUE (State_Code)
);
GO
SELECT * FROM dbo.States
GO

CREATE TABLE dbo.Cities
(
    City_ID         SMALLINT IDENTITY(1,1) NOT NULL,
    State_ID        TINYINT NOT NULL,
    City_Name       NVARCHAR(100) NOT NULL,
    Is_Active       BIT NOT NULL CONSTRAINT DF_Cities_IsActive DEFAULT (1),
    Created_Date    DATETIME2(0) NOT NULL CONSTRAINT DF_Cities_CreatedDate DEFAULT (SYSDATETIME()),
    Modified_Date   DATETIME2(0) NULL,

    CONSTRAINT PK_Cities PRIMARY KEY (City_ID),
    CONSTRAINT FK_Cities_States FOREIGN KEY (State_ID)
        REFERENCES dbo.States (State_ID),
    CONSTRAINT UQ_Cities_State_City UNIQUE (State_ID, City_Name)
);
GO
SELECT * FROM dbo.Cities;
GO


/*==============================================================
   CUSTOMER MANAGEMENT
==============================================================*/

CREATE TABLE dbo.Customer_Types
(
    Customer_Type_ID     TINYINT IDENTITY(1,1) NOT NULL,
    Customer_Type_Name   NVARCHAR(50) NOT NULL,
    Description        NVARCHAR(255) NULL,
    Is_Active           BIT NOT NULL CONSTRAINT DF_CustomerTypes_IsActive DEFAULT (1),
    Created_Date        DATETIME2(0) NOT NULL CONSTRAINT DF_CustomerTypes_CreatedDate DEFAULT (SYSDATETIME()),
    Modified_Date       DATETIME2(0) NULL,

    CONSTRAINT PK_CustomerTypes PRIMARY KEY (Customer_Type_ID),
    CONSTRAINT UQ_CustomerTypes_Name UNIQUE (Customer_Type_Name)
);
GO
SELECT * FROM dbo.Customer_Types;
GO

CREATE TABLE dbo.Customers
(
    Customer_ID         INT IDENTITY(1,1) NOT NULL,
    Customer_Type_ID     TINYINT NOT NULL,
    City_ID             SMALLINT NOT NULL,
    Customer_Code       VARCHAR(20) NOT NULL,
    Customer_Name       NVARCHAR(150) NOT NULL,
    Contact_Person      NVARCHAR(100) NULL,
    Phone              VARCHAR(20) NULL,
    Email              NVARCHAR(255) NULL,
    Address            NVARCHAR(255) NOT NULL,
    Credit_Limit        DECIMAL(18,2) NOT NULL CONSTRAINT DF_Customers_CreditLimit DEFAULT (0),
    Payment_Terms       TINYINT NOT NULL CONSTRAINT DF_Customers_PaymentTerms DEFAULT (0),
    Is_Active           BIT NOT NULL CONSTRAINT DF_Customers_IsActive DEFAULT (1),
    Created_Date        DATETIME2(0) NOT NULL CONSTRAINT DF_Customers_CreatedDate DEFAULT (SYSDATETIME()),
    Modified_Date       DATETIME2(0) NULL,

    CONSTRAINT PK_Customers PRIMARY KEY (Customer_ID),
    CONSTRAINT FK_Customers_CustomerTypes FOREIGN KEY (Customer_Type_ID)
        REFERENCES dbo.Customer_Types (Customer_Type_ID),
    CONSTRAINT FK_Customers_Cities FOREIGN KEY (City_ID)
        REFERENCES dbo.Cities (City_ID),
    CONSTRAINT UQ_Customers_CustomerCode UNIQUE (Customer_Code),
    CONSTRAINT CK_Customers_CreditLimit CHECK (Credit_Limit >= 0),
    CONSTRAINT CK_Customers_PaymentTerms CHECK (Payment_Terms >= 0)
);
GO
SELECT* FROM dbo.Customers
GO


/*==============================================================
  PRODUCT MANAGEMENT
==============================================================*/

CREATE TABLE dbo.Categories
(
    Category_ID      TINYINT IDENTITY(1,1) NOT NULL,
    Category_Name    NVARCHAR(100) NOT NULL,
    Description     NVARCHAR(255) NULL,
    Is_Active        BIT NOT NULL CONSTRAINT DF_Categories_IsActive DEFAULT (1),
    Created_Date     DATETIME2(0) NOT NULL CONSTRAINT DF_Categories_CreatedDate DEFAULT (SYSDATETIME()),
    Modified_Date    DATETIME2(0) NULL,

    CONSTRAINT PK_Categories PRIMARY KEY (Category_ID),
    CONSTRAINT UQ_Categories_Name UNIQUE (Category_Name)
);
GO
SELECT * FROM DBO.Categories
GO

CREATE TABLE dbo.Brands
(
    Brand_ID         SMALLINT IDENTITY(1,1) NOT NULL,
    Brand_Name       NVARCHAR(100) NOT NULL,
    Description     NVARCHAR(255) NULL,
    Is_Active        BIT NOT NULL CONSTRAINT DF_Brands_IsActive DEFAULT (1),
    Created_Date     DATETIME2(0) NOT NULL CONSTRAINT DF_Brands_CreatedDate DEFAULT (SYSDATETIME()),
    Modified_Date    DATETIME2(0) NULL,

    CONSTRAINT PK_Brands PRIMARY KEY (Brand_ID),
    CONSTRAINT UQ_Brands_Name UNIQUE (Brand_Name)
);
GO
SELECT * FROM DBO.Brands
GO

CREATE TABLE dbo.Units_Of_Measure
(
    Unit_ID              TINYINT IDENTITY(1,1) NOT NULL,
    Unit_Name            NVARCHAR(50) NOT NULL,
    Unit_Abbreviation    NVARCHAR(10) NOT NULL,
    Is_Active            BIT NOT NULL CONSTRAINT DF_UnitsOfMeasure_IsActive DEFAULT (1),
    Created_Date         DATETIME2(0) NOT NULL CONSTRAINT DF_UnitsOfMeasure_CreatedDate DEFAULT (SYSDATETIME()),
    Modified_Date        DATETIME2(0) NULL,

    CONSTRAINT PK_UnitsOfMeasure PRIMARY KEY (Unit_ID),
    CONSTRAINT UQ_UnitsOfMeasure_Name UNIQUE (Unit_Name),
    CONSTRAINT UQ_UnitsOfMeasure_Abbreviation UNIQUE (Unit_Abbreviation)
);
GO
SELECT * FROM DBO.Units_Of_Measure
GO

CREATE TABLE dbo.Products
(
    Product_ID       INT IDENTITY(1,1) NOT NULL,
    Category_ID      TINYINT NOT NULL,
    Brand_ID         SMALLINT NOT NULL,
    Unit_ID          TINYINT NOT NULL,
    Product_Code     VARCHAR(20) NOT NULL,
    Product_Name     NVARCHAR(150) NOT NULL,
    SKU             VARCHAR(30) NOT NULL,
    Barcode         VARCHAR(50) NULL,
    Selling_Price    DECIMAL(18,2) NOT NULL,
    Is_Active        BIT NOT NULL CONSTRAINT DF_Products_IsActive DEFAULT (1),
    Created_Date     DATETIME2(0) NOT NULL CONSTRAINT DF_Products_CreatedDate DEFAULT (SYSDATETIME()),
    Modified_Date    DATETIME2(0) NULL,

    CONSTRAINT PK_Products PRIMARY KEY (Product_ID),
    CONSTRAINT FK_Products_Categories FOREIGN KEY (Category_ID)
        REFERENCES dbo.Categories (Category_ID),
    CONSTRAINT FK_Products_Brands FOREIGN KEY (Brand_ID)
        REFERENCES dbo.Brands (Brand_ID),
    CONSTRAINT FK_Products_UnitsOfMeasure FOREIGN KEY (Unit_ID)
        REFERENCES dbo.Units_Of_Measure (Unit_ID),
    CONSTRAINT UQ_Products_ProductCode UNIQUE (Product_Code),
    CONSTRAINT UQ_Products_SKU UNIQUE (SKU),
    CONSTRAINT CK_Products_SellingPrice CHECK (Selling_Price >= 0)
);
GO
SELECT * FROM DBO.Products
GO

    /*==============================================================
   SUPPLIER MANAGEMENT
==============================================================*/

CREATE TABLE dbo.Suppliers
(
    Supplier_ID       INT IDENTITY(1,1) NOT NULL,
    City_ID           SMALLINT NOT NULL,
    Supplier_Code     VARCHAR(20) NOT NULL,
    Supplier_Name     NVARCHAR(150) NOT NULL,
    Contact_Person    NVARCHAR(100) NULL,
    Phone            VARCHAR(20) NULL,
    Email            NVARCHAR(255) NULL,
    Address          NVARCHAR(255) NOT NULL,
    Payment_Terms     TINYINT NOT NULL CONSTRAINT DF_Suppliers_PaymentTerms DEFAULT (0),
    Is_Active         BIT NOT NULL CONSTRAINT DF_Suppliers_IsActive DEFAULT (1),
    Created_Date      DATETIME2(0) NOT NULL CONSTRAINT DF_Suppliers_CreatedDate DEFAULT (SYSDATETIME()),
    Modified_Date     DATETIME2(0) NULL,

    CONSTRAINT PK_Suppliers PRIMARY KEY (Supplier_ID),
    CONSTRAINT FK_Suppliers_Cities FOREIGN KEY (City_ID)
        REFERENCES dbo.Cities (City_ID),
    CONSTRAINT UQ_Suppliers_SupplierCode UNIQUE (Supplier_Code),
    CONSTRAINT CK_Suppliers_PaymentTerms CHECK (Payment_Terms >= 0)
);
GO
SELECT * FROM DBO.Suppliers
GO


/*==============================================================
   ORGANIZATION
==============================================================*/

CREATE TABLE dbo.Departments
(
    Department_ID      TINYINT IDENTITY(1,1) NOT NULL,
    Department_Name    NVARCHAR(100) NOT NULL,
    Description       NVARCHAR(255) NULL,
    Is_Active          BIT NOT NULL CONSTRAINT DF_Departments_IsActive DEFAULT (1),
    Created_Date       DATETIME2(0) NOT NULL CONSTRAINT DF_Departments_CreatedDate DEFAULT (SYSDATETIME()),
    Modified_Date      DATETIME2(0) NULL,

    CONSTRAINT PK_Departments PRIMARY KEY (Department_ID),
    CONSTRAINT UQ_Departments_Name UNIQUE (Department_Name)
);
GO
SELECT * FROM DBO.Departments
GO

CREATE TABLE dbo.Employees
(
    Employee_ID       INT IDENTITY(1,1) NOT NULL,
    Department_ID     TINYINT NOT NULL,
    City_ID           SMALLINT NOT NULL,
    Employee_Code     VARCHAR(20) NOT NULL,
    First_Name        NVARCHAR(100) NOT NULL,
    Last_Name         NVARCHAR(100) NOT NULL,
    Phone            VARCHAR(20) NULL,
    Email            NVARCHAR(255) NOT NULL,
    Hire_Date         DATE NOT NULL,
    Job_Title         NVARCHAR(100) NOT NULL,
    Is_Active         BIT NOT NULL CONSTRAINT DF_Employees_IsActive DEFAULT (1),
    Created_Date      DATETIME2(0) NOT NULL CONSTRAINT DF_Employees_CreatedDate DEFAULT (SYSDATETIME()),
    Modified_Date     DATETIME2(0) NULL,

    CONSTRAINT PK_Employees PRIMARY KEY (Employee_ID),
    CONSTRAINT FK_Employees_Departments FOREIGN KEY (Department_ID)
        REFERENCES dbo.Departments (Department_ID),
    CONSTRAINT FK_Employees_Cities FOREIGN KEY (City_ID)
        REFERENCES dbo.Cities (City_ID),
    CONSTRAINT UQ_Employees_EmployeeCode UNIQUE (Employee_Code),
    CONSTRAINT UQ_Employees_Email UNIQUE (Email)
);
GO
SELECT * FROM DBO.Employees
GO

CREATE TABLE dbo.Warehouses
(
    Warehouse_ID       SMALLINT IDENTITY(1,1) NOT NULL,
    City_ID            SMALLINT NOT NULL,
    Manager_ID         INT NOT NULL,
    Warehouse_Code     VARCHAR(20) NOT NULL,
    Warehouse_Name     NVARCHAR(100) NOT NULL,
    Address           NVARCHAR(255) NOT NULL,
    Is_Active          BIT NOT NULL CONSTRAINT DF_Warehouses_IsActive DEFAULT (1),
    Created_Date       DATETIME2(0) NOT NULL CONSTRAINT DF_Warehouses_CreatedDate DEFAULT (SYSDATETIME()),
    Modified_Date      DATETIME2(0) NULL,

    CONSTRAINT PK_Warehouses PRIMARY KEY (Warehouse_ID),
    CONSTRAINT FK_Warehouses_Cities FOREIGN KEY (City_ID)
        REFERENCES dbo.Cities (City_ID),
    CONSTRAINT FK_Warehouses_Manager FOREIGN KEY (Manager_ID)
        REFERENCES dbo.Employees (Employee_ID),
    CONSTRAINT UQ_Warehouses_WarehouseCode UNIQUE (Warehouse_Code)
);
GO
SELECT * FROM  DBO.Warehouses
GO

/*==============================================================
   PROCUREMENT
==============================================================*/

CREATE TABLE dbo.Purchase_Orders
(
    Purchase_Order_ID        INT IDENTITY(1,1) NOT NULL,
    Supplier_ID             INT NOT NULL,
    Warehouse_ID            SMALLINT NOT NULL,
    Created_By_Employee_ID    INT NOT NULL,
    Purchase_Order_Code      VARCHAR(20) NOT NULL,
    Order_Date              DATE NOT NULL,
    Expected_Delivery_Date   DATE NOT NULL,
    Purchase_Order_Status    VARCHAR(20) NOT NULL,
    Notes                  NVARCHAR(255) NULL,
    Created_Date            DATETIME2(0) NOT NULL CONSTRAINT DF_PurchaseOrders_CreatedDate DEFAULT (SYSDATETIME()),
    Modified_Date           DATETIME2(0) NULL,

    CONSTRAINT PK_PurchaseOrders PRIMARY KEY (Purchase_Order_ID),
    CONSTRAINT FK_PurchaseOrders_Suppliers FOREIGN KEY (Supplier_ID)
        REFERENCES dbo.Suppliers (Supplier_ID),
    CONSTRAINT FK_PurchaseOrders_Warehouses FOREIGN KEY (Warehouse_ID)
        REFERENCES dbo.Warehouses (Warehouse_ID),
    CONSTRAINT FK_PurchaseOrders_Employees FOREIGN KEY (Created_By_Employee_ID)
        REFERENCES dbo.Employees (Employee_ID),
    CONSTRAINT UQ_PurchaseOrders_Code UNIQUE (Purchase_Order_Code),
    CONSTRAINT CK_PurchaseOrders_Dates CHECK (Expected_Delivery_Date >= Order_Date),
    CONSTRAINT CK_PurchaseOrders_Status CHECK
    (
        Purchase_Order_Status IN
        ('Draft','Submitted','Approved','Partially Received','Received','Cancelled')
    )
);
GO
SELECT * FROM DBO.Purchase_Orders
GO

CREATE TABLE dbo.Purchase_Order_Items
(
    Purchase_Order_Item_ID   BIGINT IDENTITY(1,1) NOT NULL,
    Purchase_Order_ID       INT NOT NULL,
    Product_ID             INT NOT NULL,
    Quantity_Ordered       INT NOT NULL,
    Unit_Cost              DECIMAL(18,2) NOT NULL,
    Created_Date           DATETIME2(0) NOT NULL CONSTRAINT DF_PurchaseOrderItems_CreatedDate DEFAULT (SYSDATETIME()),
    Modified_Date          DATETIME2(0) NULL,

    CONSTRAINT PK_PurchaseOrderItems PRIMARY KEY (Purchase_Order_Item_ID),
    CONSTRAINT FK_PurchaseOrderItems_PurchaseOrders FOREIGN KEY (Purchase_Order_ID)
        REFERENCES dbo.Purchase_Orders (Purchase_Order_ID),
    CONSTRAINT FK_PurchaseOrderItems_Products FOREIGN KEY (Product_ID)
        REFERENCES dbo.Products (Product_ID),
    CONSTRAINT UQ_PurchaseOrderItems_Order_Product UNIQUE (Purchase_Order_ID, Product_ID),
    CONSTRAINT CK_PurchaseOrderItems_Quantity CHECK (Quantity_Ordered > 0),
    CONSTRAINT CK_PurchaseOrderItems_UnitCost CHECK (Unit_Cost >= 0)
);
GO

SELECT * FROM DBO.Purchase_Order_Items
GO

/*==============================================================
   RECEIVING
==============================================================*/

CREATE TABLE dbo.Goods_Receipts
(
    Goods_Receipt_ID          INT IDENTITY(1,1) NOT NULL,
    Purchase_Order_ID         INT NOT NULL,
    Warehouse_ID             SMALLINT NOT NULL,
    Received_By_Employee_ID    INT NOT NULL,
    Goods_Receipt_Code        VARCHAR(20) NOT NULL,
    Received_Date            DATETIME2(0) NOT NULL,
    Delivery_Note_Number      VARCHAR(30) NULL,
    Notes                   NVARCHAR(255) NULL,
    Created_Date             DATETIME2(0) NOT NULL CONSTRAINT DF_GoodsReceipts_CreatedDate DEFAULT (SYSDATETIME()),
    Modified_Date            DATETIME2(0) NULL,

    CONSTRAINT PK_GoodsReceipts PRIMARY KEY (Goods_Receipt_ID),
    CONSTRAINT FK_GoodsReceipts_PurchaseOrders FOREIGN KEY (Purchase_Order_ID)
        REFERENCES dbo.Purchase_Orders (Purchase_Order_ID),
    CONSTRAINT FK_GoodsReceipts_Warehouses FOREIGN KEY (Warehouse_ID)
        REFERENCES dbo.Warehouses (Warehouse_ID),
    CONSTRAINT FK_GoodsReceipts_Employees FOREIGN KEY (Received_By_Employee_ID)
        REFERENCES dbo.Employees (Employee_ID),
    CONSTRAINT UQ_GoodsReceipts_Code UNIQUE (Goods_Receipt_Code)
);
GO

SELECT * FROM DBO.Goods_Receipts
GO

CREATE TABLE dbo.Goods_Receipt_Items
(
    Goods_Receipt_Item_ID      BIGINT IDENTITY(1,1) NOT NULL,
    Goods_Receipt_ID          INT NOT NULL,
    Purchase_Order_Item_ID     BIGINT NOT NULL,
    Quantity_Received        INT NOT NULL,
    Quantity_Rejected        INT NOT NULL CONSTRAINT DF_GoodsReceiptItems_QuantityRejected DEFAULT (0),
    Rejection_Reason         NVARCHAR(255) NULL,
    Created_Date             DATETIME2(0) NOT NULL CONSTRAINT DF_GoodsReceiptItems_CreatedDate DEFAULT (SYSDATETIME()),
    Modified_Date            DATETIME2(0) NULL,

    CONSTRAINT PK_GoodsReceiptItems PRIMARY KEY (Goods_Receipt_Item_ID),
    CONSTRAINT FK_GoodsReceiptItems_GoodsReceipts FOREIGN KEY (Goods_Receipt_ID)
        REFERENCES dbo.Goods_Receipts (Goods_Receipt_ID),
    CONSTRAINT FK_GoodsReceiptItems_PurchaseOrderItems FOREIGN KEY (Purchase_Order_Item_ID)
        REFERENCES dbo.Purchase_Order_Items (Purchase_Order_Item_ID),
    CONSTRAINT CK_GoodsReceiptItems_Received CHECK (Quantity_Received >= 0),
    CONSTRAINT CK_GoodsReceiptItems_Rejected CHECK (Quantity_Rejected >= 0),
    CONSTRAINT CK_GoodsReceiptItems_Total CHECK (Quantity_Received + Quantity_Rejected > 0)
);
GO
SELECT * FROM DBO.Goods_Receipt_Items
GO

/*==============================================================
   WAREHOUSE INVENTORY
==============================================================*/

CREATE TABLE dbo.Warehouse_Inventory
(
    Warehouse_Inventory_ID   BIGINT IDENTITY(1,1) NOT NULL,
    Warehouse_ID            SMALLINT NOT NULL,
    Product_ID              INT NOT NULL,
    Current_Stock           INT NOT NULL CONSTRAINT DF_WarehouseInventory_CurrentStock DEFAULT (0),
    Reorder_Level           INT NOT NULL,
    Reorder_Quantity        INT NOT NULL,
    Last_Stock_Count_Date     DATE NULL,
    Created_Date            DATETIME2(0) NOT NULL CONSTRAINT DF_WarehouseInventory_CreatedDate DEFAULT (SYSDATETIME()),
    Modified_Date           DATETIME2(0) NULL,

    CONSTRAINT PK_WarehouseInventory PRIMARY KEY (Warehouse_Inventory_ID),
    CONSTRAINT FK_WarehouseInventory_Warehouses FOREIGN KEY (Warehouse_ID)
        REFERENCES dbo.Warehouses (Warehouse_ID),
    CONSTRAINT FK_WarehouseInventory_Products FOREIGN KEY (Product_ID)
        REFERENCES dbo.Products (Product_ID),
    CONSTRAINT UQ_WarehouseInventory_Warehouse_Product UNIQUE (Warehouse_ID, Product_ID),
    CONSTRAINT CK_WarehouseInventory_CurrentStock CHECK (Current_Stock >= 0),
    CONSTRAINT CK_WarehouseInventory_ReorderLevel CHECK (Reorder_Level >= 0),
    CONSTRAINT CK_WarehouseInventory_ReorderQuantity CHECK (Reorder_Quantity > 0)
);
GO
SELECT * FROM DBO.Warehouse_Inventory
GO

/*==============================================================
   SALES
==============================================================*/

CREATE TABLE dbo.Sales_Orders
(
    Sales_Order_ID             INT IDENTITY(1,1) NOT NULL,
    Customer_ID               INT NOT NULL,
    Warehouse_ID              SMALLINT NOT NULL,
    Sales_Rep_ID               INT NOT NULL,
    Sales_Order_Code           VARCHAR(20) NOT NULL,
    Order_Date                DATE NOT NULL,
    Required_Delivery_Date     DATE NOT NULL,
    Sales_Order_Status         VARCHAR(20) NOT NULL,
    Notes                    NVARCHAR(255) NULL,
    Created_Date              DATETIME2(0) NOT NULL CONSTRAINT DF_SalesOrders_CreatedDate DEFAULT (SYSDATETIME()),
    Modified_Date             DATETIME2(0) NULL,

    CONSTRAINT PK_SalesOrders PRIMARY KEY (Sales_Order_ID),
    CONSTRAINT FK_SalesOrders_Customers FOREIGN KEY (Customer_ID)
        REFERENCES dbo.Customers (Customer_ID),
    CONSTRAINT FK_SalesOrders_Warehouses FOREIGN KEY (Warehouse_ID)
        REFERENCES dbo.Warehouses (Warehouse_ID),
    CONSTRAINT FK_SalesOrders_Employees FOREIGN KEY (Sales_Rep_ID)
        REFERENCES dbo.Employees (Employee_ID),
    CONSTRAINT UQ_SalesOrders_Code UNIQUE (Sales_Order_Code),
    CONSTRAINT CK_SalesOrders_Dates CHECK (Required_Delivery_Date >= Order_Date),
    CONSTRAINT CK_SalesOrders_Status CHECK
    (
        Sales_Order_Status IN
        ('Draft','Confirmed','Processing','Partially Fulfilled','Fulfilled','Cancelled')
    )
);
GO
SELECT * FROM DBO.Sales_Orders
GO


CREATE TABLE dbo.Sales_Order_Items
(
    Sales_Order_Item_ID     BIGINT IDENTITY(1,1) NOT NULL,
    Sales_Order_ID         INT NOT NULL,
    Product_ID            INT NOT NULL,
    Quantity_Ordered      INT NOT NULL,
    Unit_Price            DECIMAL(18,2) NOT NULL,
    Discount_Percent      DECIMAL(5,2) NOT NULL CONSTRAINT DF_SalesOrderItems_Discount DEFAULT (0),
    Created_Date          DATETIME2(0) NOT NULL CONSTRAINT DF_SalesOrderItems_CreatedDate DEFAULT (SYSDATETIME()),
    Modified_Date         DATETIME2(0) NULL,

    CONSTRAINT PK_SalesOrderItems PRIMARY KEY (Sales_Order_Item_ID),
    CONSTRAINT FK_SalesOrderItems_SalesOrders FOREIGN KEY (Sales_Order_ID)
        REFERENCES dbo.Sales_Orders (Sales_Order_ID),
    CONSTRAINT FK_SalesOrderItems_Products FOREIGN KEY (Product_ID)
        REFERENCES dbo.Products (Product_ID),
    CONSTRAINT UQ_SalesOrderItems_Order_Product UNIQUE (Sales_Order_ID, Product_ID),
    CONSTRAINT CK_SalesOrderItems_Quantity CHECK (Quantity_Ordered > 0),
    CONSTRAINT CK_SalesOrderItems_UnitPrice CHECK (Unit_Price >= 0),
    CONSTRAINT CK_SalesOrderItems_Discount CHECK (Discount_Percent BETWEEN 0 AND 100)
);
GO
SELECT * FROM DBO.Sales_Order_Items
GO

CREATE TABLE dbo.Sales_Targets
(
    Sales_Target_ID     INT IDENTITY(1,1) NOT NULL,
    Employee_ID        INT NOT NULL,
    Target_Year        SMALLINT NOT NULL,
    Target_Month       TINYINT NOT NULL,
    Target_Amount      DECIMAL(18,2) NOT NULL,
    Created_Date       DATETIME2(0) NOT NULL CONSTRAINT DF_SalesTargets_CreatedDate DEFAULT (SYSDATETIME()),
    Modified_Date      DATETIME2(0) NULL,

    CONSTRAINT PK_SalesTargets PRIMARY KEY (Sales_Target_ID),
    CONSTRAINT FK_SalesTargets_Employees FOREIGN KEY (Employee_ID)
        REFERENCES dbo.Employees (Employee_ID),
    CONSTRAINT UQ_SalesTargets_Employee_Period UNIQUE (Employee_ID, Target_Year, Target_Month),
    CONSTRAINT CK_SalesTargets_Year CHECK (Target_Year BETWEEN 2000 AND 2100),
    CONSTRAINT CK_SalesTargets_Month CHECK (Target_Month BETWEEN 1 AND 12),
    CONSTRAINT CK_SalesTargets_Amount CHECK (Target_Amount >= 0)
);
GO
SELECT * FROM DBO.Sales_Targets
GO

/*==============================================================
   INVENTORY TRANSACTIONS
==============================================================*/

CREATE TABLE dbo.Inventory_Transactions
(
    Inventory_Transaction_ID   BIGINT IDENTITY(1,1) NOT NULL,
    Warehouse_ID              SMALLINT NOT NULL,
    Product_ID                INT NOT NULL,
    Performed_By_Employee_ID    INT NOT NULL,
    Transaction_Type          VARCHAR(30) NOT NULL,
    Quantity_Change           INT NOT NULL,
    Transaction_Date          DATETIME2(0) NOT NULL,
    Reference_Type            VARCHAR(30) NULL,
    Reference_ID              BIGINT NULL,
    Notes                    NVARCHAR(255) NULL,
    Created_Date              DATETIME2(0) NOT NULL CONSTRAINT DF_InventoryTransactions_CreatedDate DEFAULT (SYSDATETIME()),

    CONSTRAINT PK_InventoryTransactions PRIMARY KEY (Inventory_Transaction_ID),
    CONSTRAINT FK_InventoryTransactions_Warehouses FOREIGN KEY (Warehouse_ID)
        REFERENCES dbo.Warehouses (Warehouse_ID),
    CONSTRAINT FK_InventoryTransactions_Products FOREIGN KEY (Product_ID)
        REFERENCES dbo.Products (Product_ID),
    CONSTRAINT FK_InventoryTransactions_Employees FOREIGN KEY (Performed_By_Employee_ID)
        REFERENCES dbo.Employees (Employee_ID),
    CONSTRAINT CK_InventoryTransactions_Quantity CHECK (Quantity_Change <> 0),
    CONSTRAINT CK_InventoryTransactions_Type CHECK
    (
        Transaction_Type IN
        ('Goods Receipt','Sales Dispatch','Sales Return',
         'Stock Adjustment','Transfer In','Transfer Out','Supplier Return')
    )
);
GO
SELECT * FROM DBO.Inventory_Transactions
GO

/*==============================================================
   INDEXES
==============================================================*/

CREATE INDEX IX_States_RegionID
    ON dbo.States (Region_ID);

CREATE INDEX IX_Cities_StateID
    ON dbo.Cities (State_ID);

CREATE INDEX IX_Customers_CustomerTypeID
    ON dbo.Customers (Customer_Type_ID);

CREATE INDEX IX_Customers_CityID
    ON dbo.Customers (City_ID);

CREATE INDEX IX_Products_CategoryID
    ON dbo.Products (Category_ID);

CREATE INDEX IX_Products_BrandID
    ON dbo.Products (Brand_ID);

CREATE INDEX IX_Suppliers_CityID
    ON dbo.Suppliers (City_ID);

CREATE INDEX IX_Employees_DepartmentID
    ON dbo.Employees (Department_ID);

CREATE INDEX IX_Employees_CityID
    ON dbo.Employees (City_ID);

CREATE INDEX IX_PurchaseOrders_Supplier_OrderDate
    ON dbo.Purchase_Orders (Supplier_ID, Order_Date);

CREATE INDEX IX_PurchaseOrders_WarehouseID
    ON dbo.Purchase_Orders (Warehouse_ID);

CREATE INDEX IX_PurchaseOrderItems_ProductID
    ON dbo.Purchase_Order_Items (Product_ID);

CREATE INDEX IX_GoodsReceipts_PurchaseOrderID
    ON dbo.Goods_Receipts (Purchase_Order_ID);

CREATE INDEX IX_GoodsReceiptItems_PurchaseOrderItemID
    ON dbo.Goods_Receipt_Items (Purchase_Order_Item_ID);

CREATE INDEX IX_SalesOrders_Customer_OrderDate
    ON dbo.Sales_Orders (Customer_ID, Order_Date);

CREATE INDEX IX_SalesOrders_SalesRep_OrderDate
    ON dbo.Sales_Orders (Sales_Rep_ID, Order_Date);

CREATE INDEX IX_SalesOrderItems_ProductID
    ON dbo.Sales_Order_Items (Product_ID);

CREATE INDEX IX_InventoryTransactions_Warehouse_Product_Date
    ON dbo.Inventory_Transactions (Warehouse_ID, Product_ID, Transaction_Date);

GO

PRINT 'ApexMartDB schema created successfully.';
GO


/*==============================================================
  ApexMartDB Seed Data
==============================================================*/

USE ApexMartDB;
GO

SET NOCOUNT ON;
SET XACT_ABORT ON;
GO

BEGIN TRY
    BEGIN TRANSACTION;

      /*==========================================================
      GEOGRAPHY
    ==========================================================*/

    INSERT INTO dbo.Regions
        (Region_Name, Region_Code)
    VALUES
        (N'North Central', 'NC'),
        (N'North East',    'NE'),
        (N'North West',    'NW'),
        (N'South East',    'SE'),
        (N'South South',   'SS'),
        (N'South West',    'SW');
SELECT * FROM DBO.Regions
GO

INSERT INTO dbo.States
        (Region_ID, State_Name, State_Code)
    VALUES
        (4, N'Abia',        'ABI'),
        (2, N'Adamawa',     'ADA'),
        (5, N'Akwa Ibom',   'AKI'),
        (4, N'Anambra',     'ANA'),
        (2, N'Bauchi',      'BAU'),
        (5, N'Bayelsa',     'BAY'),
        (1, N'Benue',       'BEN'),
        (2, N'Borno',       'BOR'),
        (5, N'Cross River', 'CRS'),
        (5, N'Delta',       'DEL'),
        (4, N'Ebonyi',      'EBO'),
        (5, N'Edo',         'EDO'),
        (6, N'Ekiti',       'EKI'),
        (4, N'Enugu',       'ENU'),
        (1, N'FCT',         'FCT'),
        (2, N'Gombe',       'GOM'),
        (4, N'Imo',         'IMO'),
        (3, N'Jigawa',      'JIG'),
        (3, N'Kaduna',      'KAD'),
        (3, N'Kano',        'KAN'),
        (3, N'Katsina',     'KAT'),
        (3, N'Kebbi',       'KEB'),
        (1, N'Kogi',        'KOG'),
        (1, N'Kwara',       'KWA'),
        (6, N'Lagos',       'LAG'),
        (1, N'Nasarawa',    'NAS'),
        (1, N'Niger',       'NIG'),
        (6, N'Ogun',        'OGU'),
        (6, N'Ondo',        'OND'),
        (6, N'Osun',        'OSU'),
        (6, N'Oyo',         'OYO'),
        (1, N'Plateau',     'PLA'),
        (5, N'Rivers',      'RIV'),
        (3, N'Sokoto',      'SOK'),
        (2, N'Taraba',      'TAR'),
        (2, N'Yobe',        'YOB'),
        (3, N'Zamfara',     'ZAM');

        SELECT * FROM DBO.States
        GO

  INSERT INTO dbo.Cities 
        (State_ID, City_Name)
    SELECT s.State_ID, v.City_Name
    FROM (VALUES
        (N'Abia', N'Aba'),
        (N'Abia', N'Umuahia'),
        (N'Adamawa', N'Yola'),
        (N'Akwa Ibom', N'Uyo'),
        (N'Anambra', N'Awka'),
        (N'Anambra', N'Onitsha'),
        (N'Bauchi', N'Bauchi'),
        (N'Bayelsa', N'Yenagoa'),
        (N'Benue', N'Makurdi'),
        (N'Borno', N'Maiduguri'),
        (N'Cross River', N'Calabar'),
        (N'Delta', N'Asaba'),
        (N'Delta', N'Warri'),
        (N'Ebonyi', N'Abakaliki'),
        (N'Edo', N'Benin City'),
        (N'Ekiti', N'Ado-Ekiti'),
        (N'Enugu', N'Enugu'),
        (N'FCT', N'Abuja'),
        (N'Gombe', N'Gombe'),
        (N'Imo', N'Owerri'),
        (N'Jigawa', N'Dutse'),
        (N'Kaduna', N'Kaduna'),
        (N'Kaduna', N'Zaria'),
        (N'Kano', N'Kano'),
        (N'Katsina', N'Katsina'),
        (N'Kebbi', N'Birnin Kebbi'),
        (N'Kogi', N'Lokoja'),
        (N'Kwara', N'Ilorin'),
        (N'Lagos', N'Ikeja'),
        (N'Lagos', N'Lekki'),
        (N'Lagos', N'Badagry'),
        (N'Lagos', N'Epe'),
        (N'Nasarawa', N'Lafia'),
        (N'Nasarawa', N'Keffi'),
        (N'Niger', N'Minna'),
        (N'Ogun', N'Abeokuta'),
        (N'Ogun', N'Sagamu'),
        (N'Ondo', N'Akure'),
        (N'Osun', N'Osogbo'),
        (N'Oyo', N'Ibadan'),
        (N'Oyo', N'Ogbomoso'),
        (N'Plateau', N'Jos'),
        (N'Rivers', N'Port Harcourt'),
        (N'Rivers', N'Bonny'),
        (N'Sokoto', N'Sokoto'),
        (N'Taraba', N'Jalingo'),
        (N'Yobe', N'Damaturu'),
        (N'Zamfara', N'Gusau'),
        (N'Kogi', N'Okene'),
        (N'Benue', N'Otukpo')
    ) v(State_Name, City_Name)
    INNER JOIN dbo.States s
        ON s.State_Name = v.State_Name;
  SELECT * FROM DBO.Cities
  GO

  /*==========================================================
       CUSTOMER MANAGEMENT
    ==========================================================*/

    INSERT INTO dbo.Customer_Types
        (Customer_Type_Name, Description)
    VALUES
        (N'Wholesaler',        N'Bulk-buying trade customer'),
        (N'Supermarket',       N'Modern retail supermarket'),
        (N'Convenience Store', N'Small-format neighbourhood retail store'),
        (N'Pharmacy',          N'Pharmacy and health retail outlet'),
        (N'Hotel & Hospitality', N'Hotel, restaurant or hospitality business'),
        (N'Independent Retailer', N'Independent retail outlet');

        SELECT * FROM DBO.Customer_Types
        GO


    ;WITH N AS
(
    SELECT TOP (120)
           ROW_NUMBER() OVER (ORDER BY (SELECT NULL)) AS n
    FROM sys.all_objects
),
Customer_Source AS
(
    SELECT
        n,
        CASE ((n - 1) % 12) + 1
            WHEN 1 THEN N'Heritage'
            WHEN 2 THEN N'Greenfield'
            WHEN 3 THEN N'Prime'
            WHEN 4 THEN N'Unity'
            WHEN 5 THEN N'Sunrise'
            WHEN 6 THEN N'Royal'
            WHEN 7 THEN N'Olive'
            WHEN 8 THEN N'Northern Choice'
            WHEN 9 THEN N'Cedar'
            WHEN 10 THEN N'Bluecrest'
            WHEN 11 THEN N'Grand Oak'
            ELSE N'CityGate'
        END AS Name_Prefix,
        CASE ((n - 1) / 12) + 1
            WHEN 1 THEN N'Stores'
            WHEN 2 THEN N'Supermarket'
            WHEN 3 THEN N'Trading Company'
            WHEN 4 THEN N'Retail Mart'
            WHEN 5 THEN N'Wholesale Depot'
            WHEN 6 THEN N'Consumer Mart'
            WHEN 7 THEN N'Neighbourhood Stores'
            WHEN 8 THEN N'Food & More'
            WHEN 9 THEN N'Market Hub'
            ELSE N'Value Stores'
        END AS Name_Suffix,
        CASE ((n - 1) % 20) + 1
            WHEN 1 THEN N'Tunde' WHEN 2 THEN N'Chiamaka' WHEN 3 THEN N'Aisha'
            WHEN 4 THEN N'Emeka' WHEN 5 THEN N'Kemi' WHEN 6 THEN N'Ibrahim'
            WHEN 7 THEN N'Blessing' WHEN 8 THEN N'Seyi' WHEN 9 THEN N'Fatima'
            WHEN 10 THEN N'Daniel' WHEN 11 THEN N'Ngozi' WHEN 12 THEN N'Abdullahi'
            WHEN 13 THEN N'Tosin' WHEN 14 THEN N'Chinedu' WHEN 15 THEN N'Zainab'
            WHEN 16 THEN N'Femi' WHEN 17 THEN N'Amaka' WHEN 18 THEN N'Kunle'
            WHEN 19 THEN N'Halima' ELSE N'Osas'
        END AS First_Name,
        CASE ((n * 7 - 1) % 20) + 1
            WHEN 1 THEN N'Adebayo' WHEN 2 THEN N'Okafor' WHEN 3 THEN N'Bello'
            WHEN 4 THEN N'Nwosu' WHEN 5 THEN N'Adeyemi' WHEN 6 THEN N'Musa'
            WHEN 7 THEN N'Eze' WHEN 8 THEN N'Balogun' WHEN 9 THEN N'Abubakar'
            WHEN 10 THEN N'Etim' WHEN 11 THEN N'Lawal' WHEN 12 THEN N'Onyeka'
            WHEN 13 THEN N'Garba' WHEN 14 THEN N'Ogunleye' WHEN 15 THEN N'Umeh'
            WHEN 16 THEN N'Ajayi' WHEN 17 THEN N'Ibrahim' WHEN 18 THEN N'Ekanem'
            WHEN 19 THEN N'Obi' ELSE N'Edobor'
        END AS Last_Name,
        CASE ((n - 1) % 16) + 1
            WHEN 1 THEN N'Ahmadu Bello Way'
            WHEN 2 THEN N'Awolowo Road'
            WHEN 3 THEN N'Aba Road'
            WHEN 4 THEN N'Nnamdi Azikiwe Avenue'
            WHEN 5 THEN N'Airport Road'
            WHEN 6 THEN N'Ring Road'
            WHEN 7 THEN N'Broad Street'
            WHEN 8 THEN N'Adetokunbo Ademola Crescent'
            WHEN 9 THEN N'Independence Layout'
            WHEN 10 THEN N'Ikorodu Road'
            WHEN 11 THEN N'Kachia Road'
            WHEN 12 THEN N'Zaria Road'
            WHEN 13 THEN N'Murtala Mohammed Way'
            WHEN 14 THEN N'GRA Road'
            WHEN 15 THEN N'Ogui Road'
            ELSE N'Sapele Road'
        END AS Street_Name
    FROM N
)
INSERT INTO dbo.Customers
(
    Customer_Type_ID, City_ID, Customer_Code, Customer_Name,
    Contact_Person, Phone, Email, Address, Credit_Limit, Payment_Terms
)
SELECT
    ((n - 1) % 6) + 1,
    ((n - 1) % 50) + 1,
    CONCAT('CUS', RIGHT('0000' + CAST(n AS VARCHAR(4)), 4)),
    CONCAT(Name_Prefix, N' ', Name_Suffix),
    CONCAT(First_Name, N' ', Last_Name),
    CONCAT(
        CASE (n % 4)
            WHEN 0 THEN '0803'
            WHEN 1 THEN '0806'
            WHEN 2 THEN '0813'
            ELSE '0703'
        END,
        RIGHT('0000000' + CAST(1000000 + (n * 731) AS VARCHAR(7)), 7)
    ),
    LOWER(
        CONCAT(
            LEFT(First_Name, 1), '.', REPLACE(Last_Name, ' ', ''), '@',
            REPLACE(REPLACE(Name_Prefix, ' ', ''), '&', 'and'),
            REPLACE(REPLACE(Name_Suffix, ' ', ''), '&', 'and'),
            '.ng'
        )
    ),
    CONCAT(4 + ((n * 7) % 93), N' ', Street_Name),
    CAST(
        CASE ((n - 1) % 6) + 1
            WHEN 1 THEN 5000000
            WHEN 2 THEN 3500000
            WHEN 3 THEN 1200000
            WHEN 4 THEN 1800000
            WHEN 5 THEN 2500000
            ELSE 1000000
        END + ((n % 5) * 250000)
        AS DECIMAL(18,2)
    ),
    CASE ((n - 1) % 5)
        WHEN 0 THEN 0
        WHEN 1 THEN 7
        WHEN 2 THEN 14
        WHEN 3 THEN 30
        ELSE 60
    END
FROM Customer_Source;
GO
SELECT * FROM DBO.Customers

    /*==========================================================
       PRODUCT MANAGEMENT
    ==========================================================*/

      INSERT INTO dbo.Categories (Category_Name, Description)
    VALUES
        (N'Food',          N'Packaged food and staples'),
        (N'Beverages',     N'Water, soft drinks and malt beverages'),
        (N'Personal Care', N'Personal hygiene and grooming products'),
        (N'Household',     N'Cleaning and household products'),
        (N'Cooking',       N'Cooking oils, seasoning and ingredients'),
        (N'Baby Care',     N'Baby and infant care products');

        SELECT * FROM DBO.Categories

      INSERT INTO dbo.Brands (Brand_Name, Description)
    VALUES
        (N'Golden Harvest', N'Rice and staple foods'),
        (N'Prime Pasta', N'Pasta and noodles'),
        (N'AquaPure', N'Packaged drinking water'),
        (N'Viva Malt', N'Malt beverages'),
        (N'Zest', N'Carbonated beverages'),
        (N'FreshSmile', N'Oral care'),
        (N'SoftGlow', N'Bath and body care'),
        (N'BrightWash', N'Laundry care'),
        (N'HomeFresh', N'Household cleaning'),
        (N'NatureGold', N'Cooking oil'),
        (N'RichTaste', N'Cooking ingredients'),
        (N'Mama Choice', N'Seasoning products'),
        (N'TinyCare', N'Baby care'),
        (N'Daily Choice', N'Everyday grocery'),
        (N'Naija Fresh', N'Locally sourced FMCG');
        SELECT * FROM DBO.Brands

            INSERT INTO dbo.Units_Of_Measure
        (Unit_Name, Unit_Abbreviation)
    VALUES
        (N'Carton', 'CTN'),
        (N'Pack', 'PK'),
        (N'Bottle', 'BTL'),
        (N'Piece', 'PCS'),
        (N'Bag', 'BAG'),
        (N'Kilogram', 'KG'),
        (N'Litre', 'L'),
        (N'Dozen', 'DOZ');

        SELECT * FROM DBO.Units_Of_Measure

        INSERT INTO dbo.Products
(Category_ID,Brand_ID,Unit_ID,Product_Code,Product_Name,SKU,Barcode,Selling_Price)
VALUES
        (1,1,5,'PRD0001',N'Golden Harvest Premium Parboiled Rice 10kg','SKU-00001','615100000001',18500.00),
        (1,1,5,'PRD0002',N'Golden Harvest Premium Parboiled Rice 25kg','SKU-00002','615100000002',43500.00),
        (1,1,5,'PRD0003',N'Golden Harvest Ofada Rice 5kg','SKU-00003','615100000003',11200.00),
        (1,1,5,'PRD0004',N'Golden Harvest Brown Rice 5kg','SKU-00004','615100000004',9800.00),
        (1,2,2,'PRD0005',N'Prime Pasta Spaghetti 500g Pack','SKU-00005','615100000005',1450.00),
        (1,2,2,'PRD0006',N'Prime Pasta Macaroni 500g Pack','SKU-00006','615100000006',1500.00),
        (1,2,2,'PRD0007',N'Prime Pasta Noodles Chicken 120g Pack','SKU-00007','615100000007',650.00),
        (1,2,1,'PRD0008',N'Prime Pasta Spaghetti 20 x 500g Carton','SKU-00008','615100000008',27500.00),
        (2,3,3,'PRD0009',N'AquaPure Table Water 75cl Bottle','SKU-00009','615100000009',350.00),
        (2,3,1,'PRD0010',N'AquaPure Table Water 12 x 75cl Carton','SKU-00010','615100000010',3900.00),
        (2,3,3,'PRD0011',N'AquaPure Table Water 1.5L Bottle','SKU-00011','615100000011',600.00),
        (2,3,1,'PRD0012',N'AquaPure Table Water 12 x 1.5L Carton','SKU-00012','615100000012',6800.00),
        (2,4,3,'PRD0013',N'Viva Malt Classic 33cl Bottle','SKU-00013','615100000013',550.00),
        (2,4,1,'PRD0014',N'Viva Malt Classic 24 x 33cl Carton','SKU-00014','615100000014',12400.00),
        (2,4,3,'PRD0015',N'Viva Malt Dark 33cl Bottle','SKU-00015','615100000015',600.00),
        (2,4,1,'PRD0016',N'Viva Malt Dark 24 x 33cl Carton','SKU-00016','615100000016',13500.00),
        (2,5,3,'PRD0017',N'Zest Cola 50cl Bottle','SKU-00017','615100000017',450.00),
        (2,5,1,'PRD0018',N'Zest Cola 12 x 50cl Carton','SKU-00018','615100000018',5100.00),
        (2,5,3,'PRD0019',N'Zest Orange 50cl Bottle','SKU-00019','615100000019',450.00),
        (2,5,1,'PRD0020',N'Zest Orange 12 x 50cl Carton','SKU-00020','615100000020',5100.00),
        (3,6,4,'PRD0021',N'FreshSmile Herbal Toothpaste 140g','SKU-00021','615100000021',1800.00),
        (3,6,1,'PRD0022',N'FreshSmile Herbal Toothpaste 24 x 140g Carton','SKU-00022','615100000022',40500.00),
        (3,6,4,'PRD0023',N'FreshSmile Fresh Mint Toothpaste 140g','SKU-00023','615100000023',1900.00),
        (3,6,4,'PRD0024',N'FreshSmile Medium Toothbrush','SKU-00024','615100000024',950.00),
        (3,7,4,'PRD0025',N'SoftGlow Beauty Soap 120g','SKU-00025','615100000025',900.00),
        (3,7,2,'PRD0026',N'SoftGlow Beauty Soap 6-Pack','SKU-00026','615100000026',5100.00),
        (3,7,4,'PRD0027',N'SoftGlow Body Lotion 400ml','SKU-00027','615100000027',4200.00),
        (3,7,4,'PRD0028',N'SoftGlow Petroleum Jelly 250ml','SKU-00028','615100000028',2600.00),
        (4,8,2,'PRD0029',N'BrightWash Detergent Powder 1kg Pack','SKU-00029','615100000029',3200.00),
        (4,8,5,'PRD0030',N'BrightWash Detergent Powder 5kg Bag','SKU-00030','615100000030',14800.00),
        (4,8,4,'PRD0031',N'BrightWash Laundry Bar 250g','SKU-00031','615100000031',750.00),
        (4,8,1,'PRD0032',N'BrightWash Laundry Bar 48 x 250g Carton','SKU-00032','615100000032',33800.00),
        (4,9,3,'PRD0033',N'HomeFresh Multipurpose Cleaner 1L','SKU-00033','615100000033',2900.00),
        (4,9,3,'PRD0034',N'HomeFresh Bleach 1L','SKU-00034','615100000034',2200.00),
        (4,9,4,'PRD0035',N'HomeFresh Air Freshener 300ml','SKU-00035','615100000035',3500.00),
        (4,9,2,'PRD0036',N'HomeFresh Scouring Powder 500g Pack','SKU-00036','615100000036',1700.00),
        (5,10,3,'PRD0037',N'NatureGold Vegetable Oil 1L Bottle','SKU-00037','615100000037',3600.00),
        (5,10,3,'PRD0038',N'NatureGold Vegetable Oil 5L Bottle','SKU-00038','615100000038',17200.00),
        (5,10,1,'PRD0039',N'NatureGold Vegetable Oil 12 x 1L Carton','SKU-00039','615100000039',40800.00),
        (5,10,3,'PRD0040',N'NatureGold Palm Oil 2L Bottle','SKU-00040','615100000040',6200.00),
        (5,11,4,'PRD0041',N'RichTaste Tomato Paste 400g Tin','SKU-00041','615100000041',1900.00),
        (5,11,2,'PRD0042',N'RichTaste Tomato Paste 6 x 400g Pack','SKU-00042','615100000042',10800.00),
        (5,11,4,'PRD0043',N'RichTaste Curry Powder 100g','SKU-00043','615100000043',850.00),
        (5,11,4,'PRD0044',N'RichTaste Thyme 100g','SKU-00044','615100000044',900.00),
        (5,12,2,'PRD0045',N'Mama Choice Chicken Seasoning 100g Pack','SKU-00045','615100000045',750.00),
        (5,12,2,'PRD0046',N'Mama Choice Beef Seasoning 100g Pack','SKU-00046','615100000046',750.00),
        (5,12,1,'PRD0047',N'Mama Choice Chicken Seasoning 40-Pack Carton','SKU-00047','615100000047',28500.00),
        (5,12,1,'PRD0048',N'Mama Choice Beef Seasoning 40-Pack Carton','SKU-00048','615100000048',28500.00),
        (6,13,2,'PRD0049',N'TinyCare Baby Diapers Small 40-Pack','SKU-00049','615100000049',8900.00),
        (6,13,2,'PRD0050',N'TinyCare Baby Diapers Medium 36-Pack','SKU-00050','615100000050',9300.00),
        (6,13,2,'PRD0051',N'TinyCare Baby Wipes 80-Sheet Pack','SKU-00051','615100000051',2400.00),
        (6,13,4,'PRD0052',N'TinyCare Baby Lotion 400ml','SKU-00052','615100000052',3900.00),
        (1,14,2,'PRD0053',N'Daily Choice Custard Vanilla 1kg Pack','SKU-00053','615100000053',3100.00),
        (1,14,2,'PRD0054',N'Daily Choice Oats 500g Pack','SKU-00054','615100000054',2800.00),
        (1,14,5,'PRD0055',N'Daily Choice Beans 5kg Bag','SKU-00055','615100000055',10500.00),
        (1,14,2,'PRD0056',N'Daily Choice Corn Flakes 500g Pack','SKU-00056','615100000056',4200.00),
        (1,15,2,'PRD0057',N'Naija Fresh Garri Ijebu 2kg Pack','SKU-00057','615100000057',4200.00),
        (1,15,2,'PRD0058',N'Naija Fresh Yellow Garri 2kg Pack','SKU-00058','615100000058',3900.00),
        (1,15,5,'PRD0059',N'Naija Fresh Honey Beans 5kg Bag','SKU-00059','615100000059',12800.00),
        (1,15,2,'PRD0060',N'Naija Fresh Groundnut 500g Pack','SKU-00060','615100000060',2600.00);
        SELECT * FROM DBO.Products

        
    /*==========================================================
       SUPPLIERS
    ==========================================================*/
INSERT INTO dbo.Suppliers
(City_ID,Supplier_Code,Supplier_Name,Contact_Person,Phone,Email,Address,Payment_Terms)
SELECT c.City_ID,v.Supplier_Code,v.Supplier_Name,v.Contact_Person,v.Phone,v.Email,v.Address,v.Payment_Terms
FROM (VALUES
        (N'Ikeja','SUP001',N'Atlantic Foods Distribution Ltd',N'Tunde Akinwale','08061234001','sales@atlanticfoods.ng',N'18 Acme Road, Ogba',30),
        (N'Ikeja','SUP002',N'Prime Consumer Products Ltd',N'Bola Ogunleye','08061234002','orders@primeconsumer.ng',N'42 Oba Akran Avenue, Ikeja',30),
        (N'Kano','SUP003',N'Arewa Wholesale Ventures Ltd',N'Ibrahim Garba','08061234003','supply@arewawholesale.ng',N'15 Bompai Road, Kano',14),
        (N'Abuja','SUP004',N'Unity FMCG Supplies Ltd',N'Aisha Mohammed','08061234004','orders@unityfmcg.ng',N'27 Idu Industrial Area, Abuja',30),
        (N'Port Harcourt','SUP005',N'Riverside Consumer Goods Ltd',N'Chinedu Eze','08061234005','sales@riversidegoods.ng',N'11 Trans Amadi Road, Port Harcourt',30),
        (N'Enugu','SUP006',N'Eastern Trade Partners Ltd',N'Ngozi Okafor','08061234006','orders@easterntrade.ng',N'9 Emene Industrial Layout, Enugu',14),
        (N'Ibadan','SUP007',N'Heritage Foods & Commodities Ltd',N'Kemi Adeyemi','08061234007','sales@heritagefoods.ng',N'33 Oluyole Industrial Estate, Ibadan',30),
        (N'Kaduna','SUP008',N'NorthGate Distribution Services Ltd',N'Musa Abdullahi','08061234008','orders@northgate.ng',N'21 Kakuri Industrial Area, Kaduna',14),
        (N'Benin City','SUP009',N'Crown Consumer Products Ltd',N'Osas Eghosa','08061234009','trade@crownconsumer.ng',N'14 Sapele Road, Benin City',30),
        (N'Aba','SUP010',N'SouthEast Merchants Ltd',N'Emeka Nwosu','08061234010','sales@southeastmerchants.ng',N'31 Factory Road, Aba',14),
        (N'Ilorin','SUP011',N'Royal Choice Distribution Ltd',N'Seyi Lawal','08061234011','orders@royalchoice.ng',N'8 Asa Dam Road, Ilorin',30),
        (N'Abeokuta','SUP012',N'Gateway Consumer Supplies Ltd',N'Tosin Ajayi','08061234012','sales@gatewayconsumer.ng',N'25 Quarry Road, Abeokuta',30),
        (N'Akure','SUP013',N'Sunrise Trade & Logistics Ltd',N'Femi Adebayo','08061234013','orders@sunrisetrade.ng',N'16 Oyemekun Road, Akure',14),
        (N'Jos','SUP014',N'Plateau Wholesale Network Ltd',N'Daniel Pam','08061234014','sales@plateauwholesale.ng',N'12 Yakubu Gowon Way, Jos',30),
        (N'Uyo','SUP015',N'Coastal Consumer Distribution Ltd',N'Blessing Etim','08061234015','orders@coastalconsumer.ng',N'19 Oron Road, Uyo',30),
        (N'Calabar','SUP016',N'CrossRiver Trade House Ltd',N'Aniekan Bassey','08061234016','sales@crossrivertrade.ng',N'7 Murtala Mohammed Highway, Calabar',14),
        (N'Owerri','SUP017',N'Heartland FMCG Partners Ltd',N'Chika Umeh','08061234017','orders@heartlandfmcg.ng',N'22 Wetheral Road, Owerri',30),
        (N'Ado-Ekiti','SUP018',N'Ekiti Value Distributors Ltd',N'Kunle Ojo','08061234018','sales@ekitivalue.ng',N'10 Adebayo Road, Ado-Ekiti',30),
        (N'Minna','SUP019',N'Niger Central Supplies Ltd',N'Halima Sani','08061234019','orders@nigercentral.ng',N'13 Bosso Road, Minna',14),
        (N'Lokoja','SUP020',N'Confluence Trade Depot Ltd',N'Yusuf Bello','08061234020','sales@confluencetrade.ng',N'6 Ganaja Road, Lokoja',30),
        (N'Makurdi','SUP021',N'Benue Market Link Ltd',N'Terna Iorfa','08061234021','orders@benuemarketlink.ng',N'24 New Otukpo Road, Makurdi',14),
        (N'Yola','SUP022',N'Adamawa Consumer Network Ltd',N'Amina Sule','08061234022','sales@adamawaconsumer.ng',N'17 Jimeta Road, Yola',30),
        (N'Maiduguri','SUP023',N'Sahel Trade Partners Ltd',N'Zainab Bukar','08061234023','orders@saheltrade.ng',N'20 Baga Road, Maiduguri',14),
        (N'Warri','SUP024',N'Delta Merchants & Supply Ltd',N'Ese Ovie','08061234024','sales@deltamerchants.ng',N'28 Effurun-Sapele Road, Warri',30),
        (N'Lafia','SUP025',N'Nasarawa Distribution Hub Ltd',N'Abdullahi Adamu','08061234025','orders@nasarawahub.ng',N'11 Jos Road, Lafia',30)
) v(City_Name,Supplier_Code,Supplier_Name,Contact_Person,Phone,Email,Address,Payment_Terms)
JOIN dbo.Cities c ON c.City_Name=v.City_Name;

SELECT * FROM DBO.Suppliers

    /*==========================================================
       ORGANIZATION
    ==========================================================*/

    INSERT INTO dbo.Departments (Department_Name, Description)
    VALUES
        (N'Warehouse Operations', N'Warehouse receiving, storage and stock control'),
        (N'Sales', N'Customer acquisition and sales management'),
        (N'Procurement', N'Supplier management and purchasing'),
        (N'Finance', N'Finance and commercial control'),
        (N'Customer Service', N'Customer support and issue resolution'),
        (N'Business Intelligence', N'Reporting, analytics and decision support');
        SELECT * FROM DBO.Departments

          /*  warehouse operations employees */
    INSERT INTO dbo.Employees
    (
        Department_ID, City_ID, Employee_Code,
        First_Name, Last_Name, Phone, Email, Hire_Date, Job_Title
    )
    VALUES
        (1,18,'EMP001',N'Amina',N'Bello','08030000001','amina.bello@apexmart.ng','2022-02-14',N'Warehouse Manager'),
        (1,29,'EMP002',N'Kunle',N'Adeyemi','08030000002','kunle.adeyemi@apexmart.ng','2021-08-09',N'Warehouse Manager'),
        (1,24,'EMP003',N'Musa',N'Ibrahim','08030000003','musa.ibrahim@apexmart.ng','2022-06-01',N'Warehouse Manager'),
        (1,43,'EMP004',N'Chinedu',N'Okafor','08030000004','chinedu.okafor@apexmart.ng','2020-11-23',N'Warehouse Manager'),
        (1,17,'EMP005',N'Ngozi',N'Eze','08030000005','ngozi.eze@apexmart.ng','2023-01-16',N'Warehouse Manager'),
        (1,40,'EMP006',N'Tosin',N'Ajayi','08030000006','tosin.ajayi@apexmart.ng','2021-04-05',N'Warehouse Manager'),
        (1,22,'EMP007',N'Fatima',N'Yusuf','08030000007','fatima.yusuf@apexmart.ng','2022-09-12',N'Warehouse Manager'),
        (1,15,'EMP008',N'Osas',N'Edobor','08030000008','osas.edobor@apexmart.ng','2023-03-20',N'Warehouse Manager');
    
      /*  sales representatives */
    INSERT INTO dbo.Employees
    (
        Department_ID, City_ID, Employee_Code,
        First_Name, Last_Name, Phone, Email, Hire_Date, Job_Title
    )
    VALUES
        (2,18,'EMP009',N'David',N'Okoro','08030000009','david.okoro@apexmart.ng','2023-02-01',N'Sales Representative'),
        (2,29,'EMP010',N'Bisi',N'Olowu','08030000010','bisi.olowu@apexmart.ng','2022-05-11',N'Sales Representative'),
        (2,24,'EMP011',N'Yusuf',N'Garba','08030000011','yusuf.garba@apexmart.ng','2023-04-17',N'Sales Representative'),
        (2,43,'EMP012',N'Kelechi',N'Nwosu','08030000012','kelechi.nwosu@apexmart.ng','2021-10-04',N'Sales Representative'),
        (2,17,'EMP013',N'Amaka',N'Onyeka','08030000013','amaka.onyeka@apexmart.ng','2022-07-25',N'Sales Representative'),
        (2,40,'EMP014',N'Seyi',N'Balogun','08030000014','seyi.balogun@apexmart.ng','2021-12-06',N'Sales Representative'),
        (2,22,'EMP015',N'Zainab',N'Muhammad','08030000015','zainab.muhammad@apexmart.ng','2023-06-19',N'Sales Representative'),
        (2,15,'EMP016',N'Emeka',N'Ezeani','08030000016','emeka.ezeani@apexmart.ng','2022-03-14',N'Sales Representative'),
        (2,28,'EMP017',N'Halima',N'Abubakar','08030000017','halima.abubakar@apexmart.ng','2023-08-07',N'Sales Representative'),
        (2,42,'EMP018',N'Femi',N'Ogunleye','08030000018','femi.ogunleye@apexmart.ng','2021-06-21',N'Sales Representative');

         /*  procurement employees */
    INSERT INTO dbo.Employees
    (
        Department_ID, City_ID, Employee_Code,
        First_Name, Last_Name, Phone, Email, Hire_Date, Job_Title
    )
    VALUES
        (3,18,'EMP019',N'Fatima',N'Bello','08030000019','fatima.bello@apexmart.ng','2020-04-06',N'Procurement Officer'),
        (3,29,'EMP020',N'Chika',N'Umeh','08030000020','chika.umeh@apexmart.ng','2022-01-10',N'Procurement Officer'),
        (3,24,'EMP021',N'Abdullahi',N'Sani','08030000021','abdullahi.sani@apexmart.ng','2021-05-31',N'Procurement Officer'),
        (3,43,'EMP022',N'Blessing',N'Etim','08030000022','blessing.etim@apexmart.ng','2023-02-20',N'Procurement Officer'),
        (3,17,'EMP023',N'Chisom',N'Obi','08030000023','chisom.obi@apexmart.ng','2022-11-14',N'Procurement Officer');

        
    /*  employees across remaining departments */
        INSERT INTO dbo.Employees
(Department_ID,City_ID,Employee_Code,First_Name,Last_Name,Phone,Email,Hire_Date,Job_Title)
SELECT v.Department_ID,c.City_ID,v.Employee_Code,v.First_Name,v.Last_Name,v.Phone,v.Email,v.Hire_Date,v.Job_Title
FROM (VALUES
        (4,N'Abuja','EMP024',N'Tosin',N'Adebayo','08040000024','tosin.adebayo@apexmart.ng','2022-04-11',N'Finance Analyst'),
        (5,N'Ikeja','EMP025',N'Chiamaka',N'Obi','08040000025','chiamaka.obi@apexmart.ng','2023-01-09',N'Customer Service Officer'),
        (6,N'Abuja','EMP026',N'David',N'Etim','08040000026','david.etim@apexmart.ng','2022-08-15',N'BI Analyst'),
        (4,N'Ikeja','EMP027',N'Kemi',N'Balogun','08040000027','kemi.balogun@apexmart.ng','2021-06-07',N'Finance Analyst'),
        (5,N'Kano','EMP028',N'Aisha',N'Musa','08040000028','aisha.musa@apexmart.ng','2023-03-13',N'Customer Service Officer'),
        (6,N'Ikeja','EMP029',N'Femi',N'Ogunleye','08040000029','femi.ogunleye.bi@apexmart.ng','2022-10-03',N'BI Analyst'),
        (4,N'Port Harcourt','EMP030',N'Blessing',N'Ekanem','08040000030','blessing.ekanem@apexmart.ng','2020-11-02',N'Finance Analyst'),
        (5,N'Enugu','EMP031',N'Ngozi',N'Okeke','08040000031','ngozi.okeke@apexmart.ng','2023-04-24',N'Customer Service Officer'),
        (6,N'Abuja','EMP032',N'Seyi',N'Lawal','08040000032','seyi.lawal@apexmart.ng','2021-09-20',N'BI Analyst'),
        (4,N'Ibadan','EMP033',N'Kunle',N'Adekunle','08040000033','kunle.adekunle@apexmart.ng','2022-02-14',N'Finance Analyst'),
        (5,N'Kaduna','EMP034',N'Halima',N'Abubakar','08040000034','halima.abubakar.cs@apexmart.ng','2023-05-08',N'Customer Service Officer'),
        (6,N'Ikeja','EMP035',N'Amaka',N'Nwankwo','08040000035','amaka.nwankwo@apexmart.ng','2022-07-18',N'BI Analyst'),
        (4,N'Benin City','EMP036',N'Osas',N'Edobor','08040000036','osas.edobor.finance@apexmart.ng','2021-12-06',N'Finance Analyst'),
        (5,N'Abeokuta','EMP037',N'Tunde',N'Ajayi','08040000037','tunde.ajayi@apexmart.ng','2023-06-12',N'Customer Service Officer'),
        (6,N'Abuja','EMP038',N'Fatima',N'Bello','08040000038','fatima.bello.bi@apexmart.ng','2022-05-23',N'BI Analyst'),
        (4,N'Ilorin','EMP039',N'Chinedu',N'Okafor','08040000039','chinedu.okafor.finance@apexmart.ng','2021-03-29',N'Finance Analyst'),
        (5,N'Jos','EMP040',N'Zainab',N'Garba','08040000040','zainab.garba@apexmart.ng','2023-07-17',N'Customer Service Officer')
) v(Department_ID,City_Name,Employee_Code,First_Name,Last_Name,Phone,Email,Hire_Date,Job_Title)
JOIN dbo.Cities c ON c.City_Name=v.City_Name;

SELECT * FROM DBO.Employees

  INSERT INTO dbo.Warehouses
    (
        City_ID, Manager_ID, Warehouse_Code, Warehouse_Name, Address
    )
    VALUES
        (18,1,'WH-ABJ','Abuja Central Warehouse',N'Idu Industrial District, Abuja'),
        (29,2,'WH-LAG','Lagos Mainland Warehouse',N'Ikeja Industrial Estate, Lagos'),
        (24,3,'WH-KAN','Kano Regional Warehouse',N'Bompai Industrial Area, Kano'),
        (43,4,'WH-PHC','Port Harcourt Warehouse',N'Trans Amadi Industrial Layout, Port Harcourt'),
        (17,5,'WH-ENU','Enugu Regional Warehouse',N'Emene Industrial Layout, Enugu'),
        (40,6,'WH-IBD','Ibadan Regional Warehouse',N'Oluyole Industrial Estate, Ibadan'),
        (22,7,'WH-KAD','Kaduna Regional Warehouse',N'Kakuri Industrial Area, Kaduna'),
        (15,8,'WH-BEN','Benin Regional Warehouse',N'Sapele Road Industrial Area, Benin City');
        SELECT * FROM DBO.Warehouses

    /*==========================================================
       PROCUREMENT 
    ==========================================================*/

    ;WITH N AS
(
    SELECT TOP (100)
           ROW_NUMBER() OVER (ORDER BY (SELECT NULL)) AS n
    FROM sys.all_objects
)
INSERT INTO dbo.Purchase_Orders
(
    Supplier_ID,
    Warehouse_ID,
    Created_By_Employee_ID,
    Purchase_Order_Code,
    Order_Date,
    Expected_Delivery_Date,
    Purchase_Order_Status,
    Notes
)
SELECT
    ((n - 1) % 25) + 1,
    ((n - 1) % 8) + 1,
    19 + ((n - 1) % 5),
    CONCAT('PO-', RIGHT('00000' + CAST(n AS VARCHAR(5)), 5)),
    DATEADD(DAY, (n - 1) * 2, CAST('2025-07-01' AS DATE)),
    DATEADD(DAY, ((n - 1) * 2) + 7 + (n % 8), CAST('2025-07-01' AS DATE)),
    CASE
        WHEN n <= 80 THEN 'Received'
        WHEN n <= 90 THEN 'Approved'
        WHEN n <= 95 THEN 'Submitted'
        ELSE 'Cancelled'
    END,
    CASE
        WHEN n % 10 = 0 THEN N'Priority replenishment order'
        WHEN n % 17 = 0 THEN N'Quarter-end stock replenishment'
        ELSE NULL
    END
FROM N;
GO
SELECT * FROM dbo.Purchase_Orders

   /* Purchase_order_items*/

;WITH Purchase_Order_Category AS
(
    SELECT
        po.Purchase_Order_ID,
        po.Supplier_ID,

        CASE
            WHEN po.Supplier_ID BETWEEN 1 AND 4 THEN 1
            WHEN po.Supplier_ID BETWEEN 5 AND 8 THEN 2
            WHEN po.Supplier_ID BETWEEN 9 AND 12 THEN 3
            WHEN po.Supplier_ID BETWEEN 13 AND 16 THEN 4
            WHEN po.Supplier_ID BETWEEN 17 AND 20 THEN 5
            ELSE ((po.Purchase_Order_ID - 1) % 6) + 1
        END AS Required_Category_ID

    FROM dbo.Purchase_Orders po
),

Eligible_Products AS
(
    SELECT
        poc.Purchase_Order_ID,
        p.Product_ID,
        p.Selling_Price,

        ROW_NUMBER() OVER
        (
            PARTITION BY poc.Purchase_Order_ID
            ORDER BY ABS(CHECKSUM(poc.Purchase_Order_ID, p.Product_ID))
        ) AS Product_Rank

    FROM Purchase_Order_Category poc

    INNER JOIN dbo.Products p
        ON p.Category_ID = poc.Required_Category_ID
       AND p.Is_Active = 1
)

INSERT INTO dbo.Purchase_Order_Items
(
    Purchase_Order_ID,
    Product_ID,
    Quantity_Ordered,
    Unit_Cost
)

SELECT
    Purchase_Order_ID,
    Product_ID,

    60 + ((Purchase_Order_ID * (Product_Rank + 3)) % 180)
        AS Quantity_Ordered,

    CAST
    (
        Selling_Price *
        CASE
            WHEN Product_Rank = 1 THEN 0.72
            ELSE 0.76
        END

        AS DECIMAL(18,2)
    ) AS Unit_Cost

FROM Eligible_Products
WHERE Product_Rank <= 2;

SELECT * FROM dbo.Purchase_Order_Items

 /*==============================================================
   GOODS RECEIPTS

==============================================================*/

INSERT INTO dbo.Goods_Receipts
(
    Purchase_Order_ID,
    Warehouse_ID,
    Received_By_Employee_ID,
    Goods_Receipt_Code,
    Received_Date,
    Delivery_Note_Number,
    Notes
)
SELECT
    po.Purchase_Order_ID,
    po.Warehouse_ID,

    /* Warehouse managers are Employees 1-8 and aligned to Warehouses 1-8 */
    po.Warehouse_ID AS Received_By_Employee_ID,

    CONCAT('GR-', RIGHT('00000' + CAST(po.Purchase_Order_ID AS VARCHAR(5)), 5)),

    DATEADD
    (
        DAY,
        po.Purchase_Order_ID % 4,
        CAST(po.Expected_Delivery_Date AS DATETIME2(0))
    ),

    CONCAT('DN-', RIGHT('00000' + CAST(po.Purchase_Order_ID AS VARCHAR(5)), 5)),

    CASE
        WHEN po.Purchase_Order_ID % 13 = 0
            THEN N'Some units rejected during inspection'
        ELSE NULL
    END
FROM dbo.Purchase_Orders po
WHERE po.Purchase_Order_Status = 'Received';
GO

SELECT * FROM dbo.Goods_Receipts
GO


/ GOODS RECEIPT ITEMS/

INSERT INTO dbo.Goods_Receipt_Items
(
    Goods_Receipt_ID,
    Purchase_Order_Item_ID,
    Quantity_Received,
    Quantity_Rejected,
    Rejection_Reason
)
SELECT
    gr.Goods_Receipt_ID,
    poi.Purchase_Order_Item_ID,

    CASE
        WHEN gr.Goods_Receipt_ID % 13 = 0
            THEN poi.Quantity_Ordered - 2
        ELSE poi.Quantity_Ordered
    END,

    CASE
        WHEN gr.Goods_Receipt_ID % 13 = 0 THEN 2
        ELSE 0
    END,

    CASE
        WHEN gr.Goods_Receipt_ID % 13 = 0
            THEN N'Damaged packaging'
        ELSE NULL
    END

FROM dbo.Goods_Receipts gr
INNER JOIN dbo.Purchase_Order_Items poi
    ON poi.Purchase_Order_ID = gr.Purchase_Order_ID;
GO
SELECT * FROM dbo.Goods_Receipt_Items
GO


/*==============================================================
  WAREHOUSE INVENTORY

==============================================================*/

INSERT INTO dbo.Warehouse_Inventory
(
    Warehouse_ID,
    Product_ID,
    Current_Stock,
    Reorder_Level,
    Reorder_Quantity,
    Last_Stock_Count_Date
)
SELECT
    gr.Warehouse_ID,
    poi.Product_ID,

    SUM(gri.Quantity_Received) AS Current_Stock,

    /* Warehouse-product-specific stock policies */
    30 + ((gr.Warehouse_ID * 7 + poi.Product_ID) % 40) AS Reorder_Level,

    80 + ((gr.Warehouse_ID * 11 + poi.Product_ID) % 120) AS Reorder_Quantity,

    DATEADD
    (
        DAY,
        -((gr.Warehouse_ID * 5 + poi.Product_ID) % 30),
        CAST('2026-06-30' AS DATE)
    )

FROM dbo.Goods_Receipt_Items gri
INNER JOIN dbo.Goods_Receipts gr
    ON gr.Goods_Receipt_ID = gri.Goods_Receipt_ID
INNER JOIN dbo.Purchase_Order_Items poi
    ON poi.Purchase_Order_Item_ID = gri.Purchase_Order_Item_ID

GROUP BY
    gr.Warehouse_ID,
    poi.Product_ID;
GO
SELECT * FROM dbo.Warehouse_Inventory
GO

/*==============================================================
  SALES ORDERS
==============================================================*/

;WITH N AS
(
    SELECT TOP (150)
           ROW_NUMBER() OVER (ORDER BY (SELECT NULL)) AS n
    FROM sys.all_objects
)
INSERT INTO dbo.Sales_Orders
(
    Customer_ID,
    Warehouse_ID,
    Sales_Rep_ID,
    Sales_Order_Code,
    Order_Date,
    Required_Delivery_Date,
    Sales_Order_Status,
    Notes
)
SELECT
    ((n - 1) % 120) + 1,

    ((n - 1) % 8) + 1,

    9 + ((n - 1) % 10),

    CONCAT('SO-', RIGHT('00000' + CAST(n AS VARCHAR(5)), 5)),

    DATEADD(DAY, (n - 1) * 2, CAST('2025-07-15' AS DATE)),

    DATEADD
    (
        DAY,
        ((n - 1) * 2) + 3 + (n % 5),
        CAST('2025-07-15' AS DATE)
    ),

    CASE
        WHEN n % 20 = 0 THEN 'Cancelled'
        WHEN n % 9 = 0 THEN 'Processing'
        WHEN n % 7 = 0 THEN 'Partially Fulfilled'
        ELSE 'Fulfilled'
    END,

    CASE
        WHEN n % 17 = 0 THEN N'Priority customer order'
        ELSE NULL
    END

FROM N;
GO
SELECT * FROM dbo.Sales_Orders
GO


/*==============================================================
   SALES ORDER ITEMS
  
==============================================================*/

;WITH Eligible_Products AS
(
    SELECT
        so.Sales_Order_ID,
        so.Warehouse_ID,
        wi.Product_ID,
        p.Selling_Price,

        ROW_NUMBER() OVER
        (
            PARTITION BY so.Sales_Order_ID
            ORDER BY ABS
            (
                CHECKSUM
                (
                    so.Sales_Order_ID,
                    wi.Product_ID
                )
            )
        ) AS Product_Rank

    FROM dbo.Sales_Orders so

    INNER JOIN dbo.Warehouse_Inventory wi
        ON wi.Warehouse_ID = so.Warehouse_ID
       AND wi.Current_Stock >= 20

    INNER JOIN dbo.Products p
        ON p.Product_ID = wi.Product_ID
)

INSERT INTO dbo.Sales_Order_Items
(
    Sales_Order_ID,
    Product_ID,
    Quantity_Ordered,
    Unit_Price,
    Discount_Percent
)
SELECT
    Sales_Order_ID,
    Product_ID,

    2 + ((Sales_Order_ID * (Product_Rank + 2)) % 8),

    Selling_Price,

    CAST
    (
        CASE
            WHEN Sales_Order_ID % 15 = 0 THEN 10
            WHEN Sales_Order_ID % 7 = 0 THEN 5
            ELSE 0
        END
        AS DECIMAL(5,2)
    )

FROM Eligible_Products
WHERE Product_Rank <= 2;
GO
SELECT * FROM dbo.Sales_Order_Items
GO


/*==============================================================
    INVENTORY TRANSACTIONS
==============================================================*/
INSERT INTO dbo.Inventory_Transactions
(
    Warehouse_ID,
    Product_ID,
    Performed_By_Employee_ID,
    Transaction_Type,
    Quantity_Change,
    Transaction_Date,
    Reference_Type,
    Reference_ID,
    Notes
)
SELECT
    gr.Warehouse_ID,
    poi.Product_ID,

    /* Warehouse managers are Employee_ID 1-8,
       aligned to Warehouse_ID 1-8 */
    gr.Warehouse_ID AS Performed_By_Employee_ID,

    'Goods Receipt',

    gri.Quantity_Received,

    gr.Received_Date,

    'Goods Receipt',

    gr.Goods_Receipt_ID,

    CASE
        WHEN gri.Quantity_Rejected > 0
            THEN CONCAT
            (
                gri.Quantity_Rejected,
                N' unit(s) rejected: ',
                gri.Rejection_Reason
            )
        ELSE N'Stock received from supplier'
    END

FROM dbo.Goods_Receipt_Items gri

INNER JOIN dbo.Goods_Receipts gr
    ON gr.Goods_Receipt_ID = gri.Goods_Receipt_ID

INNER JOIN dbo.Purchase_Order_Items poi
    ON poi.Purchase_Order_Item_ID = gri.Purchase_Order_Item_ID;
GO

/*==============================================================
   SALES DISPATCH TRANSACTIONS

  Fulfilled orders:
    dispatch full ordered quantity.

  Partially Fulfilled orders:
    dispatch approximately half, with at least one unit.

  Processing and Cancelled orders:
    create no stock movement.
==============================================================*/

INSERT INTO dbo.Inventory_Transactions
(
    Warehouse_ID,
    Product_ID,
    Performed_By_Employee_ID,
    Transaction_Type,
    Quantity_Change,
    Transaction_Date,
    Reference_Type,
    Reference_ID,
    Notes
)
SELECT
    so.Warehouse_ID,
    soi.Product_ID,

    /* Warehouse manager records the physical dispatch */
    so.Warehouse_ID AS Performed_By_Employee_ID,

    'Sales Dispatch',

    -CASE
        WHEN so.Sales_Order_Status = 'Fulfilled'
            THEN soi.Quantity_Ordered

        WHEN so.Sales_Order_Status = 'Partially Fulfilled'
            THEN CASE
                    WHEN soi.Quantity_Ordered / 2 < 1 THEN 1
                    ELSE soi.Quantity_Ordered / 2
                 END
    END,

    DATEADD
    (
        DAY,
        CASE
            WHEN so.Sales_Order_Status = 'Fulfilled' THEN 0
            ELSE 1
        END,
        CAST(so.Required_Delivery_Date AS DATETIME2(0))
    ),

    'Sales Order',

    so.Sales_Order_ID,

    CASE
        WHEN so.Sales_Order_Status = 'Partially Fulfilled'
            THEN N'Partial customer-order dispatch'
        ELSE N'Completed customer-order dispatch'
    END

FROM dbo.Sales_Order_Items soi

INNER JOIN dbo.Sales_Orders so
    ON so.Sales_Order_ID = soi.Sales_Order_ID

WHERE so.Sales_Order_Status IN
(
    'Fulfilled',
    'Partially Fulfilled'
);
GO


/*==============================================================
  SYNCHRONIZE CURRENT INVENTORY

  Current stock becomes:
      total receipts
      minus sales dispatches
      plus/minus any future adjustments
==============================================================*/

;WITH Transaction_Balance AS
(
    SELECT
        Warehouse_ID,
        Product_ID,
        SUM(Quantity_Change) AS Calculated_Current_Stock

    FROM dbo.Inventory_Transactions

    GROUP BY
        Warehouse_ID,
        Product_ID
)
UPDATE wi
SET
    wi.Current_Stock = tb.Calculated_Current_Stock

FROM dbo.Warehouse_Inventory wi

INNER JOIN Transaction_Balance tb
    ON tb.Warehouse_ID = wi.Warehouse_ID
   AND tb.Product_ID = wi.Product_ID;
GO
SELECT it.Inventory_Transaction_ID
FROM dbo.Inventory_Transactions it
LEFT JOIN dbo.Sales_Orders so
    ON so.Sales_Order_ID = it.Reference_ID
WHERE it.Reference_Type = 'Sales Order'
  AND so.Sales_Order_ID IS NULL;
GO

/*==============================================================
 Sales Targets 
  
==============================================================*/
;WITH Sales_Employees AS
(
    SELECT
        e.Employee_ID,

        ROW_NUMBER() OVER
        (
            ORDER BY e.Employee_ID
        ) AS Sales_Rep_Rank

    FROM dbo.Employees e
    INNER JOIN dbo.Departments d
        ON d.Department_ID = e.Department_ID

    WHERE d.Department_Name = N'Sales'
      AND e.Is_Active = 1
),
Target_Months AS
(
    SELECT *
    FROM
    (
        VALUES
            (2025, 7,  1.00),
            (2025, 8,  1.03),
            (2025, 9,  1.05),
            (2025, 10, 1.08),
            (2025, 11, 1.15),
            (2025, 12, 1.25),
            (2026, 1,  0.92),
            (2026, 2,  0.98),
            (2026, 3,  1.02),
            (2026, 4,  1.05),
            (2026, 5,  1.08),
            (2026, 6,  1.10)
    ) m
    (
        Target_Year,
        Target_Month,
        Seasonal_Multiplier
    )
),
Employee_Base_Targets AS
(
    SELECT
        Employee_ID,

        /* Individual monthly base targets:
           ₦3.50m, ₦3.75m ... up to ₦5.75m */
        CAST
        (
            3500000 + ((Sales_Rep_Rank - 1) * 250000)
            AS DECIMAL(18,2)
        ) AS Base_Target

    FROM Sales_Employees
)
INSERT INTO dbo.Sales_Targets
(
    Employee_ID,
    Target_Year,
    Target_Month,
    Target_Amount
)
SELECT
    ebt.Employee_ID,
    tm.Target_Year,
    tm.Target_Month,

    /* Round targets to the nearest ₦50,000 */
    CAST
    (
        ROUND
        (
            (ebt.Base_Target * tm.Seasonal_Multiplier) / 50000,
            0
        ) * 50000
        AS DECIMAL(18,2)
    ) AS Target_Amount

FROM Employee_Base_Targets ebt
CROSS JOIN Target_Months tm;
GO
SELECT*FROM Sales_Targets
GO