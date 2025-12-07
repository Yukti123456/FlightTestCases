*** Settings ***
Resource    ../Resources/Keywords/SearchKeywords.robot
Resource    ../Resources/Keywords/LoginKeywords.robot
Library     SeleniumLibrary
Suite Setup       Open Browser To Home
Suite Teardown    Close All Browsers

*** Test Cases ***
Positive Flight Search - results shown for valid route
    [Documentation]    Login -> open search -> valid route returns results
    Go To Login Page
    Login To Application    ${VALID_USERNAME}    ${VALID_PASSWORD}
    Verify Login Success
    #Go To   Flight Search Page
    Search Flight    ${FROM_CITY_VALID}    ${TO_CITY_VALID}    ${DEPART_DATE_VALID}
    Verify Flights Found

Negative Flight Search - no results for invalid route
    [Documentation]    Login -> search an invalid route -> no flights found
    Go To Login Page
    Login To Application    ${VALID_USERNAME}    ${VALID_PASSWORD}
    Verify Login Success
    #Go To Flight Search Page
    Search Flight    ${FROM_CITY_BAD}    ${TO_CITY_BAD}    ${DEPART_DATE_BAD}
    Verify No Flights Found
