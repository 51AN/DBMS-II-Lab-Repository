-->Task 2.b
create or replace 
function charge_calc(sim_no varchar2, callBegin date, callEnd date)
return int
is 
    charge int;
    duration int;
    cpm int;
begin

    select plan.chargePerMin into cpm
    from sim, plan
    where sim.sim_no = sim_no and sim.p_name = plan.p_name;

  charge := 0;
  duration := (callEnd - callBegin)*24*60*60;

  while(duration>0) loop 
      charge := charge + cpm;
      duration := duration - 60;
    end loop;
    --update call set call.charge = charge where call.sim_no = sim_no and call.callBegin = callBegin and call.callEnd = callEnd;
    return charge;


end;
/

-->Task 2.c

drop sequence call_serial;
create sequence call_serial
minvalue 00000001
maxvalue 99999999
start with 00000001
increment by 1
cache 20;

create or replace 
function id_gen(callBegin date)
return varchar2
is
    call_date varchar2(10);
    seq_id varchar2(10);
    seq_id_eig varchar2(10);
    output varchar2(30);
begin
    select call_serial.nextval into seq_id
    from dual;

    select lpad(seq_id,8,'0') into seq_id_eig
    from dual;

    call_date := to_char(callBegin, 'YYYYMMDD');

    output := call_date || '.' || seq_id_eig;
    return output;

end;
/

drop trigger call_id_trig;
create or replace trigger call_id_trig
before insert on call 
for each ROW
begin
  :new.callID := id_gen(:new.callBegin);
end;
/

-->Task 3

create or replace 
function SCHOLARHIP_Func(Total_MS number, PSamount number, NoMS out number)
return number
is
    cursor c is 
        select ID , cgpa
        from students
        where cgpa >= 3.5
        order by cgpa desc;
    PotentGotMS number;
    total_selected number;

begin
    total_selected := 0;
    NoMS := 0;
    PotentGotMS := floor(Total_MS/PSamount);

    for i in c loop
      select StudentID 
      from misconducts
      where StudentID = i.id;
      if(sql%notfound) then
        total_selected := total_selected + 1;
      end if;
    end loop;


    if(PotentGotMS > total_selected) then 
        return total_selected;
    elsif(PotentGotMS < total_selected) then
        NoMS := total_selected - PotentGotMS
        return PotentGotMS;

end;
/