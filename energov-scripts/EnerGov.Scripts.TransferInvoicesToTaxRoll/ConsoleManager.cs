using System;
using System.CommandLine;
using System.Linq;
using Colorify;
using Colorify.UI;
using ToolBox.Platform;

namespace EnerGov.Scripts.TransferInvoicesToTaxRoll {

    public class ConsoleManager {


        private readonly IConsole _console;
        private readonly Format _colorify;

        public int ScopeLevel { get; private set; } = 0;

        public ConsoleManager(IConsole console) {
            _console = console;
            switch (OS.GetCurrent()) {
                case "win":
                case "gnu":
                    _colorify = new Format(Theme.Dark);
                    break;
                case "mac":
                    _colorify = new Format(Theme.Light);
                    break;
            }
            _colorify.ResetColor();
            _colorify.Clear();
        }

        public void BeginScope(string text = null, string color = Colors.bgPrimary) {
            if (!string.IsNullOrWhiteSpace(text)) {
                WriteLine(text, color);
            }
            ScopeLevel++;
        }

        public void EndScope(int number = 1) {
            if (ScopeLevel - number < 0) {
                throw new Exception("Console Manager scope level attempting to end scope with a negative level");
            }

            ScopeLevel -= number;
        }

        private string WhitespaceForScopeLevel() =>
            Enumerable.Repeat("  ", ScopeLevel).Aggregate("", (s, s1) => s + s1);

        public void WriteLine(string text, string color = Colors.txtMuted) {
            var parsedString = text.Replace(Environment.NewLine, WhitespaceForScopeLevel());
            _colorify.Write(WhitespaceForScopeLevel());
            _colorify.Write(parsedString, color);
            _colorify.Write(Environment.NewLine);
        }

        public void WriteLineBeginning(string text, string color = Colors.txtMuted) {
            var parsedString = text.Replace(Environment.NewLine, WhitespaceForScopeLevel());
            _colorify.Write(WhitespaceForScopeLevel());
            _colorify.Write(parsedString, color);
        }

        public void WriteLineEnding(string text, string color = Colors.txtMuted) {
            var parsedString = text.Replace(Environment.NewLine, WhitespaceForScopeLevel());
            _colorify.Write(parsedString, color);
            _colorify.Write(Environment.NewLine);
        }

        public void Write(string text, string color = Colors.txtMuted) {
            var parsedString = text.Replace(Environment.NewLine, WhitespaceForScopeLevel());
            _colorify.Write(parsedString, color);
        }

    }

}