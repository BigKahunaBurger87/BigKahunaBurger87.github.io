param (
    [Parameter(Mandatory=$true)]
    [string]$MachineName
)

$ErrorActionPreference = "Stop"

# Configuration
$ObsidianPath = "C:\Users\cbooz\Desktop\Obsidian_Notes\OSCP\02_HTB\02_Boxes"
$ImagesPath = "C:\Users\cbooz\Desktop\Obsidian_Notes\OSCP\999_Pasted Images\Pasted Images"
$RepoPath = "E:\BigKahunaBurger87.github.io"
$PostsPath = "$RepoPath\content\posts"
$StaticImagesPath = "$RepoPath\static\images"

# 1. Find the markdown file
Write-Host "Searching for note matching '$MachineName'..." -ForegroundColor Cyan
$PossibleFiles = Get-ChildItem -Path $ObsidianPath -Filter "$MachineName*.md"
$NoteFile = $null

if (-not $PossibleFiles) {
    Write-Error "No note found matching '$MachineName' in $ObsidianPath"
} elseif ($PossibleFiles.Count -gt 1) {
    Write-Warning "Found multiple matching notes. Using the first one:"
    $PossibleFiles | ForEach-Object { Write-Host "  - $($_.Name)" }
    $NoteFile = $PossibleFiles[0]
} else {
    $NoteFile = $PossibleFiles[0]
}

Write-Host "Found note: $($NoteFile.Name)" -ForegroundColor Green

# 2. Prepare destination paths
$Slug = "htb-" + $MachineName.ToLower()
$DestFile = Join-Path $PostsPath "$Slug.md"
$DestImgDir = Join-Path $StaticImagesPath $Slug

if (-not (Test-Path $DestImgDir)) {
    New-Item -ItemType Directory -Path $DestImgDir -Force | Out-Null
}

# 3. Read content
$Content = Get-Content -Path $NoteFile.FullName -Raw

# 4. Process Images
Write-Host "Processing images..." -ForegroundColor Cyan
# Pattern to match ![[image.png]] or ![[image.png|alias]]
$ImagePattern = '!\[\[(.*?)(?:\|.*?)?\]\]'
$Matches = [regex]::Matches($Content, $ImagePattern)

foreach ($Match in $Matches) {
    $RawLink = $Match.Value
    $ImageName = $Match.Groups[1].Value.Trim()
    
    # Check if image exists in source
    # Try looking in the specific pasted images folder first
    $SourceImg = Join-Path $ImagesPath $ImageName
    
    if (-not (Test-Path $SourceImg)) {
        # Fallback: search recursively in vault if not found in default folder
        $Found = Get-ChildItem -Path "C:\Users\cbooz\Desktop\Obsidian_Notes" -Recurse -Filter $ImageName -ErrorAction SilentlyContinue | Select-Object -First 1
        if ($Found) {
            $SourceImg = $Found.FullName
        }
    }

    if (Test-Path $SourceImg) {
        # Copy image
        Copy-Item -Path $SourceImg -Destination $DestImgDir -Force
        
        # Replace link in content
        # From: ![[image.png]]
        # To:   ![image](/images/htb-machine/image.png)
        # Note: Hugo static folder 'static/images' maps to '/images' in URL
        $WebPath = "/images/$Slug/$ImageName"
        $NewLink = "![$ImageName]($WebPath)"
        
        $Content = $Content.Replace($RawLink, $NewLink)
        
        Write-Host "  Copied and linked: $ImageName" -ForegroundColor Gray
    } else {
        Write-Warning "  Image not found: $ImageName"
    }
}

# 5. Add/Fix Frontmatter
Write-Host "Updating frontmatter..." -ForegroundColor Cyan
if ($Content -notmatch "^---") {
    $DateStr = (Get-Date).ToString("yyyy-MM-ddTHH:mm:sszzz")
    $Frontmatter = @"
---
title: "HackTheBox - $MachineName"
date: $DateStr
draft: false
tags: ["htb", "walkthrough", "$($MachineName.ToLower())"]
categories: ["HackTheBox"]
author: "BigKahunaBurger87"
---

"@
    $Content = $Frontmatter + $Content
}

# 6. Save to Hugo content
$Content | Set-Content -Path $DestFile -Encoding UTF8
Write-Host "Saved post to $DestFile" -ForegroundColor Green

# 7. Git Operations
Write-Host "Pushing to GitHub..." -ForegroundColor Cyan
Set-Location $RepoPath
$git = "C:\Program Files\Git\cmd\git.exe"
& $git add .
& $git commit -m "feat: Add walkthrough for $MachineName"
& $git push

Write-Host "Done! Check https://BigKahunaBurger87.github.io/posts/$Slug/" -ForegroundColor Green
