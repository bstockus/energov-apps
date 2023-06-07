CREATE PROCEDURE [dbo].[RAPIDRENEWALUNPAIDFEES]
@currentid char(36)
as
begin
	declare @parentid char(36)
	declare @tempid as table( ID char(36) )
	while (@currentid is not null)
	begin
		set @parentid = (
		select top 1 BLLICENSEPARENTID from BLLICENSE
		where BLLICENSEID = @currentid)

		insert into @tempid values (@parentid)
	
		set @currentid = @parentid
	end

	select cf.CACOMPUTEDFEEID, l.LICENSENUMBER, l.BLLICENSEID, l.TAXYEAR from @tempid t
	join BLLICENSE l
	on l.BLLICENSEID = t.ID
	join BLLICENSEFEE lf
	on lf.BLLICENSEID = t.ID
	join CACOMPUTEDFEE cf
	on lf.CACOMPUTEDFEEID = cf.CACOMPUTEDFEEID 
	where (cf.COMPUTEDAMOUNT - cf.AMOUNTPAIDTODATE) > 0
end