-->1<--

create TABLESPACE tbs1
DATAFILE 'tbs1_data.dbf' SIZE 1M,
         'tbs2_data.dbf' SIZE 1M;
         
create TABLESPACE tbs2
DATAFILE 'tbs3_data.dbf' SIZE 1M,
         'tbs4_data.dbf' SIZE 1M;

-->2<--

create user s200042149 IDENTIFIED BY cse4410 default TABLESPACE tbs1;
create user s200042118 IDENTIFIED BY cse4410 default TABLESPACE tbs2;
grant all privileges to s200042149;
grant all privileges to s200042118;

alter user s200042149 quota 2M on tbs1;
alter user s200042149 quota 3M on tbs2;
--for another user here :
alter user s200042118 quota 3M on tbs1;
alter user s200042118 quota 4M on tbs2;

-->3<--

conn s200042149/cse4410;

create table department(
    dept_name varchar2(50),
    dept_id int,
    primary key (dept_id)
) TABLESPACE tbs1;

create table student(
    s_name varchar2(50),
    s_id int,
    dept_id int,
    primary key (s_id),
    FOREIGN KEY(dept_id) REFERENCES department(dept_id)
) TABLESPACE tbs1;

-->4<--

create table course(
    code int,
    c_name varchar2(50),
    credit int,
    offer_by int,
    primary key (code),
    FOREIGN KEY (offer_by) references department(dept_id)
) TABLESPACE tbs2;

-->5<--

insert into department values (
    'CSE',
    1
);

begin 
    for i in 1..9999 LOOP
        INSERT INTO student(
            s_name,
            s_id,
            dept_id
        ) values(
            'Sian',
            i,
            1
        );
        COMMIT;
    end LOOP;
end;
/

begin 
    for i in 1..6969 LOOP
        INSERT INTO course(
            code,
            c_name,
            credit,
            offer_by
        ) values(
            i,
            'DBMS',
            2,
            1
        );
        COMMIT;
    end LOOP;
end;
/

-->6<--
--connect to system to see free space
conn system/12345678
SELECT
    TABLESPACE_NAME,
    BYTES /1024/1024 MB
FROM
    DBA_FREE_SPACE
WHERE
    TABLESPACE_NAME ='TBS1';
    
SELECT
    TABLESPACE_NAME,
    BYTES /1024/1024 MB
FROM
    DBA_FREE_SPACE
WHERE
    TABLESPACE_NAME ='TBS2';

-->7<--

alter TABLESPACE tbs1 add datafile 'tbs5_data.dbf' size 1M;

-->8<--

alter DATABASE datafile 'tbs3_data.dbf' resize 5M;
alter DATABASE datafile 'tbs4_data.dbf' resize 5M;

-->9<--

SELECT
    TABLESPACE_NAME,
    SUM(BYTES/1024/1024) "Database Size(MB)"
FROM
    DBA_DATA_FILES
GROUP BY
    TABLESPACE_NAME;

-->10<--
DROP TABLESPACE tbs1
INCLUDING CONTENTS AND DATAFILES
CASCADE CONSTRAINTS;

-->11<--

DROP TABLESPACE tbs2
INCLUDING CONTENTS KEEP DATAFILES
CASCADE CONSTRAINTS;

--> extra task 1 : find the tables in tbs1 <--

select table_name
from ALL_TABLES
where  owner = 'S200042149' and tablespace_name='TBS1'; --giving owner here is not necessary

--> task 2 : student table in which tablespace <--

 select tablespace_name 
 from all_tables 
 where owner = 'S200042149' and table_name = 'STUDENT'; --giving owner here is not necessary