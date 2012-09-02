ALTER TABLE [Person].[Person]
    ADD CONSTRAINT [DF_Person_rowguid] DEFAULT (newid()) FOR [rowguid];

