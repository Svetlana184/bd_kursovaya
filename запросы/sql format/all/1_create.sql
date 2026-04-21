
-- Создание файловых групп для партиционирования
ALTER DATABASE TeploDB ADD FILEGROUP FG_Habits_2024;
ALTER DATABASE TeploDB ADD FILEGROUP FG_Habits_2025;
ALTER DATABASE TeploDB ADD FILEGROUP FG_Habits_Archive;

-- Добавление файлов в файловые группы
ALTER DATABASE TeploDB ADD FILE 
(
    NAME = N'Habits_2024_Data',
    FILENAME = N'D:\Data\Habits_2024.ndf',
    SIZE = 500MB,
    MAXSIZE = UNLIMITED,
    FILEGROWTH = 100MB
) TO FILEGROUP FG_Habits_2024;

ALTER DATABASE TeploDB ADD FILE 
(
    NAME = N'Habits_2025_Data',
    FILENAME = N'D:\Data\Habits_2025.ndf',
    SIZE = 500MB,
    MAXSIZE = UNLIMITED,
    FILEGROWTH = 100MB
) TO FILEGROUP FG_Habits_2025;

ALTER DATABASE TeploDB ADD FILE 
(
    NAME = N'Habits_Archive_Data',
    FILENAME = N'D:\Data\Habits_Archive.ndf',
    SIZE = 1GB,
    MAXSIZE = UNLIMITED,
    FILEGROWTH = 200MB
) TO FILEGROUP FG_Habits_Archive;
GO

CREATE PARTITION FUNCTION PF_Habits_Year (DATE)
AS RANGE RIGHT FOR VALUES (
    '2024-01-01', '2025-01-01', '2026-01-01'
);
GO

-- Схема партиционирования
CREATE PARTITION SCHEME PS_Habits_Year
AS PARTITION PF_Habits_Year
TO (FG_Habits_2024, FG_Habits_2025, FG_Habits_Archive, [PRIMARY]);
GO

CREATE TABLE Users (
    IdUser INT IDENTITY(1,1) NOT NULL,
    Name NVARCHAR(200) NOT NULL,
    Email NVARCHAR(300) NOT NULL,
    Phone NVARCHAR(20) NULL,
    PasswordHash NVARCHAR(255) NOT NULL,
    IsAuthor BIT NOT NULL DEFAULT 0,
    Birthday DATE NULL,
    Language NVARCHAR(10) NOT NULL DEFAULT 'ru',
    LastLoginAt DATETIME NULL,
    DateCreated DATETIME NOT NULL DEFAULT GETDATE(),
    DateUpdated DATETIME NULL,
    DateDeleted DATETIME NULL,
    IsDeleted BIT NOT NULL DEFAULT 0,
	UserName NVARCHAR(100) NOT NULL,
	Description NVARCHAR(500 ) NULL,
    
    CONSTRAINT PK_Users PRIMARY KEY CLUSTERED (IdUser),
    CONSTRAINT CK_Users_Language CHECK (Language IN ('ru', 'en')),
    CONSTRAINT CK_Users_Email CHECK (Email LIKE '%_@__%.__%')
);
GO

CREATE UNIQUE NONCLUSTERED INDEX UX_Users_Email 
ON Users(Email) 
WHERE IsDeleted = 0;
GO

CREATE UNIQUE NONCLUSTERED INDEX UX_Users_Phone 
ON Users(Phone) 
WHERE Phone IS NOT NULL AND IsDeleted = 0;
GO

ALTER TABLE Users ADD CONSTRAINT UX_Users_UserName UNIQUE (UserName)

-- Индексы для Users
CREATE NONCLUSTERED INDEX IX_Users_IsAuthor ON Users(IsAuthor) INCLUDE(IdUser, Name, Description) WHERE IsAuthor = 1;
CREATE NONCLUSTERED INDEX IX_Users_LastLogin ON Users(LastLoginAt) WHERE IsDeleted = 0;
GO


