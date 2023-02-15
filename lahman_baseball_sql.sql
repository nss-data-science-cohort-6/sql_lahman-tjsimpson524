
SELECT namefirst, 
namelast,    
SUM(salary)::numeric::money AS total_salary, 	   
COUNT(DISTINCT yearid) AS years_played
FROM people	 
INNER JOIN salaries	 
USING(playerid)
WHERE playerid IN 
(SELECT 	
 playerid	
 FROM collegeplaying 		
 LEFT JOIN schools		
 USING(schoolid)	
 WHERE schoolid = 'vandy')
 GROUP BY playerid, namefirst, namelast ORDER BY total_salary DESC;




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

With decade_cte As(
Select generate_series(1920,2020,10) As beginning_of_decade
)
Select
yearid,hr
so,
g,
beginning_of_decade::text || 's' As decade
From teams 
Inner Join decade_cte
On yearid Between beginning_of_decade And beginning_of_Decade + 9
Where yearid >= 1920;



With decade_cte As(
Select generate_series(1920,2020,10) As beginning_of_decade
)
Select
	Round(Sum(hr) * 1.0/Sum(g),2) As hr_per_game,
	Round(Sum(so) * 1.0 / Sum(g), 2) As so_per_game,
	beginning_of_decade::text || 's' As decade
From teams 
Inner Join decade_cte
On yearid Between beginning_of_decade And beginning_of_Decade + 9
Where yearid >= 1920;


Select
	Round(avg(so/g), 2) As k_per_g,
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


With full_bat As(
select
playerid,
Sum(sb) as sb,
Sum(cs) AS cs,
	Sum(sb) + Sum(cs) As attempts
	From batting
	Where yearid = 2016
	Group By playerid
	)
Select
	namefirst ||' '|| namelast As fullname,
	sb, 
	attempts, 
	Round(sb * 1.0/ attempts,2 ) As sb_pct
From full_bat
Inner Join people
Using (playerid)
Where sb >= 20
Group by sb_pct
	
5. 

Select 
	franchname,
	w,
	wswin, 
	yearid
From teams
Inner Join teamsfranchises
Using(franchid)
Where wswin = 'N' And yearid Between 1970 and 2016 
Order by w desc 


Select 
	franchname,
	w,
	wswin,
	yearid
From teams
Inner Join teamsfranchises
Using(franchid)
Where  wswin = 'Y' And yearid != 1981 
Order by w asc;


Select
	Sum(w) as total_wins,
 	franchname as team,
	yearid as year,
	wswin as world_series
From teams
Inner Join teamsfranchises
Using(franchid)
Where wswin = 'Y' And yearid != 1981 And yearid Between 1970 And 2016
Group By franchname, yearid, wswin
Order by total_wins desc

45


-- Michaels CTE --

With top_wins As(
select yearid, Max(w) As w
From teams
Where yearid between 1970 And 2016
Group by yearid
),
top_wins_teams As(
Select teamid, yearid, w, wswin
From teams
Inner Join top_wins
Using(yearid, w)
)
Select	
Sum(Case When wswin = 'Y' Then 1 Else 0 End),
Avg(case when wswin = 'Y' Then 1 Else 0 End)
From top_wins_teams
	
Select
	Sum(w) as total_wins,
 	franchname as team,
	yearid as year,
	wswin as world_series
From teams
Inner Join teamsfranchises
Using(franchid)
Where yearid != 1981 And yearid Between 1970 And 2016
Group By franchname, yearid, wswin
Order by total_wins desc



	
6.

Select 
playerid,
namefirst,
namelast,
Case 
	When lgid = 'NL' Then 'NL'
	When lgid = 'AL' Then 'AL'
	Else 'Both'
	End As league
From managers
Inner Join people
Using (playerid)
Group By playerid, namefirst, namelast, lgid 


-- m 

