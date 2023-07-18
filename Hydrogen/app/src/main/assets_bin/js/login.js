let logFetch = window.fetch
function onfetch(callback) {
    window.fetch = function (input, init) {
        return new Promise((resolve, reject) => {
            logFetch(input, init)
                .then(function (response) {
                    callback(response.clone())
                    resolve(response)
                }, reject)
        })
    }
}

onfetch(response => {
    response.text()
        .then(res => {
            if (/access_token/.test(res)) {
                console.log("sign_data=" + res)
            }
        })
})