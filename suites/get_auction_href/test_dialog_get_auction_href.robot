*** Settings ***
Resource  ../../src/src.robot
Suite Setup     Створити словник  data
Suite Teardown  Close All Browsers
Test Teardown  Run Keyword If Test Failed  Run Keywords
...                                        Log Location  AND
...                                        Capture Page Screenshot

#  robot --consolecolors on -L TRACE:INFO -d test_output -e get_tender suites/get_auction_href/test_dialog_get_auction_href.robot
*** Test Cases ***
Підготувати користувачів
    Додати першого користувача  Bened           tender_owner
    Додати користувача          user1           provider1
    Додати користувача          user2           provider2
    Додати користувача          user3           provider3
    Додати користувача          user4           provider4
    Додати користувача          test_viewer     viewer


Створити тендер
	[Tags]  create_tender
	Завантажити сесію для  tender_owner
	test_dialog.Створити тендер


Отримати дані тендера та зберегти їх у файл
    [Tags]  create_tender
	Пошук об'єкта у webclient по полю  Узагальнена назва закупівлі  ${data['title']}
    ${tender_uaid}  Отримати tender_uaid вибраного тендера
    ${tender_href}  Отримати tender_href вибраного тендера
    Set To Dictionary  ${data}  tender_uaid  ${tender_uaid}
    Set To Dictionary  ${data}  tender_href  ${tender_href}
    Log  ${tender_href}  WARN
    Зберегти словник у файл  ${data}  data


If skipped create tender
	[Tags]  get_tender
	${json}  Get File  ${OUTPUTDIR}/artifact_data.json
	${data}  conver json to dict  ${json}
	Set Global Variable  ${data}


Перевірка відображення даних створеного тендера на сторінці
    [Tags]  view
    [Setup]  Stop The Whole Test Execution If Previous Test Failed
    Перевірка відображення даних тендера на сторінці  provider1


Подати заявку на участь в тендері трьома учасниками на 1-му етапі
	:FOR  ${i}  IN  1  2  3
	\  Завантажити сесію для  provider${i}
	\  Прийняти участь у тендері учасником  provider${i}


Підготувати користувача та дочекатись початку періоду перкваліфікації
    Завантажити сесію для  provider1
    Go to  ${data['tender_href']}
    Дочекатись початку періоду перкваліфікації


Відкрити браузер під роллю організатора та знайти тендер
    Завантажити сесію для  tender_owner
	Перейти у розділ (webclient)  Конкурентний діалог(тестові)
    Пошук об'єкта у webclient по полю  Узагальнена назва закупівлі  ${data['title']}


Підтвердити прекваліфікацію всіх учасників
    Провести прекваліфікацію учасників
    Підтвердити організатором формування протоколу розгляду пропозицій


Підготувати користувача та дочекатись очікування рішення організатора
    [Setup]  Stop The Whole Test Execution If Previous Test Failed
    Завантажити сесію для  provider1
    Go to  ${data['tender_href']}
    Wait Until Keyword Succeeds  20m  10  Дочекатись закінчення періоду прекваліфікації
    Дочекатися статусу тендера  Очікування рішення організатора


Виконати дії для переведення тендера на 2-ий етап
    Завантажити сесію для  tender_owner
    Перейти до другої фази
    Завантажити сесію для  provider1
    Дочекатися статусу тендера  Завершено
    Завантажити сесію для  tender_owner
    Перейти до другого етапу
    Опублікувати процедуру


Отримати дані тендера та зберегти їх у файл
    [Tags]  create_tender
	Пошук об'єкта у webclient по полю  Узагальнена назва закупівлі  ${data['title']}
    ${tender_uaid}  Отримати tender_uaid вибраного тендера
    ${tender_href}  Отримати tender_href вибраного тендера
    Set To Dictionary  ${data}  tender_uaid  ${tender_uaid}
    Set To Dictionary  ${data}  tender_href  ${tender_href}
    Log  ${tender_href}  WARN
    Зберегти словник у файл  ${data}  data


Підготувати учасників до участі в тендері на 2-ий етап
    Close All Browsers
    Start  user1  provider1
    Start  user2  provider2
    Start  user3  provider3


Подати заявку на участь в тендері трьома учасниками на 2-му етапі
	:FOR  ${user}  IN  provider1  provider2  provider3
	\  Прийняти участь у тендері учасником  ${user}


Підготувати учасників для отримання посилання на аукціон
    Close All Browsers
    Start  user1  provider1
    Go to  ${data['tender_href']}


Отримати поcилання на участь в аукціоні для учасників
	[Setup]  Stop The Whole Test Execution If Previous Test Failed
	Завантажити сесію для  provider1
    Go to  ${data['tender_href']}
    Дочекатись закінчення прийому пропозицій
	Дочекатися статусу тендера  Аукціон
    Wait Until Keyword Succeeds  180  3  Перевірити отримання ссилки на участь в аукціоні  provider1


Неможливість отримати поcилання на участь в аукціоні
	[Template]  Перевірити можливість отримати посилання на аукціон користувачем
	viewer
	tender_owner
	provider4



*** Keywords ***
Перевірка відображення даних тендера на сторінці
    [Arguments]  ${role}
    Завантажити сесію для  ${role}
    Go to  ${data['tender_href']}
    Перевірити коректність даних на сторінці  ['title']
    Перевірити коректність даних на сторінці  ['description']
    Перевірити коректність даних на сторінці  ['tender_uaid']
    Перевірити коректність даних на сторінці  ['item']['title']
    Перевірити коректність даних на сторінці  ['item']['city']
    Перевірити коректність даних на сторінці  ['item']['streetAddress']
    Перевірити коректність даних на сторінці  ['item']['postal code']
    Перевірити коректність даних на сторінці  ['item']['id']
    Перевірити коректність даних на сторінці  ['item']['id title']
    Перевірити коректність даних на сторінці  ['item']['unit']
    Перевірити коректність даних на сторінці  ['item']['quantity']
    Перевірити коректність даних на сторінці  ['tenderPeriod']['endDate']
    Перевірити коректність даних на сторінці  ['value']['amount']
    Перевірити коректність даних на сторінці  ['value']['minimalStep']['percent']


Прийняти участь у тендері учасником
    [Arguments]  ${role}
    Завантажити сесію для  ${role}
    Go to  ${data['tender_href']}
    Дочекатися статусу тендера  Прийом пропозицій
    Run Keyword If  '${role}' == 'provider1'  Sleep  3m
    Подати пропозицію учасником


Прийняти участь у тендері учасником на 1-му етапі
    [Arguments]  ${role}
    Завантажити сесію для  ${role}
    Go to  ${data['tender_href']}
    Дочекатися статусу тендера  Прийом пропозицій
    Run Keyword If  '${role}' == 'provider1'  Sleep  3m
    Подати пропозицію учасником на 1-му етапі


Подати пропозицію учасником
	Перевірити кнопку подачі пропозиції
	Заповнити поле з ціною  1  1
    Додати файл  1
	Run Keyword And Ignore Error  Підтвердити відповідність
	Подати пропозицію
    Go Back


Подати пропозицію учасником на 1-му етапі
	Перевірити кнопку подачі пропозиції
	Run Keyword And Ignore Error  Підтвердити відповідність
	Подати пропозицію
    Go Back


Перевірити отримання ссилки на участь в аукціоні
    [Arguments]  ${role}
    Завантажити сесію для  ${role}
    Go To  ${data['tender_href']}
    Натиснути кнопку "До аукціону"
	${auction_participate_href}  Отримати URL для участі в аукціоні
	Wait Until Keyword Succeeds  60  3  Перейти та перевірити сторінку участі в аукціоні  ${auction_participate_href}


Перейти та перевірити сторінку участі в аукціоні
	[Arguments]  ${auction_href}
	Go To  ${auction_href}
	Location Should Contain  bidder_id=
	Підтвердити повідомлення про умови проведення аукціону
	Wait Until Page Contains Element  //*[@class="page-header"]//h2  30
	Sleep  2
	Element Should Contain  //*[@class="page-header"]//h2  ${data['tender_uaid']}
	Element Should Contain  //*[@class="lead ng-binding"]  ${data['title']}
	Element Should Contain  //*[contains(@ng-repeat, 'items')]  ${data['item']['title']}
	Element Should Contain  //*[contains(@ng-repeat, 'items')]  ${data['item']['quantity']}
	Element Should Contain  //*[contains(@ng-repeat, 'items')]  ${data['item']['unit']}
	Element Should Contain  //h4  Вхід на даний момент закритий.
    Go Back

Перевірити можливість отримати посилання на аукціон користувачем
	[Arguments]  ${role}
	Завантажити сесію для  ${role}
	Go to  ${data['tender_href']}
	${auction_participate_href}  Run Keyword And Expect Error  *  Run Keywords
	...  Натиснути кнопку "До аукціону"
	...  AND  Отримати URL для участі в аукціоні