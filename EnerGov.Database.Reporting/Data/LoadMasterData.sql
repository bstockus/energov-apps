-- Clear Existing Data
DELETE FROM [laxmasterdata].[PermitTypeMasterData];
GO

-- Permit Types Master Data
INSERT INTO [laxmasterdata].[PermitTypeMasterData] ([PermitTypeId], [PermitWorkClassId], [Department], [PermitCategory], [PermitType], [PermitClass], [FixedNumberOfDwellingUnits], [IsNewConstruction], [SpecialHandlingCode], [SquareFootageType], [SummaryGroup], [SummaryClass], [SummaryWorkClass], [MechanicalIsNewHandling])
VALUES
('f8e2e5f8-3e4e-4578-9862-8835a2b1d59a', '27eacb5b-c6f6-4b93-9657-8bb713ad3744', 'FP&BS', 'Building', 'Commercial', 'Addition', 0, 0, '', 'M', 'Comm./Indust./Inst./Multi-Use', 'Addition', 'Addition', 'Z'),
('f8e2e5f8-3e4e-4578-9862-8835a2b1d59a', '76846663-7059-4c01-b951-c1fd5bd8a167', 'FP&BS', 'Building', 'Commercial', 'Alteration', 0, 0, '', 'M', 'Comm./Indust./Inst./Multi-Use', 'Alteration', 'Alteration', 'Z'),
('f8e2e5f8-3e4e-4578-9862-8835a2b1d59a', '016aca7a-abe2-4c0f-abac-3ef1eca172e5', 'FP&BS', 'Building', 'Commercial', 'New', 0, 1, '', 'M', 'Comm./Indust./Inst./Multi-Use', 'New', 'New', 'Z'),
('f8e2e5f8-3e4e-4578-9862-8835a2b1d59a', '09cf8e2e-6b06-4e7a-bda4-660dd67a9b13', 'FP&BS', 'Building', 'Commercial', 'Shell Only', 0, 1, '', 'M', 'Comm./Indust./Inst./Multi-Use', 'New', 'New', 'Z'),
('f8e2e5f8-3e4e-4578-9862-8835a2b1d59a', '1616dc11-f65f-4581-911d-9c12a95ecdca', 'FP&BS', 'Building', 'Commercial', 'Tenant Buildout', 0, 0, '', 'M', 'Comm./Indust./Inst./Multi-Use', 'Alteration', 'Alteration', 'Z'),

('73ee5e61-1743-485c-91c6-f317b27751bd', '27eacb5b-c6f6-4b93-9657-8bb713ad3744', 'FP&BS', 'Building', 'Condo', 'Addition', 1, 0, '', 'R', 'Single Family/Duplex/Condo', 'Addition', 'Addition', 'Z'),
('73ee5e61-1743-485c-91c6-f317b27751bd', 'bf2b2f57-8b3a-4ffa-ba7f-46cfefb2e960', 'FP&BS', 'Building', 'Condo', 'Alteration', 1, 0, '', 'R', 'Single Family/Duplex/Condo', 'Alteration', 'Alteration', 'Z'),
('73ee5e61-1743-485c-91c6-f317b27751bd', '016aca7a-abe2-4c0f-abac-3ef1eca172e5', 'FP&BS', 'Building', 'Condo', 'New', 1, 1, '', 'R', 'Single Family/Duplex/Condo', 'New', 'New', 'Z'),


('6e9a74ef-c984-44c1-82a5-6ebb21f5faa5', '27eacb5b-c6f6-4b93-9657-8bb713ad3744', 'FP&BS', 'Building', 'Duplex', 'Addition', 2, 0, '', 'R', 'Single Family/Duplex/Condo', 'Addition', 'Addition', 'Z'),
('6e9a74ef-c984-44c1-82a5-6ebb21f5faa5', 'bf2b2f57-8b3a-4ffa-ba7f-46cfefb2e960', 'FP&BS', 'Building', 'Duplex', 'Alteration', 2, 0, '', 'R', 'Single Family/Duplex/Condo', 'Alteration', 'Alteration', 'Z'),
('6e9a74ef-c984-44c1-82a5-6ebb21f5faa5', '016aca7a-abe2-4c0f-abac-3ef1eca172e5', 'FP&BS', 'Building', 'Duplex', 'New', 2, 1, '', 'R', 'Single Family/Duplex/Condo', 'New', 'New', 'Z'),


