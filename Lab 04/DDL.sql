create user lab04 identified by lab04;
conn SYSTEM/12345678

GRANT ALL PRIVILEGES TO lab04;

conn lab04/lab04



SET SERVEROUTPUT ON SIZE 1000000

drop table transaction;
drop table balance;
drop table account;
drop table accountproperty;


create table accountproperty(
    ap_id int,
    name VARCHAR2(100),
    profitrate numeric(2,1),
    graceperiod int,
    CONSTRAINT pk_id primary key (ap_id)
);


create table account(
    a_id int,
    name VARCHAR2(100),
    acccode int,
    openningdate date,
    lastdateinterest date,
    CONSTRAINT pk_id_acc primary key (a_id),
    CONSTRAINT fk_acc_prop FOREIGN key (acccode) REFERENCES accountproperty(ap_id)
);

create table transaction(
    tid int,
    accno int,
    amount number,
    transactionDate date,
    CONSTRAINT pk_tid PRIMARY key (tid),
    CONSTRAINT fk_account FOREIGN key (accno) REFERENCES account(a_id)
);


-- create table balance(
--     accno int,
--     principalamount number,
--     profitamount number,
--     CONSTRAINT pk_accno primary key (accno),
--     CONSTRAINT fk_account_id FOREIGN key (accno) REFERENCES account(id)

-- );

create table balance(
    accno int,
    principalamount number,
    profitamount number,
    CONSTRAINT pk_accno primary key (accno),
    CONSTRAINT fk_account_id FOREIGN key (accno) REFERENCES account(a_id)
);


insert into accountproperty values (2002, 'monthly', 2.8, 1);
insert into accountproperty values (3003, 'quarterly', 4.2, 4);
insert into accountproperty values (4004, 'biyearly', 6.8, 6);
insert into accountproperty values (5005, 'yearly', 8, 12);

insert into account values (1, 'Sian', 2002, TO_DATE('2023-01-23', 'YYYY-MM-DD'), TO_DATE('2024-01-23', 'YYYY-MM-DD'));
insert into account values (2, 'Dihan', 3003, TO_DATE('2023-01-24', 'YYYY-MM-DD'), TO_DATE('2024-01-23', 'YYYY-MM-DD'));
insert into account values (3, 'Naz', 4004, TO_DATE('2023-01-25', 'YYYY-MM-DD'), TO_DATE('2024-01-23', 'YYYY-MM-DD'));
insert into account values (4, 'Nafisa', 5005, TO_DATE('2023-01-26', 'YYYY-MM-DD'), TO_DATE('2024-01-23', 'YYYY-MM-DD'));

insert into transaction values (1, 1, 1000,TO_DATE('2023-01-31', 'YYYY-MM-DD') );
insert into transaction values (2, 1, 1000,TO_DATE('2023-01-30', 'YYYY-MM-DD') );
insert into transaction values (3, 1, 1000,TO_DATE('2023-01-29', 'YYYY-MM-DD') );


insert into balance values (1, 6900, 0);
insert into balance values (2, 100670, 0);
insert into balance values (3, 10000, 0);
insert into balance values (4, 12000, 0);
