ALTER TABLE [Production].[BillOfMaterials]
    ADD CONSTRAINT [CK_BillOfMaterials_BOMLevel] CHECK ([ProductAssemblyID] IS NULL AND [BOMLevel]=(0) AND [PerAssemblyQty]=(1.00) OR [ProductAssemblyID] IS NOT NULL AND [BOMLevel]>=(1));

