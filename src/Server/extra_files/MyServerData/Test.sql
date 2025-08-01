DECLARE @Username varchar(100) = 'admin4'
DECLARE @Password varchar(100) = 'admin4'
DECLARE @Email varchar(100) = 'admin4@gmail.com'

EXEC DBO.UP_CreateUser @Username, @Password, @Email;