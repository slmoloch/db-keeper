ALTER TABLE [Production].[ProductProductPhoto]
    ADD CONSTRAINT [DF_ProductProductPhoto_ModifiedDate] DEFAULT (getdate()) FOR [ModifiedDate];