CREATE TABLE ThemesForArticles (
    IdThemeForArticles INT IDENTITY(1,1) NOT NULL,
    Title NVARCHAR(200) NOT NULL,
    IdParentTheme INT NULL,
    IsActive BIT NOT NULL DEFAULT 1,
    
    CONSTRAINT PK_Themes PRIMARY KEY CLUSTERED (IdThemeForArticles),
    CONSTRAINT FK_Themes_Parent FOREIGN KEY (IdParentTheme) REFERENCES ThemesForArticles(IdThemeForArticles)
);
GO


CREATE TABLE Articles (
    IdArticle INT IDENTITY(1,1) NOT NULL,
    Title NVARCHAR(200) NOT NULL,
    Description NVARCHAR(MAX) NULL,
    PublicationDate DATETIME NULL,
    UpdateDate DATETIME NULL,
    Status NVARCHAR(50) NOT NULL,
    Text NVARCHAR(MAX) NOT NULL,
    Author INT NOT NULL,
    CountLikes INT DEFAULT 0 NOT NULL,
    CountFavs INT DEFAULT 0 NOT NULL,
	CountViews INT DEFAULT 0 NOT NULL,
    
    CONSTRAINT PK_Articles PRIMARY KEY CLUSTERED (IdArticle),
    CONSTRAINT FK_Articles_Author FOREIGN KEY (Author) REFERENCES Users(IdUser),
    CONSTRAINT CK_Articles_Status CHECK (Status IN ('Draft', 'Published', 'Archived', 'Blocked'))
);
GO

-- Индексы для Articles
CREATE NONCLUSTERED INDEX IX_Articles_Author_Status ON Articles(Author, Status) 
    INCLUDE (Title, PublicationDate, Text);
CREATE NONCLUSTERED INDEX IX_Articles_PublicationDate ON Articles(PublicationDate DESC) 
    WHERE Status = 'Published';
GO

CREATE NONCLUSTERED INDEX IX_Articles_Title ON Articles(Title) 
     INCLUDE (IdArticle, Author, PublicationDate, Text);
GO

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

CREATE TABLE Likes (
    IdArticle INT NOT NULL,
    IdUser INT NOT NULL,
    Date DATETIME NOT NULL DEFAULT GETDATE(),
    
    CONSTRAINT PK_Likes PRIMARY KEY (IdArticle, IdUser),
    CONSTRAINT FK_Likes_Article FOREIGN KEY (IdArticle) 
        REFERENCES Articles(IdArticle) ON DELETE CASCADE,
    CONSTRAINT FK_Likes_User FOREIGN KEY (IdUser) 
        REFERENCES Users(IdUser) ON DELETE CASCADE
);
GO

