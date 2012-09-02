ALTER TABLE [Purchasing].[PurchaseOrderHeader]
    ADD CONSTRAINT [DF_PurchaseOrderHeader_SubTotal] DEFAULT ((0.00)) FOR [SubTotal];

