ALTER TABLE [Purchasing].[PurchaseOrderHeader]
    ADD CONSTRAINT [DF_PurchaseOrderHeader_Freight] DEFAULT ((0.00)) FOR [Freight];

