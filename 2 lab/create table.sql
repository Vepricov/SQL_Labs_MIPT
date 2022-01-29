use TV
set dateformat dmy

create table COUNTRY
(
country_id int not null,
[name] varchar(30)

primary key(country_id)
);

create table CITY
(
city_id int not null,
[name] varchar(30),
country_id int

primary key(city_id)
foreign key(country_id) references COUNTRY(country_id)
);


create table DEPARTMENT
(
department_id int not null,
[name] varchar(50),
city_id int

primary key(department_id)
foreign key(city_id) references CITY(city_id)
);

create table CHANNEL
(
channel_id int not null,
[name] varchar(30),
descriprion varchar(30)

primary key(channel_id)
);

create table EMPLOYEE
(
employee_id int not null,
first_name varchar(30),
last_name varchar(30),
country_id int

primary key(employee_id)
foreign key(country_id) references COUNTRY(country_id) 
);


create table [TYPE]
(
[type_id] int not null,
[name] varchar(30)

primary key([type_id])
);

create table JOB
(
job_id int not null,
[function] varchar(50)

primary key(job_id)
);

create table [CONTRACT]
(
contract_id int not null,
job_id int,
employee_id int,
hire_date date,
department_id int,
salary money

primary key(contract_id)
foreign key(employee_id) references EMPLOYEE(employee_id),
foreign key(job_id) references JOB(job_id),
foreign key(department_id) references DEPARTMENT(department_id)
);

create table QUALITY
(
quality_id int not null,
quality varchar(10),
[description] varchar(20)

primary key(quality_id)
);

create table DANGER
(
danger_id int not null,
[level] int,
[description] varchar(30)

primary key(danger_id)
);

create table [EVENT]
(
event_id int not null,
[start_date] date,
end_date date,
danger_id int,
[description] varchar(50),
city_id int

primary key(event_id)
foreign key(danger_id) references DANGER(danger_id),
foreign key(city_id) references CITY(city_id)
);

create table REPORT
(
report_id int not null,
quality_id int,
[date] date,
[type_id] int,
event_id int,
duration time(0),
[name] varchar(50)

primary key(report_id)
foreign key([type_id]) references [TYPE]([type_id]),
foreign key(event_id) references [EVENT](event_id),
foreign key(quality_id) references QUALITY(quality_id)
);

create table REPORT_MAKERS
(
contract_id int not null,
report_id int not null

primary key(contract_id, report_id)
foreign key(contract_id) references [CONTRACT](contract_id),
foreign key(report_id) references REPORT(report_id)
);

create table BROADCAST
(
channel_id int not null,
broadcast_time datetime not null,
report_id int

primary key(channel_id, broadcast_time)
foreign key(channel_id) references CHANNEL(channel_id),
foreign key(report_id) references REPORT(report_id)
);