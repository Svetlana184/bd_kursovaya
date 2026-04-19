INSERT INTO Users (Name, Email, Phone, PasswordHash, IsAuthor, Birthday, Language, LastLoginAt, DateCreated, DateUpdated, DateDeleted, IsDeleted)
VALUES
('Анна Петрова', 'anna@example.com', '+79001234567', 'hash_anna123', 1, '1990-05-15', 'ru', GETDATE(), GETDATE(), NULL, NULL, 0),
('Иван Сидоров', 'ivan@example.com', '+79007654321', 'hash_ivan456', 0, '1985-12-20', 'ru', GETDATE(), GETDATE(), NULL, NULL, 0),
('Мария Иванова', 'maria@example.com', NULL, 'hash_maria789', 1, '1995-03-10', 'en', GETDATE(), GETDATE(), NULL, NULL, 0),
('Ольга Смирнова', 'olga@example.com', '+79009998877', 'hash_olga999', 0, '2000-07-22', 'ru', NULL, GETDATE(), NULL, NULL, 0),
('Алексей Козлов', 'alex@example.com', '+79001112233', 'hash_alex111', 1, '1988-11-30', 'en', GETDATE(), GETDATE(), NULL, NULL, 0);

INSERT INTO ThemesForArticles (Title, IdParentTheme, IsActive)
VALUES
('Здоровье', NULL, 1),
('Психология', NULL, 1),
('Продуктивность', NULL, 1),
('Спорт', 1, 1),
('Медитация', 2, 1);


INSERT INTO Articles (Title, Description, PublicationDate, UpdateDate, Status, Text, Author, CountLikes, CountFavs, CountViews)
VALUES
('Как начать медитировать', 'Простые шаги для начинающих', GETDATE(), NULL, 'Published', 'Текст статьи о медитации...', 1, 5, 2, 120),
('Польза утренней зарядки', 'Зарядка и продуктивность', GETDATE(), NULL, 'Published', 'Текст о зарядке...', 3, 3, 1, 95),
('Тайм-менеджмент для занятых', 'Как всё успевать', GETDATE(), NULL, 'Draft', 'Текст о тайм-менеджменте...', 5, 0, 0, 0),
('Как справиться со стрессом', 'Советы психолога', GETDATE(), NULL, 'Published', 'Текст о стрессе...', 1, 8, 5, 210),
('Правильное питание', 'Основы здорового рациона', GETDATE(), GETDATE(), 'Archived', 'Текст о питании...', 3, 2, 0, 45);


INSERT INTO TagArticles (IdArticle, IdThemeForArticles)
VALUES
(1, 2),  -- Медитация → Психология
(1, 5),  -- Медитация → Медитация
(2, 1),  -- Зарядка → Здоровье
(2, 4),  -- Зарядка → Спорт
(3, 3),  -- Тайм-менеджмент → Продуктивность
(4, 2),  -- Стресс → Психология
(5, 1);  -- Питание → Здоровье


INSERT INTO Likes (IdArticle, IdUser, Date)
VALUES
(1, 2, GETDATE()),
(1, 4, GETDATE()),
(2, 1, GETDATE()),
(4, 2, GETDATE()),
(4, 5, GETDATE());

INSERT INTO Favs (IdArticle, IdUser, Date)
VALUES
(1, 2, GETDATE()),
(4, 1, GETDATE()),
(4, 5, GETDATE());


INSERT INTO Icons (Title, Resource, Color, Category, Type)
VALUES
('Спорт', '/icons/sport.svg', '#FF5733', 'activity', 'habit'),
('Вода', '/icons/water.svg', '#33A1FF', 'health', 'habit'),
('Медитация', '/icons/meditation.svg', '#33FF57', 'mindfulness', 'habit'),
('Сон', '/icons/sleep.svg', '#A133FF', 'health', 'habit'),
('Прогулка', '/icons/walk.svg', '#FFA500', 'activity', 'habit');

INSERT INTO Trackers (IdUser, Title, Description, DateCreated, DateUpdated, Color, IsActive, UnitsOfMeasurement, ReferenceValue)
VALUES
(1, 'Пить воду', 'Ежедневное потребление воды', GETDATE(), NULL, '#33A1FF', 1, 'литры', 2.5),
(1, 'Утренняя зарядка', 'Зарядка по утрам', GETDATE(), NULL, '#FF5733', 1, 'минуты', 15),
(2, 'Медитация', 'Практика осознанности', GETDATE(), NULL, '#33FF57', 1, 'минуты', 10),
(3, 'Прогулка', 'Ежедневная прогулка', GETDATE(), NULL, '#FFA500', 1, 'шаги', 8000),
(4, 'Сон', 'Отслеживание сна', GETDATE(), NULL, '#A133FF', 1, 'часы', 8);


