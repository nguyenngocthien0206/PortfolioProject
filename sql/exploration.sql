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