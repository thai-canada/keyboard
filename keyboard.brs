'plugin name: keyboard

Function keyboard_Initialize(msgPort As Object, userVariables As Object, bsp as Object)
	
	s = {}
	s.version = "1.0"
	s.msgPort = msgPort
	s.userVariables = userVariables
	s.bsp = bsp
    s.SystemLog = CreateObject("roSystemLog")
    s.objectName = "keyboard_plugin"
	s.ProcessEvent = inject_ProcessEvent
    s.htmlWidget = invalid
	
	return s
End Function


Function inject_ProcessEvent(event As Object) as boolean
    retval = false

	if type(event) = "roAssociativeArray" then
	else if type(event) = "roHtmlWidgetEvent" then

		eventData = event.GetData()
		if type(eventData) = "roAssociativeArray" and type(eventData.reason) = "roString" then

			if eventData.reason = "load-finished" then
				m.htmlWidget = FindHTMLWidget(m)
				if m.htmlWidget <> invalid then
					injectCode(m)
				end if
			end if		
		end if	
	end if

	return retval
End Function

Function FindHTMLWidget(m as object)

	if m.bsp = invalid or m.bsp.sign = invalid or m.bsp.sign.zonesHSM = invalid then
		return false
	end if

	for each baZone in m.bsp.sign.zonesHSM
		if type(baZone) = "roAssociativeArray" then
			'zoneHSM = m.bsp.GetZone(baZone.id$)
			if baZone.loadingHtmlWidget <> invalid then
                return baZone.loadingHtmlWidget
            end if

		end if
	end for
	return false
End Function



