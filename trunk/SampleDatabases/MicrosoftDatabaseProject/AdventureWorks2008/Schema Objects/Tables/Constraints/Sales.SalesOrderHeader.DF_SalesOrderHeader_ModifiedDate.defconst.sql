ALTER TABLE [Sales].[SalesOrderHeader]
    ADD CONSTRAINT [DF_SalesOrderHeader_ModifiedDate] DEFAULT (getdate()) FOR [ModifiedDate];

