ALTER TABLE [Sales].[SalesOrderHeader]
    ADD CONSTRAINT [CK_SalesOrderHeader_Status] CHECK ([Status]>=(0) AND [Status]<=(8));

