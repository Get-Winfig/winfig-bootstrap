# ====================================================================== #
# UTF-8 with BOM Encoding for output
# ====================================================================== #

if ($PSVersionTable.PSVersion.Major -eq 5) {
    $OutputEncoding = [System.Text.Encoding]::UTF8
    [Console]::OutputEncoding = [System.Text.Encoding]::UTF8
    [Console]::InputEncoding = [System.Text.Encoding]::UTF8
} else {
    $utf8WithBom = New-Object System.Text.UTF8Encoding $true
    $OutputEncoding = $utf8WithBom
    [Console]::OutputEncoding = $utf8WithBom
}

# ====================================================================== #
#  Script Metadata
# ====================================================================== #

$Script:WinfigMeta = @{
    Author       = "Armoghan-ul-Mohmin"
    CompanyName  = "Get-Winfig"
    Description  = "Windows configuration and automation framework"
    Version     = "1.0.0"
    License     = "MIT"
    Platform    = "Windows"
    PowerShell  = $PSVersionTable.PSVersion.ToString()
}

# ====================================================================== #
#  Color Palette
# ====================================================================== #

$Script:WinfigColors = @{
    Primary   = "Blue"
    Success   = "Green"
    Info      = "Cyan"
    Warning   = "Yellow"
    Error     = "Red"
    Accent    = "Magenta"
    Light     = "White"
    Dark      = "DarkGray"
}

# ====================================================================== #
# User Prompts
# ====================================================================== #

$Script:WinfigPrompts = @{
    Confirm    = "[?] Do you want to proceed? (Y/N): "
    Retry      = "[?] Do you want to retry? (Y/N): "
    Abort      = "[!] Operation aborted by user."
    Continue   = "[*] Press any key to continue..."
}

# ====================================================================== #
#  Paths
# ====================================================================== #

$Global:WinfigPaths = @{
    Desktop         = [Environment]::GetFolderPath("Desktop")
    Documents       = [Environment]::GetFolderPath("MyDocuments")
    UserProfile     = [Environment]::GetFolderPath("UserProfile")
    Temp            = [Environment]::GetEnvironmentVariable("TEMP")
    AppDataRoaming  = [Environment]::GetFolderPath("ApplicationData")
    AppDataLocal    = [Environment]::GetFolderPath("LocalApplicationData")
    Downloads       = [System.IO.Path]::Combine([Environment]::GetFolderPath("UserProfile"), "Downloads")
    Logs            = [System.IO.Path]::Combine([Environment]::GetEnvironmentVariable("TEMP"), "Winfig-Logs")
}

# ====================================================================== #
# Start Time, Resets, Counters
# ====================================================================== #
$Global:WinfigLogStart = Get-Date
$Global:WinfigLogFilePath = $null
Remove-Variable -Name WinfigLogFilePath -Scope Global -ErrorAction SilentlyContinue
Remove-Variable -Name LogCount -Scope Global -ErrorAction SilentlyContinue
Remove-Variable -Name ErrorCount -Scope Global -ErrorAction SilentlyContinue
Remove-Variable -Name WarnCount -Scope Global -ErrorAction SilentlyContinue
$Script:RemovedCount = 0
$Script:NotFoundCount = 0
$Script:ErrorCount = 0

# ===================================================================== #
#  App List to remove
# ===================================================================== #
$Script:AppList = @(
    @{packageName="Microsoft.549981C3F5F10"; displayName="Cortana"}
    @{packageName="MicrosoftWindows.Client.WebExperience"; displayName="Widgets"}
    @{packageName="Microsoft.GetHelp"; displayName="Get Help"}
    @{packageName="Microsoft.BingWeather"; displayName="Weather"}
    @{packageName="Microsoft.BingNews"; displayName="News"}
    @{packageName="Microsoft.Todos"; displayName="Microsoft To Do"}
    @{packageName="Microsoft.MicrosoftSolitaireCollection"; displayName="Solitaire Collection"}
    @{packageName="Microsoft.WindowsFeedbackHub"; displayName="Feedback Hub"}
    @{packageName="Microsoft.MicrosoftOfficeHub"; displayName="Office Hub"}
    @{packageName="Microsoft.PowerAutomateDesktop"; displayName="Power Automate Desktop"}
    @{packageName="Microsoft.Microsoft3DViewer"; displayName="3D Viewer"}
    @{packageName="Microsoft.SkypeApp"; displayName="Skype"}
    @{packageName="Microsoft.Getstarted"; displayName="Tips App"}
    @{packageName="Microsoft.Office.OneNote"; displayName="OneNote for Windows 10"}
    @{packageName="Microsoft.MicrosoftStickyNotes"; displayName="Sticky Notes"}
    @{packageName="SpotifyAB.SpotifyMusic"; displayName="Spotify"}
    @{packageName="Disney.37853FC22B2CE"; displayName="Disney+"}
    @{packageName="Microsoft.XboxApp"; displayName="Xbox Console Companion"}
    @{packageName="Microsoft.MixedReality.Portal"; displayName="Mixed Reality Portal"}
    @{packageName="Clipchamp.Clipchamp"; displayName="Clipchamp"}
    @{packageName="MicrosoftCorporationII.QuickAssist"; displayName="Quick Assist"}
    @{packageName="MicrosoftTeams"; displayName="Microsoft Teams (Personal)"}
    @{packageName="MSTeams"; displayName="Microsoft Teams"}
    @{packageName="Microsoft.GamingApp"; displayName="Xbox Gaming App"}
    @{packageName="MicrosoftCorporationII.MicrosoftFamily"; displayName="Microsoft Family"}
    @{packageName="Microsoft.Windows.DevHome"; displayName="Dev Home"}
    @{packageName="Microsoft.OutlookForWindows"; displayName="Outlook (New)"}
    @{packageName="Microsoft.6365217CE6EB4"; displayName="Microsoft Security"}
    @{packageName="Microsoft.WidgetsPlatformRuntime"; displayName="Widgets Platform Runtime"}
    @{packageName="Microsoft.BingSearch"; displayName="Bing Search"}
    @{packageName="Microsoft.StartExperiencesApp"; displayName="Start Experiences App"}
    @{packageName="Microsoft.MicrosoftPCManager"; displayName="Microsoft PC Manager"}
    @{packageName="Microsoft.WindowsMaps"; displayName="Maps"}
    @{packageName="Microsoft.WindowsAlarms"; displayName="Alarms & Clock"}
    @{packageName="Microsoft.People"; displayName="People"}
    @{packageName="Microsoft.XboxIdentityProvider"; displayName="Xbox Identity Provider"}
    @{packageName="Microsoft.XboxSpeechToTextOverlay"; displayName="Xbox Speech To Text Overlay"}
    @{packageName="Microsoft.XboxGameOverlay"; displayName="Xbox Game Overlay"}
    @{packageName="Microsoft.Xbox.TCUI"; displayName="Xbox Live in-game experience"}
    @{packageName="Facebook.317180B0BB486"; displayName="Instagram"}
    @{packageName="7EE7776C.LinkedInforWindows"; displayName="LinkedIn"}
    @{packageName="Microsoft.ZuneVideo"; displayName="Movies & TV"}
    @{packageName="Microsoft.ZuneMusic"; displayName="Groove Music"}
    @{packageName="Microsoft.GetStarted"; displayName="Get Started"}
    @{packageName="Microsoft.Wallet"; displayName="Microsoft Pay"}
    @{packageName="Microsoft.OneConnect"; displayName="Mobile Plans"}
    @{packageName="Microsoft.Messaging"; displayName="Microsoft Messaging"}
    @{packageName="Microsoft.WindowsFeedback"; displayName="Feedback Hub"}
    @{packageName="Microsoft.ScreenSketch"; displayName="Snip & Sketch"}
    @{packageName="Microsoft.Windows.ScreenSketch"; displayName="Snipping Tool"}
)

# ====================================================================== #
# List of Registry Keys, Names, Description, Value and Type
# ====================================================================== #
$Script:RegList = @(
    @{key = "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Themes\Personalize"; name = "AppsUseLightTheme"; description = "Enable Dark Mode for Apps"; value = 0; type = "DWORD"}
    @{key = "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Themes\Personalize"; name = "SystemUsesLightTheme"; description = "Enable Dark Mode for System"; value = "0"; type = "DWORD"}
    @{key = "HKCU:\Software\Microsoft\Windows\CurrentVersion\Search"; name = "BingSearchEnabled"; description = "Disable Bing Search in Start Menu"; value = "0"; type = "DWORD"}
    @{key = "HKCU:\Software\Microsoft\Windows\CurrentVersion\Search"; name = "SearchboxTaskbarMode"; description = "Show Search Icon in Taskbar"; value = "1"; type = "DWORD"}
    @{key = "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System"; name = "VerboseStatus"; description = "Enable Verbose Boot Messages"; value = "1"; type = "DWORD"}
    @{key = "HKLM:\SYSTEM\CurrentControlSet\Control\CrashControl"; name = "DisplayParameters"; description = "Show Crash Details on BSOD"; value = "1"; type = "DWORD"}
    @{key = "HKLM:\SYSTEM\CurrentControlSet\Control\CrashControl"; name = "DisableEmoticon"; description = "Disable Sad Face on BSOD"; value = "1"; type = "DWORD"}
    @{key = "HKLM:\SOFTWARE\Microsoft\PolicyManager\current\device\Start"; name = "HideRecommendedSection"; description = "Hide Recommended Section in Start Menu"; value = "1"; type = "DWORD"}
    @{key = "HKLM:\SOFTWARE\Policies\Microsoft\Windows\Explorer"; name = "HideRecommendedSection"; description = "Hide Recommended Files in Explorer"; value = "1"; type = "DWORD"}
    @{key = "HKLM:\SOFTWARE\Microsoft\PolicyManager\current\device\Education"; name = "IsEducationEnvironment"; description = "Disable Education Environment Features"; value = "0"; type = "DWORD"}
    @{key = "HKCU:\Control Panel\Mouse"; name = "MouseSpeed"; description = "Enable Enhanced Pointer Precision"; value = "1"; type = "DWORD"}
    @{key = "HKCU:\Control Panel\Mouse"; name = "MouseThreshold1"; description = "Set Mouse Acceleration Threshold 1"; value = "6"; type = "DWORD"}
    @{key = "HKCU:\Control Panel\Mouse"; name = "MouseThreshold2"; description = "Set Mouse Acceleration Threshold 2"; value = "10"; type = "DWORD"}
    @{key = "HKCU:\Control Panel\Accessibility\StickyKeys"; name = "Flags"; description = "Disable Sticky Keys Notifications"; value = "510"; type = "DWORD"}
    @{key = "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced"; name = "Hidden"; description = "Show Hidden Files and Folders"; value = "1"; type = "DWORD"}
    @{key = "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced"; name = "HideFileExt"; description = "Show File Extensions"; value = "0"; type = "DWORD"}
    @{key = "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced"; name = "ShowTaskViewButton"; description = "Hide Task View Button"; value = "0"; type = "DWORD"}
    @{key = "HKCU:\Software\Microsoft\InputPersonalization"; name = "RestrictImplicitTextCollection"; description = "Disable Implicit Text Input Collection (Privacy)"; value = "1"; type = "DWORD"},
    @{key = "HKCU:\Software\Microsoft\InputPersonalization"; name = "RestrictImplicitInkCollection"; description = "Disable Implicit Ink Input Collection (Privacy)"; value = "1"; type = "DWORD"},
    @{key = "HKCU:\Software\Microsoft\Windows\CurrentVersion\ContentDeliveryManager"; name = "SilentInstalledAppsEnabled"; description = "Disable silently installed apps/suggestions"; value = "0"; type = "DWORD"},
    @{key = "HKLM:\SOFTWARE\Policies\Microsoft\Windows\CloudContent"; name = "DisableWindowsConsumerFeatures"; description = "Disable Consumer Features (Pre-installed apps/Suggestions)"; value = "1"; type = "DWORD"},
    @{key = "HKLM:\SOFTWARE\Policies\Microsoft\Windows\DataCollection"; name = "AllowTelemetry"; description = "Disable Windows Telemetry/Data Collection"; value = "0"; type = "DWORD"},
    @{key = "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\ContentDeliveryManager"; name = "RotatingLockScreenEnabled"; description = "Disable Spotlight/Ads on Lock Screen"; value = "0"; type = "DWORD"},
    @{key = "HKLM:\SOFTWARE\Microsoft\SQMClient"; name = "MachineId"; description = "Disable Customer Experience Improvement Program (CEIP)"; value = "0"; type = "DWORD"}
)

