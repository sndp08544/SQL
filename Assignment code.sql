# 1) Creating tabels from existing tabels with required columns and derived columns
create table bajaj1 as 
	select str_to_date(Date, '%d-%M-%Y') as `Date`,`Close price` 
	from bajaj_auto 
	order by `Date` asc;
alter table bajaj1
	ADD `20 Day MA` double default null,
	ADD	`50 Day MA` double default null;
create table tmp as
	(SELECT Date, `Close price`, ROW_NUMBER() OVER (ORDER BY `Date` ASC) RowNumber,
       AVG(`Close price`) OVER (ORDER BY `Date` ASC ROWS 19 PRECEDING) AS `20 Day MA`,
       AVG(`Close price`) OVER (ORDER BY `Date` ASC ROWS 49 PRECEDING) AS `50 Day MA`
	FROM bajaj1);
UPDATE bajaj1 
   SET `20 Day MA`= (SELECT `20 Day MA` FROM tmp WHERE bajaj1.Date = tmp.Date and RowNumber > 19),
   `50 Day MA`= (SELECT `50 Day MA` FROM tmp WHERE bajaj1.Date = tmp.Date and RowNumber > 49);
drop table tmp;

#Creating Eicher1 table
create table eicher1 as 
	select str_to_date(Date, '%d-%M-%Y') as `Date`,`Close price` 
	from eicher_motors 
	order by `Date` asc;
alter table eicher1
	ADD `20 Day MA` double default null,
	ADD	`50 Day MA` double default null;
create table tmp as
	(SELECT Date, `Close price`, ROW_NUMBER() OVER (ORDER BY `Date` ASC) RowNumber,
       AVG(`Close price`) OVER (ORDER BY `Date` ASC ROWS 19 PRECEDING) AS `20 Day MA`,
       AVG(`Close price`) OVER (ORDER BY `Date` ASC ROWS 49 PRECEDING) AS `50 Day MA`
	FROM eicher1);
UPDATE eicher1 
   SET `20 Day MA`= (SELECT `20 Day MA` FROM tmp WHERE eicher1.Date = tmp.Date and RowNumber > 19),
   `50 Day MA`= (SELECT `50 Day MA` FROM tmp WHERE eicher1.Date = tmp.Date and RowNumber > 49);
drop table tmp;

#Creating Hero1 table
create table hero1 as 
	select str_to_date(Date, '%d-%M-%Y') as `Date`,`Close price` 
	from hero_motocorp 
	order by `Date` asc;
alter table hero1
	ADD `20 Day MA` double default null,
	ADD	`50 Day MA` double default null;
create table tmp as
	(SELECT Date, `Close price`, ROW_NUMBER() OVER (ORDER BY `Date` ASC) RowNumber,
       AVG(`Close price`) OVER (ORDER BY `Date` ASC ROWS 19 PRECEDING) AS `20 Day MA`,
       AVG(`Close price`) OVER (ORDER BY `Date` ASC ROWS 49 PRECEDING) AS `50 Day MA`
	FROM hero1);
UPDATE hero1 
   SET `20 Day MA`= (SELECT `20 Day MA` FROM tmp WHERE hero1.Date = tmp.Date and RowNumber > 19),
   `50 Day MA`= (SELECT `50 Day MA` FROM tmp WHERE hero1.Date = tmp.Date and RowNumber > 49);
drop table tmp;

#Creating Infosys1 table
create table Infosys1 as 
	select str_to_date(Date, '%d-%M-%Y') as `Date`,`Close price` 
	from infosys 
	order by `Date` asc;
alter table Infosys1
	ADD `20 Day MA` double default null,
	ADD	`50 Day MA` double default null;
create table tmp as
	(SELECT Date, `Close price`, ROW_NUMBER() OVER (ORDER BY `Date` ASC) RowNumber,
       AVG(`Close price`) OVER (ORDER BY `Date` ASC ROWS 19 PRECEDING) AS `20 Day MA`,
       AVG(`Close price`) OVER (ORDER BY `Date` ASC ROWS 49 PRECEDING) AS `50 Day MA`
	FROM Infosys1);
