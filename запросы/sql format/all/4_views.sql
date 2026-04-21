-- =====================================================
-- 1. vw_UserDashboard - исправлено
-- =====================================================
CREATE OR ALTER VIEW vw_UserDashboard
AS
WITH 
-- Активные цели пользователя
UserGoals AS (
    SELECT 
        g.IdUser,
        g.IdGoal,
        g.Title,
        g.Description,
        g.Deadline,
        g.Status,
        g.DateCreated,
        g.PeriodicityValue,
        g.PeriodicityUnit,
        DATEDIFF(DAY, GETDATE(), g.Deadline) AS DaysUntilDeadline,
        CASE 
            WHEN g.Deadline < GETDATE() AND g.Status IN ('Created', 'InProgress') THEN 1 
            ELSE 0 
        END AS IsOverdue,
        CAST(NULL AS NVARCHAR(200)) AS TrackerTitle,
        CAST(NULL AS NVARCHAR(50)) AS UnitsOfMeasurement,
        CAST(NULL AS DECIMAL(10,2)) AS ReferenceValue,
        CAST(NULL AS DATE) AS DateHabit,
        CAST(NULL AS TIME) AS TimeHabit,
        CAST(NULL AS NVARCHAR(50)) AS HabitStatus,
        CAST(NULL AS DECIMAL(10,2)) AS HabitValue,
        CAST(NULL AS NVARCHAR(50)) AS GoalStatus,
        CAST(NULL AS NVARCHAR(300)) AS ListTitle,
        CAST(NULL AS DATETIME) AS ListDate,
        CAST(NULL AS INT) AS IdTask,
        CAST(NULL AS NVARCHAR(MAX)) AS TaskText,
        CAST(NULL AS NVARCHAR(50)) AS TaskStatus,
        CAST(NULL AS NVARCHAR(200)) AS RelatedGoalTitle,
        CAST(NULL AS INT) AS NoteId,
        CAST(NULL AS DATE) AS NoteDate,
        CAST(NULL AS NVARCHAR(MAX)) AS NoteText,
        CAST(NULL AS NVARCHAR(100)) AS ThemeTitle,
        CAST(NULL AS INT) AS PhotosCount,
        'Goal' AS RecordType
    FROM Goals g
    WHERE g.Status IN ('Created', 'InProgress')
),

-- Статистика привычек за неделю
UserWeeklyHabits AS (
    SELECT 
        t.IdUser,
        CAST(NULL AS INT) AS IdGoal,
        CAST(NULL AS NVARCHAR(200)) AS Title,
        CAST(NULL AS NVARCHAR(MAX)) AS Description,
        CAST(NULL AS DATETIME) AS Deadline,
        CAST(NULL AS NVARCHAR(50)) AS Status,
        CAST(NULL AS DATETIME) AS DateCreated,
        CAST(NULL AS INT) AS PeriodicityValue,
        CAST(NULL AS NVARCHAR(100)) AS PeriodicityUnit,
        CAST(NULL AS INT) AS DaysUntilDeadline,
        CAST(NULL AS BIT) AS IsOverdue,
        t.Title AS TrackerTitle,
        t.UnitsOfMeasurement,
        t.ReferenceValue,
        h.DateHabit,
        h.TimeHabit,
        h.Status AS HabitStatus,
        h.Value AS HabitValue,
        CASE 
            WHEN h.Value >= t.ReferenceValue THEN 'GoalAchieved'
            ELSE 'GoalNotAchieved'
        END AS GoalStatus,
        CAST(NULL AS NVARCHAR(300)) AS ListTitle,
        CAST(NULL AS DATETIME) AS ListDate,
        CAST(NULL AS INT) AS IdTask,
        CAST(NULL AS NVARCHAR(MAX)) AS TaskText,
        CAST(NULL AS NVARCHAR(50)) AS TaskStatus,
        CAST(NULL AS NVARCHAR(200)) AS RelatedGoalTitle,
        CAST(NULL AS INT) AS NoteId,
        CAST(NULL AS DATE) AS NoteDate,
        CAST(NULL AS NVARCHAR(MAX)) AS NoteText,
        CAST(NULL AS NVARCHAR(100)) AS ThemeTitle,
        CAST(NULL AS INT) AS PhotosCount,
        'Habit' AS RecordType
    FROM Trackers t
    INNER JOIN Habits h ON t.IdTracker = h.IdTracker
    WHERE h.DateHabit >= DATEADD(DAY, -7, GETDATE())
      AND h.DateHabit <= GETDATE()
      AND t.IsActive = 1
),

