CREATE TABLE Tasks (
    IdTask INT IDENTITY(1,1) NOT NULL,
    IdTodoList INT NOT NULL,
    IdGoal INT NULL,
    Text NVARCHAR(MAX) NOT NULL,
    Status NVARCHAR(50) NOT NULL,
    
    CONSTRAINT PK_Tasks PRIMARY KEY NONCLUSTERED (IdTask),
    -- CONSTRAINT UX_Tasks_List_Text удален из определения таблицы
    CONSTRAINT FK_Tasks_TodoList FOREIGN KEY (IdTodoList) 
        REFERENCES TodoLists(IdTodoList) ON DELETE CASCADE,
    CONSTRAINT FK_Tasks_Goal FOREIGN KEY (IdGoal) REFERENCES Goals(IdGoal) ON DELETE NO ACTION,
    CONSTRAINT CK_Tasks_Status CHECK (Status IN ('Created', 'InProgress', 'Completed', 'Failed', 'Frozen'))
);
GO

-- Фильтруемый уникальный индекс создается отдельно
CREATE UNIQUE NONCLUSTERED INDEX UX_Tasks_List_Text_Active 
ON Tasks(IdTodoList) 
WHERE Status != 'Completed';
GO

-- Индексы для Tasks
CREATE NONCLUSTERED INDEX IX_Tasks_Status_Uncompleted ON Tasks(Status) 
    WHERE Status IN ('Created', 'InProgress');
GO

CREATE NONCLUSTERED INDEX IX_Tasks_Status_Completed ON Tasks(Status) 
    WHERE Status IN ('Completed', 'Failed');
GO