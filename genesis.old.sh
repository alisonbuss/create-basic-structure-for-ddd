#!/bin/bash

readonly DOCUMENTATION="
The genesis.sh is a simple Shell Script for creating .NET Core 
projects on a DDD(Domain-Driven Design) implementation model.

The proposed model is:
.
├── ExampleUsersDDD.sln --> (Solution file)
└── src
    ├── 0 - Presentation
    │   └── ExampleUsersDDD.UI.Web --> (ASP.NET Core Empty Web)
    ├── 1 - Services
    │   ├── ExampleUsersDDD.Service.API --> (ASP.NET Core Web API)
    │   └── ExampleUsersDDD.Service.gRPC --> (ASP.NET Core gRPC Service)
    ├── 2 - Business
    │   └── ExampleUsersDDD.Business --> (Class library)
    ├── 3 - Domain
    │   └── ExampleUsersDDD.Domain --> (Class library)
    └── 4 - Infra
        ├── ExampleUsersDDD.Infra.CrossCutting --> (Class library)
        └── ExampleUsersDDD.Infra.Data --> (Class library)

Usage:  bash genesis.sh [OPTIONS]

Options:
|                               | Descrição                               |
| ----------------------------- | --------------------------------------- |
| --project-name|-p             | - Define the name of the Solution and   |
|                               |   subprojects.                          |
|-------------------------------------------------------------------------|
| --output|-o                   | - Defines the output path of the        |
|                               |   generated project.                    |
|-------------------------------------------------------------------------|
| --help|-help|-h|help          | - Help                                  |
---------------------------------------------------------------------------

Examples:
| HELP------------------------------------------------------------------- |
| $ bash genesis.sh  --help                                               |
|                                                                         |
| RUN-------------------------------------------------------------------- |
| $ bash genesis.sh                                                       |
| ----------------------------------------------------------------------- |
| $ bash genesis.sh --project-name='ExampleUsersDDD' --output='.'         |
---------------------------------------------------------------------------
";

# ########################################### #
# Project variables/constants:
# ########################################### #

# 
PROJECT_NAME="ExampleEmptyProjectDDD";
# 
OUTPUT_PATH=".";

readonly LAYER_PATH="${OUTPUT_PATH}/src";

readonly LAYER_PRESENTATION="0 - Presentation";
readonly LAYER_SERVICE="1 - Services";
readonly LAYER_BUSINESS="2 - Business";
readonly LAYER_DOMAIN="3 - Domain";
readonly LAYER_INFRA="4 - Infra";


# @descr: Function that returns the value of a given parameter in a collection.
# @fonts: https://www.digitalocean.com/community/tutorials/using-grep-regular-expressions-to-search-for-text-patterns-in-linux
function fnGetParameterValue() {
    local exp=$1;
    local params=("$@");
    local valueEnd="";
    for value in "${params[@]:1:$#}"; do
        if grep -E -q "${exp}" <<< "${value}"; then
            valueEnd="${value#*=}";
            break;
        fi
    done
    echo $valueEnd;
}


