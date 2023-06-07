using System;

namespace EnerGov.Business.Exports.Helpers {

    public static class DateTimeHelperExtensions {

        public static string FixedDateFormat(this DateTime value) =>
            value.ToString("yyyy-MM-dd");

        public static string FixedDateFormat(this DateTime? value) =>
            value?.ToString("yyyy-MM-dd") ?? new string(' ', 10);

    }

}