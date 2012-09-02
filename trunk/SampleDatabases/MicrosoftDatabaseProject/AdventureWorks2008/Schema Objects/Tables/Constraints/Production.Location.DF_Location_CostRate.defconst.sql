ALTER TABLE [Production].[Location]
    ADD CONSTRAINT [DF_Location_CostRate] DEFAULT ((0.00)) FOR [CostRate];

