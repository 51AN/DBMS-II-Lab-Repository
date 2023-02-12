--> task 1 <--
drop sequence acc_serial;
create sequence acc_serial
minvalue 000001
maxvalue 999999
start with 000001
increment by 1
cache 20;

create or replace 
function id_gen(name varchar2, acc_code number, open_date date)
return varchar2
is
    acc_format varchar2(100);
    seq_id varchar2(10);
    seq_id_six varchar2(10);
    form_name varchar2(10);
    form_year varchar2(10);
    form_month varchar2(10);
    form_day varchar2(10);
    form_date varchar2(10);
begin
    select acc_serial.nextval into seq_id
    from dual;

    select lpad(seq_id,6,'0') into seq_id_six
    from dual;

    form_name := substr(name, 1, 3);
    --form_date := to_char(open_date, 'YYYYMMDD');
    form_year := to_char(open_date, 'YYYY');
    form_month := to_char(open_date, 'MM');
    form_day := to_char(open_date, 'DD');

    form_date := form_year || form_month || form_day;

    acc_format := acc_code || form_date || '.' || upper(form_name) || '.' || seq_id_six;

    return acc_format;
    
end;
/

begin
 DBMS_OUTPUT.PUT_LINE(id_gen('Sian',2002,TO_DATE('2023-01-23', 'YYYY-MM-DD'))) ;
end;
/
--> task 2 <--

alter table account modify a_id varchar2(50);
alter table transaction modify accno varchar2(50);
alter table balance modify accno varchar2(50);

--> task 3 <--
drop trigger assign_id;
create or replace trigger assign_id 
before
insert on account 
for each row
begin 
    :new.a_id := id_gen(:new.name, :new.acccode, :new.openningdate);
end;
/

--> task 4 <--
drop trigger insert_balance 
create or replace trigger insert_balance 
after
insert on account 
for each row
begin
    insert into balance values(:new.a_id, 5000, 0);
end;
/
--> task 5 <--

drop trigger update_balance;
create or replace trigger update_balance 
after
insert on transaction for each row
begin
    update balance set principalamount = principalamount + :new.amount where accno = :new.accno;
end;
/

insert into  account
values ('88','Ongkon',2002,TO_DATE('2023-01-23', 'YYYY-MM-DD'),TO_DATE('2024-01-23', 'YYYY-MM-DD'));

insert into transaction
values (89,'200220230123.ONG.000002',5000,TO_DATE('2023-02-07', 'YYYY-MM-DD'));