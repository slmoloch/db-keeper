ALTER TABLE [Production].[ProductModel]
    ADD CONSTRAINT [DF_ProductModel_ModifiedDate] DEFAULT (getdate()) FOR [ModifiedDate];

