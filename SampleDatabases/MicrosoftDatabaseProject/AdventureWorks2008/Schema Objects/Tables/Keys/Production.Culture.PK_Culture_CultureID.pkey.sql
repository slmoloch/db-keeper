﻿ALTER TABLE [Production].[Culture]
    ADD CONSTRAINT [PK_Culture_CultureID] PRIMARY KEY CLUSTERED ([CultureID] ASC) WITH (ALLOW_PAGE_LOCKS = ON, ALLOW_ROW_LOCKS = ON, PAD_INDEX = OFF, IGNORE_DUP_KEY = OFF, STATISTICS_NORECOMPUTE = OFF);
