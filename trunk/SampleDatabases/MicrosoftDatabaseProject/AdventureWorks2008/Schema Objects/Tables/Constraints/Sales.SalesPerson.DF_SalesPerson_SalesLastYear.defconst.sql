ALTER TABLE [Sales].[SalesPerson]
    ADD CONSTRAINT [DF_SalesPerson_SalesLastYear] DEFAULT ((0.00)) FOR [SalesLastYear];