UPDATE Infosys1 
   SET `20 Day MA`= (SELECT `20 Day MA` FROM tmp WHERE Infosys1.Date = tmp.Date and RowNumber > 19),
   `50 Day MA`= (SELECT `50 Day MA` FROM tmp WHERE Infosys1.Date = tmp.Date and RowNumber > 49);
drop table tmp;

#Creating TCS1 table
create table TCS1 as 
	select str_to_date(Date, '%d-%M-%Y') as `Date`,`Close price` 
	from tcs 
	order by `Date` asc;
alter table TCS1
	ADD `20 Day MA` double default null,
	ADD	`50 Day MA` double default null;
create table tmp as
	(SELECT Date, `Close price`, ROW_NUMBER() OVER (ORDER BY `Date` ASC) RowNumber,
       AVG(`Close price`) OVER (ORDER BY `Date` ASC ROWS 19 PRECEDING) AS `20 Day MA`,
       AVG(`Close price`) OVER (ORDER BY `Date` ASC ROWS 49 PRECEDING) AS `50 Day MA`
	FROM TCS1);
UPDATE TCS1 
   SET `20 Day MA`= (SELECT `20 Day MA` FROM tmp WHERE TCS1.Date = tmp.Date and RowNumber > 19),
   `50 Day MA`= (SELECT `50 Day MA` FROM tmp WHERE TCS1.Date = tmp.Date and RowNumber > 49);
drop table tmp;

#Creating TVS1 table
create table TVS1 as 
	select str_to_date(Date, '%d-%M-%Y') as `Date`,`Close price` 
	from tvs_motors 
	order by `Date` asc;
alter table TVS1
	ADD `20 Day MA` double default null,
	ADD	`50 Day MA` double default null;
create table tmp as
	(SELECT Date, `Close price`, ROW_NUMBER() OVER (ORDER BY `Date` ASC) RowNumber,
       AVG(`Close price`) OVER (ORDER BY `Date` ASC ROWS 19 PRECEDING) AS `20 Day MA`,
       AVG(`Close price`) OVER (ORDER BY `Date` ASC ROWS 49 PRECEDING) AS `50 Day MA`
	FROM TVS1);
UPDATE TVS1 
   SET `20 Day MA`= (SELECT `20 Day MA` FROM tmp WHERE TVS1.Date = tmp.Date and RowNumber > 19),
   `50 Day MA`= (SELECT `50 Day MA` FROM tmp WHERE TVS1.Date = tmp.Date and RowNumber > 49);
drop table tmp;

#2) Creating a master file
create table master1 as
	select b.Date as Date, b.`Close price` as Bajaj, e.`Close price` as Eicher,h.`Close price` as Hero,i.`Close price` as Infosys,
    tc.`Close price` as TCS,tv.`Close price` as TVS
	from bajaj1 b inner join eicher1 e on b.Date = e.Date
    inner join hero1 h on b.Date = h.Date
    inner join infosys1 i on b.Date = i.Date
    inner join tcs1 tc on b.Date = tc.Date
    inner join tvs1 tv on b.Date = tv.Date;
    
#3) Generation of Buy/Sell Signal for Bajaj company
create table bajaj2 as
	select Date,`Close price`
	from bajaj1;
alter table bajaj2
	add `Signal` text;
CREATE  TABLE temp( SELECT Date,`Close price`,`20 Day MA`,`50 Day MA`,`20 Day MA` - `50 Day MA` as diff,
					lag(`20 Day MA` - `50 Day MA`,1) over () as lag_diff
                    FROM bajaj1) order by Date;
update bajaj2
	set `Signal` = (select case when diff > 0 and (lag_diff < 0 or lag_diff IS NULL) then "Buy"
								when diff < 0 and (lag_diff > 0 or lag_diff IS NULL) then "Sell"
                                else "Hold"  
                                end as "Signal" from temp
					where bajaj2.Date = temp.Date);
drop table temp;

# Generation of Buy/Sell Signal for Eicher company
create table eicher2 as
	select Date,`Close price`
	from eicher1;
alter table eicher2
	add `Signal` text;
