ALTER TABLE [Sales].[SalesOrderHeader]
    ADD CONSTRAINT [DF_SalesOrderHeader_SubTotal] DEFAULT ((0.00)) FOR [SubTotal];

