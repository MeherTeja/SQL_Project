use sql_q4;
drop table student2;

create table student2(
	studentId int primary key,
    firstname varchar(255),
    lastname varchar(255),
    email varchar(255),
    course varchar(255),
    yoj date
    );

create table course1(
	courseId int primary key,
    coursename varchar(255),
    branches varchar(255),
    courseFee varchar(255)
    );
select * from student2;
select *from course1;

set sql_safe_updates=0;

create table enrollment(
	enrollmentId int,
    studentId int,
    courseId int,
    enrollmentDate date,
    foreign Key(studentId) references student2(studentId),
	foreign Key(courseId) references course1(courseId)
);


create table instructor(
	instructorId int,
    firstname varchar(255),
    lastname  varchar(255),
    email varchar(255)
);

alter table instructor add column branches varchar(255);

select *from student2;

select *from course1;

select *from instructor;


drop table instructor;
set sql_safe_updates=0;
delimiter $$
create procedure student2_table(
	in studentId int,
    in firstname varchar(255),
    in lastname varchar(255),
    in email varchar(255),
    in course varchar(255),
    in yoj date
)
begin
	insert into student2 values(studentId,firstname,lastname,email,course,yoj);
end $$
delimiter ;

delimiter $$
create procedure course1_table(
	in courseId int,
    in coursename varchar(255),
    in branches varchar(255),
    in courseFee varchar(255)
)
begin
	insert into course1 values(courseId,coursename,branches,courseFee);
end $$
delimiter ;



select *from enrollment;

select
c1.coursename as course_not_enrolled_by_Student
from course1 c1 where c1.courseId not in(
select e1.courseId from enrollment e1
);

delimiter $$
create procedure enroll_table(
	in enrollmentId int,
    in studentId varchar(255),
    in courseId varchar(255),
    in enrollmentDate varchar(255)
)
begin
	insert into enrollment values(enrollmentId,studentId,courseId,enrollmentDate);
end $$
delimiter ;

create view unique_enroll_id_1
as
select  distinct enrollmentId,studentId,courseId,enrollmentDate
from enrollment;

select *from unique_enroll_id_1;

select 
e1.courseId, count(e1.studentId) as no_of_stud_enrolled
from unique_enroll_id_1 e1
left join
course1 c1
on
e1.courseId=c1.courseId
group by e1.courseId;

select 
c1.coursename,c1.courseId
from course1 c1
where c1.courseId not in(
select e1.courseId 
from enrollment e1
join
course1 c1
on e1.courseId=c1.courseId);

select 
e2.enrollmentId,e2.studentId,e2.courseId
from enrollment e2
left join 
student2 s2
on
e2.studentId=s2.studentId;


drop procedure instructor_table;

set sql_safe_updates=0;
delimiter $$
create procedure instructor_table(
	in instructorId int,
    in firstname varchar(255),
    in lastname varchar(255),
    in email varchar(255),
    in branches varchar(255)
)
begin
	insert into instructor values(instructorId,firstname,lastname,email,branches);
end $$
delimiter ;


select *from student2;


select *from course1;

-- 1) query for no.of students purchased course

select
 count(e1.studentId) as student_enrolled_cnt,e1.courseId
from enrollment e1 
left join 
student2 s1
on
s1.studentId=e1.studentId
group by e1.courseId;


-- 2) query for retrieving courses not enrolled by student

select
c1.coursename as course_not_enrolled_by_Student
from course1 c1
left join 
enrollment e1
on
c1.courseId<>e1.courseId;


select *from course1;
select *from enrollment;

-- 3) query for courseId,coursename,coursebranch,instructorid,firstname

select 
c1.courseId, c1.coursename,c1.branches,i.instructorId,i.firstname
from course1 c1,instructor i ;


-- 4) query for student_id with coursename

select 
e1.studentId,e1.courseId
from enrollment e1
left join 
course1 c1
on
e1.courseId=c1.courseId;



select studentId,count(studentId) from enrollment group by studentId;

select *from enrollment;


-- 5) student details based on max course purchased
select s2.studentId,s2.firstname,s2.lastname
from student2 s2
join 
enrollment e1
on
s2.studentId=e1.studentId
group by e1.studentId order by count(courseId) desc;

-- 6) rank for student based on course fee

create view course_fee as
select c1.courseFee
from course1 c1
join
enrollment e1
on
e1.courseId=c1.courseId;

select * from course_fee;
select *, rank() over(partition by courseFee order by courseFee) from course_fee;

-- store data
create schema store_data1;

use store_data1;

drop table storedata;
select * from storedata;

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
