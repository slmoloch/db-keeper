ALTER TABLE [Sales].[SalesTaxRate]
    ADD CONSTRAINT [DF_SalesTaxRate_rowguid] DEFAULT (newid()) FOR [rowguid];

