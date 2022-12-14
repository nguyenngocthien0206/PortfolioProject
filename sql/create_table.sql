USE MASTER
GO

CREATE DATABASE Football

USE Football
GO

CREATE TABLE [dbo].[leagues](
	[leagueID] [float] NOT NULL,
	[name] [nvarchar](255) NULL,
	[understatNotation] [nvarchar](255) NULL,
	CONSTRAINT PK_League PRIMARY KEY (leagueID)
);

CREATE TABLE [dbo].[players](
	[playerID] [float] NOT NULL,
	[name] [nvarchar](255) NULL,
	CONSTRAINT PK_Player PRIMARY KEY (playerID)
);

CREATE TABLE [dbo].[teams](
	[teamID] [float] NOT NULL,
	[name] [nvarchar](255) NULL,
	CONSTRAINT PK_Team PRIMARY KEY (teamID)
);

CREATE TABLE [dbo].[games](
	[gameID] [float] NOT NULL,
	[leagueID] [float] NULL,
	[season] [float] NULL,
	[date] [datetime] NULL,
	[homeTeamID] [float] NULL,
	[awayTeamID] [float] NULL,
	[homeGoals] [float] NULL,
	[awayGoals] [float] NULL,
	[homeProbability] [float] NULL,
	[drawProbability] [float] NULL,
	[awayProbability] [float] NULL,
	[homeGoalsHalfTime] [float] NULL,
	[awayGoalsHalfTime] [float] NULL,
	[B365H] [float] NULL,
	[B365D] [float] NULL,
	[B365A] [float] NULL,
	[BWH] [float] NULL,
	[BWD] [float] NULL,
	[BWA] [float] NULL,
	[IWH] [float] NULL,
	[IWD] [float] NULL,
	[IWA] [float] NULL,
	[PSH] [float] NULL,
	[PSD] [float] NULL,
	[PSA] [float] NULL,
	[WHH] [float] NULL,
	[WHD] [float] NULL,
	[WHA] [float] NULL,
	[VCH] [float] NULL,
	[VCD] [float] NULL,
	[VCA] [float] NULL,
	[PSCH] [float] NULL,
	[PSCD] [float] NULL,
	[PSCA] [float] NULL,
	CONSTRAINT PK_Game PRIMARY KEY (gameID),
	CONSTRAINT FK_GameLeague FOREIGN KEY (leagueID) REFERENCES leagues(leagueID)
);

CREATE TABLE [dbo].[appearances](
	[gameID] [float] NOT NULL,
	[playerID] [float] NOT NULL,
	[goals] [float] NULL,
	[ownGoals] [float] NULL,
	[shots] [float] NULL,
	[xGoals] [float] NULL,
	[xGoalsChain] [float] NULL,
	[xGoalsBuildup] [float] NULL,
	[assists] [float] NULL,
	[keyPasses] [float] NULL,
	[xAssists] [float] NULL,
	[position] [nvarchar](255) NULL,
	[positionOrder] [float] NULL,
	[yellowCard] [float] NULL,
	[redCard] [float] NULL,
	[time] [float] NULL,
	[substituteIn] [float] NULL,
	[substituteOut] [float] NULL,
	[leagueID] [float] NULL,
	CONSTRAINT PK_Appearance PRIMARY KEY (gameID,playerID),
	CONSTRAINT FK_AppearanceGame FOREIGN KEY (gameID) REFERENCES games(gameID),
	CONSTRAINT FK_AppearancePlayer FOREIGN KEY (playerID) REFERENCES players(playerID)
);

/*CREATE TABLE [dbo].[shots](
	[gameID] [float] NOT NULL,
	[shooterID] [float] NOT NULL,
	[assisterID] [float] NULL,
	[minute] [float] NOT NULL,
	[situation] [nvarchar](255) NULL,
	[lastAction] [nvarchar](255) NULL,
	[shotType] [nvarchar](255) NULL,
	[shotResult] [nvarchar](255) NULL,
	[xGoal] [float] NOT NULL,
	[positionX] [float] NULL,
	[positionY] [float] NULL,
	CONSTRAINT PK_Shot PRIMARY KEY (gameID,shooterID,minute,xGoal),
	CONSTRAINT FK_ShotGame FOREIGN KEY (gameID) REFERENCES games(gameID),
	CONSTRAINT FK_ShotShooter FOREIGN KEY (shooterID) REFERENCES players(playerID),
	CONSTRAINT FK_ShotAssister FOREIGN KEY (assisterID) REFERENCES players(playerID)
);*/

CREATE TABLE [dbo].[teamstats](
	[gameID] [float] NOT NULL,
	[teamID] [float] NOT NULL,
	[season] [float] NULL,
	[date] [datetime] NULL,
	[location] [nvarchar](255) NULL,
	[goals] [float] NULL,
	[xGoals] [float] NULL,
	[shots] [float] NULL,
	[shotsOnTarget] [float] NULL,
	[deep] [float] NULL,
	[ppda] [float] NULL,
	[fouls] [float] NULL,
	[corners] [float] NULL,
	[yellowCards] [float] NULL,
	[redCards] [float] NULL,
	[result] [nvarchar](255) NULL,
	CONSTRAINT PK_Teamstat PRIMARY KEY (gameID,teamID),
	CONSTRAINT FK_TeamstatGame FOREIGN KEY (gameID) REFERENCES games(gameID),
	CONSTRAINT FK_TeamstatTeam FOREIGN KEY (teamID) REFERENCES teams(teamID)
);
