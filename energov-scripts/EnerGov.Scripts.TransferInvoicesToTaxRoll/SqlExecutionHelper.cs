using System;
using System.Collections.Generic;
using System.Diagnostics;
using System.Linq;
using System.Threading.Tasks;
using Colorify;

namespace EnerGov.Scripts.TransferInvoicesToTaxRoll {

    public static class SqlExecutionHelper {

        private static void WriteExecutingLine(ConsoleManager consoleManager, string name) {
            consoleManager.WriteLineBeginning("Executing SQL Command ");
            consoleManager.Write(name, Colors.txtInfo);
            consoleManager.Write("... ");
        }

        private static void WriteNotExecutingLine(ConsoleManager consoleManager, string name) {
            consoleManager.WriteLineBeginning("Executing SQL Command ");
            consoleManager.Write(name, Colors.txtInfo);
            consoleManager.WriteLineEnding("... Done (Not Executed)");
        }

        private static void WriteDoneExecutingLine(
            ConsoleManager consoleManager, 
            double seconds,
            int? rowCount = null) {

            consoleManager.Write("Done (");
            consoleManager.Write($"{seconds:F3}", Colors.txtPrimary);
            consoleManager.Write("s");
            if (rowCount.HasValue) {
                consoleManager.Write(", ");
                consoleManager.Write($"{rowCount.Value}", Colors.txtPrimary);
                consoleManager.Write(" rows");
            }
            consoleManager.WriteLineEnding(")");

        }

        public static async Task TimeAndExecuteTask(this ConsoleManager consoleManager, string name, Func<Task> task) {
            if (!string.IsNullOrWhiteSpace(name)) {
                WriteExecutingLine(consoleManager, name);
                var stopwatch = new Stopwatch();
                stopwatch.Start();
                await task();
                stopwatch.Stop();
                consoleManager.WriteLineEnding($"Done ({stopwatch.Elapsed.TotalSeconds:F3}s)");
            } else {
                await task();
            }
        }

        public static async Task TimeAndMaybeExecuteTask(
            this ConsoleManager consoleManager,
            string name,
            Func<Task> task,
            bool executeTask) {

            if (!executeTask && !string.IsNullOrWhiteSpace(name)) {
                WriteNotExecutingLine(consoleManager, name);
            } else if (executeTask) {
                await consoleManager.TimeAndExecuteTask(name, task);
            }

        }

        public static async Task<T> TimeAndExecuteTask<T>(this ConsoleManager consoleManager, string name, Func<Task<T>> task) {
            if (!string.IsNullOrWhiteSpace(name)) {
                WriteExecutingLine(consoleManager, name);
                var stopwatch = new Stopwatch();
                stopwatch.Start();
                var result = await task();
                stopwatch.Stop();
                WriteDoneExecutingLine(consoleManager, stopwatch.Elapsed.TotalSeconds);
                return result;
            }

            return await task();
        }

        public static async Task<T> TimeAndMaybeExecuteTask<T>(
            this ConsoleManager consoleManager,
            string name,
            Func<Task<T>> actualTask,
            Func<Task<T>> fakeTask,
            bool executeTask) {

            if (!executeTask && !string.IsNullOrWhiteSpace(name)) {
                WriteNotExecutingLine(consoleManager, name);
            } else if (executeTask) {
                return await consoleManager.TimeAndExecuteTask(name, actualTask);
            }

            return await fakeTask();

        }

        public static async Task<IEnumerable<T>> TimeAndExecuteTask<T>(this ConsoleManager consoleManager, string name, Func<Task<IEnumerable<T>>> task) {
            if (!string.IsNullOrWhiteSpace(name)) {
                WriteExecutingLine(consoleManager, name);
                var stopwatch = new Stopwatch();
                stopwatch.Start();
                var result = await task();
                stopwatch.Stop();
                WriteDoneExecutingLine(consoleManager, stopwatch.Elapsed.TotalSeconds, result?.Count() ?? 0);
                return result;
            }

            return await task();
        }

    }

}