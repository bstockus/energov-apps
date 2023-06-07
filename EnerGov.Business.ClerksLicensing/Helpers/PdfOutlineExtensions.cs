using iText.Kernel.Pdf;
using iText.Kernel.Pdf.Action;
using iText.Kernel.Pdf.Navigation;

namespace EnerGov.Business.ClerksLicensing.Helpers; 

public static class PdfOutlineExtensions {

    public static PdfOutline AddOutlineActionToPage(this PdfOutline outline, PdfDocument pdfDoc, string title, int pageNumber) {
        var bookmark = outline.AddOutline(title);
        bookmark.AddAction(
            PdfAction.CreateGoTo(
                PdfExplicitDestination.CreateFitH(
                    pdfDoc.GetPage(pageNumber),
                    pdfDoc.GetPage(pageNumber).GetPageSize().GetTop()
                )));
        return bookmark;
    }

}