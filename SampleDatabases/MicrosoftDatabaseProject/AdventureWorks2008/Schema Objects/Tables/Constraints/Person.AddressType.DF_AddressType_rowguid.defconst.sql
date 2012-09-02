ALTER TABLE [Person].[AddressType]
    ADD CONSTRAINT [DF_AddressType_rowguid] DEFAULT (newid()) FOR [rowguid];

