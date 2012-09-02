ALTER TABLE [Person].[EmailAddress]
    ADD CONSTRAINT [DF_EmailAddress_ModifiedDate] DEFAULT (getdate()) FOR [ModifiedDate];