('be20d44c-7667-43db-9348-d0c9e46f35b8', '27eacb5b-c6f6-4b93-9657-8bb713ad3744', 'FP&BS', 'Building', 'Industrial', 'Addition', 0, 0, '', 'M', 'Comm./Indust./Inst./Multi-Use', 'Addition', 'Addition', 'Z'),
('be20d44c-7667-43db-9348-d0c9e46f35b8', 'bf2b2f57-8b3a-4ffa-ba7f-46cfefb2e960', 'FP&BS', 'Building', 'Industrial', 'Alteration', 0, 0, '', 'M', 'Comm./Indust./Inst./Multi-Use', 'Alteration', 'Alteration', 'Z'),
('be20d44c-7667-43db-9348-d0c9e46f35b8', '016aca7a-abe2-4c0f-abac-3ef1eca172e5', 'FP&BS', 'Building', 'Industrial', 'New', 0, 1, '', 'M', 'Comm./Indust./Inst./Multi-Use', 'New', 'New', 'Z'),

('9040613f-5ac1-4819-91cd-6b02158a73ab', '27eacb5b-c6f6-4b93-9657-8bb713ad3744', 'FP&BS', 'Building', 'Institutional', 'Addition', 0, 0, '', 'M', 'Comm./Indust./Inst./Multi-Use', 'Addition', 'Addition', 'Z'),
('9040613f-5ac1-4819-91cd-6b02158a73ab', 'bf2b2f57-8b3a-4ffa-ba7f-46cfefb2e960', 'FP&BS', 'Building', 'Institutional', 'Alteration', 0, 0, '', 'M', 'Comm./Indust./Inst./Multi-Use', 'Alteration', 'Alteration', 'Z'),
('9040613f-5ac1-4819-91cd-6b02158a73ab', '016aca7a-abe2-4c0f-abac-3ef1eca172e5', 'FP&BS', 'Building', 'Institutional', 'New', 0, 1, '', 'M', 'Comm./Indust./Inst./Multi-Use', 'New', 'New', 'Z'),

('8811c583-9d77-455c-9cfd-ab10d86fc2bd', '27eacb5b-c6f6-4b93-9657-8bb713ad3744', 'FP&BS', 'Building', 'Multi-Family', 'Addition', 0, 0, '', 'M', 'Multi-Family (3+ Units)', 'Addition', 'Addition', 'Z'),
('8811c583-9d77-455c-9cfd-ab10d86fc2bd', 'bf2b2f57-8b3a-4ffa-ba7f-46cfefb2e960', 'FP&BS', 'Building', 'Multi-Family', 'Alteration', 0, 0, '', 'M', 'Multi-Family (3+ Units)', 'Alteration', 'Alteration', 'Z'),
('8811c583-9d77-455c-9cfd-ab10d86fc2bd', '016aca7a-abe2-4c0f-abac-3ef1eca172e5', 'FP&BS', 'Building', 'Multi-Family', 'New', 0, 1, '', 'M', 'Multi-Family (3+ Units)', 'New', 'New', 'Z'),

('7ca58aba-3a5b-4809-9cdb-3d83f78d480e', '27eacb5b-c6f6-4b93-9657-8bb713ad3744', 'FP&BS', 'Building', 'Single-Family', 'Addition', 1, 0, '', 'R', 'Single Family/Duplex/Condo', 'Addition', 'Addition', 'Z'),
('7ca58aba-3a5b-4809-9cdb-3d83f78d480e', '76846663-7059-4c01-b951-c1fd5bd8a167', 'FP&BS', 'Building', 'Single-Family', 'Alteration', 1, 0, '', 'R', 'Single Family/Duplex/Condo', 'Alteration', 'Alteration', 'Z'),
('7ca58aba-3a5b-4809-9cdb-3d83f78d480e', '016aca7a-abe2-4c0f-abac-3ef1eca172e5', 'FP&BS', 'Building', 'Single-Family', 'New', 1, 1, '', 'R', 'Single Family/Duplex/Condo', 'New', 'New', 'Z'),

