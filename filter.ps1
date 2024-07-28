# Prompt the user for the input CSV file path
$inputCsvFilePath = Read-Host "Please enter the path to your input CSV file"

# Define the path for the output CSV file based on the input path
$outputCsvFilePath = "${inputCsvFilePath}out.csv"

# Prompt the user for confirmation to proceed
$userInput = Read-Host "Do you want to proceed with processing the CSV file? (Y/N)"

if ($userInput -eq "Y" -or $userInput -eq "y") {
    Write-Output "You chose to proceed. Processing the CSV file..."

    # Check if the file exists
    if (Test-Path -Path $inputCsvFilePath) {
        # Read the input CSV file
        $contacts = Import-Csv -Path $inputCsvFilePath
        
        # Check if the CSV file has been read and contains data
        if ($contacts) {
            # Create an array to store the filtered contact details
            $filteredContacts = @()

            # Loop through each contact in the CSV file and extract the necessary information
            foreach ($contact in $contacts) {
                $filteredContact = [PSCustomObject]@{
                    Email       = $contact.Email
                    FirstName   = $contact.'First Name'
                    LastName    = $contact.'Last Name'
                    City        = $contact.City
                    PhoneNumber = $contact.'Phone Number'
                }
                $filteredContacts += $filteredContact
            }

            # Export the filtered contact details to a new CSV file
            $filteredContacts | Export-Csv -Path $outputCsvFilePath -NoTypeInformation

            Write-Output "Filtered contacts have been successfully exported to $outputCsvFilePath"

            # Prompt the user if they want to see the output file
            $batit = Read-Host "Do you wish to see the output CSV file? (Y/N)"

            if ($batit -eq "Y" -or $batit -eq "y") {
                # Open the CSV file in default application
                Invoke-Item -Path $outputCsvFilePath
            }

        } else {
            Write-Output "The input CSV file is empty or could not be read. Exiting the script..."
        }
    } else {
        Write-Output "The specified input CSV file does not exist. Exiting the script..."
    }
} else {
    Write-Output "You chose not to proceed. Exiting the script..."
    exit
}