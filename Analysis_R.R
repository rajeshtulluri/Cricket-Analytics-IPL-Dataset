# IPL Analysis
# Renganathan Lalgudi Venkatesan

#Use library
library(RODBC)

#List all your ODBC connections
odbcDataSources(type = c("all", "user", "system"))

#Create connection - Note if you leave uid and pwd blank it works with your existing Windows credentials
Local <- odbcConnect("Example", uid = "", pwd = "")

#Query a database (select statement)
Match <- sqlQuery(Local, "SELECT * FROM IPL.dbo.Match")
Player <- sqlQuery(Local, "SELECT * FROM IPL.dbo.Player")
Team <- sqlQuery(Local, "SELECT * FROM IPL.dbo.Team")
M1 <- sqlQuery(Local, "SELECT * FROM IPL.dbo.Match_new")
M2 <- sqlQuery(Local,"select * 
                      from IPL.dbo.Match M
                      Inner join IPL.dbo.Team T on M.Team_Name_Id = T.Team_Id")

#View data
View (Match)
View (Player)
head(Player,3)

#Check the structure of the data
class(Team)
str(Team)
str(Match)

dim(Match)
dim(Player)
dim(Team)

#Quick summary to describe the data
summary (Player)  
colnames(Player)
colnames(Match)

#Players By country
table(Player$Country)

#Bar plot showing Right Hand and Left Hand batsmen
#myData<-Player[-which(apply(Player,Player$Batting_Hand,function(x) all(is.na(x)))),]
barplot(table(Player$Batting_Hand))
table(Player$Batting_Hand)
#Histogram of the score ranges
hist(as.numeric(Match$Won_By))
boxplot(as.numeric(Match$Won_By))

#plot(as.Date(Match$Match_Date),as.numeric(Match$Won_By))

#Group By
Venue_Winning_Stats <- sqlQuery(Local, "SELECT City_Name
                    ,Count (Match_Id) as Num_matches
                    ,AVG(cast(Won_By as int)) as AvgWinning_Margin
                    ,SUM(cast(Won_By as int)) as SumWinningMargins
                    ,MAX(cast(Won_By as int)) as Max_Winning_Margin
                    ,MIN(cast(Won_By as int)) as Min_Winning_Margin
                    FROM IPL.dbo.Match_new                
                    GROUP BY City_Name
                    ORDER BY SumWinningMargins;") 


#Scatter plot
plot(Venue_Winning_Stats$Num_matches,Venue_Winning_Stats$AvgWinning_Margin)


#Analysis of Average winning margins

win_sub<-Venue_Winning_Stats[which(Venue_Winning_Stats$Num_matches>20),]
plot(win_sub$Num_matches,win_sub$AvgWinning_Margin)
abline(a=mean(win_sub$AvgWinning_Margin), b=0, col='blue')

#Team Vs Batting on Toss
table(Match$Toss_Decision)
barplot(table(Match$Toss_Decision))
table(Match$Toss_Winner_Id, Match$Toss_Decision)

#Teams Vs Won Matches
table( Match$Match_Winner_Id,Match$Toss_Decision)

#barplot(Match$Match_Winner_Id,Match$Toss_Decision)
#Best practice - don't leave the connection open and ensures you get the latest data
odbcCloseAll()
