@isTest
public class TwilioApiMocks {
	public class apiSuccessMock implements HttpCalloutMock {
    
        public HTTPResponse respond(HTTPRequest request) {
        
            HttpResponse response = new HttpResponse();
            response.setHeader('Content-Type', 'application/json');
            response.setHeader('Accept', 'application/json');
            response.setStatusCode(201);

            response.setBody('{' +
                             '     "id": "sffnsdfsdfsdfsdf"' +
                            '} '
            );
    
            return response;
        }
    }
    
    public class apiErrorMock implements HttpCalloutMock {
    
        public HTTPResponse respond(HTTPRequest request) {
            HttpResponse response = new HttpResponse();
            response.setHeader('Content-Type', 'application/json');
            response.setHeader('Accept', 'application/json');
            response.setStatusCode(401);

            return response;
        }
    }
}