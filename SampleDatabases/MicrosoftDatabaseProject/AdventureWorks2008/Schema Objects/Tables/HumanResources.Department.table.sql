CREATE TABLE [HumanResources].[Department] (
    [DepartmentID] SMALLINT     IDENTITY (1, 1) NOT NULL,
    [Name]         NVARCHAR (50) NOT NULL,
    [GroupName]    NVARCHAR (50) NOT NULL,
    [ModifiedDate] DATETIME     NOT NULL
);

