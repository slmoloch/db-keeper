ALTER TABLE [Person].[StateProvince]
    ADD CONSTRAINT [DF_StateProvince_ModifiedDate] DEFAULT (getdate()) FOR [ModifiedDate];

