ALTER TABLE [Person].[Password]
    ADD CONSTRAINT [DF_Password_rowguid] DEFAULT (newid()) FOR [rowguid];

