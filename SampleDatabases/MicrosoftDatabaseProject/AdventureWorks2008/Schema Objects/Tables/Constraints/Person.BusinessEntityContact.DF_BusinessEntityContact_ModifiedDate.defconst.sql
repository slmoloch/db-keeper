ALTER TABLE [Person].[BusinessEntityContact]
    ADD CONSTRAINT [DF_BusinessEntityContact_ModifiedDate] DEFAULT (getdate()) FOR [ModifiedDate];

