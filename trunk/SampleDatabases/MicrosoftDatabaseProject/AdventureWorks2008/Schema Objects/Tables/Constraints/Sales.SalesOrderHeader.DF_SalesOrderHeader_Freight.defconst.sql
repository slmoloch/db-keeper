ALTER TABLE [Sales].[SalesOrderHeader]
    ADD CONSTRAINT [DF_SalesOrderHeader_Freight] DEFAULT ((0.00)) FOR [Freight];

