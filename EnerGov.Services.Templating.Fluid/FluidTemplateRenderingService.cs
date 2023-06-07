using System;
using System.IO;
using System.Linq;
using System.Reflection;
using System.Threading.Tasks;
using Fluid;
using Fluid.Parser;

namespace EnerGov.Services.Templating.Fluid {

    public class FluidTemplateRenderingService : ITemplateRenderingService {

        public async Task<string> GenerateAsync(Assembly assembly, string resourceName, object model, Type[] additionalTypesToWhitelist = null) {
            var fullResourceName = assembly
                .GetManifestResourceNames()
                .Single(str => str.EndsWith(resourceName));

            string templateText;

            await using (var stream = assembly.GetManifestResourceStream(fullResourceName)) {

                if (stream == null) {
                    throw new NullReferenceException("Stream was null");
                }

                using var streamReader = new StreamReader(stream);
                templateText = await streamReader.ReadToEndAsync();
            }

            var parser = new FluidParser();


            if (!parser.TryParse(templateText, out var template, out var errors)) {
                throw new Exception($"Error while parsing the template. {errors.Aggregate("", (x, y) => $"{x}; {y}")}");
            }

            var options = new TemplateOptions();

            options.MemberAccessStrategy.Register(model.GetType());

            if (additionalTypesToWhitelist != null) {
                foreach (var type in additionalTypesToWhitelist) {
                    options.MemberAccessStrategy.Register(type);
                }
            }

            var context = new TemplateContext(options);

            context.SetValue("model", model);

            return await template.RenderAsync(context);

        }

        public async Task<string> GenerateAsync(string templateText, object model,
            Type[] additionalTypesToWhitelist = null) {

            var parser = new FluidParser();

            if (!parser.TryParse(templateText, out var template, out var errors)) {
                throw new Exception($"Error while parsing the template. {errors.Aggregate("", (x, y) => $"{x}; {y}")}");
            }

            var options = new TemplateOptions();

            options.MemberAccessStrategy.Register(model.GetType());

            if (additionalTypesToWhitelist != null) {
                foreach (var type in additionalTypesToWhitelist) {
                    options.MemberAccessStrategy.Register(type);
                }
            }

            var context = new TemplateContext();

            context.SetValue("model", model);

            return await template.RenderAsync(context);

        }

    }

}