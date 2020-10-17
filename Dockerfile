#See https://aka.ms/containerfastmode to understand how Visual Studio uses this Dockerfile to build your images for faster debugging.

FROM mcr.microsoft.com/dotnet/core/aspnet:3.1-buster-slim AS base
WORKDIR /root/jenkins/core
EXPOSE 8099

FROM mcr.microsoft.com/dotnet/core/sdk:3.1-buster AS build
WORKDIR /root/jenkins/core
COPY ["WebApplication2.csproj", ""]
RUN dotnet restore "./WebApplication2.csproj"
COPY . .
WORKDIR "/root/jenkins/core/."
RUN dotnet build "WebApplication2.csproj" -c Release -o /root/jenkins/core/build

FROM build AS publish
RUN dotnet publish "WebApplication2.csproj" -c Release -o /root/jenkins/core/publish

FROM base AS final
WORKDIR /root/jenkins/core
COPY --from=publish /root/jenkins/core/publish .
ENTRYPOINT ["dotnet", "WebApplication2.dll"]