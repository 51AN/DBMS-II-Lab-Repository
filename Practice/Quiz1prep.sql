--two ways of printing movie titles

-->1 using cursor
DECLARE
    c_title  movie.mov_title%type;
    cursor c_movie
    is 
        select mov_title
        from movie;
begin 
    open c_movie;
    loop
      fetch c_movie into c_title;
      exit when c_movie%notfound;
      DBMS_OUTPUT.PUT_LINE(c_title);
    end loop;
    close c_movie;
END;
/


-->2 without using cursor
begin 
    for row in (select mov_title from movie) loop
        DBMS_OUTPUT.PUT_LINE(row.mov_title);
    end loop;
end;
/


--standard looping
DECLARE
    a number(2);
BEGIN
    FOR a in 10 .. 20 LOOP
    dbms_output.put_line(’value of a: ’ || a);
    END LOOP;
END;
/

--for loop but in reverse
DECLARE
    a number(2) ;
BEGIN
    FOR a IN REVERSE 10 .. 20 LOOP
    dbms_output.put_line(’value of a: ’ || a);
    END LOOP;
END;
/


DECLARE
    c_title movie.mov_title%type;
    cursor c_movie 
    is 
    select mov_title
    from movie;

begin
  open c_movie;
    loop
        fetch c_movie into c_title;
      dbms_output.put_line(c_title);
    --   if (c_movie%notfound) then exit;
    --   end if;
    exit when c_movie%notfound;
    end loop;
  close c_movie;
end;
/



DECLARE
    var varchar2(20);
begin
  var := '&name';
  dbms_output.put_line('My name is '|| var);
end;
/




DECLARE
    i number;
begin
  for i in 1..10 loop
    dbms_output.put_line('My number is increasing man : ' || i);
  end loop;
end;



create or replace 
Procedure addition(a in number, c in number,  b out number, d out number)
as
begin
  b := a + c;
  d := a - c;
end;
/

DECLARE
    a number;
    b number;
    c number;
    d number;
begin
  a := '&a ';
  b := 0;
  c := '&c ';
  d := 0;
  addition(a,c,b,d);
  dbms_output.put_line('Addition : ' || b);
  dbms_output.put_line('Subtraction : ' || d);
end;
/






create or replace 
procedure calculate_transactions
as
  cursor c1
  is
  select SID , count(grade)
  from grades 
  where grade = 'F'
  group by SID
  having count(grade)>=3;

  amount number;
  accountnumber students.accountno%type;
  category courses.cat%type;
  creds courses.credit%type;

BEGIN
  amount := 0;
  for row in c1 loop

    select s.accountno into accountnumber
    from students s
    where s.id = row.SID;

    select c.cat into category, c.credit into creds
    from courses c, grades g
    where row.SID = g.SID and c.id = g.CID;

    if(category = 0 ) then amount := 50*creds;
    elsif (category = 1) then amount := 75*creds;
    end if;

    insert into transactions values(accountnumber, 101, sysdate, amount, 'deposit made', 1);
  end loop;

end;
/

begin 
  calculate_transactions()
end;
/