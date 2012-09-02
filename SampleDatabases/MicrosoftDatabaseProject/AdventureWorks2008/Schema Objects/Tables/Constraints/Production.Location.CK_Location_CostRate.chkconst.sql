ALTER TABLE [Production].[Location]
    ADD CONSTRAINT [CK_Location_CostRate] CHECK ([CostRate]>=(0.00));

