ALTER TABLE [Person].[Password]
    ADD CONSTRAINT [DF_Password_ModifiedDate] DEFAULT (getdate()) FOR [ModifiedDate];

