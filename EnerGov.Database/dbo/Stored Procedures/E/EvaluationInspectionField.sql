
CREATE PROCEDURE [dbo].[EvaluationInspectionField]
-- Add the parameters for the stored procedure here
@CaseID char(36),
@ConditionID char(36),
@FieldLogicalOperator nvarchar(3),
@Result bit out
AS
BEGIN
	--Initialize evaluation paramater
	DECLARE @SQL nvarchar(max) = NULL
	DECLARE @TableName nvarchar(50) = NULL
	DECLARE @ColumnName nvarchar(50) = NULL		
	DECLARE @EvaluationExpression nvarchar(max) = NULL		
	DECLARE @Field nvarchar(100) = NULL
	DECLARE @FieldValue nvarchar(200) = NULL	
	DECLARE @Operator nvarchar(2) = NULL	
	DECLARE @CustomSaverInspections nvarchar(50) = 'CUSTOMSAVERINSPECTIONS'

	--FieldCursor	
	DECLARE FieldCursor CURSOR LOCAL FAST_FORWARD FOR
	SELECT FIELD, FIELDVALUE, OPERATOR
	FROM  IMPREREQFIELD
	WHERE IMPREREQCONDITIONID = @ConditionID

	--Initialize					
	OPEN FieldCursor
	FETCH NEXT FROM FieldCursor INTO @Field, @FieldValue, @Operator
	WHILE @@FETCH_STATUS = 0
	BEGIN													
		SET @TableName = SUBSTRING(@Field, 1, CHARINDEX('.', @Field) - 1)
		SET @ColumnName = SUBSTRING(@Field, CHARINDEX('.', @Field) +1, LEN(@Field))
		IF RTRIM(LTRIM(@TableName)) = 'IMINSPECTION' --This is inspection fields
		BEGIN
			SET @EvaluationExpression = 'EXISTS(SELECT 1 FROM IMINSPECTION WHERE IMINSPECTIONID = ' + '''' + @CaseID + ''' AND ' + @Field + ' ' + @Operator + ' ''' + @FieldValue + ''')'
			SET @SQL = 'SELECT @Result = CASE WHEN ' + @EvaluationExpression + ' THEN 1 ELSE 0 END'
			Exec sp_executesql @SQL, N'@Result bit output', @Result output			
		END
		ELSE IF CHARINDEX(@CustomSaverInspections, @TableName) > 0 --Custom Field evaluation
		BEGIN
			IF EXISTS (SELECT * FROM INFORMATION_SCHEMA.COLUMNS Where TABLE_NAME= @TableName AND COLUMN_NAME = @ColumnName) --Make sure table and column existed
			BEGIN
				SET @EvaluationExpression = 'EXISTS	(SELECT 1 FROM ' + @TableName + ' WHERE ID = ' + '''' + @CaseID + ''' AND ' + @Field + ' ' + @Operator + ' ''' + @FieldValue + ''')'
				SET @SQL = 'SELECT @Result = CASE WHEN ' + @EvaluationExpression + ' THEN 1 ELSE 0 END'
				Exec sp_executesql @SQL, N'@Result bit output', @Result output											
			END
			ELSE --No custom field, evaluate should be true
			BEGIN
				SET @Result = 1
			END
		END
		IF @FieldLogicalOperator IS NULL --No need to continue evaluate
		BEGIN							
			BREAK --Break out of while loop
		END
		ELSE IF (@FieldLogicalOperator = 'OR' AND @Result = 1) OR (@FieldLogicalOperator = 'AND' AND @Result = 0) --No need to evaluate furthur
		BEGIN
			BREAK --Break out of while loop
		END		
		--Initialize for next field
		SET @EvaluationExpression = NULL
		SET @SQL = NULL
		SET @Field = NULL
		SET @FieldValue = NULL						
		SET @Operator = NULL
		FETCH NEXT FROM FieldCursor INTO @Field, @FieldValue, @Operator							
	END
	CLOSE FieldCursor
END
