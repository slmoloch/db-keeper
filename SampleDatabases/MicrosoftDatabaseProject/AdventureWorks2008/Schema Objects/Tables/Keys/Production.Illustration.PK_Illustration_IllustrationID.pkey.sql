﻿ALTER TABLE [Production].[Illustration]
    ADD CONSTRAINT [PK_Illustration_IllustrationID] PRIMARY KEY CLUSTERED ([IllustrationID] ASC) WITH (ALLOW_PAGE_LOCKS = ON, ALLOW_ROW_LOCKS = ON, PAD_INDEX = OFF, IGNORE_DUP_KEY = OFF, STATISTICS_NORECOMPUTE = OFF);

