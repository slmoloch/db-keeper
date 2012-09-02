ALTER TABLE [Sales].[SalesTaxRate]
    ADD CONSTRAINT [DF_SalesTaxRate_TaxRate] DEFAULT ((0.00)) FOR [TaxRate];

