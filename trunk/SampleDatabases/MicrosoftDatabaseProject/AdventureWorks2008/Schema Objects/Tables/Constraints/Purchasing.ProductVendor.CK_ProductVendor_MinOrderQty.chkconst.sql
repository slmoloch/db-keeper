ALTER TABLE [Purchasing].[ProductVendor]
    ADD CONSTRAINT [CK_ProductVendor_MinOrderQty] CHECK ([MinOrderQty]>=(1));

