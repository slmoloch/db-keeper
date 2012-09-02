ALTER TABLE [Sales].[SpecialOfferProduct]
    ADD CONSTRAINT [DF_SpecialOfferProduct_rowguid] DEFAULT (newid()) FOR [rowguid];

