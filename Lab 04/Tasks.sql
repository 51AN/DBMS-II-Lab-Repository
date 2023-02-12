-->1 : principal amount in balance + all transactions made

create or replace
function current_balance(id number)
return number
is
    baseAmount number;
    balance number;
begin
balance := 0;
  select principalamount into baseAmount
    from balance
   where accno = id;
    balance := balance + baseAmount;
for row in (select amount from transaction where accno = id) loop
  balance := balance + row.amount;
end loop;

return balance;

end;
/

DECLARE
    amount number;
begin
    amount := current_balance(1);
  DBMS_OUTPUT.PUT_LINE(amount) ;
end;
/

-->2 : profit rate adds after the grace period has ended (yearly, biyearly etc.)

create or replace 
function GET_PROFIT(id number, fnBalance out number, fnProfit out number)
return varchar2 
is 
baseAmount number;
grace number;
rate number;
last_date date;
open_date date;
month number;
cnt number;
total_profit number;
final_balance number;
profit number;
output varchar2(5000);

begin

  baseAmount := 0;
  select principalamount into baseAmount
    from balance
   where accno = id;

    grace := 0;
    select accountproperty.graceperiod into grace
      from accountproperty ,account 
     where accountproperty.ap_id = account.acccode and account.a_id = id;

     rate := 0;
     select accountproperty.profitrate into rate
      from accountproperty ,account 
     where accountproperty.ap_id = account.acccode and account.a_id = id;

     select openningdate into open_date
       from account
      where account.a_id = id;

    month := TRUNC(MONTHS_BETWEEN(open_date, sysdate));
    cnt := 1;
    total_profit := 0;
    final_balance := baseAmount;

    for i in 1..month loop
      if cnt != grace then 
        profit := profit + final_balance*rate;
      elsif cnt = grace then
        final_balance := final_balance + profit;
        total_profit := total_profit + profit;
        profit := 0;
        cnt := 0;
      end if;
      cnt := cnt + 1;
        
    end loop;
    fnBalance := final_balance;
    fnProfit := total_profit;
    output := 'Profit : ' || total_profit || ' Balance before profit : ' || baseAmount || ' Balance after profit : ' || final_balance;
    return output;
    
end;
/

DECLARE
  output varchar2(1000);
  finalbalance number;
  finalprofit number;
begin
  output:= GET_PROFIT(1,finalbalance, finalprofit);
  DBMS_OUTPUT.PUT_LINE(output);
end;
/

-->3 : do for all account and update ammounts table

CREATE or replace
procedure  all_profit
AS
  output varchar2(1000);
  loop_id int;
  finalbalance number;
  finalprofit number;
  cursor c_profit
  is
    select a_id from account;
begin
  
  open c_profit;
  loop
    fetch c_profit into loop_id;
    exit when c_profit%notfound;
    output:= GET_PROFIT(loop_id,finalbalance, finalprofit);
    update balance set principalamount = finalbalance where accno = loop_id;
    update balance set profitamount = finalprofit where accno = loop_id;
  end loop;
  close c_profit;
end;
/


begin
  all_profit();
end;
/