ALTER TABLE [Person].[Address]
    ADD CONSTRAINT [DF_Address_rowguid] DEFAULT (newid()) FOR [rowguid];

