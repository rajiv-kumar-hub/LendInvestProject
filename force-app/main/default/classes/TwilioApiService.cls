public class TwilioApiService {
    
    public static String ENDPOINT_DETAILS = 'callout:Twilio_API';
    Twilio_Configuration__mdt twilioConfigDetails;
    
    public TwilioApiService(){
        twilioConfigDetails = Twilio_Configuration__mdt.getInstance('Twilio_Configuration');
    }  
    
    public void postApiRequest(String accountName, String goldCustomerContactNo, String smsMessage) {
        Http http = new Http();
        HttpRequest httpReq = new HttpRequest();
        String endPointWithAttribute = '/'+twilioConfigDetails.Account_SID__c+'/SMS/Messages.json';
        httpReq.setMethod('POST');
        httpReq.setEndpoint(ENDPOINT_DETAILS + endPointWithAttribute);
        httpReq.setHeader('X-Twilio-Client', 'salesforce-' + twilioConfigDetails.Twilio_Version__c);        
        httpReq.setHeader('User-Agent', 'twilio-salesforce/' + twilioConfigDetails.Twilio_Version__c);       
        httpReq.setHeader('Accept', 'application/json');        
        httpReq.setHeader('Accept-Charset', 'utf-8');        
        httpReq.setHeader('Authorization', 'Basic '+getAuthorizationDetails());
        if(String.isNotBlank(smsMessage)){
        	httpReq.setBody(getSmsBodyContent(goldCustomerContactNo, smsMessage));    
        }else{
        	httpReq.setBody(getSmsBodyContent(accountName));    
        }
        
        
        HttpResponse httpRes = http.send( httpReq );
        if (httpRes.getStatusCode() != 201) {
        	throw new CalloutException('Error in SMS processing'); 
            //additional processing can be done to either create a case in Salesforce or
            //throw the appropriate business message back on the screen 
        }
    }
    
    
    private String getAuthorizationDetails(){
        return EncodingUtil.base64Encode(Blob.valueOf(twilioConfigDetails.Account_SID__c+':' +twilioConfigDetails.Twilio_Token__c));
    }
    
    private String getSmsBodyContent(String accountName){
        String smsBody = String.format(twilioConfigDetails.SMS_Content__c, new List<String>{accountName});
        return 'To='+EncodingUtil.urlEncode(twilioConfigDetails.Send_SMS_Notification_For_Gold_Customer__c,'UTF-8')+'&From='+EncodingUtil.urlEncode(twilioConfigDetails.Twilio_Contact_No__c,'UTF-8')+'&Body='+smsBody;
    }
    
    private String getSmsBodyContent(String goldCustomerContactNo, String smsMessage){
        return 'To='+EncodingUtil.urlEncode(goldCustomerContactNo,'UTF-8')+'&From='+EncodingUtil.urlEncode(twilioConfigDetails.Twilio_Contact_No__c,'UTF-8')+'&Body='+smsMessage;
    }

}