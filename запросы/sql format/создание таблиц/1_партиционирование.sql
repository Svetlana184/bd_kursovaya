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