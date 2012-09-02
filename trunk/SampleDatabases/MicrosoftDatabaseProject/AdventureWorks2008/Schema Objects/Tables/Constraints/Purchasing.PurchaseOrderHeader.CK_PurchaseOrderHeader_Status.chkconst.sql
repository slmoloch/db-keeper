ALTER TABLE [Purchasing].[PurchaseOrderHeader]
    ADD CONSTRAINT [CK_PurchaseOrderHeader_Status] CHECK ([Status]>=(1) AND [Status]<=(4));

