CREATE TABLE Trackers (
    IdTracker INT IDENTITY(1,1) NOT NULL,
    IdUser INT NOT NULL,
    Title NVARCHAR(200) NOT NULL,
    Description NVARCHAR(MAX) NULL,
    DateCreated DATETIME NOT NULL DEFAULT GETDATE(),
    DateUpdated DATETIME NULL,
    Color NVARCHAR(50) NULL,
    IsActive BIT NOT NULL DEFAULT 1,
    
    CONSTRAINT PK_Trackers PRIMARY KEY CLUSTERED (IdTracker),
    CONSTRAINT FK_Trackers_User FOREIGN KEY (IdUser) REFERENCES Users(IdUser) ON DELETE CASCADE,
);
GO

-- Индексы для Trackers
CREATE NONCLUSTERED INDEX IX_Trackers_User_Active ON Trackers(IdUser, IsActive) 
    INCLUDE (Title);
GO