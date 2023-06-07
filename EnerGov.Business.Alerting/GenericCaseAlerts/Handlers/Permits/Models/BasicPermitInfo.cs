namespace EnerGov.Business.Alerting.GenericCaseAlerts.Handlers.Permits.Models {

    public class BasicPermitInfo {

        public string PermitId { get; set; }
        public int RowVersion { get; set; }
        public string PermitStatusId { get; set; }
        public string PermitTypeId { get; set; }
        public string PermitWorkClassId { get; set; }

    }

}