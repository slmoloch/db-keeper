ALTER TABLE [Sales].[SalesPerson]
    ADD CONSTRAINT [DF_SalesPerson_SalesYTD] DEFAULT ((0.00)) FOR [SalesYTD];

