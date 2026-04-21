CREATE OR ALTER TRIGGER trg_Notes_UpdateThemeCount
ON Notes
AFTER INSERT, UPDATE, DELETE
AS
BEGIN
    SET NOCOUNT ON;

    -- При вставке новых заметок
    IF EXISTS (SELECT 1 FROM inserted) AND NOT EXISTS (SELECT 1 FROM deleted)
    BEGIN
        UPDATE tf
        SET tf.CountNotes = tf.CountNotes + 1
        FROM ThemesForNotes tf
        INNER JOIN inserted i ON tf.IdThemeForNotes = i.IdThemeForNote
        WHERE i.IdThemeForNote IS NOT NULL;
    END

    -- При удалении заметок
    IF EXISTS (SELECT 1 FROM deleted) AND NOT EXISTS (SELECT 1 FROM inserted)
    BEGIN
        UPDATE tf
        SET tf.CountNotes = tf.CountNotes - 1
        FROM ThemesForNotes tf
        INNER JOIN deleted d ON tf.IdThemeForNotes = d.IdThemeForNote
        WHERE d.IdThemeForNote IS NOT NULL;
    END

    -- При изменении темы у заметки
    IF EXISTS (SELECT 1 FROM inserted) AND EXISTS (SELECT 1 FROM deleted)
    BEGIN
        -- Уменьшаем счётчик для старой темы
        UPDATE tf
        SET tf.CountNotes = tf.CountNotes - 1
        FROM ThemesForNotes tf
        INNER JOIN deleted d ON tf.IdThemeForNotes = d.IdThemeForNote
        WHERE d.IdThemeForNote IS NOT NULL;

        -- Увеличиваем счётчик для новой темы
        UPDATE tf
        SET tf.CountNotes = tf.CountNotes + 1
        FROM ThemesForNotes tf
        INNER JOIN inserted i ON tf.IdThemeForNotes = i.IdThemeForNote
        WHERE i.IdThemeForNote IS NOT NULL;
    END
END;
GO


-- Функция для проверки количества фото
CREATE OR ALTER FUNCTION fn_CheckPhotosLimit(@IdNote INT)
RETURNS BIT
AS
BEGIN
    DECLARE @PhotoCount INT;
    
    SELECT @PhotoCount = COUNT(*)
    FROM Photos
    WHERE IdNote = @IdNote;
    
    RETURN CASE WHEN @PhotoCount <= 5 THEN 1 ELSE 0 END;
END;
GO

-- Ограничение CHECK
ALTER TABLE Photos
ADD CONSTRAINT CK_Photos_MaxPerNote CHECK (dbo.fn_CheckPhotosLimit(IdNote) = 1);
GO

ALTER TABLE Users
ADD CONSTRAINT CK_Users_LastLoginAfterCreation 
CHECK (LastLoginAt IS NULL OR LastLoginAt >= DateCreated);
GO

CREATE OR ALTER TRIGGER trg_Users_SetDateDeleted
ON Users
AFTER UPDATE
AS
BEGIN
    SET NOCOUNT ON;

    UPDATE u
    SET u.DateDeleted = GETDATE()
    FROM Users u
    INNER JOIN inserted i ON u.IdUser = i.IdUser
    INNER JOIN deleted d ON u.IdUser = d.IdUser
    WHERE i.IsDeleted = 1 AND d.IsDeleted = 0;
END;
GO


ALTER TABLE Goals
ADD CONSTRAINT CK_Goals_DateCompletedValid 
CHECK (DateCompleted IS NULL OR DateCompleted >= DateCreated);
GO

CREATE OR ALTER TRIGGER trg_Favs_UpdateCountFavs
ON Favs
AFTER INSERT, DELETE
AS
BEGIN
    SET NOCOUNT ON;

    -- При добавлении в избранное
    IF EXISTS (SELECT 1 FROM inserted)
    BEGIN
        UPDATE a
        SET a.CountFavs = a.CountFavs + 1
        FROM Articles a
        INNER JOIN inserted i ON a.IdArticle = i.IdArticle;
    END

    -- При удалении из избранного
    IF EXISTS (SELECT 1 FROM deleted)
    BEGIN
        UPDATE a
        SET a.CountFavs = a.CountFavs - 1
        FROM Articles a
        INNER JOIN deleted d ON a.IdArticle = d.IdArticle;
    END
END;
GO


CREATE OR ALTER TRIGGER trg_Likes_UpdateCountLikes
ON Likes
AFTER INSERT, DELETE
AS
BEGIN
    SET NOCOUNT ON;

    -- При добавлении лайка
    IF EXISTS (SELECT 1 FROM inserted)
    BEGIN
        UPDATE a
        SET a.CountLikes = a.CountLikes + 1
        FROM Articles a
        INNER JOIN inserted i ON a.IdArticle = i.IdArticle;
    END

    -- При удалении лайка
    IF EXISTS (SELECT 1 FROM deleted)
    BEGIN
        UPDATE a
        SET a.CountLikes = a.CountLikes - 1
        FROM Articles a
        INNER JOIN deleted d ON a.IdArticle = d.IdArticle;
    END
END;
GO