﻿ALTER TABLE [Sales].[SalesTaxRate]
    ADD CONSTRAINT [CK_SalesTaxRate_TaxType] CHECK ([TaxType]>=(1) AND [TaxType]<=(3));

