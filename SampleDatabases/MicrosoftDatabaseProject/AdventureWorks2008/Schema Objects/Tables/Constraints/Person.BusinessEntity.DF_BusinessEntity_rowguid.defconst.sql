ALTER TABLE [Person].[BusinessEntity]
    ADD CONSTRAINT [DF_BusinessEntity_rowguid] DEFAULT (newid()) FOR [rowguid];

