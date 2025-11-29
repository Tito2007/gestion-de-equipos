# Build stage
FROM mcr.microsoft.com/dotnet/sdk:10.0 AS build
WORKDIR /src

# Copy project file first to leverage Docker layer caching
COPY ["Gestion de equipos web.csproj", "./"]
RUN dotnet restore "./Gestion de equipos web.csproj"

# Copy the rest of the files and publish
COPY . .
# Override AssemblyName to a name without spaces to avoid issues at runtime
RUN dotnet publish "./Gestion de equipos web.csproj" -c Release -o /app/publish --no-restore -p:AssemblyName=Gestion_de_equipos_web

# Runtime stage
FROM mcr.microsoft.com/dotnet/aspnet:10.0 AS final
WORKDIR /app
COPY --from=build /app/publish .

# Listen on port 10000
ENV ASPNETCORE_URLS=http://+:10000
EXPOSE 10000

ENTRYPOINT ["dotnet", "Gestion_de_equipos_web.dll"]
