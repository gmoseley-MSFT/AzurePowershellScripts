# Resolve-FQDNLoop.ps1
# Executive Summary: This script resolves a specified FQDN using a list of DNS servers repeatedly and logs the results, including errors, to a CSV file in the C:\temp directory.

# Check if the C:\temp directory exists
if (-not (Test-Path "C:\temp")) {
    # Create the C:\temp directory
    New-Item -Path "C:\temp" -ItemType Directory
}

# Prompt the user for an FQDN
$fqdn = "INSERTFQDN"

# Define the list of public DNS resolvers to use
$dnsServers = @("1.1.1.1")

# Create an empty array to store the results
$results = @()

# Loop through each DNS server and resolve the FQDN
for ($i = 1; $i -le 1000; $i++) {
    foreach($dnsServer in $dnsServers) {
        try {
            # Resolve the FQDN using the current DNS server
            $ipAddresses = [System.Net.Dns]::GetHostAddresses($fqdn)

            # Loop through each IP address in the result
            foreach($ipAddress in $ipAddresses) {
                # Create a new object to store the result for this IP address
                $result = [PSCustomObject]@{
                    Answer = $ipAddress
                    DnsServerIp = $dnsServer
                    Timestamp = (Get-Date).ToUniversalTime()
                }

                # Add the result to the array
                $results += $result
            }
            #Sleep(1) #Uncomment this sleep if you'd like to slow it down a bit
        }
        catch {
            # Create a new object to store the error result
            $result = [PSCustomObject]@{
                Answer = "Error: $_"
                DnsServerIp = $dnsServer
                Timestamp = (Get-Date).ToUniversalTime()
            }

            # Add the result to the array
            $results += $result
        }
    }
}

# Output the results to a CSV file
$results | Export-Csv -Path C:\temp\results.csv -NoTypeInformation

# Open the C:\temp directory in File Explorer
Invoke-Item "C:\temp"
