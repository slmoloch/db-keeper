ALTER TABLE [Sales].[SalesOrderDetail]
    ADD CONSTRAINT [DF_SalesOrderDetail_ModifiedDate] DEFAULT (getdate()) FOR [ModifiedDate];