CREATE  TABLE temp( SELECT Date,`Close price`,`20 Day MA`,`50 Day MA`,`20 Day MA` - `50 Day MA` as diff,
					lag(`20 Day MA` - `50 Day MA`,1) over () as lag_diff
                    FROM eicher1) order by Date;
update eicher2
	set `Signal` = (select case when diff > 0 and (lag_diff < 0 or lag_diff IS NULL) then "Buy"
								when diff < 0 and (lag_diff > 0 or lag_diff IS NULL) then "Sell"
                                else "Hold"  
                                end as "Signal" from temp
					where eicher2.Date = temp.Date);
drop table temp;

# Generation of Buy/Sell Signal for Hero company
create table hero2 as
	select Date,`Close price`
	from hero1;
alter table hero2
	add `Signal` text;
CREATE  TABLE temp( SELECT Date,`Close price`,`20 Day MA`,`50 Day MA`,`20 Day MA` - `50 Day MA` as diff,
					lag(`20 Day MA` - `50 Day MA`,1) over () as lag_diff
                    FROM hero1) order by Date;
update hero2
	set `Signal` = (select case when diff > 0 and (lag_diff < 0 or lag_diff IS NULL) then "Buy"
								when diff < 0 and (lag_diff > 0 or lag_diff IS NULL) then "Sell"
                                else "Hold"  
                                end as "Signal" from temp
					where hero2.Date = temp.Date);
drop table temp;

# Generation of Buy/Sell Signal for Infosys company
create table infosys2 as
	select Date,`Close price`
	from infosys1;
alter table infosys2
	add `Signal` text;
CREATE  TABLE temp( SELECT Date,`Close price`,`20 Day MA`,`50 Day MA`,`20 Day MA` - `50 Day MA` as diff,
					lag(`20 Day MA` - `50 Day MA`,1) over () as lag_diff
                    FROM infosys1) order by Date;
update infosys2
	set `Signal` = (select case when diff > 0 and (lag_diff < 0 or lag_diff IS NULL) then "Buy"
								when diff < 0 and (lag_diff > 0 or lag_diff IS NULL) then "Sell"
                                else "Hold"  
                                end as "Signal" from temp
					where infosys2.Date = temp.Date);
drop table temp;

# Generation of Buy/Sell Signal for TCS company
create table TCS2 as
	select Date,`Close price`
	from tcs1;
alter table TCS2
	add `Signal` text;
CREATE  TABLE temp( SELECT Date,`Close price`,`20 Day MA`,`50 Day MA`,`20 Day MA` - `50 Day MA` as diff,
					lag(`20 Day MA` - `50 Day MA`,1) over () as lag_diff
                    FROM tcs1) order by Date;
update TCS2
	set `Signal` = (select case when diff > 0 and (lag_diff < 0 or lag_diff IS NULL) then "Buy"
								when diff < 0 and (lag_diff > 0 or lag_diff IS NULL) then "Sell"
                                else "Hold"  
                                end as "Signal" from temp
					where TCS2.Date = temp.Date);
drop table temp;

# Generation of Buy/Sell Signal for TVS company
create table TVS2 as
	select Date,`Close price`
	from tvs1;
alter table TVS2
	add `Signal` text;
CREATE  TABLE temp( SELECT Date,`Close price`,`20 Day MA`,`50 Day MA`,`20 Day MA` - `50 Day MA` as diff,
					lag(`20 Day MA` - `50 Day MA`,1) over () as lag_diff
                    FROM tvs1) order by Date;
update TVS2
	set `Signal` = (select case when diff > 0 and (lag_diff < 0 or lag_diff IS NULL) then "Buy"
								when diff < 0 and (lag_diff > 0 or lag_diff IS NULL) then "Sell"
                                else "Hold"  
                                end as "Signal" from temp
					where TVS2.Date = temp.Date);
drop table temp;

#4) Creating a stored procedure to extract signal for any particular date
DELIMITER $$

CREATE FUNCTION Decision(date1 date) 
RETURNS varchar(10) 
DETERMINISTIC
BEGIN
 DECLARE signal1 varchar(10);
  set signal1 = (select `Signal` from bajaj2 where Date = date1);
  RETURN signal1;
END 
$$
DELIMITER ;

#Calling the function
select Decision('2018-06-21');