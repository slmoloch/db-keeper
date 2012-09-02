ALTER TABLE [Sales].[SalesTerritoryHistory]
    ADD CONSTRAINT [DF_SalesTerritoryHistory_rowguid] DEFAULT (newid()) FOR [rowguid];

