CREATE TABLE [Person].[ContactType] (
    [ContactTypeID] INT          IDENTITY (1, 1) NOT NULL,
    [Name]          [dbo].[Name] NOT NULL,
    [ModifiedDate]  DATETIME     NOT NULL
);