-- Списки дел на сегодня
UserTodayTasks AS (
    SELECT 
        tl.IdUser,
        CAST(NULL AS INT) AS IdGoal,
        CAST(NULL AS NVARCHAR(200)) AS Title,
        CAST(NULL AS NVARCHAR(MAX)) AS Description,
        CAST(NULL AS DATETIME) AS Deadline,
        CAST(NULL AS NVARCHAR(50)) AS Status,
        CAST(NULL AS DATETIME) AS DateCreated,
        CAST(NULL AS INT) AS PeriodicityValue,
        CAST(NULL AS NVARCHAR(100)) AS PeriodicityUnit,
        CAST(NULL AS INT) AS DaysUntilDeadline,
        CAST(NULL AS BIT) AS IsOverdue,
        CAST(NULL AS NVARCHAR(200)) AS TrackerTitle,
        CAST(NULL AS NVARCHAR(50)) AS UnitsOfMeasurement,
        CAST(NULL AS DECIMAL(10,2)) AS ReferenceValue,
        CAST(NULL AS DATE) AS DateHabit,
        CAST(NULL AS TIME) AS TimeHabit,
        CAST(NULL AS NVARCHAR(50)) AS HabitStatus,
        CAST(NULL AS DECIMAL(10,2)) AS HabitValue,
        CAST(NULL AS NVARCHAR(50)) AS GoalStatus,
        tl.Title AS ListTitle,
        tl.Date AS ListDate,
        t.IdTask,
        t.Text AS TaskText,
        t.Status AS TaskStatus,
        CASE 
            WHEN t.IdGoal IS NOT NULL THEN g.Title 
            ELSE NULL 
        END AS RelatedGoalTitle,
        CAST(NULL AS INT) AS NoteId,
        CAST(NULL AS DATE) AS NoteDate,
        CAST(NULL AS NVARCHAR(MAX)) AS NoteText,
        CAST(NULL AS NVARCHAR(100)) AS ThemeTitle,
        CAST(NULL AS INT) AS PhotosCount,
        'Task' AS RecordType
    FROM TodoLists tl
    INNER JOIN Tasks t ON tl.IdTodoList = t.IdTodoList
    LEFT JOIN Goals g ON t.IdGoal = g.IdGoal
    WHERE CAST(tl.Date AS DATE) = CAST(GETDATE() AS DATE)
      AND t.Status IN ('Created', 'InProgress')
),

-- Заметки на сегодня
UserTodayNotes AS (
    SELECT 
        n.IdUser,
        CAST(NULL AS INT) AS IdGoal,
        CAST(NULL AS NVARCHAR(200)) AS Title,
        CAST(NULL AS NVARCHAR(MAX)) AS Description,
        CAST(NULL AS DATETIME) AS Deadline,
        CAST(NULL AS NVARCHAR(50)) AS Status,
        CAST(NULL AS DATETIME) AS DateCreated,
        CAST(NULL AS INT) AS PeriodicityValue,
        CAST(NULL AS NVARCHAR(100)) AS PeriodicityUnit,
        CAST(NULL AS INT) AS DaysUntilDeadline,
        CAST(NULL AS BIT) AS IsOverdue,
        CAST(NULL AS NVARCHAR(200)) AS TrackerTitle,
        CAST(NULL AS NVARCHAR(50)) AS UnitsOfMeasurement,
        CAST(NULL AS DECIMAL(10,2)) AS ReferenceValue,
        CAST(NULL AS DATE) AS DateHabit,
        CAST(NULL AS TIME) AS TimeHabit,
        CAST(NULL AS NVARCHAR(50)) AS HabitStatus,
        CAST(NULL AS DECIMAL(10,2)) AS HabitValue,
        CAST(NULL AS NVARCHAR(50)) AS GoalStatus,
        CAST(NULL AS NVARCHAR(300)) AS ListTitle,
        CAST(NULL AS DATETIME) AS ListDate,
        CAST(NULL AS INT) AS IdTask,
        CAST(NULL AS NVARCHAR(MAX)) AS TaskText,
        CAST(NULL AS NVARCHAR(50)) AS TaskStatus,
        CAST(NULL AS NVARCHAR(200)) AS RelatedGoalTitle,
        n.IdNote AS NoteId,
        n.Date AS NoteDate,
        n.Text AS NoteText,
        tn.Title AS ThemeTitle,
        CAST(COUNT(p.IdPhoto) AS INT) AS PhotosCount,
        'Note' AS RecordType
    FROM Notes n
    LEFT JOIN ThemesForNotes tn ON n.IdThemeForNote = tn.IdThemeForNotes
    LEFT JOIN Photos p ON n.IdNote = p.IdNote
    WHERE n.Date = CAST(GETDATE() AS DATE)
    GROUP BY n.IdUser, n.IdNote, n.Date, n.Text, tn.Title
)

