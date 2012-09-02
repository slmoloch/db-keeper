ALTER TABLE [Purchasing].[PurchaseOrderDetail]
    ADD CONSTRAINT [CK_PurchaseOrderDetail_UnitPrice] CHECK ([UnitPrice]>=(0.00));

