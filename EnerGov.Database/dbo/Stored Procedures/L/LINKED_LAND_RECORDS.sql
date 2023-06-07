CREATE PROCEDURE [dbo].[LINKED_LAND_RECORDS]
	@ENTITY_ID as char(36)
AS

BEGIN
		-- This is to get parcel with address info for land record. If the parcel is never attached to any records, it isn't in mailing address and we execute 2nd query in that scenario to get
		-- the address information of that parcel.
		WITH PARCELS as (select  PARCEL.PARCELID, PARCEL.PARCELNUMBER, SUBDIVISION, BLOCK, LOT, addr.ADDRESSLINE1, addr.PREDIRECTION, addr.ADDRESSLINE2, addr.ADDRESSLINE3, 
		addr.POSTDIRECTION, addr.STREETTYPE, addr.UNITORSUITE, addr.city,addr.STATE,addr.POSTALCODE from PARCEL
		INNER JOIN MAILINGADDRESS addr on PARCEL.PARCELID = addr.PARCELID
		INNER JOIN PARCELADDRESS praddr on addr.ADDRESSID = praddr.ADDRESSID
		where PARCEL.PARCELNUMBER = @ENTITY_ID)
		select * from PARCELS
		UNION ALL
		select p.PARCELID, p.PARCELNUMBER, SUBDIVISION, BLOCK, LOT, pa.ADDRESSLINE1, pa.PREDIRECTION, pa.ADDRESSLINE2, pa.ADDRESSLINE3, 
		pa.POSTDIRECTION, pa.STREETTYPE, pa.UNITORSUITE, pa.city,pa.STATE,pa.POSTALCODE from PARCEL p 
		INNER JOIN PARCELADDRESS pa on p.PARCELID = pa.PARCELID
		where p.PARCELNUMBER = @ENTITY_ID AND (select count(*) from PARCELS) = 0
END