# ====================================================================== #
#  Packages to install using Winget and Chocolatey
# ====================================================================== #
$Script:Packages = @(
    @{ ID = "Git.Git"; Name = "Git - Version Control System"; Description = "Distributed version control for tracking code changes, branching, and collaboration."; Homepage = "https://git-scm.com/" ; source = "winget"; Permission = "true"},
    @{ ID = "GitHub.cli"; Name = "GitHub CLI - GitHub Command Line"; Description = "Official command-line interface for managing repositories, issues, and pull requests on GitHub."; Homepage = "https://cli.github.com/" ; source = "winget"; Permission = "false"},
    @{ ID = "Microsoft.VisualStudioCode"; Name = "Visual Studio Code - Code Editor"; Description = "Feature-rich code editor with IntelliSense, debugging, and extensive extension marketplace."; Homepage = "https://code.visualstudio.com/" ; source = "winget"; Permission = "true"},
    @{ ID = "SublimeHQ.SublimeText.4"; Name = "Sublime Text 4 - Text Editor"; Description = "High-performance text editor with multiple cursors, split editing, and powerful search."; Homepage = "https://www.sublimetext.com/"; source = "winget"; Permission = "true"},
    @{ ID = "Neovim.Neovim"; Name = "Neovim - Vim-based Editor"; Description = "Hyperextensible Vim-based text editor with modern features and plugin support."; Homepage = "https://neovim.io/" ; source = "winget"; Permission = "false"},
    @{ ID = "Neovide.Neovide"; Name = "Neovide - Neovim GUI"; Description = "A GUI for Neovim, providing a modern interface and features."; Homepage = "https://neovide.dev/" ; source = "winget"; Permission = "false"},
    @{ ID = "DevToys-app.DevToys"; Name = "DevToys - Developer Utilities"; Description = "Comprehensive toolbox featuring JSON formatter, regex tester, color picker, and encoding tools."; Homepage = "https://devtoys.app/" ; source = "winget"; Permission = "false"},
    @{ ID = "Microsoft.PowerShell"; Name = "PowerShell - Shell & Scripting"; Description = "Cross-platform automation platform with object-oriented shell and scripting language."; Homepage = "https://github.com/PowerShell/PowerShell/" ; source = "winget"; Permission = "true"},
    @{ ID = "Microsoft.WindowsTerminal"; Name = "Windows Terminal - Command Line"; Description = "Modern, fast terminal application with tabs, panes, and multiple shell support."; Homepage = "https://aka.ms/terminal/" ; source = "winget"; Permission = "true"},
    @{ ID = "GoLang.Go"; Name = "Go Programming Language"; Description = "Statically typed compiled language with concurrency support and garbage collection."; Homepage = "https://golang.org/" ; source = "winget"; Permission = "true"},
    @{ ID = "Rustlang.Rust.GNU"; Name = "Rust Programming Language"; Description = "Systems programming language focused on safety, speed, and concurrency."; Homepage = "https://www.rust-lang.org/" ; source = "winget"; Permission = "true"},
    @{ ID = "MartinStorsjo.LLVM-MinGW.MSVCRT"; Name = "C++ Programming Language"; Description = "C++ build tools including MSVC compiler, libraries, and CMake support."; Homepage = "https://visualstudio.microsoft.com/visual-cpp-build-tools/" ; source = "winget"; Permission = "true"},
    @{ ID = "astral-sh.uv"; Name = "uv - Python Package Manager"; Description = "Ultra-fast Python package installer and resolver, replacing pip and virtualenv."; Homepage = "https://github.com/astral-sh/uv/" ; source = "winget"; Permission = "true"},
    @{ ID = "7zip.7zip"; Name = "7-Zip - File Archiver"; Description = "High-compression file archiver supporting multiple formats including ZIP, RAR, and TAR."; Homepage = "https://www.7-zip.org/" ; source = "winget"; Permission = "true"},
    @{ ID = "ShareX.ShareX"; Name = "ShareX - Screenshot & Sharing"; Description = "Advanced screen capture tool with editing, annotations, and cloud sharing capabilities."; Homepage = "https://getsharex.com/" ; source = "winget"; Permission = "true"},
    @{ ID = "Microsoft.PowerToys"; Name = "PowerToys - Windows Utilities"; Description = "Collection of system utilities including FancyZones, PowerRename, and Color Picker."; Homepage = "https://github.com/microsoft/PowerToys/" ; source = "winget"; Permission = "true"},
    @{ ID = "Nilesoft.Shell"; Name = "Nilesoft Shell - Context Menu"; Description = "Enhanced Windows context menu with customizable shortcuts and file operations."; Homepage = "https://nilesoft.org/" ; source = "winget"; Permission = "true"},
    @{ ID = "gerardog.gsudo"; Name = "gsudo - Windows Sudo"; Description = "Elevate command-line commands with administrator privileges, similar to Unix sudo."; Homepage = "https://gerardog.github.io/gsudo/" ; source = "winget"; Permission = "true"},
    @{ ID = "namazso.OpenHashTab"; Name = "OpenHashTab - File Integrity"; Description = "Windows Explorer integration for calculating and verifying file checksums and hashes."; Homepage = "https://github.com/marticliment/UniGetUI/" ; source = "winget"; Permission = "true"},
    @{ ID = "yorukot.superfile"; Name = "Super File - File Manager"; Description = "Modern file manager with dual-pane interface, tabs, and advanced file operations."; Homepage = "https://superfile.dev/" ; source = "winget"; Permission = "false"},
    @{ ID = "AutoHotkey.AutoHotkey"; Name = "AutoHotkey - Automation Scripting"; Description = "Scripting language for creating hotkeys, macros, and automating Windows tasks."; Homepage = "https://www.autohotkey.com/" ; source = "winget"; Permission = "true"},
    @{ ID = "XavierRoche.HTTrack"; Name = "HTTrack - Website Copier"; Description = "Download entire websites for offline browsing with mirroring capabilities."; Homepage = "https://www.httrack.com/" ; source = "winget"; Permission = "false"},
    @{ ID = "Zen-Team.Zen-Browser"; Name = "Zen Browser - Privacy Browser"; Description = "Privacy-focused web browser with built-in ad blocking and tracking protection."; Homepage = "https://zenbrowser.io/" ; source = "winget"; Permission = "true"},
    @{ ID = "Mozilla.Thunderbird"; Name = "Thunderbird - Email Client"; Description = "Full-featured email, calendar, and chat client with extensive add-on support."; Homepage = "https://www.thunderbird.net/" ; source = "winget"; Permission = "false"},
    @{ ID = "Notion.Notion"; Name = "Notion - Workspace"; Description = "All-in-one workspace for notes, tasks, wikis, and databases with team collaboration."; Homepage = "https://www.notion.so/" ; source = "winget"; Permission = "false"},
    @{ ID = "Obsidian.Obsidian"; Name = "Obsidian - Knowledge Base"; Description = "A powerful knowledge base that works on local Markdown files."; Homepage = "https://obsidian.md/" ; source = "winget"; Permission = "false"},
    @{ ID = "Zoom.Zoom.EXE"; Name = "Zoom - Video Conferencing"; Description = "HD video meetings, webinars, and team chat with screen sharing and recording."; Homepage = "https://zoom.us/" ; source = "winget"; Permission = "false"},
    @{ ID = "Microsoft.OneDrive"; Name = "OneDrive - Cloud Storage"; Description = "Microsoft's cloud storage with file synchronization and Office integration."; Homepage = "https://onedrive.live.com/" ; source = "winget"; Permission = "false"},
    @{ ID = "Google.GoogleDrive"; Name = "Google Drive - Cloud Storage"; Description = "Google's file storage with collaboration features and Google Workspace integration."; Homepage = "https://drive.google.com/" ; source = "winget"; Permission = "false"},
    @{ ID = "Dropbox.Dropbox"; Name = "Dropbox - File Synchronization"; Description = "Cloud storage with file synchronization, sharing, and collaboration tools."; Homepage = "https://www.dropbox.com/" ; source = "winget"; Permission = "false"},
    @{ ID = "OpenVPNTechnologies.OpenVPNConnect"; Name = "OpenVPN - VPN Client"; Description = "Open-source VPN solution for secure remote access and site-to-site connectivity."; Homepage = "https://openvpn.net/" ; source = "winget"; Permission = "true"},
    @{ ID = "AnyDesk.AnyDesk"; Name = "AnyDesk - Remote Desktop"; Description = "Fast remote desktop access with file transfer and session recording capabilities."; Homepage = "https://anydesk.com/" ; source = "winget"; Permission = "false"},
    @{ ID = "lazygit"; Name = "LazyGit - Git TUI"; Description = "Beautiful terminal interface for Git with visual commit history and easy navigation."; Homepage = "https://github.com/jesseduffield/lazygit/" ; source = "choco"; Permission = "false"},
    @{ ID = "onefetch"; Name = "OneFetch - Git Repository Stats"; Description = "Display project information and Git statistics directly in your terminal with ASCII art."; Homepage = "https://github.com/o2sh/onefetch/" ; source = "choco"; Permission = "false"},
    @{ ID = "bat"; Name = "Bat - Modern Cat"; Description = "Enhanced file viewer with syntax highlighting, Git integration, and paging functionality."; Homepage = "https://github.com/sharkdp/bat/" ; source = "choco"; Permission = "true"},
    @{ ID = "fzf"; Name = "fzf - Fuzzy Finder"; Description = "Blazing-fast command-line fuzzy finder for files, commands, history, and more."; Homepage = "https://github.com/junegunn/fzf/" ; source = "choco"; Permission = "true"},
    @{ ID = "ripgrep"; Name = "ripgrep - Search Tool"; Description = "Ultra-fast text search tool that respects your .gitignore and recursively searches code."; Homepage = "https://github.com/BurntSushi/ripgrep/" ; source = "choco"; Permission = "true"},
    @{ ID = "starship"; Name = "Starship - Cross-Shell Prompt"; Description = "The minimal, blazing-fast, and infinitely customizable prompt for any shell."; Homepage = "https://starship.rs/" ; source = "choco"; Permission = "true"},
    @{ ID = "zoxide"; Name = "Zoxide - Smart Directory Jumper"; Description = "Smarter cd command that learns your habits and jumps to frequently used directories instantly."; Homepage = "https://github.com/ajeetdsouza/zoxide/" ; source = "choco"; Permission = "true"},
    @{ ID = "hashmyfiles"; Name = "HashMyFiles - File Integrity"; Description = "Lightweight utility to calculate MD5, SHA1, and other hashes for file verification."; Homepage = "https://www.nirsoft.net/utils/hash_my_files.html/" ; source = "choco"; Permission = "true"},
    @{ ID = "fastfetch"; Name = "Fastfetch - System Information"; Description = "Elegant system information tool for Windows with detailed hardware and OS details."; Homepage = "https://github.com/fastfetch-cli/fastfetch/" ; source = "choco"; Permission = "true"},
    @{ ID = "nvm"; Name = "nvm-windows - Node Version Manager"; Description = "Easily switch between Node.js versions and manage multiple development environments."; Homepage = "https://github.com/coreybutler/nvm-windows/" ; source = "choco"; Permission = "true"},
    @{ ID = "exiftool"; Name = "ExifTool - Metadata Editor"; Description = "Powerful command-line tool for reading, writing, and editing metadata in images and files."; Homepage = "https://exiftool.org/" ; source = "choco"; Permission = "true"},
    @{ ID = "ntop.portable"; Name = "Ntop - Htop for Windows"; Description = "Htop-like system-monitor with Vi-emulation for Windows. Because using Task Manager is not cool enough."; Homepage = "https://github.com/gsass1/NTop/" ; source = "choco"; Permission = "false"},
    # @{ ID = "tig"; Name = "Tig - Text-mode Interface for Git"; Description = "Text-mode interface for Git repositories, providing a visual way to browse history and stage changes."; Homepage = "https://jonas.github.io/tig/" ; source = "choco"; Permission = "true"},
    @{ ID = "delta"; Name = "Delta - Syntax-highlighting Pager"; Description = "Syntax-highlighting pager for Git, providing a better diff experience."; Homepage = "https://github.com/dandavison/delta/" ; source = "choco"; Permission = "true"},
    @{ ID = "windhawk"; Name = "Windhawk - Windows Customizer"; Description = "Advanced Windows customization tool with plugin system for enhancing desktop experience."; Homepage = "https://windhawk.net/" ; source = "choco"; Permission = "true"},
    @{ ID = "discord"; Name = "Discord - Communication Platform"; Description = "All-in-one voice, video, and text chat for communities, gamers, and teams."; Homepage = "https://discord.com/" ; source = "choco"; Permission = "false"},
    @{ ID = "telegram"; Name = "Telegram - Messaging App"; Description = "Cloud-based instant messaging, VoIP, and video calling app."; Homepage = "https://telegram.org/" ; source = "choco"; Permission = "false"}
)