INSERT INTO IconsForTracker (IdTracker, IdIcon)
VALUES
(1, 2),  -- Вода → Вода
(2, 1),  -- Зарядка → Спорт
(3, 3),  -- Медитация → Медитация
(4, 5),  -- Прогулка → Прогулка
(5, 4);  -- Сон → Сон


INSERT INTO Habits (IdTracker, DateHabit, TimeHabit, Status, Value)
VALUES
(1, '2025-03-20', '12:00:00', 'Good', 2.2),
(1, '2025-03-21', '11:30:00', 'Excellent', 2.7),
(2, '2025-03-20', '08:00:00', 'Normal', 12),
(2, '2025-03-21', '07:45:00', 'Good', 15),
(3, '2025-03-20', '20:00:00', 'Good', 10),
(4, '2025-03-21', '18:00:00', 'A little', 5000);


INSERT INTO Goals (IdUser, Title, Description, Deadline, Status, DateCreated, DateCompleted, PeriodicityValue, PeriodicityUnit)
VALUES
(1, 'Выучить английский', 'Уровень B2', '2025-12-31', 'InProgress', GETDATE(), NULL, NULL, NULL),
(1, 'Пить больше воды', 'Ежедневно 2.5 литра', NULL, 'InProgress', GETDATE(), NULL, 1, 'days'),
(2, 'Пробежать марафон', '42 км', '2025-09-01', 'Created', GETDATE(), NULL, NULL, NULL),
(3, 'Медитировать ежедневно', '10 минут в день', NULL, 'InProgress', GETDATE(), NULL, 1, 'days'),
(5, 'Написать книгу', 'Завершить рукопись', '2025-12-01', 'Frozen', GETDATE(), NULL, NULL, NULL);


INSERT INTO TodoLists (IdUser, IdNote, IdParentTodoList, Title, Date)
VALUES
(1, NULL, NULL, 'Рабочие задачи', GETDATE()),
(1, NULL, NULL, 'Личные задачи', GETDATE()),
(2, NULL, 1, 'Отчёты', GETDATE()),
(3, NULL, NULL, 'Здоровье', GETDATE()),
(5, NULL, 2, 'Покупки', GETDATE());


INSERT INTO Tasks (IdTodoList, IdGoal, Text, Status)
VALUES
(1, 1, 'Посмотреть урок английского', 'InProgress'),
(1, NULL, 'Подготовить презентацию', 'Created'),
(2, 2, 'Выпить 2 литра воды', 'Completed'),
(3, NULL, 'Сделать отчёт за март', 'Created'),
(4, 4, 'Помедитировать 10 минут', 'InProgress');


INSERT INTO Notifications (IdUser, Text, Time, PeriodicityValue, PeriodicityUnit, IdGoal, IdTask, Type)
VALUES
(1, 'Выпить стакан воды', '10:00:00', 1, 'hours', 2, NULL, 'habit'),
(1, 'Урок английского', '19:00:00', 1, 'days', 1, NULL, 'goal'),
(2, 'Тренировка', '08:00:00', NULL, NULL, NULL, NULL, 'custom'),
(3, 'Медитация', '21:00:00', 1, 'days', 4, NULL, 'goal'),
(5, 'Проверить задачи', '09:00:00', 1, 'days', NULL, 5, 'task');


INSERT INTO Notes (IdUser, Date, Text, IdThemeForNote)
VALUES
(1, '2025-03-20', 'Сегодня хороший день, много успел', NULL),
(1, '2025-03-21', 'Устал, но цели достигнуты', NULL),
(2, '2025-03-20', 'Нужно больше отдыхать', NULL),
(3, '2025-03-19', 'Медитация помогает сосредоточиться', NULL),
(5, '2025-03-21', 'План на неделю составлен', NULL);


INSERT INTO Photos (IdNote, Resource)
VALUES
(1, '/uploads/photo1.jpg'),
(1, '/uploads/photo2.jpg'),
(3, '/uploads/photo3.jpg'),
(4, '/uploads/meditation.jpg'),
(5, '/uploads/plan.jpg');

INSERT INTO Templates (Text)
VALUES
('Сегодня я благодарен за...'),
('Что я сделал для своего здоровья: ...'),
('Мои цели на завтра: ...'),
('Эмоции дня: ...'),
('Итоги недели: ...');

INSERT INTO TemplatesForNotes (IdTemplate, IdNote)
VALUES
(1, 1),
(2, 2),
(3, 5),
(4, 3),
(5, 4);


INSERT INTO ThemesForNotes (CountNotes, Title)
VALUES
(5, 'Личный дневник'),
(3, 'Здоровье'),
(2, 'Работа'),
(4, 'Эмоции'),
(1, 'Планирование');




