-- 3421. Find Students Who Improved

with cte as (
    SELECT min(exam_date) as f_date, max(exam_date) as l_date, score, student_id, subject FROM Scores Group by student_id, subject having count(*) > 1
)
SELECT s.student_id, s.subject, a.score as first_score , b.score as latest_score FROM
cte as s, Scores as a, Scores as b WHERE (a.student_id = s.student_id and a.subject = s.subject and a.exam_date = s.f_date) and (b.student_id = s.student_id and b.subject = s.subject and b.exam_date = s.l_date) AND a.score < b.score ORDER BY student_id, subject


-- 1407. Top Travellers

SELECT U.name, COALESCE(SUM(r.distance), 0) as travelled_distance FROM Users as u LEFT JOIN Rides as r ON u.id = r.user_id  GROUP BY (r.user_id) ORDER BY travelled_distance DESC , name ASC 

-- 1393. Capital Gain/Loss

