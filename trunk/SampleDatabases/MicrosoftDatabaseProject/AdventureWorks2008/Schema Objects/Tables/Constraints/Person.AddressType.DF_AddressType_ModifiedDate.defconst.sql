﻿ALTER TABLE [Person].[AddressType]
    ADD CONSTRAINT [DF_AddressType_ModifiedDate] DEFAULT (getdate()) FOR [ModifiedDate];

