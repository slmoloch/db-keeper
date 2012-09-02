ALTER TABLE [Sales].[SalesOrderDetail]
    ADD CONSTRAINT [CK_SalesOrderDetail_UnitPrice] CHECK ([UnitPrice]>=(0.00));

