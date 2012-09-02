ALTER TABLE [Production].[Document]
    ADD CONSTRAINT [CK_Document_Status] CHECK ([Status]>=(1) AND [Status]<=(3));

