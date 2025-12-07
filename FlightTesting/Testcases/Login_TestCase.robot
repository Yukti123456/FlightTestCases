*** Settings ***
Documentation     TestingMint — Flight practice: Login + Search module tests (positive & negative)
Resource    ../Resources/Keywords/LoginKeywords.robot
Library     SeleniumLibrary
Suite Setup       Open Browser To Home
Suite Teardown    Close All Browsers

*** Test Cases ***
Positive Login - should login with valid user
    [Documentation]    Positive login: valid credentials should log user in
    Go To Login Page
    Login To Application    ${VALID_USERNAME}    ${VALID_PASSWORD}
    Verify Login Success

Negative Login - invalid credentials show error
    [Documentation]    Negative login: invalid credentials should show error message
    Go To Login Page After Positive
    Login To Application    ${INVALID_USERNAME}    ${INVALID_PASSWORD}
    Verify Login Failed