oh-my-posh init pwsh --config "C:\Users\robertgriffin\scoop\apps\oh-my-posh\current\themes\powerlevel10k_lean.omp.json" | Invoke-Expression


Import-Module -Name Terminal-Icons
Import-Module posh-git
Import-Module -Name PSReadLine
Import-Module C:\Users\RobertGriffin\scoop\modules\posh-git\posh-git.psd1

Invoke-Expression (& { (zoxide init powershell | Out-String) })

# PSfzf

# replace 'Ctrl+t' and 'Ctrl+r' with your preferred bindings:
Set-PsFzfOption -PSReadlineChordProvider 'Ctrl+t' -PSReadlineChordReverseHistory 'Ctrl+r'
Set-PSReadLineKeyHandler -Chord "Ctrl+f" -Function ForwardWord


function gaa {
	git add .
}

function gst {
	git status
}

function gpsup {
    <#
    .SYNOPSIS
    Push the current branch to remote and set up tracking
    
    .DESCRIPTION
    Equivalent to oh-my-zsh's gpsup alias. Pushes the current git branch
    to the remote repository and sets it up to track the remote branch.
    #>
    
    # Get the current branch name
    $branch = git rev-parse --abbrev-ref HEAD 2>$null
    
    if ($LASTEXITCODE -ne 0) {
        Write-Error "Not in a git repository"
        return
    }
    
    if ($branch -eq "HEAD") {
        Write-Error "Cannot push in detached HEAD state"
        return
    }
    
    # Push and set upstream
    Write-Host "Pushing '$branch' and setting upstream tracking..." -ForegroundColor Cyan
    git push --set-upstream origin $branch
}

function gco {
    <#
    .SYNOPSIS
    Git checkout - switch branches or restore files
    
    .DESCRIPTION
    Equivalent to oh-my-zsh's gco alias (git checkout).
    
    .PARAMETER Branch
    The branch name or file path to checkout
    
    .EXAMPLE
    gco main
    gco feature/new-feature
    gco -- file.txt
    #>
    
    param(
#        [Parameter(Position=0)]
#        [ArgumentCompleter({
#            param($commandName, $parameterName, $wordToComplete, $commandAst, $fakeBoundParameters)
#            
#            git branch --format='%(refname:short)' 2>$null | Where-Object { 
#                $_ -like "$wordToComplete*" 
#            } | ForEach-Object {
#                [System.Management.Automation.CompletionResult]::new($_, $_, 'ParameterValue', $_)
#            }
#        })]
#        [string]$Branch,
        
        [Parameter(ValueFromRemainingArguments=$true)]
        [string[]]$Args
    )
    
    if ($Branch) {
        git checkout $Branch $Args
    } else {
        git checkout $Args
    }
}

function gcob {
    <#
    .SYNOPSIS
    Git checkout -b - create and switch to a new branch
    
    .DESCRIPTION
    Equivalent to oh-my-zsh's gcob alias (git checkout -b).
    Creates a new branch and switches to it.
    
    .PARAMETER BranchName
    The name of the new branch to create
    
    .EXAMPLE
    gcob feature/my-feature
    gcob bugfix/issue-123
    #>
    
    param(
        [Parameter(Mandatory=$true, Position=0)]
        [string]$BranchName,
        
        [Parameter(ValueFromRemainingArguments=$true)]
        [string[]]$Args
    )
    
    git checkout -b $BranchName $Args
}

function gpr {
    <#
    .SYNOPSIS
    Git pull with rebase
    
    .DESCRIPTION
    Equivalent to oh-my-zsh's gpr alias (git pull --rebase).
    Pulls changes from remote and rebases local commits on top.
    
    .EXAMPLE
    gpr
    gpr origin main
    #>
    
    param(
        [Parameter(ValueFromRemainingArguments=$true)]
        [string[]]$Args
    )
    
    git pull --rebase $Args
}

function gcmsg {
    <#
    .SYNOPSIS
    Git commit with message
    
    .DESCRIPTION
    Equivalent to oh-my-zsh's gcmsg alias (git commit -m).
    Creates a commit with the provided message.
    
    .PARAMETER Message
    The commit message
    
    .EXAMPLE
    gcmsg "Fix bug in login"
    gcmsg "Add new feature"
    #>
    
    param(
        [Parameter(Mandatory=$true, Position=0)]
        [string]$Message,
        
        [Parameter(ValueFromRemainingArguments=$true)]
        [string[]]$Args
    )
    
    git commit -m $Message $Args
}

function gcam {
    <#
    .SYNOPSIS
    Git commit all with message
    
    .DESCRIPTION
    Equivalent to oh-my-zsh's gcam alias (git commit -a -m).
    Stages all modified files and creates a commit with the provided message.
    
    .PARAMETER Message
    The commit message
    
    .EXAMPLE
    gcam "Update documentation"
    gcam "Fix typos"
    #>
    
    param(
        [Parameter(Mandatory=$true, Position=0)]
        [string]$Message,
        
        [Parameter(ValueFromRemainingArguments=$true)]
        [string[]]$Args
    )
    
    git commit -a -m $Message $Args
}

function gp {
    <#
    .SYNOPSIS
    Git push
    
    .DESCRIPTION
    Equivalent to oh-my-zsh's gp alias (git push).
    Pushes commits to the remote repository.
    
    .EXAMPLE
    gp
    gp origin main
    gp --force
    #>
    
    param(
        [Parameter(ValueFromRemainingArguments=$true)]
        [string[]]$Args
    )
    
    git push $Args
}
