# Extract-UniqueIPCIDRs.ps1
# Executive Summary: This script extracts unique IP CIDRs from a JSON file and saves them to a CSV file.

# Define the paths for the input and output files
$inputFilePath = "C:\temp\input.json"
$outputFilePath = "C:\temp\output.csv"

# Initialize an array to store the CIDRs
$cidrList = @()

# Regular expression pattern to match IP CIDRs
$pattern = '\b\d{1,3}\.\d{1,3}\.\d{1,3}\.\d{1,3}/\d{1,2}\b'

# Read the input file line by line
Get-Content -Path $inputFilePath | ForEach-Object {
    $line = $_

    # Check if the line contains a CIDR and extract it
    if ($line -match $pattern) {
        $cidr = $matches[0]
        # Check if the CIDR already exists in the array
        if ($cidrList -notcontains $cidr) {
            $cidrList += $cidr
        }
    }
}

# Convert the list of CIDRs to a format suitable for CSV
$cidrList | ForEach-Object { [PSCustomObject]@{ CIDR = $_ } } | Export-Csv -Path $outputFilePath -NoTypeInformation