WITH man_a_gers AS(	
	SELECT DISTINCT *
	FROM (
		SELECT 
			a1.playerid,
			a1.yearid,
			a1.awardid,
			a1.lgid
		FROM awardsmanagers AS a1
		INNER JOIN awardsmanagers AS a2
		ON a1.playerid = a2.playerid
			AND a1.lgid <> a2.lgid
		WHERE a1.lgid <> 'ML'
			AND a1.awardid = 'TSN Manager of the Year'
			AND a2.lgid <> 'ML'
			AND a2.awardid = 'TSN Manager of the Year'
	) AS sub
)
SELECT 
	namefirst,
	namelast,
	yearid,
	teamid
FROM managers
RIGHT JOIN man_a_gers
USING(playerid, yearid)
LEFT JOIN people
USING(playerid)
ORDER BY namelast, yearid




7. 

With full_pitching AS(
	Select
	playerid,
	sum(so) As so
From pitching
Where yearid = 2016)
Group By playerid
Having Sum(gs) >= 10
),
full_salary As (
	Select
	playerid,
Sum(salary) As salary
From salaries
Where yearid =2016
Group By playerid
)
Select
	playerid,
salary::money/ so as so_eff
From full_pitching
Natural Join full_salary)

-- tomo's code
SELECT 
 playerid,
 SUM(so) AS tot_strikeouts,
 SUM(salary)::numeric::money AS tot_salary,
 SUM(salary)::numeric::money / SUM(so) AS salary_strike
FROM pitching p
LEFT JOIN salaries s
USING (playerid)
WHERE p.yearid = 2016
  AND s.yearid = 2016
GROUP BY playerid
HAVING SUM(gs) > 10
ORDER BY salary_strike DESC;
----- Michaels
WITH full_pitching AS (	
	SELECT 		
	playerid,
	SUM(so) AS so
	FROM pitching
	WHERE yearid = 2016
	GROUP BY playerid
	HAVING SUM(gs) >= 10),
	full_salary AS (
		SELECT		
		playerid,		
		SUM(salary) AS salary	
		FROM salaries	
		WHERE yearid = 2016	
		GROUP BY playerid)
		SELECT 
		namefirst || ' ' || namelast AS fullname,
		salary::numeric::MONEY / so AS so_efficiency
		FROM full_pitching
		NATURAL JOIN full_salary
		INNER JOIN people
		USING(playerid)
		ORDER BY so_efficiency DESC;



	
8. 
-- Left join keeps all players
With hits As(
Select 
	playerid,
	Sum(h) As total_hits
	From batting
	Group By playerid
	Having Sum(h) >= 3000
)
With inducted_year AS (
	Select 
	playerid,
	yearid As year_inducted
	From halloffame
	Where inducted = 'Y'
)
Select playerid, total_hits
From hits
Left Join halloffame
Using(playerid)
Where inducted = 'Y'


WITH career_hits AS(
	SELECT DISTINCT playerid, 
	SUM(h) AS hits 
	FROM batting	
	GROUP BY playerid		
	HAVING  SUM(h) >= 3000
	ORDER BY 2 DESC)
	SELECT DISTINCT ON (namefirst, namelast) namefirst,
	namelast,
	ch.hits,
	CASE WHEN hf.inducted = 'Y' THEN 'Y'	   		
	ELSE NULL END AS hf_inducted,
	CASE WHEN hf.inducted = 'Y' THEN hf.yearid 
	END AS hf_yearid	   
	FROM people p
	INNER JOIN career_hits ch 
	USING (playerid)	
	LEFT JOIN halloffame hf 
	USING (playerid)
	ORDER BY namefirst, namelast, hf_yearid desc NULLS LAST
	
	
9.

WITH thousandaires AS (
	SELECT 
	 playerid,
	 teamid,
	 SUM(h) AS total_hits
	FROM batting	
	GROUP BY playerid, teamid	
	HAVING SUM(H) >= 1000),
	double_thousandaires AS (
		SELECT
		playerid
		FROM thousandaires
		GROUP BY playerid	
		HAVING COUNT(DISTINCT teamid) = 2)
		SELECT 
		namefirst || ' ' || namelast AS full_name
		FROM double_thousandaires
		NATURAL JOIN people;

	










	
	
	
	
	

	
	



	




	








