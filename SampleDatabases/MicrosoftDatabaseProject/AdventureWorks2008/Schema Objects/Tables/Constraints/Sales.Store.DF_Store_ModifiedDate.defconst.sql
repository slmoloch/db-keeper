﻿ALTER TABLE [Sales].[Store]
    ADD CONSTRAINT [DF_Store_ModifiedDate] DEFAULT (getdate()) FOR [ModifiedDate];

