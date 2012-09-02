CREATE TABLE [Person].[PhoneNumberType] (
    [PhoneNumberTypeID] INT          IDENTITY (1, 1) NOT NULL,
    [Name]              [dbo].[Name] NOT NULL,
    [ModifiedDate]      DATETIME     NOT NULL
);

