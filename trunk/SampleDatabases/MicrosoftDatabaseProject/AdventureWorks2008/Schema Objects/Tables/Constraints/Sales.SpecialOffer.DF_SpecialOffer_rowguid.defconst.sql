ALTER TABLE [Sales].[SpecialOffer]
    ADD CONSTRAINT [DF_SpecialOffer_rowguid] DEFAULT (newid()) FOR [rowguid];

