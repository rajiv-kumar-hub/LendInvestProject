@isTest
public class TwilioSMSProcessing_Test {
    
    @testSetup 
    static void setup() {
    	Account acc = new Account(name = 'Test Account');
        Database.insert(acc);
    }
    
    static testmethod void testSuccessSMSApiCall(){
        
        Test.setMock(HttpCalloutMock.class, new TwilioApiMocks.apiSuccessMock());
        
        Test.StartTest();        
        	TwilioSMSProcessing.callSmsApi('ABC');
        Test.StopTest();

    }
    
    static testmethod void testSuccessSMSApiLwcCall(){
        
        Test.setMock(HttpCalloutMock.class, new TwilioApiMocks.apiSuccessMock());
        
        Test.StartTest();        
        	TwilioSMSProcessing.sendSmsUsingLwcComponent('+44752', 'Test SMS Message');
        Test.StopTest();

    }
    
    static testmethod void testErrorSMSApiLwcCall(){
        Boolean exceptionthrown = false;
        
        Test.setMock(HttpCalloutMock.class, new TwilioApiMocks.apiErrorMock());
        
        Test.StartTest();        
        try{
        	TwilioSMSProcessing.sendSmsUsingLwcComponent('+44752', 'Test SMS Message');    
        }catch (Exception ex) {
            exceptionthrown = true;
        }	
        
        Test.StopTest();
		System.assertEquals(true, exceptionthrown);
    }
    
    static testmethod void testFlowSMSMethod(){
        Account acc = [SELECT Id FROM Account WHERE name = 'Test Account'];
        List<String> inputData = new List<String>();
        inputData.add(acc.Id);
        Test.setMock(HttpCalloutMock.class, new TwilioApiMocks.apiSuccessMock());
        
        Test.StartTest();        
        	TwilioSMSProcessing.sendSMSToGoldAccounts(inputData);
        Test.StopTest();

    }

}