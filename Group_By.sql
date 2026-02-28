-- A table named “famous” has two columns called user id and follower id. It represents each user ID has a particular follower ID. These follower IDs are also users of hashtag#Facebook / hashtag#Meta. Then, find the famous percentage of each user. 
-- Famous Percentage = number of followers a user has / total number of users on the platform.
CREATE TABLE famous (user_id INT, follower_id INT);
INSERT INTO famous VALUES
(1, 2), (1, 3), (2, 4), (5, 1), (5, 3), 
(11, 7), (12, 8), (13, 5), (13, 10), 
(14, 12), (14, 3), (15, 14), (15, 13);

with a as(select distinct user_id from famous union select distinct follower_id from famous),
b as (select user_id, count(*) as fc from famous group by user_id)
select a.user_id , 
case when b.user_id is null then 0 else round((b.fc/(select count(*) from a))*100,2) end as famous_percentage 
from a left join b 
on a.user_id = b.user_id