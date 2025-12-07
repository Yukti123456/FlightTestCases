*** Settings ***
Resource    ../Variables/Login_Credentials.robot
Resource    ../Variables/Search_Data.robot
Library     SeleniumLibrary

*** Keywords ***
Search Flight
    [Arguments]    ${from_city}    ${to_city}    ${depart_date}
    [Documentation]    Fill search fields. Update locators to match actual page.
    # from city input
    Run Keyword And Ignore Error    Input Text    xpath=//input[@data-testid='source-input']
    Sleep    0.3s
    Clear Element Text              xpath=//input[@data-testid='source-input']
    Sleep    0.7s
    Input Text             xpath=//input[@data-testid='source-input']    ${FROM_CITY_VALID}
    # Click the matching dropdown item
    Wait Until Element Is Visible    xpath=//li[@data-testid='source-result-${FROM_CITY_VALID}']    20s
    Click Element          xpath=//li[@data-testid='source-result-${FROM_CITY_VALID}']


    # to city input
    Run Keyword And Ignore Error    Input Text    xpath=//input[@data-testid='dest-input']
    Sleep    0.3s
    Clear Element Text       xpath=//input[@data-testid='dest-input']
    Sleep    0.7s
    Input Text               xpath=//input[@data-testid='dest-input']       ${TO_CITY_VALID}
    Wait Until Element Is Visible       xpath=//li[@data-testid='dest-result-${TO_CITY_VALID}']     20s
    Click Element            xpath=//li[@data-testid='dest-result-${TO_CITY_VALID}']

    # departure date
    Execute JavaScript    document.querySelector("[data-testid='date-input']").style.opacity="1";
    Input Text    xpath=//input[@data-testid='date-input']    2025-12-20

    #Select no of passenger
    Run Keyword And Ignore Error    Select From List By Value    xpath=//select[@data-testid='passengers-select']    ${NO_OF_PASSENGER}

    #Search button
    Run Keyword And Ignore Error    Click Button       xpath=//button[@data-testid="search-btn"]
    Sleep    2s

Verify Flights Found
    Verify Flights Found
    [Documentation]    Wait for flight results to appear, assert there is at least one result, and log the first result for debugging.
    # Wait until at least one likely results container appears (div or li). The XPath uses a union (|) to cover both.
    Wait Until Page Contains Element   //div[starts-with(@data-testid, 'flight-card-')]    ${TIMEOUT}

    # Count matching result nodes
    ${count}=    Get Element Count    //div[starts-with(@data-testid, 'flight-card-')]
    Log    Number of flight result nodes found: ${count}

    # Convert count to boolean using Evaluate
    ${has_results}=    Evaluate    ${count} > 0
    Should Be True    ${has_results}    msg=No flights found after search (expected at least 1)


