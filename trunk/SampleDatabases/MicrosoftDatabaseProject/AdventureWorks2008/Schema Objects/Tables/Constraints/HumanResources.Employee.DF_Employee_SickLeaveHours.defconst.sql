ALTER TABLE [HumanResources].[Employee]
    ADD CONSTRAINT [DF_Employee_SickLeaveHours] DEFAULT ((0)) FOR [SickLeaveHours];

