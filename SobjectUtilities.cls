public inherited sharing class SobjectUtilities {
    // clone fields from input to output SObject
    public static SObject cloneFields(SObject input, SObject output) {
        Map<String, Schema.SObjectField> inputFieldMap = input.getSobjectType()
            .getDescribe()
            .fields.getMap();
        Map<String, Schema.SObjectField> outputFieldMap = output.getSobjectType()
            .getDescribe()
            .fields.getMap();
        Boolean hasId = false;
        if (outputFieldMap.containsKey('id') && outputFieldMap.get('id') != null) {
            hasId = true;
        }
        for (String inputField : inputFieldMap.keySet()) {
            Schema.DescribeFieldResult inputFieldDescribe = inputFieldMap.get(inputField)
                .getDescribe();
            if (outputFieldmap.containsKey(inputField)) {
                Schema.DescribeFieldResult outputFieldDescribe = outputFieldMap.get(inputField)
                    .getDescribe();
                if (
                    (hasId && outputFieldDescribe.isUpdateable() ||
                    !hasId && outputFieldDescribe.isCreateable()) &&
                    outputFieldDescribe.isAutoNumber() == false &&
                    outputFieldDescribe.isCalculated() == false &&
                    input.get(inputField) != null
                ) {
                    output.put(inputField, input.get(inputField));
                }
            }
        }
        return output;
    }
}
