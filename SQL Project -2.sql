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

