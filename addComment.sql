CREATE TABLE users (
    user_id int uniqueidentifier PRIMARY KEY,
    username VARCHAR(100) NOT NULL,
    email VARCHAR(100) NOT NULL,
    is_active bit DEFAULT 0,
    create_date DATETIME DEFAULT GETDATE()
);

CREATE TABLE photo (
    photo_id INT NOT NULL PRIMARY KEY,
    image_path VARCHAR(255),
    description VARCHAR(511),
    create_date DATETIME DEFAULT GETDATE(),
)

CREATE TABLE comments (
    comment_id INT NOT NULL PRIMARY KEY,
    comment_id_hiear HIERARCHYID NOT NULL,
    user_id uniqueidentifier NOT NULL,
    photo_id INT NOT NULL,
    comment_text VARCHAR(500),
    create_date DATETIME DEFAULT GETDATE(),
    update_date DATETIME NULL
);

CREATE VIEW V_COMMENTS 
AS
SELECT c.id, c.id.GetLevel() AS node_level, c.id.ToString() AS node_text, CONVERT(INT, CONVERT(varbinary, c.id, 1)) AS HEX_TO_INT, 
c.user_id, u.username, u.avatar, u.isPremium, c.comment_text, c.photo_id
DATEDIFF(MINUTE, c.createDate, GETDATE()) AS createDate, c.updateDate
FROM comments AS c 
INNER JOIN users u ON users.id = c.user_id
GO

CREATE PROCEDURE addComment
@user_id varchar(100),
@comment_text varchar(500),
@photo_id varchar(100),
@parent_node hierarchyid
AS
BEGIN
    DECLARE @last_comment_node hierarchyid	
	DECLARE @RESULT_NODE hierarchyid;

	IF @parent_node.ToString() = '/'
	BEGIN
			
		SELECT @last_comment_node=max(id) FROM V_COMMENTS 
		WHERE photo_id=@photo_id AND node_text LIKE @parent_node.ToString() + '%' AND node_level=1;
		
			
		SET @RESULT_NODE = @parent_node.GetDescendant(@last_comment_node, NULL)
	END
	ELSE
	BEGIN
		SELECT @last_comment_node=max(id) FROM V_COMMENTS 
			WHERE photo_id=@photo_id AND node_text LIKE @parent_node.ToString() + '%' AND node_level=2;

		IF @parent_node=@last_comment_node
		BEGIN
			SET @RESULT_NODE = @parent_node.GetDescendant(NULL, NULL)
		END
		ELSE
		BEGIN
			SET @RESULT_NODE = @parent_node.GetDescendant(@last_comment_node, null); 
		END
	END

	INSERT INTO comments (id, user_id, comment_text, photo_id) 
	VALUES (@RESULT_NODE, @user_id, @comment_text, @photo_id )


	SELECT @RESULT_NODE.ToString() AS RESULT

END