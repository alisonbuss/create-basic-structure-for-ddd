#!/bin/bash

readonly RUN_JQ="./files/jq-linux64-v1.6" && chmod +x $RUN_JQ;

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

function fnRunScript {

    local jsonFile=$(fnGetParameterValue "(--json-file=|-j=)" "$@");
    [ ! -z "$jsonFile" ] || jsonFile="./genesis.projects.json"; # If the value is empty.

    local output=$(fnGetParameterValue "(--output=|-o=)" "$@");
    [ ! -z "$output" ] || output="."; # If the value is empty.

    function fnReadJsonFile() {
        local file="$1";
        local startTime=$(date +'%H:%M:%S');
        local startDate=$(date -u -d "${startTime}" +"%s");
        local projectsSize=$(cat "${file}" | $RUN_JQ ".projects | length");
        # Projects
        for (( a=1; a<=$projectsSize; a++ )); do
            local projectIndex=$(($a-1));
            local projectActive=$(cat "${file}" | $RUN_JQ -r ".projects[${projectIndex}].active");

            # Project Active
            if [ "${projectActive}" == "true" ]; then
                local      projectName=$(cat "${file}" | $RUN_JQ -r ".projects[${projectIndex}].project");
                local projectFramework=$(cat "${file}" | $RUN_JQ -r ".projects[${projectIndex}].framework");
                local      projectPath=$(cat "${file}" | $RUN_JQ -r ".projects[${projectIndex}].output_path");
                local       layersSize=$(cat "${file}" | $RUN_JQ    ".projects[${projectIndex}].layers | length");

                echo "Project: ${projectName}";
                echo "Project active: ${projectActive}";

                # Project -> Layers
                for (( b=1; b<=$layersSize; b++ )); do
                    local layerIndex=$(($b-1));

                    local   layerName=$(cat "${file}" | $RUN_JQ -r ".projects[${projectIndex}].layers[${layerIndex}].layer");
                    local   layerPath=$(cat "${file}" | $RUN_JQ -r ".projects[${projectIndex}].layers[${layerIndex}].layer_path");
                    local subProjSize=$(cat "${file}" | $RUN_JQ    ".projects[${projectIndex}].layers[${layerIndex}].subprojects | length");

                    echo "---> Layer: ${layerName}";

                    # Project -> Layers -> Sub Projects
                    for (( c=1; c<=$subProjSize; c++ )); do
                        local subProjIndex=$(($c-1));

                        local subProjName=$(cat "${file}" | $RUN_JQ -r ".projects[${projectIndex}].layers[${layerIndex}].subprojects[${subProjIndex}].subproject");
                        local subProjType=$(cat "${file}" | $RUN_JQ -r ".projects[${projectIndex}].layers[${layerIndex}].subprojects[${subProjIndex}].type");
                        local foldersSize=$(cat "${file}" | $RUN_JQ    ".projects[${projectIndex}].layers[${layerIndex}].subprojects[${subProjIndex}].folders | length"); 

                        echo "-------> Sub Project: ${subProjName}";
                        echo "-----------> folders:";

                        # Project -> Layers -> Sub Projects -> Folders
                        for (( d=1; d<=$foldersSize; d++ )); do
                            local folderIndex=$(($d-1));
                            local folder=$(cat "${file}" | $RUN_JQ -r ".projects[${projectIndex}].layers[${layerIndex}].subprojects[${subProjIndex}].folders[${folderIndex}]");
                            
                            echo "----------------> ${folder}";
                            
                        done
                    done
                done
            fi
        done

        local endTime=$(date +'%H:%M:%S');
        local endDate=$(date -u -d "${endTime}" +"%s")
        local finalTime=$(date -u -d "0 ${endDate} sec - ${startDate} sec" +"%H:%M:%S");

        echo "The execution of the script lasted for: ${finalTime}";
    }

    fnReadJsonFile "${jsonFile}";
}

# @descr: Call of execution of the script's main function.
fnRunScript "$@" | tee -a "./${0##*/}.log";

# @descr: Finishing the script!!! :P
exit 0;