# ====================================================================== #
# Utility Functions
# ====================================================================== #

# ---------------------------------------------------------------------------- #
# Function to display a Success message
function Show-SuccessMessage {
    param (
        [string]$Message
    )
    Write-Host "[OK] $Message" -ForegroundColor $Script:WinfigColors.Success
}

# ---------------------------------------------------------------------------- #
# Function to display an Error message
function Show-ErrorMessage {
    param (
        [string]$Message
    )
    Write-Host "[ERROR] $Message" -ForegroundColor $Script:WinfigColors.Error
}

# ---------------------------------------------------------------------------- #
# Function to display an Info message
function Show-InfoMessage {
    param (
        [string]$Message
    )
    Write-Host "[INFO] $Message" -ForegroundColor $Script:WinfigColors.Info
}

# ---------------------------------------------------------------------------- #
# Function to display a Warning message
function Show-WarningMessage {
    param (
        [string]$Message
    )
    Write-Host "[WARN] $Message" -ForegroundColor $Script:WinfigColors.Warning
}

# ---------------------------------------------------------------------------- #
# Function to prompt user for input with a specific color
function Prompt-UserInput {
    param (
        [string]$PromptMessage = $Script:WinfigPrompts.Confirm,
        [string]$PromptColor   = $Script:WinfigColors.Primary
    )
    # Write prompt in the requested color, keep cursor on same line, then read input
    Write-Host -NoNewline $PromptMessage -ForegroundColor $PromptColor
    $response = Read-Host

    return $response
}

# ---------------------------------------------------------------------------- #
# Function to Prompt user for confirmation (Y/N)
function Prompt-UserConfirmation {
    while ($true) {
        $response = Prompt-UserInput -PromptMessage $Script:WinfigPrompts.Confirm -PromptColor $Script:WinfigColors.Primary
        switch ($response.ToUpper()) {
            "Y" { return $true }
            "N" { return $false }
            default {
                Show-WarningMessage "Invalid input. Please enter Y or N."
            }
        }
    }
}

# ---------------------------------------------------------------------------- #
# Function to Prompt user to Retry (Y/N)
function Prompt-UserRetry {
    while ($true) {
        $response = Prompt-UserInput -PromptMessage $Script:WinfigPrompts.Retry -PromptColor $Script:WinfigColors.Primary
        switch ($response.ToUpper()) {
            "Y" { return $true }
            "N" { return $false }
            default {
                Show-WarningMessage "Invalid input. Please enter Y or N."
            }
        }
    }
}

# ---------------------------------------------------------------------------- #
# Function to Prompt user to continue
function Prompt-UserContinue {
    Write-Host $Script:WinfigPrompts.Continue -ForegroundColor $Script:WinfigColors.Primary
    $null = $Host.UI.RawUI.ReadKey("NoEcho,IncludeKeyDown")
}

# ---------------------------------------------------------------------------- #
# Function to Abort operation
function Abort-Operation {
    Show-ErrorMessage $Script:WinfigPrompts.Abort
    # Write log footer before exiting
    if ($Global:WinfigLogFilePath) {
        Log-Message -Message "Script terminated." -EndRun
    }
    exit 1
}

# ---------------------------------------------------------------------------- #
# Function to Write a Section Header
function Write-SectionHeader {
    param(
        [Parameter(Mandatory=$true)]
        [string]$Title,

        [Parameter(Mandatory=$false)]
        [string]$Description = ""
    )
    $separator = "=" * 70
    Write-Host $separator -ForegroundColor $Script:WinfigColors.Accent
    Write-Host "$Title" -ForegroundColor $Script:WinfigColors.Primary
    if ($Description) {
        Write-Host "$Description" -ForegroundColor $Script:WinfigColors.Accent
    }
    Write-Host $separator -ForegroundColor $Script:WinfigColors.Accent
}

# ---------------------------------------------------------------------------- #
# Function to Write a Subsection Header
function Write-SubsectionHeader {
    param(
        [Parameter(Mandatory=$true)]
        [string]$Title
    )
    $separator = "-" * 50
    Write-Host $separator -ForegroundColor $Script:WinfigColors.Accent
    Write-Host "$Title" -ForegroundColor $Script:WinfigColors.Primary
    Write-Host $separator -ForegroundColor $Script:WinfigColors.Accent
}

