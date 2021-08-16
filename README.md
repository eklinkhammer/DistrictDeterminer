# DistrictDeterminer
This application checks if a provided coordinate is within district maps. The point is to determine eligibility of a particular
citizen to run for an open district.

# How it works
```
stack run <lat> <long>
```
Will check position defined by (lat, long) among all defined districts in resources, returning the list of districts that
the location is in.

# How to Add Districts
All districts are stored in the resources directory. To add a district type, add a folder for the district type, and then add a
csv file for each district within that. The CSV file should be the boundary coordinates expressed in lat, long.