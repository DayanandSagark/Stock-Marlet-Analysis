-- Creating the schema stocks
create schema stocks_schema;


-- Using the schema stocks
use stocks_schema;

-- creating the base tables for all stocks understanding from CSV files getting only date and close price
-- creating bajaj_auto
create table bajaj_auto (
  `date` VARCHAR(20),
  `close_price` decimal(10,2)
);
-- create other base tables for other stocks like bajaj_auto
-- CREATE TABLE foo LIKE bar;
create table eicher_motors like bajaj_auto;
create table hero_motocorp like bajaj_auto;
create table infosys like bajaj_auto;
create table tcs like bajaj_auto;
create table tvs_motors like bajaj_auto;



-- imorting data using Table data import wizard and only select required columns for imported to above created tables
-- DONE importing all tables
 -- verify that all 889 rows inserted in all tables as per import wizard mysql
 
 
select count(*) from bajaj_auto;
select count(*) from eicher_motors;
select count(*) from hero_motocorp;
select count(*) from infosys;
select count(*) from tcs;
select count(*) from tvs_motors;
-- 889
-- 1. Create a new table named 'bajaj1' containing the date, close price, 20 Day MA and 50 Day MA. 
-- (This has to be done for all 6 stocks)
create table bajaj1 (
	`date` date,
	`close_price` decimal(10,2),
    `20_day_ma` decimal(10,2),
    `50_day_ma` decimal(10,2)  
);

-- create other tables for other stocks as well like bajaj1
create table eicher1 like bajaj1;
create table hero1 like bajaj1;	
create table infosys1 like bajaj1;
create table tcs1 like bajaj1;
create table tvs1 like bajaj1;

-- inserting the rows into the tables
-- INSERT INTO table2 (column1, column2, column3, ...)
-- SELECT column1, column2, column3, ...
-- FROM table1
-- WHERE condition;

insert into bajaj1 (date, close_price, 20_day_ma, 50_day_ma)
	select str_to_date(date, '%d-%M-%Y'),close_price,
    avg(close_price) over(order by str_to_date(date, '%d-%M-%Y') rows 19 preceding),
    avg(close_price) over(order by str_to_date(date, '%d-%M-%Y') rows 49 preceding)
    from bajaj_auto 
    order by str_to_date(date, '%d-%M-%Y'); 
    
    select * from bajaj1;
    
   insert into eicher1 (date, close_price, 20_day_ma, 50_day_ma)
	select str_to_date(date, '%d-%M-%Y'),close_price,
    avg(close_price) over(order by str_to_date(date, '%d-%M-%Y') rows 19 preceding),
    avg(close_price) over(order by str_to_date(date, '%d-%M-%Y') rows 49 preceding)
    from eicher_motors 
    order by str_to_date(date, '%d-%M-%Y');  
    
	insert into hero1(date, close_price, 20_day_ma, 50_day_ma)
	select str_to_date(date, '%d-%M-%Y'),close_price,
    avg(close_price) over(order by str_to_date(date, '%d-%M-%Y') rows 19 preceding),
    avg(close_price) over(order by str_to_date(date, '%d-%M-%Y') rows 49 preceding)
    from hero_motocorp 
    order by str_to_date(date, '%d-%M-%Y'); 
    
	insert into infosys1(date, close_price, 20_day_ma, 50_day_ma)
	select str_to_date(date, '%d-%M-%Y'),close_price,
    avg(close_price) over(order by str_to_date(date, '%d-%M-%Y') rows 19 preceding),
    avg(close_price) over(order by str_to_date(date, '%d-%M-%Y') rows 49 preceding)
    from infosys 
    order by str_to_date(date, '%d-%M-%Y'); 
    
    
   insert into tcs1(date, close_price, 20_day_ma, 50_day_ma)
	select str_to_date(date, '%d-%M-%Y'),close_price,
    avg(close_price) over(order by str_to_date(date, '%d-%M-%Y') rows 19 preceding),
    avg(close_price) over(order by str_to_date(date, '%d-%M-%Y') rows 49 preceding)
    from tcs
    order by str_to_date(date, '%d-%M-%Y'); 

 insert into tvs1(date, close_price, 20_day_ma, 50_day_ma)
	select str_to_date(date, '%d-%M-%Y'),close_price,
    avg(close_price) over(order by str_to_date(date, '%d-%M-%Y') rows 19 preceding),
    avg(close_price) over(order by str_to_date(date, '%d-%M-%Y') rows 49 preceding)
    from tvs_motors
    order by str_to_date(date, '%d-%M-%Y'); 
    commit;    
    
    select * from tvs1;
    select * from tcs1;
    select * from bajaj1;
    select * from eicher1;
    select * from infosys1;
    select * from hero1;
    
    -----------------------
    -- CHecking count
