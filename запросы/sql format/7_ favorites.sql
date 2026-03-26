CREATE TABLE Favorites (
    IdArticle INT NOT NULL,
    IdUser INT NOT NULL,
    Date DATETIME NOT NULL DEFAULT GETDATE(),
    
    CONSTRAINT PK_Favorites PRIMARY KEY (IdArticle, IdUser),
    CONSTRAINT FK_Favorites_Article FOREIGN KEY (IdArticle) 
        REFERENCES Articles(IdArticle) ON DELETE CASCADE,
    CONSTRAINT FK_Favorites_User FOREIGN KEY (IdUser) 
        REFERENCES Users(IdUser) ON DELETE CASCADE
);
GO