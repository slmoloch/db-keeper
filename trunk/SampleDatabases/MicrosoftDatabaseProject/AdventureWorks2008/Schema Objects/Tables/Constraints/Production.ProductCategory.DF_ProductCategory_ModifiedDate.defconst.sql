ALTER TABLE [Production].[ProductCategory]
    ADD CONSTRAINT [DF_ProductCategory_ModifiedDate] DEFAULT (getdate()) FOR [ModifiedDate];

