namespace EnerGov.Business.Alerting.GenericCaseAlerts.Handlers.Permits.Models {

    public class BasicPermitInvoiceInfo {

        public string PermitId { get; set; }
        public int RowVersion { get; set; }
        public string InvoiceId { get; set; }
        public int InvoiceStatusId { get; set; }
        public string PermitTypeId { get; set; }
        public string PermitWorkClassId { get; set; }

    }

}