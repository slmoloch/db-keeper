ALTER TABLE [Person].[BusinessEntityAddress]
    ADD CONSTRAINT [DF_BusinessEntityAddress_rowguid] DEFAULT (newid()) FOR [rowguid];

