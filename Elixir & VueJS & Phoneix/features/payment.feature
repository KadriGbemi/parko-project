# Feature: Parking service payment feature
#   As an user of FindMeAParkingSpace service
#   Such that I can pay for my parking
#   I want to be available to choose payment type, parking start and end time

#   Scenario: Paying for parking
#     Given FindMeAParkingSpace's parking spaces info includes the following spaces
#         | availablity         | unavailable_to | location        | zone_id | longitude | latitude |
#         | false               | 12:00          | Puusepa 7       | 1       | 12.34     | 11.34    |    
#         | true                |                | Puusepa 8       | 1       | 12.35     | 11.34    |   
#         | false               | 13:23          | Narva mnt 89    | 2       | 13.35     | 16.34    | 
#     And the time is 13:00
#     And the location longitude gotten from mobile device is 12.35
#     And the latitude is 11.34
#     When user clicks the button to start paying for the parking
#     Then user should be available to choose hourly payment or real-time payment
#     And system should find "Puusepa 8" as the parking place
#     When user chooses hourly payment
#     Then user should be available to insert parking start time 
#     And parking end time
#     When user chooses "13:00" as parking start time
#     and user chooses "15:00" as parking end time
#     Then system should mark "Puusepa 8" availablity "false"
#     And system should mark "unavailable_to" to "15:00"
#     When time is now "14:50"
#     And parking is pays until "15:00"
#     Then system should send notification about the paid parking ending soon
#     When user updates extends the parking period
#     Then "unavailable_to" should be updated also
#     When user chooses not to extend the parking period
#     And the paid parking ends in less than "2" minutes
#     Then system should update "availability" to true
#     And "unavailable_to" to null 