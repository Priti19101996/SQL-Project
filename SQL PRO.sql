-- Create Database
CREATE DATABASE OnlineBookstore;

-- Switch to the database
Use OnlineBookstore;

-- Create Tables
DROP TABLE IF EXISTS Books;
CREATE TABLE Books (
    Book_ID SERIAL PRIMARY KEY,
    Title VARCHAR(100),
    Author VARCHAR(100),
    Genre VARCHAR(50),
    Published_Year INT,
    Price NUMERIC(10, 2),
    Stock INT
);
DROP TABLE IF EXISTS customers;
CREATE TABLE Customers (
    Customer_ID SERIAL PRIMARY KEY,
    Name VARCHAR(100),
    Email VARCHAR(100),
    Phone VARCHAR(15),
    City VARCHAR(50),
    Country VARCHAR(150)
);
DROP TABLE IF EXISTS orders;
CREATE TABLE Orders (
    Order_ID SERIAL PRIMARY KEY,
    Customer_ID INT REFERENCES Customers(Customer_ID),
    Book_ID INT REFERENCES Books(Book_ID),
    Order_Date DATE,
    Quantity INT,
    Total_Amount NUMERIC(10, 2)
);

SELECT * FROM Books;
SELECT * FROM Customers;
SELECT * FROM Orders;



-- 1) Retrieve all books in the "Fiction" genre:

select * from Books 
where Genre='Fiction';


-- 2) Find books published after the year 1950:

select * from Books 
where Published_Year>1950;


-- 3) List all customers from the Canada:

select * from Customers 
where Country='Canada';


-- 4) Show orders placed in November 2023:

select * from Orders 
where Order_Date 
between '2023-11-01' and '2023-11-30';

-- 5) Retrieve the total stock of books available:

select sum(Stock) as Total_Stock
from Books;


-- 6) Find the details of the most expensive book:

select*from Books 
order by Price desc 
limit 1;

-- 7) Show all customers who ordered more than 1 quantity of a book:

select * from Orders 
where Quantity>1;

-- 8) Retrieve all orders where the total amount exceeds $20:

select * from Orders 
where Total_Amount>20;

-- 9) List all genres available in the Books table:

Select distinct Genre
from Books;

-- 10) Find the book with the lowest stock:

Select*from Books
order by Stock
Limit 10;


-- 11) Calculate the total revenue generated from all orders:

Select sum(Total_Amount) as Total_revenue
from orders;

-- Advance Queries

-- 1) Retrieve the total number of books sold for each genre:

Select B.Genre, Sum(O.Quantity)
From orders o
join Books b 
on o.Book_ID=B.Book_ID
Group By B.Genre;



-- 2) Find the average price of books in the "Fantasy" genre:

Select avg(Price)
From Books
where Genre='Fantasy';


-- 3) List customers who have placed at least 2 orders:

SELECT c.name, o.customer_id, COUNT(o.Order_ID) AS Total_order
FROM Customers c
JOIN Orders o
ON c.customer_id = o.customer_id
GROUP BY o.customer_id, c.name  
HAVING COUNT(o.Order_ID) >= 2;



-- 4) Find the most frequently ordered book:

Select Book_id, count(order_id) as Total_c
from Orders
group by Book_id
order by Total_c desc limit 2;


-- 5) Show the top 3 most expensive books of 'Fantasy' Genre :

select *from Books
where Genre='Fantasy'
Order by Price desc limit 3;

-- 6) Retrieve the total quantity of books sold by each author:

select b.author,sum(o.quantity)as Total_qty
from Books b
join Orders o
on b.book_id=o.book_id
group by b.author;

-- 7) List the cities where customers who spent over $30 are located:
select distinct c.city, total_amount
from Orders o
join customers c
on c.customer_id=o.customer_id
where o.total_amount>30;


-- 8) Find the customer who spent the most on orders:

Select c.name,sum(o.total_amount)as total_spent
from customers c
join orders o
on c.customer_id=o.customer_id
group by c.name,c.customer_id
order by total_spent desc
limit 1;

-- 9) Calculate the stock remaining after fulfilling all orders:

SELECT 
    b.book_id, b.title,  b.stock,coalesce(sum(o.quantity),0) as QTY_SOLD,
    COALESCE(b.stock - SUM(o.quantity), b.stock) AS Qty_remain
FROM Books b
LEFT JOIN Orders o ON b.book_id = o.book_id  
GROUP BY b.book_id, b.stock, b.title;  









