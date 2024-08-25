let logFetch = window.fetch

function onfetch(callback, mockDataCallback) {
    window.fetch = function (input, init) {
        return new Promise((resolve, reject) => {
            logFetch(input, init)
                .then(response => {
                    callback(response.clone());
                    resolve(response);
                })
                .catch(error => {
                    // 当fetch请求失败时，触发mockDataCallback生成并返回模拟数据
                    if (mockDataCallback) {
                        try {
                            const mockResponse = new Response(JSON.stringify(mockDataCallback()), {
                                status: 200,
                                statusText: 'OK',
                                headers: {'Content-Type': 'application/json'}
                            });
                            resolve(mockResponse);
                        } catch (mockError) {
                            reject(mockError);
                        }
                    } else {
                        reject(error); // 如果没有提供mockDataCallback，直接抛出错误
                    }
                });
        });
    };
}

// 定义模拟数据生成函数
function generateMockData() {
    return {}
}

onfetch(response => {
    response.text().then(data => console.log('真实或模拟数据:', data));
}, generateMockData);