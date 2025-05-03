# 🚀 SteamCMD in Docker optimized for Unraid
This Docker container installs SteamCMD and downloads the game specified via environment variables. It is optimized for use with Unraid but should also work in other environments with Docker.

> 🧩 This container is designed to work seamlessly with the **[Docker Compose Manager](https://forums.unraid.net/topic/114415-plugin-docker-compose-manager/)** plugin for Unraid, which allows you to easily manage Docker Compose projects from the Unraid web interface.

## 🛠️ Example Env params for **Motor Town: Behind The Wheel** 
| Name | Value | Example |
| --- | --- | --- |
| GAME_ID | The GAME_ID that the container downloads at startup. | 2223650 |
| GAME_ID_ARGS | Additional args to pass the steamcmd client (i.e. for betas) | -beta test -betapassword motortowndedi |
| GAME_PARAMS | Values to start the server | Jeju_World?listen? -server -log -useperfthreads |
| STEAM_USERNAME | This game need an account with the game, leave blank for anonymous login. | steamuser |
| STEAM_PASSWORD | This game need an account with the game, leave blank for anonymous login. | steampassword |
| STEAMCMD_DIR | Folder for SteamCMD | /serverdata/steamcmd |
| SERVER_DIR | Folder for gamefile | /serverdata/serverfiles |
| UID | User Identifier | 99 |
| GID | Group Identifier | 100 |
| VALIDATE | Validates the game data | blank |

> 💡 **Note:** The environment variables shown above should be set in a `.env` file.  
> You can start by copying the provided `.env.example` to `.env` and then customizing the values as needed.

## 📦 Usage Example
1. Clone the repository:
    ```bash
    cd /mnt/user/appdata/<folderWithDocker>
    git clone <this repo>
    cd motortowndedi
    ```

2. Copy and configure the environment variables:
    ```bash
    cp .env.example .env
    ```

3. Run the container from the Unraid terminal:
    ```bash
    docker compose up -d
    ```

> 💡 **Note:** Make sure the **Docker Compose Manager** plugin is installed in Unraid so you can also manage this container visually through the Unraid web UI if preferred.

## 🔎 Notes
- Make sure ports are correctly forwarded in Unraid.
- Steam Guard codes may require interactive login using the container shell. (This could probably use a rework).
- The `.env` file is already in the `.gitignore` so the changes will not be reflected if you update the repository.


## 🙏 Credits
This Docker is forked from sazquatch17, mattieserver, ich777, nodiaque, thank you for this wonderfull Docker.