-- Объединение всех данных
SELECT * FROM UserGoals
UNION ALL
SELECT * FROM UserWeeklyHabits
UNION ALL
SELECT * FROM UserTodayTasks
UNION ALL
SELECT * FROM UserTodayNotes;
GO

-- =====================================================
-- 2. vw_PopularArticles - исправлено (добавлена обработка NULL)
-- =====================================================
CREATE OR ALTER VIEW vw_PopularArticles
AS
SELECT TOP 100
    a.IdArticle,
    a.Title,
    a.Description,
    a.PublicationDate,
    ISNULL(u.Name, 'Unknown') AS AuthorName,
    ISNULL(a.CountViews, 0) AS CountViews,
    ISNULL(a.CountLikes, 0) AS CountLikes,
    ISNULL(a.CountFavs, 0) AS CountFavs,
    (ISNULL(a.CountViews, 0) + ISNULL(a.CountLikes, 0) * 10 + ISNULL(a.CountFavs, 0) * 5) AS PopularityScore
FROM Articles a
INNER JOIN Users u ON a.Author = u.IdUser
WHERE a.Status = 'Published'
  AND a.PublicationDate IS NOT NULL
ORDER BY PopularityScore DESC, a.PublicationDate DESC;
GO

-- =====================================================
-- 3. vw_AuthorFullStats - исправлено
-- =====================================================
CREATE OR ALTER VIEW vw_AuthorFullStats
AS
WITH 
-- Детальная статистика по каждой статье автора
AuthorArticlesDetails AS (
    SELECT 
        a.Author AS IdUser,
        u.Name AS AuthorName,
        a.IdArticle,
        a.Title,
        a.Status,
        a.PublicationDate,
        ISNULL(a.CountViews, 0) AS CountViews,
        ISNULL(a.CountLikes, 0) AS CountLikes,
        ISNULL(a.CountFavs, 0) AS CountFavs,
        CASE 
            WHEN a.PublicationDate IS NOT NULL 
            THEN DATEDIFF(DAY, a.PublicationDate, GETDATE())
            ELSE NULL 
        END AS DaysPublished,
        COUNT(DISTINCT l.IdUser) AS UniqueLikers,
        COUNT(DISTINCT f.IdUser) AS UniqueFavoriters,
        CAST(NULL AS INT) AS TotalArticles,
        CAST(NULL AS INT) AS PublishedArticles,
        CAST(NULL AS INT) AS DraftArticles,
        CAST(NULL AS INT) AS TotalViews,
        CAST(NULL AS INT) AS TotalLikes,
        CAST(NULL AS INT) AS TotalFavs,
        CAST(NULL AS INT) AS AvgViewsPerArticle,
        CAST(NULL AS DATETIME) AS LastPublicationDate,
        'ArticleDetail' AS RecordType
    FROM Articles a
    INNER JOIN Users u ON a.Author = u.IdUser
    LEFT JOIN Likes l ON a.IdArticle = l.IdArticle
    LEFT JOIN Favs f ON a.IdArticle = f.IdArticle
    WHERE u.IsAuthor = 1
      AND u.IsDeleted = 0
    GROUP BY a.Author, u.Name, a.IdArticle, a.Title, a.Status, a.PublicationDate, a.CountViews, a.CountLikes, a.CountFavs
),

