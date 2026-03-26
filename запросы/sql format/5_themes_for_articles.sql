CREATE TABLE ThemesForArticles (
    IdArticle INT NOT NULL,
    IdTheme INT NOT NULL,
    
    CONSTRAINT PK_ThemesForArticles PRIMARY KEY (IdArticle, IdTheme),
    CONSTRAINT FK_ThemesForArticles_Article FOREIGN KEY (IdArticle) 
        REFERENCES Articles(IdArticle) ON DELETE CASCADE,
    CONSTRAINT FK_ThemesForArticles_Theme FOREIGN KEY (IdTheme) 
        REFERENCES Themes(IdTheme) ON DELETE CASCADE
);
GO