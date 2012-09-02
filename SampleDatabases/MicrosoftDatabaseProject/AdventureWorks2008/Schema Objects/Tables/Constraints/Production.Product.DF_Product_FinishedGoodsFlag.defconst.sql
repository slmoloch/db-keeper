ALTER TABLE [Production].[Product]
    ADD CONSTRAINT [DF_Product_FinishedGoodsFlag] DEFAULT ((1)) FOR [FinishedGoodsFlag];

