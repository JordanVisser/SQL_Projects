SELECT *
FROM Nashville_Housing.nashville_housing1;

SELECT *
FROM Nashville_Housing.nashville_housing1
ORDER BY ParcelID;

-- Cleaning Null Data for Property Address
SELECT *
FROM Nashville_Housing.nashville_housing1 a
JOIN Nashville_Housing.nashville_housing1 b
	ON a.ParcelID = b.ParcelID
    AND a.UniqueID <> b.UniqueID
WHERE a.PropertyAddress is null;


SELECT 
    a.ParcelID,
    a.PropertyAddress AS NullPropertyAddress,
    b.PropertyAddress AS MatchingPropertyAddress
FROM 
    Nashville_Housing.nashville_housing1 a
JOIN 
    Nashville_Housing.nashville_housing1 b
ON 
    a.ParcelID = b.ParcelID
WHERE 
    a.PropertyAddress IS NULL
    AND a.UniqueID <> b.UniqueID;


UPDATE Nashville_Housing.nashville_housing1 a
JOIN Nashville_Housing.nashville_housing1 b
    ON a.ParcelID = b.ParcelID
SET a.PropertyAddress = b.PropertyAddress
WHERE a.PropertyAddress IS NULL
    AND a.UniqueID <> b.UniqueID;
    
-- Cleaning Property Address
SELECT PropertyAddress
FROM Nashville_Housing.nashville_housing1;

SELECT 
    TRIM(SUBSTRING_INDEX(PropertyAddress, ',', 1)) AS StreetAddress,
    TRIM(SUBSTRING_INDEX(PropertyAddress, ',', -1)) AS City
FROM 
    Nashville_Housing.nashville_housing1;
    
ALTER TABLE Nashville_Housing.nashville_housing1
Add StreetAddress NVARCHAR(255);

UPDATE Nashville_Housing.nashville_housing1
SET StreetAddress = TRIM(SUBSTRING_INDEX(PropertyAddress, ',', 1));

ALTER TABLE Nashville_Housing.nashville_housing1
Add City NVARCHAR(255);

UPDATE Nashville_Housing.nashville_housing1
SET City = TRIM(SUBSTRING_INDEX(PropertyAddress, ',', -1));

-- Owner Address Cleaning
SELECT OwnerAddress
FROM Nashville_Housing.nashville_housing1;

SELECT 
    TRIM(SUBSTRING_INDEX(OwnerAddress, ',', 1)) AS Owner_StreetAddress,
    TRIM(SUBSTRING_INDEX(SUBSTRING_INDEX(OwnerAddress, ',', 2), ',', -1)) AS Owner_City,
    TRIM(SUBSTRING_INDEX(OwnerAddress, ',', -1)) AS Owner_State
FROM 
    Nashville_Housing.nashville_housing1;
    
ALTER TABLE Nashville_Housing.nashville_housing1
Add Owner_StreetAddress NVARCHAR(255);
UPDATE Nashville_Housing.nashville_housing1
SET Owner_StreetAddress = TRIM(SUBSTRING_INDEX(OwnerAddress, ',', 1));

ALTER TABLE Nashville_Housing.nashville_housing1
Add Owner_City NVARCHAR(255);
UPDATE Nashville_Housing.nashville_housing1
SET Owner_City = TRIM(SUBSTRING_INDEX(SUBSTRING_INDEX(OwnerAddress, ',', 2), ',', -1));

ALTER TABLE Nashville_Housing.nashville_housing1
Add Owner_State NVARCHAR(255);
UPDATE Nashville_Housing.nashville_housing1
SET Owner_State = TRIM(SUBSTRING_INDEX(OwnerAddress, ',', -1));

-- Cleaning Sold As Vacant

SELECT DISTINCT(SoldAsVacant), COUNT(SoldAsVacant)
FROM Nashville_Housing.nashville_housing1
GROUP BY SoldAsVacant
ORDER BY 2;

SELECT SoldAsVacant
, CASE WHEN SoldAsVacant = 'Y' THEN 'Yes'
WHEN SoldAsVacant = 'N' THEN 'No'
ELSE SoldAsVacant
END
FROM Nashville_Housing.nashville_housing1;

UPDATE Nashville_Housing.nashville_housing1
SET SoldAsVacant = CASE WHEN SoldAsVacant = 'Y' THEN 'Yes'
WHEN SoldAsVacant = 'N' THEN 'No'
ELSE SoldAsVacant
END;

-- Deleting Unused Columns
SELECT *
FROM Nashville_Housing.nashville_housing1;

ALTER TABLE Nashville_Housing.nashville_housing1
DROP COLUMN OwnerAddress,
DROP COLUMN TaxDistrict,
DROP COLUMN PropertyAddress;











    

