using System;
using System.IO;
using System.Linq;
using System.Threading;
using System.Threading.Tasks;
using Dapper;
using EnerGov.Data.TCM;
using Lax.Business.Bus.Logging;
using Lax.Data.Sql.SqlServer;
using MediatR;
using SixLabors.ImageSharp;
using SixLabors.ImageSharp.Metadata.Profiles.Exif;
using SixLabors.ImageSharp.Processing;

namespace EnerGov.Business.TcmIntegration;

[LogRequest]
public class FetchTcmDocumentAsImageQuery: IRequest<byte[]> {

    public string DocumentId { get; }
    public int ReizeWidth { get; }

    public FetchTcmDocumentAsImageQuery(
        string documentId,
        int reizeWidth) {
        DocumentId = documentId;
        ReizeWidth = reizeWidth;
    }

    public class Handler : IRequestHandler<FetchTcmDocumentAsImageQuery, byte[]> {

        private readonly ISqlServerConnectionProvider<TcmSqlServerConnection> _tcmSqlServerConnectionProvider;

        public Handler(
            ISqlServerConnectionProvider<TcmSqlServerConnection> tcmSqlServerConnectionProvider) {

            _tcmSqlServerConnectionProvider = tcmSqlServerConnectionProvider;
        }

        public async Task<byte[]> Handle(
            FetchTcmDocumentAsImageQuery request,
            CancellationToken cancellationToken) {

            var tcmConnection = await _tcmSqlServerConnectionProvider.GetSqlServerConnectionAsync(cancellationToken);

            var documentInfo = await tcmConnection.QueryFirstOrDefaultAsync<DocumentInfo>(
                new CommandDefinition(
                    @"SELECT TOP 100
                            docs.DocumentId AS DocumentId,
                            docs.DocumentTitle AS DocumentTitle,
                            docData2.DocumentData AS DocumentData
                        FROM Document docs
                        INNER JOIN DocumentData2 docData2 ON docs.DocumentId = docData2.DocumentID
                        WHERE docs.DocumentFormat = 'application/mpdoc' AND docs.DocumentId LIKE @DocumentId + '.%'",
                    new {
                        DocumentId = request.DocumentId
                    },
                    cancellationToken: cancellationToken));

            if (documentInfo is not {DocumentData: { }}) {
                return null;
            }

            using var image = Image.Load(documentInfo.DocumentData.Skip(12).ToArray());
            image.Mutate(_ => _.Resize(request.ReizeWidth, 0, KnownResamplers.Lanczos3));
            
            image.Metadata.ExifProfile.SetValue<ushort>(ExifTag.Orientation, 1);

            using var memoryStream = new MemoryStream();

            await image.SaveAsJpegAsync(memoryStream, cancellationToken);

            return memoryStream.ToArray();


        }

    }

}