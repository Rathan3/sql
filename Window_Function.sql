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

-- To create a naïve forecast for "distance per dollar" (defined as distance_to_travel/monetary_cost),
-- first sum the "distance to travel" and "monetary cost" values monthly.
-- This gives the actual value for the current month. For the forecasted value, use the previous month's value.
-- After obtaining both actual and forecasted values,
-- calculate the root mean squared error (RMSE) using the formula RMSE = sqrt(mean(square(actual - forecast))).
-- Report the RMSE rounded to two decimal places.
CREATE TABLE uber_request_logs(request_id int, request_date datetime, request_status varchar(10), distance_to_travel float, monetary_cost float, driver_to_client_distance float);
INSERT INTO uber_request_logs VALUES (1,'2020-01-09','success', 70.59, 6.56,14.36), (2,'2020-01-24','success', 93.36, 22.68,19.9), (3,'2020-02-08','fail', 51.24, 11.39,21.32), (4,'2020-02-23','success', 61.58,8.04,44.26), (5,'2020-03-09','success', 25.04,7.19,1.74), (6,'2020-03-24','fail', 45.57, 4.68,24.19), (7,'2020-04-08','success', 24.45,12.69,15.91), (8,'2020-04-23','success', 48.22,11.2,48.82), (9,'2020-05-08','success', 56.63,4.04,16.08), (10,'2020-05-23','fail', 19.03,16.65,11.22), (11,'2020-06-07','fail', 81,6.56,26.6), (12,'2020-06-22','fail', 21.32,8.86,28.57), (13,'2020-07-07','fail', 14.74,17.76,19.33), (14,'2020-07-22','success',66.73,13.68,14.07), (15,'2020-08-06','success',32.98,16.17,25.34), (16,'2020-08-21','success',46.49,1.84,41.9), (17,'2020-09-05','fail', 45.98,12.2,2.46), (18,'2020-09-20','success',3.14,24.8,36.6), (19,'2020-10-05','success',75.33,23.04,29.99), (20,'2020-10-20','success', 53.76,22.94,18.74);

 with a as(select date_format(request_date,'%Y-%m') as mon,sum(distance_to_travel)/sum(monetary_cost) as d_p_d
 from uber_request_logs group by mon),
 b as (select mon, d_p_d, lag(d_p_d) over (order by mon ) as p_p_d from a)
 select round(sqrt(avg(pow(d_p_d-p_p_d,2))),2) as RMSE from b