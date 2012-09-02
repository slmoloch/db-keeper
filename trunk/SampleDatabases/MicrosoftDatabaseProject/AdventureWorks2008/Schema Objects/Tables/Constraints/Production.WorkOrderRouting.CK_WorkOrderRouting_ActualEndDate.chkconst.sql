ALTER TABLE [Production].[WorkOrderRouting]
    ADD CONSTRAINT [CK_WorkOrderRouting_ActualEndDate] CHECK ([ActualEndDate]>=[ActualStartDate] OR [ActualEndDate] IS NULL OR [ActualStartDate] IS NULL);

