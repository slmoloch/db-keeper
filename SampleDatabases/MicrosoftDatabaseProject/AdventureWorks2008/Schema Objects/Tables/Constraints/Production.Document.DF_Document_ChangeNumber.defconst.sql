ALTER TABLE [Production].[Document]
    ADD CONSTRAINT [DF_Document_ChangeNumber] DEFAULT ((0)) FOR [ChangeNumber];

