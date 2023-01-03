USE Football
GO

-- 1.Game results by Teams
SELECT	teamID,
	name,
	W AS wins,
	D AS draws,
	L AS loses,
	(W+D+L) AS gamesPlayed,
	FORMAT(1.0*W/(W+D+L),'P') AS winPercentage
FROM
(	SELECT	t.teamID AS teamID,
		t.name,
		ts.result
	FROM	teamstats ts
	JOIN	teams t ON ts.teamID = t.teamID
) AS source_table
PIVOT
(
	COUNT(result)
	FOR result IN ([W],[D],[L])
) AS pivot_table

-- 2. Average goal per game by Leagues
SELECT		l.leagueID,
		l.name,
		AVG(g.homeGoals + g.awayGoals) AS avgGoal
FROM		games g
JOIN		leagues l ON g.leagueID = l.leagueID
GROUP BY	l.leagueID, l.name
ORDER BY	l.leagueID

-- 3. Average goal vs shot per game by Players
SELECT		p.playerID,
		p.name,
		ROUND(AVG(a.goals),2) AS goalPerGames,
		ROUND(AVG(a.shots),2) AS shotPerGames,
		SUM(a.goals) AS totalGoal,
		SUM(a.shots) AS totalShot,
		FORMAT(1.0*SUM(a.goals)/SUM(a.shots),'P') AS goalRate
FROM		appearances a
JOIN		players p ON p.playerID = a.playerID
GROUP BY	p.playerID, p.name
HAVING		SUM(a.shots) != 0
ORDER BY	ROUND(100.0*SUM(a.goals)/SUM(a.shots),2) DESC

-- 4. Statistics by Season
SELECT		season,
		SUM(goals) AS totalGoals,
		SUM(shots) AS totalShots,
		SUM(shotsOnTarget) AS totalShotsOnTarget,
		SUM(fouls) AS totalFouls,
		SUM(corners) AS totalCorners,
		SUM(yellowCards) AS totalYellowCards,
		SUM(redCards) AS totalRedCards
FROM		teamstats
GROUP BY	season
ORDER BY	season

-- 5. Goals per Game
SELECT		l.name,
			g.season,
			SUM((g.homeGoals + g.awayGoals)) AS totalGoals,
			COUNT(g.gameID) AS totalGames,
			ROUND(1.0*SUM((g.homeGoals + g.awayGoals))/COUNT(g.gameID),0) AS goalsPerGame
FROM		games g
JOIN		leagues l ON g.leagueID = l.leagueID
GROUP BY	l.name, g.season
ORDER BY	l.name, g.season
-- PIVOT: totalGoals
SELECT		name,
			SUM([2014]) AS 'totalGoals2014',
			SUM([2015]) AS 'totalGoals2015',
			SUM([2016]) AS 'totalGoals2016',
			SUM([2017]) AS 'totalGoals2017',
			SUM([2018]) AS 'totalGoals2018',
			SUM([2019]) AS 'totalGoals2019',
			SUM([2020]) AS 'totalGoals2020'
FROM
(		SELECT		l.name,
					g.season,
					(g.homeGoals + g.awayGoals) AS totalGoals,
					gameID
		FROM		games g
		JOIN		leagues l ON g.leagueID = l.leagueID
) AS source_table
PIVOT
(		
		SUM(totalGoals)
		FOR season IN ([2014],[2015],[2016],[2017],[2018],[2019],[2020])
) AS pivot_table
GROUP BY	name
-- PIVOT: totalGames
SELECT		name,
			SUM([2014]) AS 'totalGames2014',
			SUM([2015]) AS 'totalGames2015',
			SUM([2016]) AS 'totalGames2016',
			SUM([2017]) AS 'totalGames2017',
			SUM([2018]) AS 'totalGames2018',
			SUM([2019]) AS 'totalGames2019',
			SUM([2020]) AS 'totalGames2020'
FROM
(		SELECT		l.name,
					g.season,
					(g.homeGoals + g.awayGoals) AS totalGoals,
					gameID
		FROM		games g
		JOIN		leagues l ON g.leagueID = l.leagueID
) AS source_table
PIVOT
(		
		COUNT(gameID)
		FOR season IN ([2014],[2015],[2016],[2017],[2018],[2019],[2020])
) AS pivot_table
GROUP BY	name
-- CTE
WITH totalGoals AS
(
	SELECT		name,
				SUM([2014]) AS 'totalGoals2014',
				SUM([2015]) AS 'totalGoals2015',
				SUM([2016]) AS 'totalGoals2016',
				SUM([2017]) AS 'totalGoals2017',
				SUM([2018]) AS 'totalGoals2018',
				SUM([2019]) AS 'totalGoals2019',
				SUM([2020]) AS 'totalGoals2020'
	FROM
	(		SELECT		l.name,
						g.season,
						(g.homeGoals + g.awayGoals) AS totalGoals,
						gameID
			FROM		games g
			JOIN		leagues l ON g.leagueID = l.leagueID
	) AS source_table
	PIVOT
	(		
			SUM(totalGoals)
			FOR season IN ([2014],[2015],[2016],[2017],[2018],[2019],[2020])
	) AS pivot_table
	GROUP BY	name
)
, totalGames AS
(
	SELECT		name,
				SUM([2014]) AS 'totalGames2014',
				SUM([2015]) AS 'totalGames2015',
				SUM([2016]) AS 'totalGames2016',
				SUM([2017]) AS 'totalGames2017',
				SUM([2018]) AS 'totalGames2018',
				SUM([2019]) AS 'totalGames2019',
				SUM([2020]) AS 'totalGames2020'
	FROM
	(		SELECT		l.name,
						g.season,
						(g.homeGoals + g.awayGoals) AS totalGoals,
						gameID
			FROM		games g
			JOIN		leagues l ON g.leagueID = l.leagueID
	) AS source_table
	PIVOT
	(		
			COUNT(gameID)
			FOR season IN ([2014],[2015],[2016],[2017],[2018],[2019],[2020])
	) AS pivot_table
	GROUP BY	name
)
SELECT		tga.name,
			ROUND(1.0*tgo.totalGoals2014/tga.totalGames2014,0) AS goalsPerGames2014,
			ROUND(1.0*tgo.totalGoals2015/tga.totalGames2015,0) AS goalsPerGames2015,
			ROUND(1.0*tgo.totalGoals2016/tga.totalGames2016,0) AS goalsPerGames2016,
			ROUND(1.0*tgo.totalGoals2017/tga.totalGames2017,0) AS goalsPerGames2017,
			ROUND(1.0*tgo.totalGoals2018/tga.totalGames2018,0) AS goalsPerGames2018,
			ROUND(1.0*tgo.totalGoals2019/tga.totalGames2019,0) AS goalsPerGames2019,
			ROUND(1.0*tgo.totalGoals2020/tga.totalGames2020,0) AS goalsPerGames2020
FROM		totalGoals tgo
JOIN		totalGames tga ON tgo.name = tga.name

-- 6. Top Scorers
SELECT TOP 10	p.playerID,
				p.name,
				g.season,
				SUM(a.goals) AS totalGoals
FROM		appearances a
JOIN		players p ON a.playerID = p.playerID
JOIN		games g ON a.gameID = g.gameID
GROUP BY	p.playerID, p.name, g.season
ORDER BY	SUM(a.goals) DESC
