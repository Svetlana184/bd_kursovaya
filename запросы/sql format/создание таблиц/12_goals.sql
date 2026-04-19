CREATE TABLE Goals (
    IdGoal INT IDENTITY(1,1) NOT NULL,
    IdUser INT NOT NULL,
    Title NVARCHAR(200) NOT NULL,
    Description NVARCHAR(MAX) NULL,
    Deadline DATETIME NULL,
    Status NVARCHAR(50) NOT NULL,
    DateCreated DATETIME NOT NULL DEFAULT GETDATE(),
    DateCompleted DATETIME NULL,
    
    -- Поля для периодичности
    PeriodicityValue INT NULL,
    PeriodicityUnit NVARCHAR(100) NULL
    
    
    CONSTRAINT PK_Goals PRIMARY KEY NONCLUSTERED (IdGoal),
    CONSTRAINT FK_Goals_User FOREIGN KEY (IdUser) REFERENCES Users(IdUser) ON DELETE CASCADE,
    CONSTRAINT CK_Goals_Status CHECK (Status IN ('Created', 'InProgress', 'Completed', 'Failed', 'Frozen')),
    CONSTRAINT CK_Goals_Periodicity CHECK (
        (PeriodicityUnit IS NULL AND PeriodicityValue IS NULL) OR
        (PeriodicityUnit IN ('minutes', 'hours', 'days', 'weeks') AND PeriodicityValue > 0)
    )
);
GO

-- Индексы для Goals
CREATE NONCLUSTERED INDEX IX_Goals_Status_Deadline ON Goals(Status, Deadline) 
    WHERE Status IN ('Created', 'InProgress');
CREATE NONCLUSTERED INDEX IX_Goals_User_Active ON Goals(IdUser) 
    INCLUDE (Title, Status);
GO
