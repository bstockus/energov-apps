

CREATE PROCEDURE [dbo].[rpt_Contact_Detail_Report_Accounts]
@GLOBALENTITYID as varchar(36)
AS
SELECT     GlobalEntityAccount.Name, GlobalEntityAccount.Description, GlobalEntityAccount.AccountNumber, GlobalEntityAccount.Balance, 
                      GlobalEntityAccountType.TypeName AS [Account Type], GlobalEntityAccountEntity.GlobalEntityAccountID
FROM         GlobalEntityAccount INNER JOIN
                      GlobalEntityAccountType ON GlobalEntityAccount.GlobalEntityAccountTypeID = GlobalEntityAccountType.GlobalEntityAccountTypeID INNER JOIN
                      GlobalEntityAccountEntity ON GlobalEntityAccount.GlobalEntityAccountID = GlobalEntityAccountEntity.GlobalEntityAccountID
WHERE GlobalEntityAccountEntity.GlobalEntityID = @GLOBALENTITYID

