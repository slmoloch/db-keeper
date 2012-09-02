ALTER TABLE [Person].[BusinessEntityAddress]
    ADD CONSTRAINT [DF_BusinessEntityAddress_ModifiedDate] DEFAULT (getdate()) FOR [ModifiedDate];

