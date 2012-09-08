﻿ALTER TABLE [Production].[ProductListPriceHistory]
    ADD CONSTRAINT [PK_ProductListPriceHistory_ProductID_StartDate] PRIMARY KEY CLUSTERED ([ProductID] ASC, [StartDate] ASC) WITH (ALLOW_PAGE_LOCKS = ON, ALLOW_ROW_LOCKS = ON, PAD_INDEX = OFF, IGNORE_DUP_KEY = OFF, STATISTICS_NORECOMPUTE = OFF);
