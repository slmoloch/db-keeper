ALTER TABLE [Sales].[SalesOrderHeader]
    ADD CONSTRAINT [CK_SalesOrderHeader_TaxAmt] CHECK ([TaxAmt]>=(0.00));

