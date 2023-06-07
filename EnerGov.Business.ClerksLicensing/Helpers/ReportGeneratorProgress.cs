namespace EnerGov.Business.ClerksLicensing.Helpers; 

public class ReportGeneratorProgress {

    public int ProgressPercentage { get; }
    public string TextMessage { get; }

    public ReportGeneratorProgress(int progressPercentage, string textMessage) {
        ProgressPercentage = progressPercentage;
        TextMessage = textMessage;
    }

}