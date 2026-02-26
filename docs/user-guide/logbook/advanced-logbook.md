# Advanced Logbook

!!! warning
    The result dropdown is set to a max of 5000 QSOs listed. This is because of performance issues when adding that many lines to the table. If this number was to be increased, the browser would either be very slow, or most likely freeze.

# Things you can do in the Advanced Logbook

* Filter QSOs
* Find duplicate QSOs
* Find "invalid" QSOs
  * Checks for missing mode/band/callsign
  * Checks for an invalid date (01011970)
  * Checks if invalid continent is set
* Export QSOs to ADIF
* Print labels
* Batch edit QSOs
* Delete QSOs
* Show a map of filtered QSOs
* Update QSOs from a callbook (QRZ, HamQTH, QRZCQ, QRZ.ru)
* See a QSL slideshow with selected QSOs that contain an uploaded image of a QSL card
* Fix state where at least a 6 char gridsquare is set (only available for a limited set of DXCC's)

## Database Tools (DBTools)

(from version 2.2.2 - not yet released)
!!! warning
    These tools work on ALL QSOs for the user. It does NOT work on just the selected QSOS, and it is NOT per location basis.

The Database Tools module in Wavelog provides a comprehensive suite of utilities for maintaining data integrity and repairing common issues in your logbook data. These tools are accessible through the Advanced Logbook interface and are designed to help operators keep their QSO records accurate and complete.

## Overview

DBTools offers checking and fixing functionality for various types of QSO metadata that may be missing, incorrect, or outdated.

## Available Tools

### 1. Check all QSOs in the logbook for incorrect CQ Zones

* **Purpose**: Checks all QSOs in the logbook to see if they have a CQ Zone that does not exists for the set DXCC
* **Updates**: The default CQ Zone is used for the DXCC set, and will be set for the selected QSOs
* **Downside**: DXCCs with multiple CQ Zones can't be set accurate.

### 2. Check all QSOs in the logbook for incorrect ITU Zones

* **Purpose**: Checks all QSOs in the logbook to see if they have an ITU Zone that does not exists for the set DXCC
* **Updates**: The default ITU Zone is used for the DXCC set, and will be set for the selected QSOs
* **Downside**: DXCCs with multiple ITU Zones can't be set accurate.

### 3. Check Gridsquares

* **Purpose**: Checks all QSOs in the logbook to see if they have a gridsquare that does not exists for the set DXCC
* **Downside**: The gridsquare list comes from TQSL, and this list is not 100% accurate.

### 4. Fix continent

* **Purpose**: Updates missing or incorrect continent information  
* **Updates**: Sets continent based on set DXCC
* **Function**: Determines continent based on DXCC entity  

### 5. Fix state

* **Purpose**: Updates missing state or province information  
* **Function**: Uses 6 char (or greater) grid square and location data to determine administrative divisions  
* **Downside**: Not available for all DXCCs.

### 6. Update distances

* **Purpose**: Calculates and updates distance information for QSOs  
* **Function**: Computes great-circle distances between stations based on gridsquare set in station location and on QSO.

### 7. Check all QSOs in the logbook for incorrect DXCC

* **Purpose**: Re-evaluates all QSOs for correct DXCC assignment  
* **Updates**: Overwrites existing DXCC data using current Wavelog database for the selected QSOs

### 8. Lookup QSOs with missing grid in callbook

* **Purpose**: Updates QSOs without gridsquares from the configured callbook.
* **Downside**: Slow, and only operates on 150 QSOs for each run. This is done because of time out issues.

### 9. Check IOTA against DXCC

* **Purpose**: Since IOTAs belong to DXCCs, a check is done to see if the IOTA belongs to the DXCC of the qso.
* **Downside**: Depends on setting either correct IOTA or DXCC.

## How It Works

## Access and Usage

### Location

* Navigate to **Advanced Logbook** → **DBTools** tab  
* Requires appropriate user permissions (typically admin or logbook owner)  

### Interface

* **Left Panel**: Tool selection and action buttons  
* **Right Panel**: Results and process information  
* **Actions**: Check, Fix, Run or Update buttons depending on tool type  

### Workflow

1. **Step 1**: Use **Check** buttons to identify issues  
2. **Step 2**: Review results and affected QSOs  
3. **Step 3**: Apply fixes using the appropriate action button  
4. **Step 4**: Wait until the fix is done

## Technical Implementation

### Data Sources

* DXCC entity database from Club Log
* Zone definitions from CQ and ITU specifications  
* Administrative boundary data for state/province determination  

### Performance Considerations

* Batch processing optimized for large logbooks  
* Memory-efficient database queries  

## Best Practices

1. **Backup First**: Always create a logbook backup before running bulk fixes  
2. **Review Results**: Carefully examine what will be changed before applying fixes  
3. **Monitor Progress**: For large logbooks, allow adequate processing time  
4. **Verify After**: Spot-check results after fixes are applied to ensure accuracy  

## Troubleshooting

### Common Issues

* **Memory Limits**: Large logbooks may require increased PHP memory limits  
* **Timeout Issues**: Long operations may need extended execution time limits  
* **Coordinate Accuracy**: Some fixes depend on accurate grid square data  
* **DXCC update does not update the QSO(s)**: Check the callsign(s) in the list and see if they really are a DXCC.
* **State updater does not update state/county/region**: the map data we use aren't 100% accurate, so it may not cover all of the land. A 6 character gridsquare is some times not accurate enough to place the position inside the state/county/region.
