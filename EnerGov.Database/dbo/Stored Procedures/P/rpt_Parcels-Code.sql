


-- =============================================
-- Author:		Kyong Hwangbo, EnerGov Solutions
-- Create date: 9/29/2010
-- Description:	This stored procedure pulls all parcels for a Code case
-- Report using this stored proc:  
-- "Notice of Violation"
-- =============================================
create PROCEDURE [dbo].[rpt_Parcels-Code]

AS
BEGIN

	SET NOCOUNT ON;


SELECT     CMCodeCaseParcel.CMCodeCaseID, CMCodeCaseParcel.[Primary] AS IsMainParcel
	, Parcel.ParcelID, Parcel.ParcelNumber
FROM       CMCodeCaseParcel INNER JOIN
                      Parcel ON CMCodeCaseParcel.ParcelID = Parcel.ParcelID
    
    
                      
END