('49dbc3c0-eb0b-427f-b05e-edabfa4a3c8c', 'd4763573-5b70-4153-8612-f1312d752bcc', 'FP&BS', 'Building', 'Accessory', 'Fence', 0, 1, '', 'N', 'Accessory', 'Fence', 'New', 'Z'),
('49dbc3c0-eb0b-427f-b05e-edabfa4a3c8c', 'bd064e71-ce9d-4da9-859e-007a13fc0e33', 'FP&BS', 'Building', 'Accessory', 'Detached Garage', 0, 1, '', 'N', 'Accessory', 'Garage', 'New', 'Z'),
('49dbc3c0-eb0b-427f-b05e-edabfa4a3c8c', 'add89e4f-9e04-434a-ac7f-6147b16c4dea', 'FP&BS', 'Building', 'Accessory', 'Gazebo', 0, 1, '', 'N', 'Accessory', 'Gazebo', 'New', 'Z'),
('49dbc3c0-eb0b-427f-b05e-edabfa4a3c8c', '4b2caee1-153a-425f-97fd-00d2f99beda8', 'FP&BS', 'Building', 'Other', 'Parking Lot', 0, 1, '', 'N', 'Other', 'Parking Lot', 'New', 'Z'),
('49dbc3c0-eb0b-427f-b05e-edabfa4a3c8c', '331829ca-7741-4eb1-a8b3-25a7303320e2', 'FP&BS', 'Building', 'Accessory', 'Wooden Patio Deck', 0, 1, '', 'N', 'Accessory', 'Deck', 'New', 'Z'),
('49dbc3c0-eb0b-427f-b05e-edabfa4a3c8c', '4f711c26-b818-4e61-b546-594a6e1ffeb8', 'FP&BS', 'Building', 'Accessory', 'Yard Shed', 0, 1, '', 'N', 'Accessory', 'Shed', 'New', 'Z'),

('3f8c444c-5e53-4dec-ae67-66ae79355876', '5cb1d570-772a-4138-ab92-32f4bbc7e3f8', 'FP&BS', 'Building', 'Other', 'Footing/Foundation Only', 0, 0, '', 'N', 'Other', 'Ftg./Found.', 'New', 'Z'),

('ef171716-60e0-48c1-bd65-9a8ae0f30171', '3e8d4fd4-ed1d-4637-9761-7eb04803ed5f', 'FP&BS', 'Building', 'Other', 'Grandstand Bleacher', 0, 0, '', 'N', 'Other', 'Bleacher', 'New', 'Z'),

('4790cba0-30b0-4a03-8716-a06b3c2c5247', '5680161d-926e-4a5e-8a71-e48a78ad0b3c', 'FP&BS', 'Building', 'Other', 'Swimming Pool', 0, 0, '', 'N', 'Other', 'Pool', 'New', 'Z'),

('6b36aed1-b0a1-418b-b9de-470e367f760b', '7078d60e-c406-438b-b222-d20431a88067', 'FP&BS', 'Building', 'Sign', 'On-Premise', 0, 0, '89992e26-34e9-4ffd-864a-f8c593337f70', 'N', 'Other', 'Sign', 'New', 'Z'),
('6b36aed1-b0a1-418b-b9de-470e367f760b', '7078d60e-c406-438b-b222-d20431a88067', 'FP&BS', 'Building', 'Sign', 'Off-Premise', 0, 0, 'c54ec176-ef55-40ec-b85c-aab500ac8d92', 'N', 'Other', 'Sign', 'New', 'Z'),

('a6f5637c-d6ff-49e8-b7b3-25f7b47db5e9', '68e3a2f8-09a1-479f-af46-52e23b9c9b03', 'FP&BS', 'Building', 'Other', 'Re-Roof', 0, 0, '', 'N', 'Other', 'Re-Roof', 'Alteration', 'Z'),

('af1acea6-eb57-484b-856c-2bb9b99668ad', '4093322f-a0c8-4cd4-b039-66f9c87a67d6', 'FP&BS', 'Demolition', 'Inside', '', 0, 0, 'ca7a2d31-64dc-4b1c-97cc-daf123948b20', 'N', 'Other', 'Demo.', '', 'Z'),
('af1acea6-eb57-484b-856c-2bb9b99668ad', '4093322f-a0c8-4cd4-b039-66f9c87a67d6', 'FP&BS', 'Demolition', 'Entire Structure', '', 0, 0, 'deb92b91-f735-4302-b3bb-06c077776d54', 'N', 'Other', 'Demo.', '', 'Z'),

