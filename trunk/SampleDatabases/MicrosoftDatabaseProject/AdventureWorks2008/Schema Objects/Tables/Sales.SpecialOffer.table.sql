CREATE TABLE [Sales].[SpecialOffer] (
    [SpecialOfferID] INT              IDENTITY (1, 1) NOT NULL,
    [Description]    NVARCHAR (255)   NOT NULL,
    [DiscountPct]    SMALLMONEY       NOT NULL,
    [Type]           NVARCHAR (50)    NOT NULL,
    [Category]       NVARCHAR (50)    NOT NULL,
    [StartDate]      DATETIME         NOT NULL,
    [EndDate]        DATETIME         NOT NULL,
    [MinQty]         INT              NOT NULL,
    [MaxQty]         INT              NULL,
    [rowguid]        UNIQUEIDENTIFIER ROWGUIDCOL NOT NULL,
    [ModifiedDate]   DATETIME         NOT NULL
);

