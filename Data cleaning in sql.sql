

Select *
From PortfolioProject.dbo.PortfolioProject.dbo.Nashville

--------------------------------------------------------------------------------------------------------------------------

-- Standardize Date Format


Select saleDateConverted, CONVERT(Date,SaleDate)
From PortfolioProject.dbo.PortfolioProject.dbo.Nashville


Update PortfolioProject.dbo.Nashville
SET SaleDate = CONVERT(Date,SaleDate)

-- If it doesn't Update properly

ALTER TABLE PortfolioProject.dbo.Nashville
Add SaleDateConverted Date;

Update PortfolioProject.dbo.Nashville
SET SaleDateConverted = CONVERT(Date,SaleDate)


 --------------------------------------------------------------------------------------------------------------------------

-- Populate Property Address data

Select *
From PortfolioProject.Nashville
--Where PropertyAddress is null
order by ParcelID



Select a.ParcelID, a.PropertyAddress, b.ParcelID, b.PropertyAddress, ISNULL(a.PropertyAddress,b.PropertyAddress)
From PortfolioProject.dbo.PortfolioProject.dbo.Nashville a
JOIN PortfolioProject.dbo.PortfolioProject.dbo.Nashville b
	on a.ParcelID = b.ParcelID
	AND a.[UniqueID ] <> b.[UniqueID ]
Where a.PropertyAddress is null


Update a
SET PropertyAddress = ISNULL(a.PropertyAddress,b.PropertyAddress)
From PortfolioProject.dbo.PortfolioProject.dbo.Nashville a
JOIN PortfolioProject.dbo.PortfolioProject.dbo.Nashville b
	on a.ParcelID = b.ParcelID
	AND a.[UniqueID ] <> b.[UniqueID ]
Where a.PropertyAddress is null




----------------------------------------------------------------------------------------------------------------------

-- Breaking out Address into Individual Columns (Address, City, State)


Select PropertyAddress
From PortfolioProject.Nashville
--Where PropertyAddress is null
--order by ParcelID
select
SUBSTRING(PropertyAddress,1,charindex(',',PropertyAddress)-1)as Address,
SUBSTRING(PropertyAddress,charindex(',',PropertyAddress)+1 ,Len(PropertyAddress)) as Address
from portfolioProject.dbo.PortfolioProject.dbo.Nashville



ALTER TABLE PortfolioProject.dbo.Nashville
Add PropertySplitAddress Nvarchar(255);

Update PortfolioProject.dbo.Nashville
SET PropertySplitAddress = SUBSTRING(PropertyAddress, 1, CHARINDEX(',', PropertyAddress) -1 )


ALTER TABLE PortfolioProject.dbo.Nashville
Add PropertySplitCity Nvarchar(255);

Update PortfolioProject.dbo.Nashville
SET PropertySplitCity = SUBSTRING(PropertyAddress, CHARINDEX(',', PropertyAddress) + 1 , LEN(PropertyAddress))




Select *
From PortfolioProject.dbo.PortfolioProject.dbo.Nashville





Select OwnerAddress
From PortfolioProject.dbo.PortfolioProject.dbo.Nashville


Select
PARSENAME(REPLACE(OwnerAddress, ',', '.') , 3)
,PARSENAME(REPLACE(OwnerAddress, ',', '.') , 2)
,PARSENAME(REPLACE(OwnerAddress, ',', '.') , 1)
From PortfolioProject.dbo.PortfolioProject.dbo.Nashville



ALTER TABLE PortfolioProject.dbo.Nashville
Add OwnerSplitAddress Nvarchar(255);

Update PortfolioProject.dbo.Nashville
SET OwnerSplitAddress = PARSENAME(REPLACE(OwnerAddress, ',', '.') , 3)


ALTER TABLE PortfolioProject.dbo.Nashville
Add OwnerSplitCity Nvarchar(255);

Update PortfolioProject.dbo.Nashville
SET OwnerSplitCity = PARSENAME(REPLACE(OwnerAddress, ',', '.') , 2)



ALTER TABLE PortfolioProject.dbo.Nashville
Add OwnerSplitState Nvarchar(255);

Update PortfolioProject.dbo.Nashville
SET OwnerSplitState = PARSENAME(REPLACE(OwnerAddress, ',', '.') , 1)



Select *
From PortfolioProject.Nashville




--------------------------------------------------------------------------------------------------------------------------


-- Change Y and N to Yes and No in "Sold as Vacant" field


Select Distinct(SoldAsVacant), Count(SoldAsVacant)
From PortfolioProject.dbo.Nashville
Group by SoldAsVacant
order by 2




Select SoldAsVacant
, CASE When SoldAsVacant = 'Y' THEN 'Yes'
	   When SoldAsVacant = 'N' THEN 'No'
	   ELSE SoldAsVacant
	   END
From PortfolioProject.dbo.Nashville


Update PortfolioProject.dbo.Nashville
SET SoldAsVacant = CASE When SoldAsVacant = 'Y' THEN 'Yes'
	   When SoldAsVacant = 'N' THEN 'No'
	   ELSE SoldAsVacant
	   END






-----------------------------------------------------------------------------------------------------------------------------------------------------------

-- Remove Duplicates

WITH RowNumCTE AS(
Select *,
	ROW_NUMBER() OVER (
	PARTITION BY ParcelID,
				 PropertyAddress,
				 SalePrice,
				 SaleDate,
				 LegalReference
				 ORDER BY
					UniqueID
					) row_num

From PortfolioProject.dbo.Nashville
--order by ParcelID
)
Select *
From RowNumCTE
Where row_num > 1
Order by PropertyAddress



Select *
From PortfolioProject.dbo.Nashville




---------------------------------------------------------------------------------------------------------

-- Delete Unused Columns



Select *
From PortfolioProject.dbo.Nashville


ALTER TABLE PortfolioProject.dbo.Nashville
DROP COLUMN OwnerAddress, TaxDistrict, PropertyAddress, SaleDate









-----------------------------------------------------------------------------------------------

















