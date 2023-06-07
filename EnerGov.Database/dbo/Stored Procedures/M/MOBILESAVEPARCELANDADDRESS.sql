CREATE PROCEDURE MOBILESAVEPARCELANDADDRESS
@parcelID char(36),
@parcelNumber varchar(100),
@parcelAddressID char(36),
@name1 varchar(100),
@name2 varchar(100),
@addressline1 varchar(500),
@addressline2 varchar(500),
@city varchar(50),
@state varchar(50),
@postalCode varchar(15),
@legalDescription varchar(500)
AS
BEGIN

IF NOT EXISTS (SELECT PARCELID FROM PARCEL WHERE PARCELNUMBER = @parcelNumber)
	BEGIN
	INSERT INTO PARCEL (PARCELID, PARCELNUMBER, LEGALDESCRIPTION, NAME1, NAME2,ADDRESSLINE1, ADDRESSLINE2, CITY, STATE, POSTALCODE, ACTIVE)
		VALUES (@parcelID, @parcelNumber, @legalDescription, @name1, @name2, @addressline1, @addressline2, @city, @state, @postalCode,1)
	END
ELSE
	BEGIN
	UPDATE PARCEL SET LEGALDESCRIPTION = @legalDescription, NAME1 = @name1, NAME2 = @name2, ADDRESSLINE1=@addressline1,
	ADDRESSLINE2 =@addressline2, CITY=@city,  STATE= @state, POSTALCODE= @postalCode WHERE PARCELNUMBER =@parcelNumber;
	SELECT @parcelID = (SELECT PARCELID FROM PARCEL WHERE PARCELNUMBER = @parcelNumber)
	END
	
IF NOT EXISTS (SELECT ADDRESSID FROM PARCELADDRESS WHERE PARCELID =@parcelID)
BEGIN
	INSERT INTO PARCELADDRESS (ADDRESSID,PARCELID, ADDRESSLINE1, ADDRESSLINE2, CITY, STATE, POSTALCODE)
		VALUES (@parcelAddressID ,@parcelID,@addressline1, @addressline2, @city, @state, @postalCode)
END
ELSE 
	BEGIN
	UPDATE PARCELADDRESS SET ADDRESSLINE1=@addressline1,
	ADDRESSLINE2 =@addressline2, CITY=@city,  STATE= @state, POSTALCODE= @postalCode WHERE PARCELNUMBER =@parcelNumber;
	SELECT @parcelAddressID = (SELECT ADDRESSID FROM PARCELADDRESS WHERE PARCELNUMBER = @parcelNumber)
	END

SELECT TOP 1 PARCELID, ADDRESSID  FROM PARCELADDRESS WHERE PARCELID = @parcelID
END
