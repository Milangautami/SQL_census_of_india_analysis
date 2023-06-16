-- CENSUS OF INDIA 2011 ANALYSIS:

show databases;
create database cencus;
use cencus;
show tables;

select * from data1;
select * from data2;

#1 - show all unique states:
select distinct state from data1;

#2 - show total number of rows in both dataset:
select count(*) from data1;
select count(*) from data2;

#3 - show all data for state gujarat and rajasthan:
select * from data1 where state in("gujarat","Rajasthan");

#4 - show total population of india:
select sum(population) as 'india_populaion' from data2;

#5 - show all states starting with u
select distinct state from data1 where state like 'u%';

#6 - show highest literacy and lowest literacy rate:
select max(literacy),min(literacy) from data1;

#7 - determine the 5th highest sex_ratio and district:
select sex_ratio,district from data1 order by sex_ratio desc limit 4,1;

#8 - show districs whose sex_ratio lies between 700 to 800:
select * from data1 where Sex_Ratio between 700 and 800;
                      #or(using subquery)
select * from data1 where district in(select district from data1 where Sex_Ratio>=700 and Sex_Ratio<=800);

#9 - give three class based on literacy rate:
select district,case 
	            when literacy>90 then 'good literacy district'
	            when literacy>=80 and literacy<=90 then 'medium literacy district'
	            else 'bad literacy district'
	            end as class
from data1;

#10 - show growth percentage by state vise:
select state,round(avg(growth)*100,2) as avg_growth from data1
group by state;

#11 - show all states whose literacy rate is greater than 90 in descending order:
select state,avg(literacy) as avg_literacy from data1 group by state 
having avg_literacy>90
order by avg_literacy desc;

#12 - top 3 state showing highest growth ratio:
select state,avg(growth)*100 as 'growth_rate' from data1 
group by State 
order by growth_rate desc limit 3;

#13 - bottom 3 state showing lowest sex_ratio:
select state,avg(sex_ratio) as 'avg_sex_ratio' from data1 
group by State 
order by avg_sex_ratio asc limit 3;

#14 - top and bottom 3 states in literacy state in one new table:
create table topstates
(state varchar(50),
 top_state float
);
#insert into topstates
select state,round(avg(literacy),0) avg_literacy_ratio from data1 
group by state order by avg_literacy_ratio desc limit 3;

create table bottomstates
(state varchar(50),
 bottom_state float
);
#insert into bottomstates
select state,round(avg(literacy),0) avg_literacy_ratio from data1 
group by state order by avg_literacy_ratio asc limit 3;

select state,top_state as 'top 3 and bottom 3' from topstates
union 
select state,bottom_state as 'top 3 and bottom 3' from bottomstates;

#15 - joining both tables:
select d1.district,d1.state,d1.sex_ratio,d2.population from data1 d1
inner join data2 d2
on d1.district=d2.district;

#16 - total male and female from sex_ratio and population:
select d1.state,d1.sex_ratio,round(d2.population/(d1.sex_ratio/1000+1),0)as 'total_males',round((d2.population*d1.sex_ratio/1000)/(d1.sex_ratio/1000+1),0) as 'total_females',d2.population from data1 d1
inner join data2 d2
on d1.district=d2.district
group by d1.state;

#17 - total literate and iliterate people from literacy_rate and population:
select d1.state,d1.literacy,round((d1.literacy/100)*d2.population,0)as 'literate_people',round((1-d1.literacy/100)*d2.population,0) as 'iliterate_people',d2.population from data1 d1
inner join data2 d2
on d1.district=d2.district
group by d1.state;

#18 - population in previous cencus:
select d1.state,d1.growth,round(d2.population/(1+d1.growth),0)as 'previous_cencus_population',d2.population as 'current_population'from data1 d1
inner join data2 d2
on d1.district=d2.district
group by d1.state;

#19 - rename the column literacy to literacy_rate from data1:
alter table data1 
rename column literacy to literacy_rate;

alter table data1 
rename column literacy_rate to literacy; (#again rename because previous query will not execute)

#20 - create view for gujarat information only:
create view gujarat_info as
select * from data1 d 
where state='gujarat';
select * from gujarat_info;
