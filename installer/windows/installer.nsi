; Nixvim Windows installer — stock Neovim + nixvim-generated config + vendored plugins
; staging/ is produced by the prepare-windows-payload job:
;   staging/config   = rewritten generated config  -> %LOCALAPPDATA%\nvim
;   staging/plugins  = vendored plugin sources     -> %LOCALAPPDATA%\nvim-plugins
;   staging/nvim     = official nvim-win64 zip contents
; store paths inside config/plugins were replaced by %LOCALAPPDATA%\nvim-plugins\<name>

[Setup]
AppName=Nixvim
AppVersion=0.1.0
AppPublisher=nixvim
DefaultDirName={autopf}\Nixvim
DefaultGroupName=Nixvim
DisableProgramGroupPage=yes
PrivilegesRequired=lowest
OutputDir=.
OutputBaseFilename=NixvimSetup
Compression=lzma2
SolidCompression=yes
ArchitecturesInstallIn64BitMode=x64compatible
UninstallDisplayIcon={app}\nvim-win64\bin\nvim.exe

[Languages]
Name: "english"; MessagesFile: "compiler:Default.isl"

[Code]
function InitializeSetup(): Boolean;
begin
  if FileExists(ExpandConstant('{localappdata}\nvim\init.lua')) then
    Result :=
      MsgBox(
        'Nixvim manages the whole Neovim config directory and will replace '
        + ExpandConstant('{localappdata}\nvim') + '. Continue?',
        mbConfirmation,
        [mbYes, mbNo]
      ) = mrYes
  else
    Result := True;
end;

[Files]
Source: "staging\nvim\*"; DestDir: "{app}\nvim-win64"; Flags: recursesubdirs
Source: "staging\config\*"; DestDir: "{localappdata}\nvim"; Flags: recursesubdirs createallsubdirs
Source: "staging\plugins\*"; DestDir: "{localappdata}\nvim-plugins"; Flags: recursesubdirs createallsubdirs

[Tasks]
Name: "addpath"; Description: "Add nvim.exe to PATH"; Flags: unchecked

[Registry]
Root: HKCU; Subkey: "Environment"; ValueType: expandsz; ValueName: "Path"; \
  ValueData: "{olddata};{app}\nvim-win64\bin"; Tasks: addpath

[Icons]
Name: "{group}\Nixvim"; Filename: "{app}\nvim-win64\bin\nvim.exe"

[Run]
Filename: "{app}\nvim-win64\bin\nvim.exe"; Description: "Launch Nixvim"; Flags: nowait postinstall skipifsilent
