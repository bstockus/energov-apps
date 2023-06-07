CREATE FUNCTION [laxreports].[HVACTableEquipmentDetailsColumnValues]
(
	@TABLEID char(36),
	@PERMITID char(36),
	@ROWNUMBER int
)
RETURNS @returntable TABLE
(
	ItemValue NVARCHAR(MAX)
)
AS
BEGIN
	--Furnace Type
	INSERT @returntable ([ItemValue])
		VALUES
			(CASE [laxreports].[GetCustomFieldTableListItemValue](@TABLEID, 'f28763ed-604e-4ee8-bef3-fd2b320d71cf', @PERMITID, 2, @ROWNUMBER) 
				WHEN NULL THEN NULL 
				ELSE 'Type: <b>' + [laxreports].[GetCustomFieldTableListItemValue](@TABLEID, 'f28763ed-604e-4ee8-bef3-fd2b320d71cf', @PERMITID, 2, @ROWNUMBER) + '</b>' END);

	-- Air Conditioner Type
	INSERT @returntable ([ItemValue])
		VALUES
			(CASE [laxreports].[GetCustomFieldTableListItemValue](@TABLEID, '5bcc8122-ffe5-4310-9941-8004133f8985', @PERMITID, 2, @ROWNUMBER) 
				WHEN NULL THEN NULL 
				ELSE 'Type: <b>' + [laxreports].[GetCustomFieldTableListItemValue](@TABLEID, '5bcc8122-ffe5-4310-9941-8004133f8985', @PERMITID, 2, @ROWNUMBER) + '</b>' END);
	
	-- Boiler Type
	INSERT @returntable ([ItemValue])
		VALUES
			(CASE [laxreports].[GetCustomFieldTableListItemValue](@TABLEID, 'cc63be80-53ff-492c-8334-e133f667d771', @PERMITID, 2, @ROWNUMBER) 
				WHEN NULL THEN NULL 
				ELSE 'Type: <b>' + [laxreports].[GetCustomFieldTableListItemValue](@TABLEID, 'cc63be80-53ff-492c-8334-e133f667d771', @PERMITID, 2, @ROWNUMBER) + '</b>' END);

	-- Commercial Type
	INSERT @returntable ([ItemValue])
		VALUES
			(CASE [laxreports].[GetCustomFieldTableListItemValue](@TABLEID, 'feb8f937-f81e-4f36-93b9-0976c671db94', @PERMITID, 2, @ROWNUMBER) 
				WHEN NULL THEN NULL 
				ELSE 'Type: <b>' + [laxreports].[GetCustomFieldTableListItemValue](@TABLEID, 'feb8f937-f81e-4f36-93b9-0976c671db94', @PERMITID, 2, @ROWNUMBER) + '</b>' END);

	-- Other Type
	INSERT @returntable ([ItemValue])
		VALUES
			(CASE [laxreports].[GetCustomFieldTableStringValue](@TABLEID, 'e2bca6bf-3288-403b-b9f7-3e7f2b1b020a', @PERMITID, 2, @ROWNUMBER) 
				WHEN NULL THEN NULL 
				ELSE 'Type: <b>' + [laxreports].[GetCustomFieldTableStringValue](@TABLEID, 'e2bca6bf-3288-403b-b9f7-3e7f2b1b020a', @PERMITID, 2, @ROWNUMBER) + '</b>' END);

	-- Fuel
	INSERT @returntable ([ItemValue])
		VALUES
			(CASE [laxreports].[GetCustomFieldTableListItemValue](@TABLEID, '0623d2c3-9958-467a-9cbf-783caf3c0a4e', @PERMITID, 2, @ROWNUMBER) 
				WHEN NULL THEN NULL 
				ELSE 'Fuel: <b>' + [laxreports].[GetCustomFieldTableListItemValue](@TABLEID, '0623d2c3-9958-467a-9cbf-783caf3c0a4e', @PERMITID, 2, @ROWNUMBER) + '</b>' END);

	-- Btuh
	INSERT @returntable ([ItemValue])
		VALUES
			(CASE [laxreports].[GetCustomFieldTableFloatValue](@TABLEID, '85d19449-24c9-47db-aab8-96271555c56e', @PERMITID, 2, @ROWNUMBER) 
				WHEN NULL THEN NULL 
				ELSE '<b>' + LTRIM(RTRIM(STR([laxreports].[GetCustomFieldTableFloatValue](@TABLEID, '85d19449-24c9-47db-aab8-96271555c56e', @PERMITID, 2, @ROWNUMBER), 10, 2))) + '</b> BTUh' END);

	-- C. Btuh
	INSERT @returntable ([ItemValue])
		VALUES
			(CASE [laxreports].[GetCustomFieldTableFloatValue](@TABLEID, 'b3d4f879-e02d-4376-8f80-02c3b3f114d7', @PERMITID, 2, @ROWNUMBER) 
				WHEN NULL THEN NULL 
				ELSE '<b>' + LTRIM(RTRIM(STR([laxreports].[GetCustomFieldTableFloatValue](@TABLEID, 'b3d4f879-e02d-4376-8f80-02c3b3f114d7', @PERMITID, 2, @ROWNUMBER), 10, 2))) + '</b> C. BTUh' END);

	-- H. Btuh
	INSERT @returntable ([ItemValue])
		VALUES
			(CASE [laxreports].[GetCustomFieldTableFloatValue](@TABLEID, '95c1c49f-805e-448a-adc3-0b53c5cbd75a', @PERMITID, 2, @ROWNUMBER) 
				WHEN NULL THEN NULL 
				ELSE '<b>' + LTRIM(RTRIM(STR([laxreports].[GetCustomFieldTableFloatValue](@TABLEID, '95c1c49f-805e-448a-adc3-0b53c5cbd75a', @PERMITID, 2, @ROWNUMBER), 10, 2))) + '</b> H. BTUh' END);

	-- kW
	INSERT @returntable ([ItemValue])
		VALUES
			(CASE [laxreports].[GetCustomFieldTableFloatValue](@TABLEID, 'ee162fac-62c5-42bf-ba00-5b7229fc1486', @PERMITID, 2, @ROWNUMBER) 
				WHEN NULL THEN NULL 
				ELSE '<b>' + LTRIM(RTRIM(STR([laxreports].[GetCustomFieldTableFloatValue](@TABLEID, 'ee162fac-62c5-42bf-ba00-5b7229fc1486', @PERMITID, 2, @ROWNUMBER), 10, 2))) + '</b> kW' END);

	-- CFM
	INSERT @returntable ([ItemValue])
		VALUES
			(CASE [laxreports].[GetCustomFieldTableFloatValue](@TABLEID, '2fc39898-22f6-4748-9e5d-ef13e8befed6', @PERMITID, 2, @ROWNUMBER) 
				WHEN NULL THEN NULL 
				ELSE '<b>' + LTRIM(RTRIM(STR([laxreports].[GetCustomFieldTableFloatValue](@TABLEID, '2fc39898-22f6-4748-9e5d-ef13e8befed6', @PERMITID, 2, @ROWNUMBER), 10, 2))) + '</b> CFM' END);

	RETURN
END
