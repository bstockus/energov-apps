

Create view [dbo].[ENERGOVLAST100ERRORVIEW]
as
select top(100) * from GlobalError 
order by LogDate desc