-- Сводная статистика автора по всем статьям
AuthorSummary AS (
    SELECT 
        a.Author AS IdUser,
        u.Name AS AuthorName,
        CAST(NULL AS INT) AS IdArticle,
        CAST(NULL AS NVARCHAR(200)) AS Title,
        CAST(NULL AS NVARCHAR(50)) AS Status,
        CAST(NULL AS DATETIME) AS PublicationDate,
        CAST(NULL AS INT) AS CountViews,
        CAST(NULL AS INT) AS CountLikes,
        CAST(NULL AS INT) AS CountFavs,
        CAST(NULL AS INT) AS DaysPublished,
        CAST(NULL AS INT) AS UniqueLikers,
        CAST(NULL AS INT) AS UniqueFavoriters,
        COUNT(a.IdArticle) AS TotalArticles,
        SUM(CASE WHEN a.Status = 'Published' THEN 1 ELSE 0 END) AS PublishedArticles,
        SUM(CASE WHEN a.Status = 'Draft' THEN 1 ELSE 0 END) AS DraftArticles,
        SUM(ISNULL(a.CountViews, 0)) AS TotalViews,
        SUM(ISNULL(a.CountLikes, 0)) AS TotalLikes,
        SUM(ISNULL(a.CountFavs, 0)) AS TotalFavs,
        AVG(ISNULL(a.CountViews, 0)) AS AvgViewsPerArticle,
        MAX(a.PublicationDate) AS LastPublicationDate,
        'AuthorSummary' AS RecordType
    FROM Articles a
    INNER JOIN Users u ON a.Author = u.IdUser
    WHERE u.IsAuthor = 1
      AND u.IsDeleted = 0
    GROUP BY a.Author, u.Name
)

-- Объединение детальной и сводной статистики
SELECT * FROM AuthorArticlesDetails
UNION ALL
SELECT * FROM AuthorSummary;
GO

-- =====================================================
-- 4. vw_AppAnalyticsStats - исправлено (добавлены явные преобразования типов)
-- =====================================================
CREATE OR ALTER VIEW vw_AppAnalyticsStats
AS
WITH 
-- Статистика по привычкам
HabitsStatsAggregated AS (
    SELECT 
        'Habits' AS StatsCategory,
        CAST(h.DateHabit AS DATE) AS StatsDate,
        CAST(NULL AS INT) AS StatsMonth,
        h.Status AS StatusValue,
        COUNT(*) AS RecordsCount,
        COUNT(DISTINCT h.IdTracker) AS DistinctTrackersCount,
        AVG(h.Value) AS AvgValue,
        CAST(NULL AS INT) AS AvgDaysToComplete,
        CAST(NULL AS INT) AS GoalsWithDeadline,
        CAST(NULL AS INT) AS OverdueGoals,
        CAST(NULL AS INT) AS GoalsCreatedCount,
        CAST(NULL AS INT) AS GoalsCompletedCount,
        CAST(NULL AS INT) AS NotesCount,
        CAST(NULL AS INT) AS UniqueUsers,
        CAST(NULL AS INT) AS TotalPhotosAttached,
        CAST(NULL AS DECIMAL(10,2)) AS AvgThemeUsage,
        CAST(NULL AS NVARCHAR(100)) AS ThemeTitle,
        CAST(NULL AS INT) AS ActualNotesCount,
        CAST(NULL AS INT) AS ThemeCountNotes
    FROM Habits h
    GROUP BY CAST(h.DateHabit AS DATE), h.Status
    
    UNION ALL
    
    SELECT 
        'HabitsTime' AS StatsCategory,
        CAST(NULL AS DATE) AS StatsDate,
        CAST(NULL AS INT) AS StatsMonth,
        CAST(h.TimeHabit AS NVARCHAR(50)) AS StatusValue,
        COUNT(*) AS RecordsCount,
        COUNT(DISTINCT h.IdTracker) AS DistinctTrackersCount,
        AVG(h.Value) AS AvgValue,
        CAST(NULL AS INT) AS AvgDaysToComplete,
        CAST(NULL AS INT) AS GoalsWithDeadline,
        CAST(NULL AS INT) AS OverdueGoals,
        CAST(NULL AS INT) AS GoalsCreatedCount,
        CAST(NULL AS INT) AS GoalsCompletedCount,
        CAST(NULL AS INT) AS NotesCount,
        CAST(NULL AS INT) AS UniqueUsers,
        CAST(NULL AS INT) AS TotalPhotosAttached,
        CAST(NULL AS DECIMAL(10,2)) AS AvgThemeUsage,
        CAST(NULL AS NVARCHAR(100)) AS ThemeTitle,
        CAST(NULL AS INT) AS ActualNotesCount,
        CAST(NULL AS INT) AS ThemeCountNotes
    FROM Habits h
    GROUP BY h.TimeHabit
),

