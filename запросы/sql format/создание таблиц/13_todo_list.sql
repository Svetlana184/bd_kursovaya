CREATE TABLE TodoLists (
    IdTodoList INT IDENTITY(1,1) NOT NULL,
    IdUser INT NOT NULL,
    IdNote INT NULL,
    IdParentTodoList INT NULL,
    Title NVARCHAR(300) NOT NULL,
	Date DATETIME NOT NULL default getdate(),
    
    CONSTRAINT PK_TodoLists PRIMARY KEY NONCLUSTERED (IdTodoList),
    CONSTRAINT UX_TodoLists_User_Path UNIQUE CLUSTERED (IdUser),
    CONSTRAINT FK_TodoLists_User FOREIGN KEY (IdUser) REFERENCES Users(IdUser) ON DELETE CASCADE,
    CONSTRAINT FK_TodoLists_Parent FOREIGN KEY (IdParentTodoList) REFERENCES TodoLists(IdTodoList),
    CONSTRAINT UX_TodoLists_User_Title_Parent UNIQUE (IdUser, Title, IdParentTodoList)
);
GO