select count(*) from bajaj1;
select count(*) from eicher1;
select count(*) from hero1;
select count(*) from infosys1;
select count(*) from tcs1;
select count(*) from tvs1;
---------------------------------------

-- 2. Create a master table containing the date and close price of all the six stocks. 
-- (Column header for the price is the name of the stock)


create table master_stock_tbl (
	`date` date,
	`bajaj` decimal(10,2),
    `tcs` decimal(10,2),
    `tvs` decimal(10,2),
    `infosys` decimal(10,2),
    `eicher` decimal(10,2),
    `hero` decimal(10,2)  
); 
insert into master_stock_tbl (date,bajaj,tcs,tvs,infosys,eicher,hero)
select bajaj1.date,bajaj1.close_price,tcs1.close_price,tvs1.close_price,
		infosys1.close_price,eicher1.close_price,hero1.close_price
        from bajaj1 inner join tcs1
        on bajaj1.date = tcs1.date
        inner join tvs1 on bajaj1.date = tvs1.date
        inner join infosys1 on bajaj1.date = infosys1.date
        inner join eicher1 on bajaj1.date = eicher1.date
        inner join hero1 on bajaj1.date = hero1.date
        order by date;
        
select * from master_stock_tbl;
-------------------------------------------------
-- 3. Use the table created in Part(1) to generate buy and sell signal. 
-- Store this in another table named 'bajaj2'. 
-- Perform this operation for all stocks.
-- Create new tables bajaj2, eicher2, hero2, infosys2, tcs2, tvs2


create table bajaj2 (
	`date` date,
	`close_price` decimal(10,2),
    `signal` varchar(15)
);


create table eicher2 like bajaj2;
create table hero2 like bajaj2;
create table infosys2 like bajaj2;
create table tcs2 like bajaj2;
create table tvs2 like bajaj2;


