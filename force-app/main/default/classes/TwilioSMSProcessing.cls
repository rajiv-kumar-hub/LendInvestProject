public class TwilioSMSProcessing {
    
    @InvocableMethod(label='Send SMS to Gold Accounts'
                     description='Send SMS using Twilio SMS Web Service to Gold Accounts'
                     category='Account')
    public static void sendSMSToGoldAccounts(List<String> accountIds){
        List<Account> accDetails = [SELECT Id, Name FROM Account WHERE Id = :accountIds];
        for(Account acc :accDetails){
            callSmsApi(acc.name);
        }
    }
    
    @future(callout = true) @TestVisible
    private static void callSmsApi(String accountName){
    	TwilioApiService apiService = new TwilioApiService();
		apiService.postApiRequest(accountName, null, null);        
    }
    
    @AuraEnabled
    public static void sendSmsUsingLwcComponent(String goldCustomerContactNo, String smsMessage ){
        system.debug('Input data : '+ goldCustomerContactNo + '--' + smsMessage);
    	TwilioApiService apiService = new TwilioApiService();
		apiService.postApiRequest(null, goldCustomerContactNo, smsMessage);        
    }
}