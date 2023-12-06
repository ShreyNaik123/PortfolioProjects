# PortfolioProjects

## Tableau Dashboard for Covid Data Dashboard 

![Dashboard 1](https://github.com/ShreyNaik123/PortfolioProjects/assets/61283238/0a73e706-3cce-4185-a213-f7e55a1e555e)


[Tableau Link](https://public.tableau.com/app/profile/shrey.naik/viz/CovidDataDashboard_17017037201400/Dashboard1?publish=yes)


# Nashville Housing Data Cleaning Project

## Overview

This data cleaning project focuses on the Nashville Housing Data dataset, leveraging SQL for efficient data transformations. The SQL operations performed in the project are highlighted below, each contributing to enhancing data quality and structure.

### 1. Filling Missing Property Addresses

- **SQL Operation:** `UPDATE`
- **Purpose:** Addressed missing values in the `PropertyAddress` column by filling them based on matching `ParcelID`.

### 2. Breaking Address into Address and City

- **SQL Operation:** `SUBSTRING`, `CHARINDEX`, `LEN`
- **Purpose:** Split the `PropertyAddress` into `Address` and `City` columns using commas as delimiters for improved data organization.

### 3. Creating New Columns for Split Address and City

- **SQL Operation:** `ALTER TABLE`, `ADD`, `UPDATE`
- **Purpose:** Introduced new columns (`PropertySplitCity` and `PropertySplitAddress`) to store the split components, enhancing data clarity.

### 4. Changing the Format of SaleDate

- **SQL Operation:** `CAST`, `ALTER TABLE`, `ADD`, `UPDATE`
- **Purpose:** Altered the format of `SaleDate` to `DATE` format for consistency and compatibility.

### 5. Splitting Owner Address into Separate Columns

- **SQL Operation:** `PARSENAME`, `REPLACE`, `ALTER TABLE`, `ADD`, `UPDATE`
- **Purpose:** Split `OwnerAddress` into separate columns (`OwnerSplitAddress`, `OwnerSplitCity`, `OwnerSplitState`) for better analysis and understanding.

### 6. Converting 'Y' and 'N' in SoldAsVacant

- **SQL Operation:** `UPDATE`, `CASE`
- **Purpose:** Standardized values in the `SoldAsVacant` column to 'Yes' and 'No' for uniformity.

### 7. Removing Duplicates

- **SQL Operation:** `WITH`, `ROW_NUMBER()`, `DELETE`
- **Purpose:** Eliminated duplicate rows based on specified columns to ensure data integrity.

### 8. Deleting Unwanted/Unused Columns

- **SQL Operation:** `ALTER TABLE`, `DROP COLUMN`
- **Purpose:** Removed columns (`OwnerAddress`, `TaxDistrict`, `PropertyAddress`, `SaleDate`) deemed unnecessary for the analysis.

## Conclusion

By strategically employing these SQL operations, the data cleaning project successfully enhanced the Nashville Housing Data dataset, addressing missing values, improving address structure, and ensuring data consistency. These transformations lay a foundation for more robust data analysis and interpretation. Future improvements may involve additional data validation and handling outliers.
