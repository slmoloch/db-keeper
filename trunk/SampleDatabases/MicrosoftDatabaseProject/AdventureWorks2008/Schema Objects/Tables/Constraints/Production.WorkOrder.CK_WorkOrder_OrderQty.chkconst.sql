ALTER TABLE [Production].[WorkOrder]
    ADD CONSTRAINT [CK_WorkOrder_OrderQty] CHECK ([OrderQty]>(0));

