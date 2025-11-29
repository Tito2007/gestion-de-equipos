# Build stage
FROM mcr.microsoft.com/dotnet/sdk:10.0 AS build
WORKDIR /src

# Copy only the .csproj to leverage Docker layer caching (context is repo root)
COPY ["Gestion de equipos web/Gestion de equipos web.csproj", "Gestion de equipos web/Gestion de equipos web.csproj"]
RUN dotnet restore "Gestion de equipos web/Gestion de equipos web.csproj"

# Copy the rest of the project files
COPY ["Gestion de equipos web", "Gestion de equipos web"]
WORKDIR "/src/Gestion de equipos web"

# Publish with assembly name without spaces to avoid runtime issues
RUN dotnet publish "Gestion de equipos web.csproj" -c Release -o /app/publish --no-restore -p:AssemblyName=Gestion_de_equipos_web

# Runtime stage
FROM mcr.microsoft.com/dotnet/aspnet:10.0 AS final
WORKDIR /app
COPY --from=build /app/publish .

# Listen on port 10000
ENV ASPNETCORE_URLS=http://+:10000
EXPOSE 10000

ENTRYPOINT ["dotnet", "Gestion_de_equipos_web.dll"]
