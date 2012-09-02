ALTER TABLE [Purchasing].[PurchaseOrderHeader]
    ADD CONSTRAINT [DF_PurchaseOrderHeader_Status] DEFAULT ((1)) FOR [Status];

