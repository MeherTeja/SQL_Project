-- 1) selecting data with max profit
select * from storedata sd1
where sd1.profit in(select max(Profit) from storedata s2);

-- 2) selecting data with max profit with disc>=0.5

select * from storedata sd1
where sd1.profit in (select max(Profit) from storedata s2 where s2.Discount>=0.5);

-- 3) selecting unique cust id

select distinct sd1.Customer_ID from storedata sd1;



-- 4) selecting categories and sub categories in which unique cust id is present

select sd1.Sub_Category,sd1.Category
from storedata sd1
where sd1.Customer_ID not in(
select sd2.Sub_Category
from storedata sd2
);

-- 5) most profit making city

select City from storedata sd1
where sd1.profit in (select max(Profit) from storedata s2);

-- 6) creating duplicate table storedata1

-- 7) delete rows from storedata1 whose discount<0.3

delete from storedata1 where Discount<0.3; 

-- 8) finding which category is saled most
select distinct Category
from storedata sd2
where sd2.Sales >(select min(sd1.Sales) from storedata sd1);


select ShipMode,count(ShipMode)
from storedata sd2
where sd2.Profit >(select min(sd1.Profit) from storedata sd1);


-- 10) retrieving high quantiy sub category

select  sd2.Sub_Category
from storedata sd2
where sd2.Quantity>(select min(sd1.Quantity) from storedata sd1);


-- 12) combining category and sub category column fields in new column

alter table storedata  add column cat_subcat_binders varchar(255);

set sql_safe_updates=0;

update storedata set cat_subcat_binders=concat(Category,Sub_Category);


select * from storedata;

-- 13) data shipped after 8/3/2015 and before 1/10/2017
select 
* from storedata s1 
where s1.OrderDate>08-03-2015 and s1.OrderDate<01-10-2017;

-- 14) most used customer id
	
	select s1.Customer_ID, count(s1.Sales) as most_used
    from storedata s1
    group by s1.Customer_ID 
    order by most_used desc
    Limit 1;
    
  -- 15) creating new col having customer_name_length
  
  alter table storedata add column customer_name_length int;
    
    
-- 16) no.of unique orders
select
count(s1.OrderID) AS Unique_order
from storedata s1
left join
storedata s2
on 
s1.OrderID<>s2.OrderID;

-- 17) query to retrieve most saled order id

select s1.OrderId,max(s1.Sales) as saled_most
from storedata s1
group by s1.OrderId 
order by saled_most DESC;


-- 18) Rank the order id based on sales, grouped on city

select * ,rank() over(partition by City order by Sales desc) as sales_rank from storedata;


-- 19) windows function sum based on partition by date

select *, sum(Sales) 
over(partition by OrderDate order by Sales) as sales_rank
from storedata;

-- 20) ProductId sales

Select Product_ID,Sales
from storedata;
