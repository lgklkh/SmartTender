*** Variables ***
${tender found}                     //*[@id="tenders"]/tbody/*[@class="head"]//a[@href and @class="linkSubjTrading"]
${advanced search}                  xpath=//div[contains(text(),'Розширений пошук')]/..
${find tender field}                xpath=//input[@placeholder="Введіть запит для пошуку або номер тендеру"]

${first found element}              css=#tenders tbody>.head a.linkSubjTrading
${last found element}               xpath=(//*[@id='tenders']//tbody/*[@class='head']//a[@class='linkSubjTrading'])[last()]


*** Keywords ***
Знайти тендер по auctionID
  [Arguments]  ${tenderID}
  Виконати пошук тендера  ${tenderID}
  ${tender_href}=  Get Element Attribute  ${tender found}  href
  Go To  ${tender_href}
  Run Keyword If  '${tender_href}' == ''  Run Keywords
  ...  Log  ${tender_href}  WARN
  ...  AND  Set Global Variable  ${tender_href}


Відкрити сторінку тестових торгів
  ${dropdown navigation}  Set Variable  css=#MenuList div.dropdown li>a
  ${button komertsiyni-torgy}  Set Variable  css=.with-drop>a[href='/komertsiyni-torgy/']
  Go To  ${start_page}
  Mouse Over  ${button komertsiyni-torgy}
  Click Element  ${dropdown navigation}[href='/test-tenders/']
  Location Should Contain  /test-tenders/


Зайти на сторінку комерційніх торгів
  ${komertsiyni-torgy icon}  Set Variable  xpath=//*[@id="main"]//a[2]/img
  Click Element  ${komertsiyni-torgy icon}
  Location Should Contain  /komertsiyni-torgy/


Відфільтрувати по формі торгів
  [Arguments]  ${type}=${TESTNAME}
  Розгорнути розширений пошук та випадаючий список видів торгів  ${type}
  Sleep  1
  Wait Until Keyword Succeeds  30s  5  Click Element  xpath=//li[contains(@class,'dropdown-item') and text()='${type}']


Відфільтрувати по статусу торгів
	[Arguments]  ${status}
	${dropdown menu for bid statuses}  Set Variable  //label[contains(text(),'Статуси')]/../../ul
	Click Element  ${dropdown menu for bid statuses}
	Click Element  xpath=//li[text()='${status}']


Відфільтрувати по даті кінця прийому пропозиції від
	[Arguments]  ${date}
	${input}  Set Variable  //label[contains(text(),'Завершення прийому')]/../following-sibling::*//input
	Input Text  ${input}  ${date}
	Press Key  ${input}  \\13


Розгорнути розширений пошук та випадаючий список видів торгів
  [Arguments]  ${check from list}=${TESTNAME}
  ${dropdown menu for bid forms}  Set Variable  xpath=//label[contains(text(),'Форми ')]/../../ul
  Wait Until Keyword Succeeds  30s  5  Run Keywords
  ...       Click Element  ${advanced search}
  ...  AND  Run Keyword And Expect Error  *  Click Element  ${advanced search}
  Sleep  2
  Wait Until Keyword Succeeds  30s  5  Run Keywords
  ...       Click Element  ${dropdown menu for bid forms}
  ...  AND  Wait Until Page Contains Element  css=.token-input-dropdown-facebook li
  ...  AND  Wait Until Page Contains Element  xpath=//li[contains(@class,'dropdown-item') and text()='${check from list}']


Виконати пошук тендера
  [Arguments]  ${id}=None
  Run Keyword If  '${id}' != 'None'  Input Text  ${find tender field}  ${id}
  Press Key  ${find tender field}  \\13
  Run Keyword If  '${id}' != 'None'  Location Should Contain  f=${id}
  Wait Until Page Contains Element  ${tender found}
  Run Keyword If  '${id}' != 'None'  Перевірити унікальність результату пошуку


Перевірити унікальність результату пошуку
  ${count}  Get Element Count  ${tender found}
  Should Be Equal  '${count}'  '1'


Перейти по результату пошуку
  [Arguments]  ${selector}
  ${href}  Get Element Attribute  ${selector}  href
  ${href}  Поправили лінку для IP  ${href}
  Go To  ${href}
  Виділити iFrame за необхідністю
  Дочекатись закінчення загрузки сторінки(webclient)


Розгорнути розширений пошук
  Wait Until Keyword Succeeds  30s  5  Run Keywords
  ...  Click Element  ${advanced search}
  ...  AND  Element Should Be Visible  xpath=//*[@class="dhxform_base"]//*[contains(text(), 'Згорнути пошук')]