-- Статистика по целям
GoalsStatsAggregated AS (
    SELECT 
        'GoalsByStatus' AS StatsCategory,
        CAST(NULL AS DATE) AS StatsDate,
        CAST(NULL AS INT) AS StatsMonth,
        g.Status AS StatusValue,
        COUNT(*) AS RecordsCount,
        CAST(NULL AS INT) AS DistinctTrackersCount,
        CAST(NULL AS DECIMAL(10,2)) AS AvgValue,
        AVG(DATEDIFF(DAY, g.DateCreated, ISNULL(g.DateCompleted, GETDATE()))) AS AvgDaysToComplete,
        COUNT(CASE WHEN g.Deadline IS NOT NULL THEN 1 END) AS GoalsWithDeadline,
        COUNT(CASE WHEN g.Deadline < GETDATE() AND g.Status IN ('Created', 'InProgress') THEN 1 END) AS OverdueGoals,
        CAST(NULL AS INT) AS GoalsCreatedCount,
        CAST(NULL AS INT) AS GoalsCompletedCount,
        CAST(NULL AS INT) AS NotesCount,
        CAST(NULL AS INT) AS UniqueUsers,
        CAST(NULL AS INT) AS TotalPhotosAttached,
        CAST(NULL AS DECIMAL(10,2)) AS AvgThemeUsage,
        CAST(NULL AS NVARCHAR(100)) AS ThemeTitle,
        CAST(NULL AS INT) AS ActualNotesCount,
        CAST(NULL AS INT) AS ThemeCountNotes
    FROM Goals g
    GROUP BY g.Status
    
    UNION ALL
    
    SELECT 
        'GoalsByDate' AS StatsCategory,
        CAST(g.DateCreated AS DATE) AS StatsDate,
        CAST(NULL AS INT) AS StatsMonth,
        CAST(NULL AS NVARCHAR(50)) AS StatusValue,
        COUNT(*) AS RecordsCount,
        CAST(NULL AS INT) AS DistinctTrackersCount,
        CAST(NULL AS DECIMAL(10,2)) AS AvgValue,
        CAST(NULL AS INT) AS AvgDaysToComplete,
        CAST(NULL AS INT) AS GoalsWithDeadline,
        CAST(NULL AS INT) AS OverdueGoals,
        COUNT(*) AS GoalsCreatedCount,
        COUNT(CASE WHEN g.Status = 'Completed' THEN 1 END) AS GoalsCompletedCount,
        CAST(NULL AS INT) AS NotesCount,
        CAST(NULL AS INT) AS UniqueUsers,
        CAST(NULL AS INT) AS TotalPhotosAttached,
        CAST(NULL AS DECIMAL(10,2)) AS AvgThemeUsage,
        CAST(NULL AS NVARCHAR(100)) AS ThemeTitle,
        CAST(NULL AS INT) AS ActualNotesCount,
        CAST(NULL AS INT) AS ThemeCountNotes
    FROM Goals g
    GROUP BY CAST(g.DateCreated AS DATE)
),

