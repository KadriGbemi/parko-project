Feature: Parking place search feature
  As an user of FindMeAParkingSpace service
  Such that I can find possible parking places
  I want to get access to available nearby parking spaces based on inserted address

  Scenario: Identifying parking spaces with in 500m radius
    Given the following parking spaces  
        | address         | zone       | lat       | lng       | is_road   | available_space  | total_space |
        | park 1          | A          | 58.359233 | 26.678020 | false     | 10               | 10          |
        | park 2          | B          | 58.359108 | 26.678020 | false     | 10               | 10          |
        | park 3          | B          | 58.354450 | 26.688985 | false     | 10               | 10          |

    And "park 1" has the following corner points which makes it completely with in 500 m radius 
        | lat        | lng        |
        | 58.359515  | 26.686992  |
        | 58.359188  | 26.686240  |
        | 58.359008  | 26.686582  |
        | 58.359278  | 26.687312  |     
    And "park 2" has the following corner points which makes it partially with in 500 m radius 
        | lat        | lng        |
        | 58.358255  | 26.680093  |
        | 58.360105  | 26.677590  |
        | 58.359143  | 26.676460  |
        | 58.357951  | 26.679751  |    
    And "park 3" having the following points which makes it completely out of 500 m radius 
        | lat        | lng        |
        | 58.354597  | 26.688315  | 
        | 58.354095  | 26.688876  |
        | 58.354102  | 26.689397  |
        | 58.354674  | 26.689236  |  
    And I go to the home page     
    And I fill "Riia 132" as destination address and submit
    Then I should see 2 rows

    