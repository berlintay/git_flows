# Prompt the user for the input CSV file path
$userSpecifiedInputFilePath = Read-Host "Please enter the path to your input CSV file:"

# Define the path for the output CSV file based on the input path
$defaultOutputFilePath = "${userSpecifiedInputFilePath}out.csv"

# Confirmation prompt for processing
$userConfirmation = Read-Host "Do you want to proceed with processing the CSV file? (Y/N)"

if ($userConfirmation -eq "Y" -or $userConfirmation -eq "y") {
  Write-Output "You chose to proceed. Processing the CSV file..."

  # Check if the input CSV file exists and has data in one step
  if (Test-Path -Path $userSpecifiedInputFilePath -and (Import-Csv -Path $userSpecifiedInputFilePath).Count -gt 0) {
    $contacts = Import-Csv -Path $userSpecifiedInputFilePath

    $filteredContacts = @()

    # Process the CSV data with standardized names
    foreach ($contact in $contacts) {
      $filteredContact = [PSCustomObject]@{
        FirstName = $contact.'Name: First'
        LastName = $contact.'Name: Last'
        AddressLine1 = $contact.'Address: Address Line 1'
        AddressLine2 = $contact.'Address: Address Line 2'
        City = $contact.'Address: City'
        State = $contact.'Address: State'
        ZipCode = $contact.'Address: Zip/Postal Code'
        Country = $contact.'Address: Country'
        Phone = $contact.Phone
        Email = $contact.Email
      }
      $filteredContacts += $filteredContact
    }

    # Export filtered contacts and handle output file name (optional)
    $filteredContacts | Export-Csv -Path $defaultOutputFilePath -NoTypeInformation
    Write-Output "Filtered contacts have been successfully exported to $defaultOutputFilePath"

    $useDefaultOutputName = Read-Host "Use default output file name (out.csv)? (Y/N)"
    if ($useDefaultOutputName -ne "Y" -and $useDefaultOutputName -ne "y") {
      $outputCsvFilePath = Read-Host "Enter desired output file name (with .csv extension):"
    } else {
      $outputCsvFilePath = $defaultOutputFilePath
    }

    # Prompt to open the output file
    if (Read-Host "Do you want to open the output CSV file? (Y/N)" -eq "Y" -or "y") {
      Invoke-Item -Path $outputCsvFilePath
    }

  } else {
    Write-Output "The input CSV file either doesn't exist or is empty. Exiting..."
  }
} else {
  Write-Output "You chose not to proceed. Exiting the script..."
  exit
}
