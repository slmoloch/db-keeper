ALTER TABLE [Sales].[SalesTerritory]
    ADD CONSTRAINT [DF_SalesTerritory_rowguid] DEFAULT (newid()) FOR [rowguid];

