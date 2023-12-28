-- Cleaning data in SQL queries

Select*
From PortfolioProject..NashvilleHousing

-- Standardize sale date format

Select SaleDateConverted, CAST(saledate as date)
From PortfolioProject..NashvilleHousing

Update NashvilleHousing
SET saledate = CAST(saledate as date)  

ALTER TABLE NashvilleHousing
ADD SaleDateConverted Date;

Update NashvilleHousing
SET SaleDateConverted = CAST(saledate as date)

--------------------------------------------------------------------------------------------------------

-- Populate Property Address data


Select *
From PortfolioProject..NashvilleHousing
--Where PropertyAddress is null
Order by ParcelID

Select a.ParcelID, a.PropertyAddress, b.ParcelID, b.PropertyAddress, ISNULL(a.PropertyAddress, b.PropertyAddress)
From PortfolioProject..NashvilleHousing a
JOIN PortfolioProject..NashvilleHousing b
	ON a.ParcelID = b.ParcelID
	 AND a.[UniqueID ] <> b.[UniqueID ]
Where a.PropertyAddress is null

UPDATE a
SET PropertyAddress = ISNULL(a.PropertyAddress, b.PropertyAddress)
From PortfolioProject..NashvilleHousing a
JOIN PortfolioProject..NashvilleHousing b
	ON a.ParcelID = b.ParcelID
	 AND a.[UniqueID] <> b.[UniqueID]
Where a.PropertyAddress is null

-----------------------------------------------------------------------------------------------------------

-- Breaking out Address into individual Columns (Address, City, State)

Select PropertyAddress
From PortfolioProject..NashvilleHousing

Select 
SUBSTRING(PropertyAddress, 1, CHARINDEX(',', PropertyAddress) -1) as Address
, SUBSTRING(PropertyAddress, CHARINDEX(',', PropertyAddress) +1,  LEN(PropertyAddress)) as Address

From PortfolioProject..NashvilleHousing  


ALTER TABLE NashvilleHousing
ADD PropertySplitAddress Nvarchar(255);

Update NashvilleHousing
SET PropertySplitAddress = SUBSTRING(PropertyAddress, 1, CHARINDEX(',', PropertyAddress) -1)


ALTER TABLE NashvilleHousing
ADD PropertySplitCity Nvarchar(255);

Update NashvilleHousing
SET PropertySplitCity = SUBSTRING(PropertyAddress, CHARINDEX(',', PropertyAddress) +1,  LEN(PropertyAddress))



Select*
From PortfolioProject..NashvilleHousing 


Select OwnerAddress
From PortfolioProject..NashvilleHousing

Select
PARSENAME(Replace(OwnerAddress, ',', '.'), 3),
PARSENAME(Replace(OwnerAddress, ',', '.'), 2),
PARSENAME(Replace(OwnerAddress, ',', '.'), 1)
From PortfolioProject..NashvilleHousing 



ALTER TABLE NashvilleHousing
ADD OwnerSplitAddress Nvarchar(255);

Update NashvilleHousing
SET OwnerSplitAddress = PARSENAME(Replace(OwnerAddress, ',', '.'), 3)


ALTER TABLE NashvilleHousing
ADD OwnerSplitCity Nvarchar(255);

Update NashvilleHousing
SET OwnerSplitCity = PARSENAME(Replace(OwnerAddress, ',', '.'), 2)

ALTER TABLE NashvilleHousing
ADD PropertySplitState Nvarchar(255);

Update NashvilleHousing
SET PropertySplitState = PARSENAME(Replace(OwnerAddress, ',', '.'), 1) 

----------------------------------------------------------------------------------------------------

-- Change Y and N to Yes and No in "Sold as Vacant" field
 
 Select Distinct(SoldAsVacant), Count(SoldAsVacant) as CountOfSoldAsVacant
 From PortfolioProject..NashvilleHousing
 Group by SoldAsVacant
 Order by 2


Select SoldAsVacant,
Case When SoldAsVacant = 'Y' Then 'Yes'
	 When SoldAsVacant = 'N' Then 'No'
	 Else SoldAsVacant
	 End
From PortfolioProject..NashvilleHousing

Update NashvilleHousing
Set SoldAsVacant = Case When SoldAsVacant = 'Y' Then 'Yes'
	 When SoldAsVacant = 'N' Then 'No'
	 Else SoldAsVacant
	 End
 
 -----------------------------------------------------------------------------------------------------------------------------------------------------------

-- Remove Duplicates

WITH RowNumCTE AS (
Select *,
	ROW_NUMBER() Over (
	Partition by ParcelID, 
				 PropertyAddress,
				 SalePrice,
				 SaleDate,
				 LegalReference
				 Order by 
					UniqueID
					) as row_num
From PortfolioProject..NashvilleHousing

)
Select*
From RowNumCTE
Where Row_Num > 1


----------------------------------------------------------------------------------------------------------------------------------

-- Delete Unused Columns

Select*
From PortfolioProject..NashvilleHousing

ALTER TABLE  PortfolioProject..NashvilleHousing
DROP COLUMN OwnerAddress, TaxDistrict, PropertyAddress

ALTER TABLE  PortfolioProject..NashvilleHousing
DROP COLUMN SaleDate