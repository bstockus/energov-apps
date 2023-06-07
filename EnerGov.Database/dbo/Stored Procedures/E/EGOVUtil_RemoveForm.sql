CREATE Procedure [dbo].[EGOVUtil_RemoveForm](	@FormName						nvarchar(250))AsDeclare @FormKey	uniqueidentifierDeclare @mess1		nvarchar(50)Declare @mess2		nvarchar(50)  		Begin      Begin			Select @FormKey = sFormsGUID			From Forms			Where Upper(sFormName) = Upper(@FormName)											End		Begin														    delete from RoleFormsXRef
			output deleted.*
			where fkFormsID = @FormKey
				

			set @mess1 = N'RoleFormsXRef table for ' + @FormName  + 'deleted'

			print @mess1

			delete forms 
			output deleted.*
			where sFormsGUID = @FormKey										set @mess2 = N'forms ' + @FormName  + 'deleted'			print @mess2					EndEnd