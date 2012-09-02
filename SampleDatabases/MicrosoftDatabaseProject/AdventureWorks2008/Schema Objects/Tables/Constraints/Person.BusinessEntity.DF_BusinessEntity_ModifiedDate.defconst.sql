ALTER TABLE [Person].[BusinessEntity]
    ADD CONSTRAINT [DF_BusinessEntity_ModifiedDate] DEFAULT (getdate()) FOR [ModifiedDate];

