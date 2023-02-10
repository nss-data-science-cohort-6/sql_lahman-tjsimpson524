
SELECT namefirst, 
namelast, 	   
SUM(salary)::numeric::money AS total_salary, 	   
COUNT(DISTINCT yearid) AS years_played
FROM people	 
INNER JOIN salaries	 
USING(playerid)
WHERE playerid IN 
(SELECT 	
 playerid	
 FROM collegeplaying 		
 LEFT JOIN schools		
 USING(schoolid)	
 WHERE schoolid = 'vandy')
 GROUP BY playerid, namefirst, namelastORDER BY total_salary DESC;




Select
		Distinct people.playerid,
		collegeplaying.schoolid,
		sum(salaries.salary) as salary,
		people.namefirst,
		people.namelast
From people
Inner Join collegeplaying
On people.playerid = collegeplaying.playerid
Inner Join salaries
On collegeplaying.playerid = salaries.playerid
Where collegeplaying.schoolid Like '%vandy%'
Group By Distinct people.playerid,  collegeplaying.schoolid
Order by salary  Desc;

Select *
From people
Inner Join collegeplaying
Using(playerid)
Inner Join schools
Using(schoolid)
Where schoolname Like '%Vanderbilt%'


2.

Select
	Case 
		When pos = 'OF' Then 'Outfield'
		When pos In('SS', '1B','2B','3B') Then 'Infield'
		When pos In('P', 'C') Then 'Batter'
		End As group_position,
	Sum(po)
	From fielding 
	Where yearid = 2016
	Group By group_position;
	
	
3. 
	

Select
	Round(avg(so/g), 2) As k_per_g
From pitching
Where yearid Between 1920 And 2022
Group By so, g
Order by k_per_g desc;

Select
	Round(avg(hr/g), 2) As hr_per_g
From pitching
Where yearid Between 1920 And 2022
Group by hr, g
Order by hr_per_g desc;



4. 


Select 
	sb,
	cs,
	playerid,
	yearid 
From batting 
Where sb >20 and yearid = 2016 
Order by sb desc;


Select 
	sb + cs as stolen_bases,
	playerid,
	yearid
From batting 
Where sb >20 and yearid = 2016 
Order by stolen_bases desc;

5. 

Select 
	franchname,
	w,
	wswin
From teams
Inner Join teamsfranchises
Using(franchid)
Order by w desc 

Select 
	franchname,
	w,
	wswin
From teams
Inner Join teamsfranchises
Using(franchid)
Where wswin = 'Y'
Order by w asc;





	

	






	
	
	
	
	

	
	



	




	








