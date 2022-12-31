caoCheat = '!';

//修改react输入框的值
_cao = (inputDom, value) => {
    const lastValue = inputDom.value;
    inputDom.value = value;
    const event = new Event('input', {bubbles: true});
    event.simulated = true;
    const tracker = inputDom._valueTracker;
    if (tracker) {
        tracker.setValue(lastValue);
    }
    inputDom.dispatchEvent(event);
}

function isLoginPage() {
    return document.querySelector('input[autocomplete="username"]') !== undefined &&
        document.querySelector('input[autocomplete="current-password"]') !== undefined;
}

function removePasswordMask() {
    const passwordInput = document.querySelector('input[type="password"]');
    if (passwordInput) {
        passwordInput.type = 'text';
    }
}


function changeLoginData(account, password) {
    _cao(document.querySelector('input[autocomplete="username"]'), account);
    _cao(document.querySelector('input[autocomplete="current-password"]'), password);
}

function getLoginData() {
    return {
        'account': document.querySelector('input[autocomplete="username"]').value,
        'password': document.querySelector('input[autocomplete="current-password"]').value
    };
}

