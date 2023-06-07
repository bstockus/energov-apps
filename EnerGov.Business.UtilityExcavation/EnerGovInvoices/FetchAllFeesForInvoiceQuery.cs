using System;
using System.Collections.Generic;
using System.Threading;
using System.Threading.Tasks;
using Dapper;
using EnerGov.Data.EnerGov;
using Lax.Business.Bus.Logging;
using Lax.Data.Sql.SqlServer;
using MediatR;

namespace EnerGov.Business.UtilityExcavation.EnerGovInvoices {

    [LogRequest]
    public class FetchAllFeesForInvoiceQuery : IRequest<IEnumerable<FetchAllFeesForInvoiceQuery.ResultFeeItem>> {

        public string InvoiceId { get; }

        public class ResultFeeItem {

            public string FeeId { get; }
            public string PickListItemId { get; }
            public decimal? FeeAmount { get; }
            public decimal? PaidAmount { get; }
            public string InvoiceNumber { get; }
            public DateTime InvoiceDate { get; }
            public string InvoiceDescription { get; }
            public string GlobalEntityName { get; }
            public string GlobalEntityFirstName { get; }
            public string PermitNumber { get; }
            public string PermitDescription { get; }
            public DateTime? PermitApplyDate { get; }
            public DateTime? PermitFinalizeDate { get; }
            public string TypeOfWork { get; }
            public decimal? InputValue { get; }
            public string InputValueName { get; }
            public string FeeName { get; }
            public string InvoiceStatus { get; }
            public string FeeStatus { get; }

            public ResultFeeItem() { }

            public ResultFeeItem(
                string feeId,
                string pickListItemId,
                decimal? feeAmount,
                decimal? paidAmount,
                string invoiceNumber,
                DateTime invoiceDate,
                string invoiceDescription,
                string globalEntityName,
                string globalEntityFirstName,
                string permitNumber,
                string permitDescription,
                DateTime? permitApplyDate,
                DateTime? permitFinalizeDate,
                string typeOfWork,
                decimal? inputValue,
                string inputValueName,
                string feeName,
                string invoiceStatus,
                string feeStatus) {
                FeeId = feeId;
                PickListItemId = pickListItemId;
                FeeAmount = feeAmount;
                PaidAmount = paidAmount;
                InvoiceNumber = invoiceNumber;
                InvoiceDate = invoiceDate;
                InvoiceDescription = invoiceDescription;
                GlobalEntityName = globalEntityName;
                GlobalEntityFirstName = globalEntityFirstName;
                PermitNumber = permitNumber;
                PermitDescription = permitDescription;
                PermitApplyDate = permitApplyDate;
                PermitFinalizeDate = permitFinalizeDate;
                TypeOfWork = typeOfWork;
                InputValue = inputValue;
                InputValueName = inputValueName;
                FeeName = feeName;
                InvoiceStatus = invoiceStatus;
                FeeStatus = feeStatus;
            }

        }

        public FetchAllFeesForInvoiceQuery(string invoiceId) {
            InvoiceId = invoiceId;
        }

        public class Handler : IRequestHandler<FetchAllFeesForInvoiceQuery, IEnumerable<ResultFeeItem>> {

            private readonly ISqlServerConnectionProvider<EnerGovSqlServerConnection> _enerGovSqlServerConnectionProvider;

            public Handler(
                ISqlServerConnectionProvider<EnerGovSqlServerConnection> enerGovSqlServerConnectionProvider) {
                _enerGovSqlServerConnectionProvider = enerGovSqlServerConnectionProvider;
            }

            public async Task<IEnumerable<ResultFeeItem>> Handle(FetchAllFeesForInvoiceQuery request,
                CancellationToken cancellationToken) =>
                await (await _enerGovSqlServerConnectionProvider.GetSqlServerConnectionAsync(cancellationToken))
                    .QueryAsync<ResultFeeItem>(@"
                        SELECT
                          caf.CAFEEID AS FeeId,
                          cspm.UtilityPurposeOfExcavation AS PickListItemId,
                          cacf.COMPUTEDAMOUNT AS FeeAmount,
                          caif.PAIDAMOUNT AS PaidAmount,
                          cai.INVOICENUMBER AS InvoiceNumber,
                          cai.INVOICEDATE AS InvoiceDate,
                          cai.INVOICEDESCRIPTION AS InvoiceDescription,
                          ge.GLOBALENTITYNAME AS GlobalEntityName,
                          ge.FIRSTNAME AS GlobalEntityFirstName,
                          pmp.PERMITNUMBER AS PermitNumber,
                          pmp.DESCRIPTION AS PermitDescription,
                          pmp.APPLYDATE AS PermitApplyDate,
                          pmp.FINALIZEDATE AS PermitFinalizeDate,
                          cfpli.SVALUE AS TypeOfWork,
                          cacf.DISPLAYINPUTVALUE AS InputValue,
                          (SELECT TOP 1
                              cafs.COMPUTATIONVALUENAME
                            FROM CAFEESETUP cafs
                            INNER JOIN CASCHEDULE cas ON cafs.CASCHEDULEID = cas.CASCHEDULEID
                            WHERE cafs.CAFEEID = caf.CAFEEID) AS InputValueName,
                          caf.NAME AS FeeName,
                          cas_inv.NAME AS InvoiceStatus,
                          cas_fee.NAME AS FeeStatus
                        FROM CAINVOICEFEE caif
                        INNER JOIN CAINVOICE cai ON caif.CAINVOICEID = cai.CAINVOICEID
                        INNER JOIN GLOBALENTITY ge ON cai.GLOBALENTITYID = ge.GLOBALENTITYID
                        INNER JOIN CACOMPUTEDFEE cacf ON caif.CACOMPUTEDFEEID = cacf.CACOMPUTEDFEEID
                        INNER JOIN CAFEETEMPLATEFEE caftf ON cacf.CAFEETEMPLATEFEEID = caftf.CAFEETEMPLATEFEEID
                        INNER JOIN CAFEE caf ON caftf.CAFEEID = caf.CAFEEID
                        INNER JOIN PMPERMITFEE pmpf ON cacf.CACOMPUTEDFEEID = pmpf.CACOMPUTEDFEEID
                        INNER JOIN PMPERMIT pmp ON pmpf.PMPERMITID = pmp.PMPERMITID
                        INNER JOIN CUSTOMSAVERPERMITMANAGEMENT cspm ON pmp.PMPERMITID = cspm.ID
                        INNER JOIN CUSTOMFIELDPICKLISTITEM cfpli ON cspm.UtilityPurposeOfExcavation = cfpli.GCUSTOMFIELDPICKLISTITEM
                        INNER JOIN CASTATUS cas_inv ON cai.CASTATUSID = cas_inv.CASTATUSID
                        INNER JOIN CASTATUS cas_fee ON cacf.CASTATUSID = cas_fee.CASTATUSID
                        WHERE caif.CAINVOICEID = @InvoiceId AND cacf.ISDELETED = 0",
                        new {
                            InvoiceId = request.InvoiceId
                        });

        }

    }

}