# ---------------------------------------------------------------------------- #
#  Function to Write a Log Message
function Log-Message {
    param(
        [Parameter(Mandatory=$true)]
        [string]$Message,

        [Parameter(Mandatory=$false)]
        [ValidateSet("DEBUG", "INFO", "WARN", "ERROR", "SUCCESS")]
        [string]$Level = "INFO",

        [Parameter(Mandatory=$false)]
        [switch]$EndRun
    )

    if (-not $Global:LogCount) { $Global:LogCount = 0 }
    if (-not $Global:ErrorCount) { $Global:ErrorCount = 0 }
    if (-not $Global:WarnCount) { $Global:WarnCount = 0 }


    if (-not (Test-Path -Path $Global:WinfigPaths.Logs)) {
        New-Item -ItemType Directory -Path $Global:WinfigPaths.Logs -Force | Out-Null
    }

    $enc = New-Object System.Text.UTF8Encoding $true

    $identity = try { [System.Security.Principal.WindowsIdentity]::GetCurrent().Name } catch { $env:USERNAME }
    $isElevated = try {
        (New-Object Security.Principal.WindowsPrincipal([Security.Principal.WindowsIdentity]::GetCurrent())).IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)
    } catch {
        $false
    }
    $scriptPath = if ($PSCommandPath) { $PSCommandPath } elseif ($MyInvocation.MyCommand.Path) { $MyInvocation.MyCommand.Path } else { $null }
    $psVersion = $PSVersionTable.PSVersion.ToString()
    $dotNetVersion = [System.Environment]::Version.ToString()
    $workingDir = (Get-Location).Path
    $osInfo = try {
        (Get-CimInstance -ClassName Win32_OperatingSystem -ErrorAction Stop).Caption
    } catch {
        [Environment]::OSVersion.VersionString
    }
    # ---------------------------------------------------------------------------------------

    if (-not $Global:WinfigLogFilePath) {
        # $Global:WinfigLogStart is set in the main script execution block for each run
        $fileStamp = $Global:WinfigLogStart.ToString('yyyy-MM-dd_HH-mm-ss')
        $Global:WinfigLogFilePath = [System.IO.Path]::Combine($Global:WinfigPaths.Logs, "winfig-bootstrap-$fileStamp.log")

        $header = @()
        $header += "==================== Winfig Bootstrap Log ===================="
        $header += "Start Time  : $($Global:WinfigLogStart.ToString('yyyy-MM-dd HH:mm:ss'))"
        $header += "Host Name   : $env:COMPUTERNAME"
        $header += "User        : $identity"
        $header += "IsElevated  : $isElevated"
        if ($scriptPath) { $header += "Script Path : $scriptPath" }
        $header += "Working Dir : $workingDir"
        $header += "PowerShell  : $psVersion"
        $header += "NET Version : $dotNetVersion"
        $header += "OS          : $osInfo"
        $header += "=============================================================="
        $header += ""

        try {
            [System.IO.File]::WriteAllLines($Global:WinfigLogFilePath, $header, $enc)
        } catch {
            $header | Out-File -FilePath $Global:WinfigLogFilePath -Encoding UTF8 -Force
        }
    } else {
        if (-not $Global:WinfigLogStart) {
            $Global:WinfigLogStart = Get-Date
        }

        try {
            if (Test-Path -Path $Global:WinfigLogFilePath) {
                $firstLine = Get-Content -Path $Global:WinfigLogFilePath -TotalCount 1 -ErrorAction SilentlyContinue
                if ($firstLine -and ($firstLine -notmatch 'Winfig Bootstrap Log')) {

                    $header = @()
                    $header += "==================== Winfig Bootstrap Log  ===================="
                    $header += "Start Time  : $($Global:WinfigLogStart.ToString('yyyy-MM-dd HH:mm:ss'))"
                    $header += "Host Name   : $env:COMPUTERNAME"
                    $header += "User        : $identity"
                    $header += "IsElevated  : $isElevated"
                    if ($scriptPath) { $header += "Script Path : $scriptPath" }
                    $header += "Working Dir : $workingDir"
                    $header += "PowerShell  : $psVersion"
                    $header += "NET Version : $dotNetVersion"
                    $header += "OS          : $osInfo"
                    $header += "======================================================================="
                    $header += ""

                    # Prepend header safely: write header to temp file then append original content
                    $temp = [System.IO.Path]::GetTempFileName()
                    try {
                        [System.IO.File]::WriteAllLines($temp, $header, $enc)
                        [System.IO.File]::AppendAllLines($temp, (Get-Content -Path $Global:WinfigLogFilePath -Raw).Split([Environment]::NewLine), $enc)
                        Move-Item -Force -Path $temp -Destination $Global:WinfigLogFilePath
                    } finally {
                        if (Test-Path $temp) { Remove-Item $temp -ErrorAction SilentlyContinue }
                    }
                }
            }
        } catch {
            # ignore header-fix failures; continue logging
        }
    }

    if ($EndRun) {
        $endTime = Get-Date
        # $Global:WinfigLogStart is guaranteed to be set now
        $duration = $endTime - $Global:WinfigLogStart
        $footer = @()
        $footer += ""
        $footer += "--------------------------------------------------------------"
        $footer += "End Time    : $($endTime.ToString('yyyy-MM-dd HH:mm:ss'))"
        $footer += "Duration    : $($duration.ToString('dd\.hh\:mm\:ss') -replace '^00\.', '')"
        $footer += "Log Count   : $Global:LogCount"
        $footer += "Errors/Warn : $Global:ErrorCount / $Global:WarnCount"
        $footer += "===================== End of Winfig Log ======================"
        try {
            [System.IO.File]::AppendAllLines($Global:WinfigLogFilePath, $footer, $enc)
        } catch {
            $footer | Out-File -FilePath $Global:WinfigLogFilePath -Append -Encoding UTF8
        }
        return
    }

    $now = Get-Date
    $timestamp = $now.ToString("yyyy-MM-dd HH:mm:ss.fff")
    $logEntry = "[$timestamp] [$Level] $Message"

    $Global:LogCount++
    if ($Level -eq 'ERROR') { $Global:ErrorCount++ }
    if ($Level -eq 'WARN') { $Global:WarnCount++ }

    try {
        [System.IO.File]::AppendAllText($Global:WinfigLogFilePath, $logEntry + [Environment]::NewLine, $enc)
    } catch {
        Write-Host "Failed to write log to file: $($_.Exception.Message)" -ForegroundColor Yellow
        Write-Host $logEntry
    }
}

# ====================================================================== #
#  Main Functions
# ====================================================================== #

# ---------------------------------------------------------------------------- #
# Function to check if running as Administrator
function IsAdmin{
    $currentUser = [System.Security.Principal.WindowsIdentity]::GetCurrent()
    $principal = New-Object System.Security.Principal.WindowsPrincipal($currentUser)
    if ($principal.IsInRole([System.Security.Principal.WindowsBuiltInRole]::Administrator)) {
        Log-Message -Message "Script is running with Administrator privileges." -Level "SUCCESS"
    } else {
        Show-ErrorMessage "Script is NOT running with Administrator privileges."
        Log-Message -Message "Script is NOT running with Administrator privileges." -Level "ERROR"
        Log-Message "Forced exit." -EndRun
        $LogPathMessage = "Check the Log file for details: $($Global:WinfigLogFilePath)"
        Show-InfoMessage -Message $LogPathMessage
        exit 1
    }
}

# ---------------------------------------------------------------------------- #
# Function to Check if running on Windows 11
function Is-Windows11 {
    try {
        $osInfo = Get-CimInstance -ClassName Win32_OperatingSystem -ErrorAction Stop
        $version = [Version]$osInfo.Version
        if ($version.Build -ge 22000) {
            Log-Message -Message "Operating System is Windows 11." -Level "SUCCESS"
        } else {
            Show-ErrorMessage "Operating System is NOT Windows 11."
            Log-Message -Message "Operating System is NOT Windows 11." -Level "ERROR"
            Log-Message "Forced exit." -EndRun
            $LogPathMessage = "Check the Log file for details: $($Global:WinfigLogFilePath)"
            Show-InfoMessage -Message $LogPathMessage
            exit 1
        }
    } catch {
        Show-ErrorMessage "Failed to determine Operating System version: $($_.Exception.Message)"
        Log-Message -Message "Failed to determine Operating System version: $($_.Exception.Message)" -Level "ERROR"
        Log-Message "Forced exit." -EndRun
        $LogPathMessage = "Check the Log file for details: $($Global:WinfigLogFilePath)"
        Show-InfoMessage -Message $LogPathMessage
        exit 1
    }
}

# ---------------------------------------------------------------------------- #
# Function to check Working Internet Connection
function Test-InternetConnection {
    try {
        $request = [System.Net.WebRequest]::Create("http://www.google.com")
        $request.Timeout = 5000
        $response = $request.GetResponse()
        $response.Close()
        Log-Message -Message "Internet connection is available." -Level "SUCCESS"
        return $true
    } catch {
        Show-ErrorMessage "No internet connection available: $($_.Exception.Message)"
        Log-Message -Message "No internet connection available: $($_.Exception.Message)" -Level "ERROR"
        Log-Message "Forced exit." -EndRun
        $LogPathMessage = "Check the Log file for details: $($Global:WinfigLogFilePath)"
        Show-InfoMessage -Message $LogPathMessage
        exit 1

    }
}

# ---------------------------------------------------------------------------- #
# function to check if there is enough free disk space (10GB minimum)
function Test-FreeDiskSpace {
    $systemDrive = Get-WmiObject -Class Win32_LogicalDisk -Filter "DeviceID='C:'" | Select-Object Size, FreeSpace
    $freeSpaceGB = [math]::Round($systemDrive.FreeSpace / 1GB, 2)
    $minSpaceGB = 10
    if ($freeSpaceGB -ge $minSpaceGB) {
        Log-Message -Message "Sufficient disk space available: $freeSpaceGB GB free." -Level "SUCCESS"
        return $true
    } else {
        Show-ErrorMessage "Insufficient disk space. Required: $minSpaceGB GB, Available: $freeSpaceGB GB."
        Log-Message -Message "Insufficient disk space. Required: $minSpaceGB GB, Available: $freeSpaceGB GB." -Level "ERROR"
        Log-Message "Forced exit." -EndRun
        $LogPathMessage = "Check the Log file for details: $($Global:WinfigLogFilePath)"
        Show-InfoMessage -Message $LogPathMessage
        exit 1
    }
}

# ---------------------------------------------------------------------------- #
# Function to check Execuation Policy
function Test-ExecutionPolicy {
    $executionPolicy = Get-ExecutionPolicy
    $allowedPolicies = @("RemoteSigned", "Unrestricted", "Bypass")
    if ($executionPolicy -in $allowedPolicies) {
        Log-Message -Message "Execution Policy is set to '$executionPolicy'." -Level "SUCCESS"
    } else {
        Show-ErrorMessage "Execution Policy '$executionPolicy' is not sufficient to run this script."
        Log-Message -Message "Execution Policy '$executionPolicy' is not sufficient to run this script." -Level "ERROR"
        Log-Message "Forced exit." -EndRun
        $LogPathMessage = "Check the Log file for details: $($Global:WinfigLogFilePath)"
        Show-InfoMessage -Message $LogPathMessage
        exit 1
    }
}

