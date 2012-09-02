ALTER TABLE [Sales].[SalesOrderHeader]
    ADD CONSTRAINT [DF_SalesOrderHeader_OnlineOrderFlag] DEFAULT ((1)) FOR [OnlineOrderFlag];

