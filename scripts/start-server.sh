#!/bin/bash
#!/bin/bash

timestamp () {
  date +"%Y-%m-%d %H:%M:%S,%3N"
}

echo "---Checking if SteamCMD exist---"
if [ ! -f ${STEAMCMD_DIR}/steamcmd.sh ]; then
  echo "SteamCMD not found!"
  wget -q -O ${STEAMCMD_DIR}/steamcmd_linux.tar.gz http://media.steampowered.com/client/steamcmd_linux.tar.gz 
  tar --directory ${STEAMCMD_DIR} -xvzf /serverdata/steamcmd/steamcmd_linux.tar.gz
  rm ${STEAMCMD_DIR}/steamcmd_linux.tar.gz
else
  echo "SteamCMD found!"
fi

echo "---Update SteamCMD---"
if [ "${USERNAME}" == "" ]; then
  ${STEAMCMD_DIR}/steamcmd.sh \
  +login anonymous \
  +quit
else
  ${STEAMCMD_DIR}/steamcmd.sh \
  +login ${USERNAME} ${PASSWRD} \
  +quit
fi

echo "---Checking if Proton is installed---"
if ! [ -f "${ASTEAM_PATH}/compatibilitytools.d/GE-Proton${GE_PROTON_VERSION}/proton" ]; then
  echo "---Proton not found, installing---"
  mkdir -p "${ASTEAM_PATH}/compatibilitytools.d" 
  mkdir -p "${ASTEAM_PATH}/steamapps/compatdata/${GAME_ID}" 
  mkdir -p "${DATA_DIR}/.steam"
  ln -s "${STEAMCMD_DIR}/linux32" "${DATA_DIR}/.steam/sdk32" 
  ln -s "${STEAMCMD_DIR}/linux64" "${DATA_DIR}/.steam/sdk64" 
  ln -s "${DATA_DIR}/.steam/sdk32/steamclient.so" "${DATA_DIR}/.steam/sdk32/steamservice.so" 
  ln -s "${DATA_DIR}/.steam/sdk64/steamclient.so" "${DATA_DIR}/.steam/sdk64/steamservice.so" 
  if ! [ -f "${DATA_DIR}/GE-Proton${GE_PROTON_VERSION}.tgz" ]; then
     wget "$GE_PROTON_URL" -O "${DATA_DIR}/GE-Proton${GE_PROTON_VERSION}.tgz"
  fi
  tar -x -C "${ASTEAM_PATH}/compatibilitytools.d/" -f "${DATA_DIR}/GE-Proton${GE_PROTON_VERSION}.tgz" && \
  if ! [ -f "${ASTEAM_PATH}/compatibilitytools.d/GE-Proton${GE_PROTON_VERSION}/proton" ]; then
    echo "---Something went wrong, can't find the executable, putting container into sleep mode!---"
    sleep infinity
  fi
else
  echo "---Proton already installed---"
fi

echo "---Update Server---"
if [ "${USERNAME}" == "" ]; then
    if [ "${VALIDATE}" == "true" ]; then
    	echo "---Validating installation---"
        ${STEAMCMD_DIR}/steamcmd.sh \
        +@sSteamCmdForcePlatformType windows \
        +force_install_dir ${SERVER_DIR} \
        +login anonymous \
        +app_update ${GAME_ID} ${GAME_ID_ARGS} validate \
        +quit
    else
        ${STEAMCMD_DIR}/steamcmd.sh \
        +@sSteamCmdForcePlatformType windows \
        +force_install_dir ${SERVER_DIR} \
        +login anonymous \
        +app_update ${GAME_ID} ${GAME_ID_ARGS} \
        +quit
    fi
else
    if [ "${VALIDATE}" == "true" ]; then
    	echo "---Validating installation---"
        ${STEAMCMD_DIR}/steamcmd.sh \
        +@sSteamCmdForcePlatformType windows \
        +force_install_dir ${SERVER_DIR} \
        +login ${USERNAME} ${PASSWRD} \
        +app_update ${GAME_ID} ${GAME_ID_ARGS} validate \
        +quit
    else
        ${STEAMCMD_DIR}/steamcmd.sh \
        +@sSteamCmdForcePlatformType windows \
        +force_install_dir ${SERVER_DIR} \
        +login ${USERNAME} ${PASSWRD} \
        +app_update ${GAME_ID} ${GAME_ID_ARGS} \
        +quit
    fi
fi


echo "---Prepare Server---"
chmod -R ${DATA_PERM} ${DATA_DIR}
cd ${SERVER_DIR}
find . -type f -name "*.dll" -exec cp {} "${SERVER_DIR}/MotorTown/Binaries/Win64/" \;
echo "---Server ready---"


if [ ! -f ${SERVER_DIR}/MotorTown/Binaries/Win64/MotorTownServer-Win64-Shipping.exe ]; then
  echo "---Something went wrong, can't find the executable, putting container into sleep mode!---"
  sleep infinity
else
  echo "---Start Server---"
  cd ${SERVER_DIR}
  ${ASTEAM_PATH}/compatibilitytools.d/GE-Proton${GE_PROTON_VERSION}/proton run ${SERVER_DIR}/MotorTown/Binaries/Win64/MotorTownServer-Win64-Shipping.exe ${GAME_PARAMS}
  
  sleep infinity
  
  echo "$(timestamp) ERROR: He's dead, Jim"
  exit 1
fi