# ---------------------------------------------------------------------------- #
# Function to check if PowerShell version is 5.1 or higher
function Test-PSVersion {
    $psVersion = $PSVersionTable.PSVersion
    if ($psVersion.Major -ge 5) {
        Log-Message -Message "PowerShell version is sufficient: $($psVersion.ToString())." -Level "SUCCESS"
    } else {
        Show-ErrorMessage "PowerShell version is insufficient: $($psVersion.ToString()). Version 5.1 or higher is required."
        Log-Message -Message "PowerShell version is insufficient: $($psVersion.ToString()). Version 5.1 or higher is required." -Level "ERROR"
        Log-Message "Forced exit." -EndRun
        $LogPathMessage = "Check the Log file for details: $($Global:WinfigLogFilePath)"
        Show-InfoMessage -Message $LogPathMessage
        exit 1
    }
}

# ---------------------------------------------------------------------------- #
# Function to Display Banner
function Winfig-Banner {
    Clear-Host
    Write-Host ""
    Write-Host ("  ██╗    ██╗██╗███╗   ██╗███████╗██╗ ██████╗  ".PadRight(70)) -ForegroundColor $Script:WinfigColors.Light
    Write-Host ("  ██║    ██║██║████╗  ██║██╔════╝██║██╔════╝  ".PadRight(70)) -ForegroundColor $Script:WinfigColors.Light
    Write-Host ("  ██║ █╗ ██║██║██╔██╗ ██║█████╗  ██║██║  ███╗ ".PadRight(70)) -ForegroundColor $Script:WinfigColors.Accent
    Write-Host ("  ██║███╗██║██║██║╚██╗██║██╔══╝  ██║██║   ██║ ".PadRight(70)) -ForegroundColor $Script:WinfigColors.Accent
    Write-Host ("  ╚███╔███╔╝██║██║ ╚████║██║     ██║╚██████╔╝ ".PadRight(70)) -ForegroundColor $Script:WinfigColors.Success
    Write-Host ("   ╚══╝╚══╝ ╚═╝╚═╝  ╚═══╝╚═╝     ╚═╝ ╚═════╝  ".PadRight(70)) -ForegroundColor $Script:WinfigColors.Success
    Write-Host ((" " * 70)) -ForegroundColor $Script:WinfigColors.Primary
    Write-Host ("" + $Script:WinfigMeta.CompanyName).PadLeft(40).PadRight(70) -ForegroundColor $Script:WinfigColors.Primary
    Write-Host ((" " * 70)) -ForegroundColor $Script:WinfigColors.Primary
    Write-Host ("  " + $Script:WinfigMeta.Description).PadRight(70) -ForegroundColor $Script:WinfigColors.Accent
    Write-Host ((" " * 70)) -ForegroundColor $Script:WinfigColors.Primary
    Write-Host (("  Version: " + $Script:WinfigMeta.Version + "    PowerShell: " + $Script:WinfigMeta.PowerShell).PadRight(70)) -ForegroundColor $Script:WinfigColors.Warning
    Write-Host (("  Author:  " + $Script:WinfigMeta.Author + "    Platform: " + $Script:WinfigMeta.Platform).PadRight(70)) -ForegroundColor $Script:WinfigColors.Warning
    Write-Host ""
}

# ---------------------------------------------------------------------------- #
# Function to check if Winget is installed
function Check-Winget {
    $wingetPath = (Get-Command winget.exe -ErrorAction SilentlyContinue)
    if ($wingetPath) {
        Log-Message -Message "Winget is installed at: $wingetPath" -Level "SUCCESS"
        return $wingetPath
    } else {
        Log-Message -Message "Winget is not installed on this system." -Level "ERROR"
        return $null
    }
}

# ---------------------------------------------------------------------------- #
# Function to check if Chocolatey is installed
function Check-Chocolatey {
    $chocoPath = (Get-Command choco.exe -ErrorAction SilentlyContinue)
    if ($chocoPath) {
        Log-Message -Message "Chocolatey is installed at: $chocoPath" -Level "SUCCESS"
        return $chocoPath
    } else {
        Log-Message -Message "Chocolatey is not installed on this system." -Level "ERROR"
        return $null
    }
}

# ---------------------------------------------------------------------------- #
# Function to uninstall Appx Package
function Uninstall-AppxPackages {
    param(
        [Parameter(Mandatory=$true)]
        [array]$AppList
    )

    foreach ($app in $AppList) {
        try {
            $packageName = $app.packageName
            $displayName = $app.displayName

            Write-SubsectionHeader -Title "Processing: $displayName"
            Log-Message -Message "Processing package: $packageName ($displayName)" -Level "INFO"

            # Use wildcard search to find packages that start with the packageName
            $Package = Get-AppxPackage -Name "*$packageName*" -ErrorAction SilentlyContinue

            if ($null -eq $Package) {
                Show-InfoMessage "Package '$displayName' not found on this system."
                Log-Message -Message "Package '$packageName' ($displayName) not found." -Level "INFO"
                $Script:NotFoundCount++
            } else {
                Remove-AppxPackage -Package $Package.PackageFullName -ErrorAction Stop

                Show-SuccessMessage "Successfully uninstalled '$displayName'."
                Log-Message -Message "Successfully uninstalled '$packageName' ($displayName)." -Level "SUCCESS"
                $Script:RemovedCount++
            }
        } catch {
            Show-ErrorMessage "Failed to uninstall '$displayName': $($_.Exception.Message)"
            Log-Message -Message "Failed to uninstall '$packageName' ($displayName): $($_.Exception.Message)" -Level "ERROR"
            $Script:ErrorCount++
        }
    }
    Log-Message -Message "Debloat completed. Removed: $Script:RemovedCount, Not Found: $Script:NotFoundCount, Errors: $Script:ErrorCount" -Level "INFO"
}

# ---------------------------------------------------------------------------- #
# Function For Some Registry Optimizations
function Optimize-Registry {
    foreach ($reg in $Script:RegList) {
        try {
            $key = $reg.key
            $name = $reg.name
            $description = $reg.description
            $value = $reg.value
            $type = $reg.type

            Write-SubsectionHeader -Title "Optimizing: $description"
            Log-Message -Message "Optimizing registry key: $key, Name: $name" -Level "INFO"

            # Create the registry key if it doesn't exist
            if (-not (Test-Path -Path $key)) {
                New-Item -Path $key -Force | Out-Null
                Log-Message -Message "Created registry key: $key" -Level "DEBUG"
            }

            # Set the registry value
            Set-ItemProperty -Path $key -Name $name -Value $value -Type $type -Force -ErrorAction Stop

            Show-SuccessMessage "Successfully optimized '$description'."
            Log-Message -Message "Successfully set '$name' to '$value' in '$key'." -Level "SUCCESS"
            Show-InfoMessage "Restarting Explorer"
            Log-Message -Message "Restarting Explorer for registry to take effect" -Level "INFO"
            Stop-Process -Name explorer -Force -ErrorAction SilentlyContinue
            Start-Process explorer
        } catch {
            Show-ErrorMessage "Failed to optimize '$description': $($_.Exception.Message)"
            Log-Message -Message "Failed to set '$name' in '$key': $($_.Exception.Message)" -Level "ERROR"
        }
    }
}

# ---------------------------------------------------------------------------- #
# Function to Run CTT Winutil and Download Preset
function Run-CTTWinutil {
    $CTTUrl = "https://christitus.com/win"
    $PresetUrl = "https://raw.githubusercontent.com/Get-Winfig/winfig-bootstrap/main/preset.json"
    # Download the Preset file and save it on desktop
    try {
        # Ensure Desktop path is a single string and build a proper output path
        $desktopPath = $Global:WinfigPaths.Desktop -as [string]
        if (-not $desktopPath) { $desktopPath = [Environment]::GetFolderPath("Desktop") }
        $presetOutFile = Join-Path -Path $desktopPath -ChildPath "winfig-preset.json"

        Invoke-WebRequest -Uri $PresetUrl -OutFile $presetOutFile -UseBasicParsing -ErrorAction Stop
        Log-Message -Message "Downloaded CTT Winutil preset file to Desktop: $presetOutFile" -Level "SUCCESS"
    }catch {
        Show-ErrorMessage "Failed to download CTT Winutil preset file: $($_.Exception.Message)"
        Log-Message -Message "Failed to download CTT Winutil preset file: $($_.Exception.Message)" -Level "ERROR"
        return
    }

    # Run CTT Winutil
    $WinutilCommand = "Invoke-WebRequest -Uri '$CTTUrl' | Invoke-Expression; Read-Host 'Press Enter to continue...'"
    Log-Message -Message "Launching CTT Winutil..." -Level "INFO"
    Start-Process -FilePath "powershell.exe" -ArgumentList "-NoProfile","-ExecutionPolicy","Bypass","-Command",$WinutilCommand -Verb RunAs -Wait
}

# ---------------------------------------------------------------------------- #
# Get Latest Winget Links
function getNewestLink($match) {
    $uri = "https://api.github.com/repos/microsoft/winget-cli/releases/latest"
    Log-Message -Message "Fetching latest Winget release info from GitHub API." -Level "INFO"
    $get = Invoke-RestMethod -uri $uri -Method Get -ErrorAction stop
    Log-Message -Message "Successfully fetched release info." -Level "SUCCESS"
    $data = $get[0].assets | Where-Object name -Match $match
    Log-Message -Message "Extracted download link for asset matching '$match'." -Level "SUCCESS"
    return $data.browser_download_url
}

