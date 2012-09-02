CREATE TABLE [Production].[ProductPhoto] (
    [ProductPhotoID]         INT             IDENTITY (1, 1) NOT NULL,
    [ThumbNailPhoto]         VARBINARY (MAX) NULL,
    [ThumbnailPhotoFileName] NVARCHAR (50)   NULL,
    [LargePhoto]             VARBINARY (MAX) NULL,
    [LargePhotoFileName]     NVARCHAR (50)   NULL,
    [ModifiedDate]           DATETIME        NOT NULL
);

