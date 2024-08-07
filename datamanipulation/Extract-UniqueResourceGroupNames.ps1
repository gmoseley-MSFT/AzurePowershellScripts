# Extract-UniqueResourceGroupNames.ps1
# Executive Summary: This script extracts unique resource group names from URIs in a JSON file and saves them to a CSV file.

# Define the paths for the input and output files
$inputFilePath = "C:\temp\input.csv"
$outputFilePath = "C:\temp\resource_groups.csv"

# Initialize an array to store the resource group names
$resourceGroupList = @()

# Regular expression pattern to match the resource group names from the URIs
$pattern = '\/resourceGroups\/([^\/]+)\/'

# Read the input file line by line
Get-Content -Path $inputFilePath | ForEach-Object {
    $line = $_

    # Check if the line contains a resource group and extract it
    if ($line -match $pattern) {
        $resourceGroup = $matches[1]
        # Check if the resource group already exists in the array
        if ($resourceGroupList -notcontains $resourceGroup) {
            $resourceGroupList += $resourceGroup
        }
    }
}

# Convert the list of resource group names to a format suitable for CSV
$resourceGroupList | ForEach-Object { [PSCustomObject]@{ ResourceGroup = $_ } } | Export-Csv -Path $outputFilePath -NoTypeInformation
