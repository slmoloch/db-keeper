ALTER TABLE [Production].[ProductSubcategory]
    ADD CONSTRAINT [DF_ProductSubcategory_ModifiedDate] DEFAULT (getdate()) FOR [ModifiedDate];

