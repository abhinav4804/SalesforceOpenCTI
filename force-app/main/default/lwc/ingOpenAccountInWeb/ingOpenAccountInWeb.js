/* eslint-disable @lwc/lwc/no-async-operation */
import { LightningElement, api, wire } from 'lwc';
import { publish, MessageContext } from 'lightning/messageService';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';

import accountDetail from '@salesforce/apex/Open_Account_In_WebController.getAccountDetail';
import MESSAGE_CHANNEL from '@salesforce/messageChannel/ap_salesforce_web_interface__c';
import ACCOUNT_OPEN_MESSAGE_LABEL from '@salesforce/label/c.ING_AccountOpenMessage';
import ACCNUM_EXTID_EMPTY from '@salesforce/label/c.ACCNUM_EXTID_EMPTY';

export default class IngOpenClientInIRIS extends LightningElement {
  isLoaded = true;
  @api recordId;
  @wire(accountDetail, { recordId: '$recordId' }) accounts;
  @wire(MessageContext) messageContext;

  connectedCallback() {
    setTimeout(() => {
      let accIdentifier = 'Account Name';
      if(this.accounts.data.accountNumber !== undefined){
        accIdentifier = this.accounts.data.accountNumber;
      }else{
        accIdentifier = this.accounts.data.accountName;
      }

      const message = {
        sf_SObjectType: this.accounts.data.sObjectType,
        sf_FieldReference: this.accounts.data.sfFieldReference,
        sf_ACCOUNT_IDENTIFIER_ID: accIdentifier,
        sf_RecordId: this.recordId
      };
      console.log({message});
      if (accIdentifier === undefined) {
        const errorEvt = new ShowToastEvent({
          message: ACCNUM_EXTID_EMPTY,
          variant: 'error'
        });
        this.dispatchEvent(errorEvt);
      } else {
        publish(this.messageContext, MESSAGE_CHANNEL, message);
        const evt = new ShowToastEvent({
          message: ACCOUNT_OPEN_MESSAGE_LABEL,
          variant: 'success'
        });
        this.dispatchEvent(evt);
      }
      this.dispatchEvent(new CustomEvent('close'));
    }, 3000);
  }
}