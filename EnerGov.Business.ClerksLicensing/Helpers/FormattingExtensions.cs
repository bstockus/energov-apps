using System.Linq;

namespace EnerGov.Business.ClerksLicensing.Helpers; 

public static class FormattingExtensions {

    public static string ReplaceNonNumeric(this string value) =>
        new((value ?? string.Empty).Where(char.IsDigit).ToArray());

    public static string FormatAsTelephoneNumber(this string value) {
        var sanitizedInput = value.Trim().ReplaceNonNumeric();
        if (sanitizedInput.Length == 7) {
            return $"{sanitizedInput[..3]}-{sanitizedInput[3..]}";
        }

        if (sanitizedInput.Length == 10) {
            return $"({sanitizedInput[..3]}) {sanitizedInput[3..6]}-{sanitizedInput[6..]}";
        }

        return sanitizedInput;
    }

    public static string FormatAsZipCode(this string value) {
        var sanitizedInput = value.Trim().ReplaceNonNumeric();

        if (sanitizedInput.Length == 5) {
            return sanitizedInput;
        }

        if (sanitizedInput.Length == 9) {
            return $"{sanitizedInput[..5]}-{sanitizedInput[5..]}";
        }

        return sanitizedInput;
    }

    public static string FormatAsCityName(this string value) =>
        value?.Trim().Replace("TOWN OF ", "").Replace("VILLAGE OF ", "").Replace("CITY OF ", "");

    public static string FormatAsAddress(this string value) =>
        value?.Trim().Replace("TOWN OF ", "").Replace("VILLAGE OF ", "").Replace("CITY OF ", "");


}