-- SELECT value - lag(value) OVER (ORDER BY Id) FROM table
insert into bajaj2 (date,close_price,`signal`) 
	select date, close_price,		
		case
			when row_number() over(order by date) < 50 
				then 'NA'
			when 20_day_ma > 50_day_ma and (lag(20_day_ma,1) over (order by date)) < (lag(50_day_ma,1) over (order by date)) 
				then 'Buy'
			when 20_day_ma < 50_day_ma and (lag(20_day_ma,1) over (order by date)) > (lag(50_day_ma,1) over (order by date))
				then 'Sell'
			else 'Hold'	
		end	
	from  bajaj1
   	order by date; 
    select * from bajaj2;
    select * from bajaj1;
 insert into infosys2 (date,close_price,`signal`) 
	select date, close_price,		
		case
			when row_number() over(order by date) < 50 
				then 'NA'
			when 20_day_ma > 50_day_ma and (lag(20_day_ma,1) over (order by date)) < (lag(50_day_ma,1) over (order by date)) 
				then 'Buy'
			when 20_day_ma < 50_day_ma and (lag(20_day_ma,1) over (order by date)) > (lag(50_day_ma,1) over (order by date))
				then 'Sell'
			else 'Hold'	
		end	
	from  infosys1
   	order by date;
    
    select * from infosys2;
    select * from infosys1;
    
 insert into eicher2 (date,close_price,`signal`) 
	select date, close_price,		
		case
			when row_number() over(order by date) < 50 
				then 'NA'
			when 20_day_ma > 50_day_ma and (lag(20_day_ma,1) over (order by date)) < (lag(50_day_ma,1) over (order by date)) 
				then 'Buy'
			when 20_day_ma < 50_day_ma and (lag(20_day_ma,1) over (order by date)) > (lag(50_day_ma,1) over (order by date))
				then 'Sell'
			else 'Hold'	
		end	
	from  eicher1
   	order by date;
    
    select * from eicher2;
    select * from eicher1; 

 insert into hero2 (date,close_price,`signal`) 
	select date, close_price,		
		case
			when row_number() over(order by date) < 50 
				then 'NA'
			when 20_day_ma > 50_day_ma and (lag(20_day_ma,1) over (order by date)) < (lag(50_day_ma,1) over (order by date)) 
				then 'Buy'
			when 20_day_ma < 50_day_ma and (lag(20_day_ma,1) over (order by date)) > (lag(50_day_ma,1) over (order by date))
				then 'Sell'
			else 'Hold'	
		end	
	from  hero1
   	order by date;
    
    select * from hero2;
    select * from hero1;

 insert into tcs2 (date,close_price,`signal`) 
	select date, close_price,		
		case
			when row_number() over(order by date) < 50 
				then 'NA'
			when 20_day_ma > 50_day_ma and (lag(20_day_ma,1) over (order by date)) < (lag(50_day_ma,1) over (order by date)) 
				then 'Buy'
			when 20_day_ma < 50_day_ma and (lag(20_day_ma,1) over (order by date)) > (lag(50_day_ma,1) over (order by date))
				then 'Sell'
			else 'Hold'	
		end	
	from  tcs1
   	order by date;
    
    select * from tcs2;
    select * from tcs1;

 insert into tvs2 (date,close_price,`signal`) 
	select date, close_price,		
		case
			when row_number() over(order by date) < 50 
				then 'NA'
			when 20_day_ma > 50_day_ma and (lag(20_day_ma,1) over (order by date)) < (lag(50_day_ma,1) over (order by date)) 
				then 'Buy'
			when 20_day_ma < 50_day_ma and (lag(20_day_ma,1) over (order by date)) > (lag(50_day_ma,1) over (order by date))
				then 'Sell'
			else 'Hold'	
		end	
	from  tvs1
   	order by date;
    
    select * from tvs2;
    select * from tvs1;


DELIMITER //

CREATE FUNCTION BajajSignal(date1 date) 
	RETURNS varchar(15) DETERMINISTIC
BEGIN
 DECLARE opsignal varchar(15);
  select bajaj2.signal into opsignal
  from bajaj2
  where date = date1;
  RETURN opsignal;
END 

//

DELIMITER ;

select BajajSignal('2015-08-25');

DELIMITER //

CREATE FUNCTION EicherSignal(date1 date) 
	RETURNS varchar(15) DETERMINISTIC
BEGIN
 DECLARE opsignal varchar(15);
  select eicher2.signal into opsignal
  from eicher2
  where date = date1;
  RETURN opsignal;
END 

//

DELIMITER ;

select EicherSignal('2015-08-25');

-- 5.Check buy and sell signals at each stock having highest close_price 
-- Queries below for inferences

-- For Bajaj

select date, close_price
from bajaj2
where `signal` = 'Buy'
order by close_price
 limit 1;

select date, close_price
from bajaj2
where `signal` = 'Sell'
order by close_price desc
limit 1;


-- For Eicher

select date, close_price
from eicher2
where `signal` = 'Buy'
order by close_price
limit 1;

select date, close_price
from eicher2
where `signal` = 'Sell'
order by close_price desc
limit 1;


-- For Hero

select date, close_price
from hero2
where `signal` = 'Buy'
order by close_price
limit 1;

select date, close_price
from hero2
where `signal` = 'Sell'
order by close_price desc
limit 1;


-- For Infosys 

select date, close_price
from infosys2
where `signal` = 'Buy'
order by close_price
limit 1;

select date, close_price
from infosys2
where `signal` = 'Sell'
order by close_price desc
limit 1;

-- For tcs 

select date, close_price
from tcs2
where `signal` = 'Buy'
order by close_price
limit 1;

select date, close_price
from tcs2
where `signal` = 'Sell'
order by close_price desc
limit 1;

-- For tvs 

select date, close_price
from tvs2
where `signal` = 'Buy'
order by close_price
limit 1;

select date, close_price
from tvs2
where `signal` = 'Sell'
order by close_price desc
limit 1;
