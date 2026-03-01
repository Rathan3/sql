/* Write an SQL query to find the consecutive number,
 which appears at least thrice one after another without interruption. 
0 1 1 2 3 3 3 4 5 5 5 7 7 */

with a as(select col1, 
lag(col1) over() as prev, 
lead(col1) over() as nex
from tb)
select distinct col1 from a where col1 = prev and prev = nex;

-- Given a table 'sf_transactions' of purchases by date, calculate the month-over-month percentage change in revenue.
-- The output should include the year-month date (YYYY-MM) and percentage change, rounded to the 2nd decimal point, and sorted from the beginning of the year to the end of the year.
-- The percentage change column will be populated from the 2nd month forward and calculated as ((this month’s revenue — last month’s revenue) / last month’s revenue)*100.
CREATE TABLE sf_transactions(id INT, created_at datetime, value INT, purchase_id INT);
INSERT INTO sf_transactions VALUES
(1, '2019-01-01 00:00:00',  172692, 43), (2,'2019-01-05 00:00:00',  177194, 36),(3, '2019-01-09 00:00:00',  109513, 30),(4, '2019-01-13 00:00:00',  164911, 30),(5, '2019-01-17 00:00:00',  198872, 39), (6, '2019-01-21 00:00:00',  184853, 31),(7, '2019-01-25 00:00:00',  186817, 26), (8, '2019-01-29 00:00:00',  137784, 22),(9, '2019-02-02 00:00:00',  140032, 25), (10, '2019-02-06 00:00:00', 116948, 43), (11, '2019-02-10 00:00:00', 162515, 25), (12, '2019-02-14 00:00:00', 114256, 12), (13, '2019-02-18 00:00:00', 197465, 48), (14, '2019-02-22 00:00:00', 120741, 20), (15, '2019-02-26 00:00:00', 100074, 49), (16, '2019-03-02 00:00:00', 157548, 19), (17, '2019-03-06 00:00:00', 105506, 16), (18, '2019-03-10 00:00:00', 189351, 46), (19, '2019-03-14 00:00:00', 191231, 29), (20, '2019-03-18 00:00:00', 120575, 44), (21, '2019-03-22 00:00:00', 151688, 47), (22, '2019-03-26 00:00:00', 102327, 18), (23, '2019-03-30 00:00:00', 156147, 25);
select * from sf_transactions;

with a as(select date_format(created_at,"%Y-%m") as mon, sum(value) as m_r from sf_transactions group by mon ),
b as (select mon,m_r, lag(m_r) over (order by mon ) as pm_r from a order by mon)
select mon as month,m_r as total_revenue,round(((m_r-pm_r)/pm_r)*100,2) as percentage_change from b 
