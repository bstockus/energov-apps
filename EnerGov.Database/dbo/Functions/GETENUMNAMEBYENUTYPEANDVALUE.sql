CREATE FUNCTION [dbo].[GETENUMNAMEBYENUTYPEANDVALUE]
(
	@ENUMTYPE INT, -- 1 => OperandType | 2 => CADataType | 3 => Operator | 4=> CAExpressionType | 5=> FeeTemplateInputTypes
	@ENUMVALUE INT = NULL -- VALUE OF ENUM 
)
RETURNS NVARCHAR(MAX)
AS
BEGIN		
	DECLARE @ENUMNAME NVARCHAR(MAX)

	SELECT  @ENUMNAME=(
	CASE @ENUMTYPE
			WHEN
				1 -- => OperandType
				THEN 
					CASE @ENUMVALUE 
							WHEN 1
								THEN 'Entity' 
							WHEN 2
								THEN 'EntityProperty' 
							WHEN 3
								THEN 'CustomField' 
							WHEN 4
								THEN 'Fee' 
							WHEN 5
								THEN 'Total' 
							WHEN 6
								THEN 'Variable' 
							WHEN 7
								THEN 'Table' 
							END				
			WHEN
				2 -- => CADataType
				THEN 
					CASE @ENUMVALUE 
							WHEN 1
								THEN 'String' 
							WHEN 2
								THEN 'Date' 
							WHEN 3
								THEN 'Boolean' 
							WHEN 4
								THEN 'Integer' 
							WHEN 5
								THEN 'Number' 
							WHEN 6
								THEN 'Currency' 
							WHEN 7
								THEN 'None' 
							END
			WHEN
				3 -- => Operator
				THEN 
					CASE @ENUMVALUE 
							WHEN 1
								THEN 'Equals' 
							WHEN 2
								THEN 'NotEqual' 
							WHEN 3
								THEN 'GreaterThan' 
							WHEN 4
								THEN 'GreaterThanOrEqual' 
							WHEN 5
								THEN 'LessThan' 
							WHEN 6
								THEN 'LessThanOrEqual' 
							WHEN 7
								THEN 'IsBlank' 
							WHEN 8
								THEN 'IsNotBlank' 
							WHEN 9
								THEN 'IsChanged' 
							WHEN 10
								THEN 'IsCreated' 
							WHEN 11
								THEN 'IsDeleted' 
							WHEN 12
								THEN 'IsLargestFee' 
							WHEN 13
								THEN 'IsNotLargestFee' 
							WHEN 14
								THEN 'IsSmallestFee' 
							WHEN 15
								THEN 'IsNotSmallestFee' 
							END
			WHEN
				4 -- => CAExpressionType
				THEN 
					CASE @ENUMVALUE 
							WHEN 1
								THEN 'Add' 
							WHEN 2
								THEN 'Subtract' 
							WHEN 3
								THEN 'Multiply' 
							WHEN 4
								THEN 'Divide' 
							WHEN 5
								THEN 'Min' 
							WHEN 6
								THEN 'Max' 
							WHEN 7
								THEN 'Constant' 
							WHEN 8
								THEN 'Variable' 
							WHEN 9
								THEN 'DateDiff' 
							WHEN 10
								THEN 'AddDays' 
							WHEN 11
								THEN 'CurrentDate' 
							WHEN 12
								THEN 'DateConstant' 
							WHEN 13
								THEN 'DateVariable' 
							END
			WHEN
				5 -- => FeeTemplateInputTypes
				THEN 
					CASE @ENUMVALUE 
							WHEN 1
								THEN 'Property' 
							WHEN 2
								THEN 'CustomField' 
							WHEN 3
								THEN 'Fee' 
							WHEN 4
								THEN 'Total' 
							WHEN 5
								THEN 'Constant' 
							ELSE
								'[none]'
							END
			END)
						
	RETURN @ENUMNAME
END