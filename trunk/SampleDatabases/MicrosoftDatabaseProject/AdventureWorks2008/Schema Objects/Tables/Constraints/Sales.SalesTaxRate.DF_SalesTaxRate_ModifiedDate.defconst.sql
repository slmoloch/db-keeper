ALTER TABLE [Sales].[SalesTaxRate]
    ADD CONSTRAINT [DF_SalesTaxRate_ModifiedDate] DEFAULT (getdate()) FOR [ModifiedDate];

