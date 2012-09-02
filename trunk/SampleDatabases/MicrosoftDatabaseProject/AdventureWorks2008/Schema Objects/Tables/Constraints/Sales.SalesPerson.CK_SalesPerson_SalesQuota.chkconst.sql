ALTER TABLE [Sales].[SalesPerson]
    ADD CONSTRAINT [CK_SalesPerson_SalesQuota] CHECK ([SalesQuota]>(0.00));

