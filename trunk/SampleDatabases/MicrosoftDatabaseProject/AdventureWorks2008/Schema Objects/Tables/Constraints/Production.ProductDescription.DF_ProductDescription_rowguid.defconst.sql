ALTER TABLE [Production].[ProductDescription]
    ADD CONSTRAINT [DF_ProductDescription_rowguid] DEFAULT (newid()) FOR [rowguid];

