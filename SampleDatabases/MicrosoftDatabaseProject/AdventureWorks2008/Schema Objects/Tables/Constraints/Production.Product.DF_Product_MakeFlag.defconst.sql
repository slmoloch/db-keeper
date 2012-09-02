ALTER TABLE [Production].[Product]
    ADD CONSTRAINT [DF_Product_MakeFlag] DEFAULT ((1)) FOR [MakeFlag];

