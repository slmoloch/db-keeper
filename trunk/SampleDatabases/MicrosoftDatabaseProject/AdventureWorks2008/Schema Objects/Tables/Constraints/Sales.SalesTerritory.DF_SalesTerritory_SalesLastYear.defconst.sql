ALTER TABLE [Sales].[SalesTerritory]
    ADD CONSTRAINT [DF_SalesTerritory_SalesLastYear] DEFAULT ((0.00)) FOR [SalesLastYear];

