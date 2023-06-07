using System.Threading;
using System.Threading.Tasks;
using EnerGov.Business.TcmIntegration;
using MediatR;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;

namespace EnerGov.Web.Controllers;

public class TcmIntegrationController : Controller {

    private readonly IMediator _mediator;

    public TcmIntegrationController(
        IMediator mediator) {

        _mediator = mediator;
    }


    [HttpGet("~/TcmIntegration/FetchTcmDocumentAsImage")]
    [ApiExplorerSettings(IgnoreApi = true)]
    [AllowAnonymous]
    public async Task<ActionResult> FetchTcmDocumentAsImage(
        string docId,
        int width,
        CancellationToken cancellationToken) {
        var imageResult = await _mediator.Send(new FetchTcmDocumentAsImageQuery(docId, width), cancellationToken);

        if (imageResult == null) {
            return NotFound();
        }

        return File(imageResult, "image/jpeg");
    }

}