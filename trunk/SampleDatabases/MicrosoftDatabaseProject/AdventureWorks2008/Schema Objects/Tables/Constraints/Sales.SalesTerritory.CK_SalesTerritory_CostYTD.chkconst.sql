ALTER TABLE [Sales].[SalesTerritory]
    ADD CONSTRAINT [CK_SalesTerritory_CostYTD] CHECK ([CostYTD]>=(0.00));

