ALTER TABLE [Sales].[SalesTerritory]
    ADD CONSTRAINT [CK_SalesTerritory_SalesLastYear] CHECK ([SalesLastYear]>=(0.00));

