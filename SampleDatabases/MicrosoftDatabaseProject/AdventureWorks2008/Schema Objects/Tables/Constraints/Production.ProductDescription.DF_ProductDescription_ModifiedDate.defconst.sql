ALTER TABLE [Production].[ProductDescription]
    ADD CONSTRAINT [DF_ProductDescription_ModifiedDate] DEFAULT (getdate()) FOR [ModifiedDate];

