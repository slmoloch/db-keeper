ALTER TABLE [Production].[Product]
    ADD CONSTRAINT [DF_Product_ModifiedDate] DEFAULT (getdate()) FOR [ModifiedDate];

