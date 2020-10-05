FROM mcr.microsoft.com/dotnet/core/sdk:3.1 AS build
WORKDIR /source

# copy csproj and restore as distinct layers
COPY *.sln .
COPY WAISistemas/*.csproj ./WAISistemas/
RUN dotnet restore

# copy everything else and build app
COPY WAISistemas/. ./WAISistemas/
WORKDIR /source/WAISistemas
RUN dotnet publish -c release -o /app --no-restore

# final stage/image
FROM mcr.microsoft.com/dotnet/core/aspnet:3.1
WORKDIR /app
COPY --from=build /app ./
ENTRYPOINT ["dotnet", "WAISistemas.dll"]
