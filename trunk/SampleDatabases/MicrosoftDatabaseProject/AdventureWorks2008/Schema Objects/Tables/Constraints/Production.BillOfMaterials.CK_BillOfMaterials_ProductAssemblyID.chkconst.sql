ALTER TABLE [Production].[BillOfMaterials]
    ADD CONSTRAINT [CK_BillOfMaterials_ProductAssemblyID] CHECK ([ProductAssemblyID]<>[ComponentID]);

