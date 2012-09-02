ALTER TABLE [Sales].[SalesTerritoryHistory]
    ADD CONSTRAINT [CK_SalesTerritoryHistory_EndDate] CHECK ([EndDate]>=[StartDate] OR [EndDate] IS NULL);

