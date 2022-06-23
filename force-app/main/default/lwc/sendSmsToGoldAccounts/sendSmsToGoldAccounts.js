import { LightningElement } from 'lwc';
import sendSMSToGoldCustomers from '@salesforce/apex/TwilioSMSProcessing.sendSmsUsingLwcComponent';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';

export default class SendSmsToGoldAccounts extends LightningElement {

    goldCustomerContactNo;
    smsMessage;
    allFieldsValidated = true;

    handleFieldChange(event){
        const {name, value} = event.target;
        if(name == 'SmsMessage'){
            this.smsMessage = value;  
        }
        
        if(name == 'CustomerContactNo'){
            this.goldCustomerContactNo = value;  
        }
    }

    validateForm(event) {
        this.allFieldsValidated = true;
        var inputs = this.template.querySelectorAll('.form-control');
        inputs.forEach( input => {
            if(!input.checkValidity()){
                input.reportValidity();
                this.allFieldsValidated = false;
            }
        });

    }

    handleSubmit(event){
        event.preventDefault();
        this.validateForm(event);
        this.showSpinner();
        if(this.allFieldsValidated){
            sendSMSToGoldCustomers({goldCustomerContactNo : this.goldCustomerContactNo, smsMessage : this.smsMessage})
            .then(result => {
                this.ShowToast('SMS Sent.', `SMS has been sent to the customer.`);
                this.showSpinner();
                this.handleResetAll();
            })
            .catch((error) => {
                this.handleResetAll();
                this.ShowToast('Error!!', `There has been an error in sending the SMS. Please try again later`, 'error');
                this.showSpinner();
            })
        
        }
    }

    handleResetAll(){
        this.template.querySelectorAll('.form-control').forEach(element => {
              element.value = null;
          });
    }

    showSpinner(){
        this.isSendingSMS = !this.isSendingSMS;
    }

    ShowToast(title, message, variant){
        this.dispatchEvent(new ShowToastEvent({title, message, variant:variant || 'success', mode:'dismissible'}));
    }
}