# ---------------------------------------------------------------------------- #
# Function to check Winget Installed Packages
function Get-InstalledWingetPackages {
    param(
        [Parameter(Mandatory=$true)]
        [array]$PackageList
    )

    $installedPackages = @{}

    # Filter only winget packages from the provided list
    $wingetPackages = $PackageList | Where-Object { $_.source -eq "winget" }

    if ($wingetPackages.Count -eq 0) {
        Log-Message -Message "No Winget packages found in the provided package list." -Level "INFO"
        return $installedPackages
    }

    try {
        Show-InfoMessage "Checking for installed Winget packages..."
        Log-Message -Message "Checking for installed Winget packages from package list." -Level "INFO"

        # Prepare temp output file using your declared paths
        $outFile = Join-Path -Path $Global:WinfigPaths.Temp -ChildPath "winfig_winget_installed.csv"
        $enc = New-Object System.Text.UTF8Encoding $true

        $csvLines = @()
        $csvLines += "Id,Name,Version,Status"

        foreach ($pkg in $wingetPackages) {
            $pkgId = $pkg.ID
            $pkgName = $pkg.Name

            try {
                # Check if this specific package is installed
                $result = & winget list --id $pkgId --exact 2>$null

                if ($LASTEXITCODE -eq 0 -and $result -match $pkgId) {
                    $installedPackages[$pkgId] = $true
                    $csvLines += "$pkgId,`"$pkgName`",Unknown,Installed"
                    Log-Message -Message "Package '$pkgId' ($pkgName) is installed via Winget." -Level "DEBUG"
                } else {
                    $installedPackages[$pkgId] = $false
                    $csvLines += "$pkgId,`"$pkgName`",N/A,Not Installed"
                    Log-Message -Message "Package '$pkgId' ($pkgName) is not installed via Winget." -Level "DEBUG"
                }
            } catch {
                $installedPackages[$pkgId] = $false
                $csvLines += "$pkgId,`"$pkgName`",N/A,Error"
                Log-Message -Message "Error checking package '$pkgId' ($pkgName): $($_.Exception.Message)" -Level "WARN"
            }
        }

        try {
            [System.IO.File]::WriteAllLines($outFile, $csvLines, $enc)
            Log-Message -Message "Winget package check results saved to: $outFile" -Level "SUCCESS"
        } catch {
            Log-Message -Message "Failed to write Winget package check results to file: $($_.Exception.Message)" -Level "ERROR"
        }

    } catch {
        Log-Message -Message "Error during Winget package checking: $($_.Exception.Message)" -Level "ERROR"
    }

    return $installedPackages
}

# ---------------------------------------------------------------------------- #
# Function to check Chocolatey Installed Packages
function Get-InstalledChocolateyPackages {
    param(
        [Parameter(Mandatory=$true)]
        [array]$PackageList
    )

    $installedPackages = @{}

    # Filter only chocolatey packages from the provided list
    $chocoPackages = $PackageList | Where-Object { $_.source -eq "choco" }

    if ($chocoPackages.Count -eq 0) {
        Log-Message -Message "No Chocolatey packages found in the provided package list." -Level "INFO"
        return $installedPackages
    }

    try {
        Show-InfoMessage "Checking for installed Chocolatey packages..."
        Log-Message -Message "Checking for installed Chocolatey packages from package list." -Level "INFO"

        # Prepare temp output file using your declared paths
        $outFile = Join-Path -Path $Global:WinfigPaths.Temp -ChildPath "winfig_choco_installed.csv"
        $enc = New-Object System.Text.UTF8Encoding $true

        $csvLines = @()
        $csvLines += "Id,Name,Status"

        foreach ($pkg in $chocoPackages) {
            $pkgId = $pkg.ID
            $pkgName = $pkg.Name

            try {
                # Check if this specific package is installed
                $result = & choco list --exact $pkgId 2>$null

                if ($LASTEXITCODE -eq 0 -and $result -match $pkgId) {
                    $installedPackages[$pkgId] = $true
                    $csvLines += "$pkgId,`"$pkgName`",Installed"
                    Log-Message -Message "Package '$pkgId' ($pkgName) is installed via Chocolatey." -Level "DEBUG"
                } else {
                    $installedPackages[$pkgId] = $false
                    $csvLines += "$pkgId,`"$pkgName`",Not Installed"
                    Log-Message -Message "Package '$pkgId' ($pkgName) is not installed via Chocolatey." -Level "DEBUG"
                }
            } catch {
                $installedPackages[$pkgId] = $false
                $csvLines += "$pkgId,`"$pkgName`",Error"
                Log-Message -Message "Error checking package '$pkgId' ($pkgName): $($_.Exception.Message)" -Level "WARN"
            }
        }

        try {
            [System.IO.File]::WriteAllLines($outFile, $csvLines, $enc)
            Log-Message -Message "Chocolatey package check results saved to: $outFile" -Level "SUCCESS"
        } catch {
            Log-Message -Message "Failed to write Chocolatey package check results to file: $($_.Exception.Message)" -Level "ERROR"
        }

    } catch {
        Log-Message -Message "Error during Chocolatey package checking: $($_.Exception.Message)" -Level "ERROR"
    }

    return $installedPackages
}

# ---------------------------------------------------------------------------- #
# Function to Install Packages
function Install-Packages {
    param(
        [Parameter(Mandatory=$true)]
        [array]$PackageList
    )

    $totalPackagesCount = 0
    $installedPackagesCount = 0
    $skippedPackagesCount = 0
    $failedPackagesCount = 0
    $userSkippedCount = 0
    $wingetCommand = "winget install --id {0} --exact --silent --accept-source-agreements --accept-package-agreements --force"
    $chocoCommand = "choco install {0} -y --no-progress --ignore-checksums --limit-output --no-color"

    # Wait for background jobs to complete and get results
    Show-InfoMessage "Waiting for package scanning to complete..."
    Log-Message -Message "Waiting for background package scanning jobs to complete." -Level "INFO"

    $installedPackages = @{}

    # Wait for Winget job and get results
    if ($Global:WingetJob -and $Global:WingetJob.State -eq "Running") {
        Show-InfoMessage "Waiting for Winget package scan to complete..."
        $wingetResults = Wait-Job $Global:WingetJob | Receive-Job
        Remove-Job $Global:WingetJob
        $wingetResults.GetEnumerator() | ForEach-Object { $installedPackages[$_.Key] = $_.Value }
        Log-Message -Message "Winget package scan completed." -Level "SUCCESS"
    } elseif ($Global:WingetJob -and $Global:WingetJob.State -eq "Completed") {
        $wingetResults = Receive-Job $Global:WingetJob
        Remove-Job $Global:WingetJob
        $wingetResults.GetEnumerator() | ForEach-Object { $installedPackages[$_.Key] = $_.Value }
    }

    # Wait for Chocolatey job and get results
    if ($Global:ChocoJob -and $Global:ChocoJob.State -eq "Running") {
        Show-InfoMessage "Waiting for Chocolatey package scan to complete..."
        $chocoResults = Wait-Job $Global:ChocoJob | Receive-Job
        Remove-Job $Global:ChocoJob
        $chocoResults.GetEnumerator() | ForEach-Object { $installedPackages[$_.Key] = $_.Value }
        Log-Message -Message "Chocolatey package scan completed." -Level "SUCCESS"
    } elseif ($Global:ChocoJob -and $Global:ChocoJob.State -eq "Completed") {
        $chocoResults = Receive-Job $Global:ChocoJob
        Remove-Job $Global:ChocoJob
        $chocoResults.GetEnumerator() | ForEach-Object { $installedPackages[$_.Key] = $_.Value }
    }

    Show-InfoMessage "Package scanning completed. Starting installations..."
    Log-Message -Message "Starting package installation phase." -Level "INFO"

    # Install Packages with user confirmation for Permission="false" packages
    foreach ($pkg in $PackageList) {
        $pkgId = $pkg.ID
        $pkgName = $pkg.Name
        $pkgDescription = $pkg.Description
        $pkgHomepage = $pkg.Homepage
        $source = $pkg.source
        $permission = $pkg.Permission

        Write-SubsectionHeader -Title "Processing: $pkgName"
        Show-InfoMessage "$pkgDescription"
        Show-InfoMessage "$pkgHomepage"
        Show-InfoMessage "$source"

        Log-Message -Message "Processing package: $pkgId ($pkgName)" -Level "INFO"
        $totalPackagesCount++

        # Check if package is already installed
        if ($installedPackages[$pkgId]) {
            Show-InfoMessage "Package '$pkgName' is already installed. Skipping."
            Log-Message -Message "Package '$pkgId' ($pkgName) is already installed. Skipping." -Level "INFO"
            $skippedPackagesCount++
            Write-Host ""
            continue
        }

        # Check permission and prompt user if needed
        $shouldInstall = $true
        if ($permission -eq "false") {
            Write-Host ""
            $userChoice = Prompt-UserConfirmation -PromptMessage "Do you want to install '$pkgName'? (Y/N): " -PromptColor $Script:WinfigColors.Primary

            if (-not $userChoice) {
                Show-InfoMessage "User chose to skip '$pkgName'."
                Log-Message -Message "User skipped package '$pkgId' ($pkgName)." -Level "INFO"
                $userSkippedCount++
                $shouldInstall = $false
            } else {
                Show-InfoMessage "User chose to install '$pkgName'."
                Log-Message -Message "User confirmed installation of '$pkgId' ($pkgName)." -Level "INFO"
            }
        }

        if ($shouldInstall) {
            try {
                if ($source -eq "winget") {
                    $installCmd = $wingetCommand -f $pkgId
                    Log-Message -Message "Executing: $installCmd" -Level "DEBUG"
                    & cmd /c $installCmd 2>$null
                } elseif ($source -eq "choco") {
                    $installCmd = $chocoCommand -f $pkgId
                    Log-Message -Message "Executing: $installCmd" -Level "DEBUG"
                    & cmd /c $installCmd 2>$null
                } else {
                    Show-ErrorMessage "Unknown source '$source' for package '$pkgName'. Skipping."
                    Log-Message -Message "Unknown source '$source' for package '$pkgId'. Skipping." -Level "ERROR"
                    $failedPackagesCount++
                    Write-Host ""
                    continue
                }

                if ($LASTEXITCODE -eq 0) {
                    Show-SuccessMessage "Successfully installed '$pkgName'."
                    Log-Message -Message "Successfully installed '$pkgId' ($pkgName)." -Level "SUCCESS"
                    $installedPackagesCount++
                } else {
                    Show-ErrorMessage "Failed to install '$pkgName' (Exit code: $LASTEXITCODE)"
                    Log-Message -Message "Failed to install '$pkgId' ($pkgName) with exit code $LASTEXITCODE" -Level "ERROR"
                    $failedPackagesCount++
                }
            } catch {
                Show-ErrorMessage "Failed to install '$pkgName': $($_.Exception.Message)"
                Log-Message -Message "Failed to install '$pkgId' ($pkgName): $($_.Exception.Message)" -Level "ERROR"
                $failedPackagesCount++
            }
        }

        Write-Host ""
    }

    # Summary with user-skipped packages
    Write-SubsectionHeader -Title "Installation Summary"
    Show-InfoMessage "Total packages: $totalPackagesCount"
    Show-InfoMessage "Installed: $installedPackagesCount"
    Show-InfoMessage "Skipped (already installed): $skippedPackagesCount"
    Show-InfoMessage "Skipped (user choice): $userSkippedCount"
    if ($failedPackagesCount -gt 0) {
        Show-ErrorMessage "Failed: $failedPackagesCount"
    }

    Log-Message -Message "Installation completed. Total: $totalPackagesCount, Installed: $installedPackagesCount, Already Installed: $skippedPackagesCount, User Skipped: $userSkippedCount, Failed: $failedPackagesCount" -Level "INFO"
}