('d4755436-4491-4456-bd0d-e3182f4207dc', '8d4f4633-52ef-4b5e-adf6-a0df17fc30a4', 'FP&BS', 'Building', 'Antenna', 'New', 0, 0, '91896a0e-c070-4679-8f8c-75460d59e403', 'N', 'Other', 'Ant.', 'New', 'Z'),
('d4755436-4491-4456-bd0d-e3182f4207dc', '8d4f4633-52ef-4b5e-adf6-a0df17fc30a4', 'FP&BS', 'Building', 'Antenna', 'Co-Location', 0, 0, '4db5f44e-c412-44cd-85c1-ec96fa942ff0', 'N', 'Other', 'Ant.', 'Addition', 'Z'),

('d3a4e03d-8834-4e4f-9723-5ff29d98eb95', 'd1509a8a-2ed6-4fb6-bc5a-301acd7258ff', 'FP&BS', 'Mechanical', 'Electrical', '', 0, 0, '', 'N', 'Mechanical', 'Electrical', 'Alteration', 'N'),
('d3a4e03d-8834-4e4f-9723-5ff29d98eb95', 'd1509a8a-2ed6-4fb6-bc5a-301acd7258ff', 'FP&BS', 'Mechanical', 'Electrical', '', 0, 0, '', 'N', 'Mechanical', 'Electrical', 'New', 'Y'),

('d2a1ec5d-89ca-4db0-81a5-c7cfafd798c2', '2dfc345f-d34f-49c5-9c6a-74e1919b80e1', 'FP&BS', 'Mechanical', 'HVAC', '', 0, 0, '', 'N', 'Mechanical', 'HVAC', 'Alteration', 'N'),
('d2a1ec5d-89ca-4db0-81a5-c7cfafd798c2', '2dfc345f-d34f-49c5-9c6a-74e1919b80e1', 'FP&BS', 'Mechanical', 'HVAC', '', 0, 0, '', 'N', 'Mechanical', 'HVAC', 'New', 'Y'),
('d2a1ec5d-89ca-4db0-81a5-c7cfafd798c2', '6dbfd2ea-b7eb-453f-bce6-75e86fa3c568', 'FP&BS', 'Mechanical', 'HVAC', '1 & 2 Family Replacement', 0, 0, '', 'N', 'Mechanical', 'HVAC', 'Alteration', 'Z'),

('6d5c931e-aaef-4bb9-8cc5-ba1ffda55fb6', '1876ad36-ee1b-40c0-ab95-a469660ec830', 'FP&BS', 'Mechanical', 'Plumbing', '', 0, 0, '', 'N', 'Mechanical', 'Plumbing', 'Alteration', 'N'),
('6d5c931e-aaef-4bb9-8cc5-ba1ffda55fb6', '1876ad36-ee1b-40c0-ab95-a469660ec830', 'FP&BS', 'Mechanical', 'Plumbing', '', 0, 0, '', 'N', 'Mechanical', 'Plumbing', 'New', 'Y'),

('d3c35ab5-d546-40a8-af56-4d4fe03f0577', 'eae5cf3b-aebf-4eb8-86e9-b8f00c505f8d', 'FP&BS', 'Zoning', 'Land Use', '', 0, 0, '', 'N', 'Zoning', 'Land Use', '', 'Z');

DELETE FROM [laxmasterdata].[Calendar];
GO

DECLARE @StartDate DATETIME = '2015-01-01' --Starting value of Date Range
DECLARE @EndDate DATETIME = '2025-12-31' --End Value of Date Range

DECLARE @CurrentDate AS DATETIME = @StartDate

WHILE @CurrentDate < @EndDate
BEGIN

INSERT INTO [laxmasterdata].[Calendar]
	SELECT		
		CONVERT (char(8),@CurrentDate,112) as [DateKey],
		@CurrentDate AS [Date];


SET @CurrentDate = DATEADD(DD, 1, @CurrentDate)
END

DELETE FROM [laxmasterdata].[FireOccupancyUserDistricts];
GO

