global with sharing class OpenCTI_API_IntegrationService {
    
    private static final String ACCOUNT_NOT_FOUND_MESSAGE = 'The account is not found';
    private static final String ACCOUNT_NOT_FOUND_DISPLAY_MESSAGE = '{1} {0} could not be found in Salesforce';
    
    public static Map<String, String> externalReferences = new Map<String, String>{
        'Account_Number' => 'AccountNumber','Account_Name' => 'Name'};
        
    // This exception is thrown when the external reference provided is unknown
    private class UnknownExternalReferenceTypeException extends Exception {}
    
    public static String searchCustomer(String externalId, String externalReferenceType) {
        try{
            String fieldName = externalReferences.get(externalReferenceType);
            if (fieldName != null && externalId != null) {
                
                String soql = 'SELECT ID FROM ACCOUNT';
                //filter for field AccountNumber
                if(fieldName=='AccountNumber'){
                    soql+=' WHERE AccountNumber = :externalId';
                }
                if(fieldName=='Name'){
                    string tempInput = '%' + externalId + '%';
                    soql+=' WHERE Name like:tempInput';
                }
                soql+=' Limit 1';
                
                List<Account> accounts = Database.query(soql);
                
                if (accounts.size() == 1) {
                    //send success response to Softphone page)
                    return JSON.serialize(new Map<String,Object>{'success' => true,'result' => accounts[0].Id});
                }
                else {
                    //send error response to Softphone page)
                    return JSON.serialize(new Map<String,Object>{
                        'success' => false,'error' => ACCOUNT_NOT_FOUND_MESSAGE,'displayError' => String.format(ACCOUNT_NOT_FOUND_DISPLAY_MESSAGE,new String[]{externalId,externalReferences.get(externalReferenceType)})});
                } 
            }else {
                throw new UnknownExternalReferenceTypeException('UNKOWN_EXTERNAL_REFERENCE_MESSAGE');
            }  
        }Catch(exception e){
            throw e;
        }
    }
    
}