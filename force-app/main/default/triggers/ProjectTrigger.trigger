trigger ProjectTrigger on agf__PPM_Project__c(
  after delete,
  after insert,
  after update,
  before delete,
  before insert,
  before update
) {
  fflib_SObjectDomain.triggerHandler(Projects.class);
}
