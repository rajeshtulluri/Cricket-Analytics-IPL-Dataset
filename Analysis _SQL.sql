/* Indian Premier League Analysis */

/* Name: Renganathan Lalgudi Venkatesan
   UCID: M12366827   */


/*Creating the Database*/
CREATE DATABASE IPL;
USE IPL;

if object_id('dbo.Match') is not null drop table dbo.Match; 
if object_id('dbo.Player') is not null drop table dbo.Match; 
if object_id('dbo.Team') is not null drop table dbo.Match; 
if object_id('dbo.M1') is not null drop table dbo.M1; 
if object_id('dbo.Opp') is not null drop table dbo.Opp; 

/* Looking at the data tables and understaning the different variables present in each table*/
select top 10 *
from dbo.Match;

select top 10 *
from dbo.Player;

select  *
from dbo.M;

select *
into dbo.Opp
from dbo.Team;

select *
into dbo.Winner
from dbo.Team;

/* Create the required Table by combining the multiple tables based on their Id's:*/
if object_id('dbo.Match_new') is not null drop table dbo.Match_new; 
SELECT DISTINCT Match_Id
		, Match_Date
		, Team_Name
		, Opponent_name
		, Winning_team
		, isnull(Won_By,'') as Won_By
		, City_Name
INTO dbo.Match_new
from dbo.Match M
Inner join dbo.Team T on M.Team_Name_Id = T.Team_Id
inner join dbo.Opp O on M.Opponent_Team_Id = O.Team_Id 
inner join dbo.Winner W on M.Match_Winner_Id = W.Team_Id;

select *
from dbo.Match_new;

/* Data cleaning for NULL values in the Won_By Column*/
Update dbo.Match_new
Set Won_By = 0
Where Won_By Like 'NULL';


/* Cities that have hosted the most number of matches in the tournament*/
select City_Name, count(distinct Match_Id) as Num_of_matches
from dbo.Match_new
group by City_Name
order by Num_of_matches desc;


/* Teams that have won the most number of matches*/
select Winning_Team, count(Winning_team) as Num_Times_Won
from dbo.Match_new
group by Winning_team
order by Num_Times_Won desc;

/* Average winning margins for the teams in the tournament*/
select Winning_Team, avg(cast(Won_By as INT)) as Avg_Winning_Margin
from dbo.Match_new
group by Winning_team
order by Avg_Winning_Margin desc;

/* Matches won by different teams in different Venues*/
select Winning_team, City_name, count(City_Name) as Num_Won_Venue
from dbo.Match_new
group by City_Name, Winning_Team
order by Num_Won_Venue desc;


/* Distribution of number of matches played in a given date*/
select Num_matches, count(*) as days
from (select Match_Date, count(Distinct Match_Id) as Num_matches
from dbo.Match_new
group by Match_Date) as temp
group by Num_matches;


/*Implemaneted in R*/
/*SELECT City_Name
      ,Count (Match_Id) as Num_matches
      ,AVG(cast(Won_By as int)) as AvgWinning_Margin
      ,SUM(cast(Won_By as int)) as SumWinningMargins
      ,MAX(cast(Won_By as int)) as Max_Winning_Margin
      ,MIN(cast(Won_By as int)) as Min_Winning_Margin
FROM dbo.Match_new                
GROUP BY City_Name
ORDER BY SumWinningMargins;

select *
from dbo.Match_new;*/