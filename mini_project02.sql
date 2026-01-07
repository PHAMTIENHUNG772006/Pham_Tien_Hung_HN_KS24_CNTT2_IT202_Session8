drop database mini_project02;
create database mini_project02;
use mini_project02;

create table customers (
	customer_id int primary key auto_increment,
    customer_name varchar(100) not null,
    email varchar(100) not null unique,
	phone varchar(100) not null unique
);

create table categorys (
	category_id int primary key auto_increment,
    category_name varchar(255) not null unique
);

create table products (
	product_id int primary key auto_increment,
    product_name varchar(255) not null unique,
    price decimal(10,2) not null check(price > 0),
    category_id int ,
    foreign key (category_id) references categorys(category_id)
);


create table orders (
	order_id int primary key auto_increment,
    customer_id int not null,
    order_date date default(current_date),
    status enum('Pending','Completed','Cancel') default('Pending'),
    
    foreign key (customer_id) references customers(customer_id)
);



create table order_items (
	order__item_id int primary key auto_increment,
    order_id int not null,
    product_id int not null,
    quantity int not null check(quantity > 0),
    
     foreign key (order_id) references orders(order_id),
     foreign key (product_id) references products(product_id)
);


INSERT INTO customers (customer_name, email, phone) VALUES
('Pham Tien Hung', 'hung@gmail.com', '0900165001'),
('Nguyen Van A', 'a@gmail.com', '0900000001'),
('Tran Thi B', 'b@gmail.com', '0900000002'),
('Le Van C', 'c@gmail.com', '0900000003'),
('Pham Thi D', 'd@gmail.com', '0900000004'),
('Hoang Van E', 'e@gmail.com', '0900000005'),
('Do Thi F', 'f@gmail.com', '0900000006'),
('Bui Van G', 'g@gmail.com', '0900000007'),
('Vu Thi H', 'h@gmail.com', '0900000008'),
('Dang Van I', 'i@gmail.com', '0900000009'),
('Ngo Thi K', 'k@gmail.com', '0900000010');



INSERT INTO categorys (category_name) VALUES
('Laptop'),
('Phone'),
('Tablet'),
('Accessory'),
('Monitor'),
('Keyboard'),
('Mouse'),
('Headphone'),
('Speaker'),
('Storage');




INSERT INTO products (product_name, price, category_id) VALUES
('Laptop Dell', 15000000, 1),
('iPhone 15', 22000000, 2),
('iPad Pro', 18000000, 3),
('Chuột Logitech', 350000, 7),
('Bàn phím cơ', 1200000, 6),
('Tai nghe Sony', 2500000, 8),
('Màn hình Samsung', 4200000, 5),
('Loa Bluetooth', 1350000, 9),
('USB 32GB', 180000, 10),
('SSD 512GB', 2200000, 10);



INSERT INTO orders (customer_id, order_date, status) VALUES
(1, '2024-01-01', 'Completed'),
(2, '2024-01-02', 'Completed'),
(3, '2024-01-03', 'Pending'),
(4, '2024-01-04', 'Completed'),
(5, '2024-01-05', 'Cancel'),
(1, '2024-01-06', 'Completed'),
(3, '2024-01-07', 'Completed'),
(6, '2024-01-08', 'Pending'),
(8, '2024-01-09', 'Completed'),
(10,'2024-01-10', 'Completed');




INSERT INTO order_items (order_id, product_id, quantity) VALUES
(1, 1, 1),
(1, 4, 2),
(2, 2, 1),
(3, 3, 1),
(4, 5, 1),
(5, 6, 1),
(6, 7, 2),
(7, 8, 1),
(8, 9, 3),
(9, 10, 1);

SELECT * FROM customers;
SELECT * FROM categorys;
SELECT * FROM products;
SELECT * FROM orders;
SELECT * FROM order_items;

-- PHẦN A – TRUY VẤN DỮ LIỆU CƠ BẢN

