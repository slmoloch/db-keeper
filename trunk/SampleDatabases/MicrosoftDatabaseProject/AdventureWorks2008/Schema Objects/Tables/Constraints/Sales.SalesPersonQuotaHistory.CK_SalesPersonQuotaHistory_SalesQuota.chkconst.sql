ALTER TABLE [Sales].[SalesPersonQuotaHistory]
    ADD CONSTRAINT [CK_SalesPersonQuotaHistory_SalesQuota] CHECK ([SalesQuota]>(0.00));

