ALTER TABLE [Production].[Document]
    ADD CONSTRAINT [DF_Document_rowguid] DEFAULT (newid()) FOR [rowguid];

