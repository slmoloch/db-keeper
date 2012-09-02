ALTER TABLE [Sales].[SalesPerson]
    ADD CONSTRAINT [DF_SalesPerson_CommissionPct] DEFAULT ((0.00)) FOR [CommissionPct];

