ALTER TABLE [Production].[ProductReview]
    ADD CONSTRAINT [CK_ProductReview_Rating] CHECK ([Rating]>=(1) AND [Rating]<=(5));

