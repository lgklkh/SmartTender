*** Settings ***
Variables  small_privatization_object_variables.py


*** Variables ***


*** Keywords ***
Натиснути кнопку "Коригувати об'єкт приватизації"
     ${selector}  Set Variable  //*[@data-qa="button-to-edit-page"]
     Scroll Page To Element XPATH  ${selector}
     Click Element  ${selector}
     Дочекатись закінчення загрузки сторінки(skeleton)
     Location Should Contain  /privatization-objects/edit/


Отримати кілкість документів обєкту приватизації
    ${selector}  Set Variable  //*[@data-qa="file-name"]
    ${count}  Get Element Count  ${selector}
    [Return]  ${count}


Заповнити всі обов'язкові поля
	small_privatization_object.Заповнити title
    small_privatization_object.Заповнити description
    small_privatization_object.Заповнити decision.title
    small_privatization_object.Заповнити decision.number
    small_privatization_object.Заповнити decision.date
    small_privatization_object.Заповнити items.description
    small_privatization_object.Заповнити items.kind
    small_privatization_object.Заповнити items.count
    small_privatization_object.Заповнити items.unit
    small_privatization_object.Заповнити items.postalcode
    small_privatization_object.Заповнити items.country
    small_privatization_object.Заповнити items.city
    small_privatization_object.Заповнити items.streetAddress


Натиснути кнопку зберегти
	${save btn}  Set variable  //*[@data-qa='button-success']
    Scroll Page To Element XPATH  ${save btn}
    Click Element  ${save btn}
    Wait Until Page Contains Element  ${notice message}  15
    ${notice text}  Get Text  ${notice message}
	Should Contain  ${notice text}  успішно
	Wait Until Page Does Not Contain Element  ${notice message}


Опублікувати об'єкт у реєстрі
	${publish btn}  Set Variable  //*[@data-qa='button-publish-asset']
	Wait Until Element Is Visible  ${publish btn}  10
   	Wait Until Element Is Not Visible  //*[@class='ivu-message']  10
	Scroll Page To Element XPATH  ${publish btn}
	Click Element  ${publish btn}
    Wait Until Page Contains Element  ${notice message}  15
    ${notice text}  Get Text  ${notice message}
	Should Contain  ${notice text}  успішно
	Wait Until Page Does Not Contain Element  ${notice message}


Заповнити title
	${text}  create_sentence  5
	${title}  Set Variable  ${text}
	${selector}  Set Variable  //*[@data-qa='input-title']//*[@autocomplete="off"]
	Wait Until Keyword Succeeds  30  3  small_privatization.Заповнити та перевірити текстове поле  ${selector}  ${title}
	Set To Dictionary  ${data['object']}  title  ${title}


Заповнити description
	${description}  create_sentence  20
	${selector}  Set Variable  //*[@data-qa='input-description']//*[@autocomplete="off"]
	Wait Until Keyword Succeeds  30  3  small_privatization.Заповнити та перевірити текстове поле  ${selector}  ${description}
	Set To Dictionary  ${data['object']}  description  ${description}


Заповнити decision.title
	${title}  create_sentence  5
	${selector}  Set Variable  //*[@data-qa='input-decision-title']//*[@autocomplete="off"]
	Wait Until Keyword Succeeds  30  3  small_privatization.Заповнити та перевірити текстове поле  ${selector}  ${title}
	${decision}  Create Dictionary  title  ${title}
	Set To Dictionary  ${data['object']}  decision  ${decision}


Заповнити decision.number
	${number}  random_number  1000  1000000
	${selector}  Set Variable  //*[@data-qa='input-decision-number']//*[@autocomplete="off"]
	Wait Until Keyword Succeeds  30  3  small_privatization.Заповнити та перевірити текстове поле  ${selector}  ${number}
	Set To Dictionary  ${data['object']['decision']}  number  ${number}


Заповнити decision.date
	${date}  smart_get_time  0  m
	${selector}  Set Variable  //*[@data-qa='datepicker-decision-date']//*[@autocomplete="off"]
	Wait Until Keyword Succeeds  30  3  small_privatization.Заповнити та перевірити текстове поле  ${selector}  ${date}
	Set To Dictionary  ${data['object']['decision']}  date  ${date}


Заповнити items.description
	${description}  create_sentence  20
	${selector}  Set Variable  //*[@data-qa='input-items-description']//*[@autocomplete="off"]
	Wait Until Keyword Succeeds  30  3  small_privatization.Заповнити та перевірити текстове поле  ${selector}  ${description}
	${items}  Create Dictionary  description  ${description}
	Set To Dictionary  ${data['object']}  item  ${items}


Заповнити items.kind
    ${selector}  Set Variable  //*[@data-qa='select-items-object-kind']
	${kind}  Wait Until Keyword Succeeds  30  3  small_privatization.Вибрати та повернути елемент з випадаючого списку за назвою  ${selector}  102
   	Should Not Be Empty  ${kind}
	Set To Dictionary  ${data['object']['item']}  kind  ${kind}


Заповнити items.count
	${first}  random_number  1  100000
	${second}  random_number  1  1000
    ${count}  Evaluate  str(round(float(${first})/float(${second}), 3))
	${selector}  Set Variable  //*[@data-qa='input-item-count']//*[@autocomplete="off"]
	Wait Until Keyword Succeeds  30  3  small_privatization.Заповнити та перевірити текстове поле  ${selector}  ${count}
	Set To Dictionary  ${data['object']['item']}  count  ${count}


Заповнити items.unit
    ${selector}  Set Variable  //*[@data-qa='select-item-unit']
    Scroll Page To Element XPATH  ${selector}
	${unit}  Wait Until Keyword Succeeds  30  3  small_privatization.Вибрати та повернути випадковий елемент з випадаючого списку  ${selector}
	Set To Dictionary  ${data['object']['item']}  unit  ${unit}


Заповнити items.postalcode
	${postalcode}  random_number  10000  99999
	${selector}  Set Variable  //div[contains(@class,'address-label') and not(contains(@class,'offset '))]//input[@type='text']
	Wait Until Keyword Succeeds  30  3  small_privatization.Заповнити та перевірити текстове поле  ${selector}  ${postalcode}
	Set To Dictionary  ${data['object']['item']}  postalcode  ${postalcode}


Заповнити items.country
   	${selector}  Set Variable  //div[@class='ivu-col ivu-col-span-sm-9']
	Scroll Page To Element XPATH  ${selector}
    ${country}  Wait Until Keyword Succeeds  30  3  small_privatization.Вибрати та повернути елемент з випадаючого списку за назвою  ${selector}  Україна
    Set To Dictionary  ${data['object']['item']}  country  ${country}


Заповнити items.city
   	${selector}  Set Variable  //div[@class='ivu-col ivu-col-span-sm-10']
    ${city}  Wait Until Keyword Succeeds  30  3  small_privatization.Вибрати та повернути випадковий елемент з випадаючого списку  ${selector}
    Set To Dictionary  ${data['object']['item']}  city  ${city}


Заповнити items.streetAddress
    ${address}  get_some_uuid
   	${selector}  Set Variable  //*[@data-qa='component-item-address']/div[contains(@class,'ivu-form-item-required')]//input
   	Wait Until Keyword Succeeds  30  3  small_privatization.Заповнити та перевірити текстове поле  ${selector}  ${address}
    Set To Dictionary  ${data['object']['item']}  address  ${address}


Прикріпити документ
	${selector}  Set Variable  //*[@data-qa='component-documents']
	${doc}  Створити та додати файл  ${selector}//input
	Element Should Contain  ${selector}  ${doc[1]}
	Set To Dictionary  ${data['object']}  document-name  ${doc[1]}


Отримати UAID для Об'єкту
	Reload Page
    Wait Until Element Is Visible  //*[@data-qa='cdbNumber']  10
    Wait Until Element Is Not Visible  //*[@class='ivu-message']  10
	${UAID}  Get Text  //*[@data-qa='cdbNumber']
	${correct status}  Run Keyword And Return Status  Перевірити коректність UAID для Об'єкту  ${UAID}
	Run Keyword If  ${correct status} == ${False}  Отримати UAID для Об'єкту
    Set To Dictionary  ${data['object']}  UAID  ${UAID}


Перевірити коректність UAID для Об'єкту
	[Arguments]  ${UAID is}
	${date now}  Evaluate  '{:%Y-%m-%d}'.format(datetime.datetime.now())  modules=datetime
	${UAID should}  Set Variable  UA-AR-P-${date now}
	Should Contain  ${UAID is}  ${UAID should}