


CREATE PROCEDURE [dbo].[PMO_AUDIT_REPORT_SYS_TABLE_SIZES]
AS

IF OBJECT_ID('tempdb..#Results') IS NOT NULL
    DROP TABLE #Results

create table #Results (tname sysname, RemainingSize int );

declare @tname sysname, @ret int
insert into #Results
select name, 0 from sysobjects where type = 'u' and name like '%customsa%' order by name;

select @tname = min(tname) from #Results
while @tname is not null
BEGIN
   exec @ret = PMO_AUDIT_REPORT_FN_AVAILABLE_TABLEROWSIZE @tname
   update #results
   set RemainingSize = @ret
   where tname = @tname
   
   select @tname = min(tname) from #Results where tname > @tname
END

select * 
from #results 
where RemainingSize <= '1000'
order by remainingsize 
    
IF OBJECT_ID('tempdb..#Results') IS NOT NULL
    DROP TABLE #Results