INSERT INTO [laxmasterdata].[FireOccupancyUserDistricts] ([ZoneId], [Shift], [Station])
VALUES
	('30cc8899-e0e2-4627-97be-d2524cc671d9', 'A', '1'), -- 1A
	('408cdf8a-8ad6-4e72-93cc-a93fe4207690', 'B', '1'), -- 1B
	('3a8732ab-d9c2-4d95-b11d-63fe660ef12b', 'C', '1'), -- 1C
	('e81e9e57-7aac-4736-9bb6-6a1671114ed3', 'A', '1'), -- 1D
	('3e38bc7c-63aa-478c-bd20-a589366ff4cf', 'B', '1'), -- 1E
	('92eb6104-0355-43dd-aa12-73ad4ad6b7f4', 'C', '1'), -- 1F
	('fee697bf-015e-4497-8a9c-3ffd8a191037', 'A', '1'), -- 1G
	('cf87443d-7587-43c6-8705-377b194db482', 'B', '1'), -- 1H
	('7b5e2335-dcd6-4fe9-8c27-19eaa18a83f3', 'C', '1'), -- 1I
	('41b30376-9afe-43a3-a9d2-f0539c56b2c6', 'A', '2'), -- 2A
	('0746e9f7-f702-4518-8423-aeaaa562a5f8', 'B', '2'), -- 2B
	('b8a9b64e-2fbd-47b4-81a1-8259720aee70', 'C', '2'), -- 2C
	('f5074e76-4e25-4f76-90d4-75d2e780a720', 'A', '2'), -- 2D
	('39189982-a103-4fa4-bea7-7a216997b054', 'B', '2'), -- 2E
	('653ae849-295e-4503-8564-a5bf5881b867', 'C', '2'), -- 2F
	('4f0d0fc7-4d21-48dc-b535-a4de21ab5d7e', 'A', '3'), -- 3A
	('99dd6e99-7804-4b47-af9a-45e0f6bd8c5d', 'B', '3'), -- 3B
	('0c4428d8-afca-4e78-ad5d-111001a8a857', 'C', '3'), -- 3C
	('47775c14-990a-4a1d-b080-41918c95f0d3', 'A', '3'), -- 3D
	('23b678a5-e585-4abb-9937-a9f215fa08fb', 'B', '3'), -- 3E
	('a29aac79-d7d7-4d61-a082-a7aad331c430', 'C', '3'), -- 3F
	('8422a84d-1126-48ab-92d7-05912c729689', 'A', '4'), -- 4A
	('e8c80f6f-8de1-4dd5-92c8-a8ec00b6c5db', 'B', '4'), -- 4B
	('a7bb4986-2629-4982-8acb-9818df41013a', 'C', '4'), -- 4C
	('113aae72-32f6-435a-ae33-296b788db851', 'Day', 'Kyle'), -- F1
	('16961407-31c6-4f4f-be3d-b4200d21f38e', 'Day', 'Kyle'), -- F2
	('2e611341-794f-41f0-a830-ff714db2a2db', 'Day', 'Kyle'), -- F3
	('9dca7aa0-14c3-457a-b930-3a1cabd3396e', 'Day', 'Kyle'), -- F4
	('86e9f8e0-466b-45b8-a1b5-f70e6fbaba72', 'Day', 'Tim'), -- F5
	('ab8bb1ec-6e0d-4e41-b03b-4cdde7b0fddf', 'Day', 'Tim'), -- F6
	('5a376fbd-9b4a-43d7-b107-ee5e9e64359c', 'Day', 'Tim'), -- F7
	('c7efe372-6297-4c54-9093-beccb8546f72', 'Air', 'Air'), -- A1
	('22976bb4-c78b-4255-b35f-3e4eeafe769f', 'Day', 'Kyle'), -- T1
	('6480d091-db37-411e-8bf3-c891b9d81a9f', 'Day', 'Tim'), -- M1
	('7cb09d9f-6811-43af-bc0e-7386e510b0d5', 'Day', 'Tim'), -- WU
	('c16399f3-6ab3-4089-993c-090e9e3d2a25', 'Day', 'Kyle'), -- PR
	('ef4db7a8-0951-4d15-8038-7f978f98ef88', 'Day', 'Tim'), -- LC
	('f8c1ddbf-e669-41f4-bbda-02042226ff51', 'Day', 'Tim'); -- MD