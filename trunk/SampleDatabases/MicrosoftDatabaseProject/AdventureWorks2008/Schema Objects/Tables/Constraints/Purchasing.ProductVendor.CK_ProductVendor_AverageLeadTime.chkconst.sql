ALTER TABLE [Purchasing].[ProductVendor]
    ADD CONSTRAINT [CK_ProductVendor_AverageLeadTime] CHECK ([AverageLeadTime]>=(1));

