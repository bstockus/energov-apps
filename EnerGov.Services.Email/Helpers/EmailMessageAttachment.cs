namespace EnerGov.Services.Email.Helpers {

    public class EmailMessageAttachment {

        public string FileName { get; set; }
        public string MimeType { get; set; }
        public byte[] FileContents { get; set; }

    }

}