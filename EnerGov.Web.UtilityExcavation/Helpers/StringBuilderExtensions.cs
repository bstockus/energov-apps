using System.Text;

namespace EnerGov.Web.UtilityExcavation.Helpers {

    public static class StringBuilderExtensions {

        public static void AppendFixedSize(this StringBuilder stringBuilder, int size, string value) {
            if (value.Length == size) {
                stringBuilder.Append(value);
            } else if (value.Length > size) {
                stringBuilder.Append(value.Substring(0, size));
            } else {
                stringBuilder.Append(value.PadRight(size));
            }
        }

    }

}