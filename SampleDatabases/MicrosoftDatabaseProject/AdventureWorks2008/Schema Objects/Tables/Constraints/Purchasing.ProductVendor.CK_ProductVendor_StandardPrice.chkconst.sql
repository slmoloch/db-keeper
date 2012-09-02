ALTER TABLE [Purchasing].[ProductVendor]
    ADD CONSTRAINT [CK_ProductVendor_StandardPrice] CHECK ([StandardPrice]>(0.00));

