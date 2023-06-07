CREATE FUNCTION [laxreports].[HVACTableValues]
(
	@PERMITID char(36)
)
RETURNS @returntable TABLE
(
	EquipmentType NVARCHAR(100),
	EquipmentQuantity NVARCHAR(10),
	EquipmentIsReplacement NVARCHAR(1),
	EquipmentManufacturer NVARCHAR(50),
	EquipmentModelNumber NVARCHAR(50),
	EquipmentDetails NVARCHAR(MAX)
)
AS
BEGIN
	-- Furnaces Table:
	INSERT @returntable
	SELECT 
		CASE RowNum.TableId 
			WHEN '9d6f6855-0095-45d5-83f9-af706ee0b913' THEN 'Air Conditioner'
			WHEN '38cd8393-b046-4fea-9c64-f06a7ef44f56' THEN 'Boiler'
			WHEN 'cf022a69-0bbd-4801-97d3-330efa37ab7d' THEN 'Combined Heater & Air Conditioner'
			WHEN '6f03334c-90eb-4b5e-b257-c1b303ef32f6' THEN 'Commercial'
			WHEN 'ba26f899-27a9-4177-ab75-63d19238ce75' THEN 'Electric Baseboard Heating'
			WHEN 'dc5fdf28-8f0a-4d7c-8f85-70b5f3df42a6' THEN 'Kitchen Hood'
			WHEN '701ac594-f933-423d-a54f-34ce77d62d34' THEN 'Fireplace/Gas Log'
			WHEN '9d639ea4-8e78-4b93-ae97-8c7ea63d7038' THEN 'Furnace'
			WHEN '4b6c23ca-710b-4e0e-b43e-cd879517d005' THEN 'Heat Pump'
			WHEN '4bfcc321-dbd7-4987-ab8b-1999bf92ffb3' THEN 'Kitchen Hood & Exhaust System'
			WHEN '49fd0681-ee0a-48ac-8dd3-e17da52f60f9' THEN 'Other'
			WHEN '85aa58e4-54e0-4ec3-9e3e-e3eaa205145d' THEN 'Unit Heater.'
			ELSE 'Unknown' END AS "EquipmentType",
		LTRIM(RTRIM(STR([laxreports].[GetCustomFieldTableIntegerValue](RowNum.TableId, 'bd47e3a3-b35b-417f-a305-5f941f8931e1', @PERMITID, 2, RowNum.RowNumber), 5, 0))) AS "EquipmentQuantity",
		CASE ISNULL([laxreports].[GetCustomFieldTableBooleanValue](RowNum.TableId, 'f2d2528e-7774-407f-a89f-efbaf53b56c9', @PERMITID, 2, RowNum.RowNumber), 0) WHEN 1 THEN 'Y' ELSE 'N' END AS "EquipmentIsReplacement",
		ISNULL([laxreports].[GetCustomFieldTableStringValue](RowNum.TableId, 'bc834a87-9604-4cde-b5a7-30204c19a871', @PERMITID, 2, RowNum.RowNumber), '') AS "EquipmentManufacturer",
		ISNULL([laxreports].[GetCustomFieldTableStringValue](RowNum.TableId, '996b5f75-35c0-4acf-95e3-b9289a9ab286', @PERMITID, 2, RowNum.RowNumber), '') AS "EquipmentModelNumber",
		ISNULL(STUFF((SELECT CAST(', ' + x.ItemValue AS NVARCHAR(MAX)) [text()]
						FROM [laxreports].HVACTableEquipmentDetailsColumnValues(RowNum.TableId, @PERMITID, RowNum.RowNumber) x
						WHERE x.ItemValue IS NOT NULL
						FOR XML PATH(''), TYPE).value('.', 'NVARCHAR(MAX)'),1,2, ' '),'') AS "EquipmentDetails"
	FROM [laxreports].[CustomFieldAllTableRowNumbers](@PERMITID, 2) RowNum
	WHERE [laxreports].[GetCustomFieldTableIntegerValue](RowNum.TableId, 'bd47e3a3-b35b-417f-a305-5f941f8931e1', @PERMITID, 2, RowNum.RowNumber) IS NOT NULL
	ORDER BY RowNum.TableId, RowNum.RowNumber
	RETURN
END
