ALTER TABLE [Sales].[SalesPerson]
    ADD CONSTRAINT [DF_SalesPerson_rowguid] DEFAULT (newid()) FOR [rowguid];

