ALTER TABLE [Purchasing].[PurchaseOrderHeader]
    ADD CONSTRAINT [DF_PurchaseOrderHeader_ModifiedDate] DEFAULT (getdate()) FOR [ModifiedDate];

