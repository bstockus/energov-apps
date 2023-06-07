CREATE VIEW INSPECTIONCONTACTTYPEVIEW
AS
SELECT        CONTACTTYPEID, NAME
FROM            (SELECT        CONTACTTYPEID, NAME 
                          FROM            dbo.CONTACTTYPE AS CONTACTTYPE_1
                          UNION ALL
                          SELECT        LANDMANAGEMENTCONTACTTYPEID, NAME 
                          FROM            dbo.LANDMANAGEMENTCONTACTTYPE
                          UNION ALL
                          SELECT        CMCODECASECONTACTTYPEID, NAME 
                          FROM            dbo.CMCODECASECONTACTTYPE
                          UNION ALL
                          SELECT        BLCONTACTTYPEID, NAME 
                          FROM            dbo.BLCONTACTTYPE
                          UNION ALL
                          SELECT        RPCONTACTTYPEID, NAME
                          FROM            dbo.RPCONTACTTYPE) AS CONTACTTYPE