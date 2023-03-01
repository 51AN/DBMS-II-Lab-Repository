--ddl trigger

DECLARE
IP_ADDRESS VARCHAR2 (11) ;
BEGIN
IF ORA_SYSEVENT = ' LOGON ' THEN
IP_ADDRESS := ORA_CLIENT_IP_ADDRESS ;
DBMS_OUTPUT.PUT_LINE(IP_ADDRESS);
END IF;
END ;
/



create or replace procedure update_mommy
as
new_name citizen.name%type;
cursor rename_mommy(id, m_name) is 
    select citizen.name from citizen where id = citizen.id and m_name <> citizen.name;
cursor c_all is
    select * from citizen;

begin
    for row in c_all loop
    open rename_mommy(row.mothernid, row.mother_name);
            fetch rename_mommy into new_name;
            if(rename_mommy%found) then
                update citizen set mother_name = new_name;
            end if;
    end loop;

end;
/