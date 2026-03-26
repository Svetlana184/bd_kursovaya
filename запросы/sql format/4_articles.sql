/*
CREATE TABLE Articles (
    IdArticle INT IDENTITY(1,1) NOT NULL,
    Title NVARCHAR(200) NOT NULL,
    Description NVARCHAR(MAX) NULL,
    PublicationDate DATETIME NULL,
    UpdateDate DATETIME NULL,
    Status NVARCHAR(50) NOT NULL,
    Text NVARCHAR(MAX) NOT NULL,
    Author INT NOT NULL,
    CountLikes INT NOT NULL,
    CountFavs INT NOT NULL,
    
    CONSTRAINT PK_Articles PRIMARY KEY CLUSTERED (IdArticle),
    CONSTRAINT FK_Articles_Author FOREIGN KEY (Author) REFERENCES Users(IdUser),
    CONSTRAINT CK_Articles_Status CHECK (Status IN ('Draft', 'Published', 'Archived', 'Blocked'))
);
GO

-- Индексы для Articles
CREATE NONCLUSTERED INDEX IX_Articles_Author_Status ON Articles(Author, Status) 
    INCLUDE (Title, PublicationDate);
CREATE NONCLUSTERED INDEX IX_Articles_PublicationDate ON Articles(PublicationDate DESC) 
    WHERE Status = 'Published';
GO
*/
CREATE NONCLUSTERED INDEX IX_Articles_Title ON Articles(Title) 
     INCLUDE (IdArticle, Author, PublicationDate, Text);
GO