USE demo;
go

IF OBJECT_ID('dbo.shots') IS NOT NULL
	DROP TABLE dbo.shots;
go

IF OBJECT_ID('dbo.players') IS NOT NULL
BEGIN
	--ALTER TABLE dbo.players SET (SYSTEM_VERSIONING = OFF);
	DROP TABLE dbo.players;
END
go

IF OBJECT_ID('dbo.write_shot') IS NOT NULL
	DROP PROCEDURE dbo.write_shot;
go

CREATE TABLE dbo.players
(
	player_id int NOT NULL IDENTITY,
	player_name varchar(100) NOT NULL,
	shots_attempted int NOT NULL DEFAULT 0,
	shots_made int NOT NULL DEFAULT 0,
	CONSTRAINT players_PK PRIMARY KEY (player_id)
);

CREATE TABLE dbo.shots
(
	shot_id int NOT NULL IDENTITY,
	player_id int NOT NULL,
	clock_time datetime NOT NULL,
	shot_made bit NOT NULL,
	CONSTRAINT shots_PK PRIMARY KEY (shot_id),
	CONSTRAINT shots_FK1 FOREIGN KEY (player_id) REFERENCES dbo.players (player_id)
);
go

CREATE PROCEDURE dbo.write_shot
	@player_id int,
	@clock_time datetime,
	@shot_made bit
AS
BEGIN TRY
	BEGIN TRANSACTION
	INSERT	dbo.shots (player_id, clock_time, shot_made) 
	VALUES	(@player_id, @clock_time, @shot_made);
	UPDATE	dbo.players
	SET		shots_attempted = shots_attempted + 1,
			shots_made = CASE @shot_made 
				WHEN 1 THEN COALESCE(shots_made, 0) + 1 
				ELSE shots_made 
			END
	WHERE	player_id = @player_id;
	COMMIT TRANSACTION;
END TRY
BEGIN CATCH
	ROLLBACK TRANSACTION
END CATCH
go

INSERT dbo.players (player_name, shots_attempted, shots_made)
VALUES
('Mary', 0, 0),
('Sue', 0, 0);

SELECT * FROM dbo.players;
go

ALTER TABLE dbo.players
ADD StartTime DATETIME2 GENERATED ALWAYS AS ROW START
  HIDDEN DEFAULT GETUTCDATE(),
 EndTime  DATETIME2 GENERATED ALWAYS AS ROW END
  HIDDEN DEFAULT
     CONVERT(DATETIME2, '9999-12-31 23:59:59.9999999'),
 PERIOD FOR SYSTEM_TIME (StartTime, EndTime);
go

ALTER TABLE dbo.players
SET (SYSTEM_VERSIONING = ON (HISTORY_TABLE=dbo.player_history));
go

SELECT * FROM dbo.players;
go

EXEC dbo.write_shot 1, '2019/10/10 10:00:00', 1;
EXEC dbo.write_shot 2, '2019/10/10 10:00:20', 0;
EXEC dbo.write_shot 1, '2019/10/10 10:00:30', 0;
EXEC dbo.write_shot 2, '2019/10/10 10:00:40', 0;
EXEC dbo.write_shot 1, '2019/10/10 10:00:50', 0;
EXEC dbo.write_shot 2, '2019/10/10 10:01:00', 0;
EXEC dbo.write_shot 1, '2019/10/10 10:00:00', 0;
EXEC dbo.write_shot 2, '2019/10/10 10:00:00', 1;
EXEC dbo.write_shot 1, '2019/10/10 10:00:00', 0;
EXEC dbo.write_shot 2, '2019/10/10 10:00:00', 1;
EXEC dbo.write_shot 1, '2019/10/10 10:00:00', 0;
EXEC dbo.write_shot 2, '2019/10/10 10:00:00', 0;
EXEC dbo.write_shot 1, '2019/10/10 10:04:10', 0;
EXEC dbo.write_shot 2, '2019/10/10 10:04:20', 0;
EXEC dbo.write_shot 1, '2019/10/10 10:04:30', 0;
go

SELECT	* 
FROM	dbo.players;
go

SELECT	* 
FROM	dbo.players
FOR		SYSTEM_TIME BETWEEN '2019-01-01 00:00:00.0000000' AND '2019-11-01 00:00:00.0000000';
go