-- Статистика по заметкам
NotesStatsAggregated AS (
    SELECT 
        'NotesByDate' AS StatsCategory,
        n.Date AS StatsDate,
        CAST(NULL AS INT) AS StatsMonth,
        CAST(NULL AS NVARCHAR(50)) AS StatusValue,
        COUNT(*) AS RecordsCount,
        CAST(NULL AS INT) AS DistinctTrackersCount,
        CAST(NULL AS DECIMAL(10,2)) AS AvgValue,
        CAST(NULL AS INT) AS AvgDaysToComplete,
        CAST(NULL AS INT) AS GoalsWithDeadline,
        CAST(NULL AS INT) AS OverdueGoals,
        CAST(NULL AS INT) AS GoalsCreatedCount,
        CAST(NULL AS INT) AS GoalsCompletedCount,
        COUNT(*) AS NotesCount,
        COUNT(DISTINCT n.IdUser) AS UniqueUsers,
        COUNT(p.IdPhoto) AS TotalPhotosAttached,
        AVG(COALESCE(tn.CountNotes, 0)) AS AvgThemeUsage,
        CAST(NULL AS NVARCHAR(100)) AS ThemeTitle,
        CAST(NULL AS INT) AS ActualNotesCount,
        CAST(NULL AS INT) AS ThemeCountNotes
    FROM Notes n
    LEFT JOIN Photos p ON n.IdNote = p.IdNote
    LEFT JOIN ThemesForNotes tn ON n.IdThemeForNote = tn.IdThemeForNotes
    GROUP BY n.Date
    
    UNION ALL
    
    SELECT 
        'NotesByTheme' AS StatsCategory,
        CAST(NULL AS DATE) AS StatsDate,
        CAST(NULL AS INT) AS StatsMonth,
        CAST(NULL AS NVARCHAR(50)) AS StatusValue,
        CAST(NULL AS INT) AS RecordsCount,
        CAST(NULL AS INT) AS DistinctTrackersCount,
        CAST(NULL AS DECIMAL(10,2)) AS AvgValue,
        CAST(NULL AS INT) AS AvgDaysToComplete,
        CAST(NULL AS INT) AS GoalsWithDeadline,
        CAST(NULL AS INT) AS OverdueGoals,
        CAST(NULL AS INT) AS GoalsCreatedCount,
        CAST(NULL AS INT) AS GoalsCompletedCount,
        COUNT(n.IdNote) AS NotesCount,
        CAST(NULL AS INT) AS UniqueUsers,
        CAST(NULL AS INT) AS TotalPhotosAttached,
        CAST(NULL AS DECIMAL(10,2)) AS AvgThemeUsage,
        tn.Title AS ThemeTitle,
        COUNT(n.IdNote) AS ActualNotesCount,
        tn.CountNotes AS ThemeCountNotes
    FROM ThemesForNotes tn
    LEFT JOIN Notes n ON tn.IdThemeForNotes = n.IdThemeForNote
    GROUP BY tn.Title, tn.CountNotes
)

-- Объединение всей статистики
SELECT * FROM HabitsStatsAggregated
UNION ALL
SELECT * FROM GoalsStatsAggregated
UNION ALL
SELECT * FROM NotesStatsAggregated;
GO

-- =====================================================
-- 5. vw_UsersMonthlyStats - исправлено
-- =====================================================
CREATE OR ALTER VIEW vw_UsersMonthlyStats
AS
SELECT 
    YEAR(DateCreated) AS Year,
    MONTH(DateCreated) AS Month,
    COUNT(*) AS UsersJoined,
    SUM(CASE WHEN IsDeleted = 1 THEN 1 ELSE 0 END) AS UsersDeleted,
    COUNT(CASE WHEN IsAuthor = 1 THEN 1 END) AS AuthorsJoined
FROM Users
WHERE DateCreated >= DATEFROMPARTS(YEAR(GETDATE()), MONTH(GETDATE()), 1)
   OR (DateDeleted >= DATEFROMPARTS(YEAR(GETDATE()), MONTH(GETDATE()), 1) AND IsDeleted = 1)
GROUP BY YEAR(DateCreated), MONTH(DateCreated);
GO

-- =====================================================
-- 6. vw_UsersDailyStats - исправлено
-- =====================================================
CREATE OR ALTER VIEW vw_UsersDailyStats
AS
SELECT 
    CAST(DateCreated AS DATE) AS Date,
    COUNT(*) AS UsersJoinedCount,
    SUM(CASE WHEN IsDeleted = 1 THEN 1 ELSE 0 END) AS UsersDeletedCount,
    COUNT(CASE WHEN IsAuthor = 1 THEN 1 END) AS AuthorsJoinedCount
FROM Users
WHERE DateCreated >= DATEFROMPARTS(YEAR(GETDATE()), MONTH(GETDATE()), 1)
   OR (DateDeleted >= DATEFROMPARTS(YEAR(GETDATE()), MONTH(GETDATE()), 1) AND IsDeleted = 1)
GROUP BY CAST(DateCreated AS DATE);
GO