#script for making a copy of an Azure storage blob and changing tiers from archive to hot
#usage is either via command line arguments or prompted input
#command line must be in the following order and complete
#ResourceGroup StorageAccountName SourceContainerName DestinationContainterName SourceBlobName DestinationBlobName
#example: ./azureRehydrate.ps1 ProductionPhotos-USCentral stprodphotos3year 3yearphotos 3yearphotos IP/2021/Camera_3/5121070_20210810_121115_802043.jpg IP/2021/Camera_3/5121070_20210810_121115_802043_copy.jpg


#command line arguments
param (
    [string]$rgName,
    [string]$accountName,
    [string]$srcContainerName,
    [string]$destContainerName,
    [string]$srcBlobName,
    [string]$destBlobName
)

function userInput{
    #function for user input with or without defaults
    $rgName = Read-Host "`nEnter Resource Group [ProductionPhotos-USCentral]"
        if (-not($rgName)){
            $rgName = 'ProductionPhotos-USCentral'
        }
    $accountName = Read-Host "`nEnter Account Name [stprodphotos3year]"
        if (-not($accountName)){
            $accountName = 'stprodphotos3year'
        }
    $srcContainerName = Read-Host "`nEnter Source Container Name [3yearphotos]"
        if (-not($srcContainerName)){
            $srcContainerName = '3yearphotos'
        }
    $destContainerName = Read-Host "`nEnter Destination Container Name [3yearphotos]"
        if (-not($destContainerName)){
            $destContainerName = '3yearphotos'
        }
    $srcBlobName = Read-Host "`nEnter Source Blob Name [IP/2021/Camera_1/5121070_20210810_121114_802043.jpg]"
        if (-not($srcBlobName)){
            $srcBlobName = 'IP/2021/Camera_1/5121070_20210810_121114_802043.jpg'
        }
    $destBlobName = Read-Host "`nEnter Destination Blob Name [IP/2021/Camera_1/5121070_20210810_121114_802043_copy.jpg]"
        if (-not($destBlobName)){
            $destBlobName = 'IP/2021/Camera_1/5121070_20210810_121114_802043_copy.jpg'
        }
    blobCopy
}

function blobCopy{
    #Select the storage account and get the context
    $storageAccount =Get-AzStorageAccount -ResourceGroupName $rgName -Name $accountName
    $ctx = $storageAccount.Context

    #Copy source blob to a new destination blob with access tier hot using standard rehydrate priority
    Start-AzStorageBlobCopy -SrcContainer $srcContainerName -SrcBlob $srcBlobName -DestContainer $destContainerName -DestBlob $destBlobName -StandardBlobTier Hot -RehydratePriority Standard -Context $ctx
}

#if no command line arguments, call userInput else call blobCopy
if ($rgName.Length -eq 0){
    userInput
}elseif ($accountName.Length -eq 0){
    userInput
}elseif ($srcContainerName.Length -eq 0){
    userInput
}elseif ($destContainerName.Length -eq 0){
    userInput
}elseif ($srcBlobName.Length -eq 0){
    userInput
}elseif ($destBlobName.Length -eq 0){
    userInput
}else {
    blobCopy
}