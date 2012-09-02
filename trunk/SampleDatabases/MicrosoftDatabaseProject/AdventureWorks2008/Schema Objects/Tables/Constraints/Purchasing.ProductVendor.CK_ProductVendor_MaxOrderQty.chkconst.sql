ALTER TABLE [Purchasing].[ProductVendor]
    ADD CONSTRAINT [CK_ProductVendor_MaxOrderQty] CHECK ([MaxOrderQty]>=(1));

