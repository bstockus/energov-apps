using System;
using System.Linq;

namespace EnerGov.Business.ClerksLicensing.Validation.Models; 

public static class StringHelperExtensions {

    public static string IndentString(this string input, int indentLevel) {

        var indentString = "";
        for (int i = 0; i < indentLevel; i++) {
            indentString += " ";
        }

        var splits = input.Split(Environment.NewLine).Select(_ => $"{indentString}{_}").ToList();

        return (splits.FirstOrDefault() ?? "") + splits.Skip(1).Aggregate("", (s, s1) => s + Environment.NewLine + s1);

    }

    public static string ToBooleanString(this bool input) => input ? "Yes" : "No";

}