Param(
	[string]$Tag,
	[string]$Machine = 'default',
	[string]$WorkDir = '/home/docker/Build-DockerCli',
	[string]$OutputDir = "/c/Users/$env:USERNAME"
)

function Invoke-SshCommand([string]$Command) {
	docker-machine ssh $Machine ($Command -replace "`r", '')
}

if (!(Get-Command -Name docker-machine -ErrorAction SilentlyContinue)) {
	Write-Host 'docker-machine is required' -ForegroundColor Red
	return
}

if ((docker-machine status $Machine) -ne 'Running') {
	Write-Host "Docker machine [$Machine] is required to be Running" -ForegroundColor Red
	return
}

# Install required package (make)
Invoke-SshCommand @"
export http_proxy=$env:http_proxy
export https_proxy=$env:https_proxy
tce-load -wi make
"@

# Clear working directory
Invoke-SshCommand @"
sudo rm -rf $WorkDir
mkdir -p $WorkDir
"@

# Save source
Invoke-SshCommand @"
cd $WorkDir

# Sparse checkout
git config --global http.proxy $env:http_proxy
git config --global https.proxy $env:https_proxy
git init
git config core.sparsecheckout true
git remote add origin https://github.com/docker/docker-ce.git
echo 'components/cli' > .git/info/sparse-checkout
git pull --tags --depth 1 origin master

# Switch tag (target version)
if [[ -n `"$Tag`" ]]; then
	git checkout tags/$Tag
	git checkout -B $Tag
fi
"@

# Build binary
Invoke-SshCommand @"
cd $WorkDir/components/cli
cat VERSION
# Try binary-windows, a new target since v17.10.0 https://github.com/docker/cli/pull/531
make -f docker.Makefile binary-windows
if [[ $? != 0 ]]; then
	make -f docker.Makefile cross
fi
"@

# Copy binary
Invoke-SshCommand "cp $WorkDir/components/cli/build/docker-windows-amd64 $OutputDir/docker.exe"
