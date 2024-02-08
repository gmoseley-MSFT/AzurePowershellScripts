# Get all subscriptions
$subscriptions = Get-AzSubscription

# Loop through each subscription
foreach ($sub in $subscriptions) {
    # Select the subscription
    Select-AzSubscription -SubscriptionId $sub.Id

    # Get public IP addresses in the current subscription
    $list = Get-AzPublicIpAddress

    # If there are IP addresses, export their details to CSV
    if ($list) {
        $exportData = $list | ForEach-Object {
            [PSCustomObject]@{
                SubscriptionId = $sub.Id
                SubscriptionName = $sub.Name
                URI = $_.Id
                IpAddress = $_.IpAddress
                Sku       = $_.Sku.Name
            }
        }

        # Define the CSV file name based on the subscription name
        $csvFileName = "C:\temp\PublicIPDetails_" + $sub.Name.Replace(" ", "") + ".csv"

        # Export the data to a CSV file
        $exportData | Export-Csv -Path $csvFileName -NoTypeInformation
    }
}
