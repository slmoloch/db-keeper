ALTER TABLE [Production].[ProductReview]
    ADD CONSTRAINT [DF_ProductReview_ModifiedDate] DEFAULT (getdate()) FOR [ModifiedDate];

