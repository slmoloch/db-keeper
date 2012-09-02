ALTER TABLE [Production].[ProductCostHistory]
    ADD CONSTRAINT [CK_ProductCostHistory_EndDate] CHECK ([EndDate]>=[StartDate] OR [EndDate] IS NULL);

