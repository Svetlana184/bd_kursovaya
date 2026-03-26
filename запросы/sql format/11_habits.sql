CREATE TABLE Habits (
    IdTracker INT NOT NULL,
    DateHabit DATE NOT NULL,
	TimeHabit TIME NOT NULL,
    Status NVARCHAR(50) NOT NULL,
    
    CONSTRAINT PK_Habits PRIMARY KEY CLUSTERED (IdTracker, DateHabit, TimeHabit),
    CONSTRAINT FK_Habits_Tracker FOREIGN KEY (IdTracker) 
        REFERENCES Trackers(IdTracker) ON DELETE CASCADE,
    CONSTRAINT CK_Habits_Status CHECK (Status IN 
	('Skipped', 'Empty', 'A little', 'Bad', 'Normal', 'Good', 'Excellent', 'Bad'))
) ON PS_Habits_Year(DateHabit);
GO

-- Индексы для Habits
CREATE NONCLUSTERED INDEX IX_Habits_Date ON Habits(DateHabit) 
    INCLUDE (IdTracker, Status);
CREATE NONCLUSTERED INDEX IX_Habits_Status ON Habits(Status) 
    WHERE Status IN ('A little', 'Bad', 'Normal', 'Good', 'Excellent', 'Bad');
GO