﻿ALTER TABLE [Sales].[PersonCreditCard]
    ADD CONSTRAINT [PK_PersonCreditCard_BusinessEntityID_CreditCardID] PRIMARY KEY CLUSTERED ([BusinessEntityID] ASC, [CreditCardID] ASC) WITH (ALLOW_PAGE_LOCKS = ON, ALLOW_ROW_LOCKS = ON, PAD_INDEX = OFF, IGNORE_DUP_KEY = OFF, STATISTICS_NORECOMPUTE = OFF);