# ---------------------------------------------------------------------------- #
# CTRL+C Signal Handler
trap {
    # Check if the error is due to a user interrupt (CTRL+C)
    if ($_.Exception.GetType().Name -eq "HostException" -and $_.Exception.Message -match "stopped by user") {

        # 1. Print the desired message
        Write-Host ""
        Write-Host ">>> [!] User interruption (CTRL+C) detected. Exiting gracefully..." -ForegroundColor $Script:WinfigColors.Accent

        # 2. Log the event before exit
        Log-Message -Message "Script interrupted by user (CTRL+C)." -Level "WARN"

        # 3. Write log footer before exiting
        if ($Global:WinfigLogFilePath) {
            Log-Message -Message "Script terminated by user (CTRL+C)." -EndRun
        }

        # 4. Terminate the script cleanly (exit code 1 is standard for non-zero exit)
        exit 1
    }
    # If it's a different kind of error, let the default behavior (or next trap) handle it
    continue
}

# ====================================================================== #
#  Main Script Execution
# ====================================================================== #

Winfig-Banner
Write-SectionHeader -Title "Creating Restore Point"
try {
    if (-not (Get-Command Checkpoint-Computer -ErrorAction SilentlyContinue)) {
        Show-WarningMessage "Checkpoint-Computer not available on this system. Skipping restore point creation."
        Log-Message -Message "Checkpoint-Computer cmdlet missing." -Level "WARN"
    } else {
        $drive = "C:\"
        # Ensure System Restore is enabled for system drive
        $hasRestorePoints = Get-ComputerRestorePoint -ErrorAction SilentlyContinue
        if (-not $hasRestorePoints) {
            Show-WarningMessage "System Restore appears disabled for $drive. Enabling..."
            Log-Message -Message "Enabling System Restore on $drive" -Level "INFO"
            try {
                Enable-ComputerRestore -Drive $drive -ErrorAction Stop
                Log-Message -Message "Enabled System Restore on $drive" -Level "SUCCESS"
            } catch {
                Show-ErrorMessage "Failed to enable System Restore: $($_.Exception.Message)"
                Log-Message -Message "Enable-ComputerRestore failed: $($_.Exception.Message)" -Level "ERROR"
            }
        }

        $timestamp = (Get-Date).ToString("yyyy-MM-dd HH:mm:ss")
        $description = "Winfig Restore Point - $timestamp"
        $maxRetries = 3
        $attempt = 0
        $created = $false
        while (-not $created -and $attempt -lt $maxRetries) {
            $attempt++
            try {
                Log-Message -Message "Creating restore point (attempt #$attempt): $description" -Level "INFO"
                Checkpoint-Computer -Description $description -RestorePointType MODIFY_SETTINGS -ErrorAction Stop
                Show-SuccessMessage "Restore point created: $description"
                Log-Message -Message "Restore point creation succeeded." -Level "SUCCESS"
                $created = $true
            } catch {
                Show-WarningMessage "Attempt #$attempt failed: $($_.Exception.Message)"
                Log-Message -Message "Checkpoint-Computer attempt #$attempt failed: $($_.Exception.Message)" -Level "WARN"
                Start-Sleep -Seconds (5 * $attempt)
            }
        }

        if (-not $created) {
            Show-ErrorMessage "Failed to create restore point after $maxRetries attempts."
            Log-Message -Message "Restore point creation failed after $maxRetries attempts." -Level "ERROR"
        }
    }
} catch {
    Show-ErrorMessage "Unexpected error while creating restore point: $($_.Exception.Message)"
    Log-Message -Message "Unexpected error while creating restore point: $($_.Exception.Message)" -Level "ERROR"
}

Winfig-Banner

Write-SectionHeader -Title "Checking Requirements"
Write-Host ""

IsAdmin | Out-Null
Show-SuccessMessage "Administrator privileges confirmed."

Is-Windows11 | Out-Null
Show-SuccessMessage "Operating System is Windows 11."

Test-InternetConnection | Out-Null
Show-SuccessMessage "Internet connection is available."

Test-FreeDiskSpace | Out-Null
Show-SuccessMessage "Sufficient disk space is available."

Test-ExecutionPolicy | Out-Null
Show-SuccessMessage "Execution Policy is sufficient."

Test-PSVersion | Out-Null
Show-SuccessMessage "PowerShell version is sufficient."

Write-Host ""
Prompt-UserContinue

Winfig-Banner
Write-SectionHeader -Title "Checking Package Managers"
Write-Host ""
$wingetInstalled = Check-Winget
if ($wingetInstalled) {
    Show-SuccessMessage "Winget is installed."
} else {
    Show-ErrorMessage "Winget is not installed."
    Show-InfoMessage "Installing Winget..."
    Log-Message -Message "Winget not found. Starting installation routine." -Level "INFO"

    $wingetUrl = getNewestLink("msixbundle")
    Log-Message -Message "Retrieved winget download URL: $wingetUrl" -Level "DEBUG"
    $wingetLicenseUrl = getNewestLink("License1.xml")
    Log-Message -Message "Retrieved winget license download URL: $wingetLicenseUrl" -Level "DEBUG"

    $downloadFolder = (New-Object -ComObject Shell.Application).NameSpace('shell:Downloads').Self.Path
    $url = "https://www.nuget.org/api/v2/package/Microsoft.UI.Xaml/2.8.1"
    $nupkgFolder = Join-Path -Path $downloadFolder -ChildPath "Microsoft.UI.Xaml.2.8.1"
    $zipFile = Join-Path -Path $downloadFolder -ChildPath "Microsoft.UI.Xaml.2.8.1.nupkg.zip"

    try {
        Log-Message -Message "Downloading XAML nupkg from $url to $zipFile" -Level "INFO"
        Invoke-WebRequest -Uri $url -OutFile $zipFile -UseBasicParsing -ErrorAction Stop | Out-Null
        Log-Message -Message "Downloaded XAML nupkg to $zipFile" -Level "SUCCESS"

        Log-Message -Message "Extracting nupkg to $nupkgFolder" -Level "INFO"
        if (Test-Path -Path $nupkgFolder) {
            Remove-Item -Path $nupkgFolder -Recurse -Force -ErrorAction SilentlyContinue | Out-Null
        }
        Expand-Archive -Path $zipFile -DestinationPath $nupkgFolder -Force -ErrorAction Stop | Out-Null
        Log-Message -Message "Extraction complete: $nupkgFolder" -Level "SUCCESS"

        if ([Environment]::Is64BitOperatingSystem) {
            Show-InfoMessage "64-bit OS detected"
            Log-Message -Message "Detected 64-bit OS; installing x64 dependencies" -Level "INFO"

            Log-Message -Message "Downloading & installing x64 VCLibs..." -Level "INFO"
            Add-AppxPackage -ErrorAction SilentlyContinue ("https://aka.ms/Microsoft.VCLibs.x64.14.00.Desktop.appx")
            Log-Message -Message "x64 VCLibs installation attempted" -Level "DEBUG"

            Log-Message -Message "Installing x64 XAML from $nupkgFolder\tools\AppX\x64\Release\Microsoft.UI.Xaml.2.8.appx" -Level "INFO"
            Add-AppxPackage -ErrorAction SilentlyContinue ((Join-Path -Path $nupkgFolder -ChildPath "tools\AppX\x64\Release\Microsoft.UI.Xaml.2.8.appx"))
            Log-Message -Message "x64 XAML installation attempted" -Level "DEBUG"
        } else {
            Show-InfoMessage "32-bit OS detected"
            Log-Message -Message "Detected 32-bit OS; installing x86 dependencies" -Level "INFO"

            Log-Message -Message "Downloading & installing x86 VCLibs..." -Level "INFO"
            Add-AppxPackage -ErrorAction SilentlyContinue ("https://aka.ms/Microsoft.VCLibs.x86.14.00.Desktop.appx") | Out-Null
            Log-Message -Message "x86 VCLibs installation attempted" -Level "DEBUG"

            Log-Message -Message "Installing x86 XAML from $nupkgFolder\tools\AppX\x86\Release\Microsoft.UI.Xaml.2.8.appx" -Level "INFO"
            Add-AppxPackage -ErrorAction SilentlyContinue ((Join-Path -Path $nupkgFolder -ChildPath "tools\AppX\x86\Release\Microsoft.UI.Xaml.2.8.appx")) | Out-Null
            Log-Message -Message "x86 XAML installation attempted" -Level "DEBUG"
        }

        # Finally, install winget
        Log-Message -Message "Preparing to download and install winget bundle" -Level "INFO"
        if (-not $wingetUrl -or -not $wingetLicenseUrl) {
            Log-Message -Message "wingetUrl or wingetLicenseUrl is not defined." -Level "WARN"
            Show-WarningMessage "wingetUrl or wingetLicenseUrl is not defined; winget download may fail."
        }

        $wingetPath = Join-Path -Path $downloadFolder -ChildPath "winget.msixbundle"
        $wingetLicensePath = Join-Path -Path $downloadFolder -ChildPath "license1.xml"

        if ($wingetUrl) {
            Log-Message -Message "Downloading winget from $wingetUrl to $wingetPath" -Level "INFO"
            Invoke-WebRequest -Uri $wingetUrl -OutFile $wingetPath -UseBasicParsing -ErrorAction Stop | Out-Null
            Log-Message -Message "Downloaded winget to $wingetPath" -Level "SUCCESS"
        }

        if ($wingetLicenseUrl) {
            Log-Message -Message "Downloading winget license from $wingetLicenseUrl to $wingetLicensePath" -Level "INFO"
            Invoke-WebRequest -Uri $wingetLicenseUrl -OutFile $wingetLicensePath -UseBasicParsing -ErrorAction Stop | Out-Null
            Log-Message -Message "Downloaded winget license to $wingetLicensePath" -Level "SUCCESS"
        }

        Log-Message -Message "Installing winget package using Add-AppxProvisionedPackage" -Level "INFO"
        Add-AppxProvisionedPackage -Online -PackagePath $wingetPath -LicensePath $wingetLicensePath -ErrorAction Stop | Out-Null
        Log-Message -Message "Add-AppxProvisionedPackage completed" -Level "SUCCESS"

        # Add WindowsApps to user PATH
        Log-Message -Message "Adding WindowsApps directory to PATH for current user" -Level "INFO"
        $userPath = [Environment]::GetEnvironmentVariable("PATH", "User")
        $windowsApps = [IO.Path]::Combine([Environment]::GetEnvironmentVariable("LOCALAPPDATA"), "Microsoft", "WindowsApps")
        if ($userPath -notlike "*$windowsApps*") {
            $newPath = $userPath + ";" + $windowsApps
            [Environment]::SetEnvironmentVariable("PATH", $newPath, "User")
            Log-Message -Message "WindowsApps added to PATH: $windowsApps" -Level "SUCCESS"
        } else {
            Log-Message -Message "WindowsApps already present in user PATH" -Level "DEBUG"
        }

        Log-Message -Message "Winget installation routine completed successfully." -Level "SUCCESS"
        Show-SuccessMessage "Winget installed successfully."
        Log-Message -Message "Verifying Winget presence after install." -Level "INFO"
        Check-Winget | Out-Null
    } catch {
        $errMsg = $_.Exception.Message
        Show-ErrorMessage "Failed to install Winget: $errMsg"
        Log-Message -Message "Failed to install Winget: $errMsg" -Level "ERROR"
        Log-Message "Forced exit." -EndRun
        $LogPathMessage = "Check the Log file for details: $($Global:WinfigLogFilePath)"
        Show-InfoMessage -Message $LogPathMessage
        exit 1
    } finally {
        Log-Message -Message "Cleaning up temporary installation files" -Level "INFO"
        try { Remove-Item -Path $zipFile -ErrorAction SilentlyContinue -Force | Out-Null } catch {}
        try { Remove-Item -Path $nupkgFolder -Recurse -ErrorAction SilentlyContinue -Force | Out-Null } catch {}
        try { Remove-Item -Path $wingetPath -ErrorAction SilentlyContinue -Force | Out-Null } catch {}
        try { Remove-Item -Path $wingetLicensePath -ErrorAction SilentlyContinue -Force | Out-Null } catch {}
        Log-Message -Message "Cleanup complete." -Level "DEBUG"
    }
}

