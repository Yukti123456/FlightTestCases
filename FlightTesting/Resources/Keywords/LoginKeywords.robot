*** Settings ***
Resource    ../Variables/Login_Credentials.robot
Library     SeleniumLibrary

*** Keywords ***
Open Browser To Home
    [Documentation]    Launching Browser
    Open Browser    ${BASE_URL}    ${BROWSER}
    Maximize Browser Window
    Set Selenium Timeout    ${TIMEOUT}

Go To Login Page
    [Documentation]    Ensure we are on login page or go to login page
    Go To    ${BASE_URL}
    Wait Until Page Contains Element    xpath=//button[normalize-space(text())='Login']      ${TIMEOUT}
    click button      xpath=//button[normalize-space(text())='Login']

Go To Login Page After Positive
    [Documentation]    It will navigate to login page again,after succesfull login,
    Click button      xpath=//button[span[contains(text(),'Logout')]]
    Wait Until Page Contains Element    xpath=//button[normalize-space(text())='Login']      ${TIMEOUT}
    click button      xpath=//button[normalize-space(text())='Login']

# --- LOGIN KEYWORDS ---
Login To Application
    [Arguments]    ${username}    ${password}
    [Documentation]    Generic login with credentials.
    Set Selenium Speed  1s
    # Common locators to try (update to actual ones from site if different)
    ${loc_username_ok}=    Run Keyword And Return Status    Element Should Be Visible    id=username
    Run Keyword If    ${loc_username_ok}    Input Text    id=username    ${username}
    ...    ELSE    Run Keyword If    Run Keyword And Return Status    Element Should Be Visible    name=username    Input Text    name=username    ${username}
    # password field
    ${loc_pwd_ok}=    Run Keyword And Return Status    Element Should Be Visible    id=password
    Run Keyword If    ${loc_pwd_ok}    Input Password    id=password    ${password}
    ...    ELSE    Run Keyword If    Run Keyword And Return Status    Element Should Be Visible    name=password    Input Password    name=password    ${password}
    # submit
    ${loc_btn_ok}=    Run Keyword And Return Status    Element Should Be Visible    xpath=//button[contains(., 'Login') or contains(., 'Sign in')]
    Run Keyword If    ${loc_btn_ok}    Click Button    xpath=//button[normalize-space()='Sign In']
     ...    ELSE    Run Keyword If    Run Keyword And Return Status    Element Should Be Visible    id=login-btn    Click Button    id=login-btn
    Wait Until Page Contains    ${EMPTY}    timeout=1s    # allow redirect to start; real checks below

Any Login Indicator Visible
    [Documentation]    Returns successfully if any known login-success indicator is visible on the page.
    ${text_ok}=    Run Keyword And Return Status    Page Should Contain    TestingMint's Premium Flight Booking
    # Try a profile element / user area (adjust selector if site uses a different class)
    ${profile_ok}=    Run Keyword And Return Status    Element Should Be Visible    css:.user-profile
    # Try a logout link/button (case-insensitive search for text 'logout')
    ${logout_ok}=    Run Keyword And Return Status    Element Should Be Visible    xpath=//a[contains(translate(normalize-space(.), 'ABCDEFGHIJKLMNOPQRSTUVWXYZ', 'abcdefghijklmnopqrstuvwxyz'), 'logout')]
    ${any}=    Evaluate    ${text_ok} or ${profile_ok} or ${logout_ok}
    Run Keyword If    ${any}    Return From Keyword
    Fail    No login indicators found.

Verify Login Success
    [Documentation]    Waits until one of the common login-success indicators appears, otherwise logs current URL and fails.
    # Try the indicator-check several times (tune attempts / timeout as needed)
    Wait Until Keyword Succeeds    5 times    2s    Any Login Indicator Visible
    # Optional: log the current URL for debugging
    ${current}=    Get Location
    Log    Current URL after login: ${current}

Verify Login Failed
    [Documentation]    Looks for a visible error message indicating failed login
    Wait Until Page Contains Element    xpath=//div[normalize-space()='Invalid credentials. Use testuser/password']       ${TIMEOUT}
    Page Should Contain    Invalid credentials. Use testuser/password