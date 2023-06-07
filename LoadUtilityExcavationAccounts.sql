CREATE TABLE #ExpenseItems (PickListItemId UNIQUEIDENTIFIER, MunisOrg NVARCHAR(8), MunisObject NVARCHAR(6), MunisProject NVARCHAR(5), MunisCashOrg NVARCHAR(8), MunisCashObject NVARCHAR(6), MunisCashProject NVARCHAR(5));

DELETE FROM #ExpenseItems;

INSERT INTO #ExpenseItems (PickListItemId, MunisOrg, MunisObject, MunisProject, MunisCashOrg, MunisCashObject, MunisCashProject)
	VALUES

	-- Sewer
	('23d27da3-41ac-4203-b837-6c6d44ea0d29', '6306334', '540300', 'W3160', '630', '101001', ''),

	-- Storm Water
	('8012e44d-ddc5-49f2-b2e4-8b05ad20a02a', '6506524', '540300', 'S3160', '650', '101001', ''),

	-- Water - Fountain Repair
	('6b89ae62-e7d9-4909-9400-3d5f7c0c46f2', '6406436', '532010', 'P6780', '640', '101001', 'P1310'),

	-- Water - Hydrant New
	('c57ac998-391d-468b-b653-febf7876e45c', '640', '162001', 'P3480', '640', '101001', 'P1310'),

	-- Water - Hydrant Removal
	('7aeb756f-53d1-4f43-8b7f-7a14dd67cc35', '6406436', '550000', 'P6770', '640', '101001', 'P1310'),

	-- Water - Hydrant Repair
	('3e6c4cbd-83bf-4d7b-b379-4f7eb6b74bf2', '6406436', '532010', 'P6770', '640', '101001', 'P1310'),

	-- Water - Hydrant Replace
	('79eac646-05cc-470c-82a9-2cb96ae44dd0', '6406436', '550000', 'P6770', '640', '101001', 'P1310'),

	-- Water - Main/Valve Disconnect
	('3e8352f5-36f5-4669-9322-58e21c51902f', '6406436', '532010', 'P6730', '640', '101001', 'P1310'),

	-- Water - Service Disconnect
	('ae535a63-4491-4735-84fa-5d5fd27e4c5a', '6406436', '550000', 'P6750', '640', '101001', 'P1310'),

	-- Water - Service New
	('4f48460b-402a-4a6b-9c1d-cd04f7cce7a9', '640', '180001', 'P107S', '640', '101001', 'P1310'),

	-- Water - Service Relay
	('2f72901b-075f-486e-b72d-baac12eebba1', '640', '180001', 'P107S', '640', '101001', 'P1310'),

	-- Water - Service Repair
	('56ee89b9-52bf-4e3f-8bb8-e58b6ae42793', '6406436', '532010', 'P6750', '640', '101001', 'P1310');

CREATE TABLE #RevenueItems (FeeId UNIQUEIDENTIFIER, MunisOrg NVARCHAR(8), MunisObject NVARCHAR(6), MunisProject NVARCHAR(5), MunisCashOrg NVARCHAR(8), MunisCashObject NVARCHAR(6), MunisCashProject NVARCHAR(5));

DELETE FROM #RevenueItems;

INSERT INTO #RevenueItems (FeeId, MunisOrg, MunisObject, MunisProject, MunisCashOrg, MunisCashObject, MunisCashProject)
	VALUES

	-- Excavation Permit
	('77159828-6398-4451-b9dd-ecd77884ad40', '1000410', '450005', '', '100', '101001', ''),

	-- Street Repair - Blacktop
	('0465ac02-8013-4be7-895c-8cd8b358db82', '1003410', '454005', '', '100', '101001', ''),

	-- Street Repair - Concrete Sidewalk
	('ad1b433f-72a2-47ae-8d26-66fd9025d32b', '1003410', '454005', '', '100', '101001', ''),

	-- Street Repair - Concrete Slab
	('92dbfdfd-d822-4e38-b4c4-8c9c645d7b0d', '1003410', '454005', '', '100', '101001', ''),

	-- Street Repair - Curb and Gutter
	('cdcf3bbc-0a4d-440b-97d9-ca919f8ce426', '1003410', '454000', '', '100', '101001', ''),

	-- Street Repair - Driveway Cuts
	('4c59d920-d394-4e87-a538-65fab72b9e8f', '1003410', '454005', '', '100', '101001', ''),

	-- Street Repair - Sawing - Blacktop - Big
	('32f8d23d-7680-43fd-b1e6-80d5b25390e5', '1003410', '454005', '', '100', '101001', ''),

	-- Street Repair - Sawing - Blacktop - Small
	('2bb377f0-9eb1-4d5a-b602-a963598e70de', '1003410', '454005', '', '100', '101001', ''),

	-- Street Repair - Sawing - Concrete - Big
	('953023e4-628d-48ca-bad7-c3f5a43ddbcb', '1003410', '454005', '', '100', '101001', ''),

	-- Street Repair - Sawing - Concrete - Small
	('113a3116-3b8f-4fb3-859c-abd7bbfa7c73', '1003410', '454005', '', '100', '101001', '');

DELETE FROM [UtilityExcavation].UtilityFeeGLAccounts;
GO

INSERT INTO [UtilityExcavation].UtilityFeeGLAccounts

SELECT
	rev.FeeId AS EnerGovFeeId,
	expe.PickListItemId AS EnerGovPickListItemId,
	rev.MunisOrg AS MunisRevenueAccountOrg,
	rev.MunisObject AS MunisRevenueAccountObject,
	rev.MunisProject AS MunisRevenueAccountProject,	
	rev.MunisCashOrg AS MunisRevenueCashAccountOrg,
	rev.MunisCashObject AS MunisRevenueCashAccountObject,
	expe.MunisOrg AS MunisExpenseAccountOrg,
	expe.MunisObject AS MunisExpenseAccountObject,
	expe.MunisProject AS MunisExpenseAccountProject,	
	expe.MunisCashOrg AS MunisExpenseCashAccountOrg,
	expe.MunisCashObject AS MunisExpenseCashAccountObject,
	expe.MunisCashProject AS MunisExpenseCashAccountProject,
	rev.MunisCashProject AS MunisRevenueCashAccountProject
FROM #RevenueItems rev
CROSS JOIN #ExpenseItems expe;
GO