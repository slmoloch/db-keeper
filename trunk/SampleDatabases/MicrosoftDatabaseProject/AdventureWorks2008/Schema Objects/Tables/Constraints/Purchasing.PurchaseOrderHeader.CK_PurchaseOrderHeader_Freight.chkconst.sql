ALTER TABLE [Purchasing].[PurchaseOrderHeader]
    ADD CONSTRAINT [CK_PurchaseOrderHeader_Freight] CHECK ([Freight]>=(0.00));

