ALTER TABLE [Sales].[SalesPerson]
    ADD CONSTRAINT [DF_SalesPerson_Bonus] DEFAULT ((0.00)) FOR [Bonus];

