
# Create a reusable class/module that can be used to check files for Authenticode signatures and contains the
# files that have issues with their signatures and/or timestamps


Class AuthenticodeValidator {
    [String] $rootDirectory
    [String[]] $searchFilter
    [String[]] $exclusionFilter
    [array] $filesWithSignatureIssues
    [array] $filesWithTimestampIssues
    [int] $fileCount

    TestFiles() {
        $files = Get-ChildItem -Path $this.rootDirectory -Include $this.searchFilter -Exclude $this.exclusionFilter -Recurse -Force
        $this.fileCount = $files.count
        ForEach ($file in $files) {
            $signature = Get-AuthenticodeSignature -FilePath $file
            If ($signature.SignatureType -ne "Authenticode") {
                $this.filesWithSignatureIssues += $file
            }
            If ($signature.TimestamperCertificate -eq "") {
                $this.filesWithTimestampIssues += $file
            }
        }
    }
}


Function Find-FilesWithAuthenticodeIssues() {
    param (
        $filePath,
        $searchFilter,
        $exclusionFilter
    )

    

}

Function Get-FilesWithSignatureIssues() {

}

Function Get-FilesWithTimestampIssues() {

}

$tester = [AuthenticodeValidator]::new()
$tester.rootDirectory = "C:\Program Files\JetBrains\"
$tester.searchFilter = '*.dll','*.exe'
$tester.TestFiles()
Write-Host "Files with signature issues:"
Write-Host $tester.filesWithSignatureIssues
Write-host "Files with timestamping issues:"
Write-Host $tester.filesWithTimestampIssues
Write-Host "File Count"
Write-Host $tester.fileCount