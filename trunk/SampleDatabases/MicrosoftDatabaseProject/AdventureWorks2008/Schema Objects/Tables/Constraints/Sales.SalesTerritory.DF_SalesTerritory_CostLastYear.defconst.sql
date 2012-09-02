ALTER TABLE [Sales].[SalesTerritory]
    ADD CONSTRAINT [DF_SalesTerritory_CostLastYear] DEFAULT ((0.00)) FOR [CostLastYear];

