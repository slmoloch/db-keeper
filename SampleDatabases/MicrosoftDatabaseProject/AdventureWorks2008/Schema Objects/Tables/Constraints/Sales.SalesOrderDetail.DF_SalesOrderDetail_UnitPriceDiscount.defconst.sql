ALTER TABLE [Sales].[SalesOrderDetail]
    ADD CONSTRAINT [DF_SalesOrderDetail_UnitPriceDiscount] DEFAULT ((0.0)) FOR [UnitPriceDiscount];