$chocoInstalled = Check-Chocolatey
if ($chocoInstalled) {
    Show-SuccessMessage "Chocolatey is installed."
} else {
    Show-ErrorMessage "Chocolatey is not installed."
    Show-InfoMessage "Installing Chocolatey..."
    try {
        [System.Net.ServicePointManager]::SecurityProtocol = [System.Net.ServicePointManager]::SecurityProtocol -bor 3072
        Invoke-Expression ((New-Object System.Net.WebClient).DownloadString('https://community.chocolatey.org/install.ps1')) | Out-Null
        Show-SuccessMessage "Chocolatey installed successfully."
        Log-Message -Message "Chocolatey installed successfully." -Level "SUCCESS"
    } catch {
        Show-ErrorMessage "Failed to install Chocolatey: $($_.Exception.Message)"
        Log-Message -Message "Failed to install Chocolatey: $($_.Exception.Message)" -Level "ERROR"
        Log-Message "Forced exit." -EndRun
        $LogPathMessage = "Check the Log file for details: $($Global:WinfigLogFilePath)"
        Show-InfoMessage -Message $LogPathMessage
        exit 1
    }
}

Log-Message -Message "Starting background package scanning jobs." -Level "INFO"

# Start Winget package checking job using the function
$Global:WingetJob = Start-Job -InitializationScript {
    # Define the function inside the job scope
    function Get-InstalledWingetPackages {
        param(
            [Parameter(Mandatory=$true)]
            [array]$PackageList
        )

        $installedPackages = @{}
        $wingetPackages = $PackageList | Where-Object { $_.source -eq "winget" }

        if ($wingetPackages.Count -eq 0) {
            return $installedPackages
        }

        try {
            foreach ($pkg in $wingetPackages) {
                $pkgId = $pkg.ID
                $pkgName = $pkg.Name

                try {
                    # Check if this specific package is installed
                    $result = & winget list --id $pkgId --exact 2>$null

                    if ($LASTEXITCODE -eq 0 -and ($result | Out-String) -match $pkgId) {
                        $installedPackages[$pkgId] = $true
                    } else {
                        $installedPackages[$pkgId] = $false
                    }
                } catch {
                    $installedPackages[$pkgId] = $false
                }
            }
        } catch {
            # Return empty hashtable on error
        }

        return $installedPackages
    }
} -ScriptBlock {
    param($PackageList, $WinfigPaths)

    # Call the function
    $result = Get-InstalledWingetPackages -PackageList $PackageList
    return $result

} -ArgumentList $Script:Packages, $Global:WinfigPaths

# Start Chocolatey package checking job using the function
$Global:ChocoJob = Start-Job -InitializationScript {
    # Define the function inside the job scope
    function Get-InstalledChocolateyPackages {
        param(
            [Parameter(Mandatory=$true)]
            [array]$PackageList
        )

        $installedPackages = @{}
        $chocoPackages = $PackageList | Where-Object { $_.source -eq "choco" }

        if ($chocoPackages.Count -eq 0) {
            return $installedPackages
        }

        try {
            foreach ($pkg in $chocoPackages) {
                $pkgId = $pkg.ID
                $pkgName = $pkg.Name

                try {
                    # Check if this specific package is installed
                    $result = & choco list --local-only --exact $pkgId 2>$null

                    if ($LASTEXITCODE -eq 0 -and ($result | Out-String) -match $pkgId) {
                        $installedPackages[$pkgId] = $true
                    } else {
                        $installedPackages[$pkgId] = $false
                    }
                } catch {
                    $installedPackages[$pkgId] = $false
                }
            }
        } catch {
            # Return empty hashtable on error
        }

        return $installedPackages
    }
} -ScriptBlock {
    param($PackageList, $WinfigPaths)

    # Call the function
    $result = Get-InstalledChocolateyPackages -PackageList $PackageList
    return $result

} -ArgumentList $Script:Packages, $Global:WinfigPaths

Show-InfoMessage "Package scanning started in background. Results will be ready during package installation."
Log-Message -Message "Background package scanning jobs started: Winget Job ID $($Global:WingetJob.Id), Choco Job ID $($Global:ChocoJob.Id)" -Level "INFO"

Write-Host ""
Prompt-UserContinue

Winfig-Banner
Write-SectionHeader -Title "Winfig Debloat" -Description "Removing Unwanted Appx Packages"
Write-Host ""

$DebloatPrompt = Prompt-UserConfirmation -PromptMessage "Do you want to Debloat Windows 11 by removing unwanted Appx Packages? (Y/N): " -PromptColor $Script:WinfigColors.Primary

if ($DebloatPrompt) {
    Write-Host ""
    Show-InfoMessage "Starting Debloat process..."
    Log-Message -Message "User confirmed Debloat process." -Level "INFO"
    Uninstall-AppxPackages -AppList $Script:AppList
} else {
    Write-Host ""
    Show-InfoMessage "Debloat process skipped by user."
    Log-Message -Message "User skipped Debloat process." -Level "INFO"
}

Write-Host ""
Prompt-UserContinue

Winfig-Banner
Write-SectionHeader -Title "Winfig Optimization" -Description "Applying Registry Optimizations"
Write-Host ""

$OptimizePrompt = Prompt-UserConfirmation -PromptMessage "Do you want to apply Registry Optimizations? (Y/N): " -PromptColor $Script:WinfigColors.Primary

if ($OptimizePrompt) {
    Write-Host ""
    Show-InfoMessage "Starting Registry Optimization process..."
    Log-Message -Message "User confirmed Registry Optimization process." -Level "INFO"
    Optimize-Registry
} else {
    Write-Host ""
    Show-InfoMessage "Registry Optimization process skipped by user."
    Log-Message -Message "User skipped Registry Optimization process." -Level "INFO"
}

Write-Host ""
Prompt-UserContinue

Winfig-Banner
Write-SectionHeader -Title "CTT Winutil" -Description "Windows Tweaking Utility"
Write-Host ""

$WinutilPrompt = Prompt-UserConfirmation -PromptMessage "Do you want to run CTT Winutil to apply additional tweaks? (Y/N): " -PromptColor $Script:WinfigColors.Primary
if ($WinutilPrompt) {
    Write-Host ""
    Show-InfoMessage "IMPORTANT INSTRUCTIONS:"
    Show-InfoMessage "1. Winutil will open in a new window"
    Show-InfoMessage "2. Your preset configuration is saved on Desktop as 'winfig-preset.json'"
    Show-InfoMessage "3. In Winutil, click 'Import' and select the winfig-preset.json file from Desktop"
    Show-InfoMessage "4. This will apply your custom optimization settings"
    Show-InfoMessage "Launching CTT Winutil..."
    $Time = Measure-Command { Run-CTTWinutil }
    Log-Message -Message "User opted to run CTT Winutil." -Level "INFO"
    Log-Message -Message "CTT Winutil Took $Time to complete." -Level "INFO"
} else {
    Write-Host ""
    Show-InfoMessage "CTT Winutil launch skipped by user."
    Log-Message -Message "User skipped CTT Winutil launch." -Level "INFO"
}

Write-Host ""
Prompt-UserContinue

Winfig-Banner
Write-SectionHeader -Title "Winfig Package Installation" -Description "Installing Recommended Software"
$InstallPrompt = Prompt-UserConfirmation -PromptMessage "Do you want to install the recommended software packages? (Y/N): " -PromptColor $Script:WinfigColors.Primary
if ($InstallPrompt) {
    Write-Host ""
    Show-InfoMessage "Starting Package Installation process..."
    Install-Packages -PackageList $Script:Packages
    Log-Message -Message "User confirmed Package Installation process." -Level "INFO"
} else {
    Write-Host ""
    Show-InfoMessage "Package Installation process skipped by user."
    Log-Message -Message "User skipped Package Installation process." -Level "INFO"
    Log-Message "Logging Completed." -EndRun
    exit 0
}
Write-Host ""

Write-SectionHeader -Title "Thank You For Using Winfig Bootstrap" -Description "https://github.com/Get-Wingig/"
Show-WarningMessage -Message "Restart Windows to apply changes"
Write-Host ""
Log-Message -Message "Logging Completed." -EndRun
