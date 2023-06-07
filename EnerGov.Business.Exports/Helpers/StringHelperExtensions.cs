using System;

namespace EnerGov.Business.Exports.Helpers {

    public static class StringHelperExtensions {

        public static string FixedLength(this string value, int length) =>
            value.Substring(0, Math.Min(length, value.Length)).PadRight(length, ' ');

    }

}