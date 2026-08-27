-- 3421. Find Students Who Improved

with cte as (
    SELECT min(exam_date) as f_date, max(exam_date) as l_date, score, student_id, subject FROM Scores Group by student_id, subject having count(*) > 1
)
SELECT s.student_id, s.subject, a.score as first_score , b.score as latest_score FROM
cte as s, Scores as a, Scores as b WHERE (a.student_id = s.student_id and a.subject = s.subject and a.exam_date = s.f_date) and (b.student_id = s.student_id and b.subject = s.subject and b.exam_date = s.l_date) AND a.score < b.score ORDER BY student_id, subject


-- 1407. Top Travellers

SELECT U.name, COALESCE(SUM(r.distance), 0) as travelled_distance FROM Users as u LEFT JOIN Rides as r ON u.id = r.user_id  GROUP BY (r.user_id) ORDER BY travelled_distance DESC , name ASC 

-- 1393. Capital Gain/Loss

select stock_name, Sum(case when operation = "Buy" then -price else price end) as capital_gain_loss FROM Stocks group by stock_name

-- 1907. Count Salary Categories

# Write your MySQL query statement below
with cte as (
  select account_id , case when income < 20000 then "Low Salary" 
                           when income between 20000 and 50000 then "Average Salary"
                           else "High Salary" end as category
                           from Accounts 
),  cat as
(
    SELECT "Low Salary"  as category 
    union all
    select "Average Salary"
    union all
    select  "High Salary"
)
select cat.category, count(cte.account_id) as accounts_count FROM cat left join cte on cat.category = cte.category group by cat.category


-- 262. Trips and Users

with cte as (
    select T.id, T.client_id, T.driver_id, T.status, T.request_at from Trips as T join Users as A ON T.client_id = A.users_id join Users as B on T.driver_id = B.users_id WHERE
    A.banned = "No" and B.banned = "No" AND request_at between "2013-10-01" and "2013-10-03"
), outcome as(
    select count(*) as c, request_at FROM cte Where status != "completed" Group by request_at 
), total as (
   select count(*) as t, request_at FROM cte Group by request_at  
)
Select t.request_at as Day ,  coalesce(round(o.c/t.t, 2), 0) as `Cancellation Rate`  From outcome as o right join total as t on o.request_at = t.request_at 

-- 1934. Confirmation Rate

with outcomes as (
 Select user_id , count(*) as c FROm Confirmations Where action = "confirmed" GROUP BY user_id
), total as (
    SELECT S.user_id , T.t as t FROM Signups as S Left join (
        select user_id , count(*) t from Confirmations group by user_id
    )as T on S.user_id = T.user_id
)
select T.user_id,  coalesce(round(O.c / T.t , 2), 0) as `confirmation_rate` from total as T Left join outcomes as O on T.user_id = O.user_id


-- 585. Investments in 2016 — Question Only
with cte as (
SELECT DISTINCT a.pid, a.tiv_2016 FROM Insurance as a Join Insurance as b On a.tiv_2015 = b.tiv_2015 and  a.pid != b.pid
), de as (
    SELECT pid, count(*) as c From Insurance Group by lat, lon having count(*) = 1
)
select round(SUM(cte.tiv_2016), 2) as tiv_2016 From cte Inner Join de ON cte.pid = de.pid 

-- 1050. Actors and Directors Who Cooperated At Least Three Times

SELECT  actor_id , director_id from ActorDirector group by actor_id, director_id having  count(*) >= 3

-- 1148. Article Views I

select distinct author_id as id from Views Where author_id = viewer_id order by  author_id asc

-- 1211. Queries Quality and Percentage

select query_name, round((sum( rating / position ) / count(*)), 2) as quality, round( (sum(case when rating < 3 then 1 else 0 end)/count(*)) * 100  , 2) as poor_query_percentage From Queries group by query_name


-- 1179. Reformat Department Table

select id, 
Min(case when month = "Jan" then revenue end) as Jan_revenue,
Min(case when month = "Feb" then revenue end) as Feb_revenue,
Min(case when month = "Mar" then revenue end) as Mar_revenue,
Min(case when month = "Apr" then revenue end) as Apr_revenue,
Min(case when month = "May" then revenue end) as May_revenue,
Min(case when month = "Jun" then revenue end) as Jun_revenue,
Min(case when month = "Jul" then revenue end) as Jul_revenue,
Min(case when month = "Aug" then revenue end) as Aug_revenue,
Min(case when month = "Sep" then revenue end) as Sep_revenue,
Min(case when month = "Oct" then revenue end) as Oct_revenue,
Min(case when month = "Nov" then revenue end) as Nov_revenue,
Min(case when month = "Dec" then revenue end) as Dec_revenue
 From Department GROUP BY id