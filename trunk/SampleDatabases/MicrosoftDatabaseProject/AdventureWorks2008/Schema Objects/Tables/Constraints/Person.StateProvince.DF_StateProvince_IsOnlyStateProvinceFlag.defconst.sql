ALTER TABLE [Person].[StateProvince]
    ADD CONSTRAINT [DF_StateProvince_IsOnlyStateProvinceFlag] DEFAULT ((1)) FOR [IsOnlyStateProvinceFlag];

