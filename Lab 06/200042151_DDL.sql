conn SYSTEM/12345678
--create user lab05 identified by lab05;

GRANT ALL PRIVILEGES TO lab05;

conn lab05/lab05

SET SERVEROUTPUT ON SIZE 1000000

drop table call;
drop table sim;
drop table plan;
drop table customer;

-->Task 2.a

create table customer(
    cid varchar2(20),
    c_name varchar2(100),
    dob date,
    address varchar2(100),
    CONSTRAINT pk_cid primary key (cid)
);

create table plan(
    p_name varchar2(100),
    chargePerMin int,
    CONSTRAINT pk_pname primary key (p_name)
);

create table sim(
    sim_no varchar2(20),
    cid varchar2(20),
    p_name varchar2(100),
    constraint pk_simno primary key (sim_no),
    constraint fk_cid FOREIGN key (cid) references customer(cid),
    constraint fk_pname FOREIGN key (p_name) references plan(p_name)
);

create table call(
    callID varchar2(20),
    sim_no varchar2(20),
    callBegin date,
    callEnd date,
    charge int,
    constraint pk_callid primary key (callID),
    constraint fk_simno FOREIGN key (sim_no) references sim(sim_no)
);



-->Task 3

drop table StudentTransactions;
drop table misconducts;
drop table students;

create table students(
    ID varchar2(20),
    s_name varchar2(50),
    program varchar2(50),
    year int,
    cgpa NUMERIC(3,2),
    constraint pk_studentsID primary key (ID)
);


create table misconducts(
    StudentID varchar2(20),
    date_time date,
    description varchar2(1000),
    constraint fk_StudentID foreign key (StudentID) references students(ID)
);

create table StudentTransactions(
    StudentID varchar2(20),
    date_time date,
    amount int,
    constraint fk_StudentID_Trans foreign key (StudentID) references students(ID)
);