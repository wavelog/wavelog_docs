#!/usr/bin/env pwsh
# Pretty runner for all docs checks - PowerShell equivalent of run.sh.
# BuildKit-style output: while a check runs, only a live tail of its last few
# output lines is shown; on success it collapses to a single OK line, on
# failure the full log is printed. Runs every check even if one fails and
# prints a summary at the end. Without a TTY (CI, pipes) it falls back to
# plain full output.
#
# Unlike run.sh this does not go through `make` (rarely present on Windows);
# it calls the same Docker commands as the Makefile targets directly.
# Requires Docker Desktop on PATH. Runs on Windows PowerShell 5.1 and pwsh 7+.
#
# NOTE: glyphs are built from [char] codes on purpose so the script parses
# regardless of how the file is saved (5.1 reads scripts as ANSI by default).

$ErrorActionPreference = 'Stop'
Set-Location (Join-Path $PSScriptRoot '..')

$IMAGE  = 'wavelog-docs'
$CURDIR = (Get-Location).Path
$ESC    = [char]27

# Box / status glyphs as code points - keeps the source pure ASCII.
$G = @{
  tl = [char]0x250C; tr = [char]0x2510; bl = [char]0x2514; br = [char]0x2518
  h  = [char]0x2500; v  = [char]0x2502
  ok = [char]0x2714; no = [char]0x2716; run = [char]0x25B6
}

$TTY = -not [Console]::IsOutputRedirected

# Windows PowerShell 5.1: enable VT processing (cursor moves + colors) and make
# sure UTF-8 glyphs render. pwsh 7+ does both already.
if ($TTY -and $PSVersionTable.PSVersion.Major -lt 6) {
  try {
    [Console]::OutputEncoding = [System.Text.UTF8Encoding]::new()
    Add-Type -Namespace WinVT -Name K -MemberDefinition @'
[System.Runtime.InteropServices.DllImport("kernel32.dll", SetLastError=true)]
public static extern System.IntPtr GetStdHandle(int n);
[System.Runtime.InteropServices.DllImport("kernel32.dll", SetLastError=true)]
public static extern bool GetConsoleMode(System.IntPtr h, out int m);
[System.Runtime.InteropServices.DllImport("kernel32.dll", SetLastError=true)]
public static extern bool SetConsoleMode(System.IntPtr h, int m);
'@
    $hOut = [WinVT.K]::GetStdHandle(-11)
    $mode = 0
    [void][WinVT.K]::GetConsoleMode($hOut, [ref]$mode)
    [void][WinVT.K]::SetConsoleMode($hOut, $mode -bor 0x0004)  # ENABLE_VIRTUAL_TERMINAL_PROCESSING
  } catch { $TTY = $false }
}

if ($TTY) {
  $BOLD = "$ESC[1m"; $DIM = "$ESC[2m"; $RED = "$ESC[31m"
  $GREEN = "$ESC[32m"; $CYAN = "$ESC[36m"; $RESET = "$ESC[0m"
} else {
  $BOLD = ''; $DIM = ''; $RED = ''; $GREEN = ''; $CYAN = ''; $RESET = ''
}

$WIDTH  = 64    # width of the boxes/rules
$WINDOW = 10    # number of live tail lines per running check

function Write-Raw { param([string]$s) [Console]::Out.Write($s) }
function Get-Rule  { [string]$G.h * $WIDTH }

function Write-Box {  # Write-Box <text>
  param([string]$Text)
  Write-Raw ("`n  {0}{1}{2}{3}{4}`n" -f $DIM, $G.tl, (Get-Rule), $G.tr, $RESET)
  Write-Raw ("  {0}{1}{2} {3}{4}{5}{6}{7}{8}`n" -f $DIM, $G.v, $RESET, $BOLD, ($Text.PadRight($WIDTH - 2)), $RESET, $DIM, $G.v, $RESET)
  Write-Raw ("  {0}{1}{2}{3}{4}`n`n" -f $DIM, $G.bl, (Get-Rule), $G.br, $RESET)
}

# Strip ANSI escape sequences (CSI colors + OSC title sequences).
function Remove-Ansi {
  param([string]$s)
  $bel = [char]7
  $s = $s -replace "$ESC\[[0-9;?]*[a-zA-Z]", ''
  $s = $s -replace "$ESC\][^$bel]*$bel?", ''
  return $s
}

# run_check equivalent: run a command, windowed on a TTY.
# Returns the process exit code; writes raw output to $Log.
function Invoke-Check {
  param([string[]]$Cmd, [string]$Log)

  # Native stderr (docker writes progress there) is wrapped as ErrorRecords by
  # `2>&1`; with -ErrorActionPreference Stop that would throw on the first line.
  $ErrorActionPreference = 'Continue'
  Set-Content -Path $Log -Value '' -NoNewline

  if (-not $TTY) {
    & $Cmd[0] @($Cmd[1..($Cmd.Count - 1)]) 2>&1 |
      ForEach-Object { $line = $_.ToString(); Add-Content -Path $Log -Value $line; $line }
    return $LASTEXITCODE
  }

  $cols  = [Math]::Max(20, [Console]::WindowWidth - 8)
  $buf   = [System.Collections.Generic.List[string]]::new()
  $drawn = 0

  & $Cmd[0] @($Cmd[1..($Cmd.Count - 1)]) 2>&1 | ForEach-Object {
    $raw = $_.ToString()
    Add-Content -Path $Log -Value $raw
    # Turn carriage returns (progress bars) into newlines, strip ANSI.
    foreach ($l in (Remove-Ansi $raw) -split "[`r`n]") {
      if ($l.Trim().Length -eq 0) { continue }
      if ($l.Length -gt $cols) { $l = $l.Substring(0, $cols) }
      $buf.Add($l)
      while ($buf.Count -gt $WINDOW) { $buf.RemoveAt(0) }
      if ($drawn -gt 0) { Write-Raw "$ESC[${drawn}A" }
      foreach ($b in $buf) { Write-Raw "$ESC[2K      $DIM$b$RESET`n" }
      $drawn = $buf.Count
    }
  }
  # Collapse: move up and clear from cursor to end of screen.
  if ($drawn -gt 0) { Write-Raw "$ESC[${drawn}A$ESC[0J" }
  return $LASTEXITCODE
}

# Same images and arguments as the Makefile / CI workflows.
$CHECKS = @(
  @{ Name = 'lint';  Label = 'Markdown Lint    (markdownlint-cli2)'
     Args = @('run', '--rm', '-t', '-v', "${CURDIR}:/workdir",
              'davidanson/markdownlint-cli2',
              '--config', 'tests/.markdownlint-cli2.jsonc', '--fix', 'docs/**/*.md') }
  @{ Name = 'build'; Label = 'Build Check      (zensical build --strict)'; Image = $true
     Args = @('run', '--rm', '-t', '-e', 'HOME=/tmp', '-v', "${CURDIR}:/docs",
              $IMAGE, 'zensical', 'build', '--strict') }
  @{ Name = 'links'; Label = 'Dead Link Check  (lychee)'
     Args = @('run', '--rm', '-t', '-w', '/input', '-v', "${CURDIR}:/input",
              'lycheeverse/lychee',
              '--cache', '--max-retries', '5', '--retry-wait-time', '5',
              '--max-cache-age', '30d', 'docs/') }
)

# --- preflight: docker present? -----------------------------------------
if (-not (Get-Command docker -ErrorAction SilentlyContinue)) {
  Write-Raw "${RED}ERROR: docker not found. Install Docker Desktop first: https://docs.docker.com/engine/install/${RESET}`n"
  exit 1
}

$TOTAL   = $CHECKS.Count
$FAILED  = 0
$START   = [Diagnostics.Stopwatch]::StartNew()
$LOG     = New-TemporaryFile
$RESULTS = @()

