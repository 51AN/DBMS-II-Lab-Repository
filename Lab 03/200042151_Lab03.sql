-->1<--
create or replace Procedure 
required_time(title in varchar)
as 
    time number;
    hour number;
    minute number;
    intermission number;
begin
    select mov_time into time
    from movie
    where mov_title = title;
    
    intermission := 0;
    hour := 0;
    minute := 0;

    intermission:=floor(time/70);
    intermission:=intermission*15;
    time := time + intermission;
    hour:=floor(time/60);
    minute:=time-hour*60;
    
    DBMS_OUTPUT.PUT_LINE( 'HOUR: ' || hour || ' || Minute: ' || Minute || ' || Intermission(mins): ' ||intermission);
end;
/

begin
    required_time('Vertigo');
end;
/

-->2<--
create or replace Procedure 
top_rated(n in number)
as 
    c number;
    c2 number;
    average number;
begin
    select avg(rev_stars) into average
    from movie natural join rating natural join reviewer;
    
    c := 0;
    c2 := 0;
    
    for row in (select mov_title,rev_stars from movie natural join rating natural join reviewer) loop
        if(row.rev_stars>average)then
            c := c + 1;
        end if;
    end loop;
    if(c<n) then
        DBMS_OUTPUT.PUT_LINE('Error : Not enough movies!');
    else
        for row in (select mov_title,rev_stars from movie natural join rating natural join reviewer where rev_stars>average) loop
            c2 := c2 + 1;
            if(c2<=n)then
                DBMS_OUTPUT.PUT_LINE(row.mov_title);
            end if;
        end loop;
    end if;
end;
/

begin
    top_rated(15);
end;
/

-->3<--

create or replace 
function yearly_earnings(movieid number)
return number
is
    earnings number;
    release_date date;
    n number;
    yearly number;
begin
    earnings := 0;
    
    select mov_releasedate into release_date
    from  movie 
    where mov_id = movieid;


    for row in (select rev_stars from movie natural join rating natural join reviewer where mov_id = movieid and rev_stars>=6) loop
        earnings := earnings + (10*(10-row.rev_stars));
    end loop;

    
    yearly:=earnings/YEAR(sysdate-release_date);
    
    return yearly;
end;
/

BEGIN
    DBMS_OUTPUT.PUT_LINE(yearly_earnings(901));
END;
/


-->4<--

create or replace 
function genre_info(genid number)
return varchar
is
    rev_count number;
    v_avg number;
    v_status varchar2(200);
    total_average number;
    total_count number;
    result varchar2(1000);
begin
    v_status := 'nice genre';

    select count(rev_id) into rev_count
    from genres natural join mtype natural join rating 
    where gen_id = genid;

    select avg(rev_stars) into v_avg 
    from genres natural join mtype natural join rating 
    where gen_id = genid;

    select avg(rev_stars) into total_average
    from genres natural join mtype natural join rating;


    select avg(rev_count) into total_count
    from(
            select count(rev_id) as rev_count 
            from genres natural join mtype natural join rating 
            group by gen_title 
        );


    if(rev_count > total_average AND v_avg < total_average) THEN      
        v_status := 'Widely Watched';
    elsif(rev_count < total_average AND v_avg > total_average) THEN
        v_status := 'Highly Rated';
    elsif(rev_count > total_average AND v_avg > total_average) THEN
        v_status := 'Peoples favorite';
    else 
        v_status := 'So so';
    end if;


    result := 'Genre status : ' || v_status || ' || Review count : ' || rev_count || ' || Average rating : ' || v_avg;
    
    return result;
end;
/

DECLARE
    result varchar2(1000);
begin
    result := genre_info(1002);
    DBMS_OUTPUT.PUT_LINE(result);
end;
/

-->5<--

create or replace
function freq_genre(start_date movie.mov_releasedate%type, end_date movie.mov_releasedate%type )
return varchar2 
IS
    genre_id number;
    cnt_mov number;
    genre_name varchar2(100);
    result varchar2(1000);
BEGIN

    SELECT id INTO genre_id 
    FROM (
            SELECT mtype.gen_id AS id , count(mov_range.MOV_ID) AS mov_count 
            FROM (
                    SELECT * 
                    FROM MOVIE 
                    WHERE MOVIE.MOV_RELEASEDATE BETWEEN START_DATE AND END_DATE
                  ) mov_range , mtype 
            WHERE mov_range.MOV_ID = mtype.MOV_ID 
            GROUP BY mtype.gen_id 
            ORDER BY mov_count DESC
        )popular_gen 
    WHERE ROWNUM<=1;

    select gen_title into genre_name 
    from genres 
    where gen_id = genre_id; 

    select count(movie.mov_id) into cnt_mov 
    from movie ,mtype
    where movie.mov_id = mtype.mov_id and gen_id = genre_id and movie.MOV_RELEASEDATE between start_date and end_date;

    result := genre_name || ' Count of movies : ' || cnt_mov;

    return result;

end;
/


DECLARE
    start_date movie.mov_releasedate%type;
    end_date movie.mov_releasedate%type;
BEGIN
    start_date := '&start_date';
    end_date := '&end_date';
    DBMS_OUTPUT.PUT_LINE( freq_genre(to_date(start_date), to_date(end_date)));
end;
/


