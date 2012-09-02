ALTER TABLE [Sales].[SalesTerritory]
    ADD CONSTRAINT [DF_SalesTerritory_SalesYTD] DEFAULT ((0.00)) FOR [SalesYTD];