try {
  Write-Raw "`n  ${BOLD}${CYAN}(Run Starting)${RESET}`n"
  Write-Box "Wavelog Docs - $TOTAL checks: lint, build, links"

  # Build the local zensical image once if any check needs it - windowed like
  # the checks (--progress=plain so the steps actually stream into the tail).
  if ($CHECKS | Where-Object { $_.Image }) {
    Write-Raw "  ${CYAN}$($G.run)${RESET} [0/$TOTAL] Build Image      (docker build)`n"
    $bt = [Diagnostics.Stopwatch]::StartNew()
    $bc = Invoke-Check -Cmd @('docker', 'build', '--progress=plain', '-t', $IMAGE, '-f', 'tests/Dockerfile', '.') -Log $LOG
    if ($bc -eq 0) {
      if ($TTY) { Write-Raw "$ESC[1A$ESC[2K" }
      Write-Raw "  ${GREEN}$($G.ok)${RESET} [0/$TOTAL] Build Image      (docker build) ${DIM}($([int]$bt.Elapsed.TotalSeconds)s)${RESET}`n"
    } else {
      if ($TTY) { Write-Raw "$ESC[1A$ESC[2K" }
      Write-Raw "  ${RED}$($G.no)${RESET} [0/$TOTAL] Build Image      (docker build)`n`n"
      foreach ($l in (Get-Content -Path $LOG)) { Write-Raw "      $l`n" }
      Write-Raw "`n  ${BOLD}${RED}$($G.no) Image build failed${RESET}`n`n"
      exit 1
    }
  }

  $i = 0
  foreach ($c in $CHECKS) {
    $i++
    Write-Raw "  ${CYAN}$($G.run)${RESET} [$i/$TOTAL] $($c.Label)`n"

    $t0   = [Diagnostics.Stopwatch]::StartNew()
    $code = Invoke-Check -Cmd (, 'docker' + $c.Args) -Log $LOG
    $secs = [int]$t0.Elapsed.TotalSeconds

    if ($code -eq 0) {
      $result = 'pass'
      if ($TTY) { Write-Raw "$ESC[1A$ESC[2K" }   # rewrite run header as OK
      Write-Raw "  ${GREEN}$($G.ok)${RESET} [$i/$TOTAL] $($c.Label) ${DIM}(${secs}s)${RESET}`n"
    } else {
      $result = 'fail'
      $FAILED++
      if ($TTY) { Write-Raw "$ESC[1A$ESC[2K" }
      Write-Raw "  ${RED}$($G.no)${RESET} [$i/$TOTAL] $($c.Label) ${DIM}(${secs}s)${RESET}`n`n"
      # on failure, show the full log
      foreach ($l in (Get-Content -Path $LOG)) { Write-Raw "      $l`n" }
      Write-Raw "`n"
    }
    $RESULTS += [pscustomobject]@{ Name = $c.Name; Result = $result; Time = $secs }
  }

  Write-Raw "`n  ${BOLD}${CYAN}(Run Finished)${RESET}`n"
  Write-Raw "`n  ${DIM}$(Get-Rule)${RESET}`n"
  foreach ($r in $RESULTS) {
    if ($r.Result -eq 'pass') {
      Write-Raw ("  {0}{1}{2}  {3,-10} {4}{5,3}s{6}   {7}passed{8}`n" -f $GREEN, $G.ok, $RESET, $r.Name, $DIM, $r.Time, $RESET, $GREEN, $RESET)
    } else {
      Write-Raw ("  {0}{1}{2}  {3,-10} {4}{5,3}s{6}   {7}failed{8}`n" -f $RED, $G.no, $RESET, $r.Name, $DIM, $r.Time, $RESET, $RED, $RESET)
    }
  }
  Write-Raw "  ${DIM}$(Get-Rule)${RESET}`n"

  $elapsed = [int]$START.Elapsed.TotalSeconds
  if ($FAILED -eq 0) {
    Write-Raw "  ${BOLD}${GREEN}$($G.ok) All $TOTAL checks passed${RESET} ${DIM}(${elapsed}s)${RESET} - ready to push!`n`n"
  } else {
    Write-Raw "  ${BOLD}${RED}$($G.no) $FAILED of $TOTAL checks failed${RESET} ${DIM}(${elapsed}s)${RESET}`n`n"
    exit 1
  }
} finally {
  Remove-Item -Path $LOG -ErrorAction SilentlyContinue
}
