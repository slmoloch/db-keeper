ALTER TABLE [Production].[ProductCategory]
    ADD CONSTRAINT [DF_ProductCategory_rowguid] DEFAULT (newid()) FOR [rowguid];

