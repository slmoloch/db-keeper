ALTER TABLE [Sales].[SalesOrderHeader]
    ADD CONSTRAINT [CK_SalesOrderHeader_Freight] CHECK ([Freight]>=(0.00));

