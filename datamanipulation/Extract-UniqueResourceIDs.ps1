# Extract-UniqueResourceIDs.ps1
# Executive Summary: This script extracts unique resource IDs from a JSON file and saves them to a CSV file.

# Define the paths for the input and output files
$inputFilePath = "C:\temp\input.json"
$outputFilePath = "C:\temp\output.csv"

# Initialize an array to store the IDs
$idList = @()

# Regular expression pattern to match the desired ID format
$pattern = '"id":\s*"([^"]*\/subscriptions\/[^"]+\/resourceGroups\/[^"]+\/providers\/Microsoft\.Network\/publicIPAddresses\/[^"]+)"'

# Read the input file line by line
Get-Content -Path $inputFilePath | ForEach-Object {
    $line = $_

    # Check if the line contains an ID and extract it
    if ($line -match $pattern) {
        $id = $matches[1]
        # Check if the ID already exists in the array
        if ($idList -notcontains $id) {
            $idList += $id
        }
    }
}

# Convert the list of IDs to a format suitable for CSV
$idList | ForEach-Object { [PSCustomObject]@{ ID = $_ } } | Export-Csv -Path $outputFilePath -NoTypeInformation
