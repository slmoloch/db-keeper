ALTER TABLE [Production].[BillOfMaterials]
    ADD CONSTRAINT [DF_BillOfMaterials_ModifiedDate] DEFAULT (getdate()) FOR [ModifiedDate];

