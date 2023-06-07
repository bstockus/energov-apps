# My Web App

### Entity Framework Core Migrations

#### Add Migration
_Run from the EnerGov.Web directory:_
```dotnet ef migrations add <MigrationName> -c EnerGov.Data.Configuration.ConfigurationDbContext -p ../EnerGov.Data.Configuration/```

#### Remove Migration
_Run from the EnerGov.Web directory:_
```dotnet ef migrations remove -c EnerGov.Data.Configuration.ConfigurationDbContext -p ../EnerGov.Data.Configuration/```

#### Update Database
_Run from the EnerGov.Web directory:_
```dotnet ef database update -c EnerGov.Data.Configuration.ConfigurationDbContext -p ../EnerGov.Data.Configuration/```

#### Generate Migrations Script
_Run from the EnerGov.Web directory:_
```dotnet ef migrations script -i -c EnerGov.Data.Configuration.ConfigurationDbContext -p ../EnerGov.Data.Configuration/ -o ../Migrations.sql```