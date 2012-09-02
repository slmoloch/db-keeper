ALTER TABLE [Purchasing].[PurchaseOrderHeader]
    ADD CONSTRAINT [DF_PurchaseOrderHeader_OrderDate] DEFAULT (getdate()) FOR [OrderDate];

