*** Variables ***

${BASE_URL}           https://testingmint.com/testingmint-flight-booking/
${BROWSER}            chrome
${TIMEOUT}            20s
# Flight search data with  valid data
${locator}            xpath=//input[@data-testid='date-input'][1]
${FROM_CITY_VALID}    Delhi
${TO_CITY_VALID}      Goa
${DEPART_DATE_VALID}  2025-12-20
${NO_OF_PASSENGER}     1

# Flight search data with  Invalid data
${FROM_CITY_BAD}      NoTownA
${TO_CITY_BAD}        NoTownB
${DEPART_DATE_BAD}    2025-12-20
${NO_OF_PASSENGER}     2