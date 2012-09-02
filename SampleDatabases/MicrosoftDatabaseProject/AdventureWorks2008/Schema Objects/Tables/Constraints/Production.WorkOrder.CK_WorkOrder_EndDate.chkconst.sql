ALTER TABLE [Production].[WorkOrder]
    ADD CONSTRAINT [CK_WorkOrder_EndDate] CHECK ([EndDate]>=[StartDate] OR [EndDate] IS NULL);

