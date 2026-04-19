CREATE TABLE TagArticles (
    IdArticle INT NOT NULL,
    IdThemeForArticles INT NOT NULL,
    
    CONSTRAINT PK_ThemesForArticles PRIMARY KEY (IdArticle, IdThemeForArticles),
    CONSTRAINT FK_ThemesForArticles_Article FOREIGN KEY (IdArticle) 
        REFERENCES Articles(IdArticle) ON DELETE CASCADE,
    CONSTRAINT FK_ThemesForArticles_Theme FOREIGN KEY (IdThemeForArticles) 
        REFERENCES ThemesForArticles(IdThemeForArticles) ON DELETE CASCADE
);
GO