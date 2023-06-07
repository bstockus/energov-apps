
-- =============================================
-- Author:		<Kyong Hwangbo, EnerGov Solutions>	
-- Create date: <10/1/2010>
-- Description:	<Created as a script to pull all parcels for a project;
-- Report(s) using this query:
-- ProjectDetails.rpt
-- =============================================

CREATE PROCEDURE [dbo].[rpt_ProjectDetails-Parcels]
AS
BEGIN
	SET NOCOUNT ON;
-- Parcel Info
SELECT PRProjectID, PRProjectParcelID, Main AS IsMainParcel, ParcelNumber
FROM PRProjectParcel 
	LEFT OUTER JOIN Parcel ON PRProjectParcel.ParcelID = Parcel.ParcelID 	
END

