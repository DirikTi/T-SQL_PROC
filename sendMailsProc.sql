CREATE TABLE users (
    user_id int IDENTITY(1,1) PRIMARY KEY,
    username VARCHAR(100) NOT NULL,
    email VARCHAR(100) NOT NULL,
    is_active bit DEFAULT 0,
    create_date datetime DEFAULT GETDATE()
);


CREATE PROCEDURE sendMailGroup
@body CHAR(255),
@subject CHAR(63)
AS
BEGIN
    DECLARE @username VARCHAR(255)
    DECLARE @email VARCHAR(255)

	

	DECLARE CRS_USERS CURSOR FOR
	SELECT users.email, users.username 
    FROM users 
    WHERE is_active=1

    OPEN CRS_USERS
    FETCH NEXT FROM CRS_USERS INTO @email, @username

    WHILE @@FETCH_STATUS = 0
    BEGIN

        SET @subject = @subject + ' respect ' + @username
        
        EXEC msdb.dbo.sp_send_dbmail 
            @profile_name='Asikus',
            @recipients=@email,
            @subject= @subject,
            @body=@body,
            @body_format='HTML';

            FETCH NEXT FROM CRS_USERS INTO @email, @username
        END
        
    CLOSE CRS_USERS
    DEALLOCATE CRS_USERS -- You have to deallocate this cursor


END