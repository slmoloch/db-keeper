﻿CREATE TABLE [Person].[Address] (
    [AddressID]       INT               IDENTITY (1, 1) NOT FOR REPLICATION NOT NULL,
    [AddressLine1]    NVARCHAR (60)     NOT NULL,
    [AddressLine2]    NVARCHAR (60)     NULL,
    [City]            NVARCHAR (30)     NOT NULL,
    [StateProvinceID] INT               NOT NULL,
    [PostalCode]      NVARCHAR (15)     NOT NULL,
    [SpatialLocation] [sys].[geography] NULL,
    [rowguid]         UNIQUEIDENTIFIER  ROWGUIDCOL NOT NULL,
    [ModifiedDate]    DATETIME          NOT NULL
);

