ALTER TABLE [Production].[Document]
    ADD CONSTRAINT [DF_Document_ModifiedDate] DEFAULT (getdate()) FOR [ModifiedDate];

