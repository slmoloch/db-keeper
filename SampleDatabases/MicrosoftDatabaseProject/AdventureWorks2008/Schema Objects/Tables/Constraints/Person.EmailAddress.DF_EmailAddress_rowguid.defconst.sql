ALTER TABLE [Person].[EmailAddress]
    ADD CONSTRAINT [DF_EmailAddress_rowguid] DEFAULT (newid()) FOR [rowguid];

