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

CREATE UNIQUE NONCLUSTERED INDEX UX_Users_Name 
ON Users(Name) 
WHERE IsDeleted = 0;
GO

-- Индексы для Users
CREATE NONCLUSTERED INDEX IX_Users_IsAuthor ON Users(IsAuthor) WHERE IsAuthor = 1;
CREATE NONCLUSTERED INDEX IX_Users_LastLogin ON Users(LastLoginAt) WHERE IsDeleted = 0;
GO
