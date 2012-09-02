ALTER TABLE [Production].[BillOfMaterials]
    ADD CONSTRAINT [DF_BillOfMaterials_PerAssemblyQty] DEFAULT ((1.00)) FOR [PerAssemblyQty];

