# Drone collision avoidance

The purpose of this project is to create a system for processing radar data and calculating whether detected obstacles are on a collision course with a drone.

## Description

The scope of this project is to handle the data from a rotating radar and determining whether a collision is likely. The radar itself as well as the visualization of the objects being tracked do not fall under this. The data processing algorithm is written in MATLAB, but when finished will be converted into VHDL code using the [HDL Coder](https://www.mathworks.com/products/hdl-coder.html) toolbox. To generate accurate radar data, a seperate MATLAB script will be written to calculate the radar angle, distance, and time of detection. This will then be copied to an Arduino, which will use a TBD communication protocol to send it to the FPGA.

## Data processing

The script for data processing is covered in the following files:

* collision_calculation.m
* eulToCar.m
* obstacle.m
* P.m

### Obstacle matching

The script represents each tracked obstacle as an object of the class obstacle, defined in obstacle.m. When an obstacle is detected, the script tries to match it to one of the objects based on the position of the obstacle, as well as the time of detection. It then matches it to the object that would be closest based on the previously calculated velocity and time. This means that for now the system is limited in that it tracks a fixed amount of objects, and that an obstacle must be matched to an already existing object instead of instantiating a new object for that obstacle.

### Collision detection

Once the script has matches an obstacle to an object, the next step is to update the values of that object. It will update the current position, as well as last detection time. Based on this it will calculate the X and Y speed. This will then be graphed in a figure showing the path for the next 5 seconds. If this comes within a 4 meter area of the drone, a warning will be displayed.

## Author
Fer Clerkx