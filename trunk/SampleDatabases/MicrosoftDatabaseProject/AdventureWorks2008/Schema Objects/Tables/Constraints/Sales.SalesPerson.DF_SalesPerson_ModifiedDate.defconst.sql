ALTER TABLE [Sales].[SalesPerson]
    ADD CONSTRAINT [DF_SalesPerson_ModifiedDate] DEFAULT (getdate()) FOR [ModifiedDate];

