*** Variables ***
${IP}
${users_variables_path1}   /home/testadm/users_variables.py
${users_variables_path2}   ${EXECDIR}/users_variables.py


*** Keywords ***
Змінити стартову сторінку для IP
	${start_page}  Run Keyword If  '${IP}' != ''  Set Variable  ${IP}
	...  ELSE  Set Variable  ${start_page}
	Set Global Variable  ${start_page}


Отримати стартову сторінку
	[Arguments]  ${site}
	${start_page}  Run Keyword If  "${site}" == "prod"  Set Variable  ${prod}
	...  ELSE  Set Variable  ${test}
	Set Global Variable  ${start_page}
	[Return]  ${start_page}


Отримати дані користувача
	[Arguments]  ${user}
	${status}  Run Keyword And Return Status  Import Variables  ${users_variables_path1}
	Run Keyword If  ${status} == ${False}  Import Variables  ${users_variables_path2}
	${a}  Create Dictionary  a  ${users_variables}
	${users_variables}  Set Variable  ${a.a}
	Set Global Variable  ${users_variables}
	Set Global Variable  ${name}  ${users_variables.${user}.name}
	Set Global Variable  ${role}  ${users_variables.${user}.role}
	Set Global Variable  ${site}  ${users_variables.${user}.site}
	[Return]  ${users_variables.${user}.login}  ${users_variables.${user}.password}


Поправити лінку для IP
	[Arguments]  ${href}
	${href}  Run Keyword If  '${IP}' != '${EMPTY}'  convert_url  ${href}  ${IP}
	...  ELSE  Set Variable  ${href}
	[Return]  ${href}

