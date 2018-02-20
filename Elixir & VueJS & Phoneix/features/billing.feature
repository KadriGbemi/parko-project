# Feature: Billing for the parking
#   As an client of parking management system service
#   Such that I am able to pay for parking
#   I want to be able to choose when to pay for the parking

#   Scenario: Paying for parking
#     Given that the user starts paying for the parking
#     When user chooses "hourly" payment as payment type
#     Then user should pay before the parking
#     When user chooses "real-time" payment as payment type
#     Then user should be able to choose if he/she wants to pay right now or at the end of the month
#     When user chooses "real-time" payment as payment type
#     And chooses to pay at the end of the month
#     Then user should be available to alter configuration options for the payment
