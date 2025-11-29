# Usa la imagen del SDK de .NET para construir el proyecto
FROM mcr.microsoft.com/dotnet/sdk:8.0 AS build
WORKDIR /app

# Cambia el nombre del directorio para eliminar espacios
COPY "Gestion de equipos web" "app-src"

# Copia el archivo .csproj y restaura las dependencias
WORKDIR /app/app-src
RUN dotnet restore "Gestion de equipos web.csproj"

# Copia el resto de los archivos del proyecto
COPY . .
WORKDIR "/app/app-src"

# Publica la aplicación para producción
RUN dotnet publish "Gestion de equipos web.csproj" -c Release -o /app/publish

# Usa la imagen de ASP.NET Core runtime para ejecutar la aplicación (es más ligera)
FROM mcr.microsoft.com/dotnet/aspnet:8.0 AS final
WORKDIR /app
COPY --from=build /app/publish .

# Expone el puerto que Render usará
EXPOSE 10000

# Define el comando para iniciar la aplicación
ENTRYPOINT ["dotnet", "Gestion de equipos web.dll"]
