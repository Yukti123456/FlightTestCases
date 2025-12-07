*** Settings ***
Resource    ../Variables/Login_Credentials.robot
Resource    ../Variables/Search_Data.robot
Library     SeleniumLibrary

*** Keywords ***
Set Date
    [Arguments]    ${locator}    ${depart_date}
    ${script}=    Catenate    SEPARATOR=\n
    ...    var el = document.evaluate("${locator.replace('"','\\"')}", document, null, XPathResult.FIRST_ORDERED_NODE_TYPE, null).singleNodeValue;
    ...    if(!el){throw 'Date input not found: ' + "${locator}";}
    ...    el.focus();
    ...    el.value = arguments[0];
    ...    el.dispatchEvent(new Event('input', { bubbles: true }));
    ...    el.dispatchEvent(new Event('change', { bubbles: true }));
    ...    el.blur();
    Execute JavaScript    ${script}    ${depart_date}
    Sleep    0.3s

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
    Run Keyword And Ignore Error    Input text      ${locator}
    Set Date      ${locator}        ${DEPART_DATE_VALID}
    ${val}=    Get Element Attribute    ${locator}    value
    Log to console    Selected date: ${val}
    Should Be Equal As Strings    ${val}    2025-12-20

    # click search
    Run Keyword And Ignore Error    Select From List By Value    xpath=//select[@data-testid='passengers-select']    ${NO_OF_PASSENGER}
    Run Keyword And Ignore Error    Click Button    xpath=//button[contains(., 'SEARCH FLIGHTS') or normalize-space()='SEARCH FLIGHTS']
    Sleep    2s

Verify Flights Found
    Verify Flights Found
    [Documentation]    Wait for flight results to appear, assert there is at least one result, and log the first result for debugging.
    # Wait until at least one likely results container appears (div or li). The XPath uses a union (|) to cover both.
    Wait Until Page Contains Element    xpath=//div[contains(@class,'flight') or contains(@class,'result')] | //li[contains(@class,'flight') or contains(@class,'result')]    ${TIMEOUT}

    # Count matching result nodes (covers both div and li cases)
    ${count}=    Get Element Count    xpath=//div[contains(@class,'flight') or contains(@class,'result')] | //li[contains(@class,'flight') or contains(@class,'result')]
    Log    Number of flight result nodes found: ${count}

    # Convert count to boolean using Evaluate (safe check)
    ${has_results}=    Evaluate    ${count} > 0
    Should Be True    ${has_results}    msg=No flights found after search (expected at least 1)

    # Optional: log text of the first result card/item to aid debugging
    ${first}=    Get Text    xpath=(//div[contains(@class,'flight') or contains(@class,'result')] | //li[contains(@class,'flight') or contains(@class,'result')])[1]
    Log    First flight result (snippet): ${first}

Verify No Flights Found
    [Documentation]    Checks for "no results" message
    Wait Until Page Contains    No flights available    ${TIMEOUT}
    Page Should Contain    No flights available
