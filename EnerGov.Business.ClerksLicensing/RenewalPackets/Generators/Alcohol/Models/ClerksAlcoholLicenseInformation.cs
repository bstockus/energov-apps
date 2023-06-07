namespace EnerGov.Business.ClerksLicensing.RenewalPackets.Generators.Alcohol.Models;

public class ClerksAlcoholLicenseInformation {

    public decimal? ClassABeerFee { get; }
    public decimal? ClassBBeerFee { get; }
    public decimal? ClassCWineFee { get; }
    public decimal? ClassALiquorFee { get; }
    public bool ClassALiquorCiderOnly { get; }
    public decimal? ClassBLiquorFee { get; }
    public decimal? ReserveClassBLiquorFee { get; }
    public decimal? ClassBWineOnlyWineryFee { get; }
    public decimal PublicationFee { get; }

    public ClerksAlcoholLicenseInformation(
        decimal? classABeerFee,
        decimal? classBBeerFee,
        decimal? classCWineFee,
        decimal? classALiquorFee,
        bool classALiquorCiderOnly,
        decimal? classBLiquorFee,
        decimal? reserveClassBLiquorFee,
        decimal? classBWineOnlyWineryFee,
        decimal publicationFee) {
        ClassABeerFee = classABeerFee;
        ClassBBeerFee = classBBeerFee;
        ClassCWineFee = classCWineFee;
        ClassALiquorFee = classALiquorFee;
        ClassALiquorCiderOnly = classALiquorCiderOnly;
        ClassBLiquorFee = classBLiquorFee;
        ReserveClassBLiquorFee = reserveClassBLiquorFee;
        ClassBWineOnlyWineryFee = classBWineOnlyWineryFee;
        PublicationFee = publicationFee;
    }

}