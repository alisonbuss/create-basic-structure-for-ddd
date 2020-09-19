#!/bin/bash

readonly RUN_JQ="./files/jq-linux64-v1.6" && chmod +x $RUN_JQ;

readonly DOCUMENTATION="
The genesis.sh is a simple Shell Script for creating .NET Core 
projects on a DDD(Domain-Driven Design) implementation model.

The proposed model is:
.
├── ExampleEmptyProjectDDD.sln --> (Solution file)
└── src
    ├── 1 - Presentation
    │   └── ExampleEmptyProjectDDD.UI.Web --> (ASP.NET Core Empty Web)
    ├── 2 - Services
    │   ├── ExampleEmptyProjectDDD.Service.API --> (ASP.NET Core Web API)
    │   └── ExampleEmptyProjectDDD.Service.gRPC --> (ASP.NET Core gRPC Service)
    ├── 3 - Application
    │   └── ExampleEmptyProjectDDD.Application --> (Class library)
    ├── 4 - Domain
    │   └── ExampleEmptyProjectDDD.Domain --> (Class library)
    └── 5 - Infra
        ├── ExampleEmptyProjectDDD.Infra.CrossCutting --> (Class library)
        └── ExampleEmptyProjectDDD.Infra.Data --> (Class library)

Usage:  bash genesis.sh [OPTIONS]

Options:
|                               | Descrição                               |
| ----------------------------- | --------------------------------------- |
| --json-file|-j                | - Set the json file to generate the     |
|                               |   DDD projects.                         |
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
| $ bash genesis.sh --json-file='./genesis.projects.json'                 |
---------------------------------------------------------------------------
";

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

    # @descr: Set the json file to generate the DDD projects.
    local JSON_FILE=$(fnGetParameterValue "(--json-file=|-j=)" "$@");
    if [ -z "$JSON_FILE" ]; then # If the value is empty.
        JSON_FILE="./genesis.projects.json";
    fi

    function fnCreateSolution() {
        local name="$1";
        local output="$2";

        echo -e "\n--> Create an empty solution containing no project. \n";

        dotnet new sln --name "${name}" --output "${output}";
    }

    function fnCreateProjectWeb() {
        local name="$1";
        local output="$2";

        echo -e "\n--> Creating an subproject: ASP.NET Core Empty Web. \n";

        dotnet new web --name "${name}" --no-https true --output "${output}";
    }

    function fnCreateProjectWebAPI() {
        local name="$1";
        local output="$2";
        
        echo -e "\n--> Creating an subproject: ASP.NET Core Web API. \n";

        dotnet new webapi --name "${name}" --no-https true --output "${output}";
    }

    function fnCreateProjectGRPC() {
        local name="$1";
        local output="$2";
        
        echo -e "\n--> Creating an subproject: ASP.NET Core gRPC Service. \n";

        dotnet new grpc --name "${name}" --output "${output}";
    }

    function fnCreateProjectClassLib() {
        local name="$1";
        local output="$2";
        
        echo -e "\n--> Creating an subproject: Class library. \n";

        dotnet new classlib --name "${name}" --output "${output}" --framework "netcoreapp3.1";
    }

    function fnAddProjectToSolution() {
        local solutionFile="$1";
        local projectFile="$2";
        local solutionFolder="$3";
        
        echo -e "\n--> Adding the subproject(C#) to the solution's root project. \n";

        dotnet sln "${solutionFile}" add "${projectFile}" --solution-folder "${solutionFolder}";
    }

    function fnRestoreProject() {
        local solutionFile="$1";
        
        echo -e "\n--> Restores the dependencies and tools of a project. \n";

        dotnet restore "${solutionFile}";
    }

    function fnReadJsonFile() {
        local jsonFile="$1";

        local startTime=$(date +'%H:%M:%S');
        local startDate=$(date -u -d "${startTime}" +"%s");

        # Projects
        local projectsSize=$(cat "${jsonFile}" | $RUN_JQ ".projects | length");
        for (( a=1; a<=$projectsSize; a++ )); do
            local projectIndex=$(($a-1));
            local projectActive=$(cat "${jsonFile}" | $RUN_JQ -r ".projects[${projectIndex}].active");

            # Project Active
            if [ "${projectActive}" == "true" ]; then
                local      projectName=$(cat "${jsonFile}" | $RUN_JQ -r ".projects[${projectIndex}].project");
                local projectFramework=$(cat "${jsonFile}" | $RUN_JQ -r ".projects[${projectIndex}].framework");
                local      projectPath=$(cat "${jsonFile}" | $RUN_JQ -r ".projects[${projectIndex}].output_path");
                local       layersSize=$(cat "${jsonFile}" | $RUN_JQ    ".projects[${projectIndex}].layers | length");

                fnCreateSolution "${projectName}" "${projectPath}";

                # Project -> Layers
                for (( b=1; b<=$layersSize; b++ )); do
                    local layerIndex=$(($b-1));
                    local   layerName=$(cat "${jsonFile}" | $RUN_JQ -r ".projects[${projectIndex}].layers[${layerIndex}].layer");
                    local   layerPath=$(cat "${jsonFile}" | $RUN_JQ -r ".projects[${projectIndex}].layers[${layerIndex}].layer_path");
                    local subProjSize=$(cat "${jsonFile}" | $RUN_JQ    ".projects[${projectIndex}].layers[${layerIndex}].subprojects | length");

                    # Project -> Layers -> Sub Projects
                    for (( c=1; c<=$subProjSize; c++ )); do
                        local subProjIndex=$(($c-1));
                        local subProjName=$(cat "${jsonFile}" | $RUN_JQ -r ".projects[${projectIndex}].layers[${layerIndex}].subprojects[${subProjIndex}].subproject");
                        local subProjType=$(cat "${jsonFile}" | $RUN_JQ -r ".projects[${projectIndex}].layers[${layerIndex}].subprojects[${subProjIndex}].type");
                        local foldersSize=$(cat "${jsonFile}" | $RUN_JQ    ".projects[${projectIndex}].layers[${layerIndex}].subprojects[${subProjIndex}].folders | length"); 

                        echo -e "\n--> Creating the layer: [${layerName}] \n";

                        case "${subProjType}" in
                            web) {
                                fnCreateProjectWeb "${subProjName}" "${projectPath}/${layerPath}/${subProjName}";
                            };;
                            webapi) {
                                fnCreateProjectWebAPI "${subProjName}" "${projectPath}/${layerPath}/${subProjName}";
                            };;
                            grpc) {
                                fnCreateProjectGRPC "${subProjName}" "${projectPath}/${layerPath}/${subProjName}"; 
                            };;
                            classlib) {
                                fnCreateProjectClassLib "${subProjName}" "${projectPath}/${layerPath}/${subProjName}"; 
                            };;
                        esac

                        fnAddProjectToSolution \
                            "${projectPath}/${projectName}.sln" \
                            "${projectPath}/${layerPath}/${subProjName}/${subProjName}.csproj" \
                            "${layerName}";

                        # Project -> Layers -> Sub Projects -> Folders
                        for (( d=1; d<=$foldersSize; d++ )); do
                            local folderIndex=$(($d-1));
                            local folder=$(cat "${jsonFile}" | $RUN_JQ -r ".projects[${projectIndex}].layers[${layerIndex}].subprojects[${subProjIndex}].folders[${folderIndex}]");
                            
                            mkdir -p -v "${projectPath}/${layerPath}/${subProjName}/${folder}";
                        done
                    done
                done

                fnRestoreProject "${projectPath}/${projectName}.sln";
            fi
        done 

        local endTime=$(date +'%H:%M:%S');
        local endDate=$(date -u -d "${endTime}" +"%s")
        local finalTime=$(date -u -d "0 ${endDate} sec - ${startDate} sec" +"%H:%M:%S");

        echo -e "\nThe execution of the script lasted for: ${finalTime}";
    }

    function fnInit() {
        echo -e "--> Prints out detailed information about a .NET Core. \n";
        dotnet --info;

        fnReadJsonFile "${JSON_FILE}";
    }

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
