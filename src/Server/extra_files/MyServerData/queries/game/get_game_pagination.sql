--DECLARE @GameId UNIQUEIDENTIFIER;

BEGIN TRY
	BEGIN TRANSACTION
		EXEC HP_PaginateTable @tableName = 'Games', @orderColumn = 'gameId', @page = 1, @limit = 10,
        @columns = "gameId AS GameId";
	COMMIT TRANSACTION
END TRY
BEGIN CATCH
	IF @@TRANCOUNT > 0
		ROLLBACK TRANSACTION;

	SELECT NULL AS GamesPage;
END CATCH