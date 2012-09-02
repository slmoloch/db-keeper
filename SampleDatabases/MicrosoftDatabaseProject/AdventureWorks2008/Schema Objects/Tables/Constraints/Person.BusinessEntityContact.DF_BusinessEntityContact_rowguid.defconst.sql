ALTER TABLE [Person].[BusinessEntityContact]
    ADD CONSTRAINT [DF_BusinessEntityContact_rowguid] DEFAULT (newid()) FOR [rowguid];

