ALTER TABLE [Sales].[SalesPerson]
    ADD CONSTRAINT [CK_SalesPerson_CommissionPct] CHECK ([CommissionPct]>=(0.00));

