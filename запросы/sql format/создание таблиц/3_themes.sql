CREATE TABLE ThemesForArticles (
    IdThemeForArticles INT IDENTITY(1,1) NOT NULL,
    Title NVARCHAR(200) NOT NULL,
    IdParentTheme INT NULL,
    IsActive BIT NOT NULL DEFAULT 1,
    
    CONSTRAINT PK_Themes PRIMARY KEY CLUSTERED (IdThemeForArticles),
    CONSTRAINT FK_Themes_Parent FOREIGN KEY (IdParentTheme) REFERENCES ThemesForArticles(IdThemeForArticles)
);
GO