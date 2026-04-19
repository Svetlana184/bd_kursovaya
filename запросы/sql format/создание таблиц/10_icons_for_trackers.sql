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