const { handler } = require('./index');

async function runTest() {
    const testEvent = {
        path: '/greet',
        httpMethod: 'GET',
        requestContext: {
            identity: {
                sourceIp: '127.0.0.1',
                userAgent: 'test-agent'
            }
        }
    };

    try {
        const response = await handler(testEvent);
        console.log('Test Response:', JSON.stringify(response, null, 2));
    } catch (error) {
        console.error('Test Error:', error);
    }
}

runTest();