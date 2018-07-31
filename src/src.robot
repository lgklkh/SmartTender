*** Settings ***
Library  Selenium2Library
Library  BuiltIn
Library  Collections
Library  DebugLibrary
Library  OperatingSystem
Library  service.py
Library  Faker/faker.py
Resource  make_proposal.robot
Resource  participation_request.robot
Resource  login.robot
Resource  loading.robot
Resource  create_tender.robot


*** Variables ***
                                    ###ІНШІ ДАННІ###
${browser}                          chrome
${start_page}                       http://test.smarttender.biz
${file path}                        src/
${some text}                        Це_тестовый_текст_для_тестування._Це_тестовый_текст_для_тестування._Це_тестовый_текст_для_тестування.
${role}                             None
${IP}

                                    ###ЛОКАТОРИ###
${block}                            xpath=.//*[@class='ivu-card ivu-card-bordered']
${logout}                           id=LogoutBtn
${error}                            id=loginErrorMsg


${link to make proposal button}     css=[class='show-control button-lot']
${iframe open tender}               xpath=.//div[@class="container"]/iframe
${make proposal button}             xpath=//*[@id="tenderPage"]//a[@class='btn button-lot cursor-pointer']
${make proposal button new}         xpath=//*[@id="tenderDetail"]//a[@class="show-control button-lot"]
${komertsiyni-torgy icon}           xpath=//*[@id="main"]//a[2]/img
${derzavni zakupku}                 xpath=//*[@id="MainMenuTenders"]//ul[1]/li[2]/a
${first element find tender}        xpath=//*[@id="tenders"]//tr[1]/td[2]/a
${bread crumbs}                     xpath=(//*[@class='ivu-breadcrumb-item-link'])
${advanced search}                  xpath=//div[contains(text(),'Розширений пошук')]/..
${dropdown menu for bid forms}      xpath=//label[contains(text(),'Форми ')]/../../ul
${bids search}                      xpath=//div[contains(text(), 'Пошук')]/..
${find tender field}                xpath=//input[@placeholder="Введіть запит для пошуку або номер тендеру"]
${tender found}                     xpath=//*[@id="tenders"]/tbody/*[@class="head"]//a[@href and @class="linkSubjTrading"]
${button komertsiyni-torgy}         css=.with-drop>a[href='/komertsiyni-torgy/']
${dropdown navigation}              css=#MenuList div.dropdown li>a


*** Keywords ***
Start
  Open Browser  ${start_page}  ${browser}  alies

Open button
  [Documentation]   відкривае лінку з локатора у поточному вікні
  [Arguments]  ${selector}
  ${a}=  Get Element Attribute  ${selector}  href
  Go To  ${a}


Знайти тендер по auctionID
  [Arguments]  ${tenderID}
  Виконати пошук тендера  ${tenderID}
  ${tender_href}=  Get Element Attribute  ${tender found}  href
  Go To  ${tender_href}
  Run Keyword If  '${tender_href}' == ''  Run Keywords
  ...  Log  ${tender_href}  WARN
  ...  AND  Set Global Variable  ${tender_href}


Відкрити сторінку тестових торгів
  Go To  ${start_page}
  Mouse Over  ${button komertsiyni-torgy}
  Click Element  ${dropdown navigation}[href='/test-tenders/']
  Location Should Contain  /test-tenders/


Зайти на сторінку комерційніх торгів
  Click Element  ${komertsiyni-torgy icon}
  Location Should Contain  /komertsiyni-torgy/


Відфільтрувати по формі торгів
  [Arguments]  ${type}=${TESTNAME}
  Розгорнути розширений пошук та випадаючий список видів торгів  ${type}
  Sleep  1
  Wait Until Keyword Succeeds  30s  5  Click Element  xpath=//li[text()='${type}']


Розгорнути розширений пошук та випадаючий список видів торгів
  [Arguments]  ${check from list}=${TESTNAME}
  Wait Until Keyword Succeeds  30s  5  Run Keywords
  ...       Click Element  ${advanced search}
  ...  AND  Run Keyword And Expect Error  *  Click Element  ${advanced search}
  Sleep  2
  Wait Until Keyword Succeeds  30s  5  Run Keywords
  ...       Click Element  ${dropdown menu for bid forms}
  ...  AND  Wait Until Page Contains Element  css=.token-input-dropdown-facebook li
  ...  AND  Wait Until Page Contains Element  xpath=//li[text()='${check from list}']


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
  ${href}  Run Keyword If  '${IP}' != ''  convert_url  ${href}  ${IP}
  ...  ELSE  Set Variable  ${href}
  Go To  ${href}
  Дочекатись закінчення загрузки сторінки(webclient)


conver dict to json
  [Arguments]  ${dict}
  ${json}  evaluate  json.dumps(${dict})  json
  [Return]  ${json}


conver json to dict
  [Arguments]  ${json}
  ${dict}  Evaluate  json.loads('''${json}''')  json
  [Return]  ${dict}