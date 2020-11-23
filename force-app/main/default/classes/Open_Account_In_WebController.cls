/**
 * @author Abhinav Sharma
 * @description Class is used for the Lightning Web Component ingOpenClientInIRIS
 */
public with sharing class Open_Account_In_WebController {
    /**
     * @param recordId : Salesforce Record Id of the Parent
     * @returns accountDetail : Wrapper instance
     */
    @AuraEnabled(cacheable=true)
    public static accountDetail getAccountDetail(Id recordId) {

        String sObjectType = String.valueOf(recordId.getsobjecttype());

        If('Opportunity'.equalsIgnoreCase(sObjectType)){
            if(Opportunity.SObjectType.getDescribe().isAccessible() && Schema.SObjectType.Opportunity.fields.AccountId.isAccessible()) {
                Opportunity oppRecord = [SELECT Account.AccountNumber,Account.Name
                                            FROM Opportunity
                                            WHERE id=:recordId AND AccountId!=null Limit 1];
                if(oppRecord != null){
                    return fillAccountDetailWrapper(oppRecord.Account,'SALESFORCE_OPPORTUNITY');
                }
            }
        }
        return null;
    }
    /**
     * @param accountInstance : Instance of Account sObject
     * @param sObjectType : Type of Object
     * @returns accountDetail : Wrapper instance
     */
    public static accountDetail fillAccountDetailWrapper(Account accountInstance, String sObjectType){
        AccountDetail accDetail = new AccountDetail();
        String fieldReference ='';
        if(!String.isBlank(accountInstance.AccountNumber)){
            fieldReference='Account_Number'; 
            accDetail.accountNumber = accountInstance.AccountNumber;
        }else{
            fieldReference='Account_Name';  
            accDetail.accountName = accountInstance.Name;
        }
        accDetail.sfFieldReference = fieldReference;
        accDetail.sObjectType = sObjectType;
        return accDetail;
    }

    /**
     *@description Wrapper Class: To capture AccountNumber, Name and External_Id__c
     */
    public class AccountDetail{
        @AuraEnabled public String accountNumber{get;set;}
        @AuraEnabled public String accountName{get;set;}
        @AuraEnabled public String sfFieldReference{get;set;}
        @AuraEnabled public String sObjectType{get;set;}
    }
}