-- Combining tables -- 

create table appleStore_combineddesc as 
select * from appleStore_description1
union ALL
select * from appleStore_description2
union all
select * from appleStore_description3
union all
select * from appleStore_description4

select * from appleStore_combineddesc
select * from AppleStore

** Exploratory data analysis **

-- Check the number of unique apps is the same in both tables-- 

select count(distinct id) as Uniqueappids
from AppleStore

select count(DISTINCT id) as Uniqueappids
from appleStore_combineddesc

-- Check for missing values-- 

select count(*) as missingvalues
from AppleStore
where track_name is null or user_rating is null or prime_genre is null 

select count(*) as missingvalues
from appleStore_combineddesc 
where id is null or app_desc is null

-- Find out the number of apps per genre --

select prime_genre, count(*) as numapps
from AppleStore
group by prime_genre
order by numapps desc

-- overview of app ratings --

select min(user_rating) as minrating,
max(user_rating) as maxrating,
avg(user_rating) AS avgrating

from AppleStore

-- min, max, avg app rating of top genre -- 

WITH GenreCounts AS (
    SELECT prime_genre, COUNT(*) AS numapps
    FROM AppleStore
    GROUP BY prime_genre
    ORDER BY numapps DESC
    LIMIT 1
)

SELECT 
    G.prime_genre,
    AVG(user_rating) AS average_rating,
    MIN(user_rating) AS min_rating,
    MAX(user_rating) AS max_rating
FROM AppleStore A
JOIN GenreCounts G ON A.prime_genre = G.prime_genre
GROUP BY G.prime_genre;


** Data Analysis **

-- Determine whether paid apps have higher ratings than free apps-- 

select case 
	when price > 0 then 'Paid'
    else 'Free'
  end as App_type,
  avg(user_rating) as Avg_rating
  
from AppleStore
Group by App_type

-- Check if apps with more supported languages have higher ratings -- 

select case 
	when lang_num <10 then '10 languages'
    when lang_num between 10 and 30 then '10-30 languages'
    else '30 languages and above'
   end as language_category,
   avg(user_rating) as Avg_rating
from AppleStore
group by language_category
   
-- Check genres with low ratings --

select prime_genre, avg(user_rating) as Avg_rating
from AppleStore
group by prime_genre
order by Avg_rating ASC
limit 10

-- Check if there is correlation between longer app desc and the user rating -- 

select CASE
	when length(b.app_desc) <500 then 'short' 
    when length(b.app_desc) between 500 and 1000 then 'medium'
    else 'long'
   end as appdesc_category,
   avg(a.user_rating) as average_rating
   
from AppleStore as A
join appleStore_combineddesc as B 
on a.id= b.id

group BY appdesc_category
   
-- Check top rated apps for each genre -- 

select prime_genre, track_name, user_rating

from( 
  select prime_genre, track_name, user_rating,
  RANK() OVER(partition by prime_genre order by user_rating desc, rating_count_tot desc) as rank
  from AppleStore) as A
where A.rank= 1

** Insights **
--1. paid apps have better ratings, 
--2. Apps supporting between 10-30 languages have the best ratings, language is probably not 
--the main focus of what makes a good app--
--3. Finance and book apps have the lowest ratings, could be a potential entry point to solve an
-- unmet need -- 
--4. Apps with comprehensive desc has better ratings--
--5. aim for a hgiher rating than the average 3.5 --
--6. Games and entertainment genre have many apps, saturated and potentially difficult to compete
