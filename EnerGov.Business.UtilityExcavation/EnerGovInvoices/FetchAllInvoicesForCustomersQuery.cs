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
    public class
        FetchAllInvoicesForCustomersQuery : IRequest<
            IEnumerable<FetchAllInvoicesForCustomersQuery.ResultInvoiceItem>> {

        public bool IncludeAllInvoices { get; }
        public Guid[] CustomerIds { get; }

        public FetchAllInvoicesForCustomersQuery(bool includeAllInvoices, params Guid[] customerIds) {
            IncludeAllInvoices = includeAllInvoices;
            CustomerIds = customerIds;
        }

        public FetchAllInvoicesForCustomersQuery(params Guid[] customerIds) : this(false, customerIds) { }

        public class ResultInvoiceItem {

            public ResultInvoiceItem() { }

            public ResultInvoiceItem(
                string invoiceId,
                string invoiceNumber,
                string globalEntityId,
                decimal? invoiceTotal,
                DateTime invoiceDate,
                decimal? amountDue,
                decimal? paidAmount,
                string status,
                string invoiceDescription) {

                InvoiceId = invoiceId;
                InvoiceNumber = invoiceNumber;
                GlobalEntityId = globalEntityId;
                InvoiceTotal = invoiceTotal;
                InvoiceDate = invoiceDate;
                AmountDue = amountDue;
                PaidAmount = paidAmount;
                Status = status;
                InvoiceDescription = invoiceDescription;
            }

            public string InvoiceId { get; }
            public string InvoiceNumber { get; }
            public string GlobalEntityId { get; }
            public decimal? InvoiceTotal { get; }
            public DateTime InvoiceDate { get; }
            public decimal? AmountDue { get; }
            public decimal? PaidAmount { get; }
            public string Status { get; }
            public string InvoiceDescription { get; }

        }



        public class Handler : IRequestHandler<FetchAllInvoicesForCustomersQuery, IEnumerable<ResultInvoiceItem>> {

            private readonly ISqlServerConnectionProvider<EnerGovSqlServerConnection>
                _enerGovSqlServerConnectionProvider;

            public Handler(
                ISqlServerConnectionProvider<EnerGovSqlServerConnection> enerGovSqlServerConnectionProvider) {
                _enerGovSqlServerConnectionProvider = enerGovSqlServerConnectionProvider;
            }

            public async Task<IEnumerable<ResultInvoiceItem>> Handle(FetchAllInvoicesForCustomersQuery request,
                CancellationToken cancellationToken) =>
                await (await _enerGovSqlServerConnectionProvider.GetSqlServerConnectionAsync(cancellationToken))
                    .QueryAsync<ResultInvoiceItem>(@"
                        SELECT
                          cai.CAINVOICEID AS InvoiceId,
                          cai.INVOICENUMBER AS InvoiceNumber,
                          cai.GLOBALENTITYID AS GlobalEntityId,
                          cai.INVOICETOTAL AS InvoiceTotal,
                          cai.INVOICEDATE AS InvoiceDate,
                          ISNULL((SELECT SUM(cacf.COMPUTEDAMOUNT - caif.PAIDAMOUNT)
                            FROM dbo.CAINVOICEFEE caif
                            INNER JOIN dbo.CACOMPUTEDFEE cacf ON caif.CACOMPUTEDFEEID = cacf.CACOMPUTEDFEEID
                            WHERE caif.CAINVOICEID = cai.CAINVOICEID AND cacf.ISDELETED = 0), 0) +
                          ISNULL((SELECT SUM(camf.AMOUNT - camf.PAIDAMOUNT)
                            FROM dbo.CAINVOICEMISCFEE caimf
                            INNER JOIN dbo.CAMISCFEE camf ON caimf.CAMISCFEEID = camf.CAMISCFEEID
                            WHERE caimf.CAINVOICEID = cai.CAINVOICEID), 0) AS AmountDue,
                          ISNULL((SELECT SUM(caif.PAIDAMOUNT)
                            FROM dbo.CAINVOICEFEE caif
                            INNER JOIN dbo.CACOMPUTEDFEE cacf ON caif.CACOMPUTEDFEEID = cacf.CACOMPUTEDFEEID
                            WHERE caif.CAINVOICEID = cai.CAINVOICEID AND cacf.ISDELETED = 0), 0) +
                          ISNULL((SELECT SUM(camf.PAIDAMOUNT)
                            FROM dbo.CAINVOICEMISCFEE caimf
                            INNER JOIN dbo.CAMISCFEE camf ON caimf.CAMISCFEEID = camf.CAMISCFEEID
                            WHERE caimf.CAINVOICEID = cai.CAINVOICEID), 0) AS PaidAmount,
                          cas.NAME AS Status,
                          cai.INVOICEDESCRIPTION InvoiceDescription
                        FROM dbo.CAINVOICE cai
                        INNER JOIN dbo.CASTATUS cas ON cai.CASTATUSID = cas.CASTATUSID
                        WHERE cai.CASTATUSID IN @Statuses AND cai.GLOBALENTITYID IN @GlobalEntityIds",
                        new {
                            GlobalEntityIds = request.CustomerIds,
                            Statuses = request.IncludeAllInvoices
                                ? new[] {1, 2, 3, 4, 5, 6, 7, 8, 9, 10}
                                : new[] {1, 2, 3, 6, 7, 8}
                        });

        }

    }

}