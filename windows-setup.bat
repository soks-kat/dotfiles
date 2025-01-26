mklink /J "%LocalAppData%/nvim" "./nvim"

mkdir "%UserProfile%/.config"
mklink /J "%UserProfile%/.config/wezterm" "./wezterm"
mklink /J "%UserProfile%/.config/kanata" "./kanata"

mkdir "%UserProfile%/.glzr"
mklink /J "%UserProfile%/.glzr/glazewm" "./glazewm"
mklink /J "%UserProfile%/.glzr/zebar" "./zebar"
cd "./zebar/nullptr-bar/"
yarn install && yarn build
cd "../../"

cd "./himawari-wallpaper/"
pwsh setup-venv.ps1
pwsh setup-task.ps1
cd "../"

timeout 5

