ALTER TABLE [Sales].[SalesTerritory]
    ADD CONSTRAINT [DF_SalesTerritory_ModifiedDate] DEFAULT (getdate()) FOR [ModifiedDate];

