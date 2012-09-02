CREATE TABLE [Person].[Person] (
    [BusinessEntityID]      INT                                                           NOT NULL,
    [PersonType]            NCHAR (2)                                                     NOT NULL,
    [NameStyle]             [dbo].[NameStyle]                                             NOT NULL,
    [Title]                 NVARCHAR (8)                                                  NULL,
    [FirstName]             [dbo].[Name]                                                  NOT NULL,
    [MiddleName]            [dbo].[Name]                                                  NULL,
    [LastName]              [dbo].[Name]                                                  NOT NULL,
    [Suffix]                NVARCHAR (10)                                                 NULL,
    [EmailPromotion]        INT                                                           NOT NULL,
    [AdditionalContactInfo] XML(CONTENT [Person].[AdditionalContactInfoSchemaCollection]) NULL,
    [Demographics]          XML(CONTENT [Person].[IndividualSurveySchemaCollection])      NULL,
    [rowguid]               UNIQUEIDENTIFIER                                              ROWGUIDCOL NOT NULL,
    [ModifiedDate]          DATETIME                                                      NOT NULL
);