# @descr: Main function of the script, it runs automatically on the script call.
# @param: 
#    $@ | array: (*)
function fnStartGenesis {

    # @descr: ...
    local NAME=$(fnGetParameterValue "(--project-name=|-p=)" "$@");
    # [ ! -z "$NAME" ] || PROJECT_NAME=$NAME; # If the value is not empty.
    if [ ! -z "$NAME" ]; then # If the value is not empty.
        PROJECT_NAME=$NAME;
    fi

    # @descr: ...
    local OUTPUT=$(fnGetParameterValue "(--output=|-o=)" "$@");
    # [ ! -z "$OUTPUT" ] || OUTPUT_PATH=$OUTPUT; # If the value is not empty.
    if [ ! -z "$OUTPUT" ]; then # If the value is not empty.
        OUTPUT_PATH=$OUTPUT;
    fi
   
    function fnInit() {
    
        echo -e "--> Prints out detailed information about a .NET Core.";
        echo -e "---- PROJECT_NAME: ${PROJECT_NAME}";
        echo -e "---- OUTPUT_PATH.: ${OUTPUT_PATH}";
        echo -e "---- LAYER_PATH.: ${LAYER_PATH} \n";
        dotnet --info;


        # ########################################### #
        # Create Project:
        # ########################################### #

        echo -e "\n--> Create an empty solution containing no project. \n";
        dotnet new sln --name "${PROJECT_NAME}" --output "${OUTPUT_PATH}";


        # Create Layers and Subprojects:

        # ########################################### #
        # Layer 00 - Presentation:
        # ########################################### #

        echo -e "\n--> Creating the layer: [${LAYER_PRESENTATION}] \n";

        # Web
        echo -e "\n--> Creating an subproject: ASP.NET Core Empty Web. \n";
        dotnet new web --name "${PROJECT_NAME}.UI.Web" --no-https true \
            --output "${LAYER_PATH}/${LAYER_PRESENTATION}/${PROJECT_NAME}.UI.Web";

        echo -e "\n--> Adding the subproject(C#) to the solution's root project. \n";
        dotnet sln "${OUTPUT_PATH}/${PROJECT_NAME}.sln" add \
            "${LAYER_PATH}/${LAYER_PRESENTATION}/${PROJECT_NAME}.UI.Web/${PROJECT_NAME}.UI.Web.csproj";

        echo -e "\n--> Creating default packages/folder in the subproject. \n";
        mkdir -p -v "${LAYER_PATH}/${LAYER_PRESENTATION}/${PROJECT_NAME}.UI.Web/Public";


        # ########################################### #
        # Layer 01 - Services:
        # ########################################### #

        echo -e "\n--> Creating the layer: [${LAYER_SERVICE}] \n";

        # Web API
        echo -e "\n--> Creating an subproject: ASP.NET Core Web API. \n";
        dotnet new webapi --name "${PROJECT_NAME}.Service.API" --no-https true \
            --output "${LAYER_PATH}/${LAYER_SERVICE}/${PROJECT_NAME}.Service.API";

        echo -e "\n--> Adding the subproject(C#) to the solution's root project. \n";
        dotnet sln "${OUTPUT_PATH}/${PROJECT_NAME}.sln" add \
            "${LAYER_PATH}/${LAYER_SERVICE}/${PROJECT_NAME}.Service.API/${PROJECT_NAME}.Service.API.csproj";

        echo -e "\n--> Creating default packages/folder in the subproject. \n";
        mkdir -p -v "${LAYER_PATH}/${LAYER_SERVICE}/${PROJECT_NAME}.Service.API/Sources/Controllers";

        # gRPC Service
        echo -e "\n--> Creating an subproject: ASP.NET Core gRPC Service. \n";
        dotnet new grpc --name "${PROJECT_NAME}.Service.gRPC" \
            --output "${LAYER_PATH}/${LAYER_SERVICE}/${PROJECT_NAME}.Service.gRPC";

        echo -e "\n--> Adding the subproject(C#) to the solution's root project. \n";
        dotnet sln "${OUTPUT_PATH}/${PROJECT_NAME}.sln" add \
            "${LAYER_PATH}/${LAYER_SERVICE}/${PROJECT_NAME}.Service.gRPC/${PROJECT_NAME}.Service.gRPC.csproj";

        echo -e "\n--> Creating default packages/folder in the subproject. \n";
        mkdir -p -v "${LAYER_PATH}/${LAYER_SERVICE}/${PROJECT_NAME}.Service.gRPC/Sources/Controllers";


        # ########################################### #
        # Layer 02 - Business:
        # ########################################### #

        echo -e "\n--> Creating the layer: [${LAYER_BUSINESS}] \n";

        echo -e "\n--> Creating an subproject: Class library. \n";
        dotnet new classlib --name "${PROJECT_NAME}.Business" \
            --output "${LAYER_PATH}/${LAYER_BUSINESS}/${PROJECT_NAME}.Business" --framework "netcoreapp3.1";

        echo -e "\n--> Adding the subproject(C#) to the solution's root project. \n";
        dotnet sln "${OUTPUT_PATH}/${PROJECT_NAME}.sln" add \
            "${LAYER_PATH}/${LAYER_BUSINESS}/${PROJECT_NAME}.Business/${PROJECT_NAME}.Business.csproj";

        echo -e "\n--> Creating default packages/folder in the subproject. \n";
        mkdir -p -v "${LAYER_PATH}/${LAYER_BUSINESS}/${PROJECT_NAME}.Business/Sources/Interfaces";
        mkdir -p -v "${LAYER_PATH}/${LAYER_BUSINESS}/${PROJECT_NAME}.Business/Sources/Dtos";


        # ########################################### #
        # Layer 03 - Domain:
        # ########################################### #

        echo -e "\n--> Creating the layer: [${LAYER_DOMAIN}] \n";

        echo -e "\n--> Creating an subproject: Class library. \n";
        dotnet new classlib --name "${PROJECT_NAME}.Domain" \
            --output "${LAYER_PATH}/${LAYER_DOMAIN}/${PROJECT_NAME}.Domain" --framework "netcoreapp3.1";

        echo -e "\n--> Adding the subproject(C#) to the solution's root project. \n";
        dotnet sln "${OUTPUT_PATH}/${PROJECT_NAME}.sln" add \
            "${LAYER_PATH}/${LAYER_DOMAIN}/${PROJECT_NAME}.Domain/${PROJECT_NAME}.Domain.csproj";

        echo -e "\n--> Creating default packages/folder in the subproject. \n";
        mkdir -p -v "${LAYER_PATH}/${LAYER_DOMAIN}/${PROJECT_NAME}.Domain/Sources/Abstracts";
        mkdir -p -v "${LAYER_PATH}/${LAYER_DOMAIN}/${PROJECT_NAME}.Domain/Sources/Abstracts/Datagrid";
        mkdir -p -v "${LAYER_PATH}/${LAYER_DOMAIN}/${PROJECT_NAME}.Domain/Sources/Abstracts/Repository";
        mkdir -p -v "${LAYER_PATH}/${LAYER_DOMAIN}/${PROJECT_NAME}.Domain/Sources/Abstracts/Service";
        mkdir -p -v "${LAYER_PATH}/${LAYER_DOMAIN}/${PROJECT_NAME}.Domain/Sources/Entities";
        mkdir -p -v "${LAYER_PATH}/${LAYER_DOMAIN}/${PROJECT_NAME}.Domain/Sources/Enums";
        mkdir -p -v "${LAYER_PATH}/${LAYER_DOMAIN}/${PROJECT_NAME}.Domain/Sources/Service";


        # ########################################### #
        # Layer 04 - Infra:
        # ########################################### #

        echo -e "\n--> Creating the layer: [${LAYER_INFRA}] \n";

        # InfraData
        echo -e "\n--> Creating an subproject: Class library. \n";
        dotnet new classlib --name "${PROJECT_NAME}.Infra.Data" \
            --output "${LAYER_PATH}/${LAYER_INFRA}/${PROJECT_NAME}.Infra.Data" --framework "netcoreapp3.1";

        echo -e "\n--> Adding the subproject(C#) to the solution's root project. \n";
        dotnet sln "${OUTPUT_PATH}/${PROJECT_NAME}.sln" add \
            "${LAYER_PATH}/${LAYER_INFRA}/${PROJECT_NAME}.Infra.Data/${PROJECT_NAME}.Infra.Data.csproj";

        echo -e "\n--> Creating default packages/folder in the subproject. \n";
        mkdir -p -v "${LAYER_PATH}/${LAYER_INFRA}/${PROJECT_NAME}.Infra.Data/Sources/Context";
        mkdir -p -v "${LAYER_PATH}/${LAYER_INFRA}/${PROJECT_NAME}.Infra.Data/Sources/EntityConfig";
        mkdir -p -v "${LAYER_PATH}/${LAYER_INFRA}/${PROJECT_NAME}.Infra.Data/Sources/Repositories";
        mkdir -p -v "${LAYER_PATH}/${LAYER_INFRA}/${PROJECT_NAME}.Infra.Data/Sources/Migrations";

        # InfraCrossCutting
        echo -e "\n--> Creating an subproject: Class library. \n";
        dotnet new classlib --name "${PROJECT_NAME}.Infra.CrossCutting" \
            --output "${LAYER_PATH}/${LAYER_INFRA}/${PROJECT_NAME}.Infra.CrossCutting" --framework "netcoreapp3.1";

        echo -e "\n--> Adding the subproject(C#) to the solution's root project. \n";
        dotnet sln "${OUTPUT_PATH}/${PROJECT_NAME}.sln" add \
            "${LAYER_PATH}/${LAYER_INFRA}/${PROJECT_NAME}.Infra.CrossCutting/${PROJECT_NAME}.Infra.CrossCutting.csproj";

        echo -e "\n--> Creating default packages/folder in the subproject. \n";
        mkdir -p -v "${LAYER_PATH}/${LAYER_INFRA}/${PROJECT_NAME}.Infra.CrossCutting/Sources/Abstracts";
        mkdir -p -v "${LAYER_PATH}/${LAYER_INFRA}/${PROJECT_NAME}.Infra.CrossCutting/Sources/IoC";
        mkdir -p -v "${LAYER_PATH}/${LAYER_INFRA}/${PROJECT_NAME}.Infra.CrossCutting/Sources/Map";

        # dotnet restore;
        # dotnet build "${OUTPUT_PATH}/${PROJECT_NAME}.sln";
    }

    # @descr: ...
    function fnHelp() {
        echo "${DOCUMENTATION}";
    }

    case "$@" in
        *--help*|*-help*|*-h*|*help*) {
            fnHelp; 
        };;
        *) {
            fnInit; 
        };;
    esac
    
}

# @descr: Call of execution of the script's main function.
fnStartGenesis "$@" | tee -a "./${0##*/}.log";

# @descr: Finishing the script!!! :P
exit 0;
