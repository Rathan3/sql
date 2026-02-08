/* Write an SQL query to find the consecutive number,
 which appears at least thrice one after another without interruption. 
0
1
1
2
3
3
3
4
5
5
5
7
7 */

with a as(select col1, 
lag(col1) over() as prev, 
lead(col1) over() as nex
from tb)
select distinct col1 from a where col1 = prev and prev = nex;
