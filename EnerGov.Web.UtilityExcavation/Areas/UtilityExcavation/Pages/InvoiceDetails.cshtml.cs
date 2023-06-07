using System;
using System.Collections.Generic;
using System.IO;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using CsvHelper;
using CsvHelper.Configuration;
using EnerGov.Business.UtilityExcavation.EnerGovInvoices;
using EnerGov.Business.UtilityExcavation.UtilityFeeGLAccounts;
using EnerGov.Security.User;
using EnerGov.Web.Common.Infrastructure;
using EnerGov.Web.UtilityExcavation.Helpers;
using MediatR;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;

namespace EnerGov.Web.UtilityExcavation.Areas.UtilityExcavation.Pages {

    [Authorize]
    public class InvoiceDetailsModel : BasePageModel {

        public class GroupedInvoiceFee {

            public UtilityFeeGLAccountDetailedInformation FeeInformation { get; }
            public IEnumerable<FetchAllFeesForInvoiceQuery.ResultFeeItem> Fees { get; }

            public GroupedInvoiceFee(
                UtilityFeeGLAccountDetailedInformation feeInformation,
                IEnumerable<FetchAllFeesForInvoiceQuery.ResultFeeItem> fees) {
                FeeInformation = feeInformation;
                Fees = fees;
            }

        }

        public class JournalEntryLine {

            public string AccountOrg { get; }
            public string AccountObject { get; }
            public string AccountProject { get; }
            public string AccountOrgName { get; }
            public string AccountName { get; }
            public decimal Amount { get; }

            public decimal CreditAmount => Amount > 0.00m ? Amount : 0.00m;
            public decimal DebitAmount => Amount < 0.00m ? Math.Abs(Amount) : 0.00m;

            public JournalEntryLine(
                string accountOrg,
                string accountObject,
                string accountProject,
                string accountOrgName,
                string accountName,
                decimal amount) {
                AccountOrg = accountOrg;
                AccountObject = accountObject;
                AccountProject = accountProject;
                AccountOrgName = accountOrgName;
                AccountName = accountName;
                Amount = amount;
            }

            public JournalEntryLine(
                UtilityFeeGLAccountDetailedInformation.MunisAccount munisAccount,
                decimal amount) {
                AccountOrg = munisAccount.AccountOrgCode;
                AccountObject = munisAccount.AccountObjectCode;
                AccountProject = munisAccount.AccountProjectCode;
                AccountOrgName = munisAccount.OrganizationDescription;
                AccountName = munisAccount.AccountDescription;
                Amount = amount;
            }

            public sealed class JournalEntryLineMap : ClassMap<JournalEntryLine> {

                public JournalEntryLineMap() {
                    Map(_ => _.AccountOrg).Index(0).Name("Account Org");
                    Map(_ => _.AccountObject).Index(1).Name("Account Object");
                    Map(_ => _.AccountProject).Index(2).Name("Account Project");
                    Map(_ => _.AccountOrgName).Index(3).Name("Org Name");
                    Map(_ => _.AccountName).Index(4).Name("Account Name");
                    Map(_ => _.CreditAmount).Index(5).Name("Credit");
                    Map(_ => _.DebitAmount).Index(6).Name("Debit");
                }

            }

        }

        public string InvoiceNumber { get; set; }
        public DateTime InvoiceDate { get; set; }
        public string GlobalEntityName { get; set; }
        public string GlobalEntityFirstName { get; set; }
        public string InvoiceDescription { get; set; }
        public string InvoiceStatus { get; set; }

        public decimal InvoiceTotal { get; set; }
        public decimal InvoicePaid { get; set; }
        public decimal InvoiceAmountDue { get; set; }

        [BindProperty]
        public string InvoiceId { get; set; }

        public IEnumerable<FetchAllFeesForInvoiceQuery.ResultFeeItem> InvoiceFees { get; set; }
        public IEnumerable<GroupedInvoiceFee> GroupedInvoiceFees { get; set; }
        public IEnumerable<JournalEntryLine> JournalEntryLines { get; set; }

        public InvoiceDetailsModel(IMediator mediator, IUserService userService) : base(mediator, userService) { }

        private async Task FetchInvoiceInfo(string invoiceId) {
            InvoiceFees = await Mediator.Send(new FetchAllFeesForInvoiceQuery(invoiceId));

            InvoiceNumber = InvoiceFees.FirstOrDefault()?.InvoiceNumber ?? "";
            InvoiceDate = InvoiceFees.FirstOrDefault()?.InvoiceDate ?? DateTime.Today;
            GlobalEntityName = InvoiceFees.FirstOrDefault()?.GlobalEntityName ?? "";
            GlobalEntityFirstName = InvoiceFees.FirstOrDefault()?.GlobalEntityFirstName ?? "";
            InvoiceDescription = InvoiceFees.FirstOrDefault()?.InvoiceDescription ?? "";
            InvoiceStatus = InvoiceFees.FirstOrDefault()?.InvoiceStatus ?? "";

            InvoiceId = invoiceId;

            var groupedInvoiceFeeKeys = InvoiceFees.GroupBy(_ => (feeId: _.FeeId, pickListItemId: _.PickListItemId));

            var groupedInvoiceFees = new List<GroupedInvoiceFee>();

            foreach (var groupedInvoiceFeeKey in groupedInvoiceFeeKeys) {

                groupedInvoiceFees.Add(new GroupedInvoiceFee(
                    await Mediator.Send(new FetchUtilityFeeGLAccountQuery(
                        Guid.Parse(groupedInvoiceFeeKey.Key.feeId),
                        Guid.Parse(groupedInvoiceFeeKey.Key.pickListItemId))),
                    groupedInvoiceFeeKey.Select(x => x).ToList()));

            }

            GroupedInvoiceFees = groupedInvoiceFees;

            var groupedRevenueCashEntries = GroupedInvoiceFees.GroupBy(_ => _.FeeInformation.RevenueCashAccount).Select(
                _ => new JournalEntryLine(
                    _.Key,
                    _.Sum(x => x.Fees.Sum(y => (y.FeeAmount ?? 0.00m) - (y.PaidAmount ?? 0.00m))) * -1.0m));

            var groupedExpenseCashEntries = GroupedInvoiceFees.GroupBy(_ => _.FeeInformation.ExpenseCashAccount).Select(
                _ => new JournalEntryLine(
                    _.Key,
                    _.Sum(x => x.Fees.Sum(y => (y.FeeAmount ?? 0.00m) - (y.PaidAmount ?? 0.00m))) * 1.0m));

            var groupedRevenueInvoiceEntries = GroupedInvoiceFees.GroupBy(_ => _.FeeInformation.RevenueAccount).Select(
                _ => new JournalEntryLine(
                    _.Key,
                    _.Sum(x => x.Fees.Sum(y => (y.FeeAmount ?? 0.00m) - (y.PaidAmount ?? 0.00m))) * 1.0m));

            var groupedExpenseInvoiceEntries = GroupedInvoiceFees.GroupBy(_ => _.FeeInformation.ExpenseAccount).Select(
                _ => new JournalEntryLine(
                    _.Key,
                    _.Sum(x => x.Fees.Sum(y => (y.FeeAmount ?? 0.00m) - (y.PaidAmount ?? 0.00m))) * -1.0m));

            JournalEntryLines = groupedRevenueInvoiceEntries
                .Concat(groupedExpenseInvoiceEntries)
                .Concat(groupedRevenueCashEntries)
                .Concat(groupedExpenseCashEntries);

            InvoiceTotal = InvoiceFees.Sum(_ => _.FeeAmount ?? 0.00m);
            InvoicePaid = InvoiceFees.Sum(_ => _.PaidAmount ?? 0.00m);
            InvoiceAmountDue = InvoiceTotal - InvoicePaid;

        }

        public async Task OnGetAsync(string invoiceId) {

            await FetchInvoiceInfo(invoiceId);

        }

        public async Task<ActionResult> OnPostJournalEntryFileAsync() {

            await FetchInvoiceInfo(InvoiceId);

            var stream = new MemoryStream();
            var outputWriter = new StreamWriter(stream);

            var csv = new CsvWriter((ISerializer)outputWriter);
            csv.Configuration.RegisterClassMap<JournalEntryLine.JournalEntryLineMap>();
            csv.WriteRecords(JournalEntryLines.ToList());
            outputWriter.Flush();
            return File(stream.ToArray(), "text/csv", $"{InvoiceNumber}.csv");

        }

        public async Task<ActionResult> OnPostJournalImportFileAsync() {

            await FetchInvoiceInfo(InvoiceId);

            var stringBuilder = new StringBuilder();

            foreach (var journalEntryLine in JournalEntryLines) {

                stringBuilder.AppendFixedSize(8, journalEntryLine.AccountOrg);
                stringBuilder.AppendFixedSize(6, journalEntryLine.AccountObject);
                stringBuilder.AppendFixedSize(5, journalEntryLine.AccountProject);
                stringBuilder.AppendFixedSize(35, "");
                stringBuilder.AppendFixedSize(30, $"EnerGov Utility Payment");
                stringBuilder.AppendFixedSize(10, InvoiceNumber);
                stringBuilder.AppendFixedSize(12, "");
                stringBuilder.AppendFixedSize(1, journalEntryLine.Amount > 0.00m ? "C" : "D");
                stringBuilder.AppendFixedSize(13,
                    journalEntryLine.Amount.ToString("F2").Replace(".", "").Replace("-", "").Replace(",", "")
                        .Replace("$", "").PadRight(13));
                stringBuilder.AppendFixedSize(1, "D");
                stringBuilder.AppendFixedSize(13, "000".PadRight(13));
                stringBuilder.AppendFixedSize(1, "A");
                stringBuilder.AppendFixedSize(1, "");
                stringBuilder.AppendFixedSize(43, "");
                stringBuilder.Append("\r\n");

            }

            return File(Encoding.Unicode.GetBytes(stringBuilder.ToString()), "text/plain",
                $"{InvoiceNumber}.txt");

        }

    }

}