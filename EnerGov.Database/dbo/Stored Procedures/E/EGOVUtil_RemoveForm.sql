﻿CREATE Procedure [dbo].[EGOVUtil_RemoveForm]
			output deleted.*
			where fkFormsID = @FormKey
				

			set @mess1 = N'RoleFormsXRef table for ' + @FormName  + 'deleted'

			print @mess1

			delete forms 
			output deleted.*
			where sFormsGUID = @FormKey