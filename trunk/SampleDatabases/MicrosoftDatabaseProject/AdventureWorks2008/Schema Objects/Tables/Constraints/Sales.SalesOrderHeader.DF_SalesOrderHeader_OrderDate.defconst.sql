ALTER TABLE [Sales].[SalesOrderHeader]
    ADD CONSTRAINT [DF_SalesOrderHeader_OrderDate] DEFAULT (getdate()) FOR [OrderDate];

