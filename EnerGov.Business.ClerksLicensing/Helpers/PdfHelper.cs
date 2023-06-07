using System.IO;
using iText.Kernel.Pdf;

namespace EnerGov.Business.ClerksLicensing.Helpers; 

public static class PdfHelper {

    public static int AppendPagesFromPdf(byte[] pdfData, PdfDocument destination) {
        using var ms = new MemoryStream(pdfData);
        var pdfDoc = new PdfDocument(new PdfReader(ms));
        var pageCount = pdfDoc.GetNumberOfPages();
        pdfDoc.CopyPagesTo(1, pageCount, destination);
        pdfDoc.Close();

        return pageCount;
    }

    public static int GetPageCount(byte[] pdfData) {
        using var ms = new MemoryStream(pdfData);
        var pdfDoc = new PdfDocument(new PdfReader(ms));
        var numberOfPages = pdfDoc.GetNumberOfPages();
        pdfDoc.Close();
        return numberOfPages;
    }

}