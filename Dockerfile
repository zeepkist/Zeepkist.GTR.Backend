FROM mcr.microsoft.com/dotnet/aspnet:8.0-alpine AS base
WORKDIR /app
EXPOSE 80
EXPOSE 443

# Install curl and libgcc
RUN apk add --no-cache curl libgcc libstdc++ ca-certificates bash gcompat

RUN curl -sqL "https://steamcdn-a.akamaihd.net/client/installer/steamcmd_linux.tar.gz" | tar zxvf - -C /usr/local/bin

FROM mcr.microsoft.com/dotnet/sdk:8.0-alpine AS build
WORKDIR /src
COPY "Zeepkist.GTR.Backend.csproj" .
RUN dotnet restore
COPY . .
WORKDIR /src
RUN dotnet build -c Release -o /app/build

FROM build AS publish
WORKDIR "/src"
RUN dotnet publish -c Release -o /app/publish

FROM base AS final
WORKDIR /app
COPY --from=publish /app/publish .

# Add healthcheck
#HEALTHCHECK --interval=5s --timeout=3s --retries=3 CMD curl --fail http://localhost/healthcheck || exit 1

ENTRYPOINT ["dotnet", "TNRD.Zeepkist.GTR.Backend.dll"]
