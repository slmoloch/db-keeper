ALTER TABLE [Production].[ProductModel]
    ADD CONSTRAINT [DF_ProductModel_rowguid] DEFAULT (newid()) FOR [rowguid];

