Create view [dbo].[ENERGOVSERVICEERRORVIEW]
as
select top(100) * from GlobalError 
where UserName = 'EnerGov Service'
order by LogDate desc
