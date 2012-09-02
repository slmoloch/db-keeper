ALTER TABLE [Sales].[SalesOrderDetail]
    ADD CONSTRAINT [CK_SalesOrderDetail_UnitPriceDiscount] CHECK ([UnitPriceDiscount]>=(0.00));

