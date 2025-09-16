-- Solving 18 Problems to Master SQL 

show tables;

-- Easy:
-- 1. Show only unique Product Categories

select * from products;

select distinct category
from products;

-- 2. Show product IDs, comments, and ratings for feedback with rating 4 or higher.

select * from feedback;

select productId, comment, rating
from feedback
where rating >= 4;

-- 3. Find User IDs, payment method, and status for all Paid PayPal payments.

select * from payments;

select UserId, PaymentMethod, Status
from payments 
where PaymentMethod like '%PayPal%' and status = 'Paid';

select UserId, PaymentMethod, Status
from payments
where PaymentMethod = 'PayPal' and status = 'Paid';


-- 4. Get the total number of users in the system.

select * from users;

select count(distinct userId) as total_users
from users;

-- 5. Find the top 5 most expensive products.

select * from products;

select ProductName, Price as most_expensive_products
from products 
order by Price desc
limit 5;

-- 6. List each distinct product category with the total quantity available

select * from products; 

select distinct category, sum(quantity) total_quantity
from products
group by category;

-- 7: Show all orders placed in May 2023

select * from orders;

select * 
from orders
where OrderDate like '2023-05%';

select * 
from orders
where month(OrderDate) = 5;

select * 
from orders
where OrderDate between '2023-05-01' and '2023-05-31';

-- 8: Show all users who live in USA, UK, or Autralia

select * from users;

select * 
from users
where country = 'USA' or country = 'UK' or country = 'Autralia';


select * 
from users
where country in ('USA', 'UK', 'Australia');

-- Medium:
-- 9. Find the total revenue generated in each month (from the Orders table), and show the results in descending order of revenue

select * from orders;

select month(orderDate) as Month, sum(TotalAmount) Total_Revenue
from orders
group by month(orderDate)
order by Total_Revenue desc;

select date_format(orderDate, '%m') as month,
sum(TotalAmount) as Total_Revenue
from orders
group by date_format(orderDate, '%m') 
order by Total_Revenue desc;


-- 10. Find the percentage of orders in each Status (Delivered, Pending, Shipped, Cancelled) compared to total orders.

select * from orders;

select status, round(count(*) * 100.0/ (select count(status) from orders),2) as percentage_of_orders
from orders
group by status;

-- 11. Find the total revenue (SUM of TotalAmount) from all orders placed between '2023-05-01' and '2023-06-30', and also count how many orders were placed in this period.

select * from orders;

select sum(TotalAmount) total_revenue, count(*) as order_count
from orders
where OrderDate between '2023-05-01' and '2023-06-30';

-- 12.Find the products that are more expensive than the average product price.

select * from products;

select avg(price) from products;

select productName, price
from products
where price > (select avg(price) from products);

-- 13. Find the users who have placed at least one order with an amount greater than 1000.

select * from users;

select * from orders;

select u.Userid, u.firstName, u.lastName, u.Email
from users u
join orders o
using(userId)
where userId in (
		select userId from orders
        where TotalAmount > 1000);	

-- 14: Find all products whose price is higher than the average price of products in the same category.

select * from products;

select p.ProductName, p.price
from products p
where price > (select avg(price) from products p1 where p.category = p1.category);

-- Hard:
-- 15: Show all orders along with the buyer's name, product name, and order status

select * from orders; -- order status
select * from products; -- product name
select * from users; -- --FirstName, LastName

select u.userId, u.firstName, u.LastName, p.productName, o.status
from users u
join products p 
on u.userId = p.userId
join orders o
on p.productId = o.productId;

-- 16: List all users who have purchased products and the total amount they spent.

select * from users;

select o.userId, u.FirstName, u.LastName, sum(TotalAmount) TotalAmountSpent
from orders o
left join users u
using(UserId)
where userId in (select userId from orders)
group by o.userId, u.FirstName, u.LastName
order by TotalAmountSpent desc;


-- 17: Show all products along with the average rating they received (if any).

select * from products;

select p.productId, p.productName, p.category, round(avg(f.rating),2) avg_rating
from products p
left join feedback f
using(productId)
group by p.productId, p.productName, p.category
order by avg_rating desc;


-- 18: Display all payments along with the buyer's name, order date, and product name for payments that are “Paid”

select * from orders;

select p.paymentId, u.FirstName, u.LastName, o.OrderDate, pd.productName, p.PaymentMethod, p.status
from users u
inner join orders o
on u.UserID = o.UserID
right join payments p 
on o.userId = p.userId
inner join products pd
on o.userId = pd.userId
where p.status = 'Paid';