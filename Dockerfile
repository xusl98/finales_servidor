FROM mcr.microsoft.com/dotnet/core/sdk:3.1 AS build
WORKDIR /source

# copy csproj and restore as distinct layers
COPY *.sln .
COPY WACAereo/*.csproj ./WACAereo/
RUN dotnet restore

# copy everything else and build app
COPY WACAereo/. ./WACAereo/
WORKDIR /source/WACAereo
RUN dotnet publish -c release -o /app --no-restore

# final stage/image
FROM mcr.microsoft.com/dotnet/core/aspnet:3.1
WORKDIR /app
COPY --from=build /app ./
ENTRYPOINT ["dotnet", "WACAereo.dll"]
