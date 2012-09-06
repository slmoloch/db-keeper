CREATE TABLE [Sales].[SalesReason] (
    [SalesReasonID] INT          IDENTITY (1, 1) NOT NULL,
    [Name]          NVARCHAR (50) NOT NULL,
    [ReasonType]    NVARCHAR (50) NOT NULL,
    [ModifiedDate]  DATETIME     NOT NULL
);

