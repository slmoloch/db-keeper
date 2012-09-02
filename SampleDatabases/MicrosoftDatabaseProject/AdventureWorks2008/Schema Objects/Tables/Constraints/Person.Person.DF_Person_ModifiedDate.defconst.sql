ALTER TABLE [Person].[Person]
    ADD CONSTRAINT [DF_Person_ModifiedDate] DEFAULT (getdate()) FOR [ModifiedDate];

