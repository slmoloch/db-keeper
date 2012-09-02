ALTER TABLE [Sales].[SalesPersonQuotaHistory]
    ADD CONSTRAINT [DF_SalesPersonQuotaHistory_ModifiedDate] DEFAULT (getdate()) FOR [ModifiedDate];

