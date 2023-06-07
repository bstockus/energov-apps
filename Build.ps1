Remove-Item .\out -Recurse -Force

dotnet clean .\EnerGov.sln


Set-Location EnerGov.Web
npm install
npm run gulp min
dotnet publish .\EnerGov.Web.csproj -c Release -p:UseAppHost=false -o .\..\out