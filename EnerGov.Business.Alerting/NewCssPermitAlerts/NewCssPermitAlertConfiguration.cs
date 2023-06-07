namespace EnerGov.Business.Alerting.NewCssPermitAlerts {

    public class NewCssPermitAlertConfiguration {
        
        public bool EnableTask { get; set; }

        public bool SendEmails { get; set; }

        public string OverrideEmailAddress { get; set; }

        public string FromAddress { get; set; }

    }

}
