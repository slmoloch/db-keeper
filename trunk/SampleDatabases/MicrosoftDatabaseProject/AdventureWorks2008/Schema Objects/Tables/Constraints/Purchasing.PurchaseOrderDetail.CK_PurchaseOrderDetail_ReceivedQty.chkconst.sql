ALTER TABLE [Purchasing].[PurchaseOrderDetail]
    ADD CONSTRAINT [CK_PurchaseOrderDetail_ReceivedQty] CHECK ([ReceivedQty]>=(0.00));

