ALTER TABLE [Purchasing].[ProductVendor]
    ADD CONSTRAINT [CK_ProductVendor_LastReceiptCost] CHECK ([LastReceiptCost]>(0.00));

