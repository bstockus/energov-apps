
CREATE FUNCTION [dbo].[GetMultiSelectValue]
       (@Id CHAR(36)
       ,@CustomField CHAR(36))
RETURNS NVARCHAR(1000)
AS
BEGIN
    
    DECLARE @output NVARCHAR(1000);

    SET @output = STUFF((
                         SELECT ', ' + [Pick].[SVALUE]
                         FROM   (
                                 SELECT *
                                 FROM   [CUSTOMSAVERASSETMANAGEMENTMS]
                                 WHERE  [ID] = @Id
                                        AND [CUSTOMFIELDID] = @CustomField
                                 UNION
                                 SELECT *
                                 FROM   [CUSTOMSAVERCODEMANAGEMENTMS]
                                 WHERE  [ID] = @Id
                                        AND [CUSTOMFIELDID] = @CustomField
                                 UNION
                                 SELECT *
                                 FROM   [CUSTOMSAVERCODEMANAGEMENTMS]
                                 WHERE  [ID] = @Id
                                        AND [CUSTOMFIELDID] = @CustomField
                                 UNION
                                 SELECT *
                                 FROM   [CUSTOMSAVERCRMMANAGEMENTMS]
                                 WHERE  [ID] = @Id
                                        AND [CUSTOMFIELDID] = @CustomField
                                 UNION
                                 SELECT *
                                 FROM   [CUSTOMSAVERDECISIONENGINEMS]
                                 WHERE  [ID] = @Id
                                        AND [CUSTOMFIELDID] = @CustomField
                                 UNION
                                 SELECT *
                                 FROM   [CUSTOMSAVERIMPACTMANAGEMENTMS]
                                 WHERE  [ID] = @Id
                                        AND [CUSTOMFIELDID] = @CustomField
                                 UNION
                                 SELECT *
                                 FROM   [CUSTOMSAVERINDLICENSEMS]
                                 WHERE  [ID] = @Id
                                        AND [CUSTOMFIELDID] = @CustomField
                                 UNION
                                 SELECT *
                                 FROM   [CUSTOMSAVERINSPECTIONSMS]
                                 WHERE  [ID] = @Id
                                        AND [CUSTOMFIELDID] = @CustomField
                                 UNION
                                 SELECT *
                                 FROM   [CUSTOMSAVERINVMANAGEMENTMS]
                                 WHERE  [ID] = @Id
                                        AND [CUSTOMFIELDID] = @CustomField
                                 UNION
                                 SELECT *
                                 FROM   [CUSTOMSAVERLICENSEMANAGEMENTMS]
                                 WHERE  [ID] = @Id
                                        AND [CUSTOMFIELDID] = @CustomField
                                 UNION
                                 SELECT *
                                 FROM   [CUSTOMSAVEROBJECTMANAGEMENTMS]
                                 WHERE  [ID] = @Id
                                        AND [CUSTOMFIELDID] = @CustomField
                                 UNION
                                 SELECT *
                                 FROM   [CUSTOMSAVERPERMITMANAGEMENTMS]
                                 WHERE  [ID] = @Id
                                        AND [CUSTOMFIELDID] = @CustomField
                                 UNION
                                 SELECT *
                                 FROM   [CUSTOMSAVERPLANMANAGEMENTMS]
                                 WHERE  [ID] = @Id
                                        AND [CUSTOMFIELDID] = @CustomField
                                 UNION
                                 SELECT *
                                 FROM   [CUSTOMSAVERPROJMANAGEMENTMS]
                                 WHERE  [ID] = @Id
                                        AND [CUSTOMFIELDID] = @CustomField
                                 UNION
                                 SELECT *
                                 FROM   [CUSTOMSAVERPROPMANAGEMENTMS]
                                 WHERE  [ID] = @Id
                                        AND [CUSTOMFIELDID] = @CustomField
                                 UNION
                                 SELECT *
                                 FROM   [CUSTOMSAVERPURMANAGEMENTMS]
                                 WHERE  [ID] = @Id
                                        AND [CUSTOMFIELDID] = @CustomField
                                 UNION
                                 SELECT *
                                 FROM   [CUSTOMSAVERSYSTEMSETUPMS]
                                 WHERE  [ID] = @Id
                                        AND [CUSTOMFIELDID] = @CustomField
                                 UNION
                                 SELECT *
                                 FROM   [CUSTOMSAVERTAXREMMANAGEMENTMS]
                                 WHERE  [ID] = @Id
                                        AND [CUSTOMFIELDID] = @CustomField
                                ) AS [Val]
                         JOIN   [CUSTOMFIELDPICKLISTITEM] [Pick]
                                ON [Pick].[GCUSTOMFIELDPICKLISTITEM] = [Val].[CUSTOMFIELDPICKLISTITEMID]
                         ORDER BY [Pick].[SVALUE]
                        FOR
                         XML PATH('')
                        ), 1, 2, '');

    RETURN @output;
END;
