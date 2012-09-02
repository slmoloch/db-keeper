ALTER TABLE [Purchasing].[PurchaseOrderHeader]
    ADD CONSTRAINT [DF_PurchaseOrderHeader_RevisionNumber] DEFAULT ((0)) FOR [RevisionNumber];

