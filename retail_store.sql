-- ========================================
-- Part 3: Retail Store Database Queries
-- ========================================

-- 1️⃣ Create the required tables

-- Suppliers Table
CREATE TABLE suppliers (
    supplierID INT AUTO_INCREMENT PRIMARY KEY,
    supplierName VARCHAR(100),
    contactNumber VARCHAR(15)
);

-- Products Table
CREATE TABLE products (
    productID INT AUTO_INCREMENT PRIMARY KEY,
    productName VARCHAR(100),
    price DECIMAL(10,2),
    stockQuantity INT,
    supplierID INT,
    FOREIGN KEY (supplierID) REFERENCES suppliers(supplierID)
);

-- Sales Table
CREATE TABLE Sales (
    saleID INT AUTO_INCREMENT PRIMARY KEY,
    productID INT,
    quantitySold INT CHECK (quantitySold > 0),
    saleDate DATE,
    FOREIGN KEY (productID) REFERENCES products(productID)
);

-- 2️⃣ Add a column “Category” to the Products table
ALTER TABLE products
ADD category VARCHAR(50) NOT NULL;

-- 3️⃣ Remove the “Category” column from Products
ALTER TABLE products
DROP COLUMN category;

-- 4️⃣ Change “ContactNumber” column in Suppliers to VARCHAR(15)
ALTER TABLE suppliers
MODIFY contactNumber VARCHAR(15);

-- 5️⃣ Add a NOT NULL constraint to ProductName
ALTER TABLE products
MODIFY productName VARCHAR(100) NOT NULL;

-- 6️⃣ Perform Basic Inserts

-- a. Add a supplier
INSERT INTO suppliers (supplierName, contactNumber)
VALUES ('FreshFoods', '01001234567');

-- b. Insert products (assuming SupplierID = 1)
INSERT INTO products (productName, price, stockQuantity, supplierID)
VALUES 
('Milk', 15.00, 50, 1),
('Bread', 10.00, 30, 1),
('Eggs', 20.00, 40, 1);

-- c. Add a sale of 2 units of 'Milk' on '2025-05-20'
INSERT INTO sales (productID, quantitySold, saleDate)
VALUES (1, 2, '2025-05-20');

-- 7️⃣ Update the price of 'Bread' to 25.00
UPDATE products
SET price = 25.00
WHERE productName = 'Bread';

-- 8️⃣ Delete the product 'Eggs'
DELETE FROM products
WHERE productName = 'Eggs';

-- 9️⃣ Retrieve the total quantity sold for each product
SELECT 
    p.productName,
    SUM(s.quantitySold) AS totalQuantitySold
FROM sales s
JOIN products p ON s.productID = p.productID
GROUP BY p.productName;

-- 10️⃣ Get the product with the highest stock
SELECT productName, stockQuantity
FROM products
WHERE stockQuantity = (SELECT MAX(stockQuantity) FROM products);


-- 11️⃣ Find suppliers with names starting with 'F'
SELECT *
FROM suppliers
WHERE supplierName LIKE 'F%';

-- 12️⃣ Show all products that have never been sold
SELECT p.productName, p.stockQuantity
FROM products p
LEFT JOIN sales s ON p.productID = s.productID
WHERE s.productID IS NULL;

-- 13️⃣ Get all sales along with product name and sale date
SELECT 
    s.saleID,
    p.productName,
    s.quantitySold,
    s.saleDate
FROM sales s
JOIN products p ON s.productID = p.productID;

-- 14️⃣ Create user “store_manager” and give SELECT, INSERT, UPDATE on all tables
CREATE USER 'store_manager'@'localhost' IDENTIFIED BY 'StrongPassword123';

GRANT SELECT, INSERT, UPDATE
ON retail_store.* TO 'store_manager'@'localhost';

-- 15️⃣ Revoke UPDATE permission from “store_manager”
REVOKE UPDATE
ON retail_store.* FROM 'store_manager'@'localhost';

-- 16️⃣ Grant DELETE permission to “store_manager” only on the Sales table
GRANT DELETE
ON retail_store.sales TO 'store_manager'@'localhost';