-- Lấy danh sách tất cả danh mục sản phẩm trong hệ thống.
SELECT * FROM categorys;
-- Lấy danh sách đơn hàng có trạng thái là COMPLETED
SELECT * FROM orders where status = 'COMPLETED';
-- Lấy danh sách sản phẩm và sắp xếp theo giá giảm dần
SELECT * FROM products 
order by price desc ;
-- Lấy 5 sản phẩm có giá cao nhất, bỏ qua 2 sản phẩm đầu tiên
SELECT * FROM products 
order by price desc limit 5 offset 2;






-- PHẦN B – TRUY VẤN NÂNG CAO

-- Lấy danh sách sản phẩm kèm tên danh mục
SELECT p.*, c.category_name FROM products p
inner join categorys c on c.category_id = p.category_id;
-- Lấy danh sách đơn hàng gồm:
-- order_id
-- order_date
-- customer_name
-- status
SELECT o.order_id, c.customer_name, o.order_date, o.status FROM  orders o
inner join customers c on c.customer_id = o.customer_id;


-- Tính tổng số lượng sản phẩm trong từng đơn hàng
SELECT o.order_id , sum(oi.quantity) as soluongsp FROM order_items oi
inner join orders o on o.order_id = oi.order_id
group by order_id;

-- Thống kê số đơn hàng của mỗi khách hàng
SELECT c.customer_name, count(o.customer_id) FROM  orders o 
inner join customers c on c.customer_id = o.customer_id
group by c.customer_id;


-- Lấy danh sách khách hàng có tổng số đơn hàng ≥ 2
SELECT c.customer_name, count(o.customer_id) as tongdon FROM  orders o 
inner join customers c on c.customer_id = o.customer_id
group by c.customer_id
having tongdon >= 2;

-- Thống kê giá trung bình, thấp nhất và cao nhất của sản phẩm theo danh mục
SELECT ca.category_id, avg(p.price) as trungbinh, min(p.price) as nho, max(p.price) as lon FROM categorys ca
inner join products p on p.category_id = ca.category_id
group by ca.category_id;


-- PHẦN C – TRUY VẤN LỒNG (SUBQUERY)

-- Lấy danh sách sản phẩm có giá cao hơn giá trung bình của tất cả sản phẩm
select p.product_name, format(p.price,0,'vi_VN') from products p
where p.price > (select avg(price) from products);

-- Lấy danh sách khách hàng đã từng đặt ít nhất một đơn hàng

select customer_name from customers
where customer_id  in(SELECT o.customer_id  FROM  orders o
group by o.customer_id
having count(o.order_id) >= 1);


-- Lấy đơn hàng có tổng số lượng sản phẩm lớn nhất.
select o.order_id ,o.order_date, o.status, sum(oi.quantity) total_quantity from orders o 
inner join order_items oi on oi.order_id = o.order_id
group by o.order_id
having sum(oi.quantity) =
 
 (select max(maxquantity) from (
select oi.order_id, sum(oi.quantity) as maxquantity 
from order_items oi
group by oi.order_id) as maxtable) ;


-- Lấy tên khách hàng đã mua sản phẩm thuộc danh mục có giá trung bình cao nhất
select  c.customer_name
from customers c
inner join orders o on o.customer_id = c.customer_id
inner join order_items oi on oi.order_id = o.order_id
inner join products p on p.product_id = oi.product_id
where p.category_id in (
    select category_id
    from products
    group by category_id
    having avg(price) = (
        select MAX(avg_price)
        from (
            select avg(price) as avg_price
            from products
            group by category_id
        ) t
    )
);

-- Từ bảng tạm (subquery), thống kê tổng số lượng sản phẩm đã mua của từng khách hàng
select c.customer_name, SUM(t.quantity) AS total_quantity
from customers c
join orders o on o.customer_id = c.customer_id
join (select order_id, quantity from order_items) as t on t.order_id = o.order_id
group by c.customer_id;


-- Viết lại truy vấn lấy sản phẩm có giá cao nhất, đảm bảo:
-- Subquery chỉ trả về một giá trị
-- Không gây lỗi “Subquery returns more than 1 row”

select * from products
where price = (select max(price) from products)
