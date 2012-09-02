ALTER TABLE [Person].[StateProvince]
    ADD CONSTRAINT [DF_StateProvince_rowguid] DEFAULT (newid()) FOR [rowguid];