CREATE TABLE Favs (
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

CREATE TABLE Icons (
    IdIcon INT IDENTITY(1,1) NOT NULL,
    Title NVARCHAR(100) NOT NULL,
    Resource NVARCHAR(500) NOT NULL,
    Color NVARCHAR(50) NULL,
    Category NVARCHAR(200) NULL,
    Type NVARCHAR(50) NULL,
    
    CONSTRAINT PK_Icons PRIMARY KEY CLUSTERED (IdIcon),
    CONSTRAINT UX_Icons_Name UNIQUE NONCLUSTERED (Title)
);
GO


CREATE TABLE Trackers (
    IdTracker INT IDENTITY(1,1) NOT NULL,
    IdUser INT NOT NULL,
    Title NVARCHAR(200) NOT NULL,
    Description NVARCHAR(MAX) NULL,
    DateCreated DATETIME NOT NULL DEFAULT GETDATE(),
    DateUpdated DATETIME NULL,
    Color NVARCHAR(50) NULL,
    IsActive BIT NOT NULL DEFAULT 1,
	UnitsOfMeasurement NVARCHAR(50) NOT NULL,
	ReferenceValue DECIMAL(10, 2) NOT NULL,
    
    CONSTRAINT PK_Trackers PRIMARY KEY CLUSTERED (IdTracker),
    CONSTRAINT FK_Trackers_User FOREIGN KEY (IdUser) REFERENCES Users(IdUser) ON DELETE CASCADE,
);
GO

-- Индексы для Trackers
CREATE NONCLUSTERED INDEX IX_Trackers_User_Active ON Trackers(IdUser, IsActive) 
    INCLUDE (Title);
GO

CREATE TABLE IconsForTracker (
    IdTracker INT NOT NULL,
    IdIcon INT NOT NULL,
    
    CONSTRAINT PK_IconsForTracker PRIMARY KEY (IdTracker, IdIcon),
    CONSTRAINT FK_IconsForTracker_Tracker FOREIGN KEY (IdTracker) 
        REFERENCES Trackers(IdTracker) ON DELETE CASCADE,
    CONSTRAINT FK_IconsForTracker_Icon FOREIGN KEY (IdIcon) 
        REFERENCES Icons(IdIcon) ON DELETE CASCADE
);
GO

CREATE TABLE Habits (
    IdTracker INT NOT NULL,
    DateHabit DATE NOT NULL,
	TimeHabit TIME NOT NULL,
    Status NVARCHAR(50) NOT NULL,
	Value DECIMAL(10, 2) NOT NULL,
    
    CONSTRAINT PK_Habits PRIMARY KEY CLUSTERED (IdTracker, DateHabit, TimeHabit),
    CONSTRAINT FK_Habits_Tracker FOREIGN KEY (IdTracker) 
        REFERENCES Trackers(IdTracker) ON DELETE CASCADE,
    CONSTRAINT CK_Habits_Status CHECK (Status IN 
	('Skipped', 'Empty', 'A little', 'Normal', 'Good', 'Excellent', 'Bad'))
) ON PS_Habits_Year(DateHabit);
GO

-- Индексы для Habits
CREATE NONCLUSTERED INDEX IX_Habits_Date ON Habits(DateHabit) 
    INCLUDE (IdTracker, Status);
CREATE NONCLUSTERED INDEX IX_Habits_Status ON Habits(Status) 
    WHERE Status IN ('A little', 'Normal', 'Good', 'Excellent', 'Bad');
GO

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


CREATE TABLE TodoLists (
    IdTodoList INT IDENTITY(1,1) NOT NULL,
    IdUser INT NOT NULL,
    IdNote INT NULL,
    IdParentTodoList INT NULL,
    Title NVARCHAR(300) NOT NULL,
	Date DATETIME NOT NULL default getdate(),
    
    CONSTRAINT PK_TodoLists PRIMARY KEY CLUSTERED (IdTodoList),
    CONSTRAINT FK_TodoLists_User FOREIGN KEY (IdUser) REFERENCES Users(IdUser) ON DELETE CASCADE,
    CONSTRAINT FK_TodoLists_Parent FOREIGN KEY (IdParentTodoList) REFERENCES TodoLists(IdTodoList),
);
GO


CREATE TABLE Tasks (
    IdTask INT IDENTITY(1,1) NOT NULL,
    IdTodoList INT NOT NULL,
    IdGoal INT NULL,
    Text NVARCHAR(MAX) NOT NULL,
    Status NVARCHAR(50) NOT NULL,
    
    CONSTRAINT PK_Tasks PRIMARY KEY NONCLUSTERED (IdTask),
    CONSTRAINT FK_Tasks_TodoList FOREIGN KEY (IdTodoList) 
        REFERENCES TodoLists(IdTodoList) ON DELETE CASCADE,
    CONSTRAINT FK_Tasks_Goal FOREIGN KEY (IdGoal) REFERENCES Goals(IdGoal) ON DELETE NO ACTION,
    CONSTRAINT CK_Tasks_Status CHECK (Status IN ('Created', 'InProgress', 'Completed', 'Failed', 'Frozen'))
);
GO

-- Индексы для Tasks
CREATE NONCLUSTERED INDEX IX_Tasks_Status_Uncompleted ON Tasks(Status) 
    WHERE Status IN ('Created', 'InProgress');
GO

CREATE NONCLUSTERED INDEX IX_Tasks_Status_Completed_Failed ON Tasks(Status) 
    WHERE Status IN ('Completed', 'Failed');
GO

CREATE TABLE Notifications (
    IdNotification INT IDENTITY(1,1) NOT NULL,
    IdUser INT NOT NULL,
    Text NVARCHAR(500) NOT NULL,
    Time TIME NOT NULL,
    PeriodicityValue INT NULL,
    PeriodicityUnit NVARCHAR(20) NULL,
	IdGoal INT NULL,
	IdTask INT NULL,
	Type NVARCHAR(100),
    
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


CREATE TABLE ThemesForNotes (
    IdThemeForNotes INT IDENTITY(1,1) NOT NULL,
    CountNotes INT DEFAULT 0 NOT NULL,
    Title NVARCHAR(100) NOT NULL,
    
    
    CONSTRAINT PK_ThemesForNotes PRIMARY KEY CLUSTERED (IdThemeForNotes)
);
GO


CREATE TABLE Notes (
    IdNote INT IDENTITY(1,1) NOT NULL,
    IdUser INT NOT NULL,
    Date DATE NOT NULL DEFAULT CAST(GETDATE() AS DATE),
    Text NVARCHAR(MAX) NULL,
	IdThemeForNote INT REFERENCES ThemesForNotes(IdThemeForNotes),
   
    
    CONSTRAINT PK_Notes PRIMARY KEY CLUSTERED (IdNote),
    CONSTRAINT FK_Notes_User FOREIGN KEY (IdUser) REFERENCES Users(IdUser) ON DELETE CASCADE,
);
GO

-- Индексы для Notes
CREATE NONCLUSTERED INDEX IX_Notes_User_Date ON Notes(IdUser, Date) 
    INCLUDE (Text);
CREATE NONCLUSTERED INDEX IX_Notes_Date ON Notes(Date);
GO


CREATE TABLE Photos (
    IdPhoto INT IDENTITY(1,1) NOT NULL,
    IdNote INT NOT NULL,
    Resource NVARCHAR(500) NOT NULL,
    
    
    CONSTRAINT PK_Photos PRIMARY KEY CLUSTERED (IdPhoto),
    CONSTRAINT FK_Photos_Note FOREIGN KEY (IdNote) REFERENCES Notes(IdNote) ON DELETE CASCADE
);
GO

-- Индекс для Photos
CREATE NONCLUSTERED INDEX IX_Photos_Note ON Photos(IdNote);
GO


CREATE TABLE Templates (
    IdTemplate INT IDENTITY(1,1) NOT NULL,
    Text NVARCHAR(MAX) NOT NULL,
  
    CONSTRAINT PK_Templates PRIMARY KEY CLUSTERED (IdTemplate),
);
GO


CREATE TABLE TemplatesForNotes (
    IdTemplate INT NOT NULL,
    IdNote INT NOT NULL,
    
    CONSTRAINT PK_TemplatesForNotes PRIMARY KEY (IdTemplate, IdNote),
    CONSTRAINT FK_TemplatesForNotes_Template FOREIGN KEY (IdTemplate) 
        REFERENCES Templates(IdTemplate) ON DELETE CASCADE,
    CONSTRAINT FK_TemplatesForNotes_Note FOREIGN KEY (IdNote) 
        REFERENCES Notes(IdNote) ON DELETE CASCADE
);
GO

CREATE NONCLUSTERED INDEX IX_ThemesForNotes_Title ON ThemesForNotes(Title);