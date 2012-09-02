ALTER TABLE [Production].[BillOfMaterials]
    ADD CONSTRAINT [DF_BillOfMaterials_StartDate] DEFAULT (getdate()) FOR [StartDate];

