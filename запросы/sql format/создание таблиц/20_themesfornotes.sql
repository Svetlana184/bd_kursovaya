CREATE TABLE ThemesForNotes (
    IdThemeForNotes INT IDENTITY(1,1) NOT NULL,
    CountNotes INT DEFAULT 0 NOT NULL,
    Title NVARCHAR(100) NOT NULL,
    
    
    CONSTRAINT PK_ThemesForNotes PRIMARY KEY CLUSTERED (IdThemeForNotes)
);
GO

-- Индекс для Photos
CREATE NONCLUSTERED INDEX IX_ThemesForNotes ON ThemesForNotes(Title);
GO
