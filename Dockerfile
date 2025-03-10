# Base image for runtime
FROM mcr.microsoft.com/dotnet/aspnet:8.0-alpine AS base
WORKDIR /app
EXPOSE 80
EXPOSE 443

# Install required dependencies
RUN apk add --no-cache libgcc libstdc++ ca-certificates bash gcompat

# Use SteamCMD Alpine image to extract SteamCMD binaries
FROM steamcmd/steamcmd:alpine AS steamcmd

# Build stage
FROM mcr.microsoft.com/dotnet/sdk:8.0-alpine AS build
WORKDIR /src
COPY "Zeepkist.GTR.Backend.csproj" .
RUN dotnet restore
COPY . .
RUN dotnet build -c Release -o /app/build

# Publish stage
FROM build AS publish
RUN dotnet publish -c Release -o /app/publish

# Final runtime image
FROM base AS final
WORKDIR /app
COPY --from=publish /app/publish .

# Copy SteamCMD files from the steamcmd stage
COPY --from=steamcmd /usr/lib/games/steam /usr/lib/games/steam
COPY --from=steamcmd /usr/bin/steamcmd /usr/bin/steamcmd

# Add healthcheck
# HEALTHCHECK --interval=5s --timeout=3s --retries=3 CMD curl --fail http://localhost/healthcheck || exit 1

ENTRYPOINT ["dotnet", "TNRD.Zeepkist.GTR.Backend.dll"]
