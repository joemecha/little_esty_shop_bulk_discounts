```
███████╗░██████╗████████╗██╗░░░██╗  ░██████╗██╗░░██╗░█████╗░██████╗░            
██╔════╝██╔════╝╚══██╔══╝╚██╗░██╔╝  ██╔════╝██║░░██║██╔══██╗██╔══██╗            
█████╗░░╚█████╗░░░░██║░░░░╚████╔╝░  ╚█████╗░███████║██║░░██║██████╔╝            
██╔══╝░░░╚═══██╗░░░██║░░░░░╚██╔╝░░  ░╚═══██╗██╔══██║██║░░██║██╔═══╝░            
███████╗██████╔╝░░░██║░░░░░░██║░░░  ██████╔╝██║░░██║╚█████╔╝██║░░░░░            
╚══════╝╚═════╝░░░░╚═╝░░░░░░╚═╝░░░  ╚═════╝░╚═╝░░╚═╝░╚════╝░╚═╝░░░░░            

██████╗░██╗░░░██╗██╗░░░░░██╗░░██╗  ██████╗░██╗░██████╗░█████╗░░█████╗░██╗░░░██╗███╗░░██╗████████╗░██████╗
██╔══██╗██║░░░██║██║░░░░░██║░██╔╝  ██╔══██╗██║██╔════╝██╔══██╗██╔══██╗██║░░░██║████╗░██║╚══██╔══╝██╔════╝
██████╦╝██║░░░██║██║░░░░░█████═╝░  ██║░░██║██║╚█████╗░██║░░╚═╝██║░░██║██║░░░██║██╔██╗██║░░░██║░░░╚█████╗░
██╔══██╗██║░░░██║██║░░░░░██╔═██╗░  ██║░░██║██║░╚═══██╗██║░░██╗██║░░██║██║░░░██║██║╚████║░░░██║░░░░╚═══██╗
██████╦╝╚██████╔╝███████╗██║░╚██╗  ██████╔╝██║██████╔╝╚█████╔╝╚█████╔╝╚██████╔╝██║░╚███║░░░██║░░░██████╔╝
╚═════╝░░╚═════╝░╚══════╝╚═╝░░╚═╝  ╚═════╝░╚═╝╚═════╝░░╚════╝░░╚════╝░░╚═════╝░╚═╝░░╚══╝░░░╚═╝░░░╚═════╝░
```
## Table of contents
* [General info](#general-info)
* [Database Schema](#database-schema)
* [Learning Goals/Areas of Focus](#learning-goals)
* [Technologies](#technologies)
* [Setup](#setup)
* [Features](#features)
* [Status](#status)
* [Contact](#contact)

## General info
This project is

## Database Schema
![Diagram](https://github.com/brisag/recreational_rails/blob/main/images/diagram.png "Database Schema")

## Learning Goals / Areas of Focus
* Design
* Write
* Use
* Create
* Write

## Technologies
Project is created with:
* Ruby version 2.5.3
* Rails version 5.2.5
* PostgeSQL

## Setup
To run this program:

1. To run this program, view in browser

Open the browser of your choice and navigate to:
'''
https://pumpkin-pie-69630.herokuapp.com/
'''

1. From this repository, press the green "clone" button and then copy the link
   by pressing the Copy To Clipboard icon.
1. Navigate to the folder where you want to save it and enter:
    '''
    $ git clone <copied link>
   '''
1. Navigate into the new folder containing this project
   '''
   $ cd recreational_rails
   '''
1. Install required gem files
   '''
   $ bundle install
   '''

Connecting to the database & starting the server:

1. Make sure the app PostgreSQL is running
1. Run the following commands:
   '''
   $ rails s
   $ rails db{drop,create,migrate,seed}
   '''

View in browser
1. Open the browser of your choice and navigate to:
   '''
   http://localhost:3000/
   '''

## Features
List of features ready and TODOs for future development
* View lists of Backcountry Offices, individual offices with their details,
 and associated trails
* View lists of Parks, individual parks with their details,
 and associated visitor programs
* Navigation bar with links to index pages containing a full list of a type of
  resource (e.g. all programs)
* All types of resources can be created, updated, and deleted
* Sort displayed resources alphabetically using a link
* Sort by number of trails/programs using a link
* Filter displayed records by a numeric threshold (trails with an elevation gain
   higher than the value, programs with greater participant limit than provided
   number)
* Matching and partial match name search of backcountry offices or parks using
  a search bar

To-do list:
* Add feature tests to cover the exact and partial name search methods
* Additional refactoring

## Status
Project is: _in progress_

## Contact
Created by
* [@joemecha](https://github.com/joemecha)

~ feel free to contact me ~

![Ranger leading program](/images/park_program.jpeg "Ranger led program")
