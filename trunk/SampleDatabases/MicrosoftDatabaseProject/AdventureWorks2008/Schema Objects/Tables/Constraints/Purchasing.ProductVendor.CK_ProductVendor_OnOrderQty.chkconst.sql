ALTER TABLE [Purchasing].[ProductVendor]
    ADD CONSTRAINT [CK_ProductVendor_OnOrderQty] CHECK ([OnOrderQty]>=(0));

