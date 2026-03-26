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