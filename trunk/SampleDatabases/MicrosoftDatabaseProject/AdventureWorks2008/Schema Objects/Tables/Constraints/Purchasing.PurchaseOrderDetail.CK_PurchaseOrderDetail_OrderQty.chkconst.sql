ALTER TABLE [Purchasing].[PurchaseOrderDetail]
    ADD CONSTRAINT [CK_PurchaseOrderDetail_OrderQty] CHECK ([OrderQty]>(0));

