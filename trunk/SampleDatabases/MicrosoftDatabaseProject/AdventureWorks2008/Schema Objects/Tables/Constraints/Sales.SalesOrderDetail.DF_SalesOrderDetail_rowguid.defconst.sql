ALTER TABLE [Sales].[SalesOrderDetail]
    ADD CONSTRAINT [DF_SalesOrderDetail_rowguid] DEFAULT (newid()) FOR [rowguid];

