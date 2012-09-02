ALTER TABLE [Sales].[SalesTerritory]
    ADD CONSTRAINT [DF_SalesTerritory_CostYTD] DEFAULT ((0.00)) FOR [CostYTD];

