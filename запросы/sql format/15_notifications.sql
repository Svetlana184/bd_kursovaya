CREATE TABLE Notifications (
    IdNotification INT IDENTITY(1,1) NOT NULL,
    IdUser INT NOT NULL,
    Text NVARCHAR(500) NOT NULL,
    Time TIME NOT NULL,
    PeriodicityValue INT NULL,
    PeriodicityUnit NVARCHAR(20) NULL,
	IdGoal INT NULL,
	IdTask INT NULL,
    
    CONSTRAINT PK_Reminders PRIMARY KEY CLUSTERED (IdNotification),
    CONSTRAINT FK_Reminders_User FOREIGN KEY (IdUser) REFERENCES Users(IdUser) ON DELETE CASCADE,
    CONSTRAINT CK_Reminders_Reference CHECK (
        (IdGoal IS NOT NULL AND IdTask IS NULL) OR
        (IdGoal IS NULL AND IdTask IS NOT NULL) OR
        (IdGoal IS NULL AND IdTask IS NULL)
    )
);
GO

-- Индексы для Notifications
CREATE NONCLUSTERED INDEX IX_Notifications_User ON Notifications(IdUser);
GO