exports.handler = async (event) => {
    const timestamp = new Date().getTime();
    const id = `request_${timestamp}`;
    
    // Log request details to DynamoDB
    const logEntry = {
        id: id,
        timestamp: timestamp,
        path: event.path || '',
        method: event.httpMethod || '',
        clientIp: event.requestContext?.identity?.sourceIp || '',
        userAgent: event.requestContext?.identity?.userAgent || ''
    };
    
    // Prepare response
    const response = {
        statusCode: 200,
        headers: {
            'Content-Type': 'application/json',
            'Access-Control-Allow-Origin': '*',
            'Access-Control-Allow-Methods': 'GET, POST, OPTIONS',
            'Access-Control-Allow-Headers': 'Content-Type,X-Amz-Date,Authorization,X-Api-Key,X-Amz-Security-Token'
        },
        body: JSON.stringify({
            message: 'Hello from AWS Lambda!',
            timestamp: timestamp,
            requestId: id,
            logEntry: logEntry
        })
    };
    
    return response;
};