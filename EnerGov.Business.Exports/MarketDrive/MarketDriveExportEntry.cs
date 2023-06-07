using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using EnerGov.Business.Exports.Helpers;

namespace EnerGov.Business.Exports.MarketDrive {

    public class MarketDriveExportEntry {

        public string PermitNumber { get; set; }

        public string ParcelNumber { get; set; }

        public string TypeName { get; set; }

        public string ClassName { get; set; }

        public string StatusId { get; set; }

        public DateTime ApplyDate { get; set; }

        public DateTime? ExpireDate { get; set; }

        public DateTime? IssueDate { get; set; }

        public DateTime? FinalizeDate { get; set; }

        public DateTime? LastInspectionDate { get; set; }

        public decimal? Valuation { get; set; }

        public string Description { get; set; }

        public string ToExportFileFormat(IDictionary<string, string> statusMappings) {

            var result = new StringBuilder();

            //1. Permit Number: (#####-####) [11]
            var reversedPermitNumberSections = PermitNumber.Split('-').Reverse().ToArray();
            result.Append($"{reversedPermitNumberSections[1]}-{reversedPermitNumberSections[0]}");

            //2. Parcel Number: (###-0#####-###) [14]
            var splitParcelNumber = ParcelNumber.Split('-').ToArray();
            result.Append(
                $"{splitParcelNumber[0].PadLeft(3, '0')}" +
                $"-0{splitParcelNumber[1].PadLeft(5, '0')}" +
                $"-{splitParcelNumber[2].PadLeft(3, '0')}");

            //3. Type Name: str[50]
            result.Append(TypeName.FixedLength(50));

            //4. Class Name: str[50]
            result.Append(ClassName.FixedLength(50));

            //5. Status Name: str[50]
            if (statusMappings.ContainsKey(StatusId)) {
                result.Append(statusMappings[StatusId].FixedLength(50));
            } else {
                result.Append(new string(' ', 50));
            }

            //6. Apply Date: (YYYY-MM-DD) [10]
            result.Append(ApplyDate.FixedDateFormat());

            //7. Expire Date: (YYYY-MM-DD) or blank [10]
            result.Append(ExpireDate.FixedDateFormat());

            //8. Issue Date: (YYYY-MM-DD) or blank [10]
            result.Append(IssueDate.FixedDateFormat());

            //9. Finalize Date: (YYYY-MM-DD) or blank [10]
            //result.Append(FinalizeDate.FixedDateFormat());
            result.Append(" ".FixedLength(10));

            //10. Last Inspection Date: (YYYY-MM-DD) or blank [10]
            result.Append(LastInspectionDate.FixedDateFormat());

            //11. Valuation: decimal(9,2) or blank [12]
            result
                .Append(Valuation?.ToString("F2")?.PadLeft(12, ' ') ?? new string(' ', 12));

            //12. Description: str[1024]
            result
                .Append((Description ?? "")
                    .Replace('\t', ' ')
                    .Replace('\n', ' ')
                    .Replace('\r', ' ')
                    .FixedLength(1024));

            return result.ToString();

        }

    }

}