select *
from NashvilleHousing


--- Fill the PropertyAddress based on the ParcelID since it looks like 
--- one parcelID correspods to one Address

select a.ParcelID, a.PropertyAddress, b.ParcelID, b.PropertyAddress, isnull(a.PropertyAddress, b.PropertyAddress)
from NashvilleHousing a
join NashvilleHousing b
on a.ParcelID = b.ParcelID and a.UniqueID <> b.UniqueID
where a.PropertyAddress is null

update a
set PropertyAddress = isnull(a.PropertyAddress, b.PropertyAddress)
from PortfolioProject..NashvilleHousing a
join PortfolioProject..NashvilleHousing b
on a.ParcelID = b.ParcelID and a.UniqueID <> b.UniqueID
where a.PropertyAddress is null


--- Breaking Address into Address and City
--- Using comma as a delimiter 

select 
substring(PropertyAddress, 1, charindex(',', PropertyAddress) - 1) as Address,
substring(PropertyAddress, charindex(',', PropertyAddress) + 1, len(PropertyAddress)) as City
from PortfolioProject..NashvilleHousing



--- Create new Columns for the Split Address and City

alter table NashvilleHousing
add PropertySplitCity nvarchar(255),
	PropertySplitAddress nvarchar(255)

update NashvilleHousing
set PropertySplitAddress  = substring(PropertyAddress, 1, charindex(',', PropertyAddress) - 1),
	PropertySplitCity = substring(PropertyAddress, charindex(',', PropertyAddress) + 1, len(PropertyAddress)) 



--- Change the format of SaleDate

select SaleDate, cast(SaleDate as date)
from NashvilleHousing


alter table NashvilleHousing
add SaleDateConverted Date

update NashvilleHousing
set SaleDateConverted = cast(Saledate as date)

 --- Doing the same thing done for PropertyAddress to Owner Address
 --- There are 3 parts in the Owner Address

 --- replace -> like split in python but delimiter is period by default and cannot be changed
 select
 parsename(replace(OwnerAddress, ',', '.'),3) as Address,
 parsename(replace(OwnerAddress, ',', '.'),2) as City,
 parsename(replace(OwnerAddress, ',', '.'),1) as State
 from NashvilleHousing

 --- Create Seperate Columns for these

 alter table NashvilleHousing
 add OwnerSplitAddress nvarchar(255),
	OwnerSplitCity nvarchar(255),
	OwnerSplitState nvarchar(255)

update NashvilleHousing
set OwnerSplitAddress =  parsename(replace(OwnerAddress, ',', '.'),3),
	OwnerSplitCity = parsename(replace(OwnerAddress, ',', '.'),2),
	OwnerSplitState =  parsename(replace(OwnerAddress, ',', '.'),1)
	


--- SoldAsVacant has Yes,No,Y,N
--- Converting Y -> Yes and N -> No 
--- Since Yes and No are have more instances

select distinct SoldAsVacant
from NashvilleHousing

select SoldAsVacant, count(SoldAsVacant)
from NashvilleHousing
group by SoldAsVacant
order by 2 desc

select
SoldAsVacant,
case 
when SoldAsVacant = 'Y' then 'Yes' 
when SoldAsVacant = 'N' then 'No'
else SoldAsVacant
end as NewName
from NashvilleHousing
where SoldAsVacant in ('Y','N')

--- Update the Table

update NashvilleHousing
set SoldAsVacant =case 
	when SoldAsVacant = 'Y' then 'Yes' 
	when SoldAsVacant = 'N' then 'No'
	else SoldAsVacant
	end 


--- Removing duplicates

with temptable as (
	select *,
	row_number() over (
		partition by ParcelID,	
					PropertyAddress,
					SalePrice,
					SaleDate, 
					LegalReference
					order by
						UniqueID) as dupe_nums
	from NashvilleHousing
)

delete from temptable
where dupe_nums > 1


--- Delete Unwanted/Unused Columns

select * from NashvilleHousing

alter table NashvilleHousing
drop column OwnerAddress,TaxDistrict, PropertyAddress,SaleDate