Sub injectCode(m as object)

	if type(m.htmlWidget) = "roHtmlWidget" then

		m.SystemLog.SendLine("------------------------------ injectCode")
		if type(m.htmlWidget) = "roHtmlWidget" then
			
			jsCode$ = ""
			jsCode$ = jsCode$ + "(function () {" + Chr(10)
			jsCode$ = jsCode$ + "    let isCaps = false;" + Chr(10)
			jsCode$ = jsCode$ + "    let activeInput = null;" + Chr(10)
			jsCode$ = jsCode$ + "" + Chr(10)
			jsCode$ = jsCode$ + "    const style = document.createElement('style');" + Chr(10)
			jsCode$ = jsCode$ + "    style.textContent = `" + Chr(10)
			jsCode$ = jsCode$ + "        .virtual-keyboard-container {" + Chr(10)
			jsCode$ = jsCode$ + "            position: fixed;" + Chr(10)
			jsCode$ = jsCode$ + "            bottom: -320px;" + Chr(10)
			jsCode$ = jsCode$ + "            left: 50%;" + Chr(10)
			jsCode$ = jsCode$ + "            transform: translateX(-50%);" + Chr(10)
			jsCode$ = jsCode$ + "            width: 100%;" + Chr(10)
			jsCode$ = jsCode$ + "            max-width: 750px;" + Chr(10)
			jsCode$ = jsCode$ + "            background-color: #222;" + Chr(10)
			jsCode$ = jsCode$ + "            padding: 15px;" + Chr(10)
			jsCode$ = jsCode$ + "            border-radius: 12px 12px 0 0;" + Chr(10)
			jsCode$ = jsCode$ + "            box-shadow: 0 -5px 25px rgba(0,0,0,0.4);" + Chr(10)
			jsCode$ = jsCode$ + "            display: flex;" + Chr(10)
			jsCode$ = jsCode$ + "            flex-direction: column;" + Chr(10)
			jsCode$ = jsCode$ + "            gap: 6px;" + Chr(10)
			jsCode$ = jsCode$ + "            transition: bottom 0.3s cubic-bezier(0.25, 0.8, 0.25, 1);" + Chr(10)
			jsCode$ = jsCode$ + "            z-index: 999999;" + Chr(10)
			jsCode$ = jsCode$ + "            box-sizing: border-box;" + Chr(10)
			jsCode$ = jsCode$ + "        }" + Chr(10)
			jsCode$ = jsCode$ + "        .virtual-keyboard-container.open {" + Chr(10)
			jsCode$ = jsCode$ + "            bottom: 0;" + Chr(10)
			jsCode$ = jsCode$ + "        }" + Chr(10)
			jsCode$ = jsCode$ + "        .vk-row {" + Chr(10)
			jsCode$ = jsCode$ + "            display: flex;" + Chr(10)
			jsCode$ = jsCode$ + "            justify-content: center;" + Chr(10)
			jsCode$ = jsCode$ + "            width: 100%;" + Chr(10)
			jsCode$ = jsCode$ + "            gap: 6px;" + Chr(10)
			jsCode$ = jsCode$ + "        }" + Chr(10)
			jsCode$ = jsCode$ + "        .vk-key {" + Chr(10)
			jsCode$ = jsCode$ + "            height: 46px;" + Chr(10)
			jsCode$ = jsCode$ + "            flex: 1;" + Chr(10)
			jsCode$ = jsCode$ + "            background-color: #fff;" + Chr(10)
			jsCode$ = jsCode$ + "            color: #333;" + Chr(10)
			jsCode$ = jsCode$ + "            border: none;" + Chr(10)
			jsCode$ = jsCode$ + "            border-radius: 6px;" + Chr(10)
			jsCode$ = jsCode$ + "            font-size: 16px;" + Chr(10)
			jsCode$ = jsCode$ + "            font-weight: 600;" + Chr(10)
			jsCode$ = jsCode$ + "            cursor: pointer;" + Chr(10)
			jsCode$ = jsCode$ + "            user-select: none;" + Chr(10)
			jsCode$ = jsCode$ + "            display: flex;" + Chr(10)
			jsCode$ = jsCode$ + "            align-items: center;" + Chr(10)
			jsCode$ = jsCode$ + "            justify-content: center;" + Chr(10)
			jsCode$ = jsCode$ + "            box-shadow: 0 2px 0 #bbb;" + Chr(10)
			jsCode$ = jsCode$ + "            transition: background 0.05s, transform 0.05s;" + Chr(10)
			jsCode$ = jsCode$ + "            box-sizing: border-box;" + Chr(10)
			jsCode$ = jsCode$ + "        }" + Chr(10)
			jsCode$ = jsCode$ + "        .vk-key:active {" + Chr(10)
			jsCode$ = jsCode$ + "            background-color: #e0e0e0;" + Chr(10)
			jsCode$ = jsCode$ + "            transform: translateY(1px);" + Chr(10)
			jsCode$ = jsCode$ + "            box-shadow: 0 1px 0 #bbb;" + Chr(10)
			jsCode$ = jsCode$ + "        }" + Chr(10)
			jsCode$ = jsCode$ + "        .vk-key-wide { flex: 1.6; background-color: #d1d5db; }" + Chr(10)
			jsCode$ = jsCode$ + "        .vk-key-space { flex: 5; }" + Chr(10)
			jsCode$ = jsCode$ + "        .vk-key-active { background-color: #10b981 !important; color: white; box-shadow: 0 2px 0 #047857; }" + Chr(10)
			jsCode$ = jsCode$ + "    `;" + Chr(10)
			jsCode$ = jsCode$ + "    document.head.appendChild(style);" + Chr(10)
			jsCode$ = jsCode$ + "" + Chr(10)
			jsCode$ = jsCode$ + "    const keyLayout = [" + Chr(10)
			jsCode$ = jsCode$ + "        ['1', '2', '3', '4', '5', '6', '7', '8', '9', '0', 'Backspace']," + Chr(10)
			jsCode$ = jsCode$ + "        ['q', 'w', 'e', 'r', 't', 'y', 'u', 'i', 'o', 'p']," + Chr(10)
			jsCode$ = jsCode$ + "        ['Caps', 'a', 's', 'd', 'f', 'g', 'h', 'j', 'k', 'l']," + Chr(10)
			jsCode$ = jsCode$ + "        ['z', 'x', 'c', 'v', 'b', 'n', 'm', ',', '.', '?',]," + Chr(10)
			jsCode$ = jsCode$ + "        ['Space', 'Close']" + Chr(10)
			jsCode$ = jsCode$ + "    ];" + Chr(10)
			jsCode$ = jsCode$ + "" + Chr(10)
			jsCode$ = jsCode$ + "    const keyboardWrapper = document.createElement('div');" + Chr(10)
			jsCode$ = jsCode$ + "    keyboardWrapper.classList.add('virtual-keyboard-container');" + Chr(10)
			jsCode$ = jsCode$ + "    document.body.appendChild(keyboardWrapper);" + Chr(10)
			jsCode$ = jsCode$ + "" + Chr(10)
			jsCode$ = jsCode$ + "    function renderKeyboard() {" + Chr(10)
			jsCode$ = jsCode$ + "        keyboardWrapper.innerHTML = '';" + Chr(10)
			jsCode$ = jsCode$ + "" + Chr(10)
			jsCode$ = jsCode$ + "        keyLayout.forEach(rowKeys => {" + Chr(10)
			jsCode$ = jsCode$ + "            const rowElement = document.createElement('div');" + Chr(10)
			jsCode$ = jsCode$ + "            rowElement.classList.add('vk-row');" + Chr(10)
			jsCode$ = jsCode$ + "" + Chr(10)
			jsCode$ = jsCode$ + "            rowKeys.forEach(key => {" + Chr(10)
			jsCode$ = jsCode$ + "                const button = document.createElement('button');" + Chr(10)
			jsCode$ = jsCode$ + "                button.classList.add('vk-key');" + Chr(10)
			jsCode$ = jsCode$ + "                button.type = 'button';" + Chr(10)
			jsCode$ = jsCode$ + "                " + Chr(10)
			jsCode$ = jsCode$ + "                const isLetter = key.length === 1 && /[a-z]/i.test(key);" + Chr(10)
			jsCode$ = jsCode$ + "                button.textContent = (isLetter && isCaps) ? key.toUpperCase() : key;" + Chr(10)
			jsCode$ = jsCode$ + "" + Chr(10)
			jsCode$ = jsCode$ + "                if (key === 'Backspace' || key === 'Caps' || key === 'Close') {" + Chr(10)
			jsCode$ = jsCode$ + "                    button.classList.add('vk-key-wide');" + Chr(10)
			jsCode$ = jsCode$ + "                    button.setAttribute('data-action', key.toLowerCase());" + Chr(10)
			jsCode$ = jsCode$ + "                } else if (key === 'Space') {" + Chr(10)
			jsCode$ = jsCode$ + "                    button.classList.add('vk-key-space');" + Chr(10)
			jsCode$ = jsCode$ + "                    button.setAttribute('data-action', 'space');" + Chr(10)
			jsCode$ = jsCode$ + "                } else {" + Chr(10)
			jsCode$ = jsCode$ + "                    button.setAttribute('data-value', button.textContent);" + Chr(10)
			jsCode$ = jsCode$ + "                }" + Chr(10)
			jsCode$ = jsCode$ + "" + Chr(10)
			jsCode$ = jsCode$ + "                if (key === 'Caps' && isCaps) {" + Chr(10)
			jsCode$ = jsCode$ + "                    button.classList.add('vk-key-active');" + Chr(10)
			jsCode$ = jsCode$ + "                }" + Chr(10)
			jsCode$ = jsCode$ + "" + Chr(10)
			jsCode$ = jsCode$ + "                rowElement.appendChild(button);" + Chr(10)
			jsCode$ = jsCode$ + "            });" + Chr(10)
			jsCode$ = jsCode$ + "" + Chr(10)
			jsCode$ = jsCode$ + "            keyboardWrapper.appendChild(rowElement);" + Chr(10)
			jsCode$ = jsCode$ + "        });" + Chr(10)
			jsCode$ = jsCode$ + "    }" + Chr(10)
			jsCode$ = jsCode$ + "" + Chr(10)
			jsCode$ = jsCode$ + "    keyboardWrapper.addEventListener('mousedown', (e) => {" + Chr(10)
			jsCode$ = jsCode$ + "        e.preventDefault(); " + Chr(10)
			jsCode$ = jsCode$ + "        " + Chr(10)
			jsCode$ = jsCode$ + "        if (!e.target.classList.contains('vk-key')) return;" + Chr(10)
			jsCode$ = jsCode$ + "        if (!activeInput) return;" + Chr(10)
			jsCode$ = jsCode$ + "" + Chr(10)
			jsCode$ = jsCode$ + "        const button = e.target;" + Chr(10)
			jsCode$ = jsCode$ + "        const action = button.getAttribute('data-action');" + Chr(10)
			jsCode$ = jsCode$ + "        const value = button.getAttribute('data-value');" + Chr(10)
			jsCode$ = jsCode$ + "" + Chr(10)
			jsCode$ = jsCode$ + "        if (action) {" + Chr(10)
			jsCode$ = jsCode$ + "            switch (action) {" + Chr(10)
			jsCode$ = jsCode$ + "                case 'backspace':" + Chr(10)
			jsCode$ = jsCode$ + "                    activeInput.value = activeInput.value.slice(0, -1);" + Chr(10)
			jsCode$ = jsCode$ + "                    break;" + Chr(10)
			jsCode$ = jsCode$ + "                case 'caps':" + Chr(10)
			jsCode$ = jsCode$ + "                    isCaps = !isCaps;" + Chr(10)
			jsCode$ = jsCode$ + "                    renderKeyboard();" + Chr(10)
			jsCode$ = jsCode$ + "                    break;" + Chr(10)
			jsCode$ = jsCode$ + "                case 'space':" + Chr(10)
			jsCode$ = jsCode$ + "                    activeInput.value += ' ';" + Chr(10)
			jsCode$ = jsCode$ + "                    break;" + Chr(10)
			jsCode$ = jsCode$ + "                case 'close':" + Chr(10)
			jsCode$ = jsCode$ + "                    keyboardWrapper.classList.remove('open');" + Chr(10)
			jsCode$ = jsCode$ + "                    activeInput.blur();" + Chr(10)
			jsCode$ = jsCode$ + "                    break;" + Chr(10)
			jsCode$ = jsCode$ + "            }" + Chr(10)
			jsCode$ = jsCode$ + "        } else if (value) {" + Chr(10)
			jsCode$ = jsCode$ + "            activeInput.value += value;" + Chr(10)
			jsCode$ = jsCode$ + "        }" + Chr(10)
			jsCode$ = jsCode$ + "" + Chr(10)
			jsCode$ = jsCode$ + "        activeInput.dispatchEvent(new Event('input', { bubbles: true }));" + Chr(10)
			jsCode$ = jsCode$ + "    });" + Chr(10)
			jsCode$ = jsCode$ + "" + Chr(10)
			jsCode$ = jsCode$ + "    document.addEventListener('focusin', (e) => {" + Chr(10)
			jsCode$ = jsCode$ + "        if (e.target.tagName === 'INPUT' && e.target.type === 'text') {" + Chr(10)
			jsCode$ = jsCode$ + "            activeInput = e.target;" + Chr(10)
			jsCode$ = jsCode$ + "            renderKeyboard();" + Chr(10)
			jsCode$ = jsCode$ + "            keyboardWrapper.classList.add('open');" + Chr(10)
			jsCode$ = jsCode$ + "        }" + Chr(10)
			jsCode$ = jsCode$ + "    });" + Chr(10)
			jsCode$ = jsCode$ + "" + Chr(10)
			jsCode$ = jsCode$ + "    document.addEventListener('click', (e) => {" + Chr(10)
			jsCode$ = jsCode$ + "        if (activeInput && !activeInput.contains(e.target) && !keyboardWrapper.contains(e.target)) {" + Chr(10)
			jsCode$ = jsCode$ + "            keyboardWrapper.classList.remove('open');" + Chr(10)
			jsCode$ = jsCode$ + "            activeInput = null;" + Chr(10)
			jsCode$ = jsCode$ + "        }" + Chr(10)
			jsCode$ = jsCode$ + "    });" + Chr(10)
			jsCode$ = jsCode$ + "})();" + Chr(10)

			
			m.htmlWidget.InjectJavascript(jsCode$)
		end if
	end if
End Sub

