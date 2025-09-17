# E-Commerce Sales & Customer Analysis Project

## Project Overview
Analyzing sales and customer behavior on an e-commerce platform using MySQL by answering 18 business questions. I explore product performance, revenue trends, customer purchasing patterns, payment methods, and feedback ratings to gain insights.

## Objective
The aim is to derive actionable insights from the dataset to:  
- Identify top-performing products and categories.  
- Understand customer purchasing behavior and spending.  
- Analyze order trends and payment methods.  
- Evaluate customer feedback to improve products and services.

## Database Schema

### Users
| Column           | Type       | Description                     |
|-----------------|-----------|---------------------------------|
| UserID          | INT       | Unique ID for each user          |
| FirstName       | VARCHAR   | User's first name                |
| LastName        | VARCHAR   | User's last name                 |
| Email           | VARCHAR   | Email address (unique)           |
| Password        | VARCHAR   | Account password                 |
| Phone           | VARCHAR   | Contact number                   |
| Address         | VARCHAR   | Street address                   |
| City            | VARCHAR   | City                              |
| Country         | VARCHAR   | Country                           |
| RegistrationDate| DATE      | Date of registration             |

### Products
| Column       | Type       | Description                     |
|-------------|-----------|---------------------------------|
| ProductID   | INT       | Unique product ID                |
| UserID      | INT       | Seller ID (from Users table)     |
| ProductName | VARCHAR   | Name of the product              |
| Category    | VARCHAR   | Product category                 |
| Description | TEXT      | Product description              |
| Price       | DECIMAL   | Price of the product             |
| Quantity    | INT       | Units available                  |
| ListingDate | DATE      | Date product was listed          |

### Orders
| Column     | Type       | Description                     |
|-----------|-----------|---------------------------------|
| OrderID   | INT       | Unique order ID                 |
| UserID    | INT       | Buyer ID                        |
| ProductID | INT       | Purchased product ID            |
| Quantity  | INT       | Quantity purchased              |
| TotalAmount| DECIMAL  | Total order amount              |
| OrderDate | DATE      | Date of order                   |
| Status    | VARCHAR   | Order status (Pending/Shipped/Delivered/Cancelled) |

### Payments
| Column        | Type       | Description                     |
|---------------|-----------|---------------------------------|
| PaymentID     | INT       | Unique payment ID                |
| OrderID       | INT       | Linked order ID                  |
| UserID        | INT       | Buyer who made the payment       |
| Amount        | DECIMAL   | Paid amount                      |
| PaymentMethod | VARCHAR   | Payment method (Credit Card, PayPal, Bank Transfer) |
| PaymentDate   | DATE      | Date of payment                  |
| Status        | VARCHAR   | Payment status (Paid, Failed, Refunded) |

### Feedback
| Column       | Type       | Description                     |
|-------------|-----------|---------------------------------|
| FeedbackID  | INT       | Unique feedback ID              |
| OrderID     | INT       | Linked order                    |
| UserID      | INT       | Buyer giving feedback           |
| ProductID   | INT       | Product being reviewed          |
| Rating      | INT       | Rating from 1–5                 |
| Comment     | TEXT      | Customer comment                |
| FeedbackDate| DATE      | Date feedback was submitted     |

## Business Questions

### Easy
1. Show only unique product categories.  
2. Show product IDs, comments, and ratings for feedback with rating 4 or higher.  
3. Find User IDs, payment method, and status for all Paid PayPal payments.  
4. Get the total number of users in the system.  
5. Find the top 5 most expensive products.  
6. List each distinct product category with the total quantity available.  
7. Show all orders placed in May 2023.  
8. Show all users who live in USA, UK, or Australia.  

### Medium
9. Find the total revenue generated in each month and show the results in descending order of revenue.  
10. Find the percentage of orders in each Status (Delivered, Pending, Shipped, Cancelled) compared to total orders.  
11. Find the total revenue from all orders placed between '2023-05-01' and '2023-06-30', and count how many orders were placed in this period.  
12. Find the products that are more expensive than the average product price.  
13. Find the users who have placed at least one order with an amount greater than 1000.  
14. Find all products whose price is higher than the average price of products in the same category.  

### Hard
15. Show all orders along with the buyer's name, product name, and order status.  
16. List all users who have purchased products and the total amount they spent.  
17. Show all products along with the average rating they received (if any).  
18. Display all payments along with the buyer's name, order date, and product name for payments that are “Paid”.

## SQL Solutions

### Easy

-- 1. Show only unique Product Categories
```sql
SELECT DISTINCT category
FROM products;
```

-- 2. Show product IDs, comments, and ratings for feedback with rating 4 or higher
```sql
SELECT productId, comment, rating
FROM feedback
WHERE rating >= 4;
```

-- 3. Find User IDs, payment method, and status for all Paid PayPal payments
```sql
SELECT UserId, PaymentMethod, Status
FROM payments 
WHERE PaymentMethod LIKE '%PayPal%' AND status = 'Paid';

SELECT UserId, PaymentMethod, Status
FROM payments
WHERE PaymentMethod = 'PayPal' AND status = 'Paid';
```

-- 4. Get the total number of users in the system
```sql
SELECT COUNT(DISTINCT userId) AS total_users
FROM users;
```

-- 5. Find the top 5 most expensive products
```sql
SELECT ProductName, Price AS most_expensive_products
FROM products 
ORDER BY Price DESC
LIMIT 5;
```

-- 6. List each distinct product category with the total quantity available
```sql
SELECT DISTINCT category, SUM(quantity) total_quantity
FROM products
GROUP BY category;
```

-- 7. Show all orders placed in May 2023
```sql
SELECT * 
FROM orders
WHERE OrderDate LIKE '2023-05%';

SELECT * 
FROM orders
WHERE MONTH(OrderDate) = 5;

SELECT * 
FROM orders
WHERE OrderDate BETWEEN '2023-05-01' AND '2023-05-31';
```

-- 8. Show all users who live in USA, UK, or Australia
```sql
SELECT * 
FROM users
WHERE country = 'USA' OR country = 'UK' OR country = 'Autralia';

SELECT * 
FROM users
WHERE country IN ('USA', 'UK', 'Australia');
```

### Medium

-- 9. Find the total revenue generated in each month (descending order)
```sql
SELECT MONTH(orderDate) AS Month, SUM(TotalAmount) Total_Revenue
FROM orders
GROUP BY MONTH(orderDate)
ORDER BY Total_Revenue DESC;

SELECT DATE_FORMAT(orderDate, '%m') AS month,
SUM(TotalAmount) AS Total_Revenue
FROM orders
GROUP BY DATE_FORMAT(orderDate, '%m') 
ORDER BY Total_Revenue DESC;
```

-- 10. Find the percentage of orders in each Status
```sql
SELECT status, ROUND(COUNT(*) * 100.0 / (SELECT COUNT(status) FROM orders), 2) AS percentage_of_orders
FROM orders
GROUP BY status;
```

-- 11. Total revenue and order count between '2023-05-01' and '2023-06-30'
```sql
SELECT SUM(TotalAmount) total_revenue, COUNT(*) AS order_count
FROM orders
WHERE OrderDate BETWEEN '2023-05-01' AND '2023-06-30';
```

-- 12. Products more expensive than the average product price
```sql
SELECT productName, price
FROM products
WHERE price > (SELECT AVG(price) FROM products);
```

-- 13. Users who placed at least one order above 1000
```sql
SELECT u.Userid, u.firstName, u.lastName, u.Email
FROM users u
JOIN orders o USING(userId)
WHERE userId IN (
    SELECT userId FROM orders
    WHERE TotalAmount > 1000
);
```

-- 14. Products priced higher than the average in the same category
```sql
SELECT p.ProductName, p.price
FROM products p
WHERE price > (SELECT AVG(price) FROM products p1 WHERE p.category = p1.category);
```

### Hard

-- 15. Show all orders along with buyer's name, product name, and order status
```sql
SELECT u.userId, u.firstName, u.LastName, p.productName, o.status
FROM users u
JOIN products p ON u.userId = p.userId
JOIN orders o ON p.productId = o.productId;
```

-- 16. List all users who have purchased products and the total amount they spent
```sql
SELECT o.userId, u.FirstName, u.LastName, SUM(TotalAmount) TotalAmountSpent
FROM orders o
LEFT JOIN users u USING(UserId)
WHERE userId IN (SELECT userId FROM orders)
GROUP BY o.userId, u.FirstName, u.LastName
ORDER BY TotalAmountSpent DESC;
```

-- 17. Show all products along with the average rating they received
```sql
SELECT p.productId, p.productName, p.category, ROUND(AVG(f.rating), 2) avg_rating
FROM products p
LEFT JOIN feedback f USING(productId)
GROUP BY p.productId, p.productName, p.category
ORDER BY avg_rating DESC;
```

-- 18. Display all payments along with buyer's name, order date, and product name for payments that are Paid
```sql
SELECT p.paymentId, u.FirstName, u.LastName, o.OrderDate, pd.productName, p.PaymentMethod, p.status
FROM users u
INNER JOIN orders o ON u.UserID = o.UserID
RIGHT JOIN payments p ON o.userId = p.userId
INNER JOIN products pd ON o.userId = pd.userId
WHERE p.status = 'Paid';
```

## Summary of Findings

- Unique categories: Electronics, Fashion, Home & Furniture, Computers, Home & Kitchen, Gaming, Sports   
- Most expensive products: Rolex Watch, iPhone 14 Pro, Gucci Handbag, Dell XPS 13, MacBook Air M2  
- Category quantities: Electronics (34), Fashion (33), Computers (27), Home & Kitchen (18), Home & Furniture (9), Sports (5), Gaming (4)  
- May had the highest revenue: $11,390  
- Order status: 60% Delivered, 20% Shipped, 10% Pending, 10% Cancelled


