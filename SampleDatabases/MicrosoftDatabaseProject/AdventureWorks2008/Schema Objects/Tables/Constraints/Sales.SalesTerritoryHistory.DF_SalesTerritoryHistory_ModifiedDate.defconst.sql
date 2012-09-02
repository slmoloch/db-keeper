ALTER TABLE [Sales].[SalesTerritoryHistory]
    ADD CONSTRAINT [DF_SalesTerritoryHistory_ModifiedDate] DEFAULT (getdate()) FOR [ModifiedDate];

