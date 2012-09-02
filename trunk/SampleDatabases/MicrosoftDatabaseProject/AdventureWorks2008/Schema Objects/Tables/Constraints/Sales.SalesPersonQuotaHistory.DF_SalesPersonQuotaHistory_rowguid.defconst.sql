ALTER TABLE [Sales].[SalesPersonQuotaHistory]
    ADD CONSTRAINT [DF_SalesPersonQuotaHistory_rowguid] DEFAULT (newid()) FOR [rowguid];

