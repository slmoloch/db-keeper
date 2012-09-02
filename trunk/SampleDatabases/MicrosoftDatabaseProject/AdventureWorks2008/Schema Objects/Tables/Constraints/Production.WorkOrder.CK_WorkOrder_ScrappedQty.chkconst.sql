ALTER TABLE [Production].[WorkOrder]
    ADD CONSTRAINT [CK_WorkOrder_ScrappedQty] CHECK ([ScrappedQty]>=(0));

