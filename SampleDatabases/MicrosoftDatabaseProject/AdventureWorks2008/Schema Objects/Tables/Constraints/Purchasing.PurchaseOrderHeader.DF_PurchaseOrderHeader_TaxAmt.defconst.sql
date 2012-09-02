ALTER TABLE [Purchasing].[PurchaseOrderHeader]
    ADD CONSTRAINT [DF_PurchaseOrderHeader_TaxAmt] DEFAULT ((0.00)) FOR [TaxAmt];

