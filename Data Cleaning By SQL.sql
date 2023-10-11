/*

Cleaning Data in SQL Quries

*/

select * from 
[portfolio project 1]..NashvilleHousing


--Populate Property Address Data

select * from 
[portfolio project 1]..NashvilleHousing
--where PropertyAddress is null
order by ParcelID


select a.ParcelID,a.PropertyAddress,b.ParcelID,b.PropertyAddress,isnull(a.PropertyAddress,b.PropertyAddress)
from[portfolio project 1].dbo.NashvilleHousing a
join [portfolio project 1].dbo.NashvilleHousing b
on a.ParcelID=b.ParcelID
and a.UniqueID<>b.UniqueID
where a.PropertyAddress is null

update a
set PropertyAddress=isnull(a.PropertyAddress,b.PropertyAddress)
from[portfolio project 1].dbo.NashvilleHousing a
join [portfolio project 1].dbo.NashvilleHousing b
on a.ParcelID=b.ParcelID
and a.UniqueID<>b.UniqueID
where a.PropertyAddress is null


--Breaking Out Address In Individual Column(Address,City,State)

select PropertyAddress
from[portfolio project 1]..NashvilleHousing

select 
SUBSTRING(PropertyAddress,1,CHARINDEX(',',PropertyAddress)-1) as Address,
SUBSTRING(PropertyAddress, CHARINDEX(',',PropertyAddress)+1, LEN(PropertyAddress)) as Address
from [portfolio project 1].dbo.NashvilleHousing

ALTER TABLE NashvilleHousing
ADD PropertySplitAddress NVARCHAR(255);

UPDATE NashvilleHousing
SET PropertySplitAddress=SUBSTRING(PropertyAddress, 1, CHARINDEX(',',PropertyAddress)-1)

ALTER TABLE NashvilleHousing
ADD PropertySplitCity NVARCHAR(255);

UPDATE NashvilleHousing
SET PropertySplitCity=SUBSTRING(PropertyAddress, CHARINDEX(',',PropertyAddress)+1, LEN(PropertyAddress))

select *
from[portfolio project 1]..NashvilleHousing



select OwnerAddress
from[portfolio project 1]..NashvilleHousing

select  
parsename(REPLACE(OwnerAddress,',','.'),3),
parsename(REPLACE(OwnerAddress,',','.'),2),
parsename(REPLACE(OwnerAddress,',','.'),1)
from[portfolio project 1]..NashvilleHousing

ALTER TABLE NashvilleHousing
ADD OwnerSplitAddress NVARCHAR(255);

UPDATE NashvilleHousing
SET OwnerSplitAddress=parsename(REPLACE(OwnerAddress,',','.'),3)


ALTER TABLE NashvilleHousing
ADD OwnerSplitCity NVARCHAR(255);

UPDATE NashvilleHousing
SET OwnerSplitCity=parsename(REPLACE(OwnerAddress,',','.'),2)


ALTER TABLE NashvilleHousing
ADD OwnerSplitState NVARCHAR(255);

UPDATE NashvilleHousing
SET OwnerSplitState=parsename(REPLACE(OwnerAddress,',','.'),1)

select *
from[portfolio project 1]..NashvilleHousing


--- Change Y and N to Yes and No in "Sold as Vacant" field

select distinct(SoldAsVacant),COUNT(SoldAsVacant)
from [portfolio project 1].dbo.NashvilleHousing
Group by SoldAsVacant
order by 2


select SoldAsVacant
,case when SoldAsVacant='y' then 'yes'
when SoldAsVacant='n' then 'no'
else SoldAsVacant
end
from [portfolio project 1].dbo.NashvilleHousing

UPDATE NashvilleHousing
SET SoldAsVacant=case when SoldAsVacant='y' then 'yes'
when SoldAsVacant='n' then 'no'
else SoldAsVacant
end



---Remove Duplicates--------

WITH RowNumCTE as(
select *,ROW_NUMBER() OVER(
    PARTITION BY ParcelID,
                PropertyAddress,
                SalePrice,
                SaleDate,
                LegalReference
                ORDER BY
                UniqueID
)row_num
from[portfolio project 1]..NashvilleHousing
--order by ParcelID
)
Select * from RowNumCTE
where row_num>1
order by PropertyAddress



select *
from[portfolio project 1]..NashvilleHousing

---Delete Unused Columns


ALTER TABLE [portfolio project 1]..NashvilleHousing
DROP COLUMN OwnerAddress,TaxDistrict,PropertyAddress

ALTER TABLE [portfolio project 1]..NashvilleHousing
DROP COLUMN SaleDate
