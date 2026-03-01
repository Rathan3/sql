-- You are analyzing a social network dataset at Google.
-- Your task is to find mutual friends between two users, Karl and Hans.
-- There is only one user named Karl and one named Hans in the dataset.
CREATE TABLE users(user_id INT, user_name varchar(30));
INSERT INTO users VALUES (1, 'Karl'), (2, 'Hans'), (3, 'Emma'), (4, 'Emma'), (5, 'Mike'), (6, 'Lucas'), (7, 'Sarah'), (8, 'Lucas'), (9, 'Anna'), (10, 'John');
CREATE TABLE friends(user_id INT, friend_id INT);
INSERT INTO friends VALUES (1,3),(1,5),(2,3),(2,4),(3,1),(3,2),(3,6),(4,7),(5,8),(6,9),(7,10),(8,6),(9,10),(10,7),(10,9);

with a as(select f1.friend_id as user_id from friends f1 
inner join friends f2 on f1.friend_id = f2.friend_id 
where f1.user_id = 1 and f2.user_id = 2)
select * from users u where u.user_id in (select * from a)