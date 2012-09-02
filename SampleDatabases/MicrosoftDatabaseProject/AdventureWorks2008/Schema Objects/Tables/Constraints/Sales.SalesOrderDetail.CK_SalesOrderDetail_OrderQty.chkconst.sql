ALTER TABLE [Sales].[SalesOrderDetail]
    ADD CONSTRAINT [CK_SalesOrderDetail_OrderQty] CHECK ([OrderQty